Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 877A5DD199
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfJRWEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728035AbfJRWEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2E25222C2;
        Fri, 18 Oct 2019 22:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436259;
        bh=B3WWtwLfQ000BqWRJiE7NmwbCqlmIAKHMfSljLuwNIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vpx5f9VHS7OGUrhuLZSgxhnPFMsh/KzBJEwcQ0fUZPNSpwz4YxWHBvXCdjXXLM8P1
         t2kT7OPeDAArCnTRpoz+At8z0ig4ZPlsckp0xPPsNzunIllB7wd95VSwiaoSwrEJwk
         NRAjszbXQ6SFLz+LJqzO0HjDVlbv7I7FVTvceWXs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 42/89] arm64: vdso32: Fix broken compat vDSO build warnings
Date:   Fri, 18 Oct 2019 18:02:37 -0400
Message-Id: <20191018220324.8165-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

[ Upstream commit e0de01aafc3dd7b73308106b056ead2d48391905 ]

The .config file and the generated include/config/auto.conf can
end up out of sync after a set of commands since
CONFIG_CROSS_COMPILE_COMPAT_VDSO is not updated correctly.

The sequence can be reproduced as follows:

$ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig
[...]
$ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- menuconfig
[set CONFIG_CROSS_COMPILE_COMPAT_VDSO="arm-linux-gnueabihf-"]
$ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-

Which results in:

arch/arm64/Makefile:62: CROSS_COMPILE_COMPAT not defined or empty,
the compat vDSO will not be built

even though the compat vDSO has been built:

$ file arch/arm64/kernel/vdso32/vdso.so
arch/arm64/kernel/vdso32/vdso.so: ELF 32-bit LSB pie executable, ARM,
EABI5 version 1 (SYSV), dynamically linked,
BuildID[sha1]=c67f6c786f2d2d6f86c71f708595594aa25247f6, stripped

A similar case that involves changing the configuration parameter
multiple times can be reconducted to the same family of problems.

Remove the use of CONFIG_CROSS_COMPILE_COMPAT_VDSO altogether and
instead rely on the cross-compiler prefix coming from the environment
via CROSS_COMPILE_COMPAT, much like we do for the rest of the kernel.

Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig                |  2 +-
 arch/arm64/Makefile               | 18 +++++-------------
 arch/arm64/kernel/vdso32/Makefile |  2 --
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3adcec05b1f67..ba9a4d079440d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -111,7 +111,7 @@ config ARM64
 	select GENERIC_STRNLEN_USER
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_GETTIMEOFDAY
-	select GENERIC_COMPAT_VDSO if (!CPU_BIG_ENDIAN && COMPAT)
+	select GENERIC_COMPAT_VDSO if (!CPU_BIG_ENDIAN && COMPAT && "$(CROSS_COMPILE_COMPAT)" != "")
 	select HANDLE_DOMAIN_IRQ
 	select HARDIRQS_SW_RESEND
 	select HAVE_PCI
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 61de992bbea3f..9743b50bdee7d 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -47,20 +47,12 @@ $(warning Detected assembler with broken .inst; disassembly will be unreliable)
   endif
 endif
 
+COMPATCC ?= $(CROSS_COMPILE_COMPAT)gcc
+export COMPATCC
+
 ifeq ($(CONFIG_GENERIC_COMPAT_VDSO), y)
-  CROSS_COMPILE_COMPAT ?= $(CONFIG_CROSS_COMPILE_COMPAT_VDSO:"%"=%)
-
-  ifeq ($(CONFIG_CC_IS_CLANG), y)
-    $(warning CROSS_COMPILE_COMPAT is clang, the compat vDSO will not be built)
-  else ifeq ($(strip $(CROSS_COMPILE_COMPAT)),)
-    $(warning CROSS_COMPILE_COMPAT not defined or empty, the compat vDSO will not be built)
-  else ifeq ($(shell which $(CROSS_COMPILE_COMPAT)gcc 2> /dev/null),)
-    $(error $(CROSS_COMPILE_COMPAT)gcc not found, check CROSS_COMPILE_COMPAT)
-  else
-    export CROSS_COMPILE_COMPAT
-    export CONFIG_COMPAT_VDSO := y
-    compat_vdso := -DCONFIG_COMPAT_VDSO=1
-  endif
+  export CONFIG_COMPAT_VDSO := y
+  compat_vdso := -DCONFIG_COMPAT_VDSO=1
 endif
 
 KBUILD_CFLAGS	+= -mgeneral-regs-only $(lseinstr) $(brokengasinst) $(compat_vdso)
diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 1fba0776ed40e..19e0d3115ffe0 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -8,8 +8,6 @@
 ARCH_REL_TYPE_ABS := R_ARM_JUMP_SLOT|R_ARM_GLOB_DAT|R_ARM_ABS32
 include $(srctree)/lib/vdso/Makefile
 
-COMPATCC := $(CROSS_COMPILE_COMPAT)gcc
-
 # Same as cc-*option, but using COMPATCC instead of CC
 cc32-option = $(call try-run,\
         $(COMPATCC) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
-- 
2.20.1

