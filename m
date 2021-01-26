Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E23A304C11
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbhAZWAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:00:21 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51500 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405243AbhAZUFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 15:05:39 -0500
Date:   Tue, 26 Jan 2021 20:04:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611691497;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=NZoAieMEnGnWWeNUy3L3XDYai+5LqqqiWY5B3wFNvwM=;
        b=FVfpmLpAP8bGI6oNhSNbEMe2sT5xB90uD8vl3anR7vWxsL0ojJwI3XHnpYI4WGI5vO0MgS
        SSpulFiVy8GS/4742T6uTTym76cWxQkJy8ffsFT4jsvYEHe7LqqxSz+EplTmyuf/Wc8Gh0
        mnFzoNwR5QzIDLO2fck3S6MLjSShItLqwTWTXlK0BaAKzTb7TfIEaoHL+gWyCE13pS7wEc
        bT0+S56Sx8AgnLWJF/5dr65spM5leydmQknBcotFjrgI9SnkKL9Dahuc4C5i19YsOBlvcp
        Nke1Dvfrmt1GhgIhOla020UEfkCNuSfQ+Rez5It9T2acw1TtwWvOF1Ife+QB/w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611691497;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=NZoAieMEnGnWWeNUy3L3XDYai+5LqqqiWY5B3wFNvwM=;
        b=dXPPbmoDsOvE2HmZMFeOm70qLu4Behgp94xboCLIGb0VvZjnQE1CvYbJ8edLTE20E1hynj
        Hbu5O6iEXfrEKiAw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] futex: Simplify fixup_pi_state_owner()
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <161169149477.414.3526220969551023147.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     f2dac39d93987f7de1e20b3988c8685523247ae2
Gitweb:        https://git.kernel.org/tip/f2dac39d93987f7de1e20b3988c8685523247ae2
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Tue, 19 Jan 2021 16:26:38 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 26 Jan 2021 15:10:59 +01:00

futex: Simplify fixup_pi_state_owner()

Too many gotos already and an upcoming fix would make it even more
unreadable.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
---
 kernel/futex.c | 53 ++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a0fe63c..7a38ead 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2329,18 +2329,13 @@ static void unqueue_me_pi(struct futex_q *q)
 	spin_unlock(q->lock_ptr);
 }
 
-static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
-				struct task_struct *argowner)
+static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
+				  struct task_struct *argowner)
 {
 	struct futex_pi_state *pi_state = q->pi_state;
-	u32 uval, curval, newval;
 	struct task_struct *oldowner, *newowner;
-	u32 newtid;
-	int ret, err = 0;
-
-	lockdep_assert_held(q->lock_ptr);
-
-	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+	u32 uval, curval, newval, newtid;
+	int err = 0;
 
 	oldowner = pi_state->owner;
 
@@ -2374,14 +2369,12 @@ retry:
 			 * We raced against a concurrent self; things are
 			 * already fixed up. Nothing to do.
 			 */
-			ret = 0;
-			goto out_unlock;
+			return 0;
 		}
 
 		if (__rt_mutex_futex_trylock(&pi_state->pi_mutex)) {
 			/* We got the lock. pi_state is correct. Tell caller. */
-			ret = 1;
-			goto out_unlock;
+			return 1;
 		}
 
 		/*
@@ -2408,8 +2401,7 @@ retry:
 			 * We raced against a concurrent self; things are
 			 * already fixed up. Nothing to do.
 			 */
-			ret = 1;
-			goto out_unlock;
+			return 1;
 		}
 		newowner = argowner;
 	}
@@ -2440,7 +2432,6 @@ retry:
 	 * itself.
 	 */
 	pi_state_update_owner(pi_state, newowner);
-	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 
 	return argowner == current;
 
@@ -2463,17 +2454,16 @@ handle_err:
 
 	switch (err) {
 	case -EFAULT:
-		ret = fault_in_user_writeable(uaddr);
+		err = fault_in_user_writeable(uaddr);
 		break;
 
 	case -EAGAIN:
 		cond_resched();
-		ret = 0;
+		err = 0;
 		break;
 
 	default:
 		WARN_ON_ONCE(1);
-		ret = err;
 		break;
 	}
 
@@ -2483,17 +2473,26 @@ handle_err:
 	/*
 	 * Check if someone else fixed it for us:
 	 */
-	if (pi_state->owner != oldowner) {
-		ret = argowner == current;
-		goto out_unlock;
-	}
+	if (pi_state->owner != oldowner)
+		return argowner == current;
 
-	if (ret)
-		goto out_unlock;
+	/* Retry if err was -EAGAIN or the fault in succeeded */
+	if (!err)
+		goto retry;
 
-	goto retry;
+	return err;
+}
 
-out_unlock:
+static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
+				struct task_struct *argowner)
+{
+	struct futex_pi_state *pi_state = q->pi_state;
+	int ret;
+
+	lockdep_assert_held(q->lock_ptr);
+
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+	ret = __fixup_pi_state_owner(uaddr, q, argowner);
 	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	return ret;
 }
