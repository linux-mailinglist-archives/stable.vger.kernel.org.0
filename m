Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BC459A499
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353941AbiHSQqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354136AbiHSQpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8648912A552;
        Fri, 19 Aug 2022 09:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B11CB82820;
        Fri, 19 Aug 2022 16:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E61C433C1;
        Fri, 19 Aug 2022 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925479;
        bh=5C3Gfc60t7LfNB1yaglLH3TLWAlCJlHGs06SifoQZOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNs/Yek9uo8pjH0kTURevD1Kc00nKf/lvQZyQxglFm3KOqXNpM2dZ9P1W47hgZS6f
         T1msiXrHUJbGwLvLbrPy5YkOILvm8KLRUHbp4Sk5CJyFzPtHR034MAYGc7iwDj8Yhf
         iivBWEd6rojN/e5SDLEJ/2lj0WZSk+HJXUWD/1N4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 502/545] KVM: x86: Move vendor CR4 validity check to dedicated kvm_x86_ops hook
Date:   Fri, 19 Aug 2022 17:44:32 +0200
Message-Id: <20220819153851.947810977@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit c2fe3cd4604ac87c587db05d41843d667dc43815 ]

Split out VMX's checks on CR4.VMXE to a dedicated hook, .is_valid_cr4(),
and invoke the new hook from kvm_valid_cr4().  This fixes an issue where
KVM_SET_SREGS would return success while failing to actually set CR4.

Fixing the issue by explicitly checking kvm_x86_ops.set_cr4()'s return
in __set_sregs() is not a viable option as KVM has already stuffed a
variety of vCPU state.

Note, kvm_valid_cr4() and is_valid_cr4() have different return types and
inverted semantics.  This will be remedied in a future patch.

Fixes: 5e1746d6205d ("KVM: nVMX: Allow setting the VMXE bit in CR4")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20201007014417.29276-5-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/svm/svm.c          |  9 +++++++--
 arch/x86/kvm/svm/svm.h          |  2 +-
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 31 ++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h          |  2 +-
 arch/x86/kvm/x86.c              |  6 ++++--
 7 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 94fbbdb888cf..87c13ef4ee8e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1117,7 +1117,8 @@ struct kvm_x86_ops {
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
-	int (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
+	bool (*is_valid_cr4)(struct kvm_vcpu *vcpu, unsigned long cr0);
+	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	int (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9bc166a5d453..442705517caf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1692,7 +1692,12 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	update_cr0_intercept(svm);
 }
 
-int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+static bool svm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	return true;
+}
+
+void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long host_cr4_mce = cr4_read_shadow() & X86_CR4_MCE;
 	unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;
@@ -1706,7 +1711,6 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	cr4 |= host_cr4_mce;
 	to_svm(vcpu)->vmcb->save.cr4 = cr4;
 	vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
-	return 0;
 }
 
 static void svm_set_segment(struct kvm_vcpu *vcpu,
@@ -4238,6 +4242,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_cpl = svm_get_cpl,
 	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
 	.set_cr0 = svm_set_cr0,
+	.is_valid_cr4 = svm_is_valid_cr4,
 	.set_cr4 = svm_set_cr4,
 	.set_efer = svm_set_efer,
 	.get_idt = svm_get_idt,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2c007241fbf5..10aba1dd264e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -355,7 +355,7 @@ void svm_vcpu_free_msrpm(u32 *msrpm);
 
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void svm_flush_tlb(struct kvm_vcpu *vcpu);
 void disable_nmi_singlestep(struct vcpu_svm *svm);
 bool svm_smi_blocked(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c4e37d81b158..3228db4db5df 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4879,7 +4879,7 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
 	/*
 	 * The Intel VMX Instruction Reference lists a bunch of bits that are
 	 * prerequisite to running VMXON, most notably cr4.VMXE must be set to
-	 * 1 (see vmx_set_cr4() for when we allow the guest to set this).
+	 * 1 (see vmx_is_valid_cr4() for when we allow the guest to set this).
 	 * Otherwise, we should fail with #UD.  But most faulting conditions
 	 * have already been checked by hardware, prior to the VM-exit for
 	 * VMXON.  We do test guest cr4.VMXE because processor CR4 always has
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 154ec5d8cdf5..b33d0f283d4f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3183,7 +3183,23 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
-int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	/*
+	 * We operate under the default treatment of SMM, so VMX cannot be
+	 * enabled under SMM.  Note, whether or not VMXE is allowed at all is
+	 * handled by kvm_valid_cr4().
+	 */
+	if ((cr4 & X86_CR4_VMXE) && is_smm(vcpu))
+		return false;
+
+	if (to_vmx(vcpu)->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
+		return false;
+
+	return true;
+}
+
+void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	/*
@@ -3211,17 +3227,6 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		}
 	}
 
-	/*
-	 * We operate under the default treatment of SMM, so VMX cannot be
-	 * enabled under SMM.  Note, whether or not VMXE is allowed at all is
-	 * handled by kvm_valid_cr4().
-	 */
-	if ((cr4 & X86_CR4_VMXE) && is_smm(vcpu))
-		return 1;
-
-	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
-		return 1;
-
 	vcpu->arch.cr4 = cr4;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR4);
 
@@ -3252,7 +3257,6 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	vmcs_writel(CR4_READ_SHADOW, cr4);
 	vmcs_writel(GUEST_CR4, hw_cr4);
-	return 0;
 }
 
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
@@ -7748,6 +7752,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_cpl = vmx_get_cpl,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.set_cr0 = vmx_set_cr0,
+	.is_valid_cr4 = vmx_is_valid_cr4,
 	.set_cr4 = vmx_set_cr4,
 	.set_efer = vmx_set_efer,
 	.get_idt = vmx_get_idt,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a6b52d3a39c9..24903f05c204 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -347,7 +347,7 @@ u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu);
 void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask);
 int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx);
 void ept_save_pdptrs(struct kvm_vcpu *vcpu);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 98422a53bb1e..5f4f855bb3b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -986,6 +986,9 @@ int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
 		return -EINVAL;
 
+	if (!kvm_x86_ops.is_valid_cr4(vcpu, cr4))
+		return -EINVAL;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_valid_cr4);
@@ -1020,8 +1023,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
-	if (kvm_x86_ops.set_cr4(vcpu, cr4))
-		return 1;
+	kvm_x86_ops.set_cr4(vcpu, cr4);
 
 	if (((cr4 ^ old_cr4) & mmu_role_bits) ||
 	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
-- 
2.35.1



