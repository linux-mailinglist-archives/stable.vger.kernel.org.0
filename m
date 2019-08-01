Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4807D3AB
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 05:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbfHADab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 23:30:31 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46695 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbfHADaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 23:30:30 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so31453329plz.13;
        Wed, 31 Jul 2019 20:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ef1nFLsIpKZV/bF+d3BWbHReqHavq+bx8awyUDo2ceU=;
        b=UnPz92wsTUoNe4/0uZdTm78sHNpbRH6Y8MwaQekzvR3vzBf32svfEwLZgavCHEPkl7
         Imfg5duBts24W5s47JCt/4w3Io1aeQ3GdDCLwE9wneqgtYvafNmQGGIk/xjqKVx/z1pg
         ArwdnzUjXu3lIuAyRXaZn4gf/e/sXEVDrrneQuRSjUuM4jYRXJDiEb70ba1NFHVj9Kk7
         wzj+9nZAI0zVS12652aHIxU3qBR7/QP0td2cHphqxrOtJ0+LrD3mtjYFVxhn04ocMCrl
         qJ19lnwDc/2yGGfT7BZ9GVGJwhdQFZNcFTsF1RekVXk/Fy4A8aW4n13rG4f0p/RrbIsl
         V03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ef1nFLsIpKZV/bF+d3BWbHReqHavq+bx8awyUDo2ceU=;
        b=VBnoe0ExmEaspz/jWxkSBh+96/AXEuq+X+cGzhhx5YdjhVtSelDxBcjKFEvcZcTaPS
         loZKhtfKJhjhrjF33PLlg8evSoV8G9LaN+etRwSKbyHttJNCF/RTSA3wWMI4KXsZij4f
         JE5bswsDyn/tCZZdbnoEck8H6ItQsKpfSju++jPwixt6Jm49SlPkSyB82Ts3Uh4JbrLm
         kH/nkQZxv6kHTdlQli+2CkDNx5U/aLKz9JIafhin1+IWxKzOLTjwiQAC9XnhjM6NM9bv
         DS8gXXNlMJT9acRnctB4wQZlc2p1MtUzSiLcPs0v1J7+Fhekz6I3P7GIVu1m3byoYyLo
         MM8g==
X-Gm-Message-State: APjAAAXBkMCtVSkXNt3Zubd+FDxKYbIfKwVcLi2gPyvnzaSwbxAZhsQN
        qkXOlfrim9azU8B/K7/Q9/C+5QknmQg=
X-Google-Smtp-Source: APXvYqzTBytVzGzjBs0U3bIZQXLPrSkf0JvuqamSibJhMm4yPrcuGoTdcwi9IPpdYSBzaZ5S3r5WWg==
X-Received: by 2002:a17:902:9a07:: with SMTP id v7mr16116809plp.245.1564630229568;
        Wed, 31 Jul 2019 20:30:29 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d14sm86158055pfo.154.2019.07.31.20.30.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 31 Jul 2019 20:30:28 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, stable@vger.kernel.org
Subject: [PATCH v3 1/3] KVM: Fix leak vCPU's VMCS value into other pCPU
Date:   Thu,  1 Aug 2019 11:30:12 +0800
Message-Id: <1564630214-28442-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

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
---
v2 -> v3:
 * check conservatively a subset of events
v1 -> v2:
 * checking swait_active(&vcpu->wq) for involuntary preemption

 arch/mips/kvm/mips.c            |  5 +++++
 arch/powerpc/kvm/powerpc.c      |  5 +++++
 arch/s390/kvm/kvm-s390.c        |  5 +++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx/vmx.c          |  6 ++++++
 arch/x86/kvm/x86.c              | 23 +++++++++++++++++++++++
 include/linux/kvm_host.h        |  1 +
 virt/kvm/arm/arm.c              |  5 +++++
 virt/kvm/kvm_main.c             | 13 ++++++++++++-
 10 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 2cfe839..95a4642 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -98,6 +98,11 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 	return !!(vcpu->arch.pending_exceptions);
 }
 
+bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
+{
+	return kvm_arch_vcpu_runnable(vcpu);
+}
+
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
 	return false;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 0dba7eb..3e34d5f 100644
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
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3f520cd8..5623b23 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3102,6 +3102,11 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 	return kvm_s390_vcpu_has_irq(vcpu, 0);
 }
 
+bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
+{
+	return kvm_arch_vcpu_runnable(vcpu);
+}
+
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
 	return !(vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7b0a4ee..de39a58 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1175,6 +1175,7 @@ struct kvm_x86_ops {
 	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
 			      uint32_t guest_irq, bool set);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
+	bool (*apicv_test_pi_on)(struct kvm_vcpu *vcpu);
 
 	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			    bool *expired);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7eafc69..1921f37 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5190,6 +5190,11 @@ static void svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 		kvm_vcpu_wake_up(vcpu);
 }
 
+static bool svm_apicv_test_pi_on(struct kvm_vcpu *vcpu)
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
+	.apicv_test_pi_on = svm_apicv_test_pi_on,
 	.update_pi_irte = svm_update_pi_irte,
 	.setup_mce = svm_setup_mce,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 074385c..863d641 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6117,6 +6117,11 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	return max_irr;
 }
 
+static bool vmx_apicv_test_pi_on(struct kvm_vcpu *vcpu)
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
+	.apicv_test_pi_on = vmx_apicv_test_pi_on,
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c6d951c..177544e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9698,6 +9698,29 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
 }
 
+bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
+{
+	if (READ_ONCE(vcpu->arch.pv.pv_unhalted))
+		return true;
+
+	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
+	    (READ_ONCE(vcpu->arch.nmi_pending) &&
+	     kvm_x86_ops->nmi_allowed(vcpu)))
+		return true;
+
+	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
+	    (READ_ONCE(vcpu->arch.smi_pending) && !is_smm(vcpu)))
+		return true;
+
+	if (kvm_test_request(KVM_REQ_EVENT, vcpu))
+		return true;
+
+	if (vcpu->arch.apicv_active && kvm_x86_ops->apicv_test_pi_on(vcpu))
+		return true;
+
+	return false;
+}
+
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.preempted_in_kernel;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5c5b586..9e4c2bb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -872,6 +872,7 @@ int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
+bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index acc4324..2927895 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -444,6 +444,11 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 		&& !v->arch.power_off && !v->arch.pause);
 }
 
+bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
+{
+	return kvm_arch_vcpu_runnable(vcpu);
+}
+
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
 	return vcpu_mode_priv(vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 887f3b0..3e1a509 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2477,6 +2477,17 @@ static bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 #endif
 }
 
+static bool vcpu_runnable(struct kvm_vcpu *vcpu)
+{
+	if (kvm_arch_dy_runnable(vcpu))
+		return true;
+
+	if (!list_empty_careful(&vcpu->async_pf.done))
+		return true;
+
+	return false;
+}
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	struct kvm *kvm = me->kvm;
@@ -2506,7 +2517,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (vcpu == me)
 				continue;
-			if (swait_active(&vcpu->wq) && !kvm_arch_vcpu_runnable(vcpu))
+			if (swait_active(&vcpu->wq) && !vcpu_runnable(vcpu))
 				continue;
 			if (yield_to_kernel_mode && !kvm_arch_vcpu_in_kernel(vcpu))
 				continue;
-- 
2.7.4

