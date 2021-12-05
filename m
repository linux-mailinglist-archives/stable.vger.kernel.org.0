Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522CB468AD3
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhLEMj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:39:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39768 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhLEMj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:39:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DAC5B80E2A
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47582C341C1;
        Sun,  5 Dec 2021 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638707789;
        bh=qlKjdeJVoMhsIL6uEZJ649Vc4zGd5wWajbwwa3iWSGI=;
        h=Subject:To:Cc:From:Date:From;
        b=ZrwjagpdaqsNUnX54MJX4nlHbrzFjU4vJ9EURxlgy+SrIiZxo52ZiaTsPou8tpRDl
         p4eybdsNG81QBk/QAZ7v6fBLk9w9HPqroyYmzR1PXQ2tF38f9dyoo4u/l3YGGkwF7A
         X2NgN9Turrrim59ydZ8UkELOFCn57ZoKtozOnFwQ=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Abide to KVM_REQ_TLB_FLUSH_GUEST request on nested" failed to apply to 5.10-stable tree
To:     seanjc@google.com, jiangshanlai+lkml@gmail.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 13:36:26 +0100
Message-ID: <163870778685193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 40e5f9080472b614eeedcc5ba678289cd98d70df Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Nov 2021 01:49:43 +0000
Subject: [PATCH] KVM: nVMX: Abide to KVM_REQ_TLB_FLUSH_GUEST request on nested
 vmentry/vmexit

Like KVM_REQ_TLB_FLUSH_CURRENT, the GUEST variant needs to be serviced at
nested transitions, as KVM doesn't track requests for L1 vs L2.  E.g. if
there's a pending flush when a nested VM-Exit occurs, then the flush was
requested in the context of L2 and needs to be handled before switching
to L1, otherwise the flush for L2 would effectiely be lost.

Opportunistically add a helper to handle CURRENT and GUEST as a pair, the
logic for when they need to be serviced is identical as both requests are
tied to L1 vs. L2, the only difference is the scope of the flush.

Reported-by: Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Fixes: 07ffaf343e34 ("KVM: nVMX: Sync all PGDs on nested transition with shadow paging")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211125014944.536398-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 315fa456d368..8e55aaef33ee 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3344,8 +3344,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	};
 	u32 failed_index;
 
-	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
-		kvm_vcpu_flush_tlb_current(vcpu);
+	kvm_service_local_tlb_flush_requests(vcpu);
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
 		(CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITING);
@@ -4502,9 +4501,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		(void)nested_get_evmcs_page(vcpu);
 	}
 
-	/* Service the TLB flush request for L2 before switching to L1. */
-	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
-		kvm_vcpu_flush_tlb_current(vcpu);
+	/* Service pending TLB flush requests for L2 before switching to L1. */
+	kvm_service_local_tlb_flush_requests(vcpu);
 
 	/*
 	 * VCPU_EXREG_PDPTR will be clobbered in arch/x86/kvm/vmx/vmx.h between
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 30c4d72bf717..028151c309c9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3258,6 +3258,29 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_tlb_flush_guest)(vcpu);
 }
 
+
+static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	++vcpu->stat.tlb_flush;
+	static_call(kvm_x86_tlb_flush_current)(vcpu);
+}
+
+/*
+ * Service "local" TLB flush requests, which are specific to the current MMU
+ * context.  In addition to the generic event handling in vcpu_enter_guest(),
+ * TLB flushes that are targeted at an MMU context also need to be serviced
+ * prior before nested VM-Enter/VM-Exit.
+ */
+void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
+{
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
+		kvm_vcpu_flush_tlb_current(vcpu);
+
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
+		kvm_vcpu_flush_tlb_guest(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
+
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
@@ -9649,10 +9672,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			/* Flushing all ASIDs flushes the current ASID... */
 			kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}
-		if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
-			kvm_vcpu_flush_tlb_current(vcpu);
-		if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
-			kvm_vcpu_flush_tlb_guest(vcpu);
+		kvm_service_local_tlb_flush_requests(vcpu);
 
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 997669ae9caa..4abcd8d9836d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -103,6 +103,7 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
 
 #define MSR_IA32_CR_PAT_DEFAULT  0x0007040600070406ULL
 
+void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
 int kvm_check_nested_events(struct kvm_vcpu *vcpu);
 
 static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
@@ -185,12 +186,6 @@ static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)
 	return vcpu->arch.walk_mmu == &vcpu->arch.nested_mmu;
 }
 
-static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
-{
-	++vcpu->stat.tlb_flush;
-	static_call(kvm_x86_tlb_flush_current)(vcpu);
-}
-
 static inline int is_pae(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr4_bits(vcpu, X86_CR4_PAE);

