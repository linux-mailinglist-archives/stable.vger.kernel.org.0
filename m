Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FFB65BBED
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbjACIQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237039AbjACIQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:16:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AEEDF6E
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:16:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F406B80E5A
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B13C433EF;
        Tue,  3 Jan 2023 08:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733767;
        bh=q3dIJLhZFdI85iw5SFJijngSMgu8QeAdoIavAKbDChs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gq3WYE50dRv5D0+6AkZTQsum/jyWlWDbdP4Ylzb3PnG55DEklXgHx5a/GUuYYold1
         4KKMfOl7321Htm8Pm8esx26rV/AbST5iF65DisFJiiHAhWkbD/gUpCJYBYGBIuFO/3
         68NHnVZf0xHc3Smn0eVRWfGESkVRMteor1oNrqFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 5.10 15/63] entry: Add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:13:45 +0100
Message-Id: <20230103081309.476105583@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 12db8b690010ccfadf9d0b49a1e1798e47dbbe1a ]

Add TIF_NOTIFY_SIGNAL handling in the generic entry code, which if set,
will return true if signal_pending() is used in a wait loop. That causes an
exit of the loop so that notify_signal tracehooks can be run. If the wait
loop is currently inside a system call, the system call is restarted once
task_work has been processed.

In preparation for only having arch_do_signal() handle syscall restarts if
_TIF_SIGPENDING isn't set, rename it to arch_do_signal_or_restart().  Pass
in a boolean that tells the architecture specific signal handler if it
should attempt to get a signal, or just process a potential syscall
restart.

For !CONFIG_GENERIC_ENTRY archs, add the TIF_NOTIFY_SIGNAL handling to
get_signal(). This is done to minimize the needed architecture changes to
support this feature.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20201026203230.386348-3-axboe@kernel.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/signal.c     |    4 ++--
 include/linux/entry-common.h |   11 ++++++++---
 include/linux/entry-kvm.h    |    4 ++--
 include/linux/sched/signal.h |   11 ++++++++++-
 include/linux/tracehook.h    |   27 +++++++++++++++++++++++++++
 kernel/entry/common.c        |   14 +++++++++++---
 kernel/entry/kvm.c           |    3 +++
 kernel/signal.c              |   14 ++++++++++++++
 8 files changed, 77 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -798,11 +798,11 @@ static inline unsigned long get_nr_resta
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-void arch_do_signal(struct pt_regs *regs)
+void arch_do_signal_or_restart(struct pt_regs *regs, bool has_signal)
 {
 	struct ksignal ksig;
 
-	if (get_signal(&ksig)) {
+	if (has_signal && get_signal(&ksig)) {
 		/* Whee! Actually deliver the signal.  */
 		handle_signal(&ksig, regs);
 		return;
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -37,6 +37,10 @@
 # define _TIF_UPROBE			(0)
 #endif
 
+#ifndef _TIF_NOTIFY_SIGNAL
+# define _TIF_NOTIFY_SIGNAL		(0)
+#endif
+
 /*
  * TIF flags handled in syscall_enter_from_user_mode()
  */
@@ -69,7 +73,7 @@
 
 #define EXIT_TO_USER_MODE_WORK						\
 	(_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_UPROBE |		\
-	 _TIF_NEED_RESCHED | _TIF_PATCH_PENDING |			\
+	 _TIF_NEED_RESCHED | _TIF_PATCH_PENDING | _TIF_NOTIFY_SIGNAL |	\
 	 ARCH_EXIT_TO_USER_MODE_WORK)
 
 /**
@@ -259,12 +263,13 @@ static __always_inline void arch_exit_to
 #endif
 
 /**
- * arch_do_signal -  Architecture specific signal delivery function
+ * arch_do_signal_or_restart -  Architecture specific signal delivery function
  * @regs:	Pointer to currents pt_regs
+ * @has_signal:	actual signal to handle
  *
  * Invoked from exit_to_user_mode_loop().
  */
-void arch_do_signal(struct pt_regs *regs);
+void arch_do_signal_or_restart(struct pt_regs *regs, bool has_signal);
 
 /**
  * arch_syscall_exit_tracehook - Wrapper around tracehook_report_syscall_exit()
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -11,8 +11,8 @@
 # define ARCH_XFER_TO_GUEST_MODE_WORK	(0)
 #endif
 
-#define XFER_TO_GUEST_MODE_WORK					\
-	(_TIF_NEED_RESCHED | _TIF_SIGPENDING |			\
+#define XFER_TO_GUEST_MODE_WORK						\
+	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL |	\
 	 _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
 
 struct kvm_vcpu;
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -361,6 +361,15 @@ static inline int task_sigpending(struct
 
 static inline int signal_pending(struct task_struct *p)
 {
+#if defined(TIF_NOTIFY_SIGNAL)
+	/*
+	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
+	 * behavior in terms of ensuring that we break out of wait loops
+	 * so that notify signal callbacks can be processed.
+	 */
+	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
+		return 1;
+#endif
 	return task_sigpending(p);
 }
 
@@ -508,7 +517,7 @@ extern int set_user_sigmask(const sigset
 static inline void restore_saved_sigmask_unless(bool interrupted)
 {
 	if (interrupted)
-		WARN_ON(!test_thread_flag(TIF_SIGPENDING));
+		WARN_ON(!signal_pending(current));
 	else
 		restore_saved_sigmask();
 }
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -198,4 +198,31 @@ static inline void tracehook_notify_resu
 	blkcg_maybe_throttle_current();
 }
 
+/*
+ * called by exit_to_user_mode_loop() if ti_work & _TIF_NOTIFY_SIGNAL. This
+ * is currently used by TWA_SIGNAL based task_work, which requires breaking
+ * wait loops to ensure that task_work is noticed and run.
+ */
+static inline void tracehook_notify_signal(void)
+{
+#if defined(TIF_NOTIFY_SIGNAL)
+	clear_thread_flag(TIF_NOTIFY_SIGNAL);
+	smp_mb__after_atomic();
+	if (current->task_works)
+		task_work_run();
+#endif
+}
+
+/*
+ * Called when we have work to process from exit_to_user_mode_loop()
+ */
+static inline void set_notify_signal(struct task_struct *task)
+{
+#if defined(TIF_NOTIFY_SIGNAL)
+	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
+	    !wake_up_state(task, TASK_INTERRUPTIBLE))
+		kick_process(task);
+#endif
+}
+
 #endif	/* <linux/tracehook.h> */
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -135,7 +135,15 @@ static __always_inline void exit_to_user
 }
 
 /* Workaround to allow gradual conversion of architecture code */
