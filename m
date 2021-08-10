Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F1F3E3970
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhHHHX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231359AbhHHHX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:23:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E41CA61028;
        Sun,  8 Aug 2021 07:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628407387;
        bh=qc1leVYk35OvjWoUI1YszX8Fq+6Nw1HnuEfGH0P28o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrS6bzS2Bp27y4V5GMdTcmX6Amhl4t6iVz1/2MlLVVvuOHdV6Slfa3cNwlqcaDC4V
         W3FClQfh98+/Vd6ZSs6hBygzq63zfvM7RQLieGRuNrj42IWuN3EtF4yBYDPEVGY9en
         ty7MR0aKZEsqcwlIB5N9srAFRlFqTrOjPhTXeISc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        juri.lelli@arm.com, bigeasy@linutronix.de, xlpang@redhat.com,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        jdesfossez@efficios.com, dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Joe Korty <joe.korty@concurrent-rt.com>
Subject: [PATCH 4.4 04/11] futex: Pull rt_mutex_futex_unlock() out from under hb->lock
Date:   Sun,  8 Aug 2021 09:22:39 +0200
Message-Id: <20210808072217.464956460@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210808072217.322468704@linuxfoundation.org>
References: <20210808072217.322468704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 16ffa12d742534d4ff73e8b3a4e81c1de39196f0 ]

There's a number of 'interesting' problems, all caused by holding
hb->lock while doing the rt_mutex_unlock() equivalient.

Notably:

 - a PI inversion on hb->lock; and,

 - a SCHED_DEADLINE crash because of pointer instability.

The previous changes:

 - changed the locking rules to cover {uval,pi_state} with wait_lock.

 - allow to do rt_mutex_futex_unlock() without dropping wait_lock; which in
   turn allows to rely on wait_lock atomicity completely.

 - simplified the waiter conundrum.

It's now sufficient to hold rtmutex::wait_lock and a reference on the
pi_state to protect the state consistency, so hb->lock can be dropped
before calling rt_mutex_futex_unlock().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.900002056@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Joe Korty <joe.korty@concurrent-rt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |  111 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 68 insertions(+), 43 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -966,10 +966,12 @@ static void exit_pi_state_list(struct ta
 		pi_state->owner = NULL;
 		raw_spin_unlock_irq(&curr->pi_lock);
 
-		rt_mutex_futex_unlock(&pi_state->pi_mutex);
-
+		get_pi_state(pi_state);
 		spin_unlock(&hb->lock);
 
+		rt_mutex_futex_unlock(&pi_state->pi_mutex);
+		put_pi_state(pi_state);
+
 		raw_spin_lock_irq(&curr->pi_lock);
 	}
 	raw_spin_unlock_irq(&curr->pi_lock);
