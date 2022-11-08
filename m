Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1A46213A2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbiKHNwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234674AbiKHNwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:52:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8621562383
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:52:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9244615A2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7C1C433C1;
        Tue,  8 Nov 2022 13:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915524;
        bh=6xaAmRgLxiRyNIq34czyt6GYCwULg6GzyHFS+UfW0Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2Kc7vtPvQ0ve2XrcI2m+2jkg2qC4INgBfo7yS1cU2XrtT6MpzAUWddF2ThPXa0xN
         KOD9kVrtLRc7WwkLv3XPUTSN/aADQmY4WjYm2H0LktWlhyB4FaP/SltqPIPTStxjnD
         wZ4hELPck4hNfuloUOYLloyQO9koLqr4mbB1rkko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Guang <guang.zeng@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/118] KVM: nVMX: Pull KVM L0s desired controls directly from vmcs01
Date:   Tue,  8 Nov 2022 14:38:01 +0100
Message-Id: <20221108133340.853387797@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 389ab25216c9d09e0d335e764eeeb84c2089614f ]

When preparing controls for vmcs02, grab KVM's desired controls from
vmcs01's shadow state instead of recalculating the controls from scratch,
or in the secondary execution controls, instead of using the dedicated
cache.  Calculating secondary exec controls is eye-poppingly expensive
due to the guest CPUID checks, hence the dedicated cache, but the other
calculations aren't exactly free either.

Explicitly clear several bits (x2APIC, DESC exiting, and load EFER on
exit) as appropriate as they may be set in vmcs01, whereas the previous
implementation relied on dynamic bits being cleared in the calculator.

Intentionally propagate VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL from
vmcs01 to vmcs02.  Whether or not PERF_GLOBAL_CTRL is loaded depends on
whether or not perf itself is active, so unless perf stops between the
exit from L1 and entry to L2, vmcs01 will hold the desired value.  This
is purely an optimization as atomic_switch_perf_msrs() will set/clear
the control as needed at VM-Enter, i.e. it avoids two extra VMWRITEs in
the case where perf is active (versus starting with the bits clear in
vmcs02, which was the previous behavior).

Cc: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210810171952.2758100-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: def9d705c05e ("KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings to vmcs02")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 25 ++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.h    |  6 +++++-
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7f15e2b2a0d6..2395387945a8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2232,7 +2232,8 @@ static void prepare_vmcs02_early_rare(struct vcpu_vmx *vmx,
 	}
 }
 
-static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
+static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs01,
+				 struct vmcs12 *vmcs12)
 {
 	u32 exec_control, vmcs12_exec_ctrl;
 	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
@@ -2243,7 +2244,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	/*
 	 * PIN CONTROLS
 	 */
-	exec_control = vmx_pin_based_exec_ctrl(vmx);
+	exec_control = __pin_controls_get(vmcs01);
 	exec_control |= (vmcs12->pin_based_vm_exec_control &
 			 ~PIN_BASED_VMX_PREEMPTION_TIMER);
 
@@ -2258,7 +2259,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	/*
 	 * EXEC CONTROLS
 	 */
-	exec_control = vmx_exec_control(vmx); /* L0's desires */
+	exec_control = __exec_controls_get(vmcs01); /* L0's desires */
 	exec_control &= ~CPU_BASED_INTR_WINDOW_EXITING;
 	exec_control &= ~CPU_BASED_NMI_WINDOW_EXITING;
 	exec_control &= ~CPU_BASED_TPR_SHADOW;
@@ -2295,17 +2296,20 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * SECONDARY EXEC CONTROLS
 	 */
 	if (cpu_has_secondary_exec_ctrls()) {
-		exec_control = vmx->secondary_exec_control;
+		exec_control = __secondary_exec_controls_get(vmcs01);
 
 		/* Take the following fields only from vmcs12 */
 		exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
+				  SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
 				  SECONDARY_EXEC_ENABLE_INVPCID |
 				  SECONDARY_EXEC_ENABLE_RDTSCP |
 				  SECONDARY_EXEC_XSAVES |
 				  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
-				  SECONDARY_EXEC_ENABLE_VMFUNC);
+				  SECONDARY_EXEC_ENABLE_VMFUNC |
+				  SECONDARY_EXEC_DESC);
+
 		if (nested_cpu_has(vmcs12,
 				   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)) {
 			vmcs12_exec_ctrl = vmcs12->secondary_vm_exec_control &
@@ -2342,8 +2346,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * on the related bits (if supported by the CPU) in the hope that
 	 * we can avoid VMWrites during vmx_set_efer().
 	 */
-	exec_control = (vmcs12->vm_entry_controls | vmx_vmentry_ctrl()) &
-			~VM_ENTRY_IA32E_MODE & ~VM_ENTRY_LOAD_IA32_EFER;
+	exec_control = __vm_entry_controls_get(vmcs01);
+	exec_control |= vmcs12->vm_entry_controls;
+	exec_control &= ~(VM_ENTRY_IA32E_MODE | VM_ENTRY_LOAD_IA32_EFER);
 	if (cpu_has_load_ia32_efer()) {
 		if (guest_efer & EFER_LMA)
 			exec_control |= VM_ENTRY_IA32E_MODE;
@@ -2359,9 +2364,11 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * we should use its exit controls. Note that VM_EXIT_LOAD_IA32_EFER
 	 * bits may be modified by vmx_set_efer() in prepare_vmcs02().
 	 */
-	exec_control = vmx_vmexit_ctrl();
+	exec_control = __vm_exit_controls_get(vmcs01);
 	if (cpu_has_load_ia32_efer() && guest_efer != host_efer)
 		exec_control |= VM_EXIT_LOAD_IA32_EFER;
+	else
+		exec_control &= ~VM_EXIT_LOAD_IA32_EFER;
 	vm_exit_controls_set(vmx, exec_control);
 
 	/*
@@ -3370,7 +3377,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
 
-	prepare_vmcs02_early(vmx, vmcs12);
+	prepare_vmcs02_early(vmx, &vmx->vmcs01, vmcs12);
 
 	if (from_vmentry) {
 		if (unlikely(!nested_get_vmcs12_pages(vcpu))) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 24903f05c204..ed4b6da83aa8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -386,9 +386,13 @@ static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
 		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
 	}								    \
 }									    \
+static inline u32 __##lname##_controls_get(struct loaded_vmcs *vmcs)	    \
+{									    \
+	return vmcs->controls_shadow.lname;				    \
+}									    \
 static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
 {									    \
-	return vmx->loaded_vmcs->controls_shadow.lname;			    \
+	return __##lname##_controls_get(vmx->loaded_vmcs);		    \
 }									    \
 static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
 {									    \
-- 
2.35.1



