Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DE0336A88
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 04:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhCKDT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 22:19:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13082 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhCKDTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 22:19:16 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DwvHs1JQdzNl1h;
        Thu, 11 Mar 2021 11:16:57 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 11:19:05 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <gregkh@linuxfoundation.org>, <lee.jones@linaro.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <tglx@linutronix.de>, <cj.chengjian@huawei.com>,
        <judy.chenhui@huawei.com>, <zhangjinhao2@huawei.com>,
        <nixiaoming@huawei.com>
Subject: [PATCH 4.4 v2 1/3] futex: Change locking rules
Date:   Thu, 11 Mar 2021 11:25:58 +0800
Message-ID: <20210311032600.2326035-2-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210311032600.2326035-1-zhengyejian1@huawei.com>
References: <20210311032600.2326035-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 734009e96d1983ad739e5b656e03430b3660c913 upstream.

This patch comes directly from an origin patch (commit
dc3f2ff11740159080f2e8e359ae0ab57c8e74b6) in v4.9.

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
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 kernel/futex.c | 138 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 112 insertions(+), 26 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a14b7ef90e5c..b410752f5ad1 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1014,6 +1014,39 @@ static void exit_pi_state_list(struct task_struct *curr)
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
@@ -1021,10 +1054,12 @@ static void exit_pi_state_list(struct task_struct *curr)
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
@@ -1032,8 +1067,33 @@ static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
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
 
+	/*
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
 	/*
 	 * Handle the owner died case:
 	 */
@@ -1049,11 +1109,11 @@ static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
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
@@ -1065,14 +1125,14 @@ static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
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
@@ -1081,11 +1141,29 @@ static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
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
@@ -1178,6 +1256,9 @@ static int attach_to_pi_owner(u32 uval, union futex_key *key,
 
 	/*
 	 * No existing pi state. First waiter. [2]
+	 *
+	 * This creates pi_state, we have hb->lock held, this means nothing can
+	 * observe this state, wait_lock is irrelevant.
 	 */
 	pi_state = alloc_pi_state();
 
@@ -1202,7 +1283,8 @@ static int attach_to_pi_owner(u32 uval, union futex_key *key,
 	return 0;
 }
 
-static int lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
+static int lookup_pi_state(u32 __user *uaddr, u32 uval,
+			   struct futex_hash_bucket *hb,
 			   union futex_key *key, struct futex_pi_state **ps,
 			   struct task_struct **exiting)
 {
@@ -1213,7 +1295,7 @@ static int lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 	 * attach to the pi_state when the validation succeeds.
 	 */
 	if (match)
-		return attach_to_pi_state(uval, match->pi_state, ps);
+		return attach_to_pi_state(uaddr, uval, match->pi_state, ps);
 
 	/*
 	 * We are the first waiter - try to look up the owner based on
@@ -1232,7 +1314,7 @@ static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
 	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
 		return -EFAULT;
 
-	/*If user space value changed, let the caller retry */
+	/* If user space value changed, let the caller retry */
 	return curval != uval ? -EAGAIN : 0;
 }
 
@@ -1296,7 +1378,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
 	 */
 	match = futex_top_waiter(hb, key);
 	if (match)
-		return attach_to_pi_state(uval, match->pi_state, ps);
+		return attach_to_pi_state(uaddr, uval, match->pi_state, ps);
 
 	/*
 	 * No waiter and user TID is 0. We are here because the
@@ -1436,6 +1518,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
 
 	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)) {
 		ret = -EFAULT;
+
 	} else if (curval != uval) {
 		/*
 		 * If a unconditional UNLOCK_PI operation (user space did not
@@ -1969,7 +2052,7 @@ retry_private:
 			 * rereading and handing potential crap to
 			 * lookup_pi_state.
 			 */
-			ret = lookup_pi_state(ret, hb2, &key2,
+			ret = lookup_pi_state(uaddr2, ret, hb2, &key2,
 					      &pi_state, &exiting);
 		}
 
@@ -2247,7 +2330,6 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	int err = 0;
 
 	oldowner = pi_state->owner;
-
 	/*
 	 * We are here because either:
 	 *
@@ -2266,11 +2348,10 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
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
@@ -2331,21 +2412,26 @@ retry:
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
-- 
2.25.4

