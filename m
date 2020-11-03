Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297F02A5256
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbgKCUtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731682AbgKCUtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C48C20719;
        Tue,  3 Nov 2020 20:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436539;
        bh=Fpydzvaweo0Y+3y3QPw0J6GRZc5CxqW6NB98jym14QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAAV6PGBPrd6rEBpYil9M1JsEwpZKR3Vcg96fsiGskBmXdaH/DAmulpRd2Sb6RSQ+
         96Vkkfbz3EFDuxssVaGOWyiyHD61nQ8F9BsF9HTbOJDuGqbrLA9WIPIO9Pt7xKNSvg
         Ht5/Ocpug+9gevr8/TQD5VcDjyYD+mjquAPXXRZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 293/391] powerpc/32: Fix vmap stack - Do not activate MMU before reading task struct
Date:   Tue,  3 Nov 2020 21:35:44 +0100
Message-Id: <20201103203406.843607550@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit c118c7303ad528be8ff2aea8cd1ee15452c763f0 upstream.

We need r1 to be properly set before activating MMU, so
reading task_struct->stack must be done with MMU off.

This means we need an additional register to play with MSR
bits while r11 now points to the stack. For that, move r10
back to CR (As is already done for hash MMU) and use r10.

We still don't have r1 correct yet when we activate MMU.
It is done in following patch.

Fixes: 028474876f47 ("powerpc/32: prepare for CONFIG_VMAP_STACK")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a027d447022a006c9c4958ac734128e577a3c5c1.1599486108.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_32.S |    6 ------
 arch/powerpc/kernel/head_32.h |   31 ++++++-------------------------
 2 files changed, 6 insertions(+), 31 deletions(-)

--- a/arch/powerpc/kernel/head_32.S
+++ b/arch/powerpc/kernel/head_32.S
@@ -274,14 +274,8 @@ __secondary_hold_acknowledge:
 	DO_KVM  0x200
 MachineCheck:
 	EXCEPTION_PROLOG_0
-#ifdef CONFIG_VMAP_STACK
-	li	r11, MSR_KERNEL & ~(MSR_IR | MSR_RI) /* can take DTLB miss */
-	mtmsr	r11
-	isync
-#endif
 #ifdef CONFIG_PPC_CHRP
 	mfspr	r11, SPRN_SPRG_THREAD
-	tovirt_vmstack r11, r11
 	lwz	r11, RTAS_SP(r11)
 	cmpwi	cr1, r11, 0
 	bne	cr1, 7f
--- a/arch/powerpc/kernel/head_32.h
+++ b/arch/powerpc/kernel/head_32.h
@@ -39,24 +39,13 @@
 .endm
 
 .macro EXCEPTION_PROLOG_1 for_rtas=0
-#ifdef CONFIG_VMAP_STACK
-	.ifeq	\for_rtas
-	li	r11, MSR_KERNEL & ~(MSR_IR | MSR_RI) /* can take DTLB miss */
-	mtmsr	r11
-	isync
-	.endif
 	subi	r11, r1, INT_FRAME_SIZE		/* use r1 if kernel */
-#else
-	tophys(r11,r1)			/* use tophys(r1) if kernel */
-	subi	r11, r11, INT_FRAME_SIZE	/* alloc exc. frame */
-#endif
 	beq	1f
 	mfspr	r11,SPRN_SPRG_THREAD
-	tovirt_vmstack r11, r11
 	lwz	r11,TASK_STACK-THREAD(r11)
 	addi	r11, r11, THREAD_SIZE - INT_FRAME_SIZE
-	tophys_novmstack r11, r11
 1:
+	tophys_novmstack r11, r11
 #ifdef CONFIG_VMAP_STACK
 	mtcrf	0x7f, r11
 	bt	32 - THREAD_ALIGN_SHIFT, stack_overflow
@@ -64,12 +53,11 @@
 .endm
 
 .macro EXCEPTION_PROLOG_2 handle_dar_dsisr=0
-#if defined(CONFIG_VMAP_STACK) && defined(CONFIG_PPC_BOOK3S)
-BEGIN_MMU_FTR_SECTION
+#ifdef CONFIG_VMAP_STACK
 	mtcr	r10
-FTR_SECTION_ELSE
-	stw	r10, _CCR(r11)
-ALT_MMU_FTR_SECTION_END_IFSET(MMU_FTR_HPTE_TABLE)
+	li	r10, MSR_KERNEL & ~(MSR_IR | MSR_RI) /* can take DTLB miss */
+	mtmsr	r10
+	isync
 #else
 	stw	r10,_CCR(r11)		/* save registers */
 #endif
@@ -77,11 +65,9 @@ ALT_MMU_FTR_SECTION_END_IFSET(MMU_FTR_HP
 	stw	r12,GPR12(r11)
 	stw	r9,GPR9(r11)
 	stw	r10,GPR10(r11)
-#if defined(CONFIG_VMAP_STACK) && defined(CONFIG_PPC_BOOK3S)
-BEGIN_MMU_FTR_SECTION
+#ifdef CONFIG_VMAP_STACK
 	mfcr	r10
 	stw	r10, _CCR(r11)
-END_MMU_FTR_SECTION_IFSET(MMU_FTR_HPTE_TABLE)
 #endif
 	mfspr	r12,SPRN_SPRG_SCRATCH1
 	stw	r12,GPR11(r11)
@@ -97,11 +83,7 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_HPTE_T
 	stw	r10, _DSISR(r11)
 	.endif
 	lwz	r9, SRR1(r12)
-#if defined(CONFIG_VMAP_STACK) && defined(CONFIG_PPC_BOOK3S)
-BEGIN_MMU_FTR_SECTION
 	andi.	r10, r9, MSR_PR
-END_MMU_FTR_SECTION_IFSET(MMU_FTR_HPTE_TABLE)
-#endif
 	lwz	r12, SRR0(r12)
 #else
 	mfspr	r12,SPRN_SRR0
@@ -328,7 +310,6 @@ label:
 #ifdef CONFIG_VMAP_STACK
 #ifdef CONFIG_SMP
 	mfspr	r11, SPRN_SPRG_THREAD
-	tovirt(r11, r11)
 	lwz	r11, TASK_CPU - THREAD(r11)
 	slwi	r11, r11, 3
 	addis	r11, r11, emergency_ctx@ha


