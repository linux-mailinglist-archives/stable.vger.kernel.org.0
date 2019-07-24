Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D353C73955
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389265AbfGXTjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389419AbfGXTjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A1E721873;
        Wed, 24 Jul 2019 19:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997156;
        bh=21FPgqHMfv8C/FOTC0D1ilVmH67gAkzOil715Fzdfvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGNe1KeYh2sfnjs05UZwgL6UHqE51CGuSDcDI53qHPK9xU5SCnY5HHX/wx4JdJbQ7
         DKbjzDo8AynbZrjXOXh08viZY6iRttIxB7KN+fljJfkargS9SVWtcbodFE1hKDUKn6
         QfVmBmZVOZ0E9hPqmi+i258c1KxKCzi+/4guO/io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Wei Li <liwei391@huawei.com>,
        Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.2 338/413] arm64: Fix incorrect irqflag restore for priority masking
Date:   Wed, 24 Jul 2019 21:20:29 +0200
Message-Id: <20190724191800.013685659@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

commit bd82d4bd21880b7c4d5f5756be435095d6ae07b5 upstream.

When using IRQ priority masking to disable interrupts, in order to deal
with the PSR.I state, local_irq_save() would convert the I bit into a
PMR value (GIC_PRIO_IRQOFF). This resulted in local_irq_restore()
potentially modifying the value of PMR in undesired location due to the
state of PSR.I upon flag saving [1].

In an attempt to solve this issue in a less hackish manner, introduce
a bit (GIC_PRIO_IGNORE_PMR) for the PMR values that can represent
whether PSR.I is being used to disable interrupts, in which case it
takes precedence of the status of interrupt masking via PMR.

GIC_PRIO_PSR_I_SET is chosen such that (<pmr_value> |
GIC_PRIO_PSR_I_SET) does not mask more interrupts than <pmr_value> as
some sections (e.g. arch_cpu_idle(), interrupt acknowledge path)
requires PMR not to mask interrupts that could be signaled to the
CPU when using only PSR.I.

[1] https://www.spinics.net/lists/arm-kernel/msg716956.html

Fixes: 4a503217ce37 ("arm64: irqflags: Use ICC_PMR_EL1 for interrupt masking")
Cc: <stable@vger.kernel.org> # 5.1.x-
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Wei Li <liwei391@huawei.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/arch_gicv3.h |    4 +-
 arch/arm64/include/asm/daifflags.h  |   68 +++++++++++++++++++++---------------
 arch/arm64/include/asm/irqflags.h   |   67 ++++++++++++++---------------------
 arch/arm64/include/asm/kvm_host.h   |    7 ++-
 arch/arm64/include/asm/ptrace.h     |   10 ++++-
 arch/arm64/kernel/entry.S           |   38 +++++++++++++++++---
 arch/arm64/kernel/process.c         |    2 -
 arch/arm64/kernel/smp.c             |    8 ++--
 arch/arm64/kvm/hyp/switch.c         |    2 -
 9 files changed, 123 insertions(+), 83 deletions(-)

--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -152,7 +152,9 @@ static inline bool gic_prio_masking_enab
 
 static inline void gic_pmr_mask_irqs(void)
 {
-	BUILD_BUG_ON(GICD_INT_DEF_PRI <= GIC_PRIO_IRQOFF);
+	BUILD_BUG_ON(GICD_INT_DEF_PRI < (GIC_PRIO_IRQOFF |
+					 GIC_PRIO_PSR_I_SET));
+	BUILD_BUG_ON(GICD_INT_DEF_PRI >= GIC_PRIO_IRQON);
 	gic_write_pmr(GIC_PRIO_IRQOFF);
 }
 
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -7,6 +7,7 @@
 
 #include <linux/irqflags.h>
 
+#include <asm/arch_gicv3.h>
 #include <asm/cpufeature.h>
 
 #define DAIF_PROCCTX		0
@@ -21,6 +22,11 @@ static inline void local_daif_mask(void)
 		:
 		:
 		: "memory");
+
+	/* Don't really care for a dsb here, we don't intend to enable IRQs */
+	if (system_uses_irq_prio_masking())
+		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
+
 	trace_hardirqs_off();
 }
 
@@ -32,7 +38,7 @@ static inline unsigned long local_daif_s
 
 	if (system_uses_irq_prio_masking()) {
 		/* If IRQs are masked with PMR, reflect it in the flags */
-		if (read_sysreg_s(SYS_ICC_PMR_EL1) <= GIC_PRIO_IRQOFF)
+		if (read_sysreg_s(SYS_ICC_PMR_EL1) != GIC_PRIO_IRQON)
 			flags |= PSR_I_BIT;
 	}
 