-void __weak arch_do_signal(struct pt_regs *regs) { }
+void __weak arch_do_signal_or_restart(struct pt_regs *regs, bool has_signal) { }
+
+static void handle_signal_work(struct pt_regs *regs, unsigned long ti_work)
+{
+	if (ti_work & _TIF_NOTIFY_SIGNAL)
+		tracehook_notify_signal();
+
+	arch_do_signal_or_restart(regs, ti_work & _TIF_SIGPENDING);
+}
 
 static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 					    unsigned long ti_work)
@@ -157,8 +165,8 @@ static unsigned long exit_to_user_mode_l
 		if (ti_work & _TIF_PATCH_PENDING)
 			klp_update_patch_state(current);
 
-		if (ti_work & _TIF_SIGPENDING)
-			arch_do_signal(regs);
+		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
+			handle_signal_work(regs, ti_work);
 
 		if (ti_work & _TIF_NOTIFY_RESUME) {
 			tracehook_notify_resume(regs);
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -8,6 +8,9 @@ static int xfer_to_guest_mode_work(struc
 	do {
 		int ret;
 
+		if (ti_work & _TIF_NOTIFY_SIGNAL)
+			tracehook_notify_signal();
+
 		if (ti_work & _TIF_SIGPENDING) {
 			kvm_handle_signal_exit(vcpu);
 			return -EINTR;
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2520,6 +2520,20 @@ bool get_signal(struct ksignal *ksig)
 	struct signal_struct *signal = current->signal;
 	int signr;
 
+	/*
+	 * For non-generic architectures, check for TIF_NOTIFY_SIGNAL so
+	 * that the arch handlers don't all have to do it. If we get here
+	 * without TIF_SIGPENDING, just exit after running signal work.
+	 */
+#ifdef TIF_NOTIFY_SIGNAL
+	if (!IS_ENABLED(CONFIG_GENERIC_ENTRY)) {
+		if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+			tracehook_notify_signal();
+		if (!task_sigpending(current))
+			return false;
+	}
+#endif
+
 	if (unlikely(uprobe_deny_signal()))
 		return false;
 


