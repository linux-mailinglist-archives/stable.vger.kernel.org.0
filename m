Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6AD2D1FBF
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 02:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgLHBLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 20:11:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53245 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgLHBLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 20:11:30 -0500
Received: from 2.general.dannf.us.vpn ([10.172.65.1] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dann.frazier@canonical.com>)
        id 1kmRWh-0005Ox-52; Tue, 08 Dec 2020 01:10:47 +0000
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org, Michael Schaller <misch@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>, linux-efi@vger.kernel.org
Subject: [PATCH 4.4] arm64: assembler: make adr_l work in modules under KASLR
Date:   Mon,  7 Dec 2020 18:10:34 -0700
Message-Id: <20201208011034.3015079-1-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <CALdTtnuT7fVJ17C2nq8kks_rFRGtDySx61tWpt8b+roajyi7vg@mail.gmail.com>
References: <CALdTtnuT7fVJ17C2nq8kks_rFRGtDySx61tWpt8b+roajyi7vg@mail.gmail.com>
MIME-Version: 1.0
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
---
 arch/arm64/include/asm/assembler.h | 36 +++++++++++++++++++++++++++---------
 arch/arm64/kernel/head.S           |  3 ++-
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index f68abb1..7c28791 100644
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
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 6299a8a..504bcc3 100644
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
-- 
2.7.4

