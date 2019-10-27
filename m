Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50059E6619
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbfJ0VI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbfJ0VI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:27 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9A6120B7C;
        Sun, 27 Oct 2019 21:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210506;
        bh=apWKvyUIUtNX+3YsSJL5D6ID3OsKFOhQny8MCSXLP/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yn9Tqd3tbRwD21Fk6nYP+eyVIZ/eIcXoUm9khDJIl1RCkvo8fh19aK3tFtPMDn8L7
         fzpr7rJkeqU5lUZb89JXcqRwfTMUHzzxGKX0FCYDpIiAKi3mxidT+9TUlqBV9tdDoJ
         e7/3sOgCfbutex2wutBRAhjTwiQFs7qG2Br0gpqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 037/119] arm64: sysreg: Move to use definitions for all the SCTLR bits
Date:   Sun, 27 Oct 2019 22:00:14 +0100
Message-Id: <20191027203312.470729066@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit 7a00d68ebe5f07cb1db17e7fedfd031f0d87e8bb ]

__cpu_setup() configures SCTLR_EL1 using some hard coded hex masks,
and el2_setup() duplicates some this when setting RES1 bits.

Lets make this the same as KVM's hyp_init, which uses named bits.

First, we add definitions for all the SCTLR_EL{1,2} bits, the RES{1,0}
bits, and those we want to set or clear.

Add a build_bug checks to ensures all bits are either set or clear.
This means we don't need to preserve endian-ness configuration
generated elsewhere.

Finally, move the head.S and proc.S users of these hard-coded masks
over to the macro versions.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/sysreg.h |   65 ++++++++++++++++++++++++++++++++++++++--
 arch/arm64/kernel/head.S        |   13 +-------
 arch/arm64/mm/proc.S            |   24 --------------
 3 files changed, 67 insertions(+), 35 deletions(-)

--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -20,6 +20,7 @@
 #ifndef __ASM_SYSREG_H
 #define __ASM_SYSREG_H
 
+#include <asm/compiler.h>
 #include <linux/stringify.h>
 
 /*
@@ -297,25 +298,81 @@
 
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
+#define SCTLR_ELx_WXN	(1 << 19)
 #define SCTLR_ELx_I	(1 << 12)
 #define SCTLR_ELx_SA	(1 << 3)
 #define SCTLR_ELx_C	(1 << 2)
 #define SCTLR_ELx_A	(1 << 1)
 #define SCTLR_ELx_M	1
 
+#define SCTLR_ELx_FLAGS	(SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | \
+			 SCTLR_ELx_SA | SCTLR_ELx_I)
+
+/* SCTLR_EL2 specific flags. */
 #define SCTLR_EL2_RES1	((1 << 4)  | (1 << 5)  | (1 << 11) | (1 << 16) | \
 			 (1 << 18) | (1 << 22) | (1 << 23) | (1 << 28) | \
 			 (1 << 29))
+#define SCTLR_EL2_RES0	((1 << 6)  | (1 << 7)  | (1 << 8)  | (1 << 9)  | \
+			 (1 << 10) | (1 << 13) | (1 << 14) | (1 << 15) | \
+			 (1 << 17) | (1 << 20) | (1 << 21) | (1 << 24) | \
+			 (1 << 26) | (1 << 27) | (1 << 30) | (1 << 31))
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define ENDIAN_SET_EL2		SCTLR_ELx_EE
+#define ENDIAN_CLEAR_EL2	0
+#else
+#define ENDIAN_SET_EL2		0
+#define ENDIAN_CLEAR_EL2	SCTLR_ELx_EE
+#endif
+
+/* SCTLR_EL2 value used for the hyp-stub */
+#define SCTLR_EL2_SET	(ENDIAN_SET_EL2   | SCTLR_EL2_RES1)
+#define SCTLR_EL2_CLEAR	(SCTLR_ELx_M      | SCTLR_ELx_A    | SCTLR_ELx_C   | \
+			 SCTLR_ELx_SA     | SCTLR_ELx_I    | SCTLR_ELx_WXN | \
+			 ENDIAN_CLEAR_EL2 | SCTLR_EL2_RES0)
+
+/* Check all the bits are accounted for */
+#define SCTLR_EL2_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL2_SET ^ SCTLR_EL2_CLEAR) != ~0)
 
-#define SCTLR_ELx_FLAGS	(SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | \
-			 SCTLR_ELx_SA | SCTLR_ELx_I)
 
 /* SCTLR_EL1 specific flags. */
 #define SCTLR_EL1_UCI		(1 << 26)
+#define SCTLR_EL1_E0E		(1 << 24)
 #define SCTLR_EL1_SPAN		(1 << 23)
+#define SCTLR_EL1_NTWE		(1 << 18)
+#define SCTLR_EL1_NTWI		(1 << 16)
 #define SCTLR_EL1_UCT		(1 << 15)
+#define SCTLR_EL1_DZE		(1 << 14)
+#define SCTLR_EL1_UMA		(1 << 9)
 #define SCTLR_EL1_SED		(1 << 8)
+#define SCTLR_EL1_ITD		(1 << 7)
 #define SCTLR_EL1_CP15BEN	(1 << 5)
