#!/bin/fish

function gen-hypr
    for colour in $argv
        set -l split (string split ' ' $colour)
        echo "\$$split[1] = $split[2]"
    end
end

function gen-scss
    for colour in $argv
        set -l split (string split ' ' $colour)
        echo "\$$split[1]: #$split[2];"
    end
end

function gen-foot
    cp (dirname (status filename))/../data/foot.template $CONFIG/../foot/schemes/dynamic.ini
    for colour in $argv
        set -l split (string split ' ' $colour)
        sed -i "s/\$$split[1]/$split[2]/g" $CONFIG/../foot/schemes/dynamic.ini
    end
end

. (dirname (status filename))/../util.fish

set -l src (dirname (status filename))
set -l colours ($src/gen-scheme.fish $argv[1])

if test -d $CONFIG/hypr/scheme
    log 'Generating hypr scheme'
    gen-hypr $colours > $CONFIG/hypr/scheme/dynamic.conf
end

if test -d $CONFIG/shell/scss/scheme
    log 'Generating shell scheme'
    gen-scss $colours > $CONFIG/shell/scss/scheme/_dynamic.scss
end

if test -d $CONFIG/safeeyes/scheme
    log 'Generating SafeEyes scheme'
    gen-scss $colours > $CONFIG/safeeyes/scheme/_dynamic.scss
end

if test -d $CONFIG/../foot/schemes
    log 'Generating foot scheme'
    gen-foot $colours
end

# Reload programs if dynamic scheme
if test -f $CACHE/scheme/current.txt -a "$(cat $CACHE/scheme/current.txt)" = 'dynamic'
    caelestia scheme dynamic
end
