Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B623DD7EC
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbhHBNsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:33 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16034 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbhHBNrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 09:47:36 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GdfNb5nnKzZwdb;
        Mon,  2 Aug 2021 21:43:43 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:16 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:15 +0800
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
Subject: [PATCH 4.4 07/11] rtmutex: Make wait_lock irq safe
Date:   Mon, 2 Aug 2021 21:46:20 +0800
Message-ID: <20210802134624.1934-8-thunder.leizhen@huawei.com>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit b4abf91047cf054f203dcfac97e1038388826937 ]

Sasha reported a lockdep splat about a potential deadlock between RCU boosting
rtmutex and the posix timer it_lock.

CPU0					CPU1

rtmutex_lock(&rcu->rt_mutex)
  spin_lock(&rcu->rt_mutex.wait_lock)
					local_irq_disable()
					spin_lock(&timer->it_lock)
					spin_lock(&rcu->mutex.wait_lock)
--> Interrupt
    spin_lock(&timer->it_lock)

This is caused by the following code sequence on CPU1

     rcu_read_lock()
     x = lookup();
     if (x)
     	spin_lock_irqsave(&x->it_lock);
     rcu_read_unlock();
     return x;

We could fix that in the posix timer code by keeping rcu read locked across
the spinlocked and irq disabled section, but the above sequence is common and
there is no reason not to support it.

Taking rt_mutex.wait_lock irq safe prevents the deadlock.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/locking/rtmutex.c | 135 +++++++++++++++++++++------------------
 1 file changed, 72 insertions(+), 63 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 98e45a2e1236e30..18154e10d63a23b 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -163,13 +163,14 @@ static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
  * 2) Drop lock->wait_lock
  * 3) Try to unlock the lock with cmpxchg
  */
-static inline bool unlock_rt_mutex_safe(struct rt_mutex *lock)
+static inline bool unlock_rt_mutex_safe(struct rt_mutex *lock,
+					unsigned long flags)
 	__releases(lock->wait_lock)
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
 
 	clear_rt_mutex_waiters(lock);
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 	/*
 	 * If a new waiter comes in between the unlock and the cmpxchg
 	 * we have two situations:
@@ -211,11 +212,12 @@ static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
 /*
  * Simple slow path only version: lock->owner is protected by lock->wait_lock.
  */
-static inline bool unlock_rt_mutex_safe(struct rt_mutex *lock)
+static inline bool unlock_rt_mutex_safe(struct rt_mutex *lock,
+					unsigned long flags)
 	__releases(lock->wait_lock)
 {
 	lock->owner = NULL;
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 	return true;
 }
 #endif
@@ -497,7 +499,6 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	int ret = 0, depth = 0;
 	struct rt_mutex *lock;
 	bool detect_deadlock;
-	unsigned long flags;
 	bool requeue = true;
 
 	detect_deadlock = rt_mutex_cond_detect_deadlock(orig_waiter, chwalk);
@@ -540,7 +541,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	/*
 	 * [1] Task cannot go away as we did a get_task() before !
 	 */
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock_irq(&task->pi_lock);
 
 	/*
 	 * [2] Get the waiter on which @task is blocked on.
@@ -624,7 +625,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	 * operations.
 	 */
 	if (!raw_spin_trylock(&lock->wait_lock)) {
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock_irq(&task->pi_lock);
 		cpu_relax();
 		goto retry;
 	}
@@ -655,7 +656,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		/*
 		 * No requeue[7] here. Just release @task [8]
 		 */
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock(&task->pi_lock);
 		put_task_struct(task);
 
 		/*
@@ -663,14 +664,14 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		 * If there is no owner of the lock, end of chain.
 		 */
 		if (!rt_mutex_owner(lock)) {
-			raw_spin_unlock(&lock->wait_lock);
+			raw_spin_unlock_irq(&lock->wait_lock);
 			return 0;
 		}
 
 		/* [10] Grab the next task, i.e. owner of @lock */
 		task = rt_mutex_owner(lock);
 		get_task_struct(task);
