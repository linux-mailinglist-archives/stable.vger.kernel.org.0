Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165C547FFCD
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbhL0PlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239410AbhL0Pjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74157C061792;
        Mon, 27 Dec 2021 07:38:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E4DD9CE10DE;
        Mon, 27 Dec 2021 15:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED0FC36AEA;
        Mon, 27 Dec 2021 15:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619497;
        bh=nClmFJYvqCZPSKRgh2NSetdXElf8OQQKBPr6FXDvZpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HC2CCuGiNfdfi4T9o8C/6Mb3jkBbUmX4xdfrKgQJUlZ9944bRig+NxzpRSzhfbe3R
         WwElZczeFuUKpHFRFFFdKwwgeFM1peH0r5F7Yec/FmW6bdGbXm0zpMGJFAtxBGljaH
         9HPo6GnlYtjYKl+fH+SG6psBeKuE76V6rDwuOYiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 02/76] arm64: vdso32: require CROSS_COMPILE_COMPAT for gcc+bfd
Date:   Mon, 27 Dec 2021 16:30:17 +0100
Message-Id: <20211227151324.795741300@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 3e6f8d1fa18457d54b20917bd9174d27daf09ab9 upstream.

Similar to
commit 231ad7f409f1 ("Makefile: infer --target from ARCH for CC=clang")
There really is no point in setting --target based on
$CROSS_COMPILE_COMPAT for clang when the integrated assembler is being
used, since
commit ef94340583ee ("arm64: vdso32: drop -no-integrated-as flag").

Allows COMPAT_VDSO to be selected without setting $CROSS_COMPILE_COMPAT
when using clang and lld together.

Before:
$ ARCH=arm64 CROSS_COMPILE_COMPAT=arm-linux-gnueabi- make -j72 LLVM=1 defconfig
$ grep CONFIG_COMPAT_VDSO .config
CONFIG_COMPAT_VDSO=y
$ ARCH=arm64 make -j72 LLVM=1 defconfig
$ grep CONFIG_COMPAT_VDSO .config
$

After:
$ ARCH=arm64 CROSS_COMPILE_COMPAT=arm-linux-gnueabi- make -j72 LLVM=1 defconfig
$ grep CONFIG_COMPAT_VDSO .config
CONFIG_COMPAT_VDSO=y
$ ARCH=arm64 make -j72 LLVM=1 defconfig
$ grep CONFIG_COMPAT_VDSO .config
CONFIG_COMPAT_VDSO=y

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/r/20211019223646.1146945-5-ndesaulniers@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig                |    3 ++-
 arch/arm64/kernel/vdso32/Makefile |   17 +++++------------
 2 files changed, 7 insertions(+), 13 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1265,7 +1265,8 @@ config KUSER_HELPERS
 
 config COMPAT_VDSO
 	bool "Enable vDSO for 32-bit applications"
-	depends on !CPU_BIG_ENDIAN && "$(CROSS_COMPILE_COMPAT)" != ""
+	depends on !CPU_BIG_ENDIAN
+	depends on (CC_IS_CLANG && LD_IS_LLD) || "$(CROSS_COMPILE_COMPAT)" != ""
 	select GENERIC_COMPAT_VDSO
 	default y
 	help
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -10,18 +10,15 @@ include $(srctree)/lib/vdso/Makefile
 
 # Same as cc-*option, but using CC_COMPAT instead of CC
 ifeq ($(CONFIG_CC_IS_CLANG), y)
-CC_COMPAT_CLANG_FLAGS := --target=$(notdir $(CROSS_COMPILE_COMPAT:%-=%))
-
 CC_COMPAT ?= $(CC)
-CC_COMPAT += $(CC_COMPAT_CLANG_FLAGS)
-
-ifneq ($(LLVM),)
-LD_COMPAT ?= $(LD)
+CC_COMPAT += --target=arm-linux-gnueabi
 else
-LD_COMPAT ?= $(CROSS_COMPILE_COMPAT)ld
+CC_COMPAT ?= $(CROSS_COMPILE_COMPAT)gcc
 endif
+
+ifeq ($(CONFIG_LD_IS_LLD), y)
+LD_COMPAT ?= $(LD)
 else
-CC_COMPAT ?= $(CROSS_COMPILE_COMPAT)gcc
 LD_COMPAT ?= $(CROSS_COMPILE_COMPAT)ld
 endif
 
@@ -47,10 +44,6 @@ VDSO_CPPFLAGS += $(LINUXINCLUDE)
 # Common C and assembly flags
 # From top-level Makefile
 VDSO_CAFLAGS := $(VDSO_CPPFLAGS)
-ifneq ($(shell $(CC_COMPAT) --version 2>&1 | head -n 1 | grep clang),)
-VDSO_CAFLAGS += --target=$(notdir $(CROSS_COMPILE_COMPAT:%-=%))
-endif
-
 VDSO_CAFLAGS += $(call cc32-option,-fno-PIE)
 ifdef CONFIG_DEBUG_INFO
 VDSO_CAFLAGS += -g


