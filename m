Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AD94F032F
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 15:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243328AbiDBNyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 09:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243365AbiDBNya (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 09:54:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D6213DFD
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 06:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D224B8085E
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 13:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F94C340EE;
        Sat,  2 Apr 2022 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648907555;
        bh=KptHsWNGbgaOgbs8vG2YBCjHZyGo8PkmqpQ/+j7rT9I=;
        h=Subject:To:Cc:From:Date:From;
        b=sngrRD3sksBVb+cxHjGX1Vto+9yT91mVyVz642e9Al2G54V/YIaas3Wx0I4M1/Vpy
         hzALfvjD+e2pMkTdKn2HAQdX+NjZf5aUBa93S8ovWGZRLFc+IQgXhX5uItY6whgFGI
         /XrnvJO2DJjQx9UNo8dUxg7wRRiAPCuFX1KbLK5I=
Subject: FAILED: patch "[PATCH] powerpc/tm: Fix more userspace r13 corruption" failed to apply to 5.15-stable tree
To:     npiggin@gmail.com, mikey@neuling.org, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 15:52:27 +0200
Message-ID: <1648907547218245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9d71165d3934e607070c4e48458c0cf161b1baea Mon Sep 17 00:00:00 2001
From: Nicholas Piggin <npiggin@gmail.com>
Date: Fri, 11 Mar 2022 12:47:33 +1000
Subject: [PATCH] powerpc/tm: Fix more userspace r13 corruption

Commit cf13435b730a ("powerpc/tm: Fix userspace r13 corruption") fixes a
problem in treclaim where a SLB miss can occur on the
thread_struct->ckpt_regs while SCRATCH0 is live with the saved user r13
value, clobbering it with the kernel r13 and ultimately resulting in
kernel r13 being stored in ckpt_regs.

There is an equivalent problem in trechkpt where the user r13 value is
loaded into r13 from chkpt_regs to be recheckpointed, but a SLB miss
could occur on ckpt_regs accesses after that, which will result in r13
being clobbered with a kernel value and that will get recheckpointed and
then restored to user registers.

The same memory page is accessed right before this critical window where
a SLB miss could cause corruption, so hitting the bug requires the SLB
entry be removed within a small window of instructions, which is
possible if a SLB related MCE hits there. PAPR also permits the
hypervisor to discard this SLB entry (because slb_shadow->persistent is
only set to SLB_NUM_BOLTED) although it's not known whether any
implementations would do this (KVM does not). So this is an extremely
unlikely bug, only found by inspection.

Fix this by also storing user r13 in a temporary location on the kernel
stack and don't change the r13 register from kernel r13 until the RI=0
critical section that does not fault.

The SCRATCH0 change is not strictly part of the fix, it's only used in
the RI=0 section so it does not have the same problem as the previous
SCRATCH0 bug.

Fixes: 98ae22e15b43 ("powerpc: Add helper functions for transactional memory context switching")
Cc: stable@vger.kernel.org # v3.9+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220311024733.48926-1-npiggin@gmail.com

diff --git a/arch/powerpc/kernel/tm.S b/arch/powerpc/kernel/tm.S
index 3beecc32940b..5a0f023a26e9 100644
--- a/arch/powerpc/kernel/tm.S
+++ b/arch/powerpc/kernel/tm.S
@@ -443,7 +443,8 @@ restore_gprs:
 
 	REST_GPR(0, r7)				/* GPR0 */
 	REST_GPRS(2, 4, r7)			/* GPR2-4 */
-	REST_GPRS(8, 31, r7)			/* GPR8-31 */
+	REST_GPRS(8, 12, r7)			/* GPR8-12 */
+	REST_GPRS(14, 31, r7)			/* GPR14-31 */
 
 	/* Load up PPR and DSCR here so we don't run with user values for long */
 	mtspr	SPRN_DSCR, r5
@@ -479,18 +480,24 @@ restore_gprs:
 	REST_GPR(6, r7)
 
 	/*
-	 * Store r1 and r5 on the stack so that we can access them after we
-	 * clear MSR RI.
+	 * Store user r1 and r5 and r13 on the stack (in the unused save
+	 * areas / compiler reserved areas), so that we can access them after
+	 * we clear MSR RI.
 	 */
 
 	REST_GPR(5, r7)
 	std	r5, -8(r1)
-	ld	r5, GPR1(r7)
+	ld	r5, GPR13(r7)
 	std	r5, -16(r1)
+	ld	r5, GPR1(r7)
+	std	r5, -24(r1)
 
 	REST_GPR(7, r7)
 
-	/* Clear MSR RI since we are about to use SCRATCH0. EE is already off */
+	/* Stash the stack pointer away for use after recheckpoint */
+	std	r1, PACAR1(r13)
+
+	/* Clear MSR RI since we are about to clobber r13. EE is already off */
 	li	r5, 0
 	mtmsrd	r5, 1
 
@@ -501,9 +508,9 @@ restore_gprs:
 	 * until we turn MSR RI back on.
 	 */
 
-	SET_SCRATCH0(r1)
 	ld	r5, -8(r1)
-	ld	r1, -16(r1)
+	ld	r13, -16(r1)
+	ld	r1, -24(r1)
 
 	/* Commit register state as checkpointed state: */
 	TRECHKPT
@@ -519,9 +526,9 @@ restore_gprs:
 	 */
 
 	GET_PACA(r13)
-	GET_SCRATCH0(r1)
+	ld	r1, PACAR1(r13)
 
-	/* R1 is restored, so we are recoverable again.  EE is still off */
+	/* R13, R1 is restored, so we are recoverable again.  EE is still off */
 	li	r4, MSR_RI
 	mtmsrd	r4, 1
 

