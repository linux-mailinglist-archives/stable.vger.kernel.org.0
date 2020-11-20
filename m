Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897AC2B9F00
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 01:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgKTAHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 19:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgKTAHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 19:07:16 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D5AC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:16 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id a18so6115488pfl.3
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x3mxnXcy3kak4c4IfShbrcJe5LIJJZ7bgihtJ/TZs2w=;
        b=WbTa5VSrffa9VQ9cDIelO6GEeNYKAqHRjnWseil6u2u+oMgvxojhGGepBUFt8l6HnR
         eT6NoCu7JJW3mwQmfLC/HZz8fuOExTtpzoxRdlSo0tRVr7C7T8Lf7e/jlkcBe6d3LSU5
         Rp+PfDg9DPc4WO7aQmLyyhRxpknFLK1NPnPxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x3mxnXcy3kak4c4IfShbrcJe5LIJJZ7bgihtJ/TZs2w=;
        b=AwxXGz09bobRwDEg7ZWAuW8OGVEKZcLsORiOD7X6KfgfjNxzM4xRCA6Jvl9v9cnEdT
         k0v6X5/TJ0Ew+QI1Q4yTAwG/V+6wkRR1fwTCOO26LWCXEg0nDa59R7U+Xqa5I2a4bSgT
         mpCx1ggwhL5RsaHJZf8V+xBgx0bQifckndW8/8utVyfSK/xplEsQPUl9Zn6K1k+pDsSZ
         SsDepQDg6b4w4WC/WdcF9RSUZi2BDgJwKGU/OKyF2nGToEaWprZQFGoefmBtESWhf2Ut
         EvtqebRKwreLvJDLTgeHLOyzXUgkhZdotTx6jSPcyOidADZXtePD47b0nEYe2OC2BJKq
         JW7A==
X-Gm-Message-State: AOAM531m958ISu4qKvZwOWv1DVjly8yWMJrzgSUPzO6zZeOBJLX0vXQi
        jOoUTeE0kkmhNFK72fzr8jxEoCdA3YPDJw==
X-Google-Smtp-Source: ABdhPJyoXk6KL+e5AnWag6XBpkHGpkWrfvXOp8O4P23XWAZs+iJGs3dywHVVAZYSqWTMap/8Qog3jQ==
X-Received: by 2002:a17:90a:b118:: with SMTP id z24mr7400050pjq.102.1605830835912;
        Thu, 19 Nov 2020 16:07:15 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id d68sm1079933pfd.32.2020.11.19.16.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 16:07:15 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.4 2/8] powerpc/64s: move some exception handlers out of line
Date:   Fri, 20 Nov 2020 11:06:58 +1100
Message-Id: <20201120000704.374811-3-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120000704.374811-1-dja@axtens.net>
References: <20201120000704.374811-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(backport only)

We're about to grow the exception handlers, which will make a bunch of them
no longer fit within the space available. We move them out of line.

This is a fiddly and error-prone business, so in the interests of reviewability
I haven't merged this in with the addition of the entry flush.

Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 arch/powerpc/kernel/exceptions-64s.S | 138 +++++++++++++++++----------
 1 file changed, 90 insertions(+), 48 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 536718ed033f..3d843e1a162c 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -202,8 +202,8 @@ ALT_FTR_SECTION_END_IFSET(CPU_FTR_HVMODE)
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
 
-- 
2.25.1

