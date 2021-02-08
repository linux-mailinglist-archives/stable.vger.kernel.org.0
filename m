Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB83313647
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhBHPIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:08:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232045AbhBHPGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:06:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27E1764ECF;
        Mon,  8 Feb 2021 15:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796677;
        bh=5e9kraJ2ZdNDjklsmqxipMjT8NbTlYUwbkYHnju2SWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXXS8SRIxS0g8VXXVlSnwpbInB2IsFJt1kYPOBthn08D3E1FZ1IXauHA8NrZgy6SC
         oipwuYxkDBGagrRFzKXZxWueBorz/xYd63L/PtZs6UxQP/soeKec00Z2tePjss88tW
         32M+stdooNzOv3h3BBbiVIiA97aOspMV60cyg79I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        juri.lelli@arm.com, bigeasy@linutronix.de, xlpang@redhat.com,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        jdesfossez@efficios.com, dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 06/43] futex: Rework inconsistent rt_mutex/futex_q state
Date:   Mon,  8 Feb 2021 16:00:32 +0100
Message-Id: <20210208145806.538562868@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[Upstream commit 73d786bd043ebc855f349c81ea805f6b11cbf2aa ]

There is a weird state in the futex_unlock_pi() path when it interleaves
with a concurrent futex_lock_pi() at the point where it drops hb->lock.

In this case, it can happen that the rt_mutex wait_list and the futex_q
disagree on pending waiters, in particular rt_mutex will find no pending
waiters where futex_q thinks there are. In this case the rt_mutex unlock
code cannot assign an owner.

The futex side fixup code has to cleanup the inconsistencies with quite a
bunch of interesting corner cases.

Simplify all this by changing wake_futex_pi() to return -EAGAIN when this
situation occurs. This then gives the futex_lock_pi() code the opportunity
to continue and the retried futex_unlock_pi() will now observe a coherent
state.

The only problem is that this breaks RT timeliness guarantees. That
is, consider the following scenario:

  T1 and T2 are both pinned to CPU0. prio(T2) > prio(T1)

    CPU0

    T1
      lock_pi()
      queue_me()  <- Waiter is visible

    preemption

    T2
      unlock_pi()
	loops with -EAGAIN forever

Which is undesirable for PI primitives. Future patches will rectify
this.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.850383690@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[Lee: Back-ported to solve a dependency]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   50 ++++++++++++++------------------------------------
 1 file changed, 14 insertions(+), 36 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1394,12 +1394,19 @@ static int wake_futex_pi(u32 __user *uad
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
-	 * It is possible that the next waiter (the one that brought
-	 * this owner to the kernel) timed out and is no longer
-	 * waiting on the lock.
+	 * When we interleave with futex_lock_pi() where it does
+	 * rt_mutex_timed_futex_lock(), we might observe @this futex_q waiter,
+	 * but the rt_mutex's wait_list can be empty (either still, or again,
+	 * depending on which side we land).
+	 *
+	 * When this happens, give up our locks and try again, giving the
+	 * futex_lock_pi() instance time to complete, either by waiting on the
+	 * rtmutex or removing itself from the futex queue.
 	 */
-	if (!new_owner)
-		new_owner = this->task;
+	if (!new_owner) {
+		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
+		return -EAGAIN;
+	}
 
 	/*
 	 * We pass it to the next owner. The WAITERS bit is always
@@ -2372,7 +2379,6 @@ static long futex_wait_restart(struct re
  */
 static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 {
-	struct task_struct *owner;
 	int ret = 0;
 
 	if (locked) {
@@ -2386,43 +2392,15 @@ static int fixup_owner(u32 __user *uaddr
 	}
 
 	/*
-	 * Catch the rare case, where the lock was released when we were on the
-	 * way back before we locked the hash bucket.
-	 */
-	if (q->pi_state->owner == current) {
-		/*
-		 * Try to get the rt_mutex now. This might fail as some other
-		 * task acquired the rt_mutex after we removed ourself from the
-		 * rt_mutex waiters list.
-		 */
-		if (rt_mutex_futex_trylock(&q->pi_state->pi_mutex)) {
-			locked = 1;
-			goto out;
-		}
-
-		/*
-		 * pi_state is incorrect, some other task did a lock steal and
-		 * we returned due to timeout or signal without taking the
-		 * rt_mutex. Too late.
-		 */
-		raw_spin_lock_irq(&q->pi_state->pi_mutex.wait_lock);
-		owner = rt_mutex_owner(&q->pi_state->pi_mutex);
-		if (!owner)
-			owner = rt_mutex_next_owner(&q->pi_state->pi_mutex);
-		raw_spin_unlock_irq(&q->pi_state->pi_mutex.wait_lock);
-		ret = fixup_pi_state_owner(uaddr, q, owner);
-		goto out;
-	}
-
-	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
 	 * the owner of the rt_mutex.
 	 */
-	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
+	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current) {
 		printk(KERN_ERR "fixup_owner: ret = %d pi-mutex: %p "
 				"pi-state %p\n", ret,
 				q->pi_state->pi_mutex.owner,
 				q->pi_state->owner);
+	}
 
 out:
 	return ret ? ret : locked;


