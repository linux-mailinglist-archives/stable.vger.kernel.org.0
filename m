Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D04E30C9F5
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbhBBSeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:34:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233820AbhBBOFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:05:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A163E6501A;
        Tue,  2 Feb 2021 13:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273741;
        bh=ypl0/ehsGorvxma5qloOQBJPvaeBRdkgU16pJa8AD5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xI/ozeglG7k7Rfx6Qr9SwnOcrWTgzL1RK5M7EkxiN+yYYod+FhyQk2Tgu81LUc/3j
         g8qRqEgiEzuu7kkpOWQj2In35mWNyXhtC/oARLyuK1Aqbkku99fZ3OQ4F6/6D++hL+
         KAdyr4lfcJxK1LChIn0pNDbvXOZXTOSUJXrFzKzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 13/28] futex: Mark the begin of futex exit explicitly
Date:   Tue,  2 Feb 2021 14:38:33 +0100
Message-Id: <20210202132941.717771404@linuxfoundation.org>
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

commit 18f694385c4fd77a09851fd301236746ca83f3cb upstream.

Instead of relying on PF_EXITING use an explicit state for the futex exit
and set it in the futex exit function. This moves the smp barrier and the
lock/unlock serialization into the futex code.

As with the DEAD state this is restricted to the exit path as exec
continues to use the same task struct.

This allows to simplify that logic in a next step.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.539409004@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/futex.h |   31 +++----------------------------
 kernel/exit.c         |    8 +-------
 kernel/futex.c        |   37 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 36 deletions(-)

--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -57,6 +57,7 @@ union futex_key {
 #ifdef CONFIG_FUTEX
 enum {
 	FUTEX_STATE_OK,
+	FUTEX_STATE_EXITING,
 	FUTEX_STATE_DEAD,
 };
 
@@ -71,33 +72,7 @@ static inline void futex_init_task(struc
 	tsk->futex_state = FUTEX_STATE_OK;
 }
 
-/**
- * futex_exit_done - Sets the tasks futex state to FUTEX_STATE_DEAD
- * @tsk:	task to set the state on
- *
- * Set the futex exit state of the task lockless. The futex waiter code
- * observes that state when a task is exiting and loops until the task has
- * actually finished the futex cleanup. The worst case for this is that the
- * waiter runs through the wait loop until the state becomes visible.
- *
- * This has two callers:
- *
- * - futex_mm_release() after the futex exit cleanup has been done
- *
- * - do_exit() from the recursive fault handling path.
- *
- * In case of a recursive fault this is best effort. Either the futex exit
- * code has run already or not. If the OWNER_DIED bit has been set on the
- * futex then the waiter can take it over. If not, the problem is pushed
- * back to user space. If the futex exit code did not run yet, then an
- * already queued waiter might block forever, but there is nothing which
- * can be done about that.
- */
-static inline void futex_exit_done(struct task_struct *tsk)
-{
-	tsk->futex_state = FUTEX_STATE_DEAD;
-}
-
+void futex_exit_recursive(struct task_struct *tsk);
 void futex_exit_release(struct task_struct *tsk);
 void futex_exec_release(struct task_struct *tsk);
 
@@ -105,7 +80,7 @@ long do_futex(u32 __user *uaddr, int op,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 #else
 static inline void futex_init_task(struct task_struct *tsk) { }
-static inline void futex_exit_done(struct task_struct *tsk) { }
+static inline void futex_exit_recursive(struct task_struct *tsk) { }
 static inline void futex_exit_release(struct task_struct *tsk) { }
 static inline void futex_exec_release(struct task_struct *tsk) { }
 #endif
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -695,18 +695,12 @@ void do_exit(long code)
 	 */
 	if (unlikely(tsk->flags & PF_EXITING)) {
 		pr_alert("Fixing recursive fault but reboot is needed!\n");
-		futex_exit_done(tsk);
+		futex_exit_recursive(tsk);
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
 	}
 
 	exit_signals(tsk);  /* sets PF_EXITING */
-	/*
-	 * tsk->flags are checked in the futex code to protect against
-	 * an exiting task cleaning up the robust pi futexes.
-	 */
-	smp_mb();
-	raw_spin_unlock_wait(&tsk->pi_lock);
 
 	if (unlikely(in_atomic())) {
 		pr_info("note: %s[%d] exited with preempt_count %d\n",
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3252,10 +3252,45 @@ void futex_exec_release(struct task_stru
 		exit_pi_state_list(tsk);
 }
 
+/**
+ * futex_exit_recursive - Set the tasks futex state to FUTEX_STATE_DEAD
+ * @tsk:	task to set the state on
+ *
+ * Set the futex exit state of the task lockless. The futex waiter code
+ * observes that state when a task is exiting and loops until the task has
+ * actually finished the futex cleanup. The worst case for this is that the
+ * waiter runs through the wait loop until the state becomes visible.
+ *
+ * This is called from the recursive fault handling path in do_exit().
+ *
+ * This is best effort. Either the futex exit code has run already or
+ * not. If the OWNER_DIED bit has been set on the futex then the waiter can
+ * take it over. If not, the problem is pushed back to user space. If the
+ * futex exit code did not run yet, then an already queued waiter might
+ * block forever, but there is nothing which can be done about that.
+ */
+void futex_exit_recursive(struct task_struct *tsk)
+{
+	tsk->futex_state = FUTEX_STATE_DEAD;
+}
+
 void futex_exit_release(struct task_struct *tsk)
 {
+	tsk->futex_state = FUTEX_STATE_EXITING;
+	/*
+	 * Ensure that all new tsk->pi_lock acquisitions must observe
+	 * FUTEX_STATE_EXITING. Serializes against attach_to_pi_owner().
+	 */
+	smp_mb();
+	/*
+	 * Ensure that we must observe the pi_state in exit_pi_state_list().
+	 */
+	raw_spin_lock_irq(&tsk->pi_lock);
+	raw_spin_unlock_irq(&tsk->pi_lock);
+
 	futex_exec_release(tsk);
-	futex_exit_done(tsk);
+
+	tsk->futex_state = FUTEX_STATE_DEAD;
 }
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,