@@ -1083,6 +1085,11 @@ static int attach_to_pi_state(u32 __user
 	 * has dropped the hb->lock in between queue_me() and unqueue_me_pi(),
 	 * which in turn means that futex_lock_pi() still has a reference on
 	 * our pi_state.
+	 *
+	 * The waiter holding a reference on @pi_state also protects against
+	 * the unlocked put_pi_state() in futex_unlock_pi(), futex_lock_pi()
+	 * and futex_wait_requeue_pi() as it cannot go to 0 and consequently
+	 * free pi_state before we can take a reference ourselves.
 	 */
 	WARN_ON(!atomic_read(&pi_state->refcount));
 
@@ -1537,48 +1544,40 @@ static void mark_wake_futex(struct wake_
 	q->lock_ptr = NULL;
 }
 
-static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
-			 struct futex_hash_bucket *hb)
+/*
+ * Caller must hold a reference on @pi_state.
+ */
+static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_pi_state *pi_state)
 {
-	struct task_struct *new_owner;
-	struct futex_pi_state *pi_state = this->pi_state;
 	u32 uninitialized_var(curval), newval;
+	struct task_struct *new_owner;
+	bool deboost = false;
 	WAKE_Q(wake_q);
-	bool deboost;
 	int ret = 0;
 
-	if (!pi_state)
-		return -EINVAL;
-
-	/*
-	 * If current does not own the pi_state then the futex is
-	 * inconsistent and user space fiddled with the futex value.
-	 */
-	if (pi_state->owner != current)
-		return -EINVAL;
-
 	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
-
-	/*
-	 * When we interleave with futex_lock_pi() where it does
-	 * rt_mutex_timed_futex_lock(), we might observe @this futex_q waiter,
-	 * but the rt_mutex's wait_list can be empty (either still, or again,
-	 * depending on which side we land).
-	 *
-	 * When this happens, give up our locks and try again, giving the
-	 * futex_lock_pi() instance time to complete, either by waiting on the
-	 * rtmutex or removing itself from the futex queue.
-	 */
 	if (!new_owner) {
-		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
-		return -EAGAIN;
+		/*
+		 * Since we held neither hb->lock nor wait_lock when coming
+		 * into this function, we could have raced with futex_lock_pi()
+		 * such that we might observe @this futex_q waiter, but the
+		 * rt_mutex's wait_list can be empty (either still, or again,
+		 * depending on which side we land).
+		 *
+		 * When this happens, give up our locks and try again, giving
+		 * the futex_lock_pi() instance time to complete, either by
+		 * waiting on the rtmutex or removing itself from the futex
+		 * queue.
+		 */
+		ret = -EAGAIN;
+		goto out_unlock;
 	}
 
 	/*
-	 * We pass it to the next owner. The WAITERS bit is always
-	 * kept enabled while there is PI state around. We cleanup the
-	 * owner died bit, because we are the owner.
+	 * We pass it to the next owner. The WAITERS bit is always kept
+	 * enabled while there is PI state around. We cleanup the owner
+	 * died bit, because we are the owner.
 	 */
 	newval = FUTEX_WAITERS | task_pid_vnr(new_owner);
 
@@ -1611,15 +1610,15 @@ static int wake_futex_pi(u32 __user *uad
 		deboost = __rt_mutex_futex_unlock(&pi_state->pi_mutex, &wake_q);
 	}
 
+out_unlock:
 	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
-	spin_unlock(&hb->lock);
 
 	if (deboost) {
 		wake_up_q(&wake_q);
 		rt_mutex_adjust_prio(current);
 	}
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -2462,7 +2461,7 @@ retry:
 	if (get_futex_value_locked(&uval, uaddr))
 		goto handle_fault;
 
-	while (1) {
+	for (;;) {
 		newval = (uval & FUTEX_OWNER_DIED) | newtid;
 
 		if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
@@ -2975,10 +2974,36 @@ retry:
 	 */
 	match = futex_top_waiter(hb, &key);
 	if (match) {
-		ret = wake_futex_pi(uaddr, uval, match, hb);
+		struct futex_pi_state *pi_state = match->pi_state;
+
+		ret = -EINVAL;
+		if (!pi_state)
+			goto out_unlock;
+
 		/*
-		 * In case of success wake_futex_pi dropped the hash
-		 * bucket lock.
+		 * If current does not own the pi_state then the futex is
+		 * inconsistent and user space fiddled with the futex value.
+		 */
+		if (pi_state->owner != current)
+			goto out_unlock;
+
+		/*
+		 * Grab a reference on the pi_state and drop hb->lock.
+		 *
+		 * The reference ensures pi_state lives, dropping the hb->lock
+		 * is tricky.. wake_futex_pi() will take rt_mutex::wait_lock to
+		 * close the races against futex_lock_pi(), but in case of
+		 * _any_ fail we'll abort and retry the whole deal.
+		 */
+		get_pi_state(pi_state);
+		spin_unlock(&hb->lock);
+
+		ret = wake_futex_pi(uaddr, uval, pi_state);
+
+		put_pi_state(pi_state);
+
+		/*
+		 * Success, we're done! No tricky corner cases.
 		 */
 		if (!ret)
 			goto out_putkey;
@@ -2993,7 +3018,6 @@ retry:
 		 * setting the FUTEX_WAITERS bit. Try again.
 		 */
 		if (ret == -EAGAIN) {
-			spin_unlock(&hb->lock);
 			put_futex_key(&key);
 			goto retry;
 		}
@@ -3001,7 +3025,7 @@ retry:
 		 * wake_futex_pi has detected invalid state. Tell user
 		 * space.
 		 */
-		goto out_unlock;
+		goto out_putkey;
 	}
 
 	/*
@@ -3011,8 +3035,10 @@ retry:
 	 * preserve the WAITERS bit not the OWNER_DIED one. We are the
 	 * owner.
 	 */
-	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, 0))
+	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, 0)) {
+		spin_unlock(&hb->lock);
 		goto pi_faulted;
+	}
 
 	/*
 	 * If uval has changed, let user space handle it.
@@ -3026,7 +3052,6 @@ out_putkey:
 	return ret;
 
 pi_faulted:
-	spin_unlock(&hb->lock);
 	put_futex_key(&key);
 
 	ret = fault_in_user_writeable(uaddr);


