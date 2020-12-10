Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234D82D66DF
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390126AbgLJO2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:28:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390144AbgLJO2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:28:40 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 4.4 29/39] arm64: assembler: make adr_l work in modules under KASLR
Date:   Thu, 10 Dec 2020 15:26:40 +0100
Message-Id: <20201210142602.329774863@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
References: <20201210142600.887734129@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 41c066f2c4d436c535616fe182331766c57838f0 upstream

When CONFIG_RANDOMIZE_MODULE_REGION_FULL=y, the offset between loaded
modules and the core kernel may exceed 4 GB, putting symbols exported
by the core kernel out of the reach of the ordinary adrp/add instruction
pairs used to generate relative symbol references. So make the adr_l
macro emit a movz/movk sequence instead when executing in module context.

While at it, remove the pointless special case for the stack pointer.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ dannf: backported to v4.4 by replacing the 3-arg adr_l macro in head.S
  with it's output, as this commit drops the 3-arg variant ]
Fixes: c042dd600f4e ("crypto: arm64/sha - avoid non-standard inline asm tricks")
Signed-off-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/assembler.h |   36 +++++++++++++++++++++++++++---------
 arch/arm64/kernel/head.S           |    3 ++-
 2 files changed, 29 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -148,22 +148,25 @@ lr	.req	x30		// link register
 
 /*
  * Pseudo-ops for PC-relative adr/ldr/str <reg>, <symbol> where
- * <symbol> is within the range +/- 4 GB of the PC.
+ * <symbol> is within the range +/- 4 GB of the PC when running
+ * in core kernel context. In module context, a movz/movk sequence
+ * is used, since modules may be loaded far away from the kernel
+ * when KASLR is in effect.
  */
 	/*
 	 * @dst: destination register (64 bit wide)
 	 * @sym: name of the symbol
-	 * @tmp: optional scratch register to be used if <dst> == sp, which
-	 *       is not allowed in an adrp instruction
 	 */
-	.macro	adr_l, dst, sym, tmp=
-	.ifb	\tmp
+	.macro	adr_l, dst, sym
+#ifndef MODULE
 	adrp	\dst, \sym
 	add	\dst, \dst, :lo12:\sym
-	.else
-	adrp	\tmp, \sym
-	add	\dst, \tmp, :lo12:\sym
-	.endif
+#else
+	movz	\dst, #:abs_g3:\sym
+	movk	\dst, #:abs_g2_nc:\sym
+	movk	\dst, #:abs_g1_nc:\sym
+	movk	\dst, #:abs_g0_nc:\sym
+#endif
 	.endm
 
 	/*
@@ -174,6 +177,7 @@ lr	.req	x30		// link register
 	 *       the address
 	 */
 	.macro	ldr_l, dst, sym, tmp=
+#ifndef MODULE
 	.ifb	\tmp
 	adrp	\dst, \sym
 	ldr	\dst, [\dst, :lo12:\sym]
@@ -181,6 +185,15 @@ lr	.req	x30		// link register
 	adrp	\tmp, \sym
 	ldr	\dst, [\tmp, :lo12:\sym]
 	.endif
+#else
+	.ifb	\tmp
+	adr_l	\dst, \sym
+	ldr	\dst, [\dst]
+	.else
+	adr_l	\tmp, \sym
+	ldr	\dst, [\tmp]
+	.endif
+#endif
 	.endm
 
 	/*
@@ -190,8 +203,13 @@ lr	.req	x30		// link register
 	 *       while <src> needs to be preserved.
 	 */
 	.macro	str_l, src, sym, tmp
+#ifndef MODULE
 	adrp	\tmp, \sym
 	str	\src, [\tmp, :lo12:\sym]
+#else
+	adr_l	\tmp, \sym
+	str	\src, [\tmp]
+#endif
 	.endm
 
 /*
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -424,7 +424,8 @@ __mmap_switched:
 	str	xzr, [x6], #8			// Clear BSS
 	b	1b
 2:
-	adr_l	sp, initial_sp, x4
+	adrp	x4, initial_sp
+	add	sp, x4, :lo12:initial_sp
 	str_l	x21, __fdt_pointer, x5		// Save FDT pointer
 	str_l	x24, memstart_addr, x6		// Save PHYS_OFFSET
 	mov	x29, #0


