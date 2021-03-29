Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704E634C5E3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhC2IDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231955AbhC2IDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:03:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C25D76198F;
        Mon, 29 Mar 2021 08:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004984;
        bh=YWN3u9qt0/vTG/8acmR7k2K68i0PfPTwckbsvtA9jVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0j/KAYXUMS91lJxhzwMRfw+70RZLWnPXL4hjLjVQRvn8Gk51Qdsahi8wEaC9XfCT
         K7JvO5CaUTFqGTL9aZ0QlLwZEzODSNROUyPhcjK2NteDOvE0+LO2P5rBpGChD/79OT
         rBbtk+LJI4zP+/KyTXeCLOXBPQkxzXFwRzPhTJwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        juri.lelli@arm.com, bigeasy@linutronix.de, xlpang@redhat.com,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        jdesfossez@efficios.com, dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 39/53] futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()
Date:   Mon, 29 Mar 2021 09:58:14 +0200
Message-Id: <20210329075608.797462410@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit cfafcd117da0216520568c195cb2f6cd1980c4bb upstream.

By changing futex_lock_pi() to use rt_mutex_*_proxy_lock() all wait_list
modifications are done under both hb->lock and wait_lock.

This closes the obvious interleave pattern between futex_lock_pi() and
futex_unlock_pi(), but not entirely so. See below:

Before:

futex_lock_pi()			futex_unlock_pi()
  unlock hb->lock

				  lock hb->lock
				  unlock hb->lock

				  lock rt_mutex->wait_lock
				  unlock rt_mutex_wait_lock
				    -EAGAIN

  lock rt_mutex->wait_lock
  list_add
  unlock rt_mutex->wait_lock

  schedule()

  lock rt_mutex->wait_lock
  list_del
  unlock rt_mutex->wait_lock

				  <idem>
				    -EAGAIN

  lock hb->lock

After:

futex_lock_pi()			futex_unlock_pi()

  lock hb->lock
  lock rt_mutex->wait_lock
  list_add
  unlock rt_mutex->wait_lock
  unlock hb->lock

  schedule()
				  lock hb->lock
				  unlock hb->lock
  lock hb->lock
  lock rt_mutex->wait_lock
  list_del
  unlock rt_mutex->wait_lock

				  lock rt_mutex->wait_lock
				  unlock rt_mutex_wait_lock
				    -EAGAIN

  unlock hb->lock

It does however solve the earlier starvation/live-lock scenario which got
introduced with the -EAGAIN since unlike the before scenario; where the
-EAGAIN happens while futex_unlock_pi() doesn't hold any locks; in the
after scenario it happens while futex_unlock_pi() actually holds a lock,
and then it is serialized on that lock.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104152.062785528@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c                  |   77 ++++++++++++++++++++++++++++------------
 kernel/locking/rtmutex.c        |   26 +++----------
 kernel/locking/rtmutex_common.h |    1 
 3 files changed, 62 insertions(+), 42 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2333,20 +2333,7 @@ queue_unlock(struct futex_hash_bucket *h
 	hb_waiters_dec(hb);
 }
 
-/**
- * queue_me() - Enqueue the futex_q on the futex_hash_bucket
- * @q:	The futex_q to enqueue
- * @hb:	The destination hash bucket
- *
- * The hb->lock must be held by the caller, and is released here. A call to
- * queue_me() is typically paired with exactly one call to unqueue_me().  The
- * exceptions involve the PI related operations, which may use unqueue_me_pi()
- * or nothing if the unqueue is done as part of the wake process and the unqueue
- * state is implicit in the state of woken task (see futex_wait_requeue_pi() for
- * an example).
- */
-static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
-	__releases(&hb->lock)
+static inline void __queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 {
 	int prio;
 
@@ -2363,6 +2350,24 @@ static inline void queue_me(struct futex
 	plist_node_init(&q->list, prio);
 	plist_add(&q->list, &hb->chain);
 	q->task = current;
+}
+
+/**
+ * queue_me() - Enqueue the futex_q on the futex_hash_bucket
+ * @q:	The futex_q to enqueue
+ * @hb:	The destination hash bucket
+ *
+ * The hb->lock must be held by the caller, and is released here. A call to
+ * queue_me() is typically paired with exactly one call to unqueue_me().  The
+ * exceptions involve the PI related operations, which may use unqueue_me_pi()
+ * or nothing if the unqueue is done as part of the wake process and the unqueue
+ * state is implicit in the state of woken task (see futex_wait_requeue_pi() for
+ * an example).
+ */
+static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
+	__releases(&hb->lock)
+{
+	__queue_me(q, hb);
 	spin_unlock(&hb->lock);
 }
 
@@ -2868,6 +2873,7 @@ static int futex_lock_pi(u32 __user *uad
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct task_struct *exiting = NULL;
+	struct rt_mutex_waiter rt_waiter;
 	struct futex_hash_bucket *hb;
 	struct futex_q q = futex_q_init;
 	int res, ret;
@@ -2928,25 +2934,52 @@ retry_private:
 		}
 	}
 
