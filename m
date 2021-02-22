Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208DC321795
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhBVMuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhBVMqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:46:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7B5764F1B;
        Mon, 22 Feb 2021 12:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997726;
        bh=4god0mvrh5Tv9JCVObQuQ2l/tBxO8qqTb/vYLauObMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RItdeijtpkVAh+HzO9N8hwCbvVfOl2XWRYibPmi7zEhZXMx3LAzgQHpxig7UE/rOF
         VYXPVsv3faHecY6+0gHdJ/Fp70M39/CPj1VYRG4NUTXOoQfELuF3Ih3L8fc3ZW/aZ2
         ejiiT/LuqDpXGEUcfCZ1qdgaLn1Ubs+wBLOEJSwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        juri.lelli@arm.com, bigeasy@linutronix.de, xlpang@redhat.com,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        jdesfossez@efficios.com, dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 14/49] futex: Change locking rules
Date:   Mon, 22 Feb 2021 13:36:12 +0100
Message-Id: <20210222121025.901487433@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Currently futex-pi relies on hb->lock to serialize everything. But hb->lock
creates another set of problems, especially priority inversions on RT where
hb->lock becomes a rt_mutex itself.

The rt_mutex::wait_lock is the most obvious protection for keeping the
futex user space value and the kernel internal pi_state in sync.

Rework and document the locking so rt_mutex::wait_lock is held accross all
operations which modify the user space value and the pi state.

This allows to invoke rt_mutex_unlock() (including deboost) without holding
hb->lock as a next step.

