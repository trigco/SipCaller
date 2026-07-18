#!/bin/bash
sed -i "s/id 'org.jetbrains.kotlin.android' version '2.2.10' apply false//g" build.gradle
sed -i "s/id 'org.jetbrains.kotlin.android'//g" app/build.gradle

# Remove kotlinOptions block
sed -i '/kotlinOptions {/,/    }/d' app/build.gradle

# Add kotlin compilerOptions at the end of android block or outside it.
cat << 'INNER_EOF' >> app/build.gradle

kotlin {
    jvmToolchain(17)
    compilerOptions {
        freeCompilerArgs.addAll([
            "-opt-in=androidx.compose.ui.platform.ExperimentalPlatformTextInputApi",
            "-opt-in=androidx.compose.ui.ExperimentalComposeUiApi"
        ])
    }
}
INNER_EOF

# ensure gradle.properties is clean
echo "org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=1g -XX:+UseG1GC -Dfile.encoding=UTF-8" > gradle.properties
echo "android.useAndroidX=true" >> gradle.properties

./gradlew clean assembleDebug --no-daemon
