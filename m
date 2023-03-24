Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFBB16C802A
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 15:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbjCXOpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 10:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjCXOpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 10:45:23 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23F4523112;
        Fri, 24 Mar 2023 07:45:13 -0700 (PDT)
Received: from localhost.localdomain (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id E308820FC442;
        Fri, 24 Mar 2023 07:45:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E308820FC442
From:   Jeremi Piotrowski <jpiotrowski@microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>, stable@vger.kernel.org
Subject: [PATCH v2] KVM: SVM: Flush Hyper-V TLB when required
Date:   Fri, 24 Mar 2023 15:45:00 +0100
Message-Id: <20230324144500.4216-1-jpiotrowski@microsoft.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>

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
svm_flush_tlb_current().

Cc: stable@vger.kernel.org # v5.17+
Fixes: 1e0c7d40758b ("KVM: SVM: hyper-v: Remote TLB flush for SVM")
Link: https://lore.kernel.org/lkml/43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
---
Changes since v1:
- lookup enlightened_npt_tlb in vmcb to determine whether to do the
  flush
- when KVM wants a hyperv_flush_guest_mapping() call, don't try to
  optimize it out
- don't hide hyperv flush behind helper, make it visible in
  svm.c

 arch/x86/kvm/kvm_onhyperv.h     |  5 +++++
 arch/x86/kvm/svm/svm.c          | 37 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm_onhyperv.h | 15 +++++++++++++
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 287e98ef9df3..67b53057e41c 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -12,6 +12,11 @@ int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 int hv_remote_flush_tlb(struct kvm *kvm);
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
 #else /* !CONFIG_HYPERV */
+static inline int hv_remote_flush_tlb(struct kvm *kvm)
+{
+	return -1;
+}
+
 static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 252e7f37e4e2..f25bc3cbb250 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3729,7 +3729,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
 }
 
-static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3753,6 +3753,37 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 		svm->current_vmcb->asid_generation--;
 }
 
+static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	hpa_t root_tdp = vcpu->arch.mmu->root.hpa;
+
+	/*
+	 * When running on Hyper-V with EnlightenedNptTlb enabled, explicitly
+	 * flush the NPT mappings via hypercall as flushing the ASID only
+	 * affects virtual to physical mappings, it does not invalidate guest
+	 * physical to host physical mappings.
+	 */
+	if (svm_hv_is_enlightened_tlb_enabled(vcpu) && VALID_PAGE(root_tdp))
+		hyperv_flush_guest_mapping(root_tdp);
+
+	svm_flush_tlb_asid(vcpu);
+}
+
+static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * When running on Hyper-V with EnlightenedNptTlb enabled, remote TLB
+	 * flushes should be routed to hv_remote_flush_tlb() without requesting
+	 * a "regular" remote flush.  Reaching this point means either there's
+	 * a KVM bug or a prior hv_remote_flush_tlb() call failed, both of
+	 * which might be fatal to the guest.  Yell, but try to recover.
+	 */
+	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
+		hv_remote_flush_tlb(vcpu->kvm);
+
+	svm_flush_tlb_asid(vcpu);
+}
+
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4745,10 +4776,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
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
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index cff838f15db5..786d46d73a8e 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -6,6 +6,8 @@
 #ifndef __ARCH_X86_KVM_SVM_ONHYPERV_H__
 #define __ARCH_X86_KVM_SVM_ONHYPERV_H__
 
+#include <asm/mshyperv.h>
+
 #if IS_ENABLED(CONFIG_HYPERV)
 
 #include "kvm_onhyperv.h"
@@ -15,6 +17,14 @@ static struct kvm_x86_ops svm_x86_ops;
 
 int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
 
+static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
+{
+	struct hv_vmcb_enlightenments *hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
+
+	return ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB &&
+	       !!hve->hv_enlightenments_control.enlightened_npt_tlb;
+}
+
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
 	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
@@ -80,6 +90,11 @@ static inline void svm_hv_update_vp_id(struct vmcb *vmcb, struct kvm_vcpu *vcpu)
 }
 #else
 
+static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
 }
-- 
2.37.2

