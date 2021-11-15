Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588854523F4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350780AbhKPBfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242343AbhKOSfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:35:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C3FD6346B;
        Mon, 15 Nov 2021 18:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999297;
        bh=j7UZxed489Gx9XufyhFLEhJgw0gm0+qE3ZlPd1RA0ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHZQiNxB0D2HCkH6wSmK8v6EaVnfzCekd7To9y8sZYjDT3IB4IF1+mIbosZS2cNQ3
         ywFq4zaXm+8oAYvD9BbPovtjVLwsMwJ2vbgpPbatvklBKHhdouu02mBmvCFtuoc+s3
         /JSekPsuNVI1e4yPGjIcmOKfnouVk/eknleKCDiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Wood <swood@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 212/849] rcutorture: Avoid problematic critical section nesting on PREEMPT_RT
Date:   Mon, 15 Nov 2021 17:54:55 +0100
Message-Id: <20211115165427.382498779@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Wood <swood@redhat.com>

[ Upstream commit 71921a9606ddbcc1d98c00eca7ae82c373d1fecd ]

rcutorture is generating some nesting scenarios that are not compatible on PREEMPT_RT.
For example:
	preempt_disable();
	rcu_read_lock_bh();
	preempt_enable();
	rcu_read_unlock_bh();

The problem here is that on PREEMPT_RT the bottom halves have to be
disabled and enabled in preemptible context.

Reorder locking: start with BH locking and continue with then with
disabling preemption or interrupts. In the unlocking do it reverse by
first enabling interrupts and preemption and BH at the very end.
Ensure that on PREEMPT_RT BH locking remains unchanged if in
non-preemptible context.

Link: https://lkml.kernel.org/r/20190911165729.11178-6-swood@redhat.com
Link: https://lkml.kernel.org/r/20210819182035.GF4126399@paulmck-ThinkPad-P17-Gen-1
Signed-off-by: Scott Wood <swood@redhat.com>
[bigeasy: Drop ATOM_BH, make it only about changing BH in atomic
context. Allow enabling RCU in IRQ-off section. Reword commit message.]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 48 ++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 40ef5417d9545..d2ef535530b10 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1432,28 +1432,34 @@ static void rcutorture_one_extend(int *readstate, int newstate,
 	/* First, put new protection in place to avoid critical-section gap. */
 	if (statesnew & RCUTORTURE_RDR_BH)
 		local_bh_disable();
+	if (statesnew & RCUTORTURE_RDR_RBH)
+		rcu_read_lock_bh();
 	if (statesnew & RCUTORTURE_RDR_IRQ)
 		local_irq_disable();
 	if (statesnew & RCUTORTURE_RDR_PREEMPT)
 		preempt_disable();
-	if (statesnew & RCUTORTURE_RDR_RBH)
-		rcu_read_lock_bh();
 	if (statesnew & RCUTORTURE_RDR_SCHED)
 		rcu_read_lock_sched();
 	if (statesnew & RCUTORTURE_RDR_RCU)
 		idxnew = cur_ops->readlock() << RCUTORTURE_RDR_SHIFT;
 
-	/* Next, remove old protection, irq first due to bh conflict. */
+	/*
+	 * Next, remove old protection, in decreasing order of strength
+	 * to avoid unlock paths that aren't safe in the stronger
+	 * context. Namely: BH can not be enabled with disabled interrupts.
+	 * Additionally PREEMPT_RT requires that BH is enabled in preemptible
+	 * context.
+	 */
 	if (statesold & RCUTORTURE_RDR_IRQ)
 		local_irq_enable();
-	if (statesold & RCUTORTURE_RDR_BH)
-		local_bh_enable();
 	if (statesold & RCUTORTURE_RDR_PREEMPT)
 		preempt_enable();
-	if (statesold & RCUTORTURE_RDR_RBH)
-		rcu_read_unlock_bh();
 	if (statesold & RCUTORTURE_RDR_SCHED)
 		rcu_read_unlock_sched();
+	if (statesold & RCUTORTURE_RDR_BH)
+		local_bh_enable();
+	if (statesold & RCUTORTURE_RDR_RBH)
+		rcu_read_unlock_bh();
 	if (statesold & RCUTORTURE_RDR_RCU) {
 		bool lockit = !statesnew && !(torture_random(trsp) & 0xffff);
 
@@ -1496,6 +1502,9 @@ rcutorture_extend_mask(int oldmask, struct torture_random_state *trsp)
 	int mask = rcutorture_extend_mask_max();
 	unsigned long randmask1 = torture_random(trsp) >> 8;
 	unsigned long randmask2 = randmask1 >> 3;
+	unsigned long preempts = RCUTORTURE_RDR_PREEMPT | RCUTORTURE_RDR_SCHED;
+	unsigned long preempts_irq = preempts | RCUTORTURE_RDR_IRQ;
+	unsigned long bhs = RCUTORTURE_RDR_BH | RCUTORTURE_RDR_RBH;
 
 	WARN_ON_ONCE(mask >> RCUTORTURE_RDR_SHIFT);
 	/* Mostly only one bit (need preemption!), sometimes lots of bits. */
@@ -1503,11 +1512,26 @@ rcutorture_extend_mask(int oldmask, struct torture_random_state *trsp)
 		mask = mask & randmask2;
 	else
 		mask = mask & (1 << (randmask2 % RCUTORTURE_RDR_NBITS));
-	/* Can't enable bh w/irq disabled. */
-	if ((mask & RCUTORTURE_RDR_IRQ) &&
-	    ((!(mask & RCUTORTURE_RDR_BH) && (oldmask & RCUTORTURE_RDR_BH)) ||
-	     (!(mask & RCUTORTURE_RDR_RBH) && (oldmask & RCUTORTURE_RDR_RBH))))
-		mask |= RCUTORTURE_RDR_BH | RCUTORTURE_RDR_RBH;
+
+	/*
+	 * Can't enable bh w/irq disabled.
+	 */
+	if (mask & RCUTORTURE_RDR_IRQ)
+		mask |= oldmask & bhs;
+
+	/*
+	 * Ideally these sequences would be detected in debug builds
+	 * (regardless of RT), but until then don't stop testing
+	 * them on non-RT.
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
+		/* Can't modify BH in atomic context */
+		if (oldmask & preempts_irq)
+			mask &= ~bhs;
+		if ((oldmask | mask) & preempts_irq)
+			mask |= oldmask & bhs;
+	}
+
 	return mask ?: RCUTORTURE_RDR_RCU;
 }
 
-- 
2.33.0



