Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2E866C923
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbjAPQq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbjAPQp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:45:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8E61E28B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:33:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D175B81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6573C433D2;
        Mon, 16 Jan 2023 16:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886828;
        bh=6uxXPMYLtM7sebR4PP3lIlCVCFOMWxHY4mfy5Y6dgJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJcef2edg48HvW4mTCm9w9DVOi3BCD5X1MZvgwc9i70jnpWCldSgvh8rl+lW84Tdq
         3qrPCx8pfv/+/ZjPjgnVj8CljdXzp/vmDn1k0TQ8hvHVVCRdEy1BqxWVF0hB13hVoM
         bETFH2ruLbTL2yiSwOV8O9gVESSJqQgm2kN3VY3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 548/658] KVM: VMX: Rename INTERRUPT_PENDING to INTERRUPT_WINDOW
Date:   Mon, 16 Jan 2023 16:50:36 +0100
Message-Id: <20230116154934.602943882@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

[ Upstream commit 9dadc2f918df26e64aa04794cdb4d8667c934f47 ]

Rename interrupt-windown exiting related definitions to match the
latest Intel SDM. No functional changes.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 31de69f4eea7 ("KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/vmx.h                       |  2 +-
 arch/x86/include/uapi/asm/vmx.h                  |  4 ++--
 arch/x86/kvm/vmx/nested.c                        | 12 ++++++------
 arch/x86/kvm/vmx/vmx.c                           | 10 +++++-----
 tools/arch/x86/include/uapi/asm/vmx.h            |  4 ++--
 tools/testing/selftests/kvm/include/x86_64/vmx.h |  4 ++--
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 1835767aa335..5acda8d9b9a7 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -19,7 +19,7 @@
 /*
  * Definitions of Primary Processor-Based VM-Execution Controls.
  */
-#define CPU_BASED_VIRTUAL_INTR_PENDING          0x00000004
+#define CPU_BASED_INTR_WINDOW_EXITING           0x00000004
 #define CPU_BASED_USE_TSC_OFFSETING             0x00000008
 #define CPU_BASED_HLT_EXITING                   0x00000080
 #define CPU_BASED_INVLPG_EXITING                0x00000200
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 3eb8411ab60e..e95b72ec19bc 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -33,7 +33,7 @@
 #define EXIT_REASON_TRIPLE_FAULT        2
 #define EXIT_REASON_INIT_SIGNAL			3
 
-#define EXIT_REASON_PENDING_INTERRUPT   7
+#define EXIT_REASON_INTERRUPT_WINDOW    7
 #define EXIT_REASON_NMI_WINDOW          8
 #define EXIT_REASON_TASK_SWITCH         9
 #define EXIT_REASON_CPUID               10
@@ -94,7 +94,7 @@
 	{ EXIT_REASON_EXTERNAL_INTERRUPT,    "EXTERNAL_INTERRUPT" }, \
 	{ EXIT_REASON_TRIPLE_FAULT,          "TRIPLE_FAULT" }, \
 	{ EXIT_REASON_INIT_SIGNAL,           "INIT_SIGNAL" }, \
-	{ EXIT_REASON_PENDING_INTERRUPT,     "PENDING_INTERRUPT" }, \
+	{ EXIT_REASON_INTERRUPT_WINDOW,      "INTERRUPT_WINDOW" }, \
 	{ EXIT_REASON_NMI_WINDOW,            "NMI_WINDOW" }, \
 	{ EXIT_REASON_TASK_SWITCH,           "TASK_SWITCH" }, \
 	{ EXIT_REASON_CPUID,                 "CPUID" }, \
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6ab0410f1030..ee768f977a0a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2073,7 +2073,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * EXEC CONTROLS
 	 */
 	exec_control = vmx_exec_control(vmx); /* L0's desires */
-	exec_control &= ~CPU_BASED_VIRTUAL_INTR_PENDING;
+	exec_control &= ~CPU_BASED_INTR_WINDOW_EXITING;
 	exec_control &= ~CPU_BASED_VIRTUAL_NMI_PENDING;
 	exec_control &= ~CPU_BASED_TPR_SHADOW;
 	exec_control |= vmcs12->cpu_based_vm_exec_control;
@@ -3039,7 +3039,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	u32 exit_qual;
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
-		(CPU_BASED_VIRTUAL_INTR_PENDING | CPU_BASED_VIRTUAL_NMI_PENDING);
+		(CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_VIRTUAL_NMI_PENDING);
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
 
@@ -3268,7 +3268,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if ((vmcs12->guest_activity_state == GUEST_ACTIVITY_HLT) &&
 	    !(vmcs12->vm_entry_intr_info_field & INTR_INFO_VALID_MASK) &&
 	    !(vmcs12->cpu_based_vm_exec_control & CPU_BASED_VIRTUAL_NMI_PENDING) &&
-	    !((vmcs12->cpu_based_vm_exec_control & CPU_BASED_VIRTUAL_INTR_PENDING) &&
+	    !((vmcs12->cpu_based_vm_exec_control & CPU_BASED_INTR_WINDOW_EXITING) &&
 	      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
 		vmx->nested.nested_run_pending = 0;
 		return kvm_vcpu_halt(vcpu);
@@ -5376,8 +5376,8 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 		return false;
 	case EXIT_REASON_TRIPLE_FAULT:
 		return true;
-	case EXIT_REASON_PENDING_INTERRUPT:
-		return nested_cpu_has(vmcs12, CPU_BASED_VIRTUAL_INTR_PENDING);
+	case EXIT_REASON_INTERRUPT_WINDOW:
+		return nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING);
 	case EXIT_REASON_NMI_WINDOW:
 		return nested_cpu_has(vmcs12, CPU_BASED_VIRTUAL_NMI_PENDING);
 	case EXIT_REASON_TASK_SWITCH:
@@ -5869,7 +5869,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->procbased_ctls_low =
 		CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
 	msrs->procbased_ctls_high &=
-		CPU_BASED_VIRTUAL_INTR_PENDING |
+		CPU_BASED_INTR_WINDOW_EXITING |
 		CPU_BASED_VIRTUAL_NMI_PENDING | CPU_BASED_USE_TSC_OFFSETING |
 		CPU_BASED_HLT_EXITING | CPU_BASED_INVLPG_EXITING |
 		CPU_BASED_MWAIT_EXITING | CPU_BASED_CR3_LOAD_EXITING |
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 668505c6abe9..51aa5851011c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4458,7 +4458,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
-	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_INTR_PENDING);
+	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_INTR_WINDOW_EXITING);
 }
 
 static void enable_nmi_window(struct kvm_vcpu *vcpu)
