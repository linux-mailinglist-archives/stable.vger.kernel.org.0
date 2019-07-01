Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87B218FA2
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 19:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfEIRwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 13:52:05 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42009 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726656AbfEIRwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 13:52:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1CB1123956;
        Thu,  9 May 2019 13:52:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 09 May 2019 13:52:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Aiht7g
        mgG8DCNsCyMv+3dbczrTeHVupDU5n+MfPJ66o=; b=M9QxiewuyR1/vPMhBsf/3t
        +AGFCSCNhvMZsZ6IVHl52BxKexjRjxzhlWGRtzPLhZGkzBQyHAiBLLvivZAbFUFn
        /gKswx9V5etRPJQVmHs0tXr57ZMNLIAaha+90Pubkybun9bAo5Vsx9BbwNVtRjgz
        I+eZyA/SzZBK0L+122aFlC4WwkB2RCrXW7z0mpaUGwmjXz58lemw67PCe6j4li8F
        +Cq/i20gt7MaTQYuLrimQK1K9H4EPHCioaqgSRbSjkRPIEvKD+K6LQenojnsH3Gc
        fyj2EC2yg+S5tljczPeyw8qnTnXwloWGU3/920aXeA+hqLtDfF5TBzoDGyBy03uw
        ==
X-ME-Sender: <xms:w2jUXEpZOYQLAl1F-mnb0lWDRICO7CA9-xe393-ctJpz1rPfcJ5HlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeeigdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:w2jUXPds7kpVhGOeAUIcoeQpubuz2XXPCcC6QA2-uQOof7HUzjQslw>
    <xmx:w2jUXN5SqfULTYCzmwp8ckcepn5gOpvuyU5COL6NOhv4-GJHC4gg3Q>
    <xmx:w2jUXDwul22Xc85qMn_5f6-ocLDFkGNJuGsdQb0WHoWZTIrN2qTDzw>
    <xmx:xGjUXCBwKAwWSt-HENu1nyAKpdHflWXq_P4Fi3zPqORP4JLC0cWzdw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7549280063;
        Thu,  9 May 2019 13:52:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] locking/futex: Allow low-level atomic operations to return" failed to apply to 3.18-stable tree
To:     will.deacon@arm.com, peterz@infradead.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 09 May 2019 19:52:02 +0200
Message-ID: <1557424322212129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 3.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6b4f4bc9cb22875f97023984a625386f0c7cc1c0 Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Thu, 28 Feb 2019 11:58:08 +0000
Subject: [PATCH] locking/futex: Allow low-level atomic operations to return
 -EAGAIN

Some futex() operations, including FUTEX_WAKE_OP, require the kernel to
perform an atomic read-modify-write of the futex word via the userspace
mapping. These operations are implemented by each architecture in
arch_futex_atomic_op_inuser() and futex_atomic_cmpxchg_inatomic(), which
are called in atomic context with the relevant hash bucket locks held.

Although these routines may return -EFAULT in response to a page fault
generated when accessing userspace, they are expected to succeed (i.e.
return 0) in all other cases. This poses a problem for architectures
that do not provide bounded forward progress guarantees or fairness of
contended atomic operations and can lead to starvation in some cases.

In these problematic scenarios, we must return back to the core futex
code so that we can drop the hash bucket locks and reschedule if
necessary, much like we do in the case of a page fault.

Allow architectures to return -EAGAIN from their implementations of
arch_futex_atomic_op_inuser() and futex_atomic_cmpxchg_inatomic(), which
will cause the core futex code to reschedule if necessary and return
back to the architecture code later on.

Cc: <stable@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>

