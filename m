Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3766E1CAAF7
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgEHMij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728392AbgEHMii (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD74F24957;
        Fri,  8 May 2020 12:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941516;
        bh=jJ0laAd9KeMfidB86hAIvKolc99ga8fgSzNcVScJC9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKMViDsZHzQWTrMuK4r0C/edktBV6wNYyHliNFFUhukadeXtKNqTT3mD5NsaVwpiI
         yHuNDvoY5hBBcsnUEGyZbcpo2JwZVop9ywwgUGHzpyWAbZ7COLXo4b1po/k/RXZHWs
         euDjiEKfVWR2UFdAa6BmPsCsemQhiXrSEmVE2lgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Paul Burton <Paul.Burton@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 025/312] MIPS: Fix little endian microMIPS MSA encodings
Date:   Fri,  8 May 2020 14:30:16 +0200
Message-Id: <20200508123126.257451997@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

commit 6e1b29c3094688b6803fa1f9d5da676a7d0fbff9 upstream.

When the toolchain doesn't support MSA we encode MSA instructions
explicitly in assembly. Unfortunately we use .word for both MIPS and
microMIPS encodings which is wrong, since 32-bit microMIPS instructions
are made up from a pair of halfwords.

- The most significant halfword always comes first, so for little endian
  builds the halves will be emitted in the wrong order.

- 32-bit alignment isn't guaranteed, so the assembler may insert a
  16-bit nop instruction to pad the instruction stream to a 32-bit
  boundary.

Use the new instruction encoding macros to encode microMIPS MSA
instructions correctly.

Fixes: d96cc3d1ec5d ("MIPS: Add microMIPS MSA support.")
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Paul Burton <Paul.Burton@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/13312/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/asmmacro.h |   99 +++++++++++++++++++--------------------
 arch/mips/include/asm/msa.h      |   21 +++-----
 2 files changed, 58 insertions(+), 62 deletions(-)

--- a/arch/mips/include/asm/asmmacro.h
+++ b/arch/mips/include/asm/asmmacro.h
@@ -19,6 +19,28 @@
 #include <asm/asmmacro-64.h>
 #endif
 
+/*
+ * Helper macros for generating raw instruction encodings.
+ */
+#ifdef CONFIG_CPU_MICROMIPS
+	.macro	insn32_if_mm enc
+	.insn
+	.hword ((\enc) >> 16)
+	.hword ((\enc) & 0xffff)
+	.endm
+
+	.macro	insn_if_mips enc
+	.endm
+#else
+	.macro	insn32_if_mm enc
+	.endm
+
+	.macro	insn_if_mips enc
+	.insn
+	.word (\enc)
+	.endm
+#endif
+
 #if defined(CONFIG_CPU_MIPSR2) || defined(CONFIG_CPU_MIPSR6)
 	.macro	local_irq_enable reg=t0
 	ei
@@ -336,38 +358,6 @@
 	.endm
 #else
 
-#ifdef CONFIG_CPU_MICROMIPS
-#define CFC_MSA_INSN		0x587e0056
-#define CTC_MSA_INSN		0x583e0816
-#define LDB_MSA_INSN		0x58000807
-#define LDH_MSA_INSN		0x58000817
-#define LDW_MSA_INSN		0x58000827
-#define LDD_MSA_INSN		0x58000837
-#define STB_MSA_INSN		0x5800080f
-#define STH_MSA_INSN		0x5800081f
-#define STW_MSA_INSN		0x5800082f
-#define STD_MSA_INSN		0x5800083f
-#define COPY_SW_MSA_INSN	0x58b00056
-#define COPY_SD_MSA_INSN	0x58b80056
-#define INSERT_W_MSA_INSN	0x59300816
-#define INSERT_D_MSA_INSN	0x59380816
-#else
-#define CFC_MSA_INSN		0x787e0059
-#define CTC_MSA_INSN		0x783e0819
-#define LDB_MSA_INSN		0x78000820
-#define LDH_MSA_INSN		0x78000821
-#define LDW_MSA_INSN		0x78000822
-#define LDD_MSA_INSN		0x78000823
-#define STB_MSA_INSN		0x78000824
-#define STH_MSA_INSN		0x78000825
-#define STW_MSA_INSN		0x78000826
-#define STD_MSA_INSN		0x78000827
-#define COPY_SW_MSA_INSN	0x78b00059
-#define COPY_SD_MSA_INSN	0x78b80059
-#define INSERT_W_MSA_INSN	0x79300819
-#define INSERT_D_MSA_INSN	0x79380819
-#endif
-
 	/*
 	 * Temporary until all toolchains in use include MSA support.
 	 */