Nothing yet relies on the new locking rules.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.751993333@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[Lee: Back-ported in support of a previous futex back-port attempt]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |  138 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 112 insertions(+), 26 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1019,6 +1019,39 @@ static void exit_pi_state_list(struct ta
  * [10] There is no transient state which leaves owner and user space
  *	TID out of sync. Except one error case where the kernel is denied
  *	write access to the user address, see fixup_pi_state_owner().
+ *
+ *
+ * Serialization and lifetime rules:
+ *
+ * hb->lock:
+ *
+ *	hb -> futex_q, relation
+ *	futex_q -> pi_state, relation
+ *
+ *	(cannot be raw because hb can contain arbitrary amount
+ *	 of futex_q's)
+ *
+ * pi_mutex->wait_lock:
+ *
+ *	{uval, pi_state}
+ *
+ *	(and pi_mutex 'obviously')
+ *
+ * p->pi_lock:
+ *
+ *	p->pi_state_list -> pi_state->list, relation
+ *
+ * pi_state->refcount:
+ *
+ *	pi_state lifetime
+ *
+ *
+ * Lock order:
+ *
+ *   hb->lock
+ *     pi_mutex->wait_lock
+ *       p->pi_lock
+ *
  */
 
 /*
@@ -1026,10 +1059,12 @@ static void exit_pi_state_list(struct ta
  * the pi_state against the user space value. If correct, attach to
  * it.
  */
-static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
+static int attach_to_pi_state(u32 __user *uaddr, u32 uval,
+			      struct futex_pi_state *pi_state,
 			      struct futex_pi_state **ps)
 {
 	pid_t pid = uval & FUTEX_TID_MASK;
+	int ret, uval2;
 
 	/*
 	 * Userspace might have messed up non-PI and PI futexes [3]
@@ -1037,9 +1072,34 @@ static int attach_to_pi_state(u32 uval,
 	if (unlikely(!pi_state))
 		return -EINVAL;
 
+	/*
+	 * We get here with hb->lock held, and having found a
+	 * futex_top_waiter(). This means that futex_lock_pi() of said futex_q
+	 * has dropped the hb->lock in between queue_me() and unqueue_me_pi(),
+	 * which in turn means that futex_lock_pi() still has a reference on
+	 * our pi_state.
+	 */
 	WARN_ON(!atomic_read(&pi_state->refcount));
 
 	/*
+	 * Now that we have a pi_state, we can acquire wait_lock
+	 * and do the state validation.
+	 */
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+
+	/*
+	 * Since {uval, pi_state} is serialized by wait_lock, and our current
+	 * uval was read without holding it, it can have changed. Verify it
+	 * still is what we expect it to be, otherwise retry the entire
+	 * operation.
+	 */
+	if (get_futex_value_locked(&uval2, uaddr))
+		goto out_efault;
+
+	if (uval != uval2)
+		goto out_eagain;
+
+	/*
 	 * Handle the owner died case:
 	 */
 	if (uval & FUTEX_OWNER_DIED) {
@@ -1054,11 +1114,11 @@ static int attach_to_pi_state(u32 uval,
 			 * is not 0. Inconsistent state. [5]
 			 */
 			if (pid)
-				return -EINVAL;
+				goto out_einval;
 			/*
 			 * Take a ref on the state and return success. [4]
 			 */
-			goto out_state;
+			goto out_attach;
 		}
 
 		/*
@@ -1070,14 +1130,14 @@ static int attach_to_pi_state(u32 uval,
 		 * Take a ref on the state and return success. [6]
 		 */
 		if (!pid)
-			goto out_state;
+			goto out_attach;
 	} else {
 		/*
 		 * If the owner died bit is not set, then the pi_state
 		 * must have an owner. [7]
 		 */
 		if (!pi_state->owner)
-			return -EINVAL;
+			goto out_einval;
 	}
 
 	/*
@@ -1086,11 +1146,29 @@ static int attach_to_pi_state(u32 uval,
 	 * user space TID. [9/10]
 	 */
 	if (pid != task_pid_vnr(pi_state->owner))
-		return -EINVAL;
-out_state:
+		goto out_einval;
+
+out_attach:
 	atomic_inc(&pi_state->refcount);
+	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	*ps = pi_state;
 	return 0;
+
+out_einval:
+	ret = -EINVAL;
+	goto out_error;
+
+out_eagain:
+	ret = -EAGAIN;
+	goto out_error;
+
+out_efault:
+	ret = -EFAULT;
+	goto out_error;
+
+out_error:
+	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
+	return ret;
 }
 
 /**
@@ -1183,6 +1261,9 @@ static int attach_to_pi_owner(u32 uval,
 
 	/*
 	 * No existing pi state. First waiter. [2]
+	 *
+	 * This creates pi_state, we have hb->lock held, this means nothing can
+	 * observe this state, wait_lock is irrelevant.
 	 */
 	pi_state = alloc_pi_state();
 
@@ -1207,7 +1288,8 @@ static int attach_to_pi_owner(u32 uval,
 	return 0;
 }
 
-static int lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
+static int lookup_pi_state(u32 __user *uaddr, u32 uval,
+			   struct futex_hash_bucket *hb,
 			   union futex_key *key, struct futex_pi_state **ps,
 			   struct task_struct **exiting)
 {
@@ -1218,7 +1300,7 @@ static int lookup_pi_state(u32 uval, str
 	 * attach to the pi_state when the validation succeeds.
 	 */
 	if (match)
-		return attach_to_pi_state(uval, match->pi_state, ps);
+		return attach_to_pi_state(uaddr, uval, match->pi_state, ps);
 
 	/*
 	 * We are the first waiter - try to look up the owner based on
@@ -1237,7 +1319,7 @@ static int lock_pi_update_atomic(u32 __u
 	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
 		return -EFAULT;
 
-	/*If user space value changed, let the caller retry */
+	/* If user space value changed, let the caller retry */
 	return curval != uval ? -EAGAIN : 0;
 }
 
@@ -1301,7 +1383,7 @@ static int futex_lock_pi_atomic(u32 __us
 	 */
 	match = futex_top_waiter(hb, key);
 	if (match)
-		return attach_to_pi_state(uval, match->pi_state, ps);
+		return attach_to_pi_state(uaddr, uval, match->pi_state, ps);
 
 	/*
 	 * No waiter and user TID is 0. We are here because the
@@ -1441,6 +1523,7 @@ static int wake_futex_pi(u32 __user *uad
 
 	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)) {
 		ret = -EFAULT;
+
 	} else if (curval != uval) {
 		/*
 		 * If a unconditional UNLOCK_PI operation (user space did not
@@ -1977,7 +2060,7 @@ retry_private:
 			 * If that call succeeds then we have pi_state and an
 			 * initial refcount on it.
 			 */
-			ret = lookup_pi_state(ret, hb2, &key2,
+			ret = lookup_pi_state(uaddr2, ret, hb2, &key2,
 					      &pi_state, &exiting);
 		}
 
@@ -2282,7 +2365,6 @@ static int __fixup_pi_state_owner(u32 __
 	int err = 0;
 
 	oldowner = pi_state->owner;
-
 	/* Owner died? */
 	if (!pi_state->owner)
 		newtid |= FUTEX_OWNER_DIED;
@@ -2305,11 +2387,10 @@ static int __fixup_pi_state_owner(u32 __
 	 * because we can fault here. Imagine swapped out pages or a fork
 	 * that marked all the anonymous memory readonly for cow.
 	 *
-	 * Modifying pi_state _before_ the user space value would
-	 * leave the pi_state in an inconsistent state when we fault
-	 * here, because we need to drop the hash bucket lock to
-	 * handle the fault. This might be observed in the PID check
-	 * in lookup_pi_state.
+	 * Modifying pi_state _before_ the user space value would leave the
+	 * pi_state in an inconsistent state when we fault here, because we
+	 * need to drop the locks to handle the fault. This might be observed
+	 * in the PID check in lookup_pi_state.
 	 */
 retry:
 	if (!argowner) {
@@ -2367,21 +2448,26 @@ retry:
 	return argowner == current;
 
 	/*
-	 * To handle the page fault we need to drop the hash bucket
-	 * lock here. That gives the other task (either the highest priority
-	 * waiter itself or the task which stole the rtmutex) the
-	 * chance to try the fixup of the pi_state. So once we are
-	 * back from handling the fault we need to check the pi_state
-	 * after reacquiring the hash bucket lock and before trying to
-	 * do another fixup. When the fixup has been done already we
-	 * simply return.
+	 * To handle the page fault we need to drop the locks here. That gives
+	 * the other task (either the highest priority waiter itself or the
+	 * task which stole the rtmutex) the chance to try the fixup of the
+	 * pi_state. So once we are back from handling the fault we need to
+	 * check the pi_state after reacquiring the locks and before trying to
+	 * do another fixup. When the fixup has been done already we simply
+	 * return.
+	 *
+	 * Note: we hold both hb->lock and pi_mutex->wait_lock. We can safely
+	 * drop hb->lock since the caller owns the hb -> futex_q relation.
+	 * Dropping the pi_mutex->wait_lock requires the state revalidate.
 	 */
 handle_fault:
+	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	spin_unlock(q->lock_ptr);
 
 	err = fault_in_user_writeable(uaddr);
 
 	spin_lock(q->lock_ptr);
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 
 	/*
 	 * Check if someone else fixed it for us:


