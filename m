Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115AA274A39
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 22:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIVUi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 16:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIVUi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 16:38:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C01C061755;
        Tue, 22 Sep 2020 13:38:28 -0700 (PDT)
Date:   Tue, 22 Sep 2020 20:38:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1600807106;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=05s98Rz0WKN9/qhFHUJ64ku8EqVk5WFKo3JdL5WgLZA=;
        b=U1vkAPKGOn/+ycbbymjwnhQ+EqUnAlSu4L6XFc42ji8TrDd7xCqxCW+IJ/1sjVnfmdqlbV
        1FNwsBvQ1cCCM4FOU2YYba1pCPQibe8xn/VRuWfzupYFM2kO5C2qCRNHutIHVkYc1Kpdyz
        OdWRuEUYJKq7qqE1U8ymxrzIAcoYC0JHydBXiTvBNyikR2EFyVoE+ZTqFB9i4m2Kl/aGTj
        MrxTJJUQsiKEBSD8fHPlRD9LgwgMCdns+M0ZbgbXAa3Emzt5u84Pstj6QArzCZI6Ry/y+S
        nW9CYRshGCUJHY4HU+cLuN7OmZMsV56C3hbWJ5pDp5e7HJ4EmTRX7oXEiAVvRQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1600807106;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=05s98Rz0WKN9/qhFHUJ64ku8EqVk5WFKo3JdL5WgLZA=;
        b=7S7CRuYzJoG4Pwx5qiHVHmTgrc4F1Kqq1yMRr6HCQ1QkmNPQi39TDv7Vx7B4b6W+v/UiQL
        eRtZIdUl4cwXIMAA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/irq: Make run_on_irqstack_cond() typesafe
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87pn6eb5tv.fsf@nanos.tec.linutronix.de>
References: <87pn6eb5tv.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <160080710510.7002.14619344176977382059.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     a7b3474cbb2864d5500d5e4f48dd57c903975cab
Gitweb:        https://git.kernel.org/tip/a7b3474cbb2864d5500d5e4f48dd57c903975cab
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Tue, 22 Sep 2020 09:58:52 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 22 Sep 2020 22:13:34 +02:00

x86/irq: Make run_on_irqstack_cond() typesafe

Sami reported that run_on_irqstack_cond() requires the caller to cast
functions to mismatching types, which trips indirect call Control-Flow
Integrity (CFI) in Clang.

Instead of disabling CFI on that function, provide proper helpers for
the three call variants. The actual ASM code stays the same as that is
out of reach.

 [ bp: Fix __run_on_irqstack() prototype to match. ]

