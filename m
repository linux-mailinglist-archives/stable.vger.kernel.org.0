Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921C03546F5
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 21:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbhDETJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 15:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239300AbhDETIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 15:08:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D734D613A0;
        Mon,  5 Apr 2021 19:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617649722;
        bh=s3HxunNSM7cAumctH+zO3LtJJ5dfoPlbC+KMRjOnrP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZse0lPdNu9VxUK5OumnS2T6rZbWcfup1kRW1mELAeMsouUBrgvW+EIMg60ZmkG3O
         /ch1Cui68thmqvWc9TgA6vKmYx92/8YAzW4iXRQGmkCfLzXf0SyT3/vdv32E7ho2L5
         LLewHHshQlsdj+udJ6FydmF1LXb19I1HBM/pEC2KzQERbM4uNlKa1VsdYrH8yRpVNX
         gO06CKiuXBuCHPkDyhmKramNtR7lyukQ0Xe0SYyCo7SoEvCP4FZ5vY0KzXd5rYr6tw
         eTj4iQbMo46x5PpRUtaxEbTgsfNdFXJDGaARNKmMYZ2e05dfyNniDDAmG6fVpuWvBY
         r6tafQ/p8JItw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9] ARM: 8723/2: always assume the "unified" syntax for assembly code
Date:   Mon,  5 Apr 2021 12:08:27 -0700
Message-Id: <20210405190827.502021-1-nathan@kernel.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <YGhV2gwpI1XUlkyu@kroah.com>
References: <YGhV2gwpI1XUlkyu@kroah.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Pitre <nicolas.pitre@linaro.org>

commit 75fea300d73ae5b18957949a53ec770daaeb6fc2 upstream.

