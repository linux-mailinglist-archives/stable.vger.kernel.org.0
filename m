Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335D31EAEB3
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbgFAS4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729677AbgFASAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:00:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53BAD2065C;
        Mon,  1 Jun 2020 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034438;
        bh=Uu427Pif+dmGwUKTeKrRVMNQQRMF0AAQYGAbly+3Wr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZTPdaz7Mzrqk2x/u2vYAKTWvaTux0Whxmw+lXw34MzCKXzYyAQ0OkDBxJBQml2oP
         yfT6Z6IYXXYhdlsxAHhcUlMap2/C6zqMy1RM7JxWspdJTBFV0nxPyZk8+fKTgjUsGj
         PIBhnqz6647OVXohg62wEBMZ5va+Zd7issAA2iwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/77] ARM: 8843/1: use unified assembler in headers
Date:   Mon,  1 Jun 2020 19:53:37 +0200
Message-Id: <20200601174022.344327002@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

[ Upstream commit c001899a5d6c2d7a0f3b75b2307ddef137fb46a6 ]

Use unified assembler syntax (UAL) in headers. Divided syntax is
considered deprecated. This will also allow to build the kernel
using LLVM's integrated assembler.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/assembler.h | 12 ++++++------
 arch/arm/include/asm/vfpmacros.h |  8 ++++----
 arch/arm/lib/bitops.h            |  8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 88286dd483ff..965224d14e6c 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -374,9 +374,9 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 	.macro	usraccoff, instr, reg, ptr, inc, off, cond, abort, t=TUSER()
 9999:
 	.if	\inc == 1
