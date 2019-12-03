Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A633A111E56
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfLCXBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:01:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730434AbfLCW4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:56:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C010B2053B;
        Tue,  3 Dec 2019 22:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413793;
        bh=barriEnN79nc636JHO7xJvfDAXAGP7Bhix11BrYC94U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEB7vdhzZe6nH8eoq+HiLrjYnH5XKy/6QOC2vwdbgamw6495O/MuBam0x9aQv6Rze
         9FwDCpFZlfuyAegTd2qZ2MBm2RfcuOPH76Lb1+I1btRoKwnsoGWqFKzMfwplAD7Hc1
         ubNt8A9fEfs6kR3XktDMHGpdszzGFe2Ho36TPMkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jack Wang <jack.wang.usish@gmail.com>
Subject: [PATCH 4.19 265/321] KVM: nVMX: assimilate nested_vmx_entry_failure() into nested_vmx_enter_non_root_mode()
Date:   Tue,  3 Dec 2019 23:35:31 +0100
Message-Id: <20191203223440.913364313@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit a633e41e736279c6d3174f52deeb9b8b5fa85e13 upstream.

Handling all VMExits due to failed consistency checks on VMEnter in
nested_vmx_enter_non_root_mode() consolidates all relevant code into
a single location, and removing nested_vmx_entry_failure() eliminates
a confusing function name and label.  For a VMEntry, "fail" and its
derivatives has a very specific meaning due to the different behavior
of a VMEnter VMFail versus VMExit, i.e. it wasn't obvious that
nested_vmx_entry_failure() handled VMExit scenarios.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jack Wang <jack.wang.usish@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |   78 ++++++++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 42 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2065,9 +2065,6 @@ static inline bool is_nmi(u32 intr_info)
 static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 			      u32 exit_intr_info,
 			      unsigned long exit_qualification);
-static void nested_vmx_entry_failure(struct kvm_vcpu *vcpu,
-			struct vmcs12 *vmcs12,
-			u32 reason, unsigned long qualification);
 
 static int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
 {
@@ -12676,26 +12673,29 @@ static int check_vmentry_postreqs(struct
 	return 0;
 }
 
+static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
+				   struct vmcs12 *vmcs12);
+
 /*
- * If exit_qual is NULL, this is being called from state restore (either RSM
+ * If from_vmentry is false, this is being called from state restore (either RSM
  * or KVM_SET_NESTED_STATE).  Otherwise it's called from vmlaunch/vmresume.
  */
-static int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, u32 *exit_qual)
+static int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
+					  bool from_vmentry)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	bool from_vmentry = !!exit_qual;
-	u32 dummy_exit_qual;
 	bool evaluate_pending_interrupts;
-	int r = 0;
+	u32 exit_reason = EXIT_REASON_INVALID_STATE;
+	u32 exit_qual;
 
 	evaluate_pending_interrupts = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL) &
 		(CPU_BASED_VIRTUAL_INTR_PENDING | CPU_BASED_VIRTUAL_NMI_PENDING);
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
 
-	if (from_vmentry && check_vmentry_postreqs(vcpu, vmcs12, exit_qual))
-		return EXIT_REASON_INVALID_STATE;
+	if (from_vmentry && check_vmentry_postreqs(vcpu, vmcs12, &exit_qual))
+		goto vmentry_fail_vmexit;
 
 	enter_guest_mode(vcpu);
 
@@ -12710,18 +12710,17 @@ static int nested_vmx_enter_non_root_mod
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETING)
 		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
 
