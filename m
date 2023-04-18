Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332416E640C
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjDRMpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjDRMpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:45:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AF614F44
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:45:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B674F63397
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66BEC433D2;
        Tue, 18 Apr 2023 12:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821943;
        bh=oxQxEZ6dQ4q2doEio6deP0P2Mnn5VSEZf2n+kFwytVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7ELcBhwnmvtBMJdup+X+sWlrhc9c4KRX2LcUSOXpxSC7BUFbZpIDh5uUdVbo6/4D
         O2EcPFYk4G6yXROKA8h8oG0viEdHFqt51dkq7d5QrDFfVeVISvATP58AAutzT+6Czs
         RZox6YhBiA1d7/nZ9h9OHnPtdWdmgsZtIkBkhv2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/134] x86/hyperv: KVM: Rename "hv_enlightenments" to "hv_vmcb_enlightenments"
Date:   Tue, 18 Apr 2023 14:22:33 +0200
Message-Id: <20230418120316.563587987@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 26b516bb39215cf60aa1fb55d0a6fd73058698fa ]

Now that KVM isn't littered with "struct hv_enlightenments" casts, rename
the struct to "hv_vmcb_enlightenments" to highlight the fact that the
struct is specifically for SVM's VMCB.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20221101145426.251680-5-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e5c972c1fada ("KVM: SVM: Flush Hyper-V TLB when required")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/hyperv-tlfs.h                   | 2 +-
 arch/x86/include/asm/svm.h                           | 2 +-
 arch/x86/kvm/svm/nested.c                            | 2 +-
 arch/x86/kvm/svm/svm.h                               | 2 +-
 arch/x86/kvm/svm/svm_onhyperv.c                      | 2 +-
 arch/x86/kvm/svm/svm_onhyperv.h                      | 6 +++---
 tools/testing/selftests/kvm/include/x86_64/svm.h     | 4 ++--
 tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c | 2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 245a806a97170..c5e0e5a06c0dc 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -602,7 +602,7 @@ struct hv_enlightened_vmcs {
  * Hyper-V uses the software reserved 32 bytes in VMCB control area to expose
  * SVM enlightenments to guests.
  */
-struct hv_enlightenments {
+struct hv_vmcb_enlightenments {
 	struct __packed hv_enlightenments_control {
 		u32 nested_flush_hypercall:1;
 		u32 msr_bitmap:1;
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 98724e7c7a6e8..02aac78cb21d4 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -164,7 +164,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	 * for use by hypervisor/software.
 	 */
 	union {
-		struct hv_enlightenments hv_enlightenments;
+		struct hv_vmcb_enlightenments hv_enlightenments;
 		u8 reserved_sw[32];
 	};
 };
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index eb5792367cc6b..92268645a5fed 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -179,7 +179,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
  */
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
-	struct hv_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
+	struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
 	int i;
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e7a22e45a7d33..d0ed3f5952295 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -152,7 +152,7 @@ struct vmcb_ctrl_area_cached {
 	u64 virt_ext;
 	u32 clean;
 	union {
-		struct hv_enlightenments hv_enlightenments;
+		struct hv_vmcb_enlightenments hv_enlightenments;
 		u8 reserved_sw[32];
 	};
 };
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 422d00fee24ab..52c73a8be72b1 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -16,7 +16,7 @@
 
 int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 {
-	struct hv_enlightenments *hve;
+	struct hv_vmcb_enlightenments *hve;
 	struct hv_partition_assist_pg **p_hv_pa_pg =
 			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
 
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index 51030df538ef5..780b6c09cfe4b 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -17,7 +17,7 @@ int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
 
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
-	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
+	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	BUILD_BUG_ON(sizeof(vmcb->control.hv_enlightenments) !=
 		     sizeof(vmcb->control.reserved_sw));
@@ -62,7 +62,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 		struct kvm_vcpu *vcpu)
 {
 	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
-	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
+	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	if (hve->hv_enlightenments_control.msr_bitmap)
 		vmcb_mark_dirty(vmcb, HV_VMCB_NESTED_ENLIGHTENMENTS);
@@ -70,7 +70,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 
 static inline void svm_hv_update_vp_id(struct vmcb *vmcb, struct kvm_vcpu *vcpu)
 {
-	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
+	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
 	u32 vp_index = kvm_hv_get_vpindex(vcpu);
 
 	if (hve->hv_vp_id != vp_index) {
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86_64/svm.h
index 6e1527aa34191..483e6ae12f69e 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
@@ -58,7 +58,7 @@ enum {
 	INTERCEPT_RDPRU,
 };
 
-struct hv_enlightenments {
+struct hv_vmcb_enlightenments {
 	struct __packed hv_enlightenments_control {
 		u32 nested_flush_hypercall:1;
 		u32 msr_bitmap:1;
@@ -124,7 +124,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	 * for use by hypervisor/software.
 	 */
 	union {
-		struct hv_enlightenments hv_enlightenments;
+		struct hv_vmcb_enlightenments hv_enlightenments;
 		u8 reserved_sw[32];
 	};
 };
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 8ef6a4c83cb1e..1c3fc38b4f151 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -46,7 +46,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	struct vmcb *vmcb = svm->vmcb;
-	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
+	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	GUEST_SYNC(1);
 
-- 
2.39.2



