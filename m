Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4C62BA7E5
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgKTLDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:03:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgKTLDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:03:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3DA3206E3;
        Fri, 20 Nov 2020 11:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870200;
        bh=j80G1CmC5IA2HvZlRbmXBMsft86w8eemJb0r1ujRnwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGHB+UWFZBfpo4BT6eDpoF9lCr3gaI9aZjcOOzAc/Iz9q1J9rwogDPRm3F62YsVgV
         8z94EORhGVYTbsUcpxUxgp64SPZYdQT/gpAiGzDPkMd+sK/J5zi1w+xrYSSjPQy5ff
         82C0cGjTgmnXpMUTJdcPwNUy7MFx302lDWACBbS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net
Subject: [PATCH 4.4 02/15] powerpc/64s: move some exception handlers out of line
Date:   Fri, 20 Nov 2020 12:03:00 +0100
Message-Id: <20201120104539.660642010@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.534424264@linuxfoundation.org>
References: <20201120104539.534424264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

(backport only)

We're about to grow the exception handlers, which will make a bunch of them
no longer fit within the space available. We move them out of line.

This is a fiddly and error-prone business, so in the interests of reviewability
I haven't merged this in with the addition of the entry flush.

Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/exceptions-64s.S |  138 ++++++++++++++++++++++-------------
 1 file changed, 90 insertions(+), 48 deletions(-)

--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -202,8 +202,8 @@ ALT_FTR_SECTION_END_IFSET(CPU_FTR_HVMODE
 data_access_pSeries:
 	HMT_MEDIUM_PPR_DISCARD
 	SET_SCRATCH0(r13)
-	EXCEPTION_PROLOG_PSERIES(PACA_EXGEN, data_access_common, EXC_STD,
-				 KVMTEST, 0x300)
+	EXCEPTION_PROLOG_0(PACA_EXGEN)
+	b data_access_pSeries_ool
 
 	. = 0x380
 	.globl data_access_slb_pSeries
@@ -211,31 +211,15 @@ data_access_slb_pSeries:
 	HMT_MEDIUM_PPR_DISCARD
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXSLB)
-	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST, 0x380)
-	std	r3,PACA_EXSLB+EX_R3(r13)
-	mfspr	r3,SPRN_DAR
-#ifdef __DISABLED__
-	/* Keep that around for when we re-implement dynamic VSIDs */
-	cmpdi	r3,0
-	bge	slb_miss_user_pseries
-#endif /* __DISABLED__ */
-	mfspr	r12,SPRN_SRR1
-#ifndef CONFIG_RELOCATABLE
-	b	slb_miss_realmode
-#else
-	/*
-	 * We can't just use a direct branch to slb_miss_realmode
-	 * because the distance from here to there depends on where
-	 * the kernel ends up being put.
-	 */
-	mfctr	r11
-	ld	r10,PACAKBASE(r13)
-	LOAD_HANDLER(r10, slb_miss_realmode)
-	mtctr	r10
-	bctr
-#endif
+	b data_access_slb_pSeries_ool
 
-	STD_EXCEPTION_PSERIES(0x400, 0x400, instruction_access)
+	. = 0x400
+	.globl instruction_access_pSeries
+instruction_access_pSeries:
+	HMT_MEDIUM_PPR_DISCARD
+	SET_SCRATCH0(r13)
+	EXCEPTION_PROLOG_0(PACA_EXGEN)
+	b instruction_access_pSeries_ool
 
 	. = 0x480
 	.globl instruction_access_slb_pSeries
