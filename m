Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1B101036E0
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 10:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbfKTJjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 04:39:20 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55861 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbfKTJid (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 04:38:33 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iXMRN-0003xL-5g; Wed, 20 Nov 2019 10:38:25 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id C136D1C1998;
        Wed, 20 Nov 2019 10:38:24 +0100 (CET)
Date:   Wed, 20 Nov 2019 09:38:24 -0000
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/core] futex: Prevent exit livelock
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Stable Team <stable@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20191106224557.041676471@linutronix.de>
References: <20191106224557.041676471@linutronix.de>
MIME-Version: 1.0
Message-ID: <157424270465.12247.13535676939680910612.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/core branch of tip:

Commit-ID:     3ef240eaff36b8119ac9e2ea17cbf41179c930ba
Gitweb:        https://git.kernel.org/tip/3ef240eaff36b8119ac9e2ea17cbf41179c930ba
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 06 Nov 2019 22:55:46 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 20 Nov 2019 09:40:38 +01:00

futex: Prevent exit livelock

Oleg provided the following test case:

int main(void)
{
	struct sched_param sp = {};

	sp.sched_priority = 2;
	assert(sched_setscheduler(0, SCHED_FIFO, &sp) == 0);

	int lock = vfork();
	if (!lock) {
		sp.sched_priority = 1;
		assert(sched_setscheduler(0, SCHED_FIFO, &sp) == 0);
		_exit(0);
	}

	syscall(__NR_futex, &lock, FUTEX_LOCK_PI, 0,0,0);
	return 0;
}

This creates an unkillable RT process spinning in futex_lock_pi() on a UP
machine or if the process is affine to a single CPU. The reason is:

 parent	    	    			child

  set FIFO prio 2

  vfork()			->	set FIFO prio 1
   implies wait_for_child()	 	sched_setscheduler(...)
 			   		exit()
					do_exit()
 					....
					mm_release()
					  tsk->futex_state = FUTEX_STATE_EXITING;
					  exit_futex(); (NOOP in this case)
					  complete() --> wakes parent
  sys_futex()
    loop infinite because
    tsk->futex_state == FUTEX_STATE_EXITING

The same problem can happen just by regular preemption as well:

  task holds futex
  ...
  do_exit()
    tsk->futex_state = FUTEX_STATE_EXITING;

  --> preemption (unrelated wakeup of some other higher prio task, e.g. timer)

  switch_to(other_task)

  return to user
  sys_futex()
	loop infinite as above

Just for the fun of it the futex exit cleanup could trigger the wakeup
itself before the task sets its futex state to DEAD.

To cure this, the handling of the exiting owner is changed so:

   - A refcount is held on the task

   - The task pointer is stored in a caller visible location

   - The caller drops all locks (hash bucket, mmap_sem) and blocks
     on task::futex_exit_mutex. When the mutex is acquired then
     the exiting task has completed the cleanup and the state
     is consistent and can be reevaluated.

This is not a pretty solution, but there is no choice other than returning
an error code to user space, which would break the state consistency
guarantee and open another can of problems including regressions.

For stable backports the preparatory commits ac31c7ff8624 .. ba31c1a48538
are required as well, but for anything older than 5.3.y the backports are
going to be provided when this hits mainline as the other dependencies for
those kernels are definitely not stable material.

Fixes: 778e9a9c3e71 ("pi-futex: fix exit races and locking problems")
Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Stable Team <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20191106224557.041676471@linutronix.de
---
 kernel/futex.c | 106 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 91 insertions(+), 15 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 4f9d7a4..03c518e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1176,6 +1176,36 @@ out_error:
 	return ret;
 }
 
