Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9BD69499A
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBMPAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbjBMPAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:00:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BA81E1EE
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:59:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D026B81256
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7657CC433EF;
        Mon, 13 Feb 2023 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300385;
        bh=MEmOQe5/1qgy8a3vclEnwF8C/ya497NIpCulmmwWdMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFWzdEeHzxK+g/f/a81VtOWZdKVi3qKYr2P+fNwawI3O6QiFTgUQcS+u0o0Qu/3NL
         8MhdADZCbi80I+8UDq2uc1RTp++gJRa/R7uW7uE2IA75zi5KqdV+2qdn9WYGRuIqp3
         9wvhe+SW/eBswJitMwk+aUwMaenkk17xTGMIsMZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wander Lairson Costa <wander@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 59/67] rtmutex: Ensure that the top waiter is always woken up
Date:   Mon, 13 Feb 2023 15:49:40 +0100
Message-Id: <20230213144735.179046086@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wander Lairson Costa <wander@redhat.com>

commit db370a8b9f67ae5f17e3d5482493294467784504 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rtmutex.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -855,8 +855,9 @@ static int __sched rt_mutex_adjust_prio_
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


