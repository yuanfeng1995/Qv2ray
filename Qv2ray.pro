#-------------------------------------------------
#
# Project created by QtCreator 2019-03-28T08:45:32
#
#-------------------------------------------------

QT += core gui widgets network charts

TARGET = qv2ray
TEMPLATE = app

# Don't merge those configs with below.
CONFIG += enable_decoder_qr_code enable_encoder_qr_code
include(3rdparty/qzxing_noTests/QZXing-components.pri)

# Main config
CONFIG += c++11 openssl-linked lrelease embed_translations

# Now read build number file.
_BUILD_NUMBER=$$cat(Build.Counter)
VERSION = 1.99.1.$$_BUILD_NUMBER
_BUILD_NUMBER = $$num_add($$_BUILD_NUMBER, 1)
write_file("Build.Counter", _BUILD_NUMBER)

DEFINES += QT_DEPRECATED_WARNINGS QV2RAY_VERSION_STRING=\"\\\"v$${VERSION}\\\"\"

SOURCES += \
        src/QvCoreConfigOperations.cpp \
        src/main.cpp \
        src/QvConfigUpgrade.cpp \
        src/QvCoreConfigOperations_Convertion.cpp \
        src/QvCoreConfigOperations_Generation.cpp \
        src/QvCoreInteractions.cpp \
        src/QvUtils.cpp \
        src/ui/NetSpeedBar/QvNetSpeedBar.cpp \
        src/ui/w_ExportConfig.cpp \
        src/ui/w_InboundEditor.cpp \
        src/ui/w_OutboundEditor.cpp \
        src/ui/w_RoutesEditor.cpp \
        src/ui/w_SubscriptionEditor.cpp \
        src/utils/QObjectMessageProxy.cpp \
        src/utils/QvHTTPRequestHelper.cpp \
        src/utils/QvPingModel.cpp \
        src/utils/QvRunguard.cpp \
        src/utils/QJsonModel.cpp \
        src/ui/w_JsonEditor.cpp \
        src/ui/w_MainWindow.cpp \
        src/ui/w_ImportConfig.cpp \
        src/ui/w_PrefrencesWindow.cpp \
        libs/gen/v2ray_api_commands.pb.cc \
        libs/gen/v2ray_api_commands.grpc.pb.cc

INCLUDEPATH += \
        3rdparty/ \
        src/ \
        src/ui/ \
        src/utils/ \
        libs/gen/

HEADERS += \
        src/Qv2rayBase.hpp \
        src/QvCoreConfigObjects.hpp \
        src/QvCoreConfigOperations.hpp \
        src/QvCoreInteractions.hpp \
        src/QvUtils.hpp \
        src/ui/w_ExportConfig.hpp \
        src/ui/w_ImportConfig.hpp \
        src/ui/w_InboundEditor.hpp \
        src/ui/w_JsonEditor.hpp \
        src/ui/w_MainWindow.hpp \
        src/ui/w_OutboundEditor.hpp \
        src/ui/w_PrefrencesWindow.hpp \
        src/ui/w_RoutesEditor.hpp \
        src/ui/w_SubscriptionEditor.hpp \
        src/utils/QJsonModel.hpp \
        src/utils/QJsonObjectInsertMacros.h \
        src/utils/QObjectMessageProxy.hpp \
        src/utils/QvHTTPRequestHelper.hpp \
        src/utils/QvNetSpeedPlugin.hpp \
        src/utils/QvPingModel.hpp \
        src/utils/QvRunguard.hpp \
        libs/gen/v2ray_api_commands.pb.h \
        libs/gen/v2ray_api_commands.grpc.pb.h \
        src/utils/QvTinyLog.hpp

FORMS += \
        src/ui/w_ExportConfig.ui \
        src/ui/w_ImportConfig.ui \
        src/ui/w_InboundEditor.ui \
        src/ui/w_JsonEditor.ui \
        src/ui/w_MainWindow.ui \
        src/ui/w_OutboundEditor.ui \
        src/ui/w_PrefrencesWindow.ui \
        src/ui/w_RoutesEditor.ui \
        src/ui/w_SubscriptionEditor.ui

RESOURCES += \
        resources.qrc

