Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED28258C05
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 11:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgIAJtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 05:49:52 -0400
Received: from foss.arm.com ([217.140.110.172]:39584 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgIAJtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 05:49:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B02BF1045;
        Tue,  1 Sep 2020 02:49:51 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6B743F71F;
        Tue,  1 Sep 2020 02:49:50 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH stable v5.4 1/3] KVM: arm64: Add kvm_extable for vaxoricism code
Date:   Tue,  1 Sep 2020 10:49:21 +0100
Message-Id: <20200901094923.52486-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901094923.52486-1-andre.przywara@arm.com>
References: <20200901094923.52486-1-andre.przywara@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit e9ee186bb735bfc17fa81dbc9aebf268aee5b41e upstream.

KVM has a one instruction window where it will allow an SError exception
to be consumed by the hypervisor without treating it as a hypervisor bug.
This is used to consume asynchronous external abort that were caused by
the guest.

As we are about to add another location that survives unexpected exceptions,
generalise this code to make it behave like the host's extable.

KVM's version has to be mapped to EL2 to be accessible on nVHE systems.

The SError vaxorcism code is a one instruction window, so has two entries
in the extable. Because the KVM code is copied for VHE and nVHE, we end up
with four entries, half of which correspond with code that isn't mapped.

Cc: <stable@vger.kernel.org> # 5.4.x
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h | 15 ++++++++++
 arch/arm64/kernel/vmlinux.lds.S  |  8 +++++
 arch/arm64/kvm/hyp/entry.S       | 15 ++++++----
 arch/arm64/kvm/hyp/hyp-entry.S   | 51 +++++++++++++++++++-------------
 arch/arm64/kvm/hyp/switch.c      | 31 +++++++++++++++++++
 5 files changed, 94 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 44a243754c1b..d929b4c4df1f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -113,6 +113,21 @@ extern u32 __kvm_get_mdcr_el2(void);
 	kern_hyp_va	\vcpu
 .endm
 
+/*
+ * KVM extable for unexpected exceptions.
+ * In the same format _asm_extable, but output to a different section so that
+ * it can be mapped to EL2. The KVM version is not sorted. The caller must
+ * ensure:
+ * x18 has the hypervisor value to allow any Shadow-Call-Stack instrumented
+ * code to write to it, and that SPSR_EL2 and ELR_EL2 are restored by the fixup.
+ */
+.macro	_kvm_extable, from, to
+	.pushsection	__kvm_ex_table, "a"
+	.align		3
+	.long		(\from - .), (\to - .)
+	.popsection
+.endm
+
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 8d0374ffdd2d..4f77de8ce138 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -24,6 +24,13 @@ ENTRY(_text)
 
 jiffies = jiffies_64;
 