diff --git a/kernel/futex.c b/kernel/futex.c
index 9e40cf7be606..6262f1534ac9 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1311,13 +1311,15 @@ static int lookup_pi_state(u32 __user *uaddr, u32 uval,
 
 static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
 {
+	int err;
 	u32 uninitialized_var(curval);
 
 	if (unlikely(should_fail_futex(true)))
 		return -EFAULT;
 
-	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
-		return -EFAULT;
+	err = cmpxchg_futex_value_locked(&curval, uaddr, uval, newval);
+	if (unlikely(err))
+		return err;
 
 	/* If user space value changed, let the caller retry */
 	return curval != uval ? -EAGAIN : 0;
@@ -1502,10 +1504,8 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_pi_state *pi_
 	if (unlikely(should_fail_futex(true)))
 		ret = -EFAULT;
 
-	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)) {
-		ret = -EFAULT;
-
-	} else if (curval != uval) {
+	ret = cmpxchg_futex_value_locked(&curval, uaddr, uval, newval);
+	if (!ret && (curval != uval)) {
 		/*
 		 * If a unconditional UNLOCK_PI operation (user space did not
 		 * try the TID->0 transition) raced with a waiter setting the
@@ -1700,32 +1700,32 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 	double_lock_hb(hb1, hb2);
 	op_ret = futex_atomic_op_inuser(op, uaddr2);
 	if (unlikely(op_ret < 0)) {
-
 		double_unlock_hb(hb1, hb2);
 
-#ifndef CONFIG_MMU
-		/*
-		 * we don't get EFAULT from MMU faults if we don't have an MMU,
-		 * but we might get them from range checking
-		 */
-		ret = op_ret;
-		goto out_put_keys;
-#endif
-
-		if (unlikely(op_ret != -EFAULT)) {
+		if (!IS_ENABLED(CONFIG_MMU) ||
+		    unlikely(op_ret != -EFAULT && op_ret != -EAGAIN)) {
+			/*
+			 * we don't get EFAULT from MMU faults if we don't have
+			 * an MMU, but we might get them from range checking
+			 */
 			ret = op_ret;
 			goto out_put_keys;
 		}
 
-		ret = fault_in_user_writeable(uaddr2);
-		if (ret)
-			goto out_put_keys;
+		if (op_ret == -EFAULT) {
+			ret = fault_in_user_writeable(uaddr2);
+			if (ret)
+				goto out_put_keys;
+		}
 
-		if (!(flags & FLAGS_SHARED))
+		if (!(flags & FLAGS_SHARED)) {
+			cond_resched();
 			goto retry_private;
+		}
 
 		put_futex_key(&key2);
 		put_futex_key(&key1);
+		cond_resched();
 		goto retry;
 	}
 
@@ -2350,7 +2350,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	u32 uval, uninitialized_var(curval), newval;
 	struct task_struct *oldowner, *newowner;
 	u32 newtid;
-	int ret;
+	int ret, err = 0;
 
 	lockdep_assert_held(q->lock_ptr);
 
@@ -2421,14 +2421,17 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	if (!pi_state->owner)
 		newtid |= FUTEX_OWNER_DIED;
 
-	if (get_futex_value_locked(&uval, uaddr))
-		goto handle_fault;
+	err = get_futex_value_locked(&uval, uaddr);
+	if (err)
+		goto handle_err;
 
 	for (;;) {
 		newval = (uval & FUTEX_OWNER_DIED) | newtid;
 
-		if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
-			goto handle_fault;
+		err = cmpxchg_futex_value_locked(&curval, uaddr, uval, newval);
+		if (err)
+			goto handle_err;
+
 		if (curval == uval)
 			break;
 		uval = curval;
@@ -2456,23 +2459,37 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	return 0;
 
 	/*
-	 * To handle the page fault we need to drop the locks here. That gives
-	 * the other task (either the highest priority waiter itself or the
-	 * task which stole the rtmutex) the chance to try the fixup of the
-	 * pi_state. So once we are back from handling the fault we need to
-	 * check the pi_state after reacquiring the locks and before trying to
-	 * do another fixup. When the fixup has been done already we simply
-	 * return.
+	 * In order to reschedule or handle a page fault, we need to drop the
+	 * locks here. In the case of a fault, this gives the other task
+	 * (either the highest priority waiter itself or the task which stole
+	 * the rtmutex) the chance to try the fixup of the pi_state. So once we
+	 * are back from handling the fault we need to check the pi_state after
+	 * reacquiring the locks and before trying to do another fixup. When
+	 * the fixup has been done already we simply return.
 	 *
 	 * Note: we hold both hb->lock and pi_mutex->wait_lock. We can safely
 	 * drop hb->lock since the caller owns the hb -> futex_q relation.
 	 * Dropping the pi_mutex->wait_lock requires the state revalidate.
 	 */
-handle_fault:
+handle_err:
 	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	spin_unlock(q->lock_ptr);
 
-	ret = fault_in_user_writeable(uaddr);
+	switch (err) {
+	case -EFAULT:
+		ret = fault_in_user_writeable(uaddr);
+		break;
+
+	case -EAGAIN:
+		cond_resched();
+		ret = 0;
+		break;
+
+	default:
+		WARN_ON_ONCE(1);
+		ret = err;
+		break;
+	}
 
 	spin_lock(q->lock_ptr);
 	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
@@ -3041,10 +3058,8 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 		 * A unconditional UNLOCK_PI op raced against a waiter
 		 * setting the FUTEX_WAITERS bit. Try again.
 		 */
-		if (ret == -EAGAIN) {
-			put_futex_key(&key);
-			goto retry;
-		}
+		if (ret == -EAGAIN)
+			goto pi_retry;
 		/*
 		 * wake_futex_pi has detected invalid state. Tell user
 		 * space.
@@ -3059,9 +3074,19 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 	 * preserve the WAITERS bit not the OWNER_DIED one. We are the
 	 * owner.
 	 */
-	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, 0)) {
+	if ((ret = cmpxchg_futex_value_locked(&curval, uaddr, uval, 0))) {
 		spin_unlock(&hb->lock);
-		goto pi_faulted;
+		switch (ret) {
+		case -EFAULT:
+			goto pi_faulted;
+
+		case -EAGAIN:
+			goto pi_retry;
+
+		default:
+			WARN_ON_ONCE(1);
+			goto out_putkey;
+		}
 	}
 
 	/*
@@ -3075,6 +3100,11 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 	put_futex_key(&key);
 	return ret;
 
+pi_retry:
+	put_futex_key(&key);
+	cond_resched();
+	goto retry;
+
 pi_faulted:
 	put_futex_key(&key);
 
@@ -3435,6 +3465,7 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
 {
 	u32 uval, uninitialized_var(nval), mval;
+	int err;
 
 	/* Futex address must be 32bit aligned */
 	if ((((unsigned long)uaddr) % sizeof(*uaddr)) != 0)
@@ -3444,42 +3475,57 @@ static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int p
 	if (get_user(uval, uaddr))
 		return -1;
 
-	if ((uval & FUTEX_TID_MASK) == task_pid_vnr(curr)) {
-		/*
-		 * Ok, this dying thread is truly holding a futex
-		 * of interest. Set the OWNER_DIED bit atomically
-		 * via cmpxchg, and if the value had FUTEX_WAITERS
-		 * set, wake up a waiter (if any). (We have to do a
-		 * futex_wake() even if OWNER_DIED is already set -
-		 * to handle the rare but possible case of recursive
-		 * thread-death.) The rest of the cleanup is done in
-		 * userspace.
-		 */
-		mval = (uval & FUTEX_WAITERS) | FUTEX_OWNER_DIED;
-		/*
-		 * We are not holding a lock here, but we want to have
-		 * the pagefault_disable/enable() protection because
-		 * we want to handle the fault gracefully. If the
-		 * access fails we try to fault in the futex with R/W
-		 * verification via get_user_pages. get_user() above
-		 * does not guarantee R/W access. If that fails we
-		 * give up and leave the futex locked.
-		 */
-		if (cmpxchg_futex_value_locked(&nval, uaddr, uval, mval)) {
+	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(curr))
+		return 0;
+
+	/*
+	 * Ok, this dying thread is truly holding a futex
+	 * of interest. Set the OWNER_DIED bit atomically
+	 * via cmpxchg, and if the value had FUTEX_WAITERS
+	 * set, wake up a waiter (if any). (We have to do a
+	 * futex_wake() even if OWNER_DIED is already set -
+	 * to handle the rare but possible case of recursive
+	 * thread-death.) The rest of the cleanup is done in
+	 * userspace.
+	 */
+	mval = (uval & FUTEX_WAITERS) | FUTEX_OWNER_DIED;
+
+	/*
+	 * We are not holding a lock here, but we want to have
+	 * the pagefault_disable/enable() protection because
+	 * we want to handle the fault gracefully. If the
+	 * access fails we try to fault in the futex with R/W
+	 * verification via get_user_pages. get_user() above
+	 * does not guarantee R/W access. If that fails we
+	 * give up and leave the futex locked.
+	 */
+	if ((err = cmpxchg_futex_value_locked(&nval, uaddr, uval, mval))) {
+		switch (err) {
+		case -EFAULT:
 			if (fault_in_user_writeable(uaddr))
 				return -1;
 			goto retry;
-		}
-		if (nval != uval)
+
+		case -EAGAIN:
+			cond_resched();
 			goto retry;
 
-		/*
-		 * Wake robust non-PI futexes here. The wakeup of
-		 * PI futexes happens in exit_pi_state():
-		 */
-		if (!pi && (uval & FUTEX_WAITERS))
-			futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
+		default:
+			WARN_ON_ONCE(1);
+			return err;
+		}
 	}
+
+	if (nval != uval)
+		goto retry;
+
+	/*
+	 * Wake robust non-PI futexes here. The wakeup of
+	 * PI futexes happens in exit_pi_state():
+	 */
+	if (!pi && (uval & FUTEX_WAITERS))
+		futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
+
 	return 0;
 }
 

