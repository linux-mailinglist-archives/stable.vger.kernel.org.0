Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E186E640B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjDRMpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbjDRMpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:45:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673F914F40
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0433563390
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1138BC433EF;
        Tue, 18 Apr 2023 12:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821937;
        bh=a8C0r4wV1znHI74rJHSmwQW3XHgNQQZ4qD5S/pj1CXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/zOVsTqYr9qIgoJxHTU3YBTB5YfPv+KsjYZSkB1FrozNePaCCnfBFyy7a90T/YgK
         kI7kGDmtxrXmYzDvUSCOP6Uu+rQkSxPkIhytHSUgqphMiJTXW1+uvLU53m6TR35WNJ
         eoGAGsjABWcz6JuZSaSfK6dRpfwR5XMb8TnAH6qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/134] KVM: SVM: Add a proper field for Hyper-V VMCB enlightenments
Date:   Tue, 18 Apr 2023 14:22:32 +0200
Message-Id: <20230418120316.525464432@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 68ae7c7bc56a4504ed5efde7c2f8d6024148a35e ]

Add a union to provide hv_enlightenments side-by-side with the sw_reserved
bytes that Hyper-V's enlightenments overlay.  Casting sw_reserved
everywhere is messy, confusing, and unnecessarily unsafe.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20221101145426.251680-4-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e5c972c1fada ("KVM: SVM: Flush Hyper-V TLB when required")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/svm.h                        |  7 ++++++-
 arch/x86/kvm/svm/nested.c                         |  9 ++++-----
 arch/x86/kvm/svm/svm.h                            |  5 ++++-
 arch/x86/kvm/svm/svm_onhyperv.c                   |  2 +-
 arch/x86/kvm/svm/svm_onhyperv.h                   | 15 +++++++--------
 tools/testing/selftests/kvm/include/x86_64/svm.h  |  5 ++++-
 .../selftests/kvm/x86_64/hyperv_svm_test.c        |  3 +--
 7 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 236fda748ae96..98724e7c7a6e8 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -5,6 +5,8 @@
 #include <uapi/asm/svm.h>
 #include <uapi/asm/kvm.h>
 
+#include <asm/hyperv-tlfs.h>
+
 /*
  * 32-bit intercept words in the VMCB Control Area, starting
  * at Byte offset 000h.
@@ -161,7 +163,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
 	 */
-	u8 reserved_sw[32];
+	union {
+		struct hv_enlightenments hv_enlightenments;
+		u8 reserved_sw[32];
+	};
 };
 
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0be104ec79d96..eb5792367cc6b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -179,8 +179,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
  */
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
+	struct hv_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
 	int i;
 
 	/*
@@ -369,8 +368,8 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	/* Hyper-V extensions (Enlightened VMCB) */
 	if (kvm_hv_hypercall_enabled(vcpu)) {
 		to->clean = from->clean;
-		memcpy(to->reserved_sw, from->reserved_sw,
-		       sizeof(struct hv_enlightenments));
+		memcpy(&to->hv_enlightenments, &from->hv_enlightenments,
+		       sizeof(to->hv_enlightenments));
 	}
 }
 
@@ -1485,7 +1484,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->virt_ext              = from->virt_ext;
 	dst->pause_filter_count   = from->pause_filter_count;
 	dst->pause_filter_thresh  = from->pause_filter_thresh;
-	/* 'clean' and 'reserved_sw' are not changed by KVM */
+	/* 'clean' and 'hv_enlightenments' are not changed by KVM */
 }
 
 static int svm_get_nested_state(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bbc061f3a2b37..e7a22e45a7d33 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -151,7 +151,10 @@ struct vmcb_ctrl_area_cached {
 	u64 nested_cr3;
 	u64 virt_ext;
 	u32 clean;
-	u8 reserved_sw[32];
+	union {
+		struct hv_enlightenments hv_enlightenments;
+		u8 reserved_sw[32];
+	};
 };
 
 struct svm_nested_state {
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index ed5e793925441..422d00fee24ab 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -26,7 +26,7 @@ int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 	if (!*p_hv_pa_pg)
 		return -ENOMEM;
 
-	hve = (struct hv_enlightenments *)to_svm(vcpu)->vmcb->control.reserved_sw;
+	hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
 
 	hve->partition_assist_page = __pa(*p_hv_pa_pg);
 	hve->hv_vm_id = (unsigned long)vcpu->kvm;
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index 35d69815d2f3a..51030df538ef5 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -17,8 +17,10 @@ int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
 
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
+
+	BUILD_BUG_ON(sizeof(vmcb->control.hv_enlightenments) !=
+		     sizeof(vmcb->control.reserved_sw));
 
 	if (npt_enabled &&
 	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
@@ -60,18 +62,15 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 		struct kvm_vcpu *vcpu)
 {
 	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	if (hve->hv_enlightenments_control.msr_bitmap)
 		vmcb_mark_dirty(vmcb, HV_VMCB_NESTED_ENLIGHTENMENTS);
 }
 
-static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
-		struct kvm_vcpu *vcpu)
+static inline void svm_hv_update_vp_id(struct vmcb *vmcb, struct kvm_vcpu *vcpu)
 {
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
 	u32 vp_index = kvm_hv_get_vpindex(vcpu);
 
 	if (hve->hv_vp_id != vp_index) {
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86_64/svm.h
index 89ce2c6b57fe0..6e1527aa34191 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
@@ -123,7 +123,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
 	 */
-	u8 reserved_sw[32];
+	union {
+		struct hv_enlightenments hv_enlightenments;
+		u8 reserved_sw[32];
+	};
 };
 
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 2fd64b419928a..8ef6a4c83cb1e 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -46,8 +46,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	struct vmcb *vmcb = svm->vmcb;
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	GUEST_SYNC(1);
 
-- 
2.39.2



