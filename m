Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D662469D84
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386842AbhLFPaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:30:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44758 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354377AbhLFP13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:27:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E1DF612D7;
        Mon,  6 Dec 2021 15:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34740C341C1;
        Mon,  6 Dec 2021 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804239;
        bh=vrnUxk8I/aFcX4aIhNAUb34z2oU8xLyMLFCPwCvALH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTlH+pE7k741/qZL/ZKjyzpu+xXKtDT2DPl1Cve/IwLrXJbK1DrBeZ0h64b7lWSuJ
         aYBBAMkA59BhsuFPf9F1EtVKO1AvWY9GZ3g8dkoHjGUIJ9obb74KqSO7yAzYv3u2Rb
         dcCPbQU4RMfMHDlojGj5hsfyIxanO/9CMHc0gu5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 077/207] KVM: nVMX: Abide to KVM_REQ_TLB_FLUSH_GUEST request on nested vmentry/vmexit
Date:   Mon,  6 Dec 2021 15:55:31 +0100
Message-Id: <20211206145612.898996758@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 40e5f9080472b614eeedcc5ba678289cd98d70df upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    8 +++-----
 arch/x86/kvm/x86.c        |   28 ++++++++++++++++++++++++----
 arch/x86/kvm/x86.h        |    7 +------
 3 files changed, 28 insertions(+), 15 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3355,8 +3355,7 @@ enum nvmx_vmentry_status nested_vmx_ente
 	};
 	u32 failed_index;
 
-	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
-		kvm_vcpu_flush_tlb_current(vcpu);
+	kvm_service_local_tlb_flush_requests(vcpu);
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
 		(CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITING);
@@ -4513,9 +4512,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *
 		(void)nested_get_evmcs_page(vcpu);
 	}
 
-	/* Service the TLB flush request for L2 before switching to L1. */
-	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
-		kvm_vcpu_flush_tlb_current(vcpu);
+	/* Service pending TLB flush requests for L2 before switching to L1. */
+	kvm_service_local_tlb_flush_requests(vcpu);
 
 	/*
 	 * VCPU_EXREG_PDPTR will be clobbered in arch/x86/kvm/vmx/vmx.h between
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3193,6 +3193,29 @@ static void kvm_vcpu_flush_tlb_guest(str
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
@@ -9530,10 +9553,7 @@ static int vcpu_enter_guest(struct kvm_v
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
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -103,6 +103,7 @@ static inline unsigned int __shrink_ple_
 
 #define MSR_IA32_CR_PAT_DEFAULT  0x0007040600070406ULL
 
+void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
 int kvm_check_nested_events(struct kvm_vcpu *vcpu);
 
 static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
@@ -185,12 +186,6 @@ static inline bool mmu_is_nested(struct
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


