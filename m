Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2930A8DA10
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbfHNROv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731136AbfHNROs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4808F2063F;
        Wed, 14 Aug 2019 17:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802886;
        bh=IqzMekpzARA+q3kh4Np1cxp5sAv3DeoeUNMqei387nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcZs/yYObXU9Hfio89ZynreBur705m8dRUxX9UJDurtOjE1Htu3lXRkBtzRhi6SU+
         XRVtLRFGNCuOM18nO48dpPnvMEwbFYMS0TTwep0G+hQ+ipNMxEiOH52ULj1dGtZh3G
         vtMbSAj4Gr6k3l3oknAG6l8N88tS+XBJt+59XXCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 4.14 64/69] KVM: Fix leak vCPUs VMCS value into other pCPU
Date:   Wed, 14 Aug 2019 19:02:02 +0200
Message-Id: <20190814165750.395263015@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit 17e433b54393a6269acbcb792da97791fe1592d8 upstream.

After commit d73eb57b80b (KVM: Boost vCPUs that are delivering interrupts), a
five years old bug is exposed. Running ebizzy benchmark in three 80 vCPUs VMs
on one 80 pCPUs Skylake server, a lot of rcu_sched stall warning splatting
in the VMs after stress testing:

 INFO: rcu_sched detected stalls on CPUs/tasks: { 4 41 57 62 77} (detected by 15, t=60004 jiffies, g=899, c=898, q=15073)
 Call Trace:
   flush_tlb_mm_range+0x68/0x140
   tlb_flush_mmu.part.75+0x37/0xe0
   tlb_finish_mmu+0x55/0x60
   zap_page_range+0x142/0x190
   SyS_madvise+0x3cd/0x9c0
   system_call_fastpath+0x1c/0x21

swait_active() sustains to be true before finish_swait() is called in
kvm_vcpu_block(), voluntarily preempted vCPUs are taken into account
by kvm_vcpu_on_spin() loop greatly increases the probability condition
kvm_arch_vcpu_runnable(vcpu) is checked and can be true, when APICv
is enabled the yield-candidate vCPU's VMCS RVI field leaks(by
vmx_sync_pir_to_irr()) into spinning-on-a-taken-lock vCPU's current
VMCS.

This patch fixes it by checking conservatively a subset of events.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: stable@vger.kernel.org
Fixes: 98f4a1467 (KVM: add kvm_arch_vcpu_runnable() test to kvm_vcpu_on_spin() loop)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/powerpc.c      |    5 +++++
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/svm.c              |    6 ++++++
 arch/x86/kvm/vmx.c              |    6 ++++++
 arch/x86/kvm/x86.c              |   16 ++++++++++++++++
 include/linux/kvm_host.h        |    1 +
 virt/kvm/kvm_main.c             |   25 ++++++++++++++++++++++++-
 7 files changed, 59 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -58,6 +58,11 @@ int kvm_arch_vcpu_runnable(struct kvm_vc
 	return !!(v->arch.pending_exceptions) || kvm_request_pending(v);
 }
 
+bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
+{
+	return kvm_arch_vcpu_runnable(vcpu);
+}
+
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
 	return false;
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1077,6 +1077,7 @@ struct kvm_x86_ops {
 	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
 			      uint32_t guest_irq, bool set);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
+	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
 
 	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc);
 	void (*cancel_hv_timer)(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4637,6 +4637,11 @@ static void svm_deliver_avic_intr(struct
 		kvm_vcpu_wake_up(vcpu);
 }
 
+static bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 {
 	unsigned long flags;
@@ -5746,6 +5751,7 @@ static struct kvm_x86_ops svm_x86_ops __
 
 	.pmu_ops = &amd_pmu_ops,
 	.deliver_posted_interrupt = svm_deliver_avic_intr,
+	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
 	.update_pi_irte = svm_update_pi_irte,
 	.setup_mce = svm_setup_mce,
 };
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -9431,6 +9431,11 @@ static int vmx_sync_pir_to_irr(struct kv
 	return max_irr;
 }
 
+static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
+{
+	return pi_test_on(vcpu_to_pi_desc(vcpu));
+}
+
 static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 {
 	if (!kvm_vcpu_apicv_active(vcpu))
@@ -12756,6 +12761,7 @@ static struct kvm_x86_ops vmx_x86_ops __
 	.hwapic_isr_update = vmx_hwapic_isr_update,
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
 	.deliver_posted_interrupt = vmx_deliver_posted_interrupt,
+	.dy_apicv_has_pending_interrupt = vmx_dy_apicv_has_pending_interrupt,
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.get_tdp_level = get_ept_level,
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8711,6 +8711,22 @@ int kvm_arch_vcpu_runnable(struct kvm_vc
 	return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
 }
 
+bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
+{
+	if (READ_ONCE(vcpu->arch.pv.pv_unhalted))
+		return true;
+
+	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
+		kvm_test_request(KVM_REQ_SMI, vcpu) ||
+		 kvm_test_request(KVM_REQ_EVENT, vcpu))
+		return true;
+
+	if (vcpu->arch.apicv_active && kvm_x86_ops->dy_apicv_has_pending_interrupt(vcpu))
+		return true;
+
+	return false;
+}
+
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.preempted_in_kernel;
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -808,6 +808,7 @@ void kvm_arch_check_processor_compat(voi
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
+bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2314,6 +2314,29 @@ static bool kvm_vcpu_eligible_for_direct
 #endif
 }
 
+/*
+ * Unlike kvm_arch_vcpu_runnable, this function is called outside
+ * a vcpu_load/vcpu_put pair.  However, for most architectures
+ * kvm_arch_vcpu_runnable does not require vcpu_load.
+ */
+bool __weak kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
+{
+	return kvm_arch_vcpu_runnable(vcpu);
+}
+
+static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
+{
+	if (kvm_arch_dy_runnable(vcpu))
+		return true;
+
+#ifdef CONFIG_KVM_ASYNC_PF
+	if (!list_empty_careful(&vcpu->async_pf.done))
+		return true;
+#endif
+
+	return false;
+}
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	struct kvm *kvm = me->kvm;
@@ -2343,7 +2366,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *m
 				continue;
 			if (vcpu == me)
 				continue;
-			if (swait_active(&vcpu->wq) && !kvm_arch_vcpu_runnable(vcpu))
+			if (swait_active(&vcpu->wq) && !vcpu_dy_runnable(vcpu))
 				continue;
 			if (yield_to_kernel_mode && !kvm_arch_vcpu_in_kernel(vcpu))
 				continue;


