Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6014E6DF
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 17:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbfD2Ptj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 11:49:39 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36592 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728394AbfD2Pti (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 11:49:38 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4EC571A0020;
        Mon, 29 Apr 2019 17:49:37 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4280C1A017C;
        Mon, 29 Apr 2019 17:49:37 +0200 (CEST)
Received: from fsr-ub1664-009.ea.freescale.net (fsr-ub1664-009.ea.freescale.net [10.171.71.77])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 01467205EE;
        Mon, 29 Apr 2019 17:49:36 +0200 (CEST)
From:   Diana Craciun <diana.craciun@nxp.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     linuxppc-dev@ozlabs.org, mpe@ellerman.id.au,
        Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH stable v4.4 6/8] powerpc/fsl: Fixed warning: orphan section `__btb_flush_fixup'
Date:   Mon, 29 Apr 2019 18:49:06 +0300
Message-Id: <1556552948-24957-7-git-send-email-diana.craciun@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
References: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 039daac5526932ec731e4499613018d263af8b3e upstream.

Fixed the following build warning:
powerpc-linux-gnu-ld: warning: orphan section `__btb_flush_fixup' from
`arch/powerpc/kernel/head_44x.o' being placed in section
`__btb_flush_fixup'.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kernel/head_booke.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/head_booke.h b/arch/powerpc/kernel/head_booke.h
index 384bb4d80520..7b98c7351f6c 100644
--- a/arch/powerpc/kernel/head_booke.h
+++ b/arch/powerpc/kernel/head_booke.h
@@ -31,6 +31,16 @@
  */
 #define THREAD_NORMSAVE(offset)	(THREAD_NORMSAVES + (offset * 4))
 
+#ifdef CONFIG_PPC_FSL_BOOK3E
+#define BOOKE_CLEAR_BTB(reg)									\
+START_BTB_FLUSH_SECTION								\
+	BTB_FLUSH(reg)									\
+END_BTB_FLUSH_SECTION
+#else
+#define BOOKE_CLEAR_BTB(reg)
+#endif
+
+
 #define NORMAL_EXCEPTION_PROLOG(intno)						     \
 	mtspr	SPRN_SPRG_WSCRATCH0, r10;	/* save one register */	     \
 	mfspr	r10, SPRN_SPRG_THREAD;					     \
@@ -42,9 +52,7 @@
 	andi.	r11, r11, MSR_PR;	/* check whether user or kernel    */\
 	mr	r11, r1;						     \
 	beq	1f;							     \
-START_BTB_FLUSH_SECTION					\
-	BTB_FLUSH(r11)						\
-END_BTB_FLUSH_SECTION					\
+	BOOKE_CLEAR_BTB(r11)						\
 	/* if from user, start at top of this thread's kernel stack */       \
 	lwz	r11, THREAD_INFO-THREAD(r10);				     \
 	ALLOC_STACK_FRAME(r11, THREAD_SIZE);				     \
@@ -130,9 +138,7 @@ END_BTB_FLUSH_SECTION					\
 	stw	r9,_CCR(r8);		/* save CR on stack		   */\
 	mfspr	r11,exc_level_srr1;	/* check whether user or kernel    */\
 	DO_KVM	BOOKE_INTERRUPT_##intno exc_level_srr1;		             \
-START_BTB_FLUSH_SECTION								\
-	BTB_FLUSH(r10)									\
-END_BTB_FLUSH_SECTION								\
+	BOOKE_CLEAR_BTB(r10)						\
 	andi.	r11,r11,MSR_PR;						     \
 	mfspr	r11,SPRN_SPRG_THREAD;	/* if from user, start at top of   */\
 	lwz	r11,THREAD_INFO-THREAD(r11); /* this thread's kernel stack */\
-- 
2.17.1

