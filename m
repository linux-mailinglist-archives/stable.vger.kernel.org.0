Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74025304C13
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbhAZWA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405256AbhAZUFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 15:05:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF37C061573;
        Tue, 26 Jan 2021 12:04:58 -0800 (PST)
Date:   Tue, 26 Jan 2021 20:04:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611691496;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=sA5ix1P9+mWqmy/XzGk8etz+MYjl1kW34ACX7l5wWb0=;
        b=NfKOV5NpLd4xFFJw7ZgRnpBDsOoQk8KuEnh9krrILt/ghsaMreJnEVincVSHMXC0EcyHbL
        F2waYZqAJltQq0pV8Keqx8elD4KCKPqasZacrvDUY3hZ8SZmzrLJK6qIXp4sEV0dVuf5f5
        dwQFTdIpfDEOTlHIPON+B0y5D0YNbVWOrkmX0GsXSpSxWIGGDMf5QjKgULmdE6E7fkGLCw
        s3vSx4fi/rzweP0d27J//ZW+pCvdYL1fzmCs7PFNouDQ8C2VIoHBWq0VEPIuXUEHmdg9Cv
        56T6A1rhyzz1VoBAJ4avNC5Hji5sOiuekxMV9eSiZR0Ji09fFPTkAo0DcQ6F7A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611691496;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=sA5ix1P9+mWqmy/XzGk8etz+MYjl1kW34ACX7l5wWb0=;
        b=DeSiV/6Buqk4YcK0PfIkSZMOeX3S1JYutK/3AnCd32XEjQ1j24zVmVuijvhoK+3Ob0ssT9
        fpmg/PQVSta/GkBA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] futex: Handle faults correctly for PI futexes
Cc:     gzobqq@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <161169149342.414.8559258090719789917.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     34b1a1ce1458f50ef27c54e28eb9b1947012907a
Gitweb:        https://git.kernel.org/tip/34b1a1ce1458f50ef27c54e28eb9b1947012907a
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Mon, 18 Jan 2021 19:01:21 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 26 Jan 2021 15:11:00 +01:00

futex: Handle faults correctly for PI futexes

fixup_pi_state_owner() tries to ensure that the state of the rtmutex,
pi_state and the user space value related to the PI futex are consistent
before returning to user space. In case that the user space value update
faults and the fault cannot be resolved by faulting the page in via
fault_in_user_writeable() the function returns with -EFAULT and leaves
the rtmutex and pi_state owner state inconsistent.

A subsequent futex_unlock_pi() operates on the inconsistent pi_state and
releases the rtmutex despite not owning it which can corrupt the RB tree of
the rtmutex and cause a subsequent kernel stack use after free.

It was suggested to loop forever in fixup_pi_state_owner() if the fault
cannot be resolved, but that results in runaway tasks which is especially
undesired when the problem happens due to a programming error and not due
to malice.

As the user space value cannot be fixed up, the proper solution is to make
the rtmutex and the pi_state consistent so both have the same owner. This
leaves the user space value out of sync. Any subsequent operation on the
futex will fail because the 10th rule of PI futexes (pi_state owner and
user space value are consistent) has been violated.

As a consequence this removes the inept attempts of 'fixing' the situation
in case that the current task owns the rtmutex when returning with an
unresolvable fault by unlocking the rtmutex which left pi_state::owner and
rtmutex::owner out of sync in a different and only slightly less dangerous
way.

Fixes: 1b7558e457ed ("futexes: fix fault handling in futex_lock_pi")
Reported-by: gzobqq@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
---
 kernel/futex.c | 57 +++++++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 37 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 7a38ead..45a13eb 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -958,7 +958,8 @@ static inline void exit_pi_state_list(struct task_struct *curr) { }
  *	FUTEX_OWNER_DIED bit. See [4]
  *
  * [10] There is no transient state which leaves owner and user space
- *	TID out of sync.
+ *	TID out of sync. Except one error case where the kernel is denied
+ *	write access to the user address, see fixup_pi_state_owner().
  *
  *
  * Serialization and lifetime rules:
@@ -2480,6 +2481,24 @@ handle_err:
 	if (!err)
 		goto retry;
 
+	/*
+	 * fault_in_user_writeable() failed so user state is immutable. At
+	 * best we can make the kernel state consistent but user state will
+	 * be most likely hosed and any subsequent unlock operation will be
+	 * rejected due to PI futex rule [10].
+	 *
+	 * Ensure that the rtmutex owner is also the pi_state owner despite
+	 * the user space value claiming something different. There is no
+	 * point in unlocking the rtmutex if current is the owner as it
+	 * would need to wait until the next waiter has taken the rtmutex
+	 * to guarantee consistent state. Keep it simple. Userspace asked
+	 * for this wreckaged state.
+	 *
+	 * The rtmutex has an owner - either current or some other
+	 * task. See the EAGAIN loop above.
+	 */
+	pi_state_update_owner(pi_state, rt_mutex_owner(&pi_state->pi_mutex));
+
 	return err;
 }
 
@@ -2756,7 +2775,6 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags,
 			 ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to;
-	struct futex_pi_state *pi_state = NULL;
 	struct task_struct *exiting = NULL;
 	struct rt_mutex_waiter rt_waiter;
 	struct futex_hash_bucket *hb;
@@ -2892,23 +2910,8 @@ no_block:
 	if (res)
 		ret = (res < 0) ? res : 0;
 
-	/*
-	 * If fixup_owner() faulted and was unable to handle the fault, unlock
-	 * it and return the fault to userspace.
-	 */
-	if (ret && (rt_mutex_owner(&q.pi_state->pi_mutex) == current)) {
-		pi_state = q.pi_state;
-		get_pi_state(pi_state);
-	}
-
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
-
-	if (pi_state) {
-		rt_mutex_futex_unlock(&pi_state->pi_mutex);
-		put_pi_state(pi_state);
-	}
-
 	goto out;
 
 out_unlock_put_key:
@@ -3168,7 +3171,6 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 				 u32 __user *uaddr2)
 {
 	struct hrtimer_sleeper timeout, *to;
-	struct futex_pi_state *pi_state = NULL;
 	struct rt_mutex_waiter rt_waiter;
 	struct futex_hash_bucket *hb;
 	union futex_key key2 = FUTEX_KEY_INIT;
@@ -3246,10 +3248,6 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 		if (q.pi_state && (q.pi_state->owner != current)) {
 			spin_lock(q.lock_ptr);
 			ret = fixup_pi_state_owner(uaddr2, &q, current);
-			if (ret < 0 && rt_mutex_owner(&q.pi_state->pi_mutex) == current) {
-				pi_state = q.pi_state;
-				get_pi_state(pi_state);
-			}
 			/*
 			 * Drop the reference to the pi state which
 			 * the requeue_pi() code acquired for us.
@@ -3291,25 +3289,10 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 		if (res)
 			ret = (res < 0) ? res : 0;
 
-		/*
-		 * If fixup_pi_state_owner() faulted and was unable to handle
-		 * the fault, unlock the rt_mutex and return the fault to
-		 * userspace.
-		 */
-		if (ret && rt_mutex_owner(&q.pi_state->pi_mutex) == current) {
-			pi_state = q.pi_state;
-			get_pi_state(pi_state);
-		}
-
 		/* Unqueue and drop the lock. */
 		unqueue_me_pi(&q);
 	}
 
-	if (pi_state) {
-		rt_mutex_futex_unlock(&pi_state->pi_mutex);
-		put_pi_state(pi_state);
-	}
-
 	if (ret == -EINTR) {
 		/*
 		 * We've already been requeued, but cannot restart by calling
