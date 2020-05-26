Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E871ACC0D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506843AbgDPPyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895586AbgDPNa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:30:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76DDB217D8;
        Thu, 16 Apr 2020 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043826;
        bh=6JXhCfInHA54YKntjpBtOWqLh6x4QkgVAoxkrTKKLlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqPs5S9rTPQIIaUrIGJ5R12hbqy+zFyUtbqN7wCS1Xh+nh9Zrmf7LEnFDy53OVWaQ
         /HzV11DaCrr/iOeN7Q5d/RbjLz/VVHc8cmX8jSB0uSy7MebZKUxcPqZS/g9tELV6Eg
         vkHwy4Bc3cisHvdFquGO3AgHQwSHg+cQ2r3vWyo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 079/146] KVM: nVMX: Properly handle userspace interrupt window request
Date:   Thu, 16 Apr 2020 15:23:40 +0200
Message-Id: <20200416131253.689478065@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit a1c77abb8d93381e25a8d2df3a917388244ba776 upstream.

Return true for vmx_interrupt_allowed() if the vCPU is in L2 and L1 has
external interrupt exiting enabled.  IRQs are never blocked in hardware
if the CPU is in the guest (L2 from L1's perspective) when IRQs trigger
VM-Exit.

The new check percolates up to kvm_vcpu_ready_for_interrupt_injection()
and thus vcpu_run(), and so KVM will exit to userspace if userspace has
requested an interrupt window (to inject an IRQ into L1).

Remove the @external_intr param from vmx_check_nested_events(), which is
actually an indicator that userspace wants an interrupt window, e.g.
it's named @req_int_win further up the stack.  Injecting a VM-Exit into
L1 to try and bounce out to L0 userspace is all kinds of broken and is
no longer necessary.

Remove the hack in nested_vmx_vmexit() that attempted to workaround the
breakage in vmx_check_nested_events() by only filling interrupt info if
there's an actual interrupt pending.  The hack actually made things
worse because it caused KVM to _never_ fill interrupt info when the
LAPIC resides in userspace (kvm_cpu_has_interrupt() queries
interrupt.injected, which is always cleared by prepare_vmcs12() before
reaching the hack in nested_vmx_vmexit()).

Fixes: 6550c4df7e50 ("KVM: nVMX: Fix interrupt window request with "Acknowledge interrupt on exit"")
Cc: stable@vger.kernel.org
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/vmx.c              |   27 +++++++++++----------------
 arch/x86/kvm/x86.c              |   10 +++++-----
 3 files changed, 17 insertions(+), 22 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1070,7 +1070,7 @@ struct kvm_x86_ops {
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
 
-	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
+	int (*check_nested_events)(struct kvm_vcpu *vcpu);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
 
 	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6954,8 +6954,13 @@ static int vmx_nmi_allowed(struct kvm_vc
 
 static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
-	return (!to_vmx(vcpu)->nested.nested_run_pending &&
-		vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
+	if (to_vmx(vcpu)->nested.nested_run_pending)
+		return false;
+
+	if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
+		return true;
+
+	return (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
 		!(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
 			(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 }
@@ -12990,7 +12995,7 @@ static void vmcs12_save_pending_event(st
 	}
 }
 
-static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
+static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qual;
@@ -13028,8 +13033,7 @@ static int vmx_check_nested_events(struc
 		return 0;
 	}
 
-	if ((kvm_cpu_has_interrupt(vcpu) || external_intr) &&
-	    nested_exit_on_intr(vcpu)) {
+	if (kvm_cpu_has_interrupt(vcpu) && nested_exit_on_intr(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
 		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
@@ -13607,17 +13611,8 @@ static void nested_vmx_vmexit(struct kvm
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	if (likely(!vmx->fail)) {
-		/*
-		 * TODO: SDM says that with acknowledge interrupt on
-		 * exit, bit 31 of the VM-exit interrupt information
-		 * (valid interrupt) is always set to 1 on
-		 * EXIT_REASON_EXTERNAL_INTERRUPT, so we shouldn't
-		 * need kvm_cpu_has_interrupt().  See the commit
-		 * message for details.
-		 */
-		if (nested_exit_intr_ack_set(vcpu) &&
-		    exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
-		    kvm_cpu_has_interrupt(vcpu)) {
+		if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
+		    nested_exit_intr_ack_set(vcpu)) {
 			int irq = kvm_cpu_get_interrupt(vcpu);
 			WARN_ON(irq < 0);
 			vmcs12->vm_exit_intr_info = irq |
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7124,7 +7124,7 @@ static void update_cr8_intercept(struct
 	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
-static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
+static int inject_pending_event(struct kvm_vcpu *vcpu)
 {
 	int r;
 
@@ -7160,7 +7160,7 @@ static int inject_pending_event(struct k
 	 * from L2 to L1.
 	 */
 	if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
-		r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
+		r = kvm_x86_ops->check_nested_events(vcpu);
 		if (r != 0)
 			return r;
 	}
@@ -7210,7 +7210,7 @@ static int inject_pending_event(struct k
 		 * KVM_REQ_EVENT only on certain events and not unconditionally?
 		 */
 		if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
-			r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
+			r = kvm_x86_ops->check_nested_events(vcpu);
 			if (r != 0)
 				return r;
 		}
@@ -7683,7 +7683,7 @@ static int vcpu_enter_guest(struct kvm_v
 			goto out;
 		}
 
-		if (inject_pending_event(vcpu, req_int_win) != 0)
+		if (inject_pending_event(vcpu) != 0)
 			req_immediate_exit = true;
 		else {
 			/* Enable SMI/NMI/IRQ window open exits if needed.
@@ -7894,7 +7894,7 @@ static inline int vcpu_block(struct kvm
 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events)
-		kvm_x86_ops->check_nested_events(vcpu, false);
+		kvm_x86_ops->check_nested_events(vcpu);
 
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);