+#define SCTLR_EL1_SA0		(1 << 4)
+
+#define SCTLR_EL1_RES1	((1 << 11) | (1 << 20) | (1 << 22) | (1 << 28) | \
+			 (1 << 29))
+#define SCTLR_EL1_RES0  ((1 << 6)  | (1 << 10) | (1 << 13) | (1 << 17) | \
+			 (1 << 21) | (1 << 27) | (1 << 30) | (1 << 31))
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define ENDIAN_SET_EL1		(SCTLR_EL1_E0E | SCTLR_ELx_EE)
+#define ENDIAN_CLEAR_EL1	0
+#else
+#define ENDIAN_SET_EL1		0
+#define ENDIAN_CLEAR_EL1	(SCTLR_EL1_E0E | SCTLR_ELx_EE)
+#endif
+
+#define SCTLR_EL1_SET	(SCTLR_ELx_M    | SCTLR_ELx_C    | SCTLR_ELx_SA   |\
+			 SCTLR_EL1_SA0  | SCTLR_EL1_SED  | SCTLR_ELx_I    |\
+			 SCTLR_EL1_DZE  | SCTLR_EL1_UCT  | SCTLR_EL1_NTWI |\
+			 SCTLR_EL1_NTWE | SCTLR_EL1_SPAN | ENDIAN_SET_EL1 |\
+			 SCTLR_EL1_UCI  | SCTLR_EL1_RES1)
+#define SCTLR_EL1_CLEAR	(SCTLR_ELx_A   | SCTLR_EL1_CP15BEN | SCTLR_EL1_ITD    |\
+			 SCTLR_EL1_UMA | SCTLR_ELx_WXN     | ENDIAN_CLEAR_EL1 |\
+			 SCTLR_EL1_RES0)
+
+/* Check all the bits are accounted for */
+#define SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != ~0)
 
 /* id_aa64isar0 */
 #define ID_AA64ISAR0_RDM_SHIFT		28
@@ -463,6 +520,7 @@
 
 #else
 
+#include <linux/build_bug.h>
 #include <linux/types.h>
 
 asm(
@@ -519,6 +577,9 @@ static inline void config_sctlr_el1(u32
 {
 	u32 val;
 
+	SCTLR_EL2_BUILD_BUG_ON_MISSING_BITS;
+	SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS;
+
 	val = read_sysreg(sctlr_el1);
 	val &= ~clear;
 	val |= set;
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -388,17 +388,13 @@ ENTRY(el2_setup)
 	mrs	x0, CurrentEL
 	cmp	x0, #CurrentEL_EL2
 	b.eq	1f
-	mrs	x0, sctlr_el1
-CPU_BE(	orr	x0, x0, #(3 << 24)	)	// Set the EE and E0E bits for EL1
-CPU_LE(	bic	x0, x0, #(3 << 24)	)	// Clear the EE and E0E bits for EL1
+	mov_q	x0, (SCTLR_EL1_RES1 | ENDIAN_SET_EL1)
 	msr	sctlr_el1, x0
 	mov	w0, #BOOT_CPU_MODE_EL1		// This cpu booted in EL1
 	isb
 	ret
 
-1:	mrs	x0, sctlr_el2
-CPU_BE(	orr	x0, x0, #(1 << 25)	)	// Set the EE bit for EL2
-CPU_LE(	bic	x0, x0, #(1 << 25)	)	// Clear the EE bit for EL2
+1:	mov_q	x0, (SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
 	msr	sctlr_el2, x0
 
 #ifdef CONFIG_ARM64_VHE
@@ -505,10 +501,7 @@ install_el2_stub:
 	 * requires no configuration, and all non-hyp-specific EL2 setup
 	 * will be done via the _EL1 system register aliases in __cpu_setup.
 	 */
-	/* sctlr_el1 */
-	mov	x0, #0x0800			// Set/clear RES{1,0} bits
-CPU_BE(	movk	x0, #0x33d0, lsl #16	)	// Set EE and E0E on BE systems
-CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
+	mov_q	x0, (SCTLR_EL1_RES1 | ENDIAN_SET_EL1)
 	msr	sctlr_el1, x0
 
 	/* Coprocessor traps. */
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -430,11 +430,7 @@ ENTRY(__cpu_setup)
 	/*
 	 * Prepare SCTLR
 	 */
-	adr	x5, crval
-	ldp	w5, w6, [x5]
-	mrs	x0, sctlr_el1
-	bic	x0, x0, x5			// clear bits
-	orr	x0, x0, x6			// set bits
+	mov_q	x0, SCTLR_EL1_SET
 	/*
 	 * Set/prepare TCR and TTBR. We use 512GB (39-bit) address range for
 	 * both user and kernel.
@@ -470,21 +466,3 @@ ENTRY(__cpu_setup)
 	msr	tcr_el1, x10
 	ret					// return to head.S
 ENDPROC(__cpu_setup)
-
-	/*
-	 * We set the desired value explicitly, including those of the
-	 * reserved bits. The values of bits EE & E0E were set early in
-	 * el2_setup, which are left untouched below.
-	 *
-	 *                 n n            T
-	 *       U E      WT T UD     US IHBS
-	 *       CE0      XWHW CZ     ME TEEA S
-	 * .... .IEE .... NEAI TE.I ..AD DEN0 ACAM
-	 * 0011 0... 1101 ..0. ..0. 10.. .0.. .... < hardware reserved
-	 * .... .1.. .... 01.1 11.1 ..01 0.01 1101 < software settings
-	 */
-	.type	crval, #object
-crval:
-	.word	0xfcffffff			// clear
-	.word	0x34d5d91d			// set
-	.popsection


