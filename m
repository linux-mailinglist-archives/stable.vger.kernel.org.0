Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5CD1ED14
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfEOLFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbfEOLFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:05:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 079D320644;
        Wed, 15 May 2019 11:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918300;
        bh=MVSi9+4aGNxazG7TY3wX6HPB6MKEvtgGe40WlH0s/pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgbwhnGWaMe7VsP50DBri/zH/dVh949gRAxImRAOgN56ao9eXkwdUUndLXmML732P
         9VecjeRrf5qA3Z0DrPVl/YdylSIYS80adr+CjaWdP5L2V9rQEK44OvCTr5ZPgKhONs
         JQNFyftPh4kHnkWBGZ8Zl09wXAkyt7aXfErxiRks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "linuxppc-dev@ozlabs.org, mpe@ellerman.id.au, Diana Craciun" 
        <diana.craciun@nxp.com>, Michael Ellerman <mpe@ellerman.id.au>,
        Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH 4.4 082/266] powerpc/fsl: Flush the branch predictor at each kernel entry (32 bit)
Date:   Wed, 15 May 2019 12:53:09 +0200
Message-Id: <20190515090725.217167197@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diana Craciun <diana.craciun@nxp.com>

commit 7fef436295bf6c05effe682c8797dfcb0deb112a upstream.

In order to protect against speculation attacks on
indirect branches, the branch predictor is flushed at
kernel entry to protect for the following situations:
- userspace process attacking another userspace process
- userspace process attacking the kernel
Basically when the privillege level change (i.e.the kernel
is entered), the branch predictor state is flushed.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/head_booke.h     |    6 ++++++
 arch/powerpc/kernel/head_fsl_booke.S |   15 +++++++++++++++
 2 files changed, 21 insertions(+)

--- a/arch/powerpc/kernel/head_booke.h
+++ b/arch/powerpc/kernel/head_booke.h
@@ -42,6 +42,9 @@
 	andi.	r11, r11, MSR_PR;	/* check whether user or kernel    */\
 	mr	r11, r1;						     \
 	beq	1f;							     \
+START_BTB_FLUSH_SECTION					\
+	BTB_FLUSH(r11)						\
+END_BTB_FLUSH_SECTION					\
 	/* if from user, start at top of this thread's kernel stack */       \
 	lwz	r11, THREAD_INFO-THREAD(r10);				     \
 	ALLOC_STACK_FRAME(r11, THREAD_SIZE);				     \
@@ -127,6 +130,9 @@
 	stw	r9,_CCR(r8);		/* save CR on stack		   */\
 	mfspr	r11,exc_level_srr1;	/* check whether user or kernel    */\
 	DO_KVM	BOOKE_INTERRUPT_##intno exc_level_srr1;		             \
+START_BTB_FLUSH_SECTION								\
+	BTB_FLUSH(r10)									\
+END_BTB_FLUSH_SECTION								\
 	andi.	r11,r11,MSR_PR;						     \
 	mfspr	r11,SPRN_SPRG_THREAD;	/* if from user, start at top of   */\
 	lwz	r11,THREAD_INFO-THREAD(r11); /* this thread's kernel stack */\
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -451,6 +451,13 @@ END_FTR_SECTION_IFSET(CPU_FTR_EMB_HV)
 	mfcr	r13
 	stw	r13, THREAD_NORMSAVE(3)(r10)
 	DO_KVM	BOOKE_INTERRUPT_DTLB_MISS SPRN_SRR1
+START_BTB_FLUSH_SECTION
+	mfspr r11, SPRN_SRR1
+	andi. r10,r11,MSR_PR
+	beq 1f
+	BTB_FLUSH(r10)
+1:
+END_BTB_FLUSH_SECTION
 	mfspr	r10, SPRN_DEAR		/* Get faulting address */
 
 	/* If we are faulting a kernel address, we have to use the
@@ -545,6 +552,14 @@ END_FTR_SECTION_IFSET(CPU_FTR_EMB_HV)
 	mfcr	r13
 	stw	r13, THREAD_NORMSAVE(3)(r10)
 	DO_KVM	BOOKE_INTERRUPT_ITLB_MISS SPRN_SRR1
+START_BTB_FLUSH_SECTION
+	mfspr r11, SPRN_SRR1
+	andi. r10,r11,MSR_PR
+	beq 1f
+	BTB_FLUSH(r10)
+1:
+END_BTB_FLUSH_SECTION
+
 	mfspr	r10, SPRN_SRR0		/* Get faulting address */
 
 	/* If we are faulting a kernel address, we have to use the


