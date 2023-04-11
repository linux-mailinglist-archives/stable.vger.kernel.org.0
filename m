Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD726DD8A1
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjDKLBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjDKLBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:01:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EC94497
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 04:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6623E621D7
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 11:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7962FC4339C;
        Tue, 11 Apr 2023 11:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681210882;
        bh=f+K3hEpPyQbiV6GuBj15LZrOkX2xN9MAF/42E/gzRwA=;
        h=Subject:To:Cc:From:Date:From;
        b=xaNodu2e4oiF/nU8mDMpWEVNbyear9v3CKc24J4LBcx64Tu1hd4he/UhQZewPd0yq
         ebp0fk+m05xFK9mLfJFnIEpehOYXNQdaoN/TKQUFOyNBZuKFoZOY9K8/86HhbkIZB7
         y66IAC41sBQ1zS50zxg6lanH3bCcLzM779jF1rFE=
Subject: FAILED: patch "[PATCH] KVM: SVM: Flush Hyper-V TLB when required" failed to apply to 5.15-stable tree
To:     jpiotrowski@linux.microsoft.com, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 13:01:20 +0200
Message-ID: <2023041120-hesitant-rekindle-faac@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x e5c972c1fadacc858b6a564d056f177275238040
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041120-hesitant-rekindle-faac@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

e5c972c1fada ("KVM: SVM: Flush Hyper-V TLB when required")
5be2226f417d ("KVM: x86: allow defining return-0 static calls")
abb6d479e226 ("KVM: x86: make several APIC virtualization callbacks optional")
dd2319c61888 ("KVM: x86: warn on incorrectly NULL members of kvm_x86_ops")
e4fc23bad813 ("KVM: x86: remove KVM_X86_OP_NULL and mark optional kvm_x86_ops")
8a2897853c53 ("KVM: x86: return 1 unconditionally for availability of KVM_CAP_VAPIC")
db6e7adf8de9 ("KVM: SVM: Rename AVIC helpers to use "avic" prefix instead of "svm"")
4e71cad31c62 ("Merge remote-tracking branch 'kvm/master' into HEAD")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e5c972c1fadacc858b6a564d056f177275238040 Mon Sep 17 00:00:00 2001
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Date: Fri, 24 Mar 2023 15:52:33 +0100
Subject: [PATCH] KVM: SVM: Flush Hyper-V TLB when required

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

diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 287e98ef9df3..6272dabec02d 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -12,6 +12,11 @@ int hv_remote_flush_tlb_with_range(struct kvm *kvm,
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

