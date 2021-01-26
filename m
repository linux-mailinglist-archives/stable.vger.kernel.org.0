Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21442304C1B
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbhAZWAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:00:44 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51536 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405259AbhAZUFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 15:05:45 -0500
Date:   Tue, 26 Jan 2021 20:05:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611691502;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=h3cicIHzaPL4P19Pb7PHBPQFDTND3U7HlXPSPiVFNSo=;
        b=Ci8skSTkHMIl+lf1wwDsVFA9VAXrwG980cTHE3qxeXj8pbK+qfK1YWp0vTL0tw13w6k1VV
        Z4X5km+pI4QAA184q/QWksRtxRMIxKyBt6oLSy9v8b2tUwO0i3qZoxEeEuk9sk0KsjVjCE
        KUlx3GTs1atoW5CI/deqNbHp83ob/unYzJ57A0oCsPuiVkOHMwD4cU43AM9xtImJu25mX6
        LNjvTDtNrEZJU3WkJTas9OuYaXe/C+5FctRZNYjOoUESoLV4dWKTVqYilKXl/lG20VcZt7
        /RjqQwbBmKb279x5oOTfzJsu2dyigZv2u5FUbhPp6wt8DqQ2YBR+XOUIjrjBwQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611691502;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=h3cicIHzaPL4P19Pb7PHBPQFDTND3U7HlXPSPiVFNSo=;
        b=j9It31nIjSWAyQXPY2KkE2zDXtniGaHwKcyDo6Vg3UQazBcTH+2HDorK2W8PsN8z2kPdPf
        +oRKKyeU61mcSFAg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] futex: Ensure the correct return value from
 futex_lock_pi()
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <161169150059.414.1521373943640356883.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     12bb3f7f1b03d5913b3f9d4236a488aa7774dfe9
Gitweb:        https://git.kernel.org/tip/12bb3f7f1b03d5913b3f9d4236a488aa7774dfe9
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 20 Jan 2021 16:00:24 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 26 Jan 2021 15:10:58 +01:00

futex: Ensure the correct return value from futex_lock_pi()

In case that futex_lock_pi() was aborted by a signal or a timeout and the
task returned without acquiring the rtmutex, but is the designated owner of
the futex due to a concurrent futex_unlock_pi() fixup_owner() is invoked to
establish consistent state. In that case it invokes fixup_pi_state_owner()
which in turn tries to acquire the rtmutex again. If that succeeds then it
does not propagate this success to fixup_owner() and futex_lock_pi()
returns -EINTR or -ETIMEOUT despite having the futex locked.

Return success from fixup_pi_state_owner() in all cases where the current
task owns the rtmutex and therefore the futex and propagate it correctly
through fixup_owner(). Fixup the other callsite which does not expect a
positive return value.

Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
---
 kernel/futex.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c47d101..d5e61c2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2373,8 +2373,8 @@ retry:
 		}
 
 		if (__rt_mutex_futex_trylock(&pi_state->pi_mutex)) {
-			/* We got the lock after all, nothing to fix. */
-			ret = 0;
+			/* We got the lock. pi_state is correct. Tell caller. */
+			ret = 1;
 			goto out_unlock;
 		}
 
@@ -2402,7 +2402,7 @@ retry:
 			 * We raced against a concurrent self; things are
 			 * already fixed up. Nothing to do.
 			 */
-			ret = 0;
+			ret = 1;
 			goto out_unlock;
 		}
 		newowner = argowner;
@@ -2448,7 +2448,7 @@ retry:
 	raw_spin_unlock(&newowner->pi_lock);
 	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 
-	return 0;
+	return argowner == current;
 
 	/*
 	 * In order to reschedule or handle a page fault, we need to drop the
@@ -2490,7 +2490,7 @@ handle_err:
 	 * Check if someone else fixed it for us:
 	 */
 	if (pi_state->owner != oldowner) {
-		ret = 0;
+		ret = argowner == current;
 		goto out_unlock;
 	}
 
@@ -2523,8 +2523,6 @@ static long futex_wait_restart(struct restart_block *restart);
  */
 static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 {
-	int ret = 0;
-
 	if (locked) {
 		/*
 		 * Got the lock. We might not be the anticipated owner if we
@@ -2535,8 +2533,8 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 		 * stable state, anything else needs more attention.
 		 */
 		if (q->pi_state->owner != current)
-			ret = fixup_pi_state_owner(uaddr, q, current);
-		return ret ? ret : locked;
+			return fixup_pi_state_owner(uaddr, q, current);
+		return 1;
 	}
 
 	/*
@@ -2547,10 +2545,8 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 	 * Another speculative read; pi_state->owner == current is unstable
 	 * but needs our attention.
 	 */
-	if (q->pi_state->owner == current) {
-		ret = fixup_pi_state_owner(uaddr, q, NULL);
-		return ret;
-	}
+	if (q->pi_state->owner == current)
+		return fixup_pi_state_owner(uaddr, q, NULL);
 
 	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
@@ -2563,7 +2559,7 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 				q->pi_state->owner);
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -3261,7 +3257,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 		if (q.pi_state && (q.pi_state->owner != current)) {
 			spin_lock(q.lock_ptr);
 			ret = fixup_pi_state_owner(uaddr2, &q, current);
-			if (ret && rt_mutex_owner(&q.pi_state->pi_mutex) == current) {
+			if (ret < 0 && rt_mutex_owner(&q.pi_state->pi_mutex) == current) {
 				pi_state = q.pi_state;
 				get_pi_state(pi_state);
 			}
@@ -3271,6 +3267,11 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 			 */
 			put_pi_state(q.pi_state);
 			spin_unlock(q.lock_ptr);
+			/*
+			 * Adjust the return value. It's either -EFAULT or
+			 * success (1) but the caller expects 0 for success.
+			 */
+			ret = ret < 0 ? ret : 0;
 		}
 	} else {
 		struct rt_mutex *pi_mutex;
