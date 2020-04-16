Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BBE1ACADF
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395393AbgDPPkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897482AbgDPNhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:37:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE93D21BE5;
        Thu, 16 Apr 2020 13:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044254;
        bh=JF2OLf0h1q2oa0DCJdkNYASXC1znLkDnKr0VR0oU0w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUM8/Ozy84d5W3FXeixvH2rCBrdo/eHI4TGHjugB6LUDtLUc0jmUALQ3m5NE7ggwa
         TDpr9Rif1rVYvJtdvV5lQy4tUNH0GCtm8uYEn99zsN1mhx8+xREXRc3QxHfQMTnsWj
         s4geZICAFdAoono2RM5WyPptuvrhsDyY/G0v3nsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 143/257] KVM: nVMX: Properly handle userspace interrupt window request
Date:   Thu, 16 Apr 2020 15:23:14 +0200
Message-Id: <20200416131344.298948472@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
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
 arch/x86/kvm/vmx/nested.c       |   18 ++++--------------
 arch/x86/kvm/vmx/vmx.c          |    9 +++++++--
 arch/x86/kvm/x86.c              |   10 +++++-----
 4 files changed, 17 insertions(+), 22 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1147,7 +1147,7 @@ struct kvm_x86_ops {
 	bool (*pt_supported)(void);
 	bool (*pku_supported)(void);
 
-	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
+	int (*check_nested_events)(struct kvm_vcpu *vcpu);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
 
 	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3611,7 +3611,7 @@ static void nested_vmx_update_pending_db
 			    vcpu->arch.exception.payload);
 }
 
-static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
+static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qual;
@@ -3660,8 +3660,7 @@ static int vmx_check_nested_events(struc
 		return 0;
 	}
 
-	if ((kvm_cpu_has_interrupt(vcpu) || external_intr) &&
-	    nested_exit_on_intr(vcpu)) {
+	if (kvm_cpu_has_interrupt(vcpu) && nested_exit_on_intr(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
 		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
@@ -4309,17 +4308,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *
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
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4485,8 +4485,13 @@ static int vmx_nmi_allowed(struct kvm_vc
 
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
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7572,7 +7572,7 @@ static void update_cr8_intercept(struct
 	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
-static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
+static int inject_pending_event(struct kvm_vcpu *vcpu)
 {
 	int r;
 
@@ -7608,7 +7608,7 @@ static int inject_pending_event(struct k
 	 * from L2 to L1.
 	 */
 	if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
-		r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
+		r = kvm_x86_ops->check_nested_events(vcpu);
 		if (r != 0)
 			return r;
 	}
@@ -7670,7 +7670,7 @@ static int inject_pending_event(struct k
 		 * KVM_REQ_EVENT only on certain events and not unconditionally?
 		 */
 		if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
-			r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
+			r = kvm_x86_ops->check_nested_events(vcpu);
 			if (r != 0)
 				return r;
 		}
@@ -8159,7 +8159,7 @@ static int vcpu_enter_guest(struct kvm_v
 			goto out;
 		}
 
-		if (inject_pending_event(vcpu, req_int_win) != 0)
+		if (inject_pending_event(vcpu) != 0)
 			req_immediate_exit = true;
 		else {
 			/* Enable SMI/NMI/IRQ window open exits if needed.
@@ -8389,7 +8389,7 @@ static inline int vcpu_block(struct kvm
 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events)
-		kvm_x86_ops->check_nested_events(vcpu, false);
+		kvm_x86_ops->check_nested_events(vcpu);
 
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);


