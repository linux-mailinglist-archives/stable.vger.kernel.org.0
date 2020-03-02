Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0101763F2
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 20:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgCBT3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 14:29:55 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:45965 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727487AbgCBT3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 14:29:55 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 3BCDA4E2;
        Mon,  2 Mar 2020 14:29:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 02 Mar 2020 14:29:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bdKkGp
        I7eIFKGXPiUcI2Xw3V4jPKPnHkDFS4Jg8Z9vs=; b=saXUX827a3For1Q0kpii1I
        RzSTF/gqk9bHaEVU5E3ELMp5cDF4DWij/wbx3jpsMWLDPbFU6SIWsTfhGBiGdABp
        OtQFC0Jskb2YaMrdRN2Z3o7mxXwNq4R0MbhTFdKO+SBvJOzSMaG/7ZNWhYAqFdsu
        e4Fl4sis3Ldk+CGOoZ926o3623+9CvTBOEdeGhL1zr0Fzr4GMHD+JJXu7zfEYJaR
        3UAXi32t18Vi+T72nTuWN9iQuyRwMH14+hukczvEqQI7kvPej21oKUezMhqMA7Xr
        vk1VpOoa84pl9zZSpvZJuaQKwLyEV/ACSzZVvop6hkUArMfrzWI2AvKv1pJHpGkQ
        ==
X-ME-Sender: <xms:r15dXhD0w8Ebl4jN45r7jlkEbA368CmZubLCktuNR1LSIyWuZqu82Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtgedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepvgigtggvphhtihhonhdrnhhrnecukfhppeekfedrkeeird
    ekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:r15dXrZvl9SCAyLSHeB9i6QQOFFLr3kJ_3f68DTKrHJl4dliLEGmEQ>
    <xmx:r15dXtSRxjFrcneKhUXOlT13RQs-NGBi4_fmmCDZv38OHbkTcRkGoA>
    <xmx:r15dXm_CKWQzcn8Hwt3-ERpIlbyhdMUQVdA62-EAG9UdEr2JqYii9g>
    <xmx:r15dXpCWzuwoTe4OjiI6v7kWqx2yMIGNBv8IhaVWkpf0INp9sWkPhg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 60E093060D1A;
        Mon,  2 Mar 2020 14:29:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Emulate MTF when performing instruction emulation" failed to apply to 5.4-stable tree
To:     oupton@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Mar 2020 20:29:47 +0100
Message-ID: <1583177387161107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5ef8acbdd687c9d72582e2c05c0b9756efb37863 Mon Sep 17 00:00:00 2001
From: Oliver Upton <oupton@google.com>
Date: Fri, 7 Feb 2020 02:36:07 -0800
Subject: [PATCH] KVM: nVMX: Emulate MTF when performing instruction emulation

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

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a84e8c5acda8..98959e8cd448 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1122,6 +1122,7 @@ struct kvm_x86_ops {
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	void (*update_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 503d3f42da16..3f3f780c8c65 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -390,6 +390,7 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
+#define KVM_STATE_NESTED_MTF_PENDING	0x00000008
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d9b5add5a211..ad3f5b178a03 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7439,6 +7439,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.update_emulated_instruction = NULL,
 	.set_interrupt_shadow = svm_set_interrupt_shadow,
 	.get_interrupt_shadow = svm_get_interrupt_shadow,
 	.patch_hypercall = svm_patch_hypercall,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2b3ba7d27be4..50d8dbb3616d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3609,8 +3609,15 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
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
@@ -3621,8 +3628,28 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
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
@@ -5712,6 +5739,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 
 			if (vmx->nested.nested_run_pending)
 				kvm_state.flags |= KVM_STATE_NESTED_RUN_PENDING;
+
+			if (vmx->nested.mtf_pending)
+				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
 		}
 	}
 
@@ -5892,6 +5922,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	vmx->nested.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
 
+	vmx->nested.mtf_pending =
+		!!(kvm_state->flags & KVM_STATE_NESTED_MTF_PENDING);
+
 	ret = -EINVAL;
 	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
 	    vmcs12->vmcs_link_pointer != -1ull) {
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 1c5fbff45d69..1db388f2a444 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -174,6 +174,11 @@ static inline bool nested_cpu_has_virtual_nmis(struct vmcs12 *vmcs12)
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 404dafedd778..dcca514ffd42 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1603,6 +1603,40 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
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
@@ -7796,7 +7830,8 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
-	.skip_emulated_instruction = skip_emulated_instruction,
+	.skip_emulated_instruction = vmx_skip_emulated_instruction,
+	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
 	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7f42cf3dcd70..e64da06c7009 100644
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb5d64ebc35d..359fcd395132 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6891,6 +6891,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			kvm_rip_write(vcpu, ctxt->eip);
 			if (r && ctxt->tf)
 				r = kvm_vcpu_do_singlestep(vcpu);
+			if (kvm_x86_ops->update_emulated_instruction)
+				kvm_x86_ops->update_emulated_instruction(vcpu);
 			__kvm_set_rflags(vcpu, ctxt->eflags);
 		}
 

