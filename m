Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02A934C5ED
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhC2IEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232039AbhC2IDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:03:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06D686196B;
        Mon, 29 Mar 2021 08:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005004;
        bh=+8ehP/BpZ6PHayYGFaXFKDQIcPboSDrYVlqKkGg97YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/D57goPh2bHZyqitolEMz2bjuFm/4tnmKu2MjOBJd6uH1r4Ar+fcaDatACFl2mTS
         X/OULSSWSmIxiQdJrfbHG3NebXpGkJTf2VAYhQPkl0pB81wdCj1ODOTr/nkLC3eGLA
         o255QEhmaDjcbG2Uk3PQu6Bgrf8ujoD5s6ORCMKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 45/53] locking/futex: Allow low-level atomic operations to return -EAGAIN
Date:   Mon, 29 Mar 2021 09:58:20 +0200
Message-Id: <20210329075608.987680356@linuxfoundation.org>
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

From: Will Deacon <will.deacon@arm.com>

commit 6b4f4bc9cb22875f97023984a625386f0c7cc1c0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |  185 +++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 115 insertions(+), 70 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1407,13 +1407,15 @@ static int lookup_pi_state(u32 __user *u
 
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
@@ -1606,10 +1608,8 @@ static int wake_futex_pi(u32 __user *uad
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
@@ -1795,32 +1795,32 @@ retry_private:
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
 
@@ -2516,14 +2516,17 @@ retry:
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
@@ -2538,23 +2541,36 @@ retry:
 	return argowner == current;
 
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
 
-	err = fault_in_user_writeable(uaddr);
+	switch (err) {
+	case -EFAULT:
+		err = fault_in_user_writeable(uaddr);
+		break;
+
+	case -EAGAIN:
+		cond_resched();
+		err = 0;
+		break;
+
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
 
 	spin_lock(q->lock_ptr);
 	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
@@ -3128,10 +3144,8 @@ retry:
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
@@ -3146,9 +3160,19 @@ retry:
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
@@ -3162,6 +3186,11 @@ out_putkey:
 	put_futex_key(&key);
 	return ret;
 
+pi_retry:
+	put_futex_key(&key);
+	cond_resched();
+	goto retry;
+
 pi_faulted:
 	put_futex_key(&key);
 
@@ -3504,6 +3533,7 @@ err_unlock:
 static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
 {
 	u32 uval, uninitialized_var(nval), mval;
+	int err;
 
 	/* Futex address must be 32bit aligned */
 	if ((((unsigned long)uaddr) % sizeof(*uaddr)) != 0)
@@ -3513,42 +3543,57 @@ retry:
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
 


