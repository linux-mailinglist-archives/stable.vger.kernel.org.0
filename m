Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053046DEF79
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjDLIvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjDLIvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F609ED8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 296D96312E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D68FC433D2;
        Wed, 12 Apr 2023 08:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289441;
        bh=JFLHhSMSXYGuZz+WKuoMUdkm8+kexttvGEBCNwrEtXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMmxUHRrgIbSQThUhmnJcca5fBdWlHhuN3iPcrroTRmSlruFYS+wbpikquGN0gzhz
         CK7Fh1ngFTBRdc+81lZSc3Njxd5wD8R/WmsQLSBcj09nOWsTSzwOuXBppVOZN4Y0O7
         eka8hDXfzy9prF1OZahjeSoDB874fj3YGC1vYy5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.2 101/173] KVM: SVM: Flush Hyper-V TLB when required
Date:   Wed, 12 Apr 2023 10:33:47 +0200
Message-Id: <20230412082842.164450040@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>

commit e5c972c1fadacc858b6a564d056f177275238040 upstream.

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
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20230324145233.4585-1-jpiotrowski@linux.microsoft.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/kvm_onhyperv.h     |    5 +++++
 arch/x86/kvm/svm/svm.c          |   37 ++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm_onhyperv.h |   15 +++++++++++++++
 3 files changed, 54 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -12,6 +12,11 @@ int hv_remote_flush_tlb_with_range(struc
 int hv_remote_flush_tlb(struct kvm *kvm);
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
 #else /* !CONFIG_HYPERV */
+static inline int hv_remote_flush_tlb(struct kvm *kvm)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
 }
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3718,7 +3718,7 @@ static void svm_enable_nmi_window(struct
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
 }
 
-static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3742,6 +3742,37 @@ static void svm_flush_tlb_current(struct
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
@@ -4747,10 +4778,10 @@ static struct kvm_x86_ops svm_x86_ops __
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
@@ -80,6 +90,11 @@ static inline void svm_hv_update_vp_id(s
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