-		raw_spin_lock_irqsave(&task->pi_lock, flags);
+		raw_spin_lock(&task->pi_lock);
 
 		/*
 		 * No requeue [11] here. We just do deadlock detection.
@@ -685,8 +686,8 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		top_waiter = rt_mutex_top_waiter(lock);
 
 		/* [13] Drop locks */
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock(&task->pi_lock);
+		raw_spin_unlock_irq(&lock->wait_lock);
 
 		/* If owner is not blocked, end of chain. */
 		if (!next_lock)
@@ -707,7 +708,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	rt_mutex_enqueue(lock, waiter);
 
 	/* [8] Release the task */
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock(&task->pi_lock);
 	put_task_struct(task);
 
 	/*
@@ -725,14 +726,14 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		 */
 		if (prerequeue_top_waiter != rt_mutex_top_waiter(lock))
 			wake_up_process(rt_mutex_top_waiter(lock)->task);
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irq(&lock->wait_lock);
 		return 0;
 	}
 
 	/* [10] Grab the next task, i.e. the owner of @lock */
 	task = rt_mutex_owner(lock);
 	get_task_struct(task);
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock(&task->pi_lock);
 
 	/* [11] requeue the pi waiters if necessary */
 	if (waiter == rt_mutex_top_waiter(lock)) {
@@ -786,8 +787,8 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	top_waiter = rt_mutex_top_waiter(lock);
 
 	/* [13] Drop the locks */
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock(&task->pi_lock);
+	raw_spin_unlock_irq(&lock->wait_lock);
 
 	/*
 	 * Make the actual exit decisions [12], based on the stored
@@ -810,7 +811,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	goto again;
 
  out_unlock_pi:
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock_irq(&task->pi_lock);
  out_put_task:
 	put_task_struct(task);
 
@@ -820,7 +821,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 /*
  * Try to take an rt-mutex
  *
- * Must be called with lock->wait_lock held.
+ * Must be called with lock->wait_lock held and interrupts disabled
  *
  * @lock:   The lock to be acquired.
  * @task:   The task which wants to acquire the lock
@@ -830,8 +831,6 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 				struct rt_mutex_waiter *waiter)
 {
-	unsigned long flags;
-
 	/*
 	 * Before testing whether we can acquire @lock, we set the
 	 * RT_MUTEX_HAS_WAITERS bit in @lock->owner. This forces all
@@ -916,7 +915,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 	 * case, but conditionals are more expensive than a redundant
 	 * store.
 	 */
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock(&task->pi_lock);
 	task->pi_blocked_on = NULL;
 	/*
 	 * Finish the lock acquisition. @task is the new owner. If
@@ -925,7 +924,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 	 */
 	if (rt_mutex_has_waiters(lock))
 		rt_mutex_enqueue_pi(task, rt_mutex_top_waiter(lock));
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock(&task->pi_lock);
 
 takeit:
 	/* We got the lock. */
@@ -945,7 +944,7 @@ takeit:
  *
  * Prepare waiter and propagate pi chain
  *
- * This must be called with lock->wait_lock held.
+ * This must be called with lock->wait_lock held and interrupts disabled
  */
 static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 				   struct rt_mutex_waiter *waiter,
@@ -956,7 +955,6 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	struct rt_mutex_waiter *top_waiter = waiter;
 	struct rt_mutex *next_lock;
 	int chain_walk = 0, res;
-	unsigned long flags;
 
 	/*
 	 * Early deadlock detection. We really don't want the task to
@@ -970,7 +968,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	if (owner == task)
 		return -EDEADLK;
 
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock(&task->pi_lock);
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;
 	waiter->lock = lock;
@@ -983,12 +981,12 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	task->pi_blocked_on = waiter;
 
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock(&task->pi_lock);
 
 	if (!owner)
 		return 0;
 
-	raw_spin_lock_irqsave(&owner->pi_lock, flags);
+	raw_spin_lock(&owner->pi_lock);
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		rt_mutex_dequeue_pi(owner, top_waiter);
 		rt_mutex_enqueue_pi(owner, waiter);
@@ -1003,7 +1001,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	/* Store the lock on which owner is blocked or NULL */
 	next_lock = task_blocked_on_lock(owner);
 
-	raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
+	raw_spin_unlock(&owner->pi_lock);
 	/*
 	 * Even if full deadlock detection is on, if the owner is not
 	 * blocked itself, we can avoid finding this out in the chain
@@ -1019,12 +1017,12 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	 */
 	get_task_struct(owner);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irq(&lock->wait_lock);
 
 	res = rt_mutex_adjust_prio_chain(owner, chwalk, lock,
 					 next_lock, waiter, task);
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irq(&lock->wait_lock);
 
 	return res;
 }
