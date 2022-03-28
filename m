Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364004E9431
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbiC1L0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241746AbiC1LYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:24:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A32255749;
        Mon, 28 Mar 2022 04:22:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBA3361195;
        Mon, 28 Mar 2022 11:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA9AC340EC;
        Mon, 28 Mar 2022 11:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466537;
        bh=9juKIwUD/GSIh+MC1cufrB6PrwTzh2p3DCsAILFY26s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8g7cD7MgBvkGLq8P4rTXeWE1is0QI13hdJ53LJuLQvrm+4U27Ai0xYRtUAbSOWA/
         p2NVs+OCtbGbguV85/FtvbNQnzKqY7JlLSGuZWSnzEbO952o74r8OYNBqOzMdKE9ac
         a36Lxm4gxfhJ33dbh/vwdkAYopRpdYBYkXpVZ2LnbmYujw7AY5wCnm9zT2ho2PG7ev
         +bOs8vrYxfbO6/gD6KrClPUGP75oL6kOoZVo58OZMzBPZY4Ht2HjjpjTnGKOWXufxx
         DKHF523fWc/RPsupQbdAK4BYBMZBhdArVxkYMdItj/NB0xbJI2kbRbkGWL63En9lml
         8cx9Tl2NOC8Iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, luto@kernel.org, frederic@kernel.org,
        rdunlap@infradead.org, ardb@kernel.org, valentin.schneider@arm.com,
        ebiederm@xmission.com, keescook@chromium.org, elver@google.com,
        legion@kernel.org
Subject: [PATCH AUTOSEL 5.15 19/29] signal, x86: Delay calling signals in atomic on RT enabled kernels
Date:   Mon, 28 Mar 2022 07:21:21 -0400
Message-Id: <20220328112132.1555683-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112132.1555683-1-sashal@kernel.org>
References: <20220328112132.1555683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit bf9ad37dc8a30cce22ae95d6c2ca6abf8731d305 ]

On x86_64 we must disable preemption before we enable interrupts
for stack faults, int3 and debugging, because the current task is using
a per CPU debug stack defined by the IST. If we schedule out, another task
can come in and use the same stack and cause the stack to be corrupted
and crash the kernel on return.

When CONFIG_PREEMPT_RT is enabled, spinlock_t locks become sleeping, and
one of these is the spin lock used in signal handling.

Some of the debug code (int3) causes do_trap() to send a signal.
This function calls a spinlock_t lock that has been converted to a
sleeping lock. If this happens, the above issues with the corrupted
stack is possible.

Instead of calling the signal right away, for PREEMPT_RT and x86,
the signal information is stored on the stacks task_struct and
TIF_NOTIFY_RESUME is set. Then on exit of the trap, the signal resume
code will send the signal when preemption is enabled.

[ rostedt: Switched from #ifdef CONFIG_PREEMPT_RT to
  ARCH_RT_DELAYS_SIGNAL_SEND and added comments to the code. ]
[bigeasy: Add on 32bit as per Yang Shi, minor rewording. ]
[ tglx: Use a config option ]

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/Ygq5aBB/qMQw6aP5@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig       |  1 +
 include/linux/sched.h  |  3 +++
 kernel/Kconfig.preempt | 12 +++++++++++-
 kernel/entry/common.c  | 14 ++++++++++++++
 kernel/signal.c        | 40 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1f96809606ac..9f6480239194 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -118,6 +118,7 @@ config X86
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANT_HUGE_PMD_SHARE
 	select ARCH_WANT_LD_ORPHAN_WARN