Fixes: 931b94145981 ("x86/entry: Provide helpers for executing on the irqstack")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Cc: <stable@vger.kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/1052
Link: https://lkml.kernel.org/r/87pn6eb5tv.fsf@nanos.tec.linutronix.de
---
 arch/x86/entry/common.c          |  2 +-
 arch/x86/entry/entry_64.S        |  2 +-
 arch/x86/include/asm/idtentry.h  |  2 +-
 arch/x86/include/asm/irq_stack.h | 69 +++++++++++++++++++++++++++----
 arch/x86/kernel/irq.c            |  2 +-
 arch/x86/kernel/irq_64.c         |  2 +-
 6 files changed, 67 insertions(+), 12 deletions(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 2f84c7c..870efee 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -299,7 +299,7 @@ __visible noinstr void xen_pv_evtchn_do_upcall(struct pt_regs *regs)
 	old_regs = set_irq_regs(regs);
 
 	instrumentation_begin();
-	run_on_irqstack_cond(__xen_pv_evtchn_do_upcall, NULL, regs);
+	run_on_irqstack_cond(__xen_pv_evtchn_do_upcall, regs);
 	instrumentation_begin();
 
 	set_irq_regs(old_regs);
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 70dea93..d977079 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -682,6 +682,8 @@ SYM_CODE_END(.Lbad_gs)
  * rdx: Function argument (can be NULL if none)
  */
 SYM_FUNC_START(asm_call_on_stack)
+SYM_INNER_LABEL(asm_call_sysvec_on_stack, SYM_L_GLOBAL)
+SYM_INNER_LABEL(asm_call_irq_on_stack, SYM_L_GLOBAL)
 	/*
 	 * Save the frame pointer unconditionally. This allows the ORC
 	 * unwinder to handle the stack switch.
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index a433661..a063864 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -242,7 +242,7 @@ __visible noinstr void func(struct pt_regs *regs)			\
 	instrumentation_begin();					\
 	irq_enter_rcu();						\
 	kvm_set_cpu_l1tf_flush_l1d();					\
-	run_on_irqstack_cond(__##func, regs, regs);			\
+	run_sysvec_on_irqstack_cond(__##func, regs);			\
 	irq_exit_rcu();							\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
diff --git a/arch/x86/include/asm/irq_stack.h b/arch/x86/include/asm/irq_stack.h
index 4ae66f0..7758169 100644
--- a/arch/x86/include/asm/irq_stack.h
+++ b/arch/x86/include/asm/irq_stack.h
@@ -12,20 +12,50 @@ static __always_inline bool irqstack_active(void)
 	return __this_cpu_read(irq_count) != -1;
 }
 
-void asm_call_on_stack(void *sp, void *func, void *arg);
+void asm_call_on_stack(void *sp, void (*func)(void), void *arg);
+void asm_call_sysvec_on_stack(void *sp, void (*func)(struct pt_regs *regs),
+			      struct pt_regs *regs);
+void asm_call_irq_on_stack(void *sp, void (*func)(struct irq_desc *desc),
+			   struct irq_desc *desc);
 
-static __always_inline void __run_on_irqstack(void *func, void *arg)
+static __always_inline void __run_on_irqstack(void (*func)(void))
 {
 	void *tos = __this_cpu_read(hardirq_stack_ptr);
 
 	__this_cpu_add(irq_count, 1);
-	asm_call_on_stack(tos - 8, func, arg);
+	asm_call_on_stack(tos - 8, func, NULL);
+	__this_cpu_sub(irq_count, 1);
+}
+
+static __always_inline void
+__run_sysvec_on_irqstack(void (*func)(struct pt_regs *regs),
+			 struct pt_regs *regs)
+{
+	void *tos = __this_cpu_read(hardirq_stack_ptr);
+
+	__this_cpu_add(irq_count, 1);
+	asm_call_sysvec_on_stack(tos - 8, func, regs);
+	__this_cpu_sub(irq_count, 1);
+}
+
+static __always_inline void
+__run_irq_on_irqstack(void (*func)(struct irq_desc *desc),
+		      struct irq_desc *desc)
+{
+	void *tos = __this_cpu_read(hardirq_stack_ptr);
+
+	__this_cpu_add(irq_count, 1);
+	asm_call_irq_on_stack(tos - 8, func, desc);
 	__this_cpu_sub(irq_count, 1);
 }
 
 #else /* CONFIG_X86_64 */
 static inline bool irqstack_active(void) { return false; }
-static inline void __run_on_irqstack(void *func, void *arg) { }
+static inline void __run_on_irqstack(void (*func)(void)) { }
+static inline void __run_sysvec_on_irqstack(void (*func)(struct pt_regs *regs),
+					    struct pt_regs *regs) { }
+static inline void __run_irq_on_irqstack(void (*func)(struct irq_desc *desc),
+					 struct irq_desc *desc) { }
 #endif /* !CONFIG_X86_64 */
 
 static __always_inline bool irq_needs_irq_stack(struct pt_regs *regs)
@@ -37,17 +67,40 @@ static __always_inline bool irq_needs_irq_stack(struct pt_regs *regs)
 	return !user_mode(regs) && !irqstack_active();
 }
 
-static __always_inline void run_on_irqstack_cond(void *func, void *arg,
+
+static __always_inline void run_on_irqstack_cond(void (*func)(void),
 						 struct pt_regs *regs)
 {
-	void (*__func)(void *arg) = func;
+	lockdep_assert_irqs_disabled();
+
+	if (irq_needs_irq_stack(regs))
+		__run_on_irqstack(func);
+	else
+		func();
+}
+
+static __always_inline void
+run_sysvec_on_irqstack_cond(void (*func)(struct pt_regs *regs),
+			    struct pt_regs *regs)
+{
+	lockdep_assert_irqs_disabled();
 
+	if (irq_needs_irq_stack(regs))
+		__run_sysvec_on_irqstack(func, regs);
+	else
+		func(regs);
+}
+
+static __always_inline void
+run_irq_on_irqstack_cond(void (*func)(struct irq_desc *desc), struct irq_desc *desc,
+			 struct pt_regs *regs)
+{
 	lockdep_assert_irqs_disabled();
 
 	if (irq_needs_irq_stack(regs))
-		__run_on_irqstack(__func, arg);
+		__run_irq_on_irqstack(func, desc);
 	else
-		__func(arg);
+		func(desc);
 }
 
 #endif
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 1810602..c5dd503 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -227,7 +227,7 @@ static __always_inline void handle_irq(struct irq_desc *desc,
 				       struct pt_regs *regs)
 {
 	if (IS_ENABLED(CONFIG_X86_64))
-		run_on_irqstack_cond(desc->handle_irq, desc, regs);
+		run_irq_on_irqstack_cond(desc->handle_irq, desc, regs);
 	else
 		__handle_irq(desc, regs);
 }
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 1b4fe93..440eed5 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -74,5 +74,5 @@ int irq_init_percpu_irqstack(unsigned int cpu)
 
 void do_softirq_own_stack(void)
 {
-	run_on_irqstack_cond(__do_softirq, NULL, NULL);
+	run_on_irqstack_cond(__do_softirq, NULL);
 }
