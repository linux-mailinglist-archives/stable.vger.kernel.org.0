Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6547FE68FF
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfJ0VMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730030AbfJ0VMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:12:16 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9D14205C9;
        Sun, 27 Oct 2019 21:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210735;
        bh=L1PrepPqPQmkFLVK0zM+FROUoakFp+6q6KeHCKYcIo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnwEsD1+EZpJrKfS2FwCDPD2US4JTtZ5viyuFiWJZ8YlnfpEBMxHoVJEfH7avh10U
         THxWTZ/EV9+Bb0UUQdH3/x02cigvbK3yHRxox4YbjUIsXWFSC0ZCMFryeAvIUD9wBx
         J07GNIaHNALh466ZkPEcIR6krP4BoMB4ED4aAgLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Jitindar SIngh, Suraj" <surajjs@amazon.com>
Subject: [PATCH 4.14 118/119] kvm: vmx: Basic APIC virtualization controls have three settings
Date:   Sun, 27 Oct 2019 22:01:35 +0100
Message-Id: <20191027203350.009320062@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

commit 8d860bbeedef97fe981d28fa7b71d77f3b29563f upstream.

Previously, we toggled between SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE
and SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES, depending on whether or
not the EXTD bit was set in MSR_IA32_APICBASE. However, if the local
APIC is disabled, we should not set either of these APIC
virtualization control bits.

Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Jitindar SIngh, Suraj" <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    2 -
 arch/x86/kvm/lapic.c            |   12 ++++------
 arch/x86/kvm/svm.c              |    4 +--
 arch/x86/kvm/vmx.c              |   48 +++++++++++++++++++++++++---------------
 4 files changed, 38 insertions(+), 28 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -998,7 +998,7 @@ struct kvm_x86_ops {
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
-	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
+	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu, hpa_t hpa);
 	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1967,13 +1967,11 @@ void kvm_lapic_set_base(struct kvm_vcpu
 		}
 	}
 
-	if ((old_value ^ value) & X2APIC_ENABLE) {
-		if (value & X2APIC_ENABLE) {
-			kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
-			kvm_x86_ops->set_virtual_x2apic_mode(vcpu, true);
-		} else
-			kvm_x86_ops->set_virtual_x2apic_mode(vcpu, false);
-	}
+	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
+		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
+
+	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
+		kvm_x86_ops->set_virtual_apic_mode(vcpu);
 
 	apic->base_address = apic->vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4589,7 +4589,7 @@ static void update_cr8_intercept(struct
 		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
 }
 
-static void svm_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
+static void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 {
 	return;
 }
@@ -5713,7 +5713,7 @@ static struct kvm_x86_ops svm_x86_ops __
 	.enable_nmi_window = enable_nmi_window,
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
-	.set_virtual_x2apic_mode = svm_set_virtual_x2apic_mode,
+	.set_virtual_apic_mode = svm_set_virtual_apic_mode,
 	.get_enable_apicv = svm_get_enable_apicv,
 	.refresh_apicv_exec_ctrl = svm_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -591,7 +591,8 @@ struct nested_vmx {
 	 */
 	bool sync_shadow_vmcs;
 
-	bool change_vmcs01_virtual_x2apic_mode;
+	bool change_vmcs01_virtual_apic_mode;
+
 	/* L2 must run next, and mustn't decide to exit to L1. */
 	bool nested_run_pending;
 
@@ -9290,31 +9291,43 @@ static void update_cr8_intercept(struct
 	vmcs_write32(TPR_THRESHOLD, irr);
 }
 
-static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
+static void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 {
 	u32 sec_exec_control;
 
+	if (!lapic_in_kernel(vcpu))
+		return;
+
 	/* Postpone execution until vmcs01 is the current VMCS. */
 	if (is_guest_mode(vcpu)) {
-		to_vmx(vcpu)->nested.change_vmcs01_virtual_x2apic_mode = true;
+		to_vmx(vcpu)->nested.change_vmcs01_virtual_apic_mode = true;
 		return;
 	}
 
-	if (!cpu_has_vmx_virtualize_x2apic_mode())
-		return;
-
 	if (!cpu_need_tpr_shadow(vcpu))
 		return;
 
 	sec_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
+	sec_exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
+			      SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE);
 
-	if (set) {
-		sec_exec_control &= ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
-		sec_exec_control |= SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
-	} else {
-		sec_exec_control &= ~SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
-		sec_exec_control |= SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
-		vmx_flush_tlb(vcpu, true);
+	switch (kvm_get_apic_mode(vcpu)) {
+	case LAPIC_MODE_INVALID:
+		WARN_ONCE(true, "Invalid local APIC state");
+	case LAPIC_MODE_DISABLED:
+		break;
+	case LAPIC_MODE_XAPIC:
+		if (flexpriority_enabled) {
+			sec_exec_control |=
+				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+			vmx_flush_tlb(vcpu, true);
+		}
+		break;
+	case LAPIC_MODE_X2APIC:
+		if (cpu_has_vmx_virtualize_x2apic_mode())
+			sec_exec_control |=
+				SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
+		break;
 	}
 	vmcs_write32(SECONDARY_VM_EXEC_CONTROL, sec_exec_control);
 
@@ -12185,10 +12198,9 @@ static void nested_vmx_vmexit(struct kvm
 	if (kvm_has_tsc_control)
 		decache_tsc_multiplier(vmx);
 
-	if (vmx->nested.change_vmcs01_virtual_x2apic_mode) {
-		vmx->nested.change_vmcs01_virtual_x2apic_mode = false;
-		vmx_set_virtual_x2apic_mode(vcpu,
-				vcpu->arch.apic_base & X2APIC_ENABLE);
+	if (vmx->nested.change_vmcs01_virtual_apic_mode) {
+		vmx->nested.change_vmcs01_virtual_apic_mode = false;
+		vmx_set_virtual_apic_mode(vcpu);
 	} else if (!nested_cpu_has_ept(vmcs12) &&
 		   nested_cpu_has2(vmcs12,
 				   SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
@@ -12749,7 +12761,7 @@ static struct kvm_x86_ops vmx_x86_ops __
 	.enable_nmi_window = enable_nmi_window,
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
-	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
+	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.get_enable_apicv = vmx_get_enable_apicv,
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,