@@ -1033,15 +1031,14 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
  * Remove the top waiter from the current tasks pi waiter tree and
  * queue it up.
  *
- * Called with lock->wait_lock held.
+ * Called with lock->wait_lock held and interrupts disabled.
  */
 static void mark_wakeup_next_waiter(struct wake_q_head *wake_q,
 				    struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter *waiter;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&current->pi_lock, flags);
+	raw_spin_lock(&current->pi_lock);
 
 	waiter = rt_mutex_top_waiter(lock);
 
@@ -1063,7 +1060,7 @@ static void mark_wakeup_next_waiter(struct wake_q_head *wake_q,
 	 */
 	lock->owner = (void *) RT_MUTEX_HAS_WAITERS;
 
-	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
+	raw_spin_unlock(&current->pi_lock);
 
 	wake_q_add(wake_q, waiter->task);
 }
@@ -1071,7 +1068,7 @@ static void mark_wakeup_next_waiter(struct wake_q_head *wake_q,
 /*
  * Remove a waiter from a lock and give up
  *
- * Must be called with lock->wait_lock held and
+ * Must be called with lock->wait_lock held and interrupts disabled. I must
  * have just failed to try_to_take_rt_mutex().
  */
 static void remove_waiter(struct rt_mutex *lock,
@@ -1080,12 +1077,11 @@ static void remove_waiter(struct rt_mutex *lock,
 	bool is_top_waiter = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
 	struct rt_mutex *next_lock;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&current->pi_lock, flags);
+	raw_spin_lock(&current->pi_lock);
 	rt_mutex_dequeue(lock, waiter);
 	current->pi_blocked_on = NULL;
-	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
+	raw_spin_unlock(&current->pi_lock);
 
 	/*
 	 * Only update priority if the waiter was the highest priority
@@ -1094,7 +1090,7 @@ static void remove_waiter(struct rt_mutex *lock,
 	if (!owner || !is_top_waiter)
 		return;
 
-	raw_spin_lock_irqsave(&owner->pi_lock, flags);
+	raw_spin_lock(&owner->pi_lock);
 
 	rt_mutex_dequeue_pi(owner, waiter);
 
@@ -1106,7 +1102,7 @@ static void remove_waiter(struct rt_mutex *lock,
 	/* Store the lock on which owner is blocked or NULL */
 	next_lock = task_blocked_on_lock(owner);
 
-	raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
+	raw_spin_unlock(&owner->pi_lock);
 
 	/*
 	 * Don't walk the chain, if the owner task is not blocked
@@ -1118,12 +1114,12 @@ static void remove_waiter(struct rt_mutex *lock,
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
 	get_task_struct(owner);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irq(&lock->wait_lock);
 
 	rt_mutex_adjust_prio_chain(owner, RT_MUTEX_MIN_CHAINWALK, lock,
 				   next_lock, NULL, current);
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irq(&lock->wait_lock);
 }
 
 /*
@@ -1167,11 +1163,11 @@ void rt_mutex_init_waiter(struct rt_mutex_waiter *waiter)
  * __rt_mutex_slowlock() - Perform the wait-wake-try-to-take loop
  * @lock:		 the rt_mutex to take
  * @state:		 the state the task should block in (TASK_INTERRUPTIBLE
- * 			 or TASK_UNINTERRUPTIBLE)
+ *			 or TASK_UNINTERRUPTIBLE)
  * @timeout:		 the pre-initialized and started timer, or NULL for none
  * @waiter:		 the pre-initialized rt_mutex_waiter
  *
- * lock->wait_lock must be held by the caller.
+ * Must be called with lock->wait_lock held and interrupts disabled
  */
 static int __sched
 __rt_mutex_slowlock(struct rt_mutex *lock, int state,
@@ -1199,13 +1195,13 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 				break;
 		}
 
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irq(&lock->wait_lock);
 
 		debug_rt_mutex_print_deadlock(waiter);
 
 		schedule();
 
-		raw_spin_lock(&lock->wait_lock);
+		raw_spin_lock_irq(&lock->wait_lock);
 		set_current_state(state);
 	}
 
@@ -1242,15 +1238,24 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		  enum rtmutex_chainwalk chwalk)
 {
 	struct rt_mutex_waiter waiter;
+	unsigned long flags;
 	int ret = 0;
 
 	rt_mutex_init_waiter(&waiter);
 
-	raw_spin_lock(&lock->wait_lock);
+	/*
+	 * Technically we could use raw_spin_[un]lock_irq() here, but this can
+	 * be called in early boot if the cmpxchg() fast path is disabled
+	 * (debug, no architecture support). In this case we will acquire the
+	 * rtmutex with lock->wait_lock held. But we cannot unconditionally
+	 * enable interrupts in that early boot case. So we need to use the
+	 * irqsave/restore variants.
+	 */
+	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 
 	/* Try to acquire the lock again: */
 	if (try_to_take_rt_mutex(lock, current, NULL)) {
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		return 0;
 	}
 
@@ -1279,7 +1284,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	 */
 	fixup_rt_mutex_waiters(lock);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	/* Remove pending timer: */
 	if (unlikely(timeout))
@@ -1308,6 +1313,7 @@ static inline int __rt_mutex_slowtrylock(struct rt_mutex *lock)
  */
 static inline int rt_mutex_slowtrylock(struct rt_mutex *lock)
 {
+	unsigned long flags;
 	int ret;
 
 	/*
@@ -1319,14 +1325,14 @@ static inline int rt_mutex_slowtrylock(struct rt_mutex *lock)
 		return 0;
 
 	/*
-	 * The mutex has currently no owner. Lock the wait lock and
-	 * try to acquire the lock.
+	 * The mutex has currently no owner. Lock the wait lock and try to
+	 * acquire the lock. We use irqsave here to support early boot calls.
 	 */
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 
 	ret = __rt_mutex_slowtrylock(lock);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	return ret;
 }
@@ -1338,7 +1344,10 @@ static inline int rt_mutex_slowtrylock(struct rt_mutex *lock)
 static bool __sched rt_mutex_slowunlock(struct rt_mutex *lock,
 					struct wake_q_head *wake_q)
 {
-	raw_spin_lock(&lock->wait_lock);
+	unsigned long flags;
+
+	/* irqsave required to support early boot calls */
+	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 
 	debug_rt_mutex_unlock(lock);
 
@@ -1375,10 +1384,10 @@ static bool __sched rt_mutex_slowunlock(struct rt_mutex *lock,
 	 */
 	while (!rt_mutex_has_waiters(lock)) {
 		/* Drops lock->wait_lock ! */
-		if (unlock_rt_mutex_safe(lock) == true)
+		if (unlock_rt_mutex_safe(lock, flags) == true)
 			return false;
 		/* Relock the rtmutex and try again */
-		raw_spin_lock(&lock->wait_lock);
+		raw_spin_lock_irqsave(&lock->wait_lock, flags);
 	}
 
 	/*
@@ -1389,7 +1398,7 @@ static bool __sched rt_mutex_slowunlock(struct rt_mutex *lock,
 	 */
 	mark_wakeup_next_waiter(wake_q, lock);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	/* check PI boosting */
 	return true;
@@ -1680,10 +1689,10 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 {
 	int ret;
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irq(&lock->wait_lock);
 
 	if (try_to_take_rt_mutex(lock, task, NULL)) {
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irq(&lock->wait_lock);
 		return 1;
 	}
 
@@ -1704,7 +1713,7 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	if (unlikely(ret))
 		remove_waiter(lock, waiter);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irq(&lock->wait_lock);
 
 	debug_rt_mutex_print_deadlock(waiter);
 
@@ -1754,14 +1763,14 @@ int rt_mutex_wait_proxy_lock(struct rt_mutex *lock,
 {
 	int ret;
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irq(&lock->wait_lock);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	/* sleep on the mutex */
 	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irq(&lock->wait_lock);
 
 	return ret;
 }
-- 
2.26.0.106.g9fadedd

