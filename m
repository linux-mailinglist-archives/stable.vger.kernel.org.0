Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD39326616A
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgIKOnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbgIKNDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:03:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6757122286;
        Fri, 11 Sep 2020 12:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829065;
        bh=HEx7XSycJRXGxGtCHabvPFr3quqD8R7LQYqFgUzcnSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhT1vhfqPN4WCgQjVhQjz/KoLqcvQBhGh1z1E4E5roGurUSkvOgU11/08byv4BgQh
         Kdm4N2JaXrnxJ1j1M0zz+V9wDZGpEs6zEKYT8TS1t98wgniTFpFpiB/GfqxvW9nu7W
         uhE4D9QhJL+86aHyBByMj4nUpTxegmvnfyrxJ4FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 4.9 52/71] KVM: arm64: Add kvm_extable for vaxorcism code
Date:   Fri, 11 Sep 2020 14:46:36 +0200
Message-Id: <20200911122507.505484831@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
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

Cc: stable@vger.kernel.org # v4.9
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
@@ -106,6 +106,21 @@ extern u32 __init_stage2_translation(voi
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
@@ -23,6 +23,13 @@ ENTRY(_text)
 
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
@@ -38,6 +45,7 @@ jiffies = jiffies_64;
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
 
@@ -178,25 +202,14 @@ el1_error:
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
@@ -25,6 +25,10 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/uaccess.h>
+
+extern struct exception_table_entry __start___kvm_ex_table;
+extern struct exception_table_entry __stop___kvm_ex_table;
 
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
 {
@@ -454,3 +458,30 @@ void __hyp_text __noreturn hyp_panic(str
 
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


