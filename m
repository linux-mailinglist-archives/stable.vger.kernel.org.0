Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B103DD7C9
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbhHBNsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16032 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234202AbhHBNrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 09:47:36 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GdfNZ4p2szZwVw;
        Mon,  2 Aug 2021 21:43:42 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:14 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:14 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4.4 05/11] futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()
Date:   Mon, 2 Aug 2021 21:46:18 +0800
Message-ID: <20210802134624.1934-6-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210802134624.1934-1-thunder.leizhen@huawei.com>
References: <20210802134624.1934-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit cfafcd117da0216520568c195cb2f6cd1980c4bb ]

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
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/futex.c                  | 77 +++++++++++++++++++++++----------
 kernel/locking/rtmutex.c        | 26 +++--------
 kernel/locking/rtmutex_common.h |  1 -
 3 files changed, 62 insertions(+), 42 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index dcea7b214e94d75..45f00a2fb59c554 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2284,20 +2284,7 @@ queue_unlock(struct futex_hash_bucket *hb)
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
 
@@ -2314,6 +2301,24 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
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
 
@@ -2819,6 +2824,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags,
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct task_struct *exiting = NULL;
+	struct rt_mutex_waiter rt_waiter;
 	struct futex_hash_bucket *hb;
 	struct futex_q q = futex_q_init;
 	int res, ret;
@@ -2879,24 +2885,51 @@ retry_private:
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
+	}
+
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
 	}
 
+	spin_unlock(q.lock_ptr);
+
+	if (unlikely(to))
+		hrtimer_start_expires(&to->timer, HRTIMER_MODE_ABS);
+
+	ret = rt_mutex_wait_proxy_lock(&q.pi_state->pi_mutex, to, &rt_waiter);
+
 	spin_lock(q.lock_ptr);
+	/*
+	 * If we failed to acquire the lock (signal/timeout), we must
+	 * first acquire the hb->lock before removing the lock from the
+	 * rt_mutex waitqueue, such that we can keep the hb and rt_mutex
+	 * wait lists consistent.
+	 */
+	if (ret && !rt_mutex_cleanup_proxy_lock(&q.pi_state->pi_mutex, &rt_waiter))
+		ret = 0;
+
+no_block:
 	/*
 	 * Fixup the pi_state owner and possibly acquire the lock if we
 	 * haven't already.
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index fa24df4bc7a8ff0..98e45a2e1236e30 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1488,19 +1488,6 @@ int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock)
 }
 EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
 
-/*
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
 /*
  * Futex variant, must not use fastpath.
  */
@@ -1774,12 +1761,6 @@ int rt_mutex_wait_proxy_lock(struct rt_mutex *lock,
 	/* sleep on the mutex */
 	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
 
-	/*
-	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
-	 * have to fix that up.
-	 */
-	fixup_rt_mutex_waiters(lock);
-
 	raw_spin_unlock(&lock->wait_lock);
 
 	return ret;
@@ -1819,6 +1800,13 @@ bool rt_mutex_cleanup_proxy_lock(struct rt_mutex *lock,
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
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index 0424ff97bb69cad..97c048c494f00d8 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -111,7 +111,6 @@ extern int rt_mutex_wait_proxy_lock(struct rt_mutex *lock,
 			       struct rt_mutex_waiter *waiter);
 extern bool rt_mutex_cleanup_proxy_lock(struct rt_mutex *lock,
 				 struct rt_mutex_waiter *waiter);
-extern int rt_mutex_timed_futex_lock(struct rt_mutex *l, struct hrtimer_sleeper *to);
 extern int rt_mutex_futex_trylock(struct rt_mutex *l);
 extern int __rt_mutex_futex_trylock(struct rt_mutex *l);
 
-- 
2.26.0.106.g9fadedd