@@ -375,8 +365,8 @@
 	.set	push
 	.set	noat
 	SET_HARDFLOAT
-	.insn
-	.word	CFC_MSA_INSN | (\cs << 11)
+	insn_if_mips 0x787e0059 | (\cs << 11)
+	insn32_if_mm 0x587e0056 | (\cs << 11)
 	move	\rd, $1
 	.set	pop
 	.endm
@@ -386,7 +376,8 @@
 	.set	noat
 	SET_HARDFLOAT
 	move	$1, \rs
-	.word	CTC_MSA_INSN | (\cd << 6)
+	insn_if_mips 0x783e0819 | (\cd << 6)
+	insn32_if_mm 0x583e0816 | (\cd << 6)
 	.set	pop
 	.endm
 
@@ -395,7 +386,8 @@
 	.set	noat
 	SET_HARDFLOAT
 	PTR_ADDU $1, \base, \off
-	.word	LDB_MSA_INSN | (\wd << 6)
+	insn_if_mips 0x78000820 | (\wd << 6)
+	insn32_if_mm 0x58000807 | (\wd << 6)
 	.set	pop
 	.endm
 
@@ -404,7 +396,8 @@
 	.set	noat
 	SET_HARDFLOAT
 	PTR_ADDU $1, \base, \off
-	.word	LDH_MSA_INSN | (\wd << 6)
+	insn_if_mips 0x78000821 | (\wd << 6)
+	insn32_if_mm 0x58000817 | (\wd << 6)
 	.set	pop
 	.endm
 
@@ -413,7 +406,8 @@
 	.set	noat
 	SET_HARDFLOAT
 	PTR_ADDU $1, \base, \off
-	.word	LDW_MSA_INSN | (\wd << 6)
+	insn_if_mips 0x78000822 | (\wd << 6)
+	insn32_if_mm 0x58000827 | (\wd << 6)
 	.set	pop
 	.endm
 
@@ -422,7 +416,8 @@
 	.set	noat
 	SET_HARDFLOAT
 	PTR_ADDU $1, \base, \off
-	.word	LDD_MSA_INSN | (\wd << 6)
+	insn_if_mips 0x78000823 | (\wd << 6)
+	insn32_if_mm 0x58000837 | (\wd << 6)
 	.set	pop
 	.endm
 
@@ -431,7 +426,8 @@
 	.set	noat
 	SET_HARDFLOAT
 	PTR_ADDU $1, \base, \off
-	.word	STB_MSA_INSN | (\wd << 6)
+	insn_if_mips 0x78000824 | (\wd << 6)
+	insn32_if_mm 0x5800080f | (\wd << 6)
 	.set	pop
 	.endm
 
@@ -440,7 +436,8 @@
 	.set	noat
 	SET_HARDFLOAT
 	PTR_ADDU $1, \base, \off
-	.word	STH_MSA_INSN | (\wd << 6)
+	insn_if_mips 0x78000825 | (\wd << 6)
+	insn32_if_mm 0x5800081f | (\wd << 6)
 	.set	pop
 	.endm
 
@@ -449,7 +446,8 @@
 	.set	noat
 	SET_HARDFLOAT
 	PTR_ADDU $1, \base, \off
-	.word	STW_MSA_INSN | (\wd << 6)
+	insn_if_mips 0x78000826 | (\wd << 6)
+	insn32_if_mm 0x5800082f | (\wd << 6)
 	.set	pop
 	.endm
 
@@ -458,7 +456,8 @@
 	.set	noat
 	SET_HARDFLOAT
 	PTR_ADDU $1, \base, \off
