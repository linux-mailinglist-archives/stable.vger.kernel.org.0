Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B84668854
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 01:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjAMAW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 19:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbjAMAVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 19:21:54 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2327434D66
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:21:53 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id jl4so21841540plb.8
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TfJcUZXyImIlalHCP7gHEGqFgclvrxbKpH8EviHTtNc=;
        b=Gdcylhypb4ZgFv6TF33iaYhDAIjssegvYBN6imijT+fPSgjA+3lF+MsIrewR9UrAw+
         E9f02uRQAd9nDfAq78JWmHDd4PdnXb9sZIh7yiOXQ2bPRNCBl8atNbpaC3W6j3LpSmwP
         lmZV/FJn8A7kDKggNp2Q6qQWy5guRwu0x4zD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TfJcUZXyImIlalHCP7gHEGqFgclvrxbKpH8EviHTtNc=;
        b=gQcVG0vuUhsJ7R3+ZhZC12eNq5dWCUzG4wNP1ZqFXhM3aWj2/1iwHbE4fvgNzLRzGY
         7hSXNATzkcYETneMcq21Cbg/RtpGRT4WpHUWn9DdGOep9H89RqAQK76gkouzwUiv94oF
         WB3YzjSjT/zyNoSMl+BWZ7b600Z/iGjTaygzhVYCXDkd1YDtSJkfDOcNMBXceh02fTmE
         G1X8ZK+ySTXAD/H+xS6TIdp/TzCX0ZXIS7JoGdtIBZKK6azCuHDKexE0F5fDBKm16CEQ
         164LzJ9NZRDxS5ElydP30na6zqmIt4ledFYm/qftMdihxfL31W+im6syfHab3CwvTJyE
         5Rew==
X-Gm-Message-State: AFqh2kpATfng7nepTaPqNLXrnpbns08BAJtZOV5p1j4HyEGHNxcLm9XW
        a9BO+ChZ475Js4lh3KKrgLl6wVov1ewb14TR
X-Google-Smtp-Source: AMrXdXsxjWXGXOF+oXe55MkBTaRf7GSSpk1INFMcvXFFvKf36lFEs2xPaLxkqGeHQKq0qIqZlAbGbw==
X-Received: by 2002:a05:6a21:e384:b0:b0:25ba:1769 with SMTP id cc4-20020a056a21e38400b000b025ba1769mr104760110pzc.58.1673569312005;
        Thu, 12 Jan 2023 16:21:52 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id z30-20020aa7991e000000b005898fcb7c2bsm7791547pff.170.2023.01.12.16.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 16:21:51 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Chun-Tse Shao <ctshao@google.com>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15.y] kbuild: Allow kernel installation packaging to override pkg-config
Date:   Thu, 12 Jan 2023 16:21:49 -0800
Message-Id: <20230113002149.3984494-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chun-Tse Shao <ctshao@google.com>

commit d5ea4fece4508bf8e72b659cd22fa4840d8d61e5 upstream.

Add HOSTPKG_CONFIG to allow tooling that builds the kernel to override
what pkg-config and parameters are used.

Signed-off-by: Chun-Tse Shao <ctshao@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[swboyd@chromium.org: Drop certs/Makefile hunk that doesn't
apply because pkg-config isn't used there, add dtc/Makefile hunk to
fix dtb builds]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

