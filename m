Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6240C177F2B
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbgCCRtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731713AbgCCRtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:49:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6982E208C3;
        Tue,  3 Mar 2020 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257739;
        bh=YIC7c+u/A8EvFUDCrBMMc4U6UtsLOGJl6IyDgHldXjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1SA5FQ3l7b24RZceD49fYGPpgBE2XWnbcA5TbwubV74gzPJ+mBKI2DFIXvmQTGIn
         keZLHJCCuQkxPBymdcYpDalMi53xSGGm5dhS04Miz8j+JscaEW9K6nZpFTbtEpZ2v2
         D0qHCy6HPn/XFw2kE9/9v5ySsLzmxuovce+oLErU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 111/176] KVM: nVMX: Emulate MTF when performing instruction emulation
Date:   Tue,  3 Mar 2020 18:42:55 +0100
Message-Id: <20200303174317.670749078@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

commit 5ef8acbdd687c9d72582e2c05c0b9756efb37863 upstream.

Since commit 5f3d45e7f282 ("kvm/x86: add support for
MONITOR_TRAP_FLAG"), KVM has allowed an L1 guest to use the monitor trap
flag processor-based execution control for its L2 guest. KVM simply
forwards any MTF VM-exits to the L1 guest, which works for normal
instruction execution.

However, when KVM needs to emulate an instruction on the behalf of an L2
guest, the monitor trap flag is not emulated. Add the necessary logic to
kvm_skip_emulated_instruction() to synthesize an MTF VM-exit to L1 upon
instruction emulation for L2.

Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/include/uapi/asm/kvm.h |    1 +
 arch/x86/kvm/svm.c              |    1 +
 arch/x86/kvm/vmx/nested.c       |   35 ++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/nested.h       |    5 +++++
 arch/x86/kvm/vmx/vmx.c          |   37 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |    3 +++
 arch/x86/kvm/x86.c              |    2 ++
 8 files changed, 83 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1092,6 +1092,7 @@ struct kvm_x86_ops {
 	void (*run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	void (*update_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -390,6 +390,7 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
+#define KVM_STATE_NESTED_MTF_PENDING	0x00000008
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7311,6 +7311,7 @@ static struct kvm_x86_ops svm_x86_ops __
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.update_emulated_instruction = NULL,
 	.set_interrupt_shadow = svm_set_interrupt_shadow,
 	.get_interrupt_shadow = svm_get_interrupt_shadow,
 	.patch_hypercall = svm_patch_hypercall,
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3616,8 +3616,15 @@ static int vmx_check_nested_events(struc
 	unsigned long exit_qual;
 	bool block_nested_events =
 	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
+	bool mtf_pending = vmx->nested.mtf_pending;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
+	/*
+	 * Clear the MTF state. If a higher priority VM-exit is delivered first,
+	 * this state is discarded.
+	 */
+	vmx->nested.mtf_pending = false;
+
 	if (lapic_in_kernel(vcpu) &&
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		if (block_nested_events)
@@ -3628,8 +3635,28 @@ static int vmx_check_nested_events(struc
 		return 0;
 	}
 
+	/*
+	 * Process any exceptions that are not debug traps before MTF.
+	 */
+	if (vcpu->arch.exception.pending &&
+	    !vmx_pending_dbg_trap(vcpu) &&
+	    nested_vmx_check_exception(vcpu, &exit_qual)) {
+		if (block_nested_events)
+			return -EBUSY;
+		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
+		return 0;
+	}
+
+	if (mtf_pending) {
+		if (block_nested_events)
+			return -EBUSY;
+		nested_vmx_update_pending_dbg(vcpu);
+		nested_vmx_vmexit(vcpu, EXIT_REASON_MONITOR_TRAP_FLAG, 0, 0);
+		return 0;
+	}
+
 	if (vcpu->arch.exception.pending &&
-		nested_vmx_check_exception(vcpu, &exit_qual)) {
+	    nested_vmx_check_exception(vcpu, &exit_qual)) {
 		if (block_nested_events)
 			return -EBUSY;
 		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
@@ -5742,6 +5769,9 @@ static int vmx_get_nested_state(struct k
 
 			if (vmx->nested.nested_run_pending)
 				kvm_state.flags |= KVM_STATE_NESTED_RUN_PENDING;
+
+			if (vmx->nested.mtf_pending)
+				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
 		}
 	}
 
@@ -5922,6 +5952,9 @@ static int vmx_set_nested_state(struct k
 	vmx->nested.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
 
+	vmx->nested.mtf_pending =
+		!!(kvm_state->flags & KVM_STATE_NESTED_MTF_PENDING);
+
 	ret = -EINVAL;
 	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
 	    vmcs12->vmcs_link_pointer != -1ull) {
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -176,6 +176,11 @@ static inline bool nested_cpu_has_virtua
 	return vmcs12->pin_based_vm_exec_control & PIN_BASED_VIRTUAL_NMIS;
 }
 
+static inline int nested_cpu_has_mtf(struct vmcs12 *vmcs12)
+{
+	return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_TRAP_FLAG);
+}
+
 static inline int nested_cpu_has_ept(struct vmcs12 *vmcs12)
 {
 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_EPT);
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1595,6 +1595,40 @@ static int skip_emulated_instruction(str
 	return 1;
 }
 
+
+/*
+ * Recognizes a pending MTF VM-exit and records the nested state for later
+ * delivery.
+ */
+static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (!is_guest_mode(vcpu))
+		return;
+
+	/*
+	 * Per the SDM, MTF takes priority over debug-trap exceptions besides
+	 * T-bit traps. As instruction emulation is completed (i.e. at the
+	 * instruction boundary), any #DB exception pending delivery must be a
+	 * debug-trap. Record the pending MTF state to be delivered in
+	 * vmx_check_nested_events().
+	 */
+	if (nested_cpu_has_mtf(vmcs12) &&
+	    (!vcpu->arch.exception.pending ||
+	     vcpu->arch.exception.nr == DB_VECTOR))
+		vmx->nested.mtf_pending = true;
+	else
+		vmx->nested.mtf_pending = false;
+}
+
+static int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
+{
+	vmx_update_emulated_instruction(vcpu);
+	return skip_emulated_instruction(vcpu);
+}
+
 static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -7886,7 +7920,8 @@ static struct kvm_x86_ops vmx_x86_ops __
 
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
-	.skip_emulated_instruction = skip_emulated_instruction,
+	.skip_emulated_instruction = vmx_skip_emulated_instruction,
+	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
 	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -150,6 +150,9 @@ struct nested_vmx {
 	/* L2 must run next, and mustn't decide to exit to L1. */
 	bool nested_run_pending;
 
+	/* Pending MTF VM-exit into L1.  */
+	bool mtf_pending;
+
 	struct loaded_vmcs vmcs02;
 
 	/*
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6838,6 +6838,8 @@ restart:
 			kvm_rip_write(vcpu, ctxt->eip);
 			if (r && ctxt->tf)
 				r = kvm_vcpu_do_singlestep(vcpu);
+			if (kvm_x86_ops->update_emulated_instruction)
+				kvm_x86_ops->update_emulated_instruction(vcpu);
 			__kvm_set_rflags(vcpu, ctxt->eflags);
 		}
 