+	select ARCH_WANTS_RT_DELAYED_SIGNALS
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select BUILDTIME_TABLE_SORT
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 76e869550646..5f84cc12f627 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1084,6 +1084,9 @@ struct task_struct {
 	/* Restored if set_restore_sigmask() was used: */
 	sigset_t			saved_sigmask;
 	struct sigpending		pending;
+#ifdef CONFIG_RT_DELAYED_SIGNALS
+	struct kernel_siginfo		forced_info;
+#endif
 	unsigned long			sas_ss_sp;
 	size_t				sas_ss_size;
 	unsigned int			sas_ss_flags;
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 5876e30c5740..64688b7a5639 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -118,4 +118,14 @@ config SCHED_CORE
 	  which is the likely usage by Linux distributions, there should
 	  be no measurable impact on performance.
 
-
+config ARCH_WANTS_RT_DELAYED_SIGNALS
+	bool
+	help
+	  This option is selected by architectures where raising signals
+	  can happen in atomic contexts on PREEMPT_RT enabled kernels. This
+	  option delays raising the signal until the return to user space
+	  loop where it is also delivered. X86 requires this to deliver
+	  signals from trap handlers which run on IST stacks.
+
+config RT_DELAYED_SIGNALS
+	def_bool PREEMPT_RT && ARCH_WANTS_RT_DELAYED_SIGNALS
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index d5a61d565ad5..75f352775e6e 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -148,6 +148,18 @@ static void handle_signal_work(struct pt_regs *regs, unsigned long ti_work)
 	arch_do_signal_or_restart(regs, ti_work & _TIF_SIGPENDING);
 }
 
+#ifdef CONFIG_RT_DELAYED_SIGNALS
+static inline void raise_delayed_signal(void)
+{
+	if (unlikely(current->forced_info.si_signo)) {
+		force_sig_info(&current->forced_info);
+		current->forced_info.si_signo = 0;
+	}
+}
+#else
+static inline void raise_delayed_signal(void) { }
+#endif
+
 static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 					    unsigned long ti_work)
 {
@@ -162,6 +174,8 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		if (ti_work & _TIF_NEED_RESCHED)
 			schedule();
 
+		raise_delayed_signal();
+
 		if (ti_work & _TIF_UPROBE)
 			uprobe_notify_resume(regs);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 6e3dbb3d1217..e9ca0019dde2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1304,6 +1304,43 @@ enum sig_handler {
 	HANDLER_EXIT,	 /* Only visible as the process exit code */
 };
 
+/*
+ * On some archictectures, PREEMPT_RT has to delay sending a signal from a
+ * trap since it cannot enable preemption, and the signal code's
+ * spin_locks turn into mutexes. Instead, it must set TIF_NOTIFY_RESUME
+ * which will send the signal on exit of the trap.
+ */
+#ifdef CONFIG_RT_DELAYED_SIGNALS
+static inline bool force_sig_delayed(struct kernel_siginfo *info,
+				     struct task_struct *t)
+{
+	if (!in_atomic())
+		return false;
+
+	if (WARN_ON_ONCE(t->forced_info.si_signo))
+		return true;
+
+	if (is_si_special(info)) {
+		WARN_ON_ONCE(info != SEND_SIG_PRIV);
+		t->forced_info.si_signo = info->si_signo;
+		t->forced_info.si_errno = 0;
+		t->forced_info.si_code = SI_KERNEL;
+		t->forced_info.si_pid = 0;
+		t->forced_info.si_uid = 0;
+	} else {
+		t->forced_info = *info;
+	}
+	set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+	return true;
+}
+#else
+static inline bool force_sig_delayed(struct kernel_siginfo *info,
+				     struct task_struct *t)
+{
+	return false;
+}
+#endif
+
 /*
  * Force a signal that the process can't ignore: if necessary
  * we unblock the signal and change any SIG_IGN to SIG_DFL.
@@ -1324,6 +1361,9 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t,
 	struct k_sigaction *action;
 	int sig = info->si_signo;
 
+	if (force_sig_delayed(info, t))
+		return 0;
+
 	spin_lock_irqsave(&t->sighand->siglock, flags);
 	action = &t->sighand->action[sig-1];
 	ignored = action->sa.sa_handler == SIG_IGN;
-- 
2.34.1