I need this to properly compile 5.15.y stable kernels in the chromeos
build system. The scripts/dtc/Makefile hunk is manually added because it
has gone away upstream in commit ef8795f3f1ce ("dt-bindings: kbuild: Use
DTB files for validation").

 Makefile                     |  3 ++-
 scripts/Makefile             |  4 ++--
 scripts/dtc/Makefile         |  6 +++---
 scripts/kconfig/gconf-cfg.sh | 12 ++++++------
 scripts/kconfig/mconf-cfg.sh | 16 ++++++++--------
 scripts/kconfig/nconf-cfg.sh | 16 ++++++++--------
 scripts/kconfig/qconf-cfg.sh | 14 +++++++-------
 tools/objtool/Makefile       |  4 ++--
 8 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/Makefile b/Makefile
index 6a9589c7b1bc..39550f492610 100644
--- a/Makefile
+++ b/Makefile
@@ -430,6 +430,7 @@ else
 HOSTCC	= gcc
 HOSTCXX	= g++
 endif
+HOSTPKG_CONFIG	= pkg-config
 
 export KBUILD_USERCFLAGS := -Wall -Wmissing-prototypes -Wstrict-prototypes \
 			      -O2 -fomit-frame-pointer -std=gnu89
@@ -525,7 +526,7 @@ KBUILD_LDFLAGS_MODULE :=
 KBUILD_LDFLAGS :=
 CLANG_FLAGS :=
 
-export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC
+export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC HOSTPKG_CONFIG
 export CPP AR NM STRIP OBJCOPY OBJDUMP READELF PAHOLE RESOLVE_BTFIDS LEX YACC AWK INSTALLKERNEL
 export PERL PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
 export KGZIP KBZIP2 KLZOP LZMA LZ4 XZ ZSTD
diff --git a/scripts/Makefile b/scripts/Makefile
index 9adb6d247818..e2a239829556 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -3,8 +3,8 @@
 # scripts contains sources for various helper programs used throughout
 # the kernel for the build process.
 
-CRYPTO_LIBS = $(shell pkg-config --libs libcrypto 2> /dev/null || echo -lcrypto)
-CRYPTO_CFLAGS = $(shell pkg-config --cflags libcrypto 2> /dev/null)
+CRYPTO_LIBS = $(shell $(HOSTPKG_CONFIG) --libs libcrypto 2> /dev/null || echo -lcrypto)
+CRYPTO_CFLAGS = $(shell $(HOSTPKG_CONFIG) --cflags libcrypto 2> /dev/null)
 
 hostprogs-always-$(CONFIG_BUILD_BIN2C)			+= bin2c
 hostprogs-always-$(CONFIG_KALLSYMS)			+= kallsyms
diff --git a/scripts/dtc/Makefile b/scripts/dtc/Makefile
index 1cba78e1dce6..2d5f274d6efd 100644
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -18,7 +18,7 @@ fdtoverlay-objs	:= $(libfdt) fdtoverlay.o util.o
 # Source files need to get at the userspace version of libfdt_env.h to compile
 HOST_EXTRACFLAGS += -I $(srctree)/$(src)/libfdt
 
-ifeq ($(shell pkg-config --exists yaml-0.1 2>/dev/null && echo yes),)
+ifeq ($(shell $(HOSTPKG_CONFIG) --exists yaml-0.1 2>/dev/null && echo yes),)
 ifneq ($(CHECK_DT_BINDING)$(CHECK_DTBS),)
 $(error dtc needs libyaml for DT schema validation support. \
 	Install the necessary libyaml development package.)
@@ -27,9 +27,9 @@ HOST_EXTRACFLAGS += -DNO_YAML
 else
 dtc-objs	+= yamltree.o
 # To include <yaml.h> installed in a non-default path
-HOSTCFLAGS_yamltree.o := $(shell pkg-config --cflags yaml-0.1)
+HOSTCFLAGS_yamltree.o := $(shell $(HOSTPKG_CONFIG) --cflags yaml-0.1)
 # To link libyaml installed in a non-default path
-HOSTLDLIBS_dtc	:= $(shell pkg-config --libs yaml-0.1)
+HOSTLDLIBS_dtc	:= $(shell $(HOSTPKG_CONFIG) --libs yaml-0.1)
 endif
 
 # Generated files need one more search path to include headers in source tree
diff --git a/scripts/kconfig/gconf-cfg.sh b/scripts/kconfig/gconf-cfg.sh
index 480ecd8b9f41..cbd90c28c05f 100755
--- a/scripts/kconfig/gconf-cfg.sh
+++ b/scripts/kconfig/gconf-cfg.sh
@@ -3,14 +3,14 @@
 
 PKG="gtk+-2.0 gmodule-2.0 libglade-2.0"
 
-if [ -z "$(command -v pkg-config)" ]; then
+if [ -z "$(command -v ${HOSTPKG_CONFIG})" ]; then
 	echo >&2 "*"
-	echo >&2 "* 'make gconfig' requires 'pkg-config'. Please install it."
+	echo >&2 "* 'make gconfig' requires '${HOSTPKG_CONFIG}'. Please install it."
 	echo >&2 "*"
 	exit 1
 fi
 
-if ! pkg-config --exists $PKG; then
+if ! ${HOSTPKG_CONFIG} --exists $PKG; then
 	echo >&2 "*"
 	echo >&2 "* Unable to find the GTK+ installation. Please make sure that"
 	echo >&2 "* the GTK+ 2.0 development package is correctly installed."
@@ -19,12 +19,12 @@ if ! pkg-config --exists $PKG; then
 	exit 1
 fi
 
-if ! pkg-config --atleast-version=2.0.0 gtk+-2.0; then
+if ! ${HOSTPKG_CONFIG} --atleast-version=2.0.0 gtk+-2.0; then
 	echo >&2 "*"
 	echo >&2 "* GTK+ is present but version >= 2.0.0 is required."
 	echo >&2 "*"
 	exit 1
 fi
 
-echo cflags=\"$(pkg-config --cflags $PKG)\"
-echo libs=\"$(pkg-config --libs $PKG)\"
+echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG)\"
+echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
diff --git a/scripts/kconfig/mconf-cfg.sh b/scripts/kconfig/mconf-cfg.sh
index b520e407a8eb..025b565e0b7c 100755
--- a/scripts/kconfig/mconf-cfg.sh
+++ b/scripts/kconfig/mconf-cfg.sh
@@ -4,16 +4,16 @@
 PKG="ncursesw"
 PKG2="ncurses"
 
