#!/bin/bash

# Check for the configuration file
if [ ! -f "word_replacements.txt" ]; then
    echo "Error: Configuration file 'word_replacements.txt' not found."
    exit 1
fi

# Initialize an array to store Java file paths
java_files=()

# Check if specific_java_files.txt is empty or doesn't exist
if [ ! -s "specific_java_files.txt" ] || [ ! -f "specific_java_files.txt" ]; then
	# If no specific file is specified, find all Java files in the current directory and subdirectories
    java_files=($(find . -type f -name "*.java"))
else
	# Read file paths line by line, skip empty lines, and add them to the array
	while read line || [ -n "$line" ]; do
		if [ -n "$line" ]; then
			line=${line%$'\r'}
			java_files+=("$line")
		fi
    done < "specific_java_files.txt"
fi

# Loop through each line in the configuration file
while read line || [ -n "$line" ]; do
    # Split the line into source and replacement words using a space as the delimiter
    source_word=$(echo "$line" | cut -d'|' -f1)
    replacement_word=$(echo "$line" | cut -d'|' -f2)

    for java_file in "${java_files[@]}"; do
        # Check if the file exists before making replacements
		echo "Checking if file exists: $java_file"
		if [ -f "$java_file" ]; then
		# File exists, continue with operations
			sed -i "s/$replacement_word/$source_word/g" "$java_file"
		else
			echo "File not found: $java_file"
		fi
    done
done < "word_replacements.txt"

echo "Reverse word replacements completed."