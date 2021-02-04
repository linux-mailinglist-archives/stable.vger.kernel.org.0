Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640CE30C9B3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbhBBS0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:26:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233420AbhBBOFy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:05:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80FD665019;
        Tue,  2 Feb 2021 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273755;
        bh=l7DSdfusXlYapBrtokuenIdrnitA1unSjwUaeriQS+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WM+4JPG9McZ5PszgbVUrjvNH88E2msn3irEra1LK/ZdkD4jn6GxFStfs6jZD3m7We
         C+Y2f4QRq3J1Xc1Q+cdJN4gm01UeG9dht7S3MVy0Xpr9C7Yi7eDNIwYf1Q3FEBLDHk
         yk1ypHtmyfMecL+G31lLoFgywaPsKjKQztP/40s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 18/28] futex: Prevent exit livelock
Date:   Tue,  2 Feb 2021 14:38:38 +0100
Message-Id: <20210202132941.918691910@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132941.180062901@linuxfoundation.org>
References: <20210202132941.180062901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 3ef240eaff36b8119ac9e2ea17cbf41179c930ba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |  106 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 91 insertions(+), 15 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1067,12 +1067,43 @@ out_state:
 	return 0;
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
 /*
  * Lookup the task for the TID provided from user space and attach to
  * it after doing proper sanity checks.
  */
 static int attach_to_pi_owner(u32 uval, union futex_key *key,
-			      struct futex_pi_state **ps)
+			      struct futex_pi_state **ps,
+			      struct task_struct **exiting)
 {
 	pid_t pid = uval & FUTEX_TID_MASK;
 	struct futex_pi_state *pi_state;
@@ -1108,7 +1139,19 @@ static int attach_to_pi_owner(u32 uval,
 		int ret = (p->futex_state = FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;
 
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
 
@@ -1139,7 +1182,8 @@ static int attach_to_pi_owner(u32 uval,
 }
 
 static int lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
-			   union futex_key *key, struct futex_pi_state **ps)
+			   union futex_key *key, struct futex_pi_state **ps,
+			   struct task_struct **exiting)
 {
 	struct futex_q *match = futex_top_waiter(hb, key);
 
@@ -1154,7 +1198,7 @@ static int lookup_pi_state(u32 uval, str
 	 * We are the first waiter - try to look up the owner based on
 	 * @uval and attach to it.
 	 */
-	return attach_to_pi_owner(uval, key, ps);
+	return attach_to_pi_owner(uval, key, ps, exiting);
 }
 
 static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
@@ -1180,6 +1224,8 @@ static int lock_pi_update_atomic(u32 __u
  *			lookup
  * @task:		the task to perform the atomic lock work for.  This will
  *			be "current" except in the case of requeue pi.
+ * @exiting:		Pointer to store the task pointer of the owner task
+ *			which is in the middle of exiting
  * @set_waiters:	force setting the FUTEX_WAITERS bit (1) or not (0)
  *
  * Return:
@@ -1188,11 +1234,17 @@ static int lock_pi_update_atomic(u32 __u
  * <0 - error
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
 	struct futex_q *match;
@@ -1262,7 +1314,7 @@ static int futex_lock_pi_atomic(u32 __us
 	 * attach to the owner. If that fails, no harm done, we only
 	 * set the FUTEX_WAITERS bit in the user space variable.
 	 */
-	return attach_to_pi_owner(uval, key, ps);
+	return attach_to_pi_owner(uval, key, ps, exiting);
 }
 
 /**
@@ -1688,6 +1740,8 @@ void requeue_pi_wake_futex(struct futex_
  * @key1:		the from futex key
  * @key2:		the to futex key
  * @ps:			address to store the pi_state pointer
+ * @exiting:		Pointer to store the task pointer of the owner task
+ *			which is in the middle of exiting
  * @set_waiters:	force setting the FUTEX_WAITERS bit (1) or not (0)
  *
  * Try and get the lock on behalf of the top waiter if we can do it atomically.
@@ -1695,16 +1749,20 @@ void requeue_pi_wake_futex(struct futex_
  * then direct futex_lock_pi_atomic() to force setting the FUTEX_WAITERS bit.
  * hb1 and hb2 must be held by the caller.
  *
+ * @exiting is only set when the return value is -EBUSY. If so, this holds
+ * a refcount on the exiting task on return and the caller needs to drop it
+ * after waiting for the exit to complete.
+ *
  * Return:
  *  0 - failed to acquire the lock atomically;
  * >0 - acquired the lock, return value is vpid of the top_waiter
  * <0 - error
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
@@ -1741,7 +1799,7 @@ static int futex_proxy_trylock_atomic(u3
 	 */
 	vpid = task_pid_vnr(top_waiter->task);
 	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
-				   set_waiters);
+				   exiting, set_waiters);
 	if (ret == 1) {
 		requeue_pi_wake_futex(top_waiter, key2, hb2);
 		return vpid;
@@ -1861,6 +1919,8 @@ retry_private:
 	}
 
 	if (requeue_pi && (task_count - nr_wake < nr_requeue)) {
+		struct task_struct *exiting = NULL;
+
 		/*
 		 * Attempt to acquire uaddr2 and wake the top waiter. If we
 		 * intend to requeue waiters, force setting the FUTEX_WAITERS
@@ -1868,7 +1928,8 @@ retry_private:
 		 * faults rather in the requeue loop below.
 		 */
 		ret = futex_proxy_trylock_atomic(uaddr2, hb1, hb2, &key1,
-						 &key2, &pi_state, nr_requeue);
+						 &key2, &pi_state,
+						 &exiting, nr_requeue);
 
 		/*
 		 * At this point the top_waiter has either taken uaddr2 or is
@@ -1892,7 +1953,8 @@ retry_private:
 			 * rereading and handing potential crap to
 			 * lookup_pi_state.
 			 */
-			ret = lookup_pi_state(ret, hb2, &key2, &pi_state);
+			ret = lookup_pi_state(ret, hb2, &key2,
+					      &pi_state, &exiting);
 		}
 
 		switch (ret) {
@@ -1923,6 +1985,12 @@ retry_private:
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
@@ -2545,6 +2613,7 @@ static int futex_lock_pi(u32 __user *uad
 			 ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
+	struct task_struct *exiting = NULL;
 	struct futex_hash_bucket *hb;
 	struct futex_q q = futex_q_init;
 	int res, ret;
@@ -2568,7 +2637,8 @@ retry:
 retry_private:
 	hb = queue_lock(&q);
 
-	ret = futex_lock_pi_atomic(uaddr, hb, &q.key, &q.pi_state, current, 0);
+	ret = futex_lock_pi_atomic(uaddr, hb, &q.key, &q.pi_state, current,
+				   &exiting, 0);
 	if (unlikely(ret)) {
 		/*
 		 * Atomic work succeeded and we got the lock,
@@ -2591,6 +2661,12 @@ retry_private:
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


