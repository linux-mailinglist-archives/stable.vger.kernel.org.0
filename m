Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742FD30C112
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhBBONC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:13:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234040AbhBBOLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:11:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 655EB64E2B;
        Tue,  2 Feb 2021 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273896;
        bh=Aptxk1tkYIY1snw2mi4RXtcEM96oqFIRYLK91zJatqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPtL6GgpoAAWqqd6r2Ql1O5sYyoQ1yIvzeVYyCE5p/JQnYsm2ZXAi25/iQkpt+lEo
         S/c0bZiLypDUGJwqdf2R3IWzdp6OcUf2fv+UAMY9/DdMS7FA/yrrxbLgsRVOhkwwiT
         OYXdLhE8c2YeTEoQchcLJ+RC2zkcVVnd2ggepInY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 06/32] futex: Replace PF_EXITPIDONE with a state
Date:   Tue,  2 Feb 2021 14:38:29 +0100
Message-Id: <20210202132942.291252804@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 3d4775df0a89240f671861c6ab6e8d59af8e9e41 upstream.

The futex exit handling relies on PF_ flags. That's suboptimal as it
requires a smp_mb() and an ugly lock/unlock of the exiting tasks pi_lock in
the middle of do_exit() to enforce the observability of PF_EXITING in the
futex code.

Add a futex_state member to task_struct and convert the PF_EXITPIDONE logic
over to the new state. The PF_EXITING dependency will be cleaned up in a
later step.

This prepares for handling various futex exit issues later.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.149449274@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/futex.h |   34 ++++++++++++++++++++++++++++++++++
 include/linux/sched.h |    2 +-
 kernel/exit.c         |   18 ++----------------
 kernel/futex.c        |   17 ++++++++---------
 4 files changed, 45 insertions(+), 26 deletions(-)

--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -55,6 +55,11 @@ union futex_key {
 #define FUTEX_KEY_INIT (union futex_key) { .both = { .ptr = 0ULL } }
 
 #ifdef CONFIG_FUTEX
+enum {
+	FUTEX_STATE_OK,
+	FUTEX_STATE_DEAD,
+};
+
 static inline void futex_init_task(struct task_struct *tsk)
 {
 	tsk->robust_list = NULL;
@@ -63,6 +68,34 @@ static inline void futex_init_task(struc
 #endif
 	INIT_LIST_HEAD(&tsk->pi_state_list);
 	tsk->pi_state_cache = NULL;
+	tsk->futex_state = FUTEX_STATE_OK;
+}
+
+/**
+ * futex_exit_done - Sets the tasks futex state to FUTEX_STATE_DEAD
+ * @tsk:	task to set the state on
+ *
+ * Set the futex exit state of the task lockless. The futex waiter code
+ * observes that state when a task is exiting and loops until the task has
+ * actually finished the futex cleanup. The worst case for this is that the
+ * waiter runs through the wait loop until the state becomes visible.
+ *
+ * This has two callers:
+ *
+ * - futex_mm_release() after the futex exit cleanup has been done
+ *
+ * - do_exit() from the recursive fault handling path.
+ *
+ * In case of a recursive fault this is best effort. Either the futex exit
+ * code has run already or not. If the OWNER_DIED bit has been set on the
+ * futex then the waiter can take it over. If not, the problem is pushed
+ * back to user space. If the futex exit code did not run yet, then an
+ * already queued waiter might block forever, but there is nothing which
+ * can be done about that.
+ */
+static inline void futex_exit_done(struct task_struct *tsk)
+{
+	tsk->futex_state = FUTEX_STATE_DEAD;
 }
 
 void futex_mm_release(struct task_struct *tsk);
@@ -72,5 +105,6 @@ long do_futex(u32 __user *uaddr, int op,
 #else
 static inline void futex_init_task(struct task_struct *tsk) { }
 static inline void futex_mm_release(struct task_struct *tsk) { }
+static inline void futex_exit_done(struct task_struct *tsk) { }
 #endif
 #endif
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1815,6 +1815,7 @@ struct task_struct {
 #endif
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
+	unsigned int futex_state;
 #endif
 #ifdef CONFIG_PERF_EVENTS
 	struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
@@ -2276,7 +2277,6 @@ extern void thread_group_cputime_adjuste
  * Per process flags
  */
 #define PF_EXITING	0x00000004	/* getting shut down */
-#define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
 #define PF_WQ_WORKER	0x00000020	/* I'm a workqueue worker */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -785,16 +785,7 @@ void __noreturn do_exit(long code)
 	 */
 	if (unlikely(tsk->flags & PF_EXITING)) {
 		pr_alert("Fixing recursive fault but reboot is needed!\n");
-		/*
-		 * We can do this unlocked here. The futex code uses
-		 * this flag just to verify whether the pi state
-		 * cleanup has been done or not. In the worst case it
-		 * loops once more. We pretend that the cleanup was
-		 * done as there is no way to return. Either the
-		 * OWNER_DIED bit is set by now or we push the blocked
-		 * task into the wait for ever nirwana as well.
-		 */
-		tsk->flags |= PF_EXITPIDONE;
+		futex_exit_done(tsk);
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
 	}
@@ -876,12 +867,7 @@ void __noreturn do_exit(long code)
 	 * Make sure we are holding no locks:
 	 */
 	debug_check_no_locks_held();
-	/*
-	 * We can do this unlocked here. The futex code uses this flag
-	 * just to verify whether the pi state cleanup has been done
-	 * or not. In the worst case it loops once more.
-	 */
-	tsk->flags |= PF_EXITPIDONE;
+	futex_exit_done(tsk);
 
 	if (tsk->io_context)
 		exit_io_context(tsk);
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1099,19 +1099,18 @@ static int attach_to_pi_owner(u32 uval,
 	}
 
 	/*
-	 * We need to look at the task state flags to figure out,
-	 * whether the task is exiting. To protect against the do_exit
-	 * change of the task flags, we do this protected by
-	 * p->pi_lock:
+	 * We need to look at the task state to figure out, whether the
+	 * task is exiting. To protect against the change of the task state
+	 * in futex_exit_release(), we do this protected by p->pi_lock:
 	 */
 	raw_spin_lock_irq(&p->pi_lock);
-	if (unlikely(p->flags & PF_EXITING)) {
+	if (unlikely(p->futex_state != FUTEX_STATE_OK)) {
 		/*
-		 * The task is on the way out. When PF_EXITPIDONE is
-		 * set, we know that the task has finished the
-		 * cleanup:
+		 * The task is on the way out. When the futex state is
+		 * FUTEX_STATE_DEAD, we know that the task has finished
+		 * the cleanup:
 		 */
-		int ret = (p->flags & PF_EXITPIDONE) ? -ESRCH : -EAGAIN;
+		int ret = (p->futex_state = FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;
 
 		raw_spin_unlock_irq(&p->pi_lock);
 		put_task_struct(p);


