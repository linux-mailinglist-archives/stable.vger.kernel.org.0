Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDFD6E640D
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbjDRMpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjDRMps (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:45:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C599314F41
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EF4D63390
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70406C433EF;
        Tue, 18 Apr 2023 12:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821945;
        bh=ZxYjEAXnh6dd0quJt0fvqUhN3yT3k7n1azYESX6nDhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yl/bfpycRNVJOmeL+4+CR2X+DDFZOwfi9zKTcrWnhFn2V9duZ0W6P7VtkRVXYMoFy
         3Lc1KjzFUKsBXIWyxOgNpm3FLn4tgTkeeo96t+uK4yRofnUCJ/EIZDuFUf7U4p1eil
         fGqxRgnhrh2mTqnXIoVJia6jWdWGcck8exDoa+AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/134] KVM: SVM: Flush Hyper-V TLB when required
Date:   Tue, 18 Apr 2023 14:22:34 +0200
Message-Id: <20230418120316.593090666@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>

[ Upstream commit e5c972c1fadacc858b6a564d056f177275238040 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/kvm_onhyperv.h     |  5 +++++
 arch/x86/kvm/svm/svm.c          | 37 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm_onhyperv.h | 15 +++++++++++++
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 287e98ef9df3d..6272dabec02da 100644
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
index 3629dd979667c..9599931c7d572 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3719,7 +3719,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
 }
 
-static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3736,6 +3736,37 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
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
@@ -4733,10 +4764,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
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
index 780b6c09cfe4b..9a6a34149919c 100644
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
 
 int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
 
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
2.39.2