+/**
+ * wait_for_owner_exiting - Block until the owner has exited
+ * @exiting:	Pointer to the exiting task
+ *
+ * Caller must hold a refcount on @exiting.
+ */
+static void wait_for_owner_exiting(int ret, struct task_struct *exiting)
+{
+	if (ret != -EBUSY) {
+		WARN_ON_ONCE(exiting);
+		return;
+	}
+
+	if (WARN_ON_ONCE(ret == -EBUSY && !exiting))
+		return;
+
+	mutex_lock(&exiting->futex_exit_mutex);
+	/*
+	 * No point in doing state checking here. If the waiter got here
+	 * while the task was in exec()->exec_futex_release() then it can
+	 * have any FUTEX_STATE_* value when the waiter has acquired the
+	 * mutex. OK, if running, EXITING or DEAD if it reached exit()
+	 * already. Highly unlikely and not a problem. Just one more round
+	 * through the futex maze.
+	 */
+	mutex_unlock(&exiting->futex_exit_mutex);
+
+	put_task_struct(exiting);
+}
+
 static int handle_exit_race(u32 __user *uaddr, u32 uval,
 			    struct task_struct *tsk)
 {
@@ -1237,7 +1267,8 @@ static int handle_exit_race(u32 __user *uaddr, u32 uval,
  * it after doing proper sanity checks.
  */
 static int attach_to_pi_owner(u32 __user *uaddr, u32 uval, union futex_key *key,
-			      struct futex_pi_state **ps)
+			      struct futex_pi_state **ps,
+			      struct task_struct **exiting)
 {
 	pid_t pid = uval & FUTEX_TID_MASK;
 	struct futex_pi_state *pi_state;
@@ -1276,7 +1307,19 @@ static int attach_to_pi_owner(u32 __user *uaddr, u32 uval, union futex_key *key,
 		int ret = handle_exit_race(uaddr, uval, p);
 
 		raw_spin_unlock_irq(&p->pi_lock);
-		put_task_struct(p);
+		/*
+		 * If the owner task is between FUTEX_STATE_EXITING and
+		 * FUTEX_STATE_DEAD then store the task pointer and keep
+		 * the reference on the task struct. The calling code will
+		 * drop all locks, wait for the task to reach
+		 * FUTEX_STATE_DEAD and then drop the refcount. This is
+		 * required to prevent a live lock when the current task
+		 * preempted the exiting task between the two states.
+		 */
+		if (ret == -EBUSY)
+			*exiting = p;
+		else
+			put_task_struct(p);
 		return ret;
 	}
 
@@ -1315,7 +1358,8 @@ static int attach_to_pi_owner(u32 __user *uaddr, u32 uval, union futex_key *key,
 
 static int lookup_pi_state(u32 __user *uaddr, u32 uval,
 			   struct futex_hash_bucket *hb,
-			   union futex_key *key, struct futex_pi_state **ps)
+			   union futex_key *key, struct futex_pi_state **ps,
+			   struct task_struct **exiting)
 {
 	struct futex_q *top_waiter = futex_top_waiter(hb, key);
 
@@ -1330,7 +1374,7 @@ static int lookup_pi_state(u32 __user *uaddr, u32 uval,
 	 * We are the first waiter - try to look up the owner based on
 	 * @uval and attach to it.
 	 */
-	return attach_to_pi_owner(uaddr, uval, key, ps);
+	return attach_to_pi_owner(uaddr, uval, key, ps, exiting);
 }
 
 static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
@@ -1358,6 +1402,8 @@ static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
  *			lookup
  * @task:		the task to perform the atomic lock work for.  This will
  *			be "current" except in the case of requeue pi.
+ * @exiting:		Pointer to store the task pointer of the owner task
+ *			which is in the middle of exiting
  * @set_waiters:	force setting the FUTEX_WAITERS bit (1) or not (0)
  *
  * Return:
@@ -1366,11 +1412,17 @@ static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
  *  - <0 - error
  *
  * The hb->lock and futex_key refs shall be held by the caller.
+ *
+ * @exiting is only set when the return value is -EBUSY. If so, this holds
+ * a refcount on the exiting task on return and the caller needs to drop it
+ * after waiting for the exit to complete.
  */
 static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
 				union futex_key *key,
 				struct futex_pi_state **ps,
-				struct task_struct *task, int set_waiters)
+				struct task_struct *task,
+				struct task_struct **exiting,
+				int set_waiters)
 {
 	u32 uval, newval, vpid = task_pid_vnr(task);
 	struct futex_q *top_waiter;
@@ -1440,7 +1492,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
 	 * attach to the owner. If that fails, no harm done, we only
 	 * set the FUTEX_WAITERS bit in the user space variable.
 	 */
-	return attach_to_pi_owner(uaddr, newval, key, ps);
+	return attach_to_pi_owner(uaddr, newval, key, ps, exiting);
 }
 
 /**
@@ -1858,6 +1910,8 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
  * @key1:		the from futex key
  * @key2:		the to futex key
  * @ps:			address to store the pi_state pointer
+ * @exiting:		Pointer to store the task pointer of the owner task
+ *			which is in the middle of exiting
  * @set_waiters:	force setting the FUTEX_WAITERS bit (1) or not (0)
  *
  * Try and get the lock on behalf of the top waiter if we can do it atomically.
@@ -1865,16 +1919,20 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
  * then direct futex_lock_pi_atomic() to force setting the FUTEX_WAITERS bit.
  * hb1 and hb2 must be held by the caller.
  *
+ * @exiting is only set when the return value is -EBUSY. If so, this holds
+ * a refcount on the exiting task on return and the caller needs to drop it
+ * after waiting for the exit to complete.
+ *
  * Return:
  *  -  0 - failed to acquire the lock atomically;
  *  - >0 - acquired the lock, return value is vpid of the top_waiter
  *  - <0 - error
  */
-static int futex_proxy_trylock_atomic(u32 __user *pifutex,
-				 struct futex_hash_bucket *hb1,
-				 struct futex_hash_bucket *hb2,
-				 union futex_key *key1, union futex_key *key2,
-				 struct futex_pi_state **ps, int set_waiters)
+static int
+futex_proxy_trylock_atomic(u32 __user *pifutex, struct futex_hash_bucket *hb1,
+			   struct futex_hash_bucket *hb2, union futex_key *key1,
+			   union futex_key *key2, struct futex_pi_state **ps,
+			   struct task_struct **exiting, int set_waiters)
 {
 	struct futex_q *top_waiter = NULL;
 	u32 curval;
@@ -1911,7 +1969,7 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 	 */
 	vpid = task_pid_vnr(top_waiter->task);
 	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
-				   set_waiters);
+				   exiting, set_waiters);
 	if (ret == 1) {
 		requeue_pi_wake_futex(top_waiter, key2, hb2);
 		return vpid;
@@ -2040,6 +2098,8 @@ retry_private:
 	}
 
 	if (requeue_pi && (task_count - nr_wake < nr_requeue)) {
+		struct task_struct *exiting = NULL;
+
 		/*
 		 * Attempt to acquire uaddr2 and wake the top waiter. If we
 		 * intend to requeue waiters, force setting the FUTEX_WAITERS
@@ -2047,7 +2107,8 @@ retry_private:
 		 * faults rather in the requeue loop below.
 		 */
 		ret = futex_proxy_trylock_atomic(uaddr2, hb1, hb2, &key1,
-						 &key2, &pi_state, nr_requeue);
+						 &key2, &pi_state,
+						 &exiting, nr_requeue);
 
 		/*
 		 * At this point the top_waiter has either taken uaddr2 or is
@@ -2074,7 +2135,8 @@ retry_private:
 			 * If that call succeeds then we have pi_state and an
 			 * initial refcount on it.
 			 */
