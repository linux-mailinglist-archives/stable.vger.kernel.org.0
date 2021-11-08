Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A0D44A115
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbhKIBH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:07:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237813AbhKIBFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:05:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B056610A3;
        Tue,  9 Nov 2021 01:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419737;
        bh=4d70ojQyTcabwi2U/vmPgkIZou54N4v/YL3GCqMgn/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMKFSAFY5G8kCYIgebtpUGlpQMvP7KW+D7I6nOs5ouK80V7qVXg2NkKFwCMAbtC20
         4knAWOG2YvM6auR68kXfRcoC90AUD7rNcbn8VB8Nr/J6vvcH/zpCnF6+clpy3m5EL0
         vzjxh1hZ1PzhlGCALCjsEcXyouebwNWnOhXxBcuW7COicXiGouUMeWuljYMVmUVJqb
         +gbHIVwaQ9ViwUTVxRK10i+0Q5Bf+Cp9AUQfQtjzAt+MjIpkkpiMnKKKp0vxxAQM3t
         itxcLs0EjYsT1cyfBf71HqEpY+GvrFfGP43CXhOeFc31QMx9Kc7YHXGu4OCVzLavBa
         OfrD8la3fa17g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, luto@kernel.org, keescook@chromium.org,
        bigeasy@linutronix.de, lukas.bulwahn@gmail.com, sh_def@163.com,
        jroedel@suse.de, laijs@linux.alibaba.com, mhiramat@kernel.org,
        chang.seok.bae@intel.com, seanjc@google.com
Subject: [PATCH AUTOSEL 5.14 020/138] x86/mm/64: Improve stack overflow warnings
Date:   Mon,  8 Nov 2021 12:44:46 -0500
Message-Id: <20211108174644.1187889-20-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 44b979fa302cab91bdd2cc982823e5c13202cd4e ]

Current code has an explicit check for hitting the task stack guard;
but overflowing any of the other stacks will get you a non-descript
general #DF warning.

Improve matters by using get_stack_info_noinstr() to detetrmine if and
which stack guard page got hit, enabling a better stack warning.

In specific, Michael Wang reported what turned out to be an NMI
exception stack overflow, which is now clearly reported as such:

  [] BUG: NMI stack guard page was hit at 0000000085fd977b (stack is 000000003a55b09e..00000000d8cce1a5)

Reported-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Michael Wang <yun.wang@linux.alibaba.com>
Link: https://lkml.kernel.org/r/YUTE/NuqnaWbST8n@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/irq_stack.h  | 37 +++++++++++++++++++++----------
 arch/x86/include/asm/stacktrace.h | 10 +++++++++
 arch/x86/include/asm/traps.h      |  6 ++---
 arch/x86/kernel/dumpstack_64.c    |  6 +++++
 arch/x86/kernel/traps.c           | 25 +++++++++++----------
 arch/x86/mm/fault.c               | 20 ++++++++---------
 6 files changed, 67 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/irq_stack.h b/arch/x86/include/asm/irq_stack.h
index 562854c608082..8d55bd11848cb 100644
--- a/arch/x86/include/asm/irq_stack.h
+++ b/arch/x86/include/asm/irq_stack.h
@@ -77,11 +77,11 @@
  *     Function calls can clobber anything except the callee-saved
  *     registers. Tell the compiler.
  */
-#define call_on_irqstack(func, asm_call, argconstr...)			\
+#define call_on_stack(stack, func, asm_call, argconstr...)		\
 {									\
 	register void *tos asm("r11");					\
 									\
-	tos = ((void *)__this_cpu_read(hardirq_stack_ptr));		\
+	tos = ((void *)(stack));					\
 									\
 	asm_inline volatile(						\
 	"movq	%%rsp, (%[tos])				\n"		\
@@ -98,6 +98,25 @@
 	);								\
 }
 
+#define ASM_CALL_ARG0							\
+	"call %P[__func]				\n"
+
+#define ASM_CALL_ARG1							\
+	"movq	%[arg1], %%rdi				\n"		\
+	ASM_CALL_ARG0
+
+#define ASM_CALL_ARG2							\
+	"movq	%[arg2], %%rsi				\n"		\
+	ASM_CALL_ARG1
+
+#define ASM_CALL_ARG3							\
+	"movq	%[arg3], %%rdx				\n"		\
+	ASM_CALL_ARG2
+
+#define call_on_irqstack(func, asm_call, argconstr...)			\
+	call_on_stack(__this_cpu_read(hardirq_stack_ptr),		\
+		      func, asm_call, argconstr)
+
 /* Macros to assert type correctness for run_*_on_irqstack macros */
 #define assert_function_type(func, proto)				\
 	static_assert(__builtin_types_compatible_p(typeof(&func), proto))
@@ -147,8 +166,7 @@
  */
 #define ASM_CALL_SYSVEC							\
 	"call irq_enter_rcu				\n"		\
-	"movq	%[arg1], %%rdi				\n"		\
-	"call %P[__func]				\n"		\
+	ASM_CALL_ARG1							\
 	"call irq_exit_rcu				\n"
 
 #define SYSVEC_CONSTRAINTS	, [arg1] "r" (regs)
@@ -168,12 +186,10 @@
  */
 #define ASM_CALL_IRQ							\
 	"call irq_enter_rcu				\n"		\
-	"movq	%[arg1], %%rdi				\n"		\
-	"movl	%[arg2], %%esi				\n"		\
-	"call %P[__func]				\n"		\
+	ASM_CALL_ARG2							\
 	"call irq_exit_rcu				\n"
 
-#define IRQ_CONSTRAINTS	, [arg1] "r" (regs), [arg2] "r" (vector)
+#define IRQ_CONSTRAINTS	, [arg1] "r" (regs), [arg2] "r" ((unsigned long)vector)
 
 #define run_irq_on_irqstack_cond(func, regs, vector)			\
 {									\
@@ -185,9 +201,6 @@
 			      IRQ_CONSTRAINTS, regs, vector);		\
 }
 
-#define ASM_CALL_SOFTIRQ						\
-	"call %P[__func]				\n"
-
 /*
  * Macro to invoke __do_softirq on the irq stack. This is only called from
  * task context when bottom halves are about to be reenabled and soft
@@ -197,7 +210,7 @@
 #define do_softirq_own_stack()						\
 {									\
 	__this_cpu_write(hardirq_stack_inuse, true);			\
-	call_on_irqstack(__do_softirq, ASM_CALL_SOFTIRQ);		\
+	call_on_irqstack(__do_softirq, ASM_CALL_ARG0);			\
 	__this_cpu_write(hardirq_stack_inuse, false);			\
 }
 
diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index f248eb2ac2d4a..3881b5333eb81 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -38,6 +38,16 @@ int get_stack_info(unsigned long *stack, struct task_struct *task,
 bool get_stack_info_noinstr(unsigned long *stack, struct task_struct *task,
 			    struct stack_info *info);
 
+static __always_inline
+bool get_stack_guard_info(unsigned long *stack, struct stack_info *info)
+{
+	/* make sure it's not in the stack proper */
+	if (get_stack_info_noinstr(stack, current, info))
+		return false;
+	/* but if it is in the page below it, we hit a guard */
+	return get_stack_info_noinstr((void *)stack + PAGE_SIZE, current, info);
+}
+
 const char *stack_type_name(enum stack_type type);
 
 static inline bool on_stack(struct stack_info *info, void *addr, size_t len)
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 7f7200021bd13..6221be7cafc3b 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -40,9 +40,9 @@ void math_emulate(struct math_emu_info *);
 bool fault_in_kernel_space(unsigned long address);
 
 #ifdef CONFIG_VMAP_STACK
-void __noreturn handle_stack_overflow(const char *message,
-				      struct pt_regs *regs,
-				      unsigned long fault_address);
+void __noreturn handle_stack_overflow(struct pt_regs *regs,
+				      unsigned long fault_address,
+				      struct stack_info *info);
 #endif
 
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 5601b95944fae..6c5defd6569a3 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -32,9 +32,15 @@ const char *stack_type_name(enum stack_type type)
 {
 	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
 
+	if (type == STACK_TYPE_TASK)
+		return "TASK";
+
 	if (type == STACK_TYPE_IRQ)
 		return "IRQ";
 
+	if (type == STACK_TYPE_SOFTIRQ)
+		return "SOFTIRQ";
+
 	if (type == STACK_TYPE_ENTRY) {
 		/*
 		 * On 64-bit, we have a generic entry stack that we
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a58800973aed3..77857d41289dd 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -313,17 +313,19 @@ DEFINE_IDTENTRY_ERRORCODE(exc_alignment_check)
 }
 
 #ifdef CONFIG_VMAP_STACK
-__visible void __noreturn handle_stack_overflow(const char *message,
-						struct pt_regs *regs,
-						unsigned long fault_address)
+__visible void __noreturn handle_stack_overflow(struct pt_regs *regs,
+						unsigned long fault_address,
+						struct stack_info *info)
 {
-	printk(KERN_EMERG "BUG: stack guard page was hit at %p (stack is %p..%p)\n",
-		 (void *)fault_address, current->stack,
-		 (char *)current->stack + THREAD_SIZE - 1);
-	die(message, regs, 0);
+	const char *name = stack_type_name(info->type);
+
+	printk(KERN_EMERG "BUG: %s stack guard page was hit at %p (stack is %p..%p)\n",
+	       name, (void *)fault_address, info->begin, info->end);
+
+	die("stack guard page", regs, 0);
 
 	/* Be absolutely certain we don't return. */
-	panic("%s", message);
+	panic("%s stack guard hit", name);
 }
 #endif
 
@@ -353,6 +355,7 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 
 #ifdef CONFIG_VMAP_STACK
 	unsigned long address = read_cr2();
+	struct stack_info info;
 #endif
 
 #ifdef CONFIG_X86_ESPFIX64
@@ -455,10 +458,8 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 	 * stack even if the actual trigger for the double fault was
 	 * something else.
 	 */
-	if ((unsigned long)task_stack_page(tsk) - 1 - address < PAGE_SIZE) {
-		handle_stack_overflow("kernel stack overflow (double-fault)",
-				      regs, address);
-	}
+	if (get_stack_guard_info((void *)address, &info))
+		handle_stack_overflow(regs, address, &info);
 #endif
 
 	pr_emerg("PANIC: double fault, error_code: 0x%lx\n", error_code);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 84a2c8c4af735..4bfed53e210ec 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -32,6 +32,7 @@
 #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
+#include <asm/irq_stack.h>
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -631,6 +632,9 @@ static noinline void
 page_fault_oops(struct pt_regs *regs, unsigned long error_code,
 		unsigned long address)
 {
+#ifdef CONFIG_VMAP_STACK
+	struct stack_info info;
+#endif
 	unsigned long flags;
 	int sig;
 
@@ -649,9 +653,7 @@ page_fault_oops(struct pt_regs *regs, unsigned long error_code,
 	 * that we're in vmalloc space to avoid this.
 	 */
 	if (is_vmalloc_addr((void *)address) &&
-	    (((unsigned long)current->stack - 1 - address < PAGE_SIZE) ||
-	     address - ((unsigned long)current->stack + THREAD_SIZE) < PAGE_SIZE)) {
-		unsigned long stack = __this_cpu_ist_top_va(DF) - sizeof(void *);
+	    get_stack_guard_info((void *)address, &info)) {
 		/*
 		 * We're likely to be running with very little stack space
 		 * left.  It's plausible that we'd hit this condition but
@@ -662,13 +664,11 @@ page_fault_oops(struct pt_regs *regs, unsigned long error_code,
 		 * and then double-fault, though, because we're likely to
 		 * break the console driver and lose most of the stack dump.
 		 */
-		asm volatile ("movq %[stack], %%rsp\n\t"
-			      "call handle_stack_overflow\n\t"
-			      "1: jmp 1b"
-			      : ASM_CALL_CONSTRAINT
-			      : "D" ("kernel stack overflow (page fault)"),
-				"S" (regs), "d" (address),
-				[stack] "rm" (stack));
+		call_on_stack(__this_cpu_ist_top_va(DF) - sizeof(void*),
+			      handle_stack_overflow,
+			      ASM_CALL_ARG3,
+			      , [arg1] "r" (regs), [arg2] "r" (address), [arg3] "r" (&info));
+
 		unreachable();
 	}
 #endif
-- 
2.33.0

