Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B9231363B
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhBHPHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:07:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233022AbhBHPFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:05:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF84A64EAC;
        Mon,  8 Feb 2021 15:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796638;
        bh=ai9DUgI3QikJLfYn2osoEuRja8o/zkxDmvR20Ugip7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBK5Ryde1e2LW5Z1k5O5k+sHBEsKkIgHKShodM6IrYnNAi+YRs0RxLa1FGCxlA1gM
         cuQKyRfPpPvy/SH5/ZSKxqfNzEyOhNHTqiKGZ+9icnfNTK6aixBXBMRP8cLaHvj0vh
         oaWAlaZLAOCi1a5QHEB+cj89TaeTEgYKXY2b4qbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 12/43] futex: Simplify fixup_pi_state_owner()
Date:   Mon,  8 Feb 2021 16:00:38 +0100
Message-Id: <20210208145806.804894516@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit f2dac39d93987f7de1e20b3988c8685523247ae2 ]

Too many gotos already and an upcoming fix would make it even more
unreadable.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2272,18 +2272,16 @@ static void unqueue_me_pi(struct futex_q
 	spin_unlock(q->lock_ptr);
 }
 
-static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
-				struct task_struct *argowner)
+static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
+				  struct task_struct *argowner)
 {
 	struct futex_pi_state *pi_state = q->pi_state;
-	u32 uval, uninitialized_var(curval), newval;
 	struct task_struct *oldowner, *newowner;
-	u32 newtid;
-	int ret;
-
-	lockdep_assert_held(q->lock_ptr);
+	u32 uval, curval, newval, newtid;
+	int err = 0;
 
 	oldowner = pi_state->owner;
+
 	/* Owner died? */
 	if (!pi_state->owner)
 		newtid |= FUTEX_OWNER_DIED;
@@ -2324,7 +2322,7 @@ retry:
 
 		if (__rt_mutex_futex_trylock(&pi_state->pi_mutex)) {
 			/* We got the lock after all, nothing to fix. */
-			return 0;
+			return 1;
 		}
 
 		/*
@@ -2339,7 +2337,7 @@ retry:
 			 * We raced against a concurrent self; things are
 			 * already fixed up. Nothing to do.
 			 */
-			return 0;
+			return 1;
 		}
 		newowner = argowner;
 	}
@@ -2380,7 +2378,7 @@ retry:
 handle_fault:
 	spin_unlock(q->lock_ptr);
 
-	ret = fault_in_user_writeable(uaddr);
+	err = fault_in_user_writeable(uaddr);
 
 	spin_lock(q->lock_ptr);
 
@@ -2388,12 +2386,27 @@ handle_fault:
 	 * Check if someone else fixed it for us:
 	 */
 	if (pi_state->owner != oldowner)
-		return 0;
+		return argowner == current;
+
+	/* Retry if err was -EAGAIN or the fault in succeeded */
+	if (!err)
+		goto retry;
 
-	if (ret)
-		return ret;
+	return err;
+}
+
+static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
+				struct task_struct *argowner)
+{
+	struct futex_pi_state *pi_state = q->pi_state;
+	int ret;
+
+	lockdep_assert_held(q->lock_ptr);
 
-	goto retry;
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+	ret = __fixup_pi_state_owner(uaddr, q, argowner);
+	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
+	return ret;
 }
 
 static long futex_wait_restart(struct restart_block *restart);


