Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539FB40C72B
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 16:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbhIOOOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 10:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233782AbhIOOOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 10:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B207B6112E;
        Wed, 15 Sep 2021 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631715216;
        bh=VLTqeW2ksxe3x1aS5RB4OgaBwOKelZsEoGRpdh4+PiM=;
        h=Subject:To:Cc:From:Date:From;
        b=ZzASi/sxOjsZR3Lgsm3sum23GJRarvfHTjVfnkJwjOU93lPRV96RF24TMR0YPI4N9
         fv/RTrcy8dfc3kgGXwQFQrUlfJPu81AxWjbrNiwt4S70DzhDHg184vSyW+CxnH4WFQ
         WHEafyzAFGi8ARKvOnJiVCINhkVw0OHzRI/qqG8s=
Subject: FAILED: patch "[PATCH] sched: Prevent balance_push() on remote runqueues" failed to apply to 5.13-stable tree
To:     tglx@linutronix.de, bigeasy@linutronix.de, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 16:13:33 +0200
Message-ID: <1631715213238253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 868ad33bfa3bf39960982682ad3a0f8ebda1656e Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 28 Aug 2021 15:55:52 +0200
Subject: [PATCH] sched: Prevent balance_push() on remote runqueues

sched_setscheduler() and rt_mutex_setprio() invoke the run-queue balance
callback after changing priorities or the scheduling class of a task. The
run-queue for which the callback is invoked can be local or remote.

That's not a problem for the regular rq::push_work which is serialized with
a busy flag in the run-queue struct, but for the balance_push() work which
is only valid to be invoked on the outgoing CPU that's wrong. It not only
triggers the debug warning, but also leaves the per CPU variable push_work
unprotected, which can result in double enqueues on the stop machine list.

Remove the warning and validate that the function is invoked on the
outgoing CPU.

Fixes: ae7927023243 ("sched: Optimize finish_lock_switch()")
Reported-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/87zgt1hdw7.ffs@tglx

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f3b27c6c5153..b21a1857b75a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8523,7 +8523,6 @@ static void balance_push(struct rq *rq)
 	struct task_struct *push_task = rq->curr;
 
 	lockdep_assert_rq_held(rq);
-	SCHED_WARN_ON(rq->cpu != smp_processor_id());
 
 	/*
 	 * Ensure the thing is persistent until balance_push_set(.on = false);
@@ -8531,9 +8530,10 @@ static void balance_push(struct rq *rq)
 	rq->balance_callback = &balance_push_callback;
 
 	/*
-	 * Only active while going offline.
+	 * Only active while going offline and when invoked on the outgoing
+	 * CPU.
 	 */
-	if (!cpu_dying(rq->cpu))
+	if (!cpu_dying(rq->cpu) || rq != this_rq())
 		return;
 
 	/*