@@ -48,36 +54,44 @@ static inline void local_daif_restore(un
 	if (!irq_disabled) {
 		trace_hardirqs_on();
 
-		if (system_uses_irq_prio_masking())
-			arch_local_irq_enable();
-	} else if (!(flags & PSR_A_BIT)) {
-		/*
-		 * If interrupts are disabled but we can take
-		 * asynchronous errors, we can take NMIs
-		 */
 		if (system_uses_irq_prio_masking()) {
-			flags &= ~PSR_I_BIT;
+			gic_write_pmr(GIC_PRIO_IRQON);
+			dsb(sy);
+		}
+	} else if (system_uses_irq_prio_masking()) {
+		u64 pmr;
+
+		if (!(flags & PSR_A_BIT)) {
 			/*
-			 * There has been concern that the write to daif
-			 * might be reordered before this write to PMR.
-			 * From the ARM ARM DDI 0487D.a, section D1.7.1
-			 * "Accessing PSTATE fields":
-			 *   Writes to the PSTATE fields have side-effects on
-			 *   various aspects of the PE operation. All of these
-			 *   side-effects are guaranteed:
-			 *     - Not to be visible to earlier instructions in
-			 *       the execution stream.
-			 *     - To be visible to later instructions in the
-			 *       execution stream
-			 *
-			 * Also, writes to PMR are self-synchronizing, so no
-			 * interrupts with a lower priority than PMR is signaled
-			 * to the PE after the write.
-			 *
-			 * So we don't need additional synchronization here.
+			 * If interrupts are disabled but we can take
+			 * asynchronous errors, we can take NMIs
 			 */
-			arch_local_irq_disable();
+			flags &= ~PSR_I_BIT;
+			pmr = GIC_PRIO_IRQOFF;
+		} else {
+			pmr = GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET;
 		}
+
+		/*
+		 * There has been concern that the write to daif
+		 * might be reordered before this write to PMR.
+		 * From the ARM ARM DDI 0487D.a, section D1.7.1
+		 * "Accessing PSTATE fields":
+		 *   Writes to the PSTATE fields have side-effects on
+		 *   various aspects of the PE operation. All of these
+		 *   side-effects are guaranteed:
+		 *     - Not to be visible to earlier instructions in
+		 *       the execution stream.
+		 *     - To be visible to later instructions in the
+		 *       execution stream
+		 *
+		 * Also, writes to PMR are self-synchronizing, so no
+		 * interrupts with a lower priority than PMR is signaled
+		 * to the PE after the write.
+		 *
+		 * So we don't need additional synchronization here.
+		 */
+		gic_write_pmr(pmr);
 	}
 
 	write_sysreg(flags, daif);
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -56,43 +56,46 @@ static inline void arch_local_irq_disabl
  */
 static inline unsigned long arch_local_save_flags(void)
 {
-	unsigned long daif_bits;
 	unsigned long flags;
 
-	daif_bits = read_sysreg(daif);
-
-	/*
-	 * The asm is logically equivalent to:
-	 *
-	 * if (system_uses_irq_prio_masking())
-	 *	flags = (daif_bits & PSR_I_BIT) ?
-	 *			GIC_PRIO_IRQOFF :
-	 *			read_sysreg_s(SYS_ICC_PMR_EL1);
-	 * else
-	 *	flags = daif_bits;
-	 */
 	asm volatile(ALTERNATIVE(
-			"mov	%0, %1\n"
-			"nop\n"
-			"nop",
-			__mrs_s("%0", SYS_ICC_PMR_EL1)
-			"ands	%1, %1, " __stringify(PSR_I_BIT) "\n"
-			"csel	%0, %0, %2, eq",
-			ARM64_HAS_IRQ_PRIO_MASKING)
-		: "=&r" (flags), "+r" (daif_bits)
-		: "r" ((unsigned long) GIC_PRIO_IRQOFF)
-		: "cc", "memory");
+		"mrs	%0, daif",
+		__mrs_s("%0", SYS_ICC_PMR_EL1),
+		ARM64_HAS_IRQ_PRIO_MASKING)
+		: "=&r" (flags)
+		:
+		: "memory");
 
 	return flags;
 }
 
+static inline int arch_irqs_disabled_flags(unsigned long flags)
+{
+	int res;
+
+	asm volatile(ALTERNATIVE(
+		"and	%w0, %w1, #" __stringify(PSR_I_BIT),
+		"eor	%w0, %w1, #" __stringify(GIC_PRIO_IRQON),
+		ARM64_HAS_IRQ_PRIO_MASKING)
+		: "=&r" (res)
+		: "r" ((int) flags)
+		: "memory");
+
+	return res;
+}
+
 static inline unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 
 	flags = arch_local_save_flags();
 