@@ -5082,7 +5082,7 @@ static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu)
 
 static int handle_interrupt_window(struct kvm_vcpu *vcpu)
 {
-	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_INTR_PENDING);
+	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_INTR_WINDOW_EXITING);
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
@@ -5316,7 +5316,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(vmx->emulation_required && vmx->nested.nested_run_pending);
 
 	intr_window_requested = exec_controls_get(vmx) &
-				CPU_BASED_VIRTUAL_INTR_PENDING;
+				CPU_BASED_INTR_WINDOW_EXITING;
 
 	while (vmx->emulation_required && count-- != 0) {
 		if (intr_window_requested && vmx_interrupt_allowed(vcpu))
@@ -5640,7 +5640,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_CPUID]                   = kvm_emulate_cpuid,
 	[EXIT_REASON_MSR_READ]                = kvm_emulate_rdmsr,
 	[EXIT_REASON_MSR_WRITE]               = kvm_emulate_wrmsr,
-	[EXIT_REASON_PENDING_INTERRUPT]       = handle_interrupt_window,
+	[EXIT_REASON_INTERRUPT_WINDOW]        = handle_interrupt_window,
 	[EXIT_REASON_HLT]                     = kvm_emulate_halt,
 	[EXIT_REASON_INVD]		      = handle_invd,
 	[EXIT_REASON_INVLPG]		      = handle_invlpg,
@@ -6021,7 +6021,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 			return kvm_emulate_wrmsr(vcpu);
 		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
 			return handle_preemption_timer(vcpu);
-		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
+		else if (exit_reason == EXIT_REASON_INTERRUPT_WINDOW)
 			return handle_interrupt_window(vcpu);
 		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
 			return handle_external_interrupt(vcpu);
diff --git a/tools/arch/x86/include/uapi/asm/vmx.h b/tools/arch/x86/include/uapi/asm/vmx.h
index 3eb8411ab60e..e95b72ec19bc 100644
--- a/tools/arch/x86/include/uapi/asm/vmx.h
+++ b/tools/arch/x86/include/uapi/asm/vmx.h
@@ -33,7 +33,7 @@
 #define EXIT_REASON_TRIPLE_FAULT        2
 #define EXIT_REASON_INIT_SIGNAL			3
 
-#define EXIT_REASON_PENDING_INTERRUPT   7
+#define EXIT_REASON_INTERRUPT_WINDOW    7
 #define EXIT_REASON_NMI_WINDOW          8
 #define EXIT_REASON_TASK_SWITCH         9
 #define EXIT_REASON_CPUID               10
@@ -94,7 +94,7 @@
 	{ EXIT_REASON_EXTERNAL_INTERRUPT,    "EXTERNAL_INTERRUPT" }, \
 	{ EXIT_REASON_TRIPLE_FAULT,          "TRIPLE_FAULT" }, \
 	{ EXIT_REASON_INIT_SIGNAL,           "INIT_SIGNAL" }, \
-	{ EXIT_REASON_PENDING_INTERRUPT,     "PENDING_INTERRUPT" }, \
+	{ EXIT_REASON_INTERRUPT_WINDOW,      "INTERRUPT_WINDOW" }, \
 	{ EXIT_REASON_NMI_WINDOW,            "NMI_WINDOW" }, \
 	{ EXIT_REASON_TASK_SWITCH,           "TASK_SWITCH" }, \
 	{ EXIT_REASON_CPUID,                 "CPUID" }, \
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index f52e0ba84fed..c6e442d7a241 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -18,7 +18,7 @@
 /*
  * Definitions of Primary Processor-Based VM-Execution Controls.
  */
-#define CPU_BASED_VIRTUAL_INTR_PENDING		0x00000004
+#define CPU_BASED_INTR_WINDOW_EXITING		0x00000004
 #define CPU_BASED_USE_TSC_OFFSETING		0x00000008
 #define CPU_BASED_HLT_EXITING			0x00000080
 #define CPU_BASED_INVLPG_EXITING		0x00000200
@@ -103,7 +103,7 @@
 #define EXIT_REASON_EXCEPTION_NMI	0
 #define EXIT_REASON_EXTERNAL_INTERRUPT	1
 #define EXIT_REASON_TRIPLE_FAULT	2
-#define EXIT_REASON_PENDING_INTERRUPT	7
+#define EXIT_REASON_INTERRUPT_WINDOW	7
 #define EXIT_REASON_NMI_WINDOW		8
 #define EXIT_REASON_TASK_SWITCH		9
 #define EXIT_REASON_CPUID		10
-- 
2.35.1