-if [ -n "$(command -v pkg-config)" ]; then
-	if pkg-config --exists $PKG; then
-		echo cflags=\"$(pkg-config --cflags $PKG)\"
-		echo libs=\"$(pkg-config --libs $PKG)\"
+if [ -n "$(command -v ${HOSTPKG_CONFIG})" ]; then
+	if ${HOSTPKG_CONFIG} --exists $PKG; then
+		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG)\"
+		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
 		exit 0
 	fi
 
-	if pkg-config --exists $PKG2; then
-		echo cflags=\"$(pkg-config --cflags $PKG2)\"
-		echo libs=\"$(pkg-config --libs $PKG2)\"
+	if ${HOSTPKG_CONFIG} --exists $PKG2; then
+		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG2)\"
+		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG2)\"
 		exit 0
 	fi
 fi
@@ -46,7 +46,7 @@ echo >&2 "* Unable to find the ncurses package."
 echo >&2 "* Install ncurses (ncurses-devel or libncurses-dev"
 echo >&2 "* depending on your distribution)."
 echo >&2 "*"
-echo >&2 "* You may also need to install pkg-config to find the"
+echo >&2 "* You may also need to install ${HOSTPKG_CONFIG} to find the"
 echo >&2 "* ncurses installed in a non-default location."
 echo >&2 "*"
 exit 1
diff --git a/scripts/kconfig/nconf-cfg.sh b/scripts/kconfig/nconf-cfg.sh
index c212255070c0..3a10bac2adb3 100755
--- a/scripts/kconfig/nconf-cfg.sh
+++ b/scripts/kconfig/nconf-cfg.sh
@@ -4,16 +4,16 @@
 PKG="ncursesw menuw panelw"
 PKG2="ncurses menu panel"
 
