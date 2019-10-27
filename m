Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1124E68FA
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfJ0VMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730008AbfJ0VME (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:12:04 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47CBE205C9;
        Sun, 27 Oct 2019 21:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210723;
        bh=4Ce5rBZoOua/OoTPwPIKxJ3Gc5yMrdjZccCghVbMfAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tTpCNKFvIBHRna5jzn2Ty3UT245EqZYom3s51s/1g5DCEm5BvKBhgoW8BTE1ZUxA
         k90c52bZGxyS2UcAfGJU8dq7khe+fa18T7lYnewLR3RUVESWDKsMzHjzApneuDJEFo
         S2qYpD64z+w2+tPNc3A+GWL2GwwsYs2u9FFHU6iE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Jitindar SIngh, Suraj" <surajjs@amazon.com>,
        Wanpeng Li <wanpeng.li@hotmail.com>
Subject: [PATCH 4.14 115/119] KVM: X86: introduce invalidate_gpa argument to tlb flush
Date:   Sun, 27 Oct 2019 22:01:32 +0100
Message-Id: <20191027203349.831967407@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpeng.li@hotmail.com>

commit c2ba05ccfde2f069a66c0462e5b5ef8a517dcc9c upstream.

Introduce a new bool invalidate_gpa argument to kvm_x86_ops->tlb_flush,
it will be used by later patches to just flush guest tlb.

For VMX, this will use INVVPID instead of INVEPT, which will invalidate
combined mappings while keeping guest-physical mappings.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Jitindar SIngh, Suraj" <surajjs@amazon.com>
Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/svm.c              |   14 +++++++-------
 arch/x86/kvm/vmx.c              |   21 +++++++++++----------
 arch/x86/kvm/x86.c              |    6 +++---
 4 files changed, 22 insertions(+), 21 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -973,7 +973,7 @@ struct kvm_x86_ops {
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 
-	void (*tlb_flush)(struct kvm_vcpu *vcpu);
+	void (*tlb_flush)(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 
 	void (*run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -299,7 +299,7 @@ static int vgif = true;
 module_param(vgif, int, 0444);
 
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-static void svm_flush_tlb(struct kvm_vcpu *vcpu);
+static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
@@ -2097,7 +2097,7 @@ static int svm_set_cr4(struct kvm_vcpu *
 		return 1;
 
 	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
-		svm_flush_tlb(vcpu);
+		svm_flush_tlb(vcpu, true);
 
 	vcpu->arch.cr4 = cr4;
 	if (!npt_enabled)
@@ -2438,7 +2438,7 @@ static void nested_svm_set_tdp_cr3(struc
 
 	svm->vmcb->control.nested_cr3 = __sme_set(root);
 	mark_dirty(svm->vmcb, VMCB_NPT);
-	svm_flush_tlb(vcpu);
+	svm_flush_tlb(vcpu, true);
 }
 
 static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
@@ -3111,7 +3111,7 @@ static bool nested_svm_vmrun(struct vcpu
 	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
 	svm->nested.intercept            = nested_vmcb->control.intercept;
 
-	svm_flush_tlb(&svm->vcpu);
+	svm_flush_tlb(&svm->vcpu, true);
 	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
 	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
@@ -4947,7 +4947,7 @@ static int svm_set_tss_addr(struct kvm *
 	return 0;
 }
 
-static void svm_flush_tlb(struct kvm_vcpu *vcpu)
+static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -5288,7 +5288,7 @@ static void svm_set_cr3(struct kvm_vcpu
 
 	svm->vmcb->save.cr3 = __sme_set(root);
 	mark_dirty(svm->vmcb, VMCB_CR);
-	svm_flush_tlb(vcpu);
+	svm_flush_tlb(vcpu, true);
 }
 
 static void set_tdp_cr3(struct kvm_vcpu *vcpu, unsigned long root)
@@ -5302,7 +5302,7 @@ static void set_tdp_cr3(struct kvm_vcpu
 	svm->vmcb->save.cr3 = kvm_read_cr3(vcpu);
 	mark_dirty(svm->vmcb, VMCB_CR);
 
-	svm_flush_tlb(vcpu);
+	svm_flush_tlb(vcpu, true);
 }
 
 static int is_disabled(void)
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4427,9 +4427,10 @@ static void exit_lmode(struct kvm_vcpu *
 
 #endif
 
-static inline void __vmx_flush_tlb(struct kvm_vcpu *vcpu, int vpid)
+static inline void __vmx_flush_tlb(struct kvm_vcpu *vcpu, int vpid,
+				bool invalidate_gpa)
 {
-	if (enable_ept) {
+	if (enable_ept && (invalidate_gpa || !enable_vpid)) {
 		if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 			return;
 		ept_sync_context(construct_eptp(vcpu, vcpu->arch.mmu.root_hpa));
@@ -4438,15 +4439,15 @@ static inline void __vmx_flush_tlb(struc
 	}
 }
 
-static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
+static void vmx_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
 {
-	__vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid);
+	__vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid, invalidate_gpa);
 }
 
 static void vmx_flush_tlb_ept_only(struct kvm_vcpu *vcpu)
 {
 	if (enable_ept)
-		vmx_flush_tlb(vcpu);
+		vmx_flush_tlb(vcpu, true);
 }
 
 static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
@@ -4644,7 +4645,7 @@ static void vmx_set_cr3(struct kvm_vcpu
 		ept_load_pdptrs(vcpu);
 	}
 
-	vmx_flush_tlb(vcpu);
+	vmx_flush_tlb(vcpu, true);
 	vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
@@ -8314,7 +8315,7 @@ static int handle_invvpid(struct kvm_vcp
 		return kvm_skip_emulated_instruction(vcpu);
 	}
 
-	__vmx_flush_tlb(vcpu, vmx->nested.vpid02);
+	__vmx_flush_tlb(vcpu, vmx->nested.vpid02, true);
 	nested_vmx_succeed(vcpu);
 
 	return kvm_skip_emulated_instruction(vcpu);
@@ -11214,11 +11215,11 @@ static int prepare_vmcs02(struct kvm_vcp
 			vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->nested.vpid02);
 			if (vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
 				vmx->nested.last_vpid = vmcs12->virtual_processor_id;
-				__vmx_flush_tlb(vcpu, to_vmx(vcpu)->nested.vpid02);
+				__vmx_flush_tlb(vcpu, to_vmx(vcpu)->nested.vpid02, true);
 			}
 		} else {
 			vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
-			vmx_flush_tlb(vcpu);
+			vmx_flush_tlb(vcpu, true);
 		}
 
 	}
@@ -11921,7 +11922,7 @@ static void load_vmcs12_host_state(struc
 		 * L1's vpid. TODO: move to a more elaborate solution, giving
 		 * each L2 its own vpid and exposing the vpid feature to L1.
 		 */
-		vmx_flush_tlb(vcpu);
+		vmx_flush_tlb(vcpu, true);
 	}
 	/* Restore posted intr vector. */
 	if (nested_cpu_has_posted_intr(vmcs12))
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6943,10 +6943,10 @@ static void vcpu_scan_ioapic(struct kvm_
 	kvm_x86_ops->load_eoi_exitmap(vcpu, eoi_exit_bitmap);
 }
 
-static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
 {
 	++vcpu->stat.tlb_flush;
-	kvm_x86_ops->tlb_flush(vcpu);
+	kvm_x86_ops->tlb_flush(vcpu, invalidate_gpa);
 }
 
 void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
@@ -7017,7 +7017,7 @@ static int vcpu_enter_guest(struct kvm_v
 		if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
 			kvm_mmu_sync_roots(vcpu);
 		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
-			kvm_vcpu_flush_tlb(vcpu);
+			kvm_vcpu_flush_tlb(vcpu, true);
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
 			r = 0;


