Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5622CD6DF
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436465AbgLCNa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436560AbgLCNaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:30:24 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
        uclinux-h8-devel@lists.sourceforge.jp,
        linux-hexagon@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, openrisc@lists.librecores.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 27/39] sched/idle: Fix arch_cpu_idle() vs tracing
Date:   Thu,  3 Dec 2020 08:28:21 -0500
Message-Id: <20201203132834.930999-27-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132834.930999-1-sashal@kernel.org>
References: <20201203132834.930999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 58c644ba512cfbc2e39b758dd979edd1d6d00e27 ]

We call arch_cpu_idle() with RCU disabled, but then use
local_irq_{en,dis}able(), which invokes tracing, which relies on RCU.

Switch all arch_cpu_idle() implementations to use
raw_local_irq_{en,dis}able() and carefully manage the
lockdep,rcu,tracing state like we do in entry.

(XXX: we really should change arch_cpu_idle() to not return with
interrupts enabled)

Reported-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lkml.kernel.org/r/20201120114925.594122626@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/process.c      |  2 +-
 arch/arm/kernel/process.c        |  2 +-
 arch/arm64/kernel/process.c      |  2 +-
 arch/csky/kernel/process.c       |  2 +-
 arch/h8300/kernel/process.c      |  2 +-
 arch/hexagon/kernel/process.c    |  2 +-
 arch/ia64/kernel/process.c       |  2 +-
 arch/microblaze/kernel/process.c |  2 +-
 arch/mips/kernel/idle.c          | 12 ++++++------
 arch/nios2/kernel/process.c      |  2 +-
 arch/openrisc/kernel/process.c   |  2 +-
 arch/parisc/kernel/process.c     |  2 +-
 arch/powerpc/kernel/idle.c       |  4 ++--
 arch/riscv/kernel/process.c      |  2 +-
 arch/s390/kernel/idle.c          |  6 +++---
 arch/sh/kernel/idle.c            |  2 +-
 arch/sparc/kernel/leon_pmc.c     |  4 ++--
 arch/sparc/kernel/process_32.c   |  2 +-
 arch/sparc/kernel/process_64.c   |  4 ++--
 arch/um/kernel/process.c         |  2 +-
 arch/x86/include/asm/mwait.h     |  2 --
 arch/x86/kernel/process.c        | 12 +++++++-----
 kernel/sched/idle.c              | 28 +++++++++++++++++++++++++++-
 23 files changed, 64 insertions(+), 38 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 7462a79110024..4c7b0414a3ff3 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -57,7 +57,7 @@ EXPORT_SYMBOL(pm_power_off);
 void arch_cpu_idle(void)
 {
 	wtint(0);
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 void arch_cpu_idle_dead(void)
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 8e6ace03e960b..9f199b1e83839 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -71,7 +71,7 @@ void arch_cpu_idle(void)
 		arm_pm_idle();
 	else
 		cpu_do_idle();
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 void arch_cpu_idle_prepare(void)
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 2da5f3f9d345f..f7c42a7d09b66 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -124,7 +124,7 @@ void arch_cpu_idle(void)
 	 * tricks
 	 */
 	cpu_do_idle();
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/csky/kernel/process.c b/arch/csky/kernel/process.c
index f730869e21eed..69af6bc87e647 100644
--- a/arch/csky/kernel/process.c
+++ b/arch/csky/kernel/process.c
@@ -102,6 +102,6 @@ void arch_cpu_idle(void)
 #ifdef CONFIG_CPU_PM_STOP
 	asm volatile("stop\n");
 #endif
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 #endif
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index 83ce3caf73139..a2961c7b2332c 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -57,7 +57,7 @@ asmlinkage void ret_from_kernel_thread(void);
  */
 void arch_cpu_idle(void)
 {
-	local_irq_enable();
+	raw_local_irq_enable();
 	__asm__("sleep");
 }
 
diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index dfd322c5ce83a..20962601a1b47 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -44,7 +44,7 @@ void arch_cpu_idle(void)
 {
 	__vmwait();
 	/*  interrupts wake us up, but irqs are still disabled */
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 /*
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index f19cb97c00987..1b2769260688d 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -252,7 +252,7 @@ void arch_cpu_idle(void)
 	if (mark_idle)
 		(*mark_idle)(1);
 
-	safe_halt();
+	raw_safe_halt();
 
 	if (mark_idle)
 		(*mark_idle)(0);
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index a9e46e525cd0a..f99860771ff48 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -149,5 +149,5 @@ int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpregs)
 
 void arch_cpu_idle(void)
 {
-       local_irq_enable();
+       raw_local_irq_enable();
 }
diff --git a/arch/mips/kernel/idle.c b/arch/mips/kernel/idle.c
index 5bc3b04693c7d..18e69ebf5691d 100644
--- a/arch/mips/kernel/idle.c
+++ b/arch/mips/kernel/idle.c
@@ -33,19 +33,19 @@ static void __cpuidle r3081_wait(void)
 {
 	unsigned long cfg = read_c0_conf();
 	write_c0_conf(cfg | R30XX_CONF_HALT);
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 static void __cpuidle r39xx_wait(void)
 {
 	if (!need_resched())
 		write_c0_conf(read_c0_conf() | TX39_CONF_HALT);
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 void __cpuidle r4k_wait(void)
 {
-	local_irq_enable();
+	raw_local_irq_enable();
 	__r4k_wait();
 }
 
@@ -64,7 +64,7 @@ void __cpuidle r4k_wait_irqoff(void)
 		"	.set	arch=r4000	\n"
 		"	wait			\n"
 		"	.set	pop		\n");
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 /*
@@ -84,7 +84,7 @@ static void __cpuidle rm7k_wait_irqoff(void)
 		"	wait						\n"
 		"	mtc0	$1, $12		# stalls until W stage	\n"
 		"	.set	pop					\n");
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 /*
@@ -257,7 +257,7 @@ void arch_cpu_idle(void)
 	if (cpu_wait)
 		cpu_wait();
 	else
-		local_irq_enable();
+		raw_local_irq_enable();
 }
 
 #ifdef CONFIG_CPU_IDLE
diff --git a/arch/nios2/kernel/process.c b/arch/nios2/kernel/process.c
index 88a4ec03edab4..f5cc55a88d310 100644
--- a/arch/nios2/kernel/process.c
+++ b/arch/nios2/kernel/process.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL(pm_power_off);
 
 void arch_cpu_idle(void)
 {
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 /*
diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
index 0ff391f00334c..3c98728cce249 100644
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -79,7 +79,7 @@ void machine_power_off(void)
  */
 void arch_cpu_idle(void)
 {
-	local_irq_enable();
+	raw_local_irq_enable();
 	if (mfspr(SPR_UPR) & SPR_UPR_PMP)
 		mtspr(SPR_PMR, mfspr(SPR_PMR) | SPR_PMR_DME);
 }
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index f196d96e2f9f5..a92a23d6acd93 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -169,7 +169,7 @@ void __cpuidle arch_cpu_idle_dead(void)
 
 void __cpuidle arch_cpu_idle(void)
 {
-	local_irq_enable();
+	raw_local_irq_enable();
 
 	/* nop on real hardware, qemu will idle sleep. */
 	asm volatile("or %%r10,%%r10,%%r10\n":::);
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 422e31d2f5a2b..8df35f1329a42 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -60,9 +60,9 @@ void arch_cpu_idle(void)
 		 * interrupts enabled, some don't.
 		 */
 		if (irqs_disabled())
-			local_irq_enable();
+			raw_local_irq_enable();
 	} else {
-		local_irq_enable();
+		raw_local_irq_enable();
 		/*
 		 * Go into low thread priority and possibly
 		 * low power mode.
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 2b97c493427c9..308e1d95ecbf0 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -36,7 +36,7 @@ extern asmlinkage void ret_from_kernel_thread(void);
 void arch_cpu_idle(void)
 {
 	wait_for_interrupt();
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 void show_regs(struct pt_regs *regs)
diff --git a/arch/s390/kernel/idle.c b/arch/s390/kernel/idle.c
index f7f1e64e0d980..2b85096964f84 100644
--- a/arch/s390/kernel/idle.c
+++ b/arch/s390/kernel/idle.c
@@ -33,10 +33,10 @@ void enabled_wait(void)
 		PSW_MASK_IO | PSW_MASK_EXT | PSW_MASK_MCHECK;
 	clear_cpu_flag(CIF_NOHZ_DELAY);
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	/* Call the assembler magic in entry.S */
 	psw_idle(idle, psw_mask);
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 
 	/* Account time spent with enabled wait psw loaded as idle time. */
 	raw_write_seqcount_begin(&idle->seqcount);
@@ -123,7 +123,7 @@ void arch_cpu_idle_enter(void)
 void arch_cpu_idle(void)
 {
 	enabled_wait();
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 void arch_cpu_idle_exit(void)
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 0dc0f52f9bb8d..f59814983bd59 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -22,7 +22,7 @@ static void (*sh_idle)(void);
 void default_idle(void)
 {
 	set_bl_bit();
-	local_irq_enable();
+	raw_local_irq_enable();
 	/* Isn't this racy ? */
 	cpu_sleep();
 	clear_bl_bit();
diff --git a/arch/sparc/kernel/leon_pmc.c b/arch/sparc/kernel/leon_pmc.c
index 065e2d4b72908..396f46bca52eb 100644
--- a/arch/sparc/kernel/leon_pmc.c
+++ b/arch/sparc/kernel/leon_pmc.c
@@ -50,7 +50,7 @@ static void pmc_leon_idle_fixup(void)
 	register unsigned int address = (unsigned int)leon3_irqctrl_regs;
 
 	/* Interrupts need to be enabled to not hang the CPU */
-	local_irq_enable();
+	raw_local_irq_enable();
 
 	__asm__ __volatile__ (
 		"wr	%%g0, %%asr19\n"
@@ -66,7 +66,7 @@ static void pmc_leon_idle_fixup(void)
 static void pmc_leon_idle(void)
 {
 	/* Interrupts need to be enabled to not hang the CPU */
-	local_irq_enable();
+	raw_local_irq_enable();
 
 	/* For systems without power-down, this will be no-op */
 	__asm__ __volatile__ ("wr	%g0, %asr19\n\t");
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index adfcaeab3ddc5..a023637359154 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -74,7 +74,7 @@ void arch_cpu_idle(void)
 {
 	if (sparc_idle)
 		(*sparc_idle)();
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 /* XXX cli/sti -> local_irq_xxx here, check this works once SMP is fixed. */
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index a75093b993f9a..6f8c7822fc065 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -62,11 +62,11 @@ void arch_cpu_idle(void)
 {
 	if (tlb_type != hypervisor) {
 		touch_nmi_watchdog();
-		local_irq_enable();
+		raw_local_irq_enable();
 	} else {
 		unsigned long pstate;
 
-		local_irq_enable();
+		raw_local_irq_enable();
 
                 /* The sun4v sleeping code requires that we have PSTATE.IE cleared over
                  * the cpu sleep hypervisor call.
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 26b5e243d3fc0..495f101792b3d 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -217,7 +217,7 @@ void arch_cpu_idle(void)
 {
 	cpu_tasks[current_thread_info()->cpu].pid = os_getpid();
 	um_idle_sleep();
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 int __cant_sleep(void) {
diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index e039a933aca3c..29dd27b5a339d 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -88,8 +88,6 @@ static inline void __mwaitx(unsigned long eax, unsigned long ebx,
 
 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
-	trace_hardirqs_on();
-
 	mds_idle_clear_cpu_buffers();
 	/* "mwait %eax, %ecx;" */
 	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ba4593a913fab..145a7ac0c19aa 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -685,7 +685,7 @@ void arch_cpu_idle(void)
  */
 void __cpuidle default_idle(void)
 {
-	safe_halt();
+	raw_safe_halt();
 }
 #if defined(CONFIG_APM_MODULE) || defined(CONFIG_HALTPOLL_CPUIDLE_MODULE)
 EXPORT_SYMBOL(default_idle);
@@ -736,6 +736,8 @@ void stop_this_cpu(void *dummy)
 /*
  * AMD Erratum 400 aware idle routine. We handle it the same way as C3 power
  * states (local apic timer and TSC stop).
+ *
+ * XXX this function is completely buggered vs RCU and tracing.
  */
 static void amd_e400_idle(void)
 {
@@ -757,9 +759,9 @@ static void amd_e400_idle(void)
 	 * The switch back from broadcast mode needs to be called with
 	 * interrupts disabled.
 	 */
-	local_irq_disable();
+	raw_local_irq_disable();
 	tick_broadcast_exit();
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 /*
@@ -801,9 +803,9 @@ static __cpuidle void mwait_idle(void)
 		if (!need_resched())
 			__sti_mwait(0, 0);
 		else
-			local_irq_enable();
+			raw_local_irq_enable();
 	} else {
-		local_irq_enable();
+		raw_local_irq_enable();
 	}
 	__current_clr_polling();
 }
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index f324dc36fc43d..dee807ffad11b 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -78,7 +78,7 @@ void __weak arch_cpu_idle_dead(void) { }
 void __weak arch_cpu_idle(void)
 {
 	cpu_idle_force_poll = 1;
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 /**
@@ -94,9 +94,35 @@ void __cpuidle default_idle_call(void)
 
 		trace_cpu_idle(1, smp_processor_id());
 		stop_critical_timings();
+
+		/*
+		 * arch_cpu_idle() is supposed to enable IRQs, however
+		 * we can't do that because of RCU and tracing.
+		 *
+		 * Trace IRQs enable here, then switch off RCU, and have
+		 * arch_cpu_idle() use raw_local_irq_enable(). Note that
+		 * rcu_idle_enter() relies on lockdep IRQ state, so switch that
+		 * last -- this is very similar to the entry code.
+		 */
+		trace_hardirqs_on_prepare();
+		lockdep_hardirqs_on_prepare(_THIS_IP_);
 		rcu_idle_enter();
+		lockdep_hardirqs_on(_THIS_IP_);
+
 		arch_cpu_idle();
+
+		/*
+		 * OK, so IRQs are enabled here, but RCU needs them disabled to
+		 * turn itself back on.. funny thing is that disabling IRQs
+		 * will cause tracing, which needs RCU. Jump through hoops to
+		 * make it 'work'.
+		 */
+		raw_local_irq_disable();
+		lockdep_hardirqs_off(_THIS_IP_);
 		rcu_idle_exit();
+		lockdep_hardirqs_on(_THIS_IP_);
+		raw_local_irq_enable();
+
 		start_critical_timings();
 		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 	}
-- 
2.27.0