+
+#define HYPERVISOR_EXTABLE					\
+	. = ALIGN(SZ_8);					\
+	__start___kvm_ex_table = .;				\
+	*(__kvm_ex_table)					\
+	__stop___kvm_ex_table = .;
+
 #define HYPERVISOR_TEXT					\
 	/*						\
 	 * Align to 4 KB so that			\
@@ -39,6 +46,7 @@ jiffies = jiffies_64;
 	__hyp_idmap_text_end = .;			\
 	__hyp_text_start = .;				\
 	*(.hyp.text)					\
+	HYPERVISOR_EXTABLE				\
 	__hyp_text_end = .;
 
 #define IDMAP_TEXT					\
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index e5cc8d66bf53..dc3d7bc2292f 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -173,20 +173,23 @@ alternative_endif
 	// This is our single instruction exception window. A pending
 	// SError is guaranteed to occur at the earliest when we unmask
 	// it, and at the latest just after the ISB.
-	.global	abort_guest_exit_start
 abort_guest_exit_start:
 
 	isb
 
-	.global	abort_guest_exit_end
 abort_guest_exit_end:
 
 	msr	daifset, #4	// Mask aborts
+	ret
+
+	_kvm_extable	abort_guest_exit_start, 9997f
+	_kvm_extable	abort_guest_exit_end, 9997f
+9997:
+	msr	daifset, #4	// Mask aborts
+	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 
-	// If the exception took place, restore the EL1 exception
-	// context so that we can report some information.
-	// Merge the exception code with the SError pending bit.
-	tbz	x0, #ARM_EXIT_WITH_SERROR_BIT, 1f
+	// restore the EL1 exception context so that we can report some
+	// information. Merge the exception code with the SError pending bit.
 	msr	elr_el2, x2
 	msr	esr_el2, x3
 	msr	spsr_el2, x4
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index ffa68d5713f1..c8cdadb38719 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -15,6 +15,30 @@
 #include <asm/kvm_mmu.h>
 #include <asm/mmu.h>
 
+.macro save_caller_saved_regs_vect
+	/* x0 and x1 were saved in the vector entry */
+	stp	x2, x3,   [sp, #-16]!
+	stp	x4, x5,   [sp, #-16]!
+	stp	x6, x7,   [sp, #-16]!
+	stp	x8, x9,   [sp, #-16]!
+	stp	x10, x11, [sp, #-16]!
+	stp	x12, x13, [sp, #-16]!
+	stp	x14, x15, [sp, #-16]!
+	stp	x16, x17, [sp, #-16]!
+.endm
+
+.macro restore_caller_saved_regs_vect
+	ldp	x16, x17, [sp], #16
+	ldp	x14, x15, [sp], #16
+	ldp	x12, x13, [sp], #16
+	ldp	x10, x11, [sp], #16
+	ldp	x8, x9,   [sp], #16
+	ldp	x6, x7,   [sp], #16
+	ldp	x4, x5,   [sp], #16
+	ldp	x2, x3,   [sp], #16
+	ldp	x0, x1,   [sp], #16
+.endm
+
 	.text
 	.pushsection	.hyp.text, "ax"
 
@@ -156,27 +180,14 @@ el2_sync:
 
 
 el2_error:
-	ldp	x0, x1, [sp], #16
+	save_caller_saved_regs_vect
+	stp     x29, x30, [sp, #-16]!
+
+	bl	kvm_unexpected_el2_exception
+
+	ldp     x29, x30, [sp], #16
+	restore_caller_saved_regs_vect
 
-	/*
-	 * Only two possibilities:
-	 * 1) Either we come from the exit path, having just unmasked
-	 *    PSTATE.A: change the return code to an EL2 fault, and
-	 *    carry on, as we're already in a sane state to handle it.
-	 * 2) Or we come from anywhere else, and that's a bug: we panic.
-	 *
-	 * For (1), x0 contains the original return code and x1 doesn't
-	 * contain anything meaningful at that stage. We can reuse them
-	 * as temp registers.
-	 * For (2), who cares?
-	 */
-	mrs	x0, elr_el2
-	adr	x1, abort_guest_exit_start
-	cmp	x0, x1
-	adr	x1, abort_guest_exit_end
-	ccmp	x0, x1, #4, ne
-	b.ne	__hyp_panic
-	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
 	sb
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d76a3d39b269..ecfbd7d29d6b 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -14,6 +14,7 @@
 
 #include <asm/arch_gicv3.h>
 #include <asm/cpufeature.h>
+#include <asm/extable.h>
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -25,6 +26,9 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
+extern struct exception_table_entry __start___kvm_ex_table;
+extern struct exception_table_entry __stop___kvm_ex_table;
+
 /* Check whether the FP regs were dirtied while in the host-side run loop: */
 static bool __hyp_text update_fp_enabled(struct kvm_vcpu *vcpu)
 {
@@ -791,3 +795,30 @@ void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
 
 	unreachable();
 }
+
+asmlinkage void __hyp_text kvm_unexpected_el2_exception(void)
+{
+	unsigned long addr, fixup;
+	struct kvm_cpu_context *host_ctxt;
+	struct exception_table_entry *entry, *end;
+	unsigned long elr_el2 = read_sysreg(elr_el2);
+
+	entry = hyp_symbol_addr(__start___kvm_ex_table);
+	end = hyp_symbol_addr(__stop___kvm_ex_table);
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+
+	while (entry < end) {
+		addr = (unsigned long)&entry->insn + entry->insn;
+		fixup = (unsigned long)&entry->fixup + entry->fixup;
+
+		if (addr != elr_el2) {
+			entry++;
+			continue;
+		}
+
+		write_sysreg(fixup, elr_el2);
+		return;
+	}
+
+	hyp_panic(host_ctxt);
+}
-- 
2.17.1

