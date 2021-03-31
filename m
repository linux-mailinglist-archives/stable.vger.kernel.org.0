Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B4934C5EE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhC2ID7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231510AbhC2IDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:03:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42139619A0;
        Mon, 29 Mar 2021 08:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004997;
        bh=Q+re3X1dSQ9ejPCBLkAlPmPEPaHh6xq2gq+7q2obHfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcCbJ1abF0542nZSL57nFSahMdF/H2OWhINleMZWdxLpugpU2HBGAmsSLqLFQpfHH
         /of/R0AFS/meKVnoyh2/daNI/+UTu+nq8FwI6rEc0neWz1UkaWdxlQR6gyYgOoi9iK
         yv+q9PSXM+3KJuE3JACZU+Nh76I6yttwCan861pQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, Stefan Liebler <stli@linux.ibm.com>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 43/53] futex: Handle early deadlock return correctly
Date:   Mon, 29 Mar 2021 09:58:18 +0200
Message-Id: <20210329075608.925964742@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 1a1fb985f2e2b85ec0d3dc2e519ee48389ec2434 upstream.

commit 56222b212e8e ("futex: Drop hb->lock before enqueueing on the
rtmutex") changed the locking rules in the futex code so that the hash
bucket lock is not longer held while the waiter is enqueued into the
rtmutex wait list. This made the lock and the unlock path symmetric, but
unfortunately the possible early exit from __rt_mutex_proxy_start() due to
a detected deadlock was not updated accordingly. That allows a concurrent
unlocker to observe inconsitent state which triggers the warning in the
unlock path.

futex_lock_pi()                         futex_unlock_pi()
  lock(hb->lock)
  queue(hb_waiter)				lock(hb->lock)
  lock(rtmutex->wait_lock)
  unlock(hb->lock)
                                        // acquired hb->lock
                                        hb_waiter = futex_top_waiter()
                                        lock(rtmutex->wait_lock)
  __rt_mutex_proxy_start()
     ---> fail
          remove(rtmutex_waiter);
     ---> returns -EDEADLOCK
  unlock(rtmutex->wait_lock)
                                        // acquired wait_lock
                                        wake_futex_pi()
                                        rt_mutex_next_owner()
					  --> returns NULL
                                          --> WARN

  lock(hb->lock)
  unqueue(hb_waiter)

The problem is caused by the remove(rtmutex_waiter) in the failure case of
__rt_mutex_proxy_start() as this lets the unlocker observe a waiter in the
hash bucket but no waiter on the rtmutex, i.e. inconsistent state.

The original commit handles this correctly for the other early return cases
(timeout, signal) by delaying the removal of the rtmutex waiter until the
returning task reacquired the hash bucket lock.

Treat the failure case of __rt_mutex_proxy_start() in the same way and let
the existing cleanup code handle the eventual handover of the rtmutex
gracefully. The regular rt_mutex_proxy_start() gains the rtmutex waiter
removal for the failure case, so that the other callsites are still
operating correctly.

Add proper comments to the code so all these details are fully documented.

Thanks to Peter for helping with the analysis and writing the really
valuable code comments.

Fixes: 56222b212e8e ("futex: Drop hb->lock before enqueueing on the rtmutex")
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Co-developed-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: Stefan Liebler <stli@linux.ibm.com>
Cc: Sebastian Sewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1901292311410.1950@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c           |   28 ++++++++++++++++++----------
 kernel/locking/rtmutex.c |   37 ++++++++++++++++++++++++++++++++-----
 2 files changed, 50 insertions(+), 15 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2958,35 +2958,39 @@ retry_private:
 	 * and BUG when futex_unlock_pi() interleaves with this.
 	 *
 	 * Therefore acquire wait_lock while holding hb->lock, but drop the
-	 * latter before calling rt_mutex_start_proxy_lock(). This still fully
-	 * serializes against futex_unlock_pi() as that does the exact same
-	 * lock handoff sequence.
+	 * latter before calling __rt_mutex_start_proxy_lock(). This
+	 * interleaves with futex_unlock_pi() -- which does a similar lock
+	 * handoff -- such that the latter can observe the futex_q::pi_state
+	 * before __rt_mutex_start_proxy_lock() is done.
 	 */
 	raw_spin_lock_irq(&q.pi_state->pi_mutex.wait_lock);
 	spin_unlock(q.lock_ptr);
+	/*
+	 * __rt_mutex_start_proxy_lock() unconditionally enqueues the @rt_waiter
+	 * such that futex_unlock_pi() is guaranteed to observe the waiter when
+	 * it sees the futex_q::pi_state.
+	 */
 	ret = __rt_mutex_start_proxy_lock(&q.pi_state->pi_mutex, &rt_waiter, current);
 	raw_spin_unlock_irq(&q.pi_state->pi_mutex.wait_lock);
 
 	if (ret) {
 		if (ret == 1)
 			ret = 0;
-
-		spin_lock(q.lock_ptr);
-		goto no_block;
+		goto cleanup;
 	}
 
-
 	if (unlikely(to))
 		hrtimer_start_expires(&to->timer, HRTIMER_MODE_ABS);
 
 	ret = rt_mutex_wait_proxy_lock(&q.pi_state->pi_mutex, to, &rt_waiter);
 
+cleanup:
 	spin_lock(q.lock_ptr);
 	/*
-	 * If we failed to acquire the lock (signal/timeout), we must
+	 * If we failed to acquire the lock (deadlock/signal/timeout), we must
 	 * first acquire the hb->lock before removing the lock from the
-	 * rt_mutex waitqueue, such that we can keep the hb and rt_mutex
-	 * wait lists consistent.
+	 * rt_mutex waitqueue, such that we can keep the hb and rt_mutex wait
+	 * lists consistent.
 	 *
 	 * In particular; it is important that futex_unlock_pi() can not
 	 * observe this inconsistency.
@@ -3093,6 +3097,10 @@ retry:
 		 * there is no point where we hold neither; and therefore
 		 * wake_futex_pi() must observe a state consistent with what we
 		 * observed.
+		 *
+		 * In particular; this forces __rt_mutex_start_proxy() to
+		 * complete such that we're guaranteed to observe the
+		 * rt_waiter. Also see the WARN in wake_futex_pi().
 		 */
 		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 		spin_unlock(&hb->lock);
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1695,12 +1695,33 @@ void rt_mutex_proxy_unlock(struct rt_mut
 	rt_mutex_set_owner(lock, NULL);
 }
 
+/**
+ * __rt_mutex_start_proxy_lock() - Start lock acquisition for another task
+ * @lock:		the rt_mutex to take
+ * @waiter:		the pre-initialized rt_mutex_waiter
+ * @task:		the task to prepare
+ *
+ * Starts the rt_mutex acquire; it enqueues the @waiter and does deadlock
+ * detection. It does not wait, see rt_mutex_wait_proxy_lock() for that.
+ *
+ * NOTE: does _NOT_ remove the @waiter on failure; must either call
+ * rt_mutex_wait_proxy_lock() or rt_mutex_cleanup_proxy_lock() after this.
+ *
+ * Returns:
+ *  0 - task blocked on lock
+ *  1 - acquired the lock for task, caller should wake it up
+ * <0 - error
+ *
+ * Special API call for PI-futex support.
+ */
 int __rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 			      struct rt_mutex_waiter *waiter,
 			      struct task_struct *task)
 {
 	int ret;
 
+	lockdep_assert_held(&lock->wait_lock);
+
 	if (try_to_take_rt_mutex(lock, task, NULL))
 		return 1;
 
@@ -1718,9 +1739,6 @@ int __rt_mutex_start_proxy_lock(struct r
 		ret = 0;
 	}
 
-	if (unlikely(ret))
-		remove_waiter(lock, waiter);
-
 	debug_rt_mutex_print_deadlock(waiter);
 
 	return ret;
@@ -1732,12 +1750,18 @@ int __rt_mutex_start_proxy_lock(struct r
  * @waiter:		the pre-initialized rt_mutex_waiter
  * @task:		the task to prepare
  *
+ * Starts the rt_mutex acquire; it enqueues the @waiter and does deadlock
+ * detection. It does not wait, see rt_mutex_wait_proxy_lock() for that.
+ *
+ * NOTE: unlike __rt_mutex_start_proxy_lock this _DOES_ remove the @waiter
+ * on failure.
+ *
  * Returns:
  *  0 - task blocked on lock
  *  1 - acquired the lock for task, caller should wake it up
  * <0 - error
  *
- * Special API call for FUTEX_REQUEUE_PI support.
+ * Special API call for PI-futex support.
  */
 int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 			      struct rt_mutex_waiter *waiter,
@@ -1747,6 +1771,8 @@ int rt_mutex_start_proxy_lock(struct rt_
 
 	raw_spin_lock_irq(&lock->wait_lock);
 	ret = __rt_mutex_start_proxy_lock(lock, waiter, task);
+	if (unlikely(ret))
+		remove_waiter(lock, waiter);
 	raw_spin_unlock_irq(&lock->wait_lock);
 
 	return ret;
@@ -1814,7 +1840,8 @@ int rt_mutex_wait_proxy_lock(struct rt_m
  * @lock:		the rt_mutex we were woken on
  * @waiter:		the pre-initialized rt_mutex_waiter
  *
- * Attempt to clean up after a failed rt_mutex_wait_proxy_lock().
+ * Attempt to clean up after a failed __rt_mutex_start_proxy_lock() or
+ * rt_mutex_wait_proxy_lock().
  *
  * Unless we acquired the lock; we're still enqueued on the wait-list and can
  * in fact still be granted ownership until we're removed. Therefore we can


