Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC336C2103
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 20:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjCTTOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 15:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjCTTNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 15:13:50 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ACADA59EE;
        Mon, 20 Mar 2023 12:06:21 -0700 (PDT)
Received: from vm02.corp.microsoft.com (unknown [167.220.197.27])
        by linux.microsoft.com (Postfix) with ESMTPSA id AE27C20FAEF1;
        Mon, 20 Mar 2023 11:52:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AE27C20FAEF1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1679338324;
        bh=P4awLpw/X0x2t72TtvT/y073iWhEjiFVTPr3bgWWreU=;
        h=From:To:Cc:Subject:Date:From;
        b=j3pVt5NkfHpd7YYIOo2ZiJG1nNe1yVyitay7fcotoJzk/5NlhKsRQdEqPdwJ4y248
         dgt6OXzfi4QuTCPt07WdHtCAKKPtnS+TXSfoYFbxEFgOA28Wxc0xxw24Wq5Ap/WW5H
         TmNun7CAVGIKyH6UBr6gbUrL7p2K3N7xIwXUD/kU=
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>, stable@vger.kernel.org
Subject: [PATCH] KVM: SVM: Flush Hyper-V TLB when required
Date:   Mon, 20 Mar 2023 18:51:10 +0000
Message-Id: <20230320185110.1346829-1-jpiotrowski@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Hyper-V "EnlightenedNptTlb" enlightenment is always enabled when KVM
is running on top of Hyper-V and Hyper-V exposes support for it (which
is always). On AMD CPUs this enlightenment results in ASID invalidations
not flushing TLB entries derived from the NPT. To force the underlying
(L0) hypervisor to rebuild its shadow page tables, an explicit hypercall
is needed.

The original KVM implementation of Hyper-V's "EnlightenedNptTlb" on SVM
only added remote TLB flush hooks. This worked out fine for a while, as
sufficient remote TLB flushes where being issued in KVM to mask the
problem. Since v5.17, changes in the TDP code reduced the number of
flushes and the out-of-sync TLB prevents guests from booting
successfully.

Split svm_flush_tlb_current() into separate callbacks for the 3 cases
(guest/all/current), and issue the required Hyper-V hypercall when a
Hyper-V TLB flush is needed. The most important case where the TLB flush
was missing is when loading a new PGD, which is followed by what is now
svm_flush_tlb_current(). Since the hypercall acts on all CPUs, cache the
last flushed root in kvm_arch->hv_root_tdp. This prevents the shadow
NPTs from being unnecessarily rebuilt for multiple vcpus and when the
same root is flushed multiple times in a row on a single vcpu.

Cc: stable@vger.kernel.org # v5.17+
Fixes: 1e0c7d40758b ("KVM: SVM: hyper-v: Remote TLB flush for SVM")
Link: https://lore.kernel.org/lkml/43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
---
 arch/x86/kvm/kvm_onhyperv.c | 23 +++++++++++++++++++++++
 arch/x86/kvm/kvm_onhyperv.h |  5 +++++
 arch/x86/kvm/svm/svm.c      | 18 +++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
index 482d6639ef88..036e04c0a161 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -94,6 +94,29 @@ int hv_remote_flush_tlb(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(hv_remote_flush_tlb);
 
+void hv_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
+	hpa_t root_tdp = vcpu->arch.mmu->root.hpa;
+
+	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb && VALID_PAGE(root_tdp)) {
+		spin_lock(&kvm_arch->hv_root_tdp_lock);
+		if (kvm_arch->hv_root_tdp != root_tdp) {
+			hyperv_flush_guest_mapping(root_tdp);
+			kvm_arch->hv_root_tdp = root_tdp;
+		}
+		spin_unlock(&kvm_arch->hv_root_tdp_lock);
+	}
+}
+EXPORT_SYMBOL_GPL(hv_flush_tlb_current);
+
+void hv_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+	if (WARN_ON_ONCE(kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb))
+		hv_remote_flush_tlb(vcpu->kvm);
+}
+EXPORT_SYMBOL_GPL(hv_flush_tlb_all);
+
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
 	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 287e98ef9df3..f24d0ca41d2b 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -10,11 +10,16 @@
 int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 		struct kvm_tlb_range *range);
 int hv_remote_flush_tlb(struct kvm *kvm);
+void hv_flush_tlb_current(struct kvm_vcpu *vcpu);
+void hv_flush_tlb_all(struct kvm_vcpu *vcpu);
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
 #else /* !CONFIG_HYPERV */
 static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
 }
+
+static inline void hv_flush_tlb_current(struct kvm_vcpu *vcpu) { }
+static inline void hv_flush_tlb_all(struct kvm_vcpu *vcpu) { }
 #endif /* !CONFIG_HYPERV */
 
 #endif
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 252e7f37e4e2..8da6740ef595 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3729,7 +3729,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
 }
 
-static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3753,6 +3753,18 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 		svm->current_vmcb->asid_generation--;
 }
 
+static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	hv_flush_tlb_current(vcpu);
+	svm_flush_tlb_asid(vcpu);
+}
+
+static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+	hv_flush_tlb_all(vcpu);
+	svm_flush_tlb_asid(vcpu);
+}
+
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4745,10 +4757,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_rflags = svm_set_rflags,
 	.get_if_flag = svm_get_if_flag,
 
-	.flush_tlb_all = svm_flush_tlb_current,
+	.flush_tlb_all = svm_flush_tlb_all,
 	.flush_tlb_current = svm_flush_tlb_current,
 	.flush_tlb_gva = svm_flush_tlb_gva,
-	.flush_tlb_guest = svm_flush_tlb_current,
+	.flush_tlb_guest = svm_flush_tlb_asid,
 
 	.vcpu_pre_run = svm_vcpu_pre_run,
 	.vcpu_run = svm_vcpu_run,
-- 
2.37.2

