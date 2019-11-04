Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34642EED5D
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389884AbfKDWF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389876AbfKDWF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:56 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668CC214D8;
        Mon,  4 Nov 2019 22:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905154;
        bh=yW+O2w4PHfidddnAy+9Zy9AId5eRwICsitn+6r2C7ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXrtJfNGDJadykixd8bJBcuqx00MlytzVoZB1J75W648GVIT99dBfIGj3+echhro9
         wsUWTcoTBd4k6uTW51dfllwM4wEvfKhiQeC7+aJe29Jt2k9NGaEi11KlUUudeh+Y1g
         JJYiwK0xaP+sXMang5FwpLb3+388c6f3lkg25bN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 045/163] arm64: vdso32: Fix broken compat vDSO build warnings
Date:   Mon,  4 Nov 2019 22:43:55 +0100
Message-Id: <20191104212143.494973753@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e8cf562838716..f63b824cdc2d3 100644
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



