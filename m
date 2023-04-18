Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0297B6E6409
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjDRMph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjDRMpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:45:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2617014F47
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:45:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B64A163392
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DE0C433EF;
        Tue, 18 Apr 2023 12:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821932;
        bh=mTw7pS+E56UDl04SnmlegHvLQWsAqfxXNPj99ME7320=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ApXYiqZv4zmpRLlkpd/NmtXt4A5GfI3MwlHdduC3XQu/LK8qlHGuAgk1xhteX4MWs
         Tep/lkEP2AfSewR5VwcBEq+4DrWeR/miO/FsN+ffKbCXMhRpu/D1PUX3P6n4bRj2eV
         I1MC4lOLpPeAn+kb70aL5lnED1iRaDqelUDISrTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/134] x86/hyperv: Move VMCB enlightenment definitions to hyperv-tlfs.h
Date:   Tue, 18 Apr 2023 14:22:30 +0200
Message-Id: <20230418120316.456770863@linuxfoundation.org>
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

[ Upstream commit 089fe572a2e0a89e36a455d299d801770293d08f ]

Move Hyper-V's VMCB enlightenment definitions to the TLFS header; the
definitions come directly from the TLFS[*], not from KVM.

No functional change intended.

[*] https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_svm_enlightened_vmcb_fields

[vitaly: rename VMCB_HV_ -> HV_VMCB_ to match the rest of
hyperv-tlfs.h, keep svm/hyperv.h]

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20221101145426.251680-2-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e5c972c1fada ("KVM: SVM: Flush Hyper-V TLB when required")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/hyperv-tlfs.h            | 22 +++++++++++++++++++
 arch/x86/kvm/svm/hyperv.h                     | 22 -------------------
 arch/x86/kvm/svm/nested.c                     |  2 +-
 arch/x86/kvm/svm/svm_onhyperv.c               |  2 +-
 arch/x86/kvm/svm/svm_onhyperv.h               |  4 ++--
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  6 ++---
 6 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 3089ec352743b..245a806a97170 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -598,6 +598,28 @@ struct hv_enlightened_vmcs {
 
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL			0xFFFF
 
+/*
+ * Hyper-V uses the software reserved 32 bytes in VMCB control area to expose
+ * SVM enlightenments to guests.
+ */
+struct hv_enlightenments {
+	struct __packed hv_enlightenments_control {
+		u32 nested_flush_hypercall:1;
+		u32 msr_bitmap:1;
+		u32 enlightened_npt_tlb: 1;
+		u32 reserved:29;
+	} __packed hv_enlightenments_control;
+	u32 hv_vp_id;
+	u64 hv_vm_id;
+	u64 partition_assist_page;
+	u64 reserved;
+} __packed;
+
+/*
+ * Hyper-V uses the software reserved clean bit in VMCB.
+ */
+#define HV_VMCB_NESTED_ENLIGHTENMENTS		31
+
 struct hv_partition_assist_pg {
 	u32 tlb_lock_count;
 };
diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index 7d6d97968fb98..c59544cdf03b7 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -10,26 +10,4 @@
 
 #include "../hyperv.h"
 
-/*
- * Hyper-V uses the software reserved 32 bytes in VMCB
- * control area to expose SVM enlightenments to guests.
- */
-struct hv_enlightenments {
-	struct __packed hv_enlightenments_control {
-		u32 nested_flush_hypercall:1;
-		u32 msr_bitmap:1;
-		u32 enlightened_npt_tlb: 1;
-		u32 reserved:29;
-	} __packed hv_enlightenments_control;
-	u32 hv_vp_id;
-	u64 hv_vm_id;
-	u64 partition_assist_page;
-	u64 reserved;
-} __packed;
-
-/*
- * Hyper-V uses the software reserved clean bit in VMCB
- */
-#define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
-
 #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 995bc0f907591..0be104ec79d96 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -194,7 +194,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	if (!svm->nested.force_msr_bitmap_recalc &&
 	    kvm_hv_hypercall_enabled(&svm->vcpu) &&
 	    hve->hv_enlightenments_control.msr_bitmap &&
-	    (svm->nested.ctl.clean & BIT(VMCB_HV_NESTED_ENLIGHTENMENTS)))
+	    (svm->nested.ctl.clean & BIT(HV_VMCB_NESTED_ENLIGHTENMENTS)))
 		goto set_msrpm_base_pa;
 
 	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 8cdc62c74a964..ed5e793925441 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -32,7 +32,7 @@ int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 	hve->hv_vm_id = (unsigned long)vcpu->kvm;
 	if (!hve->hv_enlightenments_control.nested_flush_hypercall) {
 		hve->hv_enlightenments_control.nested_flush_hypercall = 1;
-		vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+		vmcb_mark_dirty(to_svm(vcpu)->vmcb, HV_VMCB_NESTED_ENLIGHTENMENTS);
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index 4387173576d5e..35d69815d2f3a 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -64,7 +64,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 		(struct hv_enlightenments *)vmcb->control.reserved_sw;
 
 	if (hve->hv_enlightenments_control.msr_bitmap)
-		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+		vmcb_mark_dirty(vmcb, HV_VMCB_NESTED_ENLIGHTENMENTS);
 }
 
 static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
@@ -76,7 +76,7 @@ static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
 
 	if (hve->hv_vp_id != vp_index) {
 		hve->hv_vp_id = vp_index;
-		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+		vmcb_mark_dirty(vmcb, HV_VMCB_NESTED_ENLIGHTENMENTS);
 	}
 }
 #else
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index a380ad7bb9b34..5060fcfe17601 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -39,7 +39,7 @@ struct hv_enlightenments {
 /*
  * Hyper-V uses the software reserved clean bit in VMCB
  */
-#define VMCB_HV_NESTED_ENLIGHTENMENTS (1U << 31)
+#define HV_VMCB_NESTED_ENLIGHTENMENTS (1U << 31)
 
 void l2_guest_code(void)
 {
@@ -98,14 +98,14 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
 	/* Intercept RDMSR 0xc0000101 without telling KVM about it */
 	set_bit(2 * (MSR_GS_BASE & 0x1fff), svm->msr + 0x800);
 	/* Make sure HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP is set */
-	vmcb->control.clean |= VMCB_HV_NESTED_ENLIGHTENMENTS;
+	vmcb->control.clean |= HV_VMCB_NESTED_ENLIGHTENMENTS;
 	run_guest(vmcb, svm->vmcb_gpa);
 	/* Make sure we don't see SVM_EXIT_MSR here so eMSR bitmap works */
 	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
 	vmcb->save.rip += 3; /* vmcall */
 
 	/* Now tell KVM we've changed MSR-Bitmap */
-	vmcb->control.clean &= ~VMCB_HV_NESTED_ENLIGHTENMENTS;
+	vmcb->control.clean &= ~HV_VMCB_NESTED_ENLIGHTENMENTS;
 	run_guest(vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
 	vmcb->save.rip += 2; /* rdmsr */
-- 
2.39.2