-	\instr\cond\()b\()\t\().w \reg, [\ptr, #\off]
+	\instr\()b\t\cond\().w \reg, [\ptr, #\off]
 	.elseif	\inc == 4
-	\instr\cond\()\t\().w \reg, [\ptr, #\off]
+	\instr\t\cond\().w \reg, [\ptr, #\off]
 	.else
 	.error	"Unsupported inc macro argument"
 	.endif
@@ -415,9 +415,9 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 	.rept	\rept
 9999:
 	.if	\inc == 1
-	\instr\cond\()b\()\t \reg, [\ptr], #\inc
+	\instr\()b\t\cond \reg, [\ptr], #\inc
 	.elseif	\inc == 4
-	\instr\cond\()\t \reg, [\ptr], #\inc
+	\instr\t\cond \reg, [\ptr], #\inc
 	.else
 	.error	"Unsupported inc macro argument"
 	.endif
@@ -458,7 +458,7 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 	.macro check_uaccess, addr:req, size:req, limit:req, tmp:req, bad:req
 #ifndef CONFIG_CPU_USE_DOMAINS
 	adds	\tmp, \addr, #\size - 1
-	sbcccs	\tmp, \tmp, \limit
+	sbcscc	\tmp, \tmp, \limit
 	bcs	\bad
 #ifdef CONFIG_CPU_SPECTRE
 	movcs	\addr, #0
@@ -472,7 +472,7 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 	sub	\tmp, \limit, #1
 	subs	\tmp, \tmp, \addr	@ tmp = limit - 1 - addr
 	addhs	\tmp, \tmp, #1		@ if (tmp >= 0) {
-	subhss	\tmp, \tmp, \size	@ tmp = limit - (addr + size) }
+	subshs	\tmp, \tmp, \size	@ tmp = limit - (addr + size) }
 	movlo	\addr, #0		@ if (tmp < 0) addr = NULL
 	csdb
 #endif
diff --git a/arch/arm/include/asm/vfpmacros.h b/arch/arm/include/asm/vfpmacros.h
index ef5dfedacd8d..628c336e8e3b 100644
--- a/arch/arm/include/asm/vfpmacros.h
+++ b/arch/arm/include/asm/vfpmacros.h
@@ -29,13 +29,13 @@
 	ldr	\tmp, =elf_hwcap		    @ may not have MVFR regs
 	ldr	\tmp, [\tmp, #0]
 	tst	\tmp, #HWCAP_VFPD32
-	ldcnel	p11, cr0, [\base],#32*4		    @ FLDMIAD \base!, {d16-d31}
+	ldclne	p11, cr0, [\base],#32*4		    @ FLDMIAD \base!, {d16-d31}
 	addeq	\base, \base, #32*4		    @ step over unused register space
 #else
 	VFPFMRX	\tmp, MVFR0			    @ Media and VFP Feature Register 0
 	and	\tmp, \tmp, #MVFR0_A_SIMD_MASK	    @ A_SIMD field
 	cmp	\tmp, #2			    @ 32 x 64bit registers?
-	ldceql	p11, cr0, [\base],#32*4		    @ FLDMIAD \base!, {d16-d31}
+	ldcleq	p11, cr0, [\base],#32*4		    @ FLDMIAD \base!, {d16-d31}
 	addne	\base, \base, #32*4		    @ step over unused register space
 #endif
 #endif
@@ -53,13 +53,13 @@
 	ldr	\tmp, =elf_hwcap		    @ may not have MVFR regs
 	ldr	\tmp, [\tmp, #0]
 	tst	\tmp, #HWCAP_VFPD32
-	stcnel	p11, cr0, [\base],#32*4		    @ FSTMIAD \base!, {d16-d31}
+	stclne	p11, cr0, [\base],#32*4		    @ FSTMIAD \base!, {d16-d31}
 	addeq	\base, \base, #32*4		    @ step over unused register space
 #else
 	VFPFMRX	\tmp, MVFR0			    @ Media and VFP Feature Register 0
 	and	\tmp, \tmp, #MVFR0_A_SIMD_MASK	    @ A_SIMD field
 	cmp	\tmp, #2			    @ 32 x 64bit registers?
-	stceql	p11, cr0, [\base],#32*4		    @ FSTMIAD \base!, {d16-d31}
+	stcleq	p11, cr0, [\base],#32*4		    @ FSTMIAD \base!, {d16-d31}
 	addne	\base, \base, #32*4		    @ step over unused register space
 #endif
 #endif
diff --git a/arch/arm/lib/bitops.h b/arch/arm/lib/bitops.h
index 93cddab73072..95bd35991288 100644
--- a/arch/arm/lib/bitops.h
+++ b/arch/arm/lib/bitops.h
@@ -7,7 +7,7 @@
 ENTRY(	\name		)
 UNWIND(	.fnstart	)
 	ands	ip, r1, #3
-	strneb	r1, [ip]		@ assert word-aligned
+	strbne	r1, [ip]		@ assert word-aligned
 	mov	r2, #1
 	and	r3, r0, #31		@ Get bit offset
 	mov	r0, r0, lsr #5
@@ -32,7 +32,7 @@ ENDPROC(\name		)
 ENTRY(	\name		)
 UNWIND(	.fnstart	)
 	ands	ip, r1, #3
-	strneb	r1, [ip]		@ assert word-aligned
+	strbne	r1, [ip]		@ assert word-aligned
 	mov	r2, #1
 	and	r3, r0, #31		@ Get bit offset
 	mov	r0, r0, lsr #5
@@ -62,7 +62,7 @@ ENDPROC(\name		)
 ENTRY(	\name		)
 UNWIND(	.fnstart	)
 	ands	ip, r1, #3
-	strneb	r1, [ip]		@ assert word-aligned
+	strbne	r1, [ip]		@ assert word-aligned
 	and	r2, r0, #31
 	mov	r0, r0, lsr #5
 	mov	r3, #1
@@ -89,7 +89,7 @@ ENDPROC(\name		)
 ENTRY(	\name		)
 UNWIND(	.fnstart	)
 	ands	ip, r1, #3
-	strneb	r1, [ip]		@ assert word-aligned
+	strbne	r1, [ip]		@ assert word-aligned
 	and	r3, r0, #31
 	mov	r0, r0, lsr #5
 	save_and_disable_irqs ip
-- 
2.25.1