The GNU assembler has implemented the "unified syntax" parsing since
2005. This "unified" syntax is required when the kernel is built in
Thumb2 mode. However the "unified" syntax is a mixed bag of features,
including not requiring a `#' prefix with immediate operands. This leads
to situations where some code builds just fine in Thumb2 mode and fails
to build in ARM mode if that prefix is missing. This behavior
discrepancy makes build tests less valuable, forcing both ARM and Thumb2
builds for proper coverage.

Let's "fix" this issue by always using the "unified" syntax for both ARM
and Thumb2 mode. Given that the documented minimum binutils version that
properly builds the kernel is version 2.20 released in 2010, we can
assume that any toolchain capable of building the latest kernel is also
"unified syntax" capable.

Whith this, a bunch of macros used to mask some differences between both
syntaxes can be removed, with the side effect of making LTO easier.

Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
[nathan: Resolve small conflict on 4.9 due to a lack of 494609701e06a]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

Hi all,

This commit is needed to fix the backport of commit 7f9942c61fa6 ("ARM:
s3c: fix fiq for clang IAS"):

https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/message/MJWA3VGAUNQYOL7XZBYMS4EI4AYRC3XN/

It is present in 4.14+ and it has been validate via TuxSuite across a
variety of arch/arm configs with no errors so I feel it should be a
fairly safe backport.

Cheers,
Nathan

 arch/arm/Kconfig               |  7 +---
 arch/arm/Makefile              |  6 ++-
 arch/arm/include/asm/unified.h | 77 ++--------------------------------
 3 files changed, 8 insertions(+), 82 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ae55f5db97f8..9dbaa283f01d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1546,12 +1546,10 @@ config THUMB2_KERNEL
 	depends on (CPU_V7 || CPU_V7M) && !CPU_V6 && !CPU_V6K
 	default y if CPU_THUMBONLY
 	select AEABI
-	select ARM_ASM_UNIFIED
 	select ARM_UNWIND
 	help
 	  By enabling this option, the kernel will be compiled in
-	  Thumb-2 mode. A compiler/assembler that understand the unified
-	  ARM-Thumb syntax is needed.
+	  Thumb-2 mode.
 
 	  If unsure, say N.
 
@@ -1586,9 +1584,6 @@ config THUMB2_AVOID_R_ARM_THM_JUMP11
 
 	  Unless you are sure your tools don't have this problem, say Y.
 
-config ARM_ASM_UNIFIED
-	bool
-
 config ARM_PATCH_IDIV
 	bool "Runtime patch udiv/sdiv instructions into __aeabi_{u}idiv()"
 	depends on CPU_32v7 && !XIP_KERNEL
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index e14ddca59d02..975b110e7d87 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -113,9 +113,11 @@ ifeq ($(CONFIG_ARM_UNWIND),y)
 CFLAGS_ABI	+=-funwind-tables
 endif
 
+# Accept old syntax despite ".syntax unified"
+AFLAGS_NOWARN	:=$(call as-option,-Wa$(comma)-mno-warn-deprecated,-Wa$(comma)-W)
+
 ifeq ($(CONFIG_THUMB2_KERNEL),y)
 AFLAGS_AUTOIT	:=$(call as-option,-Wa$(comma)-mimplicit-it=always,-Wa$(comma)-mauto-it)
-AFLAGS_NOWARN	:=$(call as-option,-Wa$(comma)-mno-warn-deprecated,-Wa$(comma)-W)
 CFLAGS_ISA	:=-mthumb $(AFLAGS_AUTOIT) $(AFLAGS_NOWARN)
 AFLAGS_ISA	:=$(CFLAGS_ISA) -Wa$(comma)-mthumb
 # Work around buggy relocation from gas if requested:
@@ -123,7 +125,7 @@ ifeq ($(CONFIG_THUMB2_AVOID_R_ARM_THM_JUMP11),y)
 CFLAGS_MODULE	+=-fno-optimize-sibling-calls
 endif
 else
-CFLAGS_ISA	:=$(call cc-option,-marm,)
+CFLAGS_ISA	:=$(call cc-option,-marm,) $(AFLAGS_NOWARN)
 AFLAGS_ISA	:=$(CFLAGS_ISA)
 endif
 
diff --git a/arch/arm/include/asm/unified.h b/arch/arm/include/asm/unified.h
index a91ae499614c..2c3b952be63e 100644
--- a/arch/arm/include/asm/unified.h
+++ b/arch/arm/include/asm/unified.h
@@ -20,8 +20,10 @@
 #ifndef __ASM_UNIFIED_H
 #define __ASM_UNIFIED_H
 
-#if defined(__ASSEMBLY__) && defined(CONFIG_ARM_ASM_UNIFIED)
+#if defined(__ASSEMBLY__)
 	.syntax unified
+#else
+__asm__(".syntax unified");
 #endif
 
 #ifdef CONFIG_CPU_V7M
@@ -64,77 +66,4 @@
 
 #endif	/* CONFIG_THUMB2_KERNEL */
 
-#ifndef CONFIG_ARM_ASM_UNIFIED
-
-/*
- * If the unified assembly syntax isn't used (in ARM mode), these
- * macros expand to an empty string
- */
-#ifdef __ASSEMBLY__
-	.macro	it, cond
-	.endm
-	.macro	itt, cond
-	.endm
-	.macro	ite, cond
-	.endm
-	.macro	ittt, cond
-	.endm
-	.macro	itte, cond
-	.endm
-	.macro	itet, cond
-	.endm
-	.macro	itee, cond
-	.endm
-	.macro	itttt, cond
-	.endm
-	.macro	ittte, cond
-	.endm
-	.macro	ittet, cond
-	.endm
-	.macro	ittee, cond
-	.endm
-	.macro	itett, cond
-	.endm
-	.macro	itete, cond
-	.endm
-	.macro	iteet, cond
-	.endm
-	.macro	iteee, cond
-	.endm
-#else	/* !__ASSEMBLY__ */
-__asm__(
-"	.macro	it, cond\n"
-"	.endm\n"
-"	.macro	itt, cond\n"
-"	.endm\n"
-"	.macro	ite, cond\n"
-"	.endm\n"
-"	.macro	ittt, cond\n"
-"	.endm\n"
-"	.macro	itte, cond\n"
-"	.endm\n"
-"	.macro	itet, cond\n"
-"	.endm\n"
-"	.macro	itee, cond\n"
-"	.endm\n"
-"	.macro	itttt, cond\n"
-"	.endm\n"
-"	.macro	ittte, cond\n"
-"	.endm\n"
-"	.macro	ittet, cond\n"
-"	.endm\n"
-"	.macro	ittee, cond\n"
-"	.endm\n"
-"	.macro	itett, cond\n"
-"	.endm\n"
-"	.macro	itete, cond\n"
-"	.endm\n"
-"	.macro	iteet, cond\n"
-"	.endm\n"
-"	.macro	iteee, cond\n"
-"	.endm\n");
-#endif	/* __ASSEMBLY__ */
-
-#endif	/* CONFIG_ARM_ASM_UNIFIED */
-
 #endif	/* !__ASM_UNIFIED_H */
-- 
2.31.0

