Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392A71F355
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfEOLFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbfEOLFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:05:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6178420644;
        Wed, 15 May 2019 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918305;
        bh=VfG4OsMsQwaK+1+mdbKg5xJkMQBl0SCgswolaF+WhKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8a0c6HV12fORdzw6GmKI7wmqBsF+dJc9QkSlaN+sNnb/UurScTN9xG5hl5hm9qnO
         8SQXLOXmpcOH66ClNMN3ulglwppw712PzFJcytQonRGztK0lAcQIcMzZ2fXnWco04C
         1XHPSZ0AaNxf3F0Tpe/Qt6c40TZSifVJgFOV0CSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "linuxppc-dev@ozlabs.org, mpe@ellerman.id.au, Diana Craciun" 
        <diana.craciun@nxp.com>, Michael Ellerman <mpe@ellerman.id.au>,
        Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH 4.4 084/266] powerpc/fsl: Fixed warning: orphan section `__btb_flush_fixup
Date:   Wed, 15 May 2019 12:53:11 +0200
Message-Id: <20190515090725.285791706@linuxfoundation.org>
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

commit 039daac5526932ec731e4499613018d263af8b3e upstream.

Fixed the following build warning:
powerpc-linux-gnu-ld: warning: orphan section `__btb_flush_fixup' from
`arch/powerpc/kernel/head_44x.o' being placed in section
`__btb_flush_fixup'.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/head_booke.h |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

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