-			ret = lookup_pi_state(uaddr2, ret, hb2, &key2, &pi_state);
+			ret = lookup_pi_state(uaddr2, ret, hb2, &key2,
+					      &pi_state, &exiting);
 		}
 
 		switch (ret) {
@@ -2104,6 +2166,12 @@ retry_private:
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
 			put_futex_key(&key1);
+			/*
+			 * Handle the case where the owner is in the middle of
+			 * exiting. Wait for the exit to complete otherwise
+			 * this task might loop forever, aka. live lock.
+			 */
+			wait_for_owner_exiting(ret, exiting);
 			cond_resched();
 			goto retry;
 		default:
@@ -2810,6 +2878,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags,
 {
 	struct hrtimer_sleeper timeout, *to;
 	struct futex_pi_state *pi_state = NULL;
+	struct task_struct *exiting = NULL;
 	struct rt_mutex_waiter rt_waiter;
 	struct futex_hash_bucket *hb;
 	struct futex_q q = futex_q_init;
@@ -2831,7 +2900,8 @@ retry:
 retry_private:
 	hb = queue_lock(&q);
 
-	ret = futex_lock_pi_atomic(uaddr, hb, &q.key, &q.pi_state, current, 0);
+	ret = futex_lock_pi_atomic(uaddr, hb, &q.key, &q.pi_state, current,
+				   &exiting, 0);
 	if (unlikely(ret)) {
 		/*
 		 * Atomic work succeeded and we got the lock,
@@ -2854,6 +2924,12 @@ retry_private:
 			 */
 			queue_unlock(hb);
 			put_futex_key(&q.key);
+			/*
+			 * Handle the case where the owner is in the middle of
+			 * exiting. Wait for the exit to complete otherwise
+			 * this task might loop forever, aka. live lock.
+			 */
+			wait_for_owner_exiting(ret, exiting);
 			cond_resched();
 			goto retry;
 		default:
