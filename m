Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641AC33BAA2
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbhCOOJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230319AbhCOOE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5694564F4F;
        Mon, 15 Mar 2021 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817067;
        bh=IR+yqY2oYFwVDWi8KF3uEXW54HyCqoAvWDAYwVLHJUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acziaZvoQVMvP6hNz/Dra1DElJexCjV5l4SHsxIOq6KUXErg7wjGUwR7AuN6YxPCC
         tiC2W0/hWQUeiaGV8JBOw1SDDEcAnoOytW1DHfl7oLEZykuDKAU81ybuzMrRzefvdo
         pj2lnoaAz3O8qn3tt9wMRDV3N4YeQ+lJpS8/BYtY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH 5.10 272/290] x86/entry: Move nmi entry/exit into common code
Date:   Mon, 15 Mar 2021 14:56:05 +0100
Message-Id: <20210315135551.217490184@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Thomas Gleixner <tglx@linutronix.de>

commit b6be002bcd1dd1dedb926abf3c90c794eacb77dc upstream.

Lockdep state handling on NMI enter and exit is nothing specific to X86. It's
not any different on other architectures. Also the extra state type is not
necessary, irqentry_state_t can carry the necessary information as well.

Move it to common code and extend irqentry_state_t to carry lockdep state.

[ Ira: Make exit_rcu and lockdep a union as they are mutually exclusive
  between the IRQ and NMI exceptions, and add kernel documentation for
  struct irqentry_state_t ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20201102205320.1458656-7-ira.weiny@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/common.c         |   34 ----------------------------------
 arch/x86/include/asm/idtentry.h |    3 ---
 arch/x86/kernel/cpu/mce/core.c  |    6 +++---
 arch/x86/kernel/nmi.c           |    6 +++---
 arch/x86/kernel/traps.c         |   13 +++++++------
 include/linux/entry-common.h    |   39 ++++++++++++++++++++++++++++++++++++++-
 kernel/entry/common.c           |   36 ++++++++++++++++++++++++++++++++++++
 7 files changed, 87 insertions(+), 50 deletions(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -213,40 +213,6 @@ SYSCALL_DEFINE0(ni_syscall)
 	return -ENOSYS;
 }
 
-noinstr bool idtentry_enter_nmi(struct pt_regs *regs)
-{
-	bool irq_state = lockdep_hardirqs_enabled();
-
-	__nmi_enter();
-	lockdep_hardirqs_off(CALLER_ADDR0);
-	lockdep_hardirq_enter();
-	rcu_nmi_enter();
-
-	instrumentation_begin();
-	trace_hardirqs_off_finish();
-	ftrace_nmi_enter();
-	instrumentation_end();
-
-	return irq_state;
-}
-
-noinstr void idtentry_exit_nmi(struct pt_regs *regs, bool restore)
-{
-	instrumentation_begin();
-	ftrace_nmi_exit();
-	if (restore) {
-		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
-	}
-	instrumentation_end();
-
-	rcu_nmi_exit();
-	lockdep_hardirq_exit();
-	if (restore)
-		lockdep_hardirqs_on(CALLER_ADDR0);
-	__nmi_exit();
-}
-
 #ifdef CONFIG_XEN_PV
 #ifndef CONFIG_PREEMPTION
 /*
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -11,9 +11,6 @@
 
 #include <asm/irq_stack.h>
 
-bool idtentry_enter_nmi(struct pt_regs *regs);
-void idtentry_exit_nmi(struct pt_regs *regs, bool irq_state);
-
 /**
  * DECLARE_IDTENTRY - Declare functions for simple IDT entry points
  *		      No error code pushed by hardware
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1986,7 +1986,7 @@ void (*machine_check_vector)(struct pt_r
 
 static __always_inline void exc_machine_check_kernel(struct pt_regs *regs)
 {
-	bool irq_state;
+	irqentry_state_t irq_state;
 
 	WARN_ON_ONCE(user_mode(regs));
 
@@ -1998,7 +1998,7 @@ static __always_inline void exc_machine_
 	    mce_check_crashing_cpu())
 		return;
 
-	irq_state = idtentry_enter_nmi(regs);
+	irq_state = irqentry_nmi_enter(regs);
 	/*
 	 * The call targets are marked noinstr, but objtool can't figure
 	 * that out because it's an indirect call. Annotate it.
@@ -2009,7 +2009,7 @@ static __always_inline void exc_machine_
 	if (regs->flags & X86_EFLAGS_IF)
 		trace_hardirqs_on_prepare();
 	instrumentation_end();
-	idtentry_exit_nmi(regs, irq_state);
+	irqentry_nmi_exit(regs, irq_state);
 }
 
 static __always_inline void exc_machine_check_user(struct pt_regs *regs)
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -475,7 +475,7 @@ static DEFINE_PER_CPU(unsigned long, nmi
 
 DEFINE_IDTENTRY_RAW(exc_nmi)
 {
-	bool irq_state;
+	irqentry_state_t irq_state;
 
 	/*
 	 * Re-enable NMIs right here when running as an SEV-ES guest. This might
@@ -502,14 +502,14 @@ nmi_restart:
 
 	this_cpu_write(nmi_dr7, local_db_save());
 
-	irq_state = idtentry_enter_nmi(regs);
+	irq_state = irqentry_nmi_enter(regs);
 
 	inc_irq_stat(__nmi_count);
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
 
-	idtentry_exit_nmi(regs, irq_state);
+	irqentry_nmi_exit(regs, irq_state);
 
 	local_db_restore(this_cpu_read(nmi_dr7));
 
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -406,7 +406,7 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 	}
 #endif
 
-	idtentry_enter_nmi(regs);
+	irqentry_nmi_enter(regs);
 	instrumentation_begin();
 	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
 
@@ -652,12 +652,13 @@ DEFINE_IDTENTRY_RAW(exc_int3)
 		instrumentation_end();
 		irqentry_exit_to_user_mode(regs);
 	} else {
-		bool irq_state = idtentry_enter_nmi(regs);
+		irqentry_state_t irq_state = irqentry_nmi_enter(regs);
+
 		instrumentation_begin();
 		if (!do_int3(regs))
 			die("int3", regs, 0);
 		instrumentation_end();
-		idtentry_exit_nmi(regs, irq_state);
+		irqentry_nmi_exit(regs, irq_state);
 	}
 }
 
@@ -851,7 +852,7 @@ static __always_inline void exc_debug_ke
 	 * includes the entry stack is excluded for everything.
 	 */
 	unsigned long dr7 = local_db_save();
-	bool irq_state = idtentry_enter_nmi(regs);
+	irqentry_state_t irq_state = irqentry_nmi_enter(regs);
 	instrumentation_begin();
 
 	/*
@@ -908,7 +909,7 @@ static __always_inline void exc_debug_ke
 		regs->flags &= ~X86_EFLAGS_TF;
 out:
 	instrumentation_end();
-	idtentry_exit_nmi(regs, irq_state);
+	irqentry_nmi_exit(regs, irq_state);
 
 	local_db_restore(dr7);
 }
@@ -926,7 +927,7 @@ static __always_inline void exc_debug_us
 
 	/*
 	 * NB: We can't easily clear DR7 here because
-	 * idtentry_exit_to_usermode() can invoke ptrace, schedule, access
+	 * irqentry_exit_to_usermode() can invoke ptrace, schedule, access
 	 * user memory, etc.  This means that a recursive #DB is possible.  If
 	 * this happens, that #DB will hit exc_debug_kernel() and clear DR7.
 	 * Since we're not on the IST stack right now, everything will be
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -341,8 +341,26 @@ void irqentry_enter_from_user_mode(struc
 void irqentry_exit_to_user_mode(struct pt_regs *regs);
 
 #ifndef irqentry_state
+/**
+ * struct irqentry_state - Opaque object for exception state storage
+ * @exit_rcu: Used exclusively in the irqentry_*() calls; signals whether the
+ *            exit path has to invoke rcu_irq_exit().
+ * @lockdep: Used exclusively in the irqentry_nmi_*() calls; ensures that
+ *           lockdep state is restored correctly on exit from nmi.
+ *
+ * This opaque object is filled in by the irqentry_*_enter() functions and
+ * must be passed back into the corresponding irqentry_*_exit() functions
+ * when the exception is complete.
+ *
+ * Callers of irqentry_*_[enter|exit]() must consider this structure opaque
+ * and all members private.  Descriptions of the members are provided to aid in
+ * the maintenance of the irqentry_*() functions.
+ */
 typedef struct irqentry_state {
-	bool	exit_rcu;
+	union {
+		bool	exit_rcu;
+		bool	lockdep;
+	};
 } irqentry_state_t;
 #endif
 
@@ -402,4 +420,23 @@ void irqentry_exit_cond_resched(void);
  */
 void noinstr irqentry_exit(struct pt_regs *regs, irqentry_state_t state);
 
+/**
+ * irqentry_nmi_enter - Handle NMI entry
+ * @regs:	Pointer to currents pt_regs
+ *
+ * Similar to irqentry_enter() but taking care of the NMI constraints.
+ */
+irqentry_state_t noinstr irqentry_nmi_enter(struct pt_regs *regs);
+
+/**
+ * irqentry_nmi_exit - Handle return from NMI handling
+ * @regs:	Pointer to pt_regs (NMI entry regs)
+ * @irq_state:	Return value from matching call to irqentry_nmi_enter()
+ *
+ * Last action before returning to the low level assmenbly code.
+ *
+ * Counterpart to irqentry_nmi_enter().
+ */
+void noinstr irqentry_nmi_exit(struct pt_regs *regs, irqentry_state_t irq_state);
+
 #endif
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -397,3 +397,39 @@ noinstr void irqentry_exit(struct pt_reg
 			rcu_irq_exit();
 	}
 }
+
+irqentry_state_t noinstr irqentry_nmi_enter(struct pt_regs *regs)
+{
+	irqentry_state_t irq_state;
+
+	irq_state.lockdep = lockdep_hardirqs_enabled();
+
+	__nmi_enter();
+	lockdep_hardirqs_off(CALLER_ADDR0);
+	lockdep_hardirq_enter();
+	rcu_nmi_enter();
+
+	instrumentation_begin();
+	trace_hardirqs_off_finish();
+	ftrace_nmi_enter();
+	instrumentation_end();
+
+	return irq_state;
+}
+
+void noinstr irqentry_nmi_exit(struct pt_regs *regs, irqentry_state_t irq_state)
+{
+	instrumentation_begin();
+	ftrace_nmi_exit();
+	if (irq_state.lockdep) {
+		trace_hardirqs_on_prepare();
+		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	}
+	instrumentation_end();
+
+	rcu_nmi_exit();
+	lockdep_hardirq_exit();
+	if (irq_state.lockdep)
+		lockdep_hardirqs_on(CALLER_ADDR0);
+	__nmi_exit();
+}