# Fine......
message(" ")
message("Qv2ray Version: $${VERSION}")
message("|-------------------------------------------------|")
message("| Qv2ray, A Cross Platform v2ray Qt GUI Client.   |")
message("| Licenced under GPLv3                            |")
message("|                                                 |")
message("| You may only use this program to the extent     |")
message("| permitted by local law.                         |")
message("|                                                 |")
message("| See: https://www.gnu.org/licenses/gpl-3.0.html  |")
message("|-------------------------------------------------|")
message(" ")
RC_ICONS += ./icons/Qv2ray.ico
ICON = ./icons/Qv2ray.icns

# ------------------------------------------ Begin checking gRPC and protobuf headers.
!exists(libs/gen/v2ray_api_commands.grpc.pb.h) || !exists(libs/gen/v2ray_api_commands.grpc.pb.cc) || !exists(libs/gen/v2ray_api_commands.pb.h) || !exists(libs/gen/v2ray_api_commands.pb.cc) {
    message(" ")
    message("-----------------------------------------------")
    message("Cannot continue: ")
    message("  --> Qv2ray is not properly configured yet: ")
    message("      gRPC and protobuf headers for v2ray API is missing.")
    message("  --> Please run gen_grpc.sh gen_grpc.bat or deps_macOS.sh located in tools/")
    message("  --> Or consider reading https://github.com/lhy0403/Qv2ray/blob/master/BUILDING.md")
    message("-----------------------------------------------")
    message(" ")
    warning("IF YOU THINK IT'S A MISTAKE, PLEASE OPEN AN ISSUE")
    error("! ABORTING THE BUILD !")
    message(" ")
}

# ------------------------------------------ Begin to detect language files.
message("Looking for language support.")
QM_FILES_RESOURCE_PREFIX = "translations"
for(var, $$list($$files("translations/*.ts", true))) {
    LOCALE_FILENAME = $$basename(var)
    message("  --> Found:" $$LOCALE_FILENAME)
    !equals(LOCALE_FILENAME, "en-US.ts") {
        # ONLY USED IN LRELEASE CONTEXT
        # en-US is not EXTRA...
        EXTRA_TRANSLATIONS += translations/$$LOCALE_FILENAME
    }
}
message("Qv2ray will build with" $${replace(EXTRA_TRANSLATIONS, "translations/", "")})
TRANSLATIONS += translations/en-US.ts

message(" ")
QMAKE_CXXFLAGS += -Wno-missing-field-initializers -Wno-unused-parameter -Wno-unused-variable

win32 {
    message("Configuring for win32 environment")
    message("  --> Setting up target descriptions")
    QMAKE_TARGET_DESCRIPTION = "Qv2ray, a cross-platform v2ray GUI client."
    QMAKE_TARGET_PRODUCT = "Qv2ray"

    message("  --> Adding Taskbar Toolbox CPP files.")
    SOURCES += src/ui/NetSpeedBar/QvNetSpeedBar_win.cpp

    # A hack for protobuf header.
    message("  --> Applying a hack for protobuf header")
    DEFINES += _WIN32_WINNT=0x600

    message("  --> Linking against gRPC and protobuf library.")
    LIBS += -L$$PWD/libs/gRPC-win32/lib/ -llibgrpc++.dll -llibprotobuf.dll

    INCLUDEPATH += $$PWD/libs/gRPC-win32/include
    DEPENDPATH  += $$PWD/libs/gRPC-win32/include
    PRE_TARGETDEPS += $$PWD/libs/gRPC-win32/lib/libgrpc++.dll.a $$PWD/libs/gRPC-win32/lib/libprotobuf.dll.a
}

unix {
    # For Linux and macOS
    message("Configuring for unix-like (macOS and linux) environment")
    # For gRPC and protobuf in linux and macOS
    message("  --> Linking against gRPC and protobuf library.")
    LIBS += -L/usr/local/lib -lgrpc++ -lprotobuf

    # macOS homebrew include path
    message("  --> Adding local include folder to search path")
    INCLUDEPATH += /usr/local/include/

    message("  --> Adding Plasma Toolbox CPP files.")
    SOURCES += src/ui/NetSpeedBar/QvNetSpeedBar_linux.cpp

    message("  --> Generating desktop dependency.")
    desktop.files += ./icons/qv2ray.desktop
    desktop.path = /usr/share/applications/

    message("  --> Generating icons dependency.")
    icon.files += ./icons/qv2ray.png
    icon.path = /usr/share/icons/hicolor/256x256/apps/

    target.path = /usr/local/bin/
    INSTALLS += target desktop icon
}

message("Done configuring Qv2ray project. Build output will be at:" $$OUT_PWD)
message("Type `make` or `mingw32-make` to start building Qv2ray")
