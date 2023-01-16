Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD5B66C925
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbjAPQq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbjAPQp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:45:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBED1CAE0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:33:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D65F6B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437F8C433EF;
        Mon, 16 Jan 2023 16:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886830;
        bh=ioj/wcY0L5oR6C5L9dl5nOG2HlnBATpBuUIiZbQ64Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5Fa8vS54MGRvDf3JFwmv3YvjJBI1StXJvDyvc3XzA0/QR34guR7YlBbSzw25/vBE
         03E3UWJHxggHVLaxDE9ZIcDDwJMqnG2H3ecpLqhV2qtOpp18RHO4GnaARiZPlQeeK4
         03qp5mSdisPLnt3azFMGyF2cAzDAieNYxtAXh9Dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 549/658] KVM: VMX: Rename NMI_PENDING to NMI_WINDOW
Date:   Mon, 16 Jan 2023 16:50:37 +0100
Message-Id: <20230116154934.646368339@linuxfoundation.org>
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

[ Upstream commit 4e2a0bc56ad197e5ccfab8395649b681067fe8cb ]

Rename the NMI-window exiting related definitions to match the latest
Intel SDM. No functional changes.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 31de69f4eea7 ("KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/vmx.h                       |  2 +-
 arch/x86/kvm/vmx/nested.c                        | 12 ++++++------
 arch/x86/kvm/vmx/vmx.c                           |  4 ++--
 tools/testing/selftests/kvm/include/x86_64/vmx.h |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 5acda8d9b9a7..06d4420508c5 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -31,7 +31,7 @@
 #define CPU_BASED_CR8_LOAD_EXITING              0x00080000
 #define CPU_BASED_CR8_STORE_EXITING             0x00100000
 #define CPU_BASED_TPR_SHADOW                    0x00200000
-#define CPU_BASED_VIRTUAL_NMI_PENDING		0x00400000
+#define CPU_BASED_NMI_WINDOW_EXITING		0x00400000
 #define CPU_BASED_MOV_DR_EXITING                0x00800000
 #define CPU_BASED_UNCOND_IO_EXITING             0x01000000
 #define CPU_BASED_USE_IO_BITMAPS                0x02000000
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ee768f977a0a..dca2c78db5d0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2074,7 +2074,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 */
 	exec_control = vmx_exec_control(vmx); /* L0's desires */
 	exec_control &= ~CPU_BASED_INTR_WINDOW_EXITING;
-	exec_control &= ~CPU_BASED_VIRTUAL_NMI_PENDING;
+	exec_control &= ~CPU_BASED_NMI_WINDOW_EXITING;
 	exec_control &= ~CPU_BASED_TPR_SHADOW;
 	exec_control |= vmcs12->cpu_based_vm_exec_control;
 
@@ -2459,7 +2459,7 @@ static int nested_vmx_check_nmi_controls(struct vmcs12 *vmcs12)
 		return -EINVAL;
 
 	if (CC(!nested_cpu_has_virtual_nmis(vmcs12) &&
-	       nested_cpu_has(vmcs12, CPU_BASED_VIRTUAL_NMI_PENDING)))
+	       nested_cpu_has(vmcs12, CPU_BASED_NMI_WINDOW_EXITING)))
 		return -EINVAL;
 
 	return 0;
@@ -3039,7 +3039,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	u32 exit_qual;
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
-		(CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_VIRTUAL_NMI_PENDING);
+		(CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITING);
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
 
@@ -3267,7 +3267,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 */
 	if ((vmcs12->guest_activity_state == GUEST_ACTIVITY_HLT) &&
 	    !(vmcs12->vm_entry_intr_info_field & INTR_INFO_VALID_MASK) &&
-	    !(vmcs12->cpu_based_vm_exec_control & CPU_BASED_VIRTUAL_NMI_PENDING) &&
+	    !(vmcs12->cpu_based_vm_exec_control & CPU_BASED_NMI_WINDOW_EXITING) &&
 	    !((vmcs12->cpu_based_vm_exec_control & CPU_BASED_INTR_WINDOW_EXITING) &&
 	      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
 		vmx->nested.nested_run_pending = 0;
@@ -5379,7 +5379,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	case EXIT_REASON_INTERRUPT_WINDOW:
 		return nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING);
 	case EXIT_REASON_NMI_WINDOW:
-		return nested_cpu_has(vmcs12, CPU_BASED_VIRTUAL_NMI_PENDING);
+		return nested_cpu_has(vmcs12, CPU_BASED_NMI_WINDOW_EXITING);
 	case EXIT_REASON_TASK_SWITCH:
 		return true;
 	case EXIT_REASON_CPUID:
@@ -5870,7 +5870,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
 	msrs->procbased_ctls_high &=
 		CPU_BASED_INTR_WINDOW_EXITING |
-		CPU_BASED_VIRTUAL_NMI_PENDING | CPU_BASED_USE_TSC_OFFSETING |
+		CPU_BASED_NMI_WINDOW_EXITING | CPU_BASED_USE_TSC_OFFSETING |
 		CPU_BASED_HLT_EXITING | CPU_BASED_INVLPG_EXITING |
 		CPU_BASED_MWAIT_EXITING | CPU_BASED_CR3_LOAD_EXITING |
 		CPU_BASED_CR3_STORE_EXITING |
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 51aa5851011c..470a8f9a0046 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4469,7 +4469,7 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_NMI_PENDING);
+	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
 }
 
 static void vmx_inject_irq(struct kvm_vcpu *vcpu)
@@ -5295,7 +5295,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 static int handle_nmi_window(struct kvm_vcpu *vcpu)
 {
 	WARN_ON_ONCE(!enable_vnmi);
-	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_NMI_PENDING);
+	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
 	++vcpu->stat.nmi_window_exits;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index c6e442d7a241..7eb38451c359 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -30,7 +30,7 @@
 #define CPU_BASED_CR8_LOAD_EXITING		0x00080000
 #define CPU_BASED_CR8_STORE_EXITING		0x00100000
 #define CPU_BASED_TPR_SHADOW			0x00200000
-#define CPU_BASED_VIRTUAL_NMI_PENDING		0x00400000
+#define CPU_BASED_NMI_WINDOW_EXITING		0x00400000
 #define CPU_BASED_MOV_DR_EXITING		0x00800000
 #define CPU_BASED_UNCOND_IO_EXITING		0x01000000
 #define CPU_BASED_USE_IO_BITMAPS		0x02000000
-- 
2.35.1