-if [ -n "$(command -v pkg-config)" ]; then
-	if pkg-config --exists $PKG; then
-		echo cflags=\"$(pkg-config --cflags $PKG)\"
-		echo libs=\"$(pkg-config --libs $PKG)\"
+if [ -n "$(command -v ${HOSTPKG_CONFIG})" ]; then
+	if ${HOSTPKG_CONFIG} --exists $PKG; then
+		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG)\"
+		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
 		exit 0
 	fi
 
-	if pkg-config --exists $PKG2; then
-		echo cflags=\"$(pkg-config --cflags $PKG2)\"
-		echo libs=\"$(pkg-config --libs $PKG2)\"
+	if ${HOSTPKG_CONFIG} --exists $PKG2; then
+		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG2)\"
+		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG2)\"
 		exit 0
 	fi
 fi
@@ -44,7 +44,7 @@ echo >&2 "* Unable to find the ncurses package."
 echo >&2 "* Install ncurses (ncurses-devel or libncurses-dev"
 echo >&2 "* depending on your distribution)."
 echo >&2 "*"
-echo >&2 "* You may also need to install pkg-config to find the"
+echo >&2 "* You may also need to install ${HOSTPKG_CONFIG} to find the"
 echo >&2 "* ncurses installed in a non-default location."
 echo >&2 "*"
 exit 1
diff --git a/scripts/kconfig/qconf-cfg.sh b/scripts/kconfig/qconf-cfg.sh
index fa564cd795b7..9b695e5cd9b3 100755
--- a/scripts/kconfig/qconf-cfg.sh
+++ b/scripts/kconfig/qconf-cfg.sh
@@ -3,22 +3,22 @@
 
 PKG="Qt5Core Qt5Gui Qt5Widgets"
 
-if [ -z "$(command -v pkg-config)" ]; then
+if [ -z "$(command -v ${HOSTPKG_CONFIG})" ]; then
 	echo >&2 "*"
-	echo >&2 "* 'make xconfig' requires 'pkg-config'. Please install it."
+	echo >&2 "* 'make xconfig' requires '${HOSTPKG_CONFIG}'. Please install it."
 	echo >&2 "*"
 	exit 1
 fi
 
-if pkg-config --exists $PKG; then
-	echo cflags=\"-std=c++11 -fPIC $(pkg-config --cflags $PKG)\"
-	echo libs=\"$(pkg-config --libs $PKG)\"
-	echo moc=\"$(pkg-config --variable=host_bins Qt5Core)/moc\"
+if ${HOSTPKG_CONFIG} --exists $PKG; then
+	echo cflags=\"-std=c++11 -fPIC $(${HOSTPKG_CONFIG} --cflags $PKG)\"
+	echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
+	echo moc=\"$(${HOSTPKG_CONFIG} --variable=host_bins Qt5Core)/moc\"
 	exit 0
 fi
 
 echo >&2 "*"
-echo >&2 "* Could not find Qt5 via pkg-config."
+echo >&2 "* Could not find Qt5 via ${HOSTPKG_CONFIG}."
 echo >&2 "* Please install Qt5 and make sure it's in PKG_CONFIG_PATH"
 echo >&2 "*"
 exit 1
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 92ce4fce7bc7..549acc5859e9 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -19,8 +19,8 @@ LIBSUBCMD		= $(LIBSUBCMD_OUTPUT)libsubcmd.a
 OBJTOOL    := $(OUTPUT)objtool
 OBJTOOL_IN := $(OBJTOOL)-in.o
 
-LIBELF_FLAGS := $(shell pkg-config libelf --cflags 2>/dev/null)
-LIBELF_LIBS  := $(shell pkg-config libelf --libs 2>/dev/null || echo -lelf)
+LIBELF_FLAGS := $(shell $(HOSTPKG_CONFIG) libelf --cflags 2>/dev/null)
+LIBELF_LIBS  := $(shell $(HOSTPKG_CONFIG) libelf --libs 2>/dev/null || echo -lelf)
 
 all: $(OBJTOOL)
 
-- 
https://chromeos.dev

