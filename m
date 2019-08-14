Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDA48D806
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 18:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfHNQZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 12:25:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47295 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbfHNQZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 12:25:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0DBBC213CA;
        Wed, 14 Aug 2019 12:25:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 14 Aug 2019 12:25:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=429zoo
        ZkCOkXvgSP34gGX+bTDpGGQR1Pvs/hUKPiePA=; b=Rx4O5pynDUH3ieB5JDmiN2
        E3+D9roZJXwFAR0l9DTY7kEc0ck0siyFLHBSQcFCCBywfSupZCZARtoOZGUxkCaY
        fjMT+hO0Fj0ybwRxQHhCiEGHlqAjrhJbm5j2ChGnvKekVfclAUPa5YRxHryq2ZqY
        kcfC9j3ykFGsKMVp7P03ZZ9PetKoKec+i15SWmH+X8jDCKzXnajvhqzrMKTjS1VO
        NbLf/zUDynEnsJFOAyj0HZGIMgJJLgE4GRqGGV5wVIU7ly7nBE3lRnSFRHO2ZymJ
        n+S4fVyElg8LBnB5m8wiOmMi/p6SHAH6/OI4hgt2sn7OiHtc9m+cAzXUinWkjpNg
        ==
X-ME-Sender: <xms:4DVUXZ6XOqxz3NSJLFfZtGMOpnH38TGHr0GwhzlUMo64kmYeWmHh-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvledgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:4DVUXf4b4y_W2aCFZB7-zN1uCXH1y-6x1wZt21tvnmxFDlMiazf4jQ>
    <xmx:4DVUXdVXcYnr07ZxOQ9CBPN0XeVqdvHwnENtJRgQkDRf0HuvFNgf0w>
    <xmx:4DVUXVCd22Tb_OKyp19VIYcY3KW8IAxiUPx3-Lm0qMOFbVcj-vIsrg>
    <xmx:4TVUXRXEKejEJnnRyVZ8gxXkGkTT9otcBk9FM7C0-mf8fIg4Ax_VEA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 476A5380075;
        Wed, 14 Aug 2019 12:25:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: Fix leak vCPU's VMCS value into other pCPU" failed to apply to 4.9-stable tree
To:     wanpengli@tencent.com, Marc.Zyngier@arm.com,
        borntraeger@de.ibm.com, pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 14 Aug 2019 18:24:55 +0200
Message-ID: <15657998951051@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 17e433b54393a6269acbcb792da97791fe1592d8 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Mon, 5 Aug 2019 10:03:19 +0800
Subject: [PATCH] KVM: Fix leak vCPU's VMCS value into other pCPU
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 0dba7eb24f92..3e34d5fa6708 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -50,6 +50,11 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
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
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e74f0711eaaf..fc046ca89d32 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1175,6 +1175,7 @@ struct kvm_x86_ops {
 	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
 			      uint32_t guest_irq, bool set);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
+	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
 
 	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			    bool *expired);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7eafc6907861..d685491fce4d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5190,6 +5190,11 @@ static void svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
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
@@ -7314,6 +7319,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.pmu_ops = &amd_pmu_ops,
 	.deliver_posted_interrupt = svm_deliver_avic_intr,
+	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
 	.update_pi_irte = svm_update_pi_irte,
 	.setup_mce = svm_setup_mce,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 074385c86c09..42ed3faa6af8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6117,6 +6117,11 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
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
@@ -7726,6 +7731,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
 	.deliver_posted_interrupt = vmx_deliver_posted_interrupt,
+	.dy_apicv_has_pending_interrupt = vmx_dy_apicv_has_pending_interrupt,
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c6d951cbd76c..93b0bd45ac73 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9698,6 +9698,22 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5c5b5867024c..9e4c2bb90297 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -872,6 +872,7 @@ int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
+bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ed061d8a457c..1f05aeb9da27 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2477,6 +2477,29 @@ static bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
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
@@ -2506,7 +2529,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (vcpu == me)
 				continue;
-			if (swait_active(&vcpu->wq) && !kvm_arch_vcpu_runnable(vcpu))
+			if (swait_active(&vcpu->wq) && !vcpu_dy_runnable(vcpu))
 				continue;
 			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
 				!kvm_arch_vcpu_in_kernel(vcpu))