-	r = EXIT_REASON_INVALID_STATE;
-	if (prepare_vmcs02(vcpu, vmcs12, from_vmentry ? exit_qual : &dummy_exit_qual))
+	if (prepare_vmcs02(vcpu, vmcs12, &exit_qual))
 		goto fail;
 
 	if (from_vmentry) {
 		nested_get_vmcs12_pages(vcpu);
 
-		r = EXIT_REASON_MSR_LOAD_FAIL;
-		*exit_qual = nested_vmx_load_msr(vcpu,
-	     					 vmcs12->vm_entry_msr_load_addr,
-					      	 vmcs12->vm_entry_msr_load_count);
-		if (*exit_qual)
+		exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
+		exit_qual = nested_vmx_load_msr(vcpu,
+						vmcs12->vm_entry_msr_load_addr,
+						vmcs12->vm_entry_msr_load_count);
+		if (exit_qual)
 			goto fail;
 	} else {
 		/*
@@ -12759,12 +12758,28 @@ static int nested_vmx_enter_non_root_mod
 	 */
 	return 0;
 
+	/*
+	 * A failed consistency check that leads to a VMExit during L1's
+	 * VMEnter to L2 is a variation of a normal VMexit, as explained in
+	 * 26.7 "VM-entry failures during or after loading guest state".
+	 */
 fail:
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETING)
 		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
 	leave_guest_mode(vcpu);
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-	return r;
+
+	if (!from_vmentry)
+		return 1;
+
+vmentry_fail_vmexit:
+	load_vmcs12_host_state(vcpu, vmcs12);
+	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
+	vmcs12->exit_qualification = exit_qual;
+	nested_vmx_succeed(vcpu);
+	if (enable_shadow_vmcs)
+		vmx->nested.sync_shadow_vmcs = true;
+	return 1;
 }
 
 /*
@@ -12776,7 +12791,6 @@ static int nested_vmx_run(struct kvm_vcp
 	struct vmcs12 *vmcs12;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
-	u32 exit_qual;
 	int ret;
 
 	if (!nested_vmx_check_permission(vcpu))
@@ -12845,9 +12859,8 @@ static int nested_vmx_run(struct kvm_vcp
 	 */
 
 	vmx->nested.nested_run_pending = 1;
-	ret = nested_vmx_enter_non_root_mode(vcpu, &exit_qual);
+	ret = nested_vmx_enter_non_root_mode(vcpu, true);
 	if (ret) {
-		nested_vmx_entry_failure(vcpu, vmcs12, ret, exit_qual);
 		vmx->nested.nested_run_pending = 0;
 		return 1;
 	}
@@ -13647,25 +13660,6 @@ static void vmx_leave_nested(struct kvm_
 	free_nested(to_vmx(vcpu));
 }
 
-/*
- * L1's failure to enter L2 is a subset of a normal exit, as explained in
- * 23.7 "VM-entry failures during or after loading guest state" (this also
- * lists the acceptable exit-reason and exit-qualification parameters).
- * It should only be called before L2 actually succeeded to run, and when
- * vmcs01 is current (it doesn't leave_guest_mode() or switch vmcss).
- */
-static void nested_vmx_entry_failure(struct kvm_vcpu *vcpu,
-			struct vmcs12 *vmcs12,
-			u32 reason, unsigned long qualification)
-{
-	load_vmcs12_host_state(vcpu, vmcs12);
-	vmcs12->vm_exit_reason = reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
-	vmcs12->exit_qualification = qualification;
-	nested_vmx_succeed(vcpu);
-	if (enable_shadow_vmcs)
-		to_vmx(vcpu)->nested.sync_shadow_vmcs = true;
-}
-
 static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage)
@@ -14089,7 +14083,7 @@ static int vmx_pre_leave_smm(struct kvm_
 
 	if (vmx->nested.smm.guest_mode) {
 		vcpu->arch.hflags &= ~HF_SMM_MASK;
-		ret = nested_vmx_enter_non_root_mode(vcpu, NULL);
+		ret = nested_vmx_enter_non_root_mode(vcpu, false);
 		vcpu->arch.hflags |= HF_SMM_MASK;
 		if (ret)
 			return ret;
@@ -14300,7 +14294,7 @@ static int vmx_set_nested_state(struct k
 		return -EINVAL;
 
 	vmx->nested.dirty_vmcs12 = true;
-	ret = nested_vmx_enter_non_root_mode(vcpu, NULL);
+	ret = nested_vmx_enter_non_root_mode(vcpu, false);
 	if (ret)
 		return -EINVAL;
 