-	arch_local_irq_disable();
+	/*
+	 * There are too many states with IRQs disabled, just keep the current
+	 * state if interrupts are already disabled/masked.
+	 */
+	if (!arch_irqs_disabled_flags(flags))
+		arch_local_irq_disable();
 
 	return flags;
 }
@@ -113,21 +116,5 @@ static inline void arch_local_irq_restor
 		: "memory");
 }
 
-static inline int arch_irqs_disabled_flags(unsigned long flags)
-{
-	int res;
-
-	asm volatile(ALTERNATIVE(
-			"and	%w0, %w1, #" __stringify(PSR_I_BIT) "\n"
-			"nop",
-			"cmp	%w1, #" __stringify(GIC_PRIO_IRQOFF) "\n"
-			"cset	%w0, ls",
-			ARM64_HAS_IRQ_PRIO_MASKING)
-		: "=&r" (res)
-		: "r" ((int) flags)
-		: "cc", "memory");
-
-	return res;
-}
 #endif
 #endif
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -597,11 +597,12 @@ static inline void kvm_arm_vhe_guest_ent
 	 * will not signal the CPU of interrupts of lower priority, and the
 	 * only way to get out will be via guest exceptions.
 	 * Naturally, we want to avoid this.
+	 *
+	 * local_daif_mask() already sets GIC_PRIO_PSR_I_SET, we just need a
+	 * dsb to ensure the redistributor is forwards EL2 IRQs to the CPU.
 	 */
-	if (system_uses_irq_prio_masking()) {
-		gic_write_pmr(GIC_PRIO_IRQON);
+	if (system_uses_irq_prio_masking())
 		dsb(sy);
-	}
 }
 
 static inline void kvm_arm_vhe_guest_exit(void)
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -24,9 +24,15 @@
  * means masking more IRQs (or at least that the same IRQs remain masked).
  *
  * To mask interrupts, we clear the most significant bit of PMR.
+ *
+ * Some code sections either automatically switch back to PSR.I or explicitly
+ * require to not use priority masking. If bit GIC_PRIO_PSR_I_SET is included
+ * in the  the priority mask, it indicates that PSR.I should be set and
+ * interrupt disabling temporarily does not rely on IRQ priorities.
  */
-#define GIC_PRIO_IRQON		0xf0
-#define GIC_PRIO_IRQOFF		(GIC_PRIO_IRQON & ~0x80)
+#define GIC_PRIO_IRQON			0xc0
+#define GIC_PRIO_IRQOFF			(GIC_PRIO_IRQON & ~0x80)
+#define GIC_PRIO_PSR_I_SET		(1 << 4)
 
 /* Additional SPSR bits not exposed in the UABI */
 #define PSR_IL_BIT		(1 << 20)
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -247,6 +247,7 @@ alternative_else_nop_endif
 	/*
 	 * Registers that may be useful after this macro is invoked:
 	 *
+	 * x20 - ICC_PMR_EL1
 	 * x21 - aborted SP
 	 * x22 - aborted PC
 	 * x23 - aborted PSTATE
@@ -438,6 +439,24 @@ alternative_endif
 	.endm
 #endif
 
+	.macro	gic_prio_kentry_setup, tmp:req
+#ifdef CONFIG_ARM64_PSEUDO_NMI
+	alternative_if ARM64_HAS_IRQ_PRIO_MASKING
+	mov	\tmp, #(GIC_PRIO_PSR_I_SET | GIC_PRIO_IRQON)
+	msr_s	SYS_ICC_PMR_EL1, \tmp
+	alternative_else_nop_endif
+#endif
+	.endm
+
+	.macro	gic_prio_irq_setup, pmr:req, tmp:req
+#ifdef CONFIG_ARM64_PSEUDO_NMI
+	alternative_if ARM64_HAS_IRQ_PRIO_MASKING
+	orr	\tmp, \pmr, #GIC_PRIO_PSR_I_SET
+	msr_s	SYS_ICC_PMR_EL1, \tmp
+	alternative_else_nop_endif
+#endif
+	.endm
+
 	.text
 
 /*
@@ -616,6 +635,7 @@ el1_dbg:
 	cmp	x24, #ESR_ELx_EC_BRK64		// if BRK64
 	cinc	x24, x24, eq			// set bit '0'
 	tbz	x24, #0, el1_inv		// EL1 only
+	gic_prio_kentry_setup tmp=x3
 	mrs	x0, far_el1
 	mov	x2, sp				// struct pt_regs
 	bl	do_debug_exception
@@ -633,12 +653,10 @@ ENDPROC(el1_sync)
 	.align	6
 el1_irq:
 	kernel_entry 1
+	gic_prio_irq_setup pmr=x20, tmp=x1
 	enable_da_f
 
 #ifdef CONFIG_ARM64_PSEUDO_NMI
-alternative_if ARM64_HAS_IRQ_PRIO_MASKING
-	ldr	x20, [sp, #S_PMR_SAVE]
-alternative_else_nop_endif
 	test_irqs_unmasked	res=x0, pmr=x20
 	cbz	x0, 1f
 	bl	asm_nmi_enter
@@ -668,8 +686,9 @@ alternative_else_nop_endif
 
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 	/*
-	 * if IRQs were disabled when we received the interrupt, we have an NMI
-	 * and we are not re-enabling interrupt upon eret. Skip tracing.
+	 * When using IRQ priority masking, we can get spurious interrupts while
+	 * PMR is set to GIC_PRIO_IRQOFF. An NMI might also have occurred in a
+	 * section with interrupts disabled. Skip tracing in those cases.
 	 */
 	test_irqs_unmasked	res=x0, pmr=x20
 	cbz	x0, 1f
