Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E1E172034
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbgB0Nwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731552AbgB0Nwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:52:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EFC620801;
        Thu, 27 Feb 2020 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811559;
        bh=ls25hE66DjZelebJqm1MeTUUK7jvn8rQPhsFYAW5Ouk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuiDThZixS3rfw5jW1Ii7gGbprU3bEpZATyFR0944yxkMxPuTvuqspVvEX0q7mUxA
         vjS66MAC2ji+7kTQ5DIGSdcNnu0zD0JE5STKy7A5T0vpirqLhbbrbDh+zmnRFezVPz
         SQIuWnN1bjFnfd69O0uHAykodexs1qcaoikjGVJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 014/237] ARM: 8723/2: always assume the "unified" syntax for assembly code
Date:   Thu, 27 Feb 2020 14:33:48 +0100
Message-Id: <20200227132257.072862824@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Pitre <nicolas.pitre@linaro.org>

[ Upstream commit 75fea300d73ae5b18957949a53ec770daaeb6fc2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig               |  7 +---
 arch/arm/Makefile              |  6 ++-
 arch/arm/include/asm/unified.h | 77 ++--------------------------------
 3 files changed, 8 insertions(+), 82 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index cf69aab648fbd..ba9325fc75b85 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1533,12 +1533,10 @@ config THUMB2_KERNEL
 	bool "Compile the kernel in Thumb-2 mode" if !CPU_THUMBONLY
 	depends on (CPU_V7 || CPU_V7M) && !CPU_V6 && !CPU_V6K
 	default y if CPU_THUMBONLY
-	select ARM_ASM_UNIFIED
 	select ARM_UNWIND
 	help
 	  By enabling this option, the kernel will be compiled in
-	  Thumb-2 mode. A compiler/assembler that understand the unified
-	  ARM-Thumb syntax is needed.
+	  Thumb-2 mode.
 
 	  If unsure, say N.
 
@@ -1573,9 +1571,6 @@ config THUMB2_AVOID_R_ARM_THM_JUMP11
 
 	  Unless you are sure your tools don't have this problem, say Y.
 
-config ARM_ASM_UNIFIED
-	bool
-
 config ARM_PATCH_IDIV
 	bool "Runtime patch udiv/sdiv instructions into __aeabi_{u}idiv()"
 	depends on CPU_32v7 && !XIP_KERNEL
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 17e80f4832816..234ee43b44384 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -115,9 +115,11 @@ ifeq ($(CONFIG_ARM_UNWIND),y)
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
@@ -125,7 +127,7 @@ ifeq ($(CONFIG_THUMB2_AVOID_R_ARM_THM_JUMP11),y)
 CFLAGS_MODULE	+=-fno-optimize-sibling-calls
 endif
 else
-CFLAGS_ISA	:=$(call cc-option,-marm,)
+CFLAGS_ISA	:=$(call cc-option,-marm,) $(AFLAGS_NOWARN)
 AFLAGS_ISA	:=$(CFLAGS_ISA)
 endif
 
diff --git a/arch/arm/include/asm/unified.h b/arch/arm/include/asm/unified.h
index a91ae499614cb..2c3b952be63eb 100644
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
2.20.1



