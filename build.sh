for file in ./skins/*; 
do 
	filename=$(basename -- "$file")
	dest="./output/$filename"
	mkdir -p ./output
	cp -f "./template.json" $dest

	keys=$(jq -r 'keys[]' $file)
	for key in $keys; do
		if [ $key != '$schema' ]
		then
			filter=".\"$key\""
			value=$(jq -r $filter $file)
			sed -i "s/{$key}/$value/g" $dest
		fi
	done

	result=$(jq '."$schema" += "vscode://schemas/color-theme"' $dest)
	echo "$result" > $dest
done