+	WARN_ON(!q.pi_state);
+
 	/*
 	 * Only actually queue now that the atomic ops are done:
 	 */
-	queue_me(&q, hb);
+	__queue_me(&q, hb);
 
-	WARN_ON(!q.pi_state);
-	/*
-	 * Block on the PI mutex:
-	 */
-	if (!trylock) {
-		ret = rt_mutex_timed_futex_lock(&q.pi_state->pi_mutex, to);
-	} else {
+	if (trylock) {
 		ret = rt_mutex_futex_trylock(&q.pi_state->pi_mutex);
 		/* Fixup the trylock return value: */
 		ret = ret ? 0 : -EWOULDBLOCK;
+		goto no_block;
 	}
 
+	/*
+	 * We must add ourselves to the rt_mutex waitlist while holding hb->lock
+	 * such that the hb and rt_mutex wait lists match.
+	 */
+	rt_mutex_init_waiter(&rt_waiter);
+	ret = rt_mutex_start_proxy_lock(&q.pi_state->pi_mutex, &rt_waiter, current);
+	if (ret) {
+		if (ret == 1)
+			ret = 0;
+
+		goto no_block;
+	}
+
+	spin_unlock(q.lock_ptr);
+
+	if (unlikely(to))
+		hrtimer_start_expires(&to->timer, HRTIMER_MODE_ABS);
+
+	ret = rt_mutex_wait_proxy_lock(&q.pi_state->pi_mutex, to, &rt_waiter);
+
 	spin_lock(q.lock_ptr);
 	/*
+	 * If we failed to acquire the lock (signal/timeout), we must
+	 * first acquire the hb->lock before removing the lock from the
+	 * rt_mutex waitqueue, such that we can keep the hb and rt_mutex
+	 * wait lists consistent.
+	 */
+	if (ret && !rt_mutex_cleanup_proxy_lock(&q.pi_state->pi_mutex, &rt_waiter))
+		ret = 0;
+
+no_block:
+	/*
 	 * Fixup the pi_state owner and possibly acquire the lock if we
 	 * haven't already.
 	 */
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1523,19 +1523,6 @@ int __sched rt_mutex_lock_interruptible(
 EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
 
 /*
- * Futex variant with full deadlock detection.
- * Futex variants must not use the fast-path, see __rt_mutex_futex_unlock().
- */
-int __sched rt_mutex_timed_futex_lock(struct rt_mutex *lock,
-			      struct hrtimer_sleeper *timeout)
-{
-	might_sleep();
-
-	return rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE,
-				 timeout, RT_MUTEX_FULL_CHAINWALK);
-}
-
-/*
  * Futex variant, must not use fastpath.
  */
 int __sched rt_mutex_futex_trylock(struct rt_mutex *lock)
@@ -1808,12 +1795,6 @@ int rt_mutex_wait_proxy_lock(struct rt_m
 	/* sleep on the mutex */
 	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
 
-	/*
-	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
-	 * have to fix that up.
-	 */
-	fixup_rt_mutex_waiters(lock);
-
 	raw_spin_unlock_irq(&lock->wait_lock);
 
 	return ret;
@@ -1853,6 +1834,13 @@ bool rt_mutex_cleanup_proxy_lock(struct
 		fixup_rt_mutex_waiters(lock);
 		cleanup = true;
 	}
+
+	/*
+	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
+	 * have to fix that up.
+	 */
+	fixup_rt_mutex_waiters(lock);
+
 	raw_spin_unlock_irq(&lock->wait_lock);
 
 	return cleanup;
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -112,7 +112,6 @@ extern int rt_mutex_wait_proxy_lock(stru
 			       struct rt_mutex_waiter *waiter);
 extern bool rt_mutex_cleanup_proxy_lock(struct rt_mutex *lock,
 				 struct rt_mutex_waiter *waiter);
-extern int rt_mutex_timed_futex_lock(struct rt_mutex *l, struct hrtimer_sleeper *to);
 extern int rt_mutex_futex_trylock(struct rt_mutex *l);
 extern int __rt_mutex_futex_trylock(struct rt_mutex *l);
 


