Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F6E25DAAC
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 15:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbgIDN4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 09:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730643AbgIDNz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:55:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B163D20829;
        Fri,  4 Sep 2020 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226208;
        bh=nPIkQCIpdQuilOuyc8TCuW2XR1An6Zqilkaa95FySd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLWBs8jEakRLmD1AELqP611UetpanlkQqCvPBugaSP7V5Xd6lIH5tSO3oNkxAp6+U
         SxshheQ06eTHuumijFP9ZssHQMg+GrnjeQNSVWutP0jL+VL9kpzv0DoeybAfK5PZIu
         naROiViFVnSz0+Gbx57XVKFH+bA1UQPe9XC5Kuxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 5.4 07/16] KVM: arm64: Survive synchronous exceptions caused by AT instructions
Date:   Fri,  4 Sep 2020 15:30:00 +0200
Message-Id: <20200904120257.560300344@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.203708503@linuxfoundation.org>
References: <20200904120257.203708503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 88a84ccccb3966bcc3f309cdb76092a9892c0260 upstream.

KVM doesn't expect any synchronous exceptions when executing, any such
exception leads to a panic(). AT instructions access the guest page
tables, and can cause a synchronous external abort to be taken.

The arm-arm is unclear on what should happen if the guest has configured
the hardware update of the access-flag, and a memory type in TCR_EL1 that
does not support atomic operations. B2.2.6 "Possible implementation
restrictions on using atomic instructions" from DDI0487F.a lists
synchronous external abort as a possible behaviour of atomic instructions
that target memory that isn't writeback cacheable, but the page table
walker may behave differently.

Make KVM robust to synchronous exceptions caused by AT instructions.
Add a get_user() style helper for AT instructions that returns -EFAULT
if an exception was generated.

While KVM's version of the exception table mixes synchronous and
asynchronous exceptions, only one of these can occur at each location.

Re-enter the guest when the AT instructions take an exception on the
assumption the guest will take the same exception. This isn't guaranteed
to make forward progress, as the AT instructions may always walk the page
tables, but guest execution may use the translation cached in the TLB.

This isn't a problem, as since commit 5dcd0fdbb492 ("KVM: arm64: Defer guest
entry when an asynchronous exception is pending"), KVM will return to the
host to process IRQs allowing the rest of the system to keep running.

Cc: stable@vger.kernel.org # <v5.3: 5dcd0fdbb492 ("KVM: arm64: Defer guest entry when an asynchronous exception is pending")
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_asm.h |   28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S   |   14 ++++++++++----
 arch/arm64/kvm/hyp/switch.c      |    8 ++++----
 3 files changed, 42 insertions(+), 8 deletions(-)

--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -88,6 +88,34 @@ extern u32 __kvm_get_mdcr_el2(void);
 		*__hyp_this_cpu_ptr(sym);				\
 	 })
 
+#define __KVM_EXTABLE(from, to)						\
+	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
+	"	.align		3\n"					\
+	"	.long		(" #from " - .), (" #to " - .)\n"	\
+	"	.popsection\n"
+
+
+#define __kvm_at(at_op, addr)						\
+( { 									\
+	int __kvm_at_err = 0;						\
+	u64 spsr, elr;							\
+	asm volatile(							\
+	"	mrs	%1, spsr_el2\n"					\
+	"	mrs	%2, elr_el2\n"					\
+	"1:	at	"at_op", %3\n"					\
+	"	isb\n"							\
+	"	b	9f\n"						\
+	"2:	msr	spsr_el2, %1\n"					\
+	"	msr	elr_el2, %2\n"					\
+	"	mov	%w0, %4\n"					\
+	"9:\n"								\
+	__KVM_EXTABLE(1b, 2b)						\
+	: "+r" (__kvm_at_err), "=&r" (spsr), "=&r" (elr)		\
+	: "r" (addr), "i" (-EFAULT));					\
+	__kvm_at_err;							\
+} )
+
+
 #else /* __ASSEMBLY__ */
 
 .macro hyp_adr_this_cpu reg, sym, tmp
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -166,13 +166,19 @@ el1_error:
 	b	__guest_exit
 
 el2_sync:
-	/* Check for illegal exception return, otherwise panic */
+	/* Check for illegal exception return */
 	mrs	x0, spsr_el2
+	tbnz	x0, #20, 1f
 
-	/* if this was something else, then panic! */
-	tst	x0, #PSR_IL_BIT
-	b.eq	__hyp_panic
+	save_caller_saved_regs_vect
+	stp     x29, x30, [sp, #-16]!
+	bl	kvm_unexpected_el2_exception
+	ldp     x29, x30, [sp], #16
+	restore_caller_saved_regs_vect
 
+	eret
+
+1:
 	/* Let's attempt a recovery from the illegal exception return */
 	get_vcpu_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_IL
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -261,10 +261,10 @@ static bool __hyp_text __translate_far_t
 	 * saved the guest context yet, and we may return early...
 	 */
 	par = read_sysreg(par_el1);
-	asm volatile("at s1e1r, %0" : : "r" (far));
-	isb();
-
-	tmp = read_sysreg(par_el1);
+	if (!__kvm_at("s1e1r", far))
+		tmp = read_sysreg(par_el1);
+	else
+		tmp = SYS_PAR_EL1_F; /* back to the guest */
 	write_sysreg(par, par_el1);
 
 	if (unlikely(tmp & SYS_PAR_EL1_F))


