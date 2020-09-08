Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A08E261824
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731810AbgIHRtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731613AbgIHQN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:13:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99F22248F1;
        Tue,  8 Sep 2020 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580391;
        bh=DSHNCY6AGJI7hm+OVkjHcXqm9RlSQaINL3epwKx1aiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEbOVx/eDZfmTxEd3K8tnndP83aSfjEhrkTBDTowHyhZmkrFeF6rHnAlbLp3Ez946
         jWVK+PLCt5y7WoU2AJKPtHSuR4fcWonLoQ32b9TZ6Uzu/b0eU7A4Xst/0V1UEdqL0z
         Fh9viBxWt34G4bZd1l6vGCikStsT/RRerQQxZi+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 4.14 58/65] KVM: arm64: Add kvm_extable for vaxorcism code
Date:   Tue,  8 Sep 2020 17:26:43 +0200
Message-Id: <20200908152220.085736401@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

Cc: stable@vger.kernel.org # v4.14
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_asm.h |   15 +++++++++++
 arch/arm64/kernel/vmlinux.lds.S  |    8 ++++++
 arch/arm64/kvm/hyp/entry.S       |   16 +++++++-----
 arch/arm64/kvm/hyp/hyp-entry.S   |   51 ++++++++++++++++++++++++---------------
 arch/arm64/kvm/hyp/switch.c      |   31 +++++++++++++++++++++++
 5 files changed, 96 insertions(+), 25 deletions(-)

--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -107,6 +107,21 @@ extern u32 __init_stage2_translation(voi
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
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -24,6 +24,13 @@ ENTRY(_text)
 
 jiffies = jiffies_64;
 
+
+#define HYPERVISOR_EXTABLE					\
+	. = ALIGN(SZ_8);					\
+	VMLINUX_SYMBOL(__start___kvm_ex_table) = .;		\
+	*(__kvm_ex_table)					\
+	VMLINUX_SYMBOL(__stop___kvm_ex_table) = .;
+
 #define HYPERVISOR_TEXT					\
 	/*						\
 	 * Align to 4 KB so that			\
@@ -39,6 +46,7 @@ jiffies = jiffies_64;
 	VMLINUX_SYMBOL(__hyp_idmap_text_end) = .;	\
 	VMLINUX_SYMBOL(__hyp_text_start) = .;		\
 	*(.hyp.text)					\
+	HYPERVISOR_EXTABLE				\
 	VMLINUX_SYMBOL(__hyp_text_end) = .;
 
 #define IDMAP_TEXT					\
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -135,18 +135,22 @@ ENTRY(__guest_exit)
 	// This is our single instruction exception window. A pending
 	// SError is guaranteed to occur at the earliest when we unmask
 	// it, and at the latest just after the ISB.
-	.global	abort_guest_exit_start
 abort_guest_exit_start:
 
 	isb
 
-	.global	abort_guest_exit_end
 abort_guest_exit_end:
+	msr	daifset, #4	// Mask aborts
+	ret
 
-	// If the exception took place, restore the EL1 exception
-	// context so that we can report some information.
-	// Merge the exception code with the SError pending bit.
-	tbz	x0, #ARM_EXIT_WITH_SERROR_BIT, 1f
+	_kvm_extable	abort_guest_exit_start, 9997f
+	_kvm_extable	abort_guest_exit_end, 9997f
+9997:
+	msr	daifset, #4	// Mask aborts
+	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
+
+	// restore the EL1 exception context so that we can report some
+	// information. Merge the exception code with the SError pending bit.
 	msr	elr_el2, x2
 	msr	esr_el2, x3
 	msr	spsr_el2, x4
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -25,6 +25,30 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 
+.macro save_caller_saved_regs_vect
+	stp	x0, x1,   [sp, #-16]!
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
 
@@ -184,25 +208,14 @@ el1_error:
 	b	__guest_exit
 
 el2_error:
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
+	save_caller_saved_regs_vect
+	stp     x29, x30, [sp, #-16]!
+
+	bl	kvm_unexpected_el2_exception
+
+	ldp     x29, x30, [sp], #16
+	restore_caller_saved_regs_vect
+
 	eret
 
 ENTRY(__hyp_do_panic)
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -22,11 +22,15 @@
 
 #include <kvm/arm_psci.h>
 
+#include <asm/extable.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/fpsimd.h>
 
+extern struct exception_table_entry __start___kvm_ex_table;
+extern struct exception_table_entry __stop___kvm_ex_table;
+
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
 {
 	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
@@ -486,3 +490,30 @@ void __hyp_text __noreturn hyp_panic(str
 
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
+	host_ctxt = __hyp_this_cpu_ptr(kvm_host_cpu_state);
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


