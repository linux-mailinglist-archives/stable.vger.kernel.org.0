Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172CA68BFB9
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 15:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjBFOOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 09:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjBFONo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 09:13:44 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA862658E;
        Mon,  6 Feb 2023 06:13:06 -0800 (PST)
Date:   Mon, 06 Feb 2023 14:12:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675692766;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hj0Mhlus84qc7jbWOcuoPYl/kpgWwsAus+jEFc07HZo=;
        b=C0LZxnQxFSP0wZGizyg93du+bTSseKLtNC3wxFlHAeX4xUKOT5eW6rMRDJFSIJuJb9QxUF
        N79KekZNrkhC30W8u68rQ2MFD4iQNV4wWKElvlG3WTceWqSyMttSaQns+O6rTmLRKIYkyh
        8YGu25NLOe4Lh+xCq5AG16On1xRAPFhMi/Tnee8gqOusvNSGv7f8ga8fTunBvn+AWWOeqN
        /3lKgUi+oL5oPRhWukcSZzIWeLA4cMPa5lWad5EVTM318IdvBoeoJfdAfhi2cRDfv0zPMP
        9RluZEPUvlN3X0cdksgQcd+vlL37yu6y22ziBMf1tNimdwxX9O5lTOaFRDfGUw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675692766;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hj0Mhlus84qc7jbWOcuoPYl/kpgWwsAus+jEFc07HZo=;
        b=a9gsloaxOMV1e6d6nOv/FFKRBuTrDfdPvbYLmYM5oiFqJTgzi4l1W7BRNtlGyOlVzzihRc
        fShbNwGf+EcdDFCg==
From:   "tip-bot2 for Wander Lairson Costa" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] rtmutex: Ensure that the top waiter is always woken up
Cc:     Wander Lairson Costa <wander@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20230117172649.52465-1-wander@redhat.com>
References: <20230117172649.52465-1-wander@redhat.com>
MIME-Version: 1.0
Message-ID: <167569276573.4906.7991545915243537568.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     db370a8b9f67ae5f17e3d5482493294467784504
Gitweb:        https://git.kernel.org/tip/db370a8b9f67ae5f17e3d5482493294467784504
Author:        Wander Lairson Costa <wander@redhat.com>
AuthorDate:    Thu, 02 Feb 2023 09:30:20 -03:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 06 Feb 2023 14:49:13 +01:00

rtmutex: Ensure that the top waiter is always woken up

Let L1 and L2 be two spinlocks.

Let T1 be a task holding L1 and blocked on L2. T1, currently, is the top
waiter of L2.

Let T2 be the task holding L2.

Let T3 be a task trying to acquire L1.

The following events will lead to a state in which the wait queue of L2
isn't empty, but no task actually holds the lock.

T1                T2                                  T3
==                ==                                  ==

                                                      spin_lock(L1)
                                                      | raw_spin_lock(L1->wait_lock)
                                                      | rtlock_slowlock_locked(L1)
                                                      | | task_blocks_on_rt_mutex(L1, T3)
                                                      | | | orig_waiter->lock = L1
                                                      | | | orig_waiter->task = T3
                                                      | | | raw_spin_unlock(L1->wait_lock)
                                                      | | | rt_mutex_adjust_prio_chain(T1, L1, L2, orig_waiter, T3)
                  spin_unlock(L2)                     | | | |
                  | rt_mutex_slowunlock(L2)           | | | |
                  | | raw_spin_lock(L2->wait_lock)    | | | |
                  | | wakeup(T1)                      | | | |
                  | | raw_spin_unlock(L2->wait_lock)  | | | |
                                                      | | | | waiter = T1->pi_blocked_on
                                                      | | | | waiter == rt_mutex_top_waiter(L2)
                                                      | | | | waiter->task == T1
                                                      | | | | raw_spin_lock(L2->wait_lock)
                                                      | | | | dequeue(L2, waiter)
                                                      | | | | update_prio(waiter, T1)
                                                      | | | | enqueue(L2, waiter)
                                                      | | | | waiter != rt_mutex_top_waiter(L2)
                                                      | | | | L2->owner == NULL
                                                      | | | | wakeup(T1)
                                                      | | | | raw_spin_unlock(L2->wait_lock)
T1 wakes up
T1 != top_waiter(L2)
schedule_rtlock()

If the deadline of T1 is updated before the call to update_prio(), and the
new deadline is greater than the deadline of the second top waiter, then
after the requeue, T1 is no longer the top waiter, and the wrong task is
woken up which will then go back to sleep because it is not the top waiter.

This can be reproduced in PREEMPT_RT with stress-ng:

while true; do
    stress-ng --sched deadline --sched-period 1000000000 \
    	    --sched-runtime 800000000 --sched-deadline \
    	    1000000000 --mmapfork 23 -t 20
done

A similar issue was pointed out by Thomas versus the cases where the top
waiter drops out early due to a signal or timeout, which is a general issue
for all regular rtmutex use cases, e.g. futex.

The problematic code is in rt_mutex_adjust_prio_chain():

    	// Save the top waiter before dequeue/enqueue
	prerequeue_top_waiter = rt_mutex_top_waiter(lock);

	rt_mutex_dequeue(lock, waiter);
	waiter_update_prio(waiter, task);
	rt_mutex_enqueue(lock, waiter);

	// Lock has no owner?
	if (!rt_mutex_owner(lock)) {
	   	// Top waiter changed		      			   
  ---->		if (prerequeue_top_waiter != rt_mutex_top_waiter(lock))
  ---->			wake_up_state(waiter->task, waiter->wake_state);

This only takes the case into account where @waiter is the new top waiter
due to the requeue operation.

But it fails to handle the case where @waiter is not longer the top
waiter due to the requeue operation.

Ensure that the new top waiter is woken up so in all cases so it can take
over the ownerless lock.

[ tglx: Amend changelog, add Fixes tag ]

Fixes: c014ef69b3ac ("locking/rtmutex: Add wake_state to rt_mutex_waiter")
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230117172649.52465-1-wander@redhat.com
Link: https://lore.kernel.org/r/20230202123020.14844-1-wander@redhat.com
---
 kernel/locking/rtmutex.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 010cf4e..728f434 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -901,8 +901,9 @@ static int __sched rt_mutex_adjust_prio_chain(struct task_struct *task,
 		 * then we need to wake the new top waiter up to try
 		 * to get the lock.
 		 */
-		if (prerequeue_top_waiter != rt_mutex_top_waiter(lock))
-			wake_up_state(waiter->task, waiter->wake_state);
+		top_waiter = rt_mutex_top_waiter(lock);
+		if (prerequeue_top_waiter != top_waiter)
+			wake_up_state(top_waiter->task, top_waiter->wake_state);
 		raw_spin_unlock_irq(&lock->wait_lock);
 		return 0;
 	}
