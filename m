Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA970304C18
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbhAZWAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:00:40 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51524 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391612AbhAZUFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 15:05:43 -0500
Date:   Tue, 26 Jan 2021 20:04:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611691500;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=5i1bS5xaTAzafC9EVeTJB6D98YZjamO0Dtekf7yIRFU=;
        b=4lFnXwcFbbmfP0QlWfwl6Bew2XQXZWx8Q86ekIHSJcYcHbK/ZRPEPL+uRkkFcPnzQ5ohxr
        rchtOgFl8UVuSQJRF6fh35WiJm7GobXahni23suPHyfgAkIJDN5Bbj83ZKRMIVN9olGWkQ
        rByKPEmgz+XzbrSC/mDuPO9bFHgJW76/WPKwUqZ9qQdYUu8/8VgDFyUYJoQ6EcoWAsQ/PX
        4JWzWdfzOX0k+ApDSiFFTozKePx/bDDyTFzXPG4LSzjHWWaGWyYBDnqMCGyo+Fqd7C3NfG
        w0UecyJY8v/78tpn/8MLR11sUQZDhUAQ4lxvvXP19EXeBe+z/Q2Turovft4/SA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611691501;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=5i1bS5xaTAzafC9EVeTJB6D98YZjamO0Dtekf7yIRFU=;
        b=j9n7LRQo5GGA5QbiinsRz1TFJqY2QuzYAxGb7ktwCcHUuLRVzO0zM/hGnYze0yG/wE1Vea
        GzNuJTyo0ejHIPDA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] futex: Provide and use pi_state_update_owner()
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <161169149846.414.14379352589492636849.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     c5cade200ab9a2a3be9e7f32a752c8d86b502ec7
Gitweb:        https://git.kernel.org/tip/c5cade200ab9a2a3be9e7f32a752c8d86b502ec7
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Tue, 19 Jan 2021 15:21:35 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 26 Jan 2021 15:10:58 +01:00

futex: Provide and use pi_state_update_owner()

Updating pi_state::owner is done at several places with the same
code. Provide a function for it and use that at the obvious places.

This is also a preparation for a bug fix to avoid yet another copy of the
same code or alternatively introducing a completely unpenetratable mess of
gotos.

Originally-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
---
 kernel/futex.c | 66 ++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 5dc8f89..7837f9e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -763,6 +763,29 @@ static struct futex_pi_state *alloc_pi_state(void)
 	return pi_state;
 }
 
+static void pi_state_update_owner(struct futex_pi_state *pi_state,
+				  struct task_struct *new_owner)
+{
+	struct task_struct *old_owner = pi_state->owner;
+
+	lockdep_assert_held(&pi_state->pi_mutex.wait_lock);
+
+	if (old_owner) {
+		raw_spin_lock(&old_owner->pi_lock);
+		WARN_ON(list_empty(&pi_state->list));
+		list_del_init(&pi_state->list);
+		raw_spin_unlock(&old_owner->pi_lock);
+	}
+
+	if (new_owner) {
+		raw_spin_lock(&new_owner->pi_lock);
+		WARN_ON(!list_empty(&pi_state->list));
+		list_add(&pi_state->list, &new_owner->pi_state_list);
+		pi_state->owner = new_owner;
+		raw_spin_unlock(&new_owner->pi_lock);
+	}
+}
+
 static void get_pi_state(struct futex_pi_state *pi_state)
 {
 	WARN_ON_ONCE(!refcount_inc_not_zero(&pi_state->refcount));
@@ -1521,26 +1544,15 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_pi_state *pi_
 			ret = -EINVAL;
 	}
 
-	if (ret)
-		goto out_unlock;
-
-	/*
-	 * This is a point of no return; once we modify the uval there is no
-	 * going back and subsequent operations must not fail.
-	 */
-
-	raw_spin_lock(&pi_state->owner->pi_lock);
-	WARN_ON(list_empty(&pi_state->list));
-	list_del_init(&pi_state->list);
-	raw_spin_unlock(&pi_state->owner->pi_lock);
-
-	raw_spin_lock(&new_owner->pi_lock);
-	WARN_ON(!list_empty(&pi_state->list));
-	list_add(&pi_state->list, &new_owner->pi_state_list);
-	pi_state->owner = new_owner;
-	raw_spin_unlock(&new_owner->pi_lock);
-
-	postunlock = __rt_mutex_futex_unlock(&pi_state->pi_mutex, &wake_q);
+	if (!ret) {
+		/*
+		 * This is a point of no return; once we modified the uval
+		 * there is no going back and subsequent operations must
+		 * not fail.
+		 */
+		pi_state_update_owner(pi_state, new_owner);
+		postunlock = __rt_mutex_futex_unlock(&pi_state->pi_mutex, &wake_q);
+	}
 
 out_unlock:
 	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
@@ -2433,19 +2445,7 @@ retry:
 	 * We fixed up user space. Now we need to fix the pi_state
 	 * itself.
 	 */
-	if (pi_state->owner != NULL) {
-		raw_spin_lock(&pi_state->owner->pi_lock);
-		WARN_ON(list_empty(&pi_state->list));
-		list_del_init(&pi_state->list);
-		raw_spin_unlock(&pi_state->owner->pi_lock);
-	}
-
-	pi_state->owner = newowner;
-
-	raw_spin_lock(&newowner->pi_lock);
-	WARN_ON(!list_empty(&pi_state->list));
-	list_add(&pi_state->list, &newowner->pi_state_list);
-	raw_spin_unlock(&newowner->pi_lock);
+	pi_state_update_owner(pi_state, newowner);
 	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 
 	return argowner == current;
