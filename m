Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63B2360C86
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbhDOOva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234001AbhDOOuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:50:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6923613C1;
        Thu, 15 Apr 2021 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498227;
        bh=57WHWjYDiOPBNbghh3Hb162OU6dJWOiyqNw2VCAoxa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7SU7/TuXy+zI5L/uM2Xa4ZgeNDtl4Z7cKgPqVf4/FsTtSF2rQ57KgUhLfgvXYYzf
         KU83peT8Hz86vD47ph3yZM+V3Xj0XbrR5pDOCEVeYaUGsfbeSfY9wyTnRbo89JNOR1
         fKgiMnnReo24QEfhhcuXbjJiykh7iqeH6msmoEOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.9 01/47] ARM: 8723/2: always assume the "unified" syntax for assembly code
Date:   Thu, 15 Apr 2021 16:46:53 +0200
Message-Id: <20210415144413.534624232@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Kconfig               |    7 ---
 arch/arm/Makefile              |    6 ++-
 arch/arm/include/asm/unified.h |   77 +----------------------------------------
 3 files changed, 8 insertions(+), 82 deletions(-)

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
@@ -123,7 +125,7 @@ ifeq ($(CONFIG_THUMB2_AVOID_R_ARM_THM_JU
 CFLAGS_MODULE	+=-fno-optimize-sibling-calls
 endif
 else
-CFLAGS_ISA	:=$(call cc-option,-marm,)
+CFLAGS_ISA	:=$(call cc-option,-marm,) $(AFLAGS_NOWARN)
 AFLAGS_ISA	:=$(CFLAGS_ISA)
 endif
 
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


