Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EED681290
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237568AbjA3OWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237487AbjA3OWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:22:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52F53CE32
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:21:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87E5FB8117E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BA2C4339B;
        Mon, 30 Jan 2023 14:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088389;
        bh=7DpJ06onAH3BFSPE0sIoK9WIQtt4k/stsG06JqKlkw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVQnyXrZ5ZNeAYkMEPuJ2dg+cVHapzVMNAzne+pidxiOqfA9QcuvwqnCrH+oPR486
         iWuAddUTJT9OBVnwTD9F3vTRDwkmar14atzl7JCRE2Zkur+IofvwYYDhIUBXoFn89L
         wWqTryRyyaHiO9ZDGCJdSBWNw5AF1THzBm2otcak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chun-Tse Shao <ctshao@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.15 200/204] kbuild: Allow kernel installation packaging to override pkg-config
Date:   Mon, 30 Jan 2023 14:52:45 +0100
Message-Id: <20230130134325.352955399@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                     |    3 ++-
 scripts/Makefile             |    4 ++--
 scripts/dtc/Makefile         |    6 +++---
 scripts/kconfig/gconf-cfg.sh |   12 ++++++------
 scripts/kconfig/mconf-cfg.sh |   16 ++++++++--------
 scripts/kconfig/nconf-cfg.sh |   16 ++++++++--------
 scripts/kconfig/qconf-cfg.sh |   14 +++++++-------
 tools/objtool/Makefile       |    4 ++--
 8 files changed, 38 insertions(+), 37 deletions(-)

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
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -18,7 +18,7 @@ fdtoverlay-objs	:= $(libfdt) fdtoverlay.
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
@@ -46,7 +46,7 @@ echo >&2 "* Unable to find the ncurses p
 echo >&2 "* Install ncurses (ncurses-devel or libncurses-dev"
 echo >&2 "* depending on your distribution)."
 echo >&2 "*"
-echo >&2 "* You may also need to install pkg-config to find the"
+echo >&2 "* You may also need to install ${HOSTPKG_CONFIG} to find the"
 echo >&2 "* ncurses installed in a non-default location."
 echo >&2 "*"
 exit 1
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
@@ -44,7 +44,7 @@ echo >&2 "* Unable to find the ncurses p
 echo >&2 "* Install ncurses (ncurses-devel or libncurses-dev"
 echo >&2 "* depending on your distribution)."
 echo >&2 "*"
-echo >&2 "* You may also need to install pkg-config to find the"
+echo >&2 "* You may also need to install ${HOSTPKG_CONFIG} to find the"
 echo >&2 "* ncurses installed in a non-default location."
 echo >&2 "*"
 exit 1
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
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -19,8 +19,8 @@ LIBSUBCMD		= $(LIBSUBCMD_OUTPUT)libsubcm
 OBJTOOL    := $(OUTPUT)objtool
 OBJTOOL_IN := $(OBJTOOL)-in.o
 
-LIBELF_FLAGS := $(shell pkg-config libelf --cflags 2>/dev/null)
-LIBELF_LIBS  := $(shell pkg-config libelf --libs 2>/dev/null || echo -lelf)
+LIBELF_FLAGS := $(shell $(HOSTPKG_CONFIG) libelf --cflags 2>/dev/null)
+LIBELF_LIBS  := $(shell $(HOSTPKG_CONFIG) libelf --libs 2>/dev/null || echo -lelf)
 
 all: $(OBJTOOL)
 