@@ -243,24 +227,7 @@ instruction_access_slb_pSeries:
 	HMT_MEDIUM_PPR_DISCARD
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXSLB)
-	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST_PR, 0x480)
-	std	r3,PACA_EXSLB+EX_R3(r13)
-	mfspr	r3,SPRN_SRR0		/* SRR0 is faulting address */
-#ifdef __DISABLED__
-	/* Keep that around for when we re-implement dynamic VSIDs */
-	cmpdi	r3,0
-	bge	slb_miss_user_pseries
-#endif /* __DISABLED__ */
-	mfspr	r12,SPRN_SRR1
-#ifndef CONFIG_RELOCATABLE
-	b	slb_miss_realmode
-#else
-	mfctr	r11
-	ld	r10,PACAKBASE(r13)
-	LOAD_HANDLER(r10, slb_miss_realmode)
-	mtctr	r10
-	bctr
-#endif
+	b instruction_access_slb_pSeries_ool
 
 	/* We open code these as we can't have a ". = x" (even with
 	 * x = "." within a feature section
@@ -291,13 +258,19 @@ hardware_interrupt_hv:
 	KVM_HANDLER_PR(PACA_EXGEN, EXC_STD, 0x800)
 
 	. = 0x900
-	.globl decrementer_pSeries
-decrementer_pSeries:
+	.globl decrementer_trampoline
+decrementer_trampoline:
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXGEN)
 	b	decrementer_ool
 
-	STD_EXCEPTION_HV(0x980, 0x982, hdecrementer)
+	. = 0x980
+	.globl hdecrementer_trampoline
+hdecrementer_trampoline:
+	HMT_MEDIUM_PPR_DISCARD;
+	SET_SCRATCH0(r13);
+	EXCEPTION_PROLOG_0(PACA_EXGEN)
+	b hdecrementer_hv
 
 	MASKABLE_EXCEPTION_PSERIES(0xa00, 0xa00, doorbell_super)
 	KVM_HANDLER_PR(PACA_EXGEN, EXC_STD, 0xa00)
@@ -545,6 +518,64 @@ machine_check_pSeries_0:
 	KVM_HANDLER_PR(PACA_EXGEN, EXC_STD, 0x900)
 	KVM_HANDLER(PACA_EXGEN, EXC_HV, 0x982)
 
+/* moved from 0x300 */
+	.globl data_access_pSeries_ool
+data_access_pSeries_ool:
+	EXCEPTION_PROLOG_1(PACA_EXGEN, KVMTEST, 0x300)
+	EXCEPTION_PROLOG_PSERIES_1(data_access_common, EXC_STD)
+
+	.globl data_access_slb_pSeries_ool
+data_access_slb_pSeries_ool:
+	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST, 0x380)
+	std	r3,PACA_EXSLB+EX_R3(r13)
+	mfspr	r3,SPRN_DAR
+#ifdef __DISABLED__
+	/* Keep that around for when we re-implement dynamic VSIDs */
+	cmpdi	r3,0
+	bge	slb_miss_user_pseries
+#endif /* __DISABLED__ */
+	mfspr	r12,SPRN_SRR1
+#ifndef CONFIG_RELOCATABLE
+	b	slb_miss_realmode
+#else
+	/*
+	 * We can't just use a direct branch to slb_miss_realmode
+	 * because the distance from here to there depends on where
+	 * the kernel ends up being put.
+	 */
+	mfctr	r11
+	ld	r10,PACAKBASE(r13)
+	LOAD_HANDLER(r10, slb_miss_realmode)
+	mtctr	r10
+	bctr
+#endif
+
+	.globl instruction_access_pSeries_ool
+instruction_access_pSeries_ool:
+	EXCEPTION_PROLOG_1(PACA_EXGEN, KVMTEST_PR, 0x400)
+	EXCEPTION_PROLOG_PSERIES_1(instruction_access_common, EXC_STD)
+
+	.globl instruction_access_slb_pSeries_ool
+instruction_access_slb_pSeries_ool:
+	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST_PR, 0x480)
+	std	r3,PACA_EXSLB+EX_R3(r13)
+	mfspr	r3,SPRN_SRR0		/* SRR0 is faulting address */
+#ifdef __DISABLED__
+	/* Keep that around for when we re-implement dynamic VSIDs */
+	cmpdi	r3,0
+	bge	slb_miss_user_pseries
+#endif /* __DISABLED__ */
+	mfspr	r12,SPRN_SRR1
+#ifndef CONFIG_RELOCATABLE
+	b	slb_miss_realmode
+#else
+	mfctr	r11
+	ld	r10,PACAKBASE(r13)
+	LOAD_HANDLER(r10, slb_miss_realmode)
+	mtctr	r10
+	bctr
+#endif
+
 #ifdef CONFIG_PPC_DENORMALISATION
 denorm_assist:
 BEGIN_FTR_SECTION
@@ -612,6 +643,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 	.align	7
 	/* moved from 0xe00 */
 	MASKABLE_EXCEPTION_OOL(0x900, decrementer)
+	STD_EXCEPTION_HV_OOL(0x982, hdecrementer)
 	STD_EXCEPTION_HV_OOL(0xe02, h_data_storage)
 	KVM_HANDLER_SKIP(PACA_EXGEN, EXC_HV, 0xe02)
 	STD_EXCEPTION_HV_OOL(0xe22, h_instr_storage)
@@ -894,7 +926,15 @@ hardware_interrupt_relon_hv:
 	STD_RELON_EXCEPTION_PSERIES(0x4600, 0x600, alignment)
 	STD_RELON_EXCEPTION_PSERIES(0x4700, 0x700, program_check)
 	STD_RELON_EXCEPTION_PSERIES(0x4800, 0x800, fp_unavailable)
-	MASKABLE_RELON_EXCEPTION_PSERIES(0x4900, 0x900, decrementer)
+
+	. = 0x4900
+	.globl decrementer_relon_trampoline
+decrementer_relon_trampoline:
+	HMT_MEDIUM_PPR_DISCARD
+	SET_SCRATCH0(r13)
+	EXCEPTION_PROLOG_0(PACA_EXGEN)
+	b decrementer_relon_pSeries
+
 	STD_RELON_EXCEPTION_HV(0x4980, 0x982, hdecrementer)
 	MASKABLE_RELON_EXCEPTION_PSERIES(0x4a00, 0xa00, doorbell_super)
 	STD_RELON_EXCEPTION_PSERIES(0x4b00, 0xb00, trap_0b)
@@ -1244,6 +1284,8 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX)
 __end_handlers:
 
 	/* Equivalents to the above handlers for relocation-on interrupt vectors */
+	MASKABLE_RELON_EXCEPTION_PSERIES_OOL(0x900, decrementer)
+
 	STD_RELON_EXCEPTION_HV_OOL(0xe40, emulation_assist)
 	MASKABLE_RELON_EXCEPTION_HV_OOL(0xe80, h_doorbell)
 


