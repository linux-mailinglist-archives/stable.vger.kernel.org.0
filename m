Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D3827C6CA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgI2Lsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731144AbgI2Ls3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BADE22262;
        Tue, 29 Sep 2020 11:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380109;
        bh=AK2bwjvHj9MfLw8UFZGtIUt0G4yRYF7r++wH8Ksr19E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnNVve+Y02viD6tsayIAYCGBmwU6RehGUJCMQE3dvM8+CUwXDBWB11+IdXDckhXZr
         xD4goCLV/X/jZSd0sMVqIebNCWGvKcADJB4FOOVE1u1HBwPVJB3RYUfWjxapP2tgH4
         kFfobh9RwwuECvalevUSR1ty3QmJfvelIt5r/mjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.8 72/99] x86/irq: Make run_on_irqstack_cond() typesafe
Date:   Tue, 29 Sep 2020 13:01:55 +0200
Message-Id: <20200929105933.277296686@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit a7b3474cbb2864d5500d5e4f48dd57c903975cab upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/common.c          |    2 -
 arch/x86/entry/entry_64.S        |    2 +
 arch/x86/include/asm/idtentry.h  |    2 -
 arch/x86/include/asm/irq_stack.h |   70 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/irq.c            |    2 -
 arch/x86/kernel/irq_64.c         |    2 -
 6 files changed, 68 insertions(+), 12 deletions(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -814,7 +814,7 @@ __visible noinstr void xen_pv_evtchn_do_
 	old_regs = set_irq_regs(regs);
 
 	instrumentation_begin();
-	run_on_irqstack_cond(__xen_pv_evtchn_do_upcall, NULL, regs);
+	run_on_irqstack_cond(__xen_pv_evtchn_do_upcall, regs);
 	instrumentation_begin();
 
 	set_irq_regs(old_regs);
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -687,6 +687,8 @@ SYM_CODE_END(.Lbad_gs)
  * rdx: Function argument (can be NULL if none)
  */
 SYM_FUNC_START(asm_call_on_stack)
+SYM_INNER_LABEL(asm_call_sysvec_on_stack, SYM_L_GLOBAL)
+SYM_INNER_LABEL(asm_call_irq_on_stack, SYM_L_GLOBAL)
 	/*
 	 * Save the frame pointer unconditionally. This allows the ORC
 	 * unwinder to handle the stack switch.
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -246,7 +246,7 @@ __visible noinstr void func(struct pt_re
 	instrumentation_begin();					\
 	irq_enter_rcu();						\
 	kvm_set_cpu_l1tf_flush_l1d();					\
-	run_on_irqstack_cond(__##func, regs, regs);			\
+	run_sysvec_on_irqstack_cond(__##func, regs);			\
 	irq_exit_rcu();							\
 	instrumentation_end();						\
 	idtentry_exit_cond_rcu(regs, rcu_exit);				\
--- a/arch/x86/include/asm/irq_stack.h
+++ b/arch/x86/include/asm/irq_stack.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_IRQ_STACK_H
 
 #include <linux/ptrace.h>
+#include <linux/irq.h>
 
 #include <asm/processor.h>
 
@@ -12,20 +13,50 @@ static __always_inline bool irqstack_act
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
@@ -37,17 +68,40 @@ static __always_inline bool irq_needs_ir
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
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -227,7 +227,7 @@ static __always_inline void handle_irq(s
 				       struct pt_regs *regs)
 {
 	if (IS_ENABLED(CONFIG_X86_64))
-		run_on_irqstack_cond(desc->handle_irq, desc, regs);
+		run_irq_on_irqstack_cond(desc->handle_irq, desc, regs);
 	else
 		__handle_irq(desc, regs);
 }
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -74,5 +74,5 @@ int irq_init_percpu_irqstack(unsigned in
 
 void do_softirq_own_stack(void)
 {
-	run_on_irqstack_cond(__do_softirq, NULL, NULL);
+	run_on_irqstack_cond(__do_softirq, NULL);
 }