-	.word	STD_MSA_INSN | (\wd << 6)
+	insn_if_mips 0x78000827 | (\wd << 6)
+	insn32_if_mm 0x5800083f | (\wd << 6)
 	.set	pop
 	.endm
 
@@ -466,8 +465,8 @@
 	.set	push
 	.set	noat
 	SET_HARDFLOAT
-	.insn
-	.word	COPY_SW_MSA_INSN | (\n << 16) | (\ws << 11)
+	insn_if_mips 0x78b00059 | (\n << 16) | (\ws << 11)
+	insn32_if_mm 0x58b00056 | (\n << 16) | (\ws << 11)
 	.set	pop
 	.endm
 
@@ -475,8 +474,8 @@
 	.set	push
 	.set	noat
 	SET_HARDFLOAT
-	.insn
-	.word	COPY_SD_MSA_INSN | (\n << 16) | (\ws << 11)
+	insn_if_mips 0x78b80059 | (\n << 16) | (\ws << 11)
+	insn32_if_mm 0x58b80056 | (\n << 16) | (\ws << 11)
 	.set	pop
 	.endm
 
@@ -484,7 +483,8 @@
 	.set	push
 	.set	noat
 	SET_HARDFLOAT
-	.word	INSERT_W_MSA_INSN | (\n << 16) | (\wd << 6)
+	insn_if_mips 0x79300819 | (\n << 16) | (\wd << 6)
+	insn32_if_mm 0x59300816 | (\n << 16) | (\wd << 6)
 	.set	pop
 	.endm
 
@@ -492,7 +492,8 @@
 	.set	push
 	.set	noat
 	SET_HARDFLOAT
-	.word	INSERT_D_MSA_INSN | (\n << 16) | (\wd << 6)
+	insn_if_mips 0x79380819 | (\n << 16) | (\wd << 6)
+	insn32_if_mm 0x59380816 | (\n << 16) | (\wd << 6)
 	.set	pop
 	.endm
 #endif
--- a/arch/mips/include/asm/msa.h
+++ b/arch/mips/include/asm/msa.h
@@ -192,13 +192,6 @@ static inline void write_msa_##name(unsi
  * allow compilation with toolchains that do not support MSA. Once all
  * toolchains in use support MSA these can be removed.
  */
-#ifdef CONFIG_CPU_MICROMIPS
-#define CFC_MSA_INSN	0x587e0056
-#define CTC_MSA_INSN	0x583e0816
-#else
-#define CFC_MSA_INSN	0x787e0059
-#define CTC_MSA_INSN	0x783e0819
-#endif
 
 #define __BUILD_MSA_CTL_REG(name, cs)				\
 static inline unsigned int read_msa_##name(void)		\
@@ -207,11 +200,12 @@ static inline unsigned int read_msa_##na
 	__asm__ __volatile__(					\
 	"	.set	push\n"					\
 	"	.set	noat\n"					\
-	"	.insn\n"					\
-	"	.word	%1 | (" #cs " << 11)\n"			\
+	"	# cfcmsa $1, $%1\n"				\
+	_ASM_INSN_IF_MIPS(0x787e0059 | %1 << 11)		\
+	_ASM_INSN32_IF_MM(0x587e0056 | %1 << 11)		\
 	"	move	%0, $1\n"				\
 	"	.set	pop\n"					\
-	: "=r"(reg) : "i"(CFC_MSA_INSN));			\
+	: "=r"(reg) : "i"(cs));					\
 	return reg;						\
 }								\
 								\
@@ -221,10 +215,11 @@ static inline void write_msa_##name(unsi
 	"	.set	push\n"					\
 	"	.set	noat\n"					\
 	"	move	$1, %0\n"				\
-	"	.insn\n"					\
-	"	.word	%1 | (" #cs " << 6)\n"			\
+	"	# ctcmsa $%1, $1\n"				\
+	_ASM_INSN_IF_MIPS(0x783e0819 | %1 << 6)			\
+	_ASM_INSN32_IF_MM(0x583e0816 | %1 << 6)			\
 	"	.set	pop\n"					\
-	: : "r"(val), "i"(CTC_MSA_INSN));			\
+	: : "r"(val), "i"(cs));					\
 }
 
 #endif /* !TOOLCHAIN_SUPPORTS_MSA */