@@ -798,6 +817,7 @@ el0_ia:
 	 * Instruction abort handling
 	 */
 	mrs	x26, far_el1
+	gic_prio_kentry_setup tmp=x0
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
@@ -843,6 +863,7 @@ el0_sp_pc:
 	 * Stack or PC alignment exception handling
 	 */
 	mrs	x26, far_el1
+	gic_prio_kentry_setup tmp=x0
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
@@ -877,6 +898,7 @@ el0_dbg:
 	 * Debug exception handling
 	 */
 	tbnz	x24, #0, el0_inv		// EL0 only
+	gic_prio_kentry_setup tmp=x3
 	mrs	x0, far_el1
 	mov	x1, x25
 	mov	x2, sp
@@ -898,7 +920,9 @@ ENDPROC(el0_sync)
 el0_irq:
 	kernel_entry 0
 el0_irq_naked:
+	gic_prio_irq_setup pmr=x20, tmp=x0
 	enable_da_f
+
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
 #endif
@@ -920,6 +944,7 @@ ENDPROC(el0_irq)
 el1_error:
 	kernel_entry 1
 	mrs	x1, esr_el1
+	gic_prio_kentry_setup tmp=x2
 	enable_dbg
 	mov	x0, sp
 	bl	do_serror
@@ -930,6 +955,7 @@ el0_error:
 	kernel_entry 0
 el0_error_naked:
 	mrs	x1, esr_el1
+	gic_prio_kentry_setup tmp=x2
 	enable_dbg
 	mov	x0, sp
 	bl	do_serror
@@ -954,6 +980,7 @@ work_pending:
  */
 ret_to_user:
 	disable_daif
+	gic_prio_kentry_setup tmp=x3
 	ldr	x1, [tsk, #TSK_TI_FLAGS]
 	and	x2, x1, #_TIF_WORK_MASK
 	cbnz	x2, work_pending
@@ -970,6 +997,7 @@ ENDPROC(ret_to_user)
  */
 	.align	6
 el0_svc:
+	gic_prio_kentry_setup tmp=x1
 	mov	x0, sp
 	bl	el0_svc_handler
 	b	ret_to_user
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -83,7 +83,7 @@ static void __cpu_do_idle_irqprio(void)
 	 * be raised.
 	 */
 	pmr = gic_read_pmr();
-	gic_write_pmr(GIC_PRIO_IRQON);
+	gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
 
 	__cpu_do_idle();
 
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -181,11 +181,13 @@ static void init_gic_priority_masking(vo
 
 	WARN_ON(!(cpuflags & PSR_I_BIT));
 
-	gic_write_pmr(GIC_PRIO_IRQOFF);
-
 	/* We can only unmask PSR.I if we can take aborts */
-	if (!(cpuflags & PSR_A_BIT))
+	if (!(cpuflags & PSR_A_BIT)) {
+		gic_write_pmr(GIC_PRIO_IRQOFF);
 		write_sysreg(cpuflags & ~PSR_I_BIT, daif);
+	} else {
+		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
+	}
 }
 
 /*
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -604,7 +604,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struc
 	 * Naturally, we want to avoid this.
 	 */
 	if (system_uses_irq_prio_masking()) {
-		gic_write_pmr(GIC_PRIO_IRQON);
+		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
 		dsb(sy);
 	}
 


