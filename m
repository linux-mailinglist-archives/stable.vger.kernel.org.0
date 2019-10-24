Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F1BE32C8
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfJXMsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:48:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36730 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfJXMsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:48:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id c22so2487680wmd.1
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6HmtDRBfzbb3BO1zV/CqCVvZCsNWI78TpY20YkbBqDE=;
        b=E7xvx35KoMZewkEQLc/PbX3YAj3kWICYrguhIdnR0v4QnuVX47KXD6Txk0J+0Je6B/
         77nZ1UHZ7yDKUA8HraE1lZro5SC18qOoOYDcBvfex5Aw6Rdgwg11+AE1e8uygwOuz+MT
         kzGoLoudLhtkVi1QN/VIGKfnKCyPN4QSfUEruyrX85WXnZP3kpXDRCCMT8HyfezaVCkB
         Tic1rGkYilkEneMsp1Kkz25D2YbVJLhXNj0ZpK/r/KE2U7/SiDnKetL9vbws7FgrLodt
         d0Hl6y0aaiD05Q/IYQiqgMCtRfW/XQfzXYnT2hw2eFglXrOAotsczh947/9LUvZDQaaC
         cWKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6HmtDRBfzbb3BO1zV/CqCVvZCsNWI78TpY20YkbBqDE=;
        b=l5WktpfqkY/s+WMMT4ELl9Z8/vh5r6t1mU6frSj/p3tgLN+ZHqKbzD00AOPwXg7Qd7
         4SLjcs00bS3iDPiwRCIoN7+Jw1PoM1DchCF3OBzaBe9BWCuph6fQthnNSGp++F8QijGK
         zbZkQXejiTb8vH1WY27WrfQ/EvLPiETzpoWv3yobTHsyeD4Uir9E3ILVzA13fP0PMga9
         jKkYXUEqPF4wX+DMzrYaDN4Gin8EHGCPV38NW+L0wnmpllPEqmNoA0kBrOsRCScIo84n
         5szfEA3aDRdkBVrU7yCgXjnjPASbwco3P+MuCO+PKBwtZLDYUl9WUihl5uEMQjITaq0q
         Mr7Q==
X-Gm-Message-State: APjAAAXj94BliV5UP67vsGseHlq+AsihCQwovA9+8lysIw8w458Kehyj
        eORMkP5GxxpuUy2qs19+YwHLRl6zbl9/38JX
X-Google-Smtp-Source: APXvYqxPkkp+DyW+CzcZ5ozLedZD1k+V29lUKKv16sV5m9bMH8+erduurDEt22nWkIFUkFJ9D3vUng==
X-Received: by 2002:a05:600c:2042:: with SMTP id p2mr2614878wmg.174.1571921328377;
        Thu, 24 Oct 2019 05:48:48 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:48:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH for-stable-4.14 01/48] arm64: sysreg: Move to use definitions for all the SCTLR bits
Date:   Thu, 24 Oct 2019 14:47:46 +0200
Message-Id: <20191024124833.4158-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
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
---
 arch/arm64/include/asm/sysreg.h | 65 +++++++++++++++++++-
 arch/arm64/kernel/head.S        | 13 +---
 arch/arm64/mm/proc.S            | 24 +-------
 3 files changed, 67 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index ede80d47d0ef..cd32a968ff5b 100644
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
@@ -519,6 +577,9 @@ static inline void config_sctlr_el1(u32 clear, u32 set)
 {
 	u32 val;
 
+	SCTLR_EL2_BUILD_BUG_ON_MISSING_BITS;
+	SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS;
+
 	val = read_sysreg(sctlr_el1);
 	val &= ~clear;
 	val |= set;
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 1371542de0d3..92cc7b51f100 100644
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
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 65b040152184..ecbc060807d2 100644
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
-- 
2.20.1

