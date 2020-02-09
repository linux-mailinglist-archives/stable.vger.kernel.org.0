Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C3B156AA8
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgBINli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:41:38 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45293 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBINlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:41:37 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A9D1921DC1;
        Sun,  9 Feb 2020 08:41:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:41:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Z0WqVp
        sLaZhhPst6vJtnc/CK01zTSa/eZ039Gmvq/3Y=; b=ihNUuUy5uYPICX7ohBc+ko
        KKQIo9G+fnZDI2W16M1umWcmzqazf5bRX9nRwRVWHGJZPZe+F+J0PXdV7+Zfqtjc
        hY9jBF24mxvkNG+yMCUZmA/85Ajyx1RD5q7ePLVbeVe6ZeGzdgkQj5KnCZZAcM1m
        6drEvC2Z0KHoXRrFDwVDaPH21QOdAmQByJVmV5cdC+jQpi/MDpl/Db1QiZhUZb/Y
        b59bsrHQLhi1LfpNptcpSoXZTfw+fT7xGYuKRqEnaVpm8scfsBiIKjM41WGajTpf
        QPKLsERRmcc50LSpeb1hqsOq0fnLaWIcaq2cugXx1hTHOvBH+kpV9q2rPoztcIaA
        ==
X-ME-Sender: <xms:DwxAXrYYV6w4Vl495vL6XDemSdF0PGeM4KU_lrwjNeLt9NDbEFsKMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinheprghpfhdrhhhoshhtnecukfhppeefkedrleekrdefjedrudefhe
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:DwxAXur-Nd4ZRc7oUm-OtbtjVYQy1Eb1aY3srBUmVZCgaHDZLlQK2g>
    <xmx:DwxAXo-yZs0Ge9sOU7vbAfwalbsI9UZGsrcVyO2Y2UQx-vdse88BpA>
    <xmx:DwxAXl-K-WWR0I0JufEJCydHINR15z_IfgYjmJlOwDZtg1osv0c-Fg>
    <xmx:DwxAXtdyf9U5pLQHAcGFizIzOZGUj8EXn_FYj84xyZaPCtwf49eIrQ>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id B5B523280062;
        Sun,  9 Feb 2020 08:41:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit" failed to apply to 5.4-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:31:40 +0100
Message-ID: <1581251500104115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 736c291c9f36b07f8889c61764c28edce20e715d Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Fri, 6 Dec 2019 15:57:14 -0800
Subject: [PATCH] KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit
 KVM

Convert a plethora of parameters and variables in the MMU and page fault
flows from type gva_t to gpa_t to properly handle TDP on 32-bit KVM.

Thanks to PSE and PAE paging, 32-bit kernels can access 64-bit physical
addresses.  When TDP is enabled, the fault address is a guest physical
address and thus can be a 64-bit value, even when both KVM and its guest
are using 32-bit virtual addressing, e.g. VMX's VMCS.GUEST_PHYSICAL is a
64-bit field, not a natural width field.

Using a gva_t for the fault address means KVM will incorrectly drop the
upper 32-bits of the GPA.  Ditto for gva_to_gpa() when it is used to
translate L2 GPAs to L1 GPAs.

Opportunistically rename variables and parameters to better reflect the
dual address modes, e.g. use "cr2_or_gpa" for fault addresses and plain
"addr" instead of "vaddr" when the address may be either a GVA or an L2
GPA.  Similarly, use "gpa" in the nonpaging_page_fault() flows to avoid
a confusing "gpa_t gva" declaration; this also sets the stage for a
future patch to combing nonpaging_page_fault() and tdp_page_fault() with
minimal churn.

Sprinkle in a few comments to document flows where an address is known
to be a GVA and thus can be safely truncated to a 32-bit value.  Add
WARNs in kvm_handle_page_fault() and FNAME(gva_to_gpa_nested)() to help
document such cases and detect bugs.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2893eae5df9f..159a28512e4c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -378,12 +378,12 @@ struct kvm_mmu {
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
 	unsigned long (*get_cr3)(struct kvm_vcpu *vcpu);
 	u64 (*get_pdptr)(struct kvm_vcpu *vcpu, int index);
-	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err,
+	int (*page_fault)(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 err,
 			  bool prefault);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  struct x86_exception *fault);
-	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
-			    struct x86_exception *exception);
+	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gpa_t gva_or_gpa,
+			    u32 access, struct x86_exception *exception);
 	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 			       struct x86_exception *exception);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
@@ -1473,7 +1473,7 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
-int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u64 error_code,
+int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c19f3ccaace3..2cb199817837 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3532,7 +3532,7 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
  * - true: let the vcpu to access on the same address again.
  * - false: let the real page fault path to fix it.
  */
-static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
+static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, int level,
 			    u32 error_code)
 {
 	struct kvm_shadow_walk_iterator iterator;
@@ -3552,7 +3552,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 	do {
 		u64 new_spte;
 
-		for_each_shadow_entry_lockless(vcpu, gva, iterator, spte)
+		for_each_shadow_entry_lockless(vcpu, cr2_or_gpa, iterator, spte)
 			if (!is_shadow_present_pte(spte) ||
 			    iterator.level < level)
 				break;
@@ -3630,7 +3630,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 
 	} while (true);
 
-	trace_fast_page_fault(vcpu, gva, error_code, iterator.sptep,
+	trace_fast_page_fault(vcpu, cr2_or_gpa, error_code, iterator.sptep,
 			      spte, fault_handled);
 	walk_shadow_page_lockless_end(vcpu);
 
@@ -3638,10 +3638,11 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gva_t gva, kvm_pfn_t *pfn, bool write, bool *writable);
+			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
+			 bool *writable);
 static int make_mmu_pages_available(struct kvm_vcpu *vcpu);
 
-static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
+static int nonpaging_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			 gfn_t gfn, bool prefault)
 {
 	int r;
@@ -3667,16 +3668,16 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}
 
-	if (fast_page_fault(vcpu, v, level, error_code))
+	if (fast_page_fault(vcpu, gpa, level, error_code))
 		return RET_PF_RETRY;
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, v, &pfn, write, &map_writable))
+	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, v, gfn, pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(vcpu, gpa, gfn, pfn, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
@@ -3687,7 +3688,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 		goto out_unlock;
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
-	r = __direct_map(vcpu, v, write, map_writable, level, pfn,
+	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn,
 			 prefault, false);
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
@@ -3985,7 +3986,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_sync_roots);
 
-static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
+static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gpa_t vaddr,
 				  u32 access, struct x86_exception *exception)
 {
 	if (exception)
@@ -3993,7 +3994,7 @@ static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
 	return vaddr;
 }
 
-static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
+static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gpa_t vaddr,
 					 u32 access,
 					 struct x86_exception *exception)
 {
@@ -4153,13 +4154,14 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 	walk_shadow_page_lockless_end(vcpu);
 }
 
-static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
+static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 				u32 error_code, bool prefault)
 {
-	gfn_t gfn = gva >> PAGE_SHIFT;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int r;
 
-	pgprintk("%s: gva %lx error %x\n", __func__, gva, error_code);
+	/* Note, paging is disabled, ergo gva == gpa. */
+	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
 
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
@@ -4171,11 +4173,12 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
 
 
-	return nonpaging_map(vcpu, gva & PAGE_MASK,
+	return nonpaging_map(vcpu, gpa & PAGE_MASK,
 			     error_code, gfn, prefault);
 }
 
-static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
+static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+				   gfn_t gfn)
 {
 	struct kvm_arch_async_pf arch;
 
@@ -4184,11 +4187,13 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
 	arch.direct_map = vcpu->arch.mmu->direct_map;
 	arch.cr3 = vcpu->arch.mmu->get_cr3(vcpu);
 
-	return kvm_setup_async_pf(vcpu, gva, kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
+	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
+				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gva_t gva, kvm_pfn_t *pfn, bool write, bool *writable)
+			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
+			 bool *writable)
 {
 	struct kvm_memory_slot *slot;
 	bool async;
@@ -4208,12 +4213,12 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 		return false; /* *pfn has correct page already */
 
 	if (!prefault && kvm_can_do_async_pf(vcpu)) {
-		trace_kvm_try_async_get_page(gva, gfn);
+		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
 		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
-			trace_kvm_async_pf_doublefault(gva, gfn);
+			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 			return true;
-		} else if (kvm_arch_setup_async_pf(vcpu, gva, gfn))
+		} else if (kvm_arch_setup_async_pf(vcpu, cr2_or_gpa, gfn))
 			return true;
 	}
 
@@ -4226,6 +4231,12 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 {
 	int r = 1;
 
+#ifndef CONFIG_X86_64
+	/* A 64-bit CR2 should be impossible on 32-bit KVM. */
+	if (WARN_ON_ONCE(fault_address >> 32))
+		return -EFAULT;
+#endif
+
 	vcpu->arch.l1tf_flush_l1d = true;
 	switch (vcpu->arch.apf.host_apf_reason) {
 	default:
@@ -4263,7 +4274,7 @@ check_hugepage_cache_consistency(struct kvm_vcpu *vcpu, gfn_t gfn, int level)
 	return kvm_mtrr_check_gfn_range_consistency(vcpu, gfn, page_num);
 }
 
-static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
+static int tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			  bool prefault)
 {
 	kvm_pfn_t pfn;
@@ -5520,7 +5531,7 @@ static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
+int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len)
 {
 	int r, emulation_type = 0;
@@ -5529,18 +5540,18 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	/* With shadow page tables, fault_address contains a GVA or nGPA.  */
 	if (vcpu->arch.mmu->direct_map) {
 		vcpu->arch.gpa_available = true;
-		vcpu->arch.gpa_val = cr2;
+		vcpu->arch.gpa_val = cr2_or_gpa;
 	}
 
 	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
-		r = handle_mmio_page_fault(vcpu, cr2, direct);
+		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
 		if (r == RET_PF_EMULATE)
 			goto emulate;
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = vcpu->arch.mmu->page_fault(vcpu, cr2,
+		r = vcpu->arch.mmu->page_fault(vcpu, cr2_or_gpa,
 					       lower_32_bits(error_code),
 					       false);
 		WARN_ON(r == RET_PF_INVALID);
@@ -5560,7 +5571,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	 */
 	if (vcpu->arch.mmu->direct_map &&
 	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
-		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2));
+		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
 		return 1;
 	}
 
@@ -5575,7 +5586,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	 * explicitly shadowing L1's page tables, i.e. unprotecting something
 	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
 	 */
-	if (!mmio_info_in_cache(vcpu, cr2, direct) && !is_guest_mode(vcpu))
+	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
 		emulation_type = EMULTYPE_ALLOW_RETRY;
 emulate:
 	/*
@@ -5590,7 +5601,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 			return 1;
 	}
 
-	return x86_emulate_instruction(vcpu, cr2, emulation_type, insn,
+	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
 				       insn_len);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 97b21e7fd013..c1d7b866a03f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -291,11 +291,11 @@ static inline unsigned FNAME(gpte_pkeys)(struct kvm_vcpu *vcpu, u64 gpte)
 }
 
 /*
- * Fetch a guest pte for a guest virtual address
+ * Fetch a guest pte for a guest virtual address, or for an L2's GPA.
  */
 static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 				    struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-				    gva_t addr, u32 access)
+				    gpa_t addr, u32 access)
 {
 	int ret;
 	pt_element_t pte;
@@ -496,7 +496,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 }
 
 static int FNAME(walk_addr)(struct guest_walker *walker,
-			    struct kvm_vcpu *vcpu, gva_t addr, u32 access)
+			    struct kvm_vcpu *vcpu, gpa_t addr, u32 access)
 {
 	return FNAME(walk_addr_generic)(walker, vcpu, vcpu->arch.mmu, addr,
 					access);
@@ -611,7 +611,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
  * If the guest tries to write a write-protected page, we need to
  * emulate this operation, return 1 to indicate this case.
  */
-static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
+static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			 struct guest_walker *gw,
 			 int write_fault, int hlevel,
 			 kvm_pfn_t pfn, bool map_writable, bool prefault,
@@ -765,7 +765,7 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
  *  Returns: 1 if we need to emulate the instruction, 0 otherwise, or
  *           a negative value on error.
  */
-static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
+static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 			     bool prefault)
 {
 	int write_fault = error_code & PFERR_WRITE_MASK;
@@ -945,18 +945,19 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 	spin_unlock(&vcpu->kvm->mmu_lock);
 }
 
-static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
+/* Note, @addr is a GPA when gva_to_gpa() translates an L2 GPA to an L1 GPA. */
+static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gpa_t addr, u32 access,
 			       struct x86_exception *exception)
 {
 	struct guest_walker walker;
 	gpa_t gpa = UNMAPPED_GVA;
 	int r;
 
-	r = FNAME(walk_addr)(&walker, vcpu, vaddr, access);
+	r = FNAME(walk_addr)(&walker, vcpu, addr, access);
 
 	if (r) {
 		gpa = gfn_to_gpa(walker.gfn);
-		gpa |= vaddr & ~PAGE_MASK;
+		gpa |= addr & ~PAGE_MASK;
 	} else if (exception)
 		*exception = walker.fault;
 
@@ -964,7 +965,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
 }
 
 #if PTTYPE != PTTYPE_EPT
-static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gva_t vaddr,
+/* Note, gva_to_gpa_nested() is only used to translate L2 GVAs. */
+static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gpa_t vaddr,
 				      u32 access,
 				      struct x86_exception *exception)
 {
@@ -972,6 +974,11 @@ static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gva_t vaddr,
 	gpa_t gpa = UNMAPPED_GVA;
 	int r;
 
+#ifndef CONFIG_X86_64
+	/* A 64-bit GVA should be impossible on 32-bit KVM. */
+	WARN_ON_ONCE(vaddr >> 32);
+#endif
+
 	r = FNAME(walk_addr_nested)(&walker, vcpu, vaddr, access);
 
 	if (r) {
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 7ca8831c7d1a..3c6522b84ff1 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -249,13 +249,13 @@ TRACE_EVENT(
 
 TRACE_EVENT(
 	fast_page_fault,
-	TP_PROTO(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code,
+	TP_PROTO(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 error_code,
 		 u64 *sptep, u64 old_spte, bool retry),
-	TP_ARGS(vcpu, gva, error_code, sptep, old_spte, retry),
+	TP_ARGS(vcpu, cr2_or_gpa, error_code, sptep, old_spte, retry),
 
 	TP_STRUCT__entry(
 		__field(int, vcpu_id)
-		__field(gva_t, gva)
+		__field(gpa_t, cr2_or_gpa)
 		__field(u32, error_code)
 		__field(u64 *, sptep)
 		__field(u64, old_spte)
@@ -265,7 +265,7 @@ TRACE_EVENT(
 
 	TP_fast_assign(
 		__entry->vcpu_id = vcpu->vcpu_id;
-		__entry->gva = gva;
+		__entry->cr2_or_gpa = cr2_or_gpa;
 		__entry->error_code = error_code;
 		__entry->sptep = sptep;
 		__entry->old_spte = old_spte;
@@ -273,9 +273,9 @@ TRACE_EVENT(
 		__entry->retry = retry;
 	),
 
-	TP_printk("vcpu %d gva %lx error_code %s sptep %p old %#llx"
+	TP_printk("vcpu %d gva %llx error_code %s sptep %p old %#llx"
 		  " new %llx spurious %d fixed %d", __entry->vcpu_id,
-		  __entry->gva, __print_flags(__entry->error_code, "|",
+		  __entry->cr2_or_gpa, __print_flags(__entry->error_code, "|",
 		  kvm_mmu_trace_pferr_flags), __entry->sptep,
 		  __entry->old_spte, __entry->new_spte,
 		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 25aac4c81b12..93bbbce67a03 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6379,11 +6379,11 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 	return 1;
 }
 
-static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
+static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  bool write_fault_to_shadow_pgtable,
 				  int emulation_type)
 {
-	gpa_t gpa = cr2;
+	gpa_t gpa = cr2_or_gpa;
 	kvm_pfn_t pfn;
 
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY))
@@ -6397,7 +6397,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
 		 * Write permission should be allowed since only
 		 * write access need to be emulated.
 		 */
-		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
+		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
 
 		/*
 		 * If the mapping is invalid in guest, let cpu retry
@@ -6454,10 +6454,10 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
 }
 
 static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
-			      unsigned long cr2,  int emulation_type)
+			      gpa_t cr2_or_gpa,  int emulation_type)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	unsigned long last_retry_eip, last_retry_addr, gpa = cr2;
+	unsigned long last_retry_eip, last_retry_addr, gpa = cr2_or_gpa;
 
 	last_retry_eip = vcpu->arch.last_retry_eip;
 	last_retry_addr = vcpu->arch.last_retry_addr;
@@ -6486,14 +6486,14 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	if (x86_page_table_writing_insn(ctxt))
 		return false;
 
-	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2)
+	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2_or_gpa)
 		return false;
 
 	vcpu->arch.last_retry_eip = ctxt->eip;
-	vcpu->arch.last_retry_addr = cr2;
+	vcpu->arch.last_retry_addr = cr2_or_gpa;
 
 	if (!vcpu->arch.mmu->direct_map)
-		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
+		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
 
 	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
 
@@ -6639,11 +6639,8 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
 	return false;
 }
 
-int x86_emulate_instruction(struct kvm_vcpu *vcpu,
-			    unsigned long cr2,
-			    int emulation_type,
-			    void *insn,
-			    int insn_len)
+int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+			    int emulation_type, void *insn, int insn_len)
 {
 	int r;
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
@@ -6689,8 +6686,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 				kvm_queue_exception(vcpu, UD_VECTOR);
 				return 1;
 			}
-			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
-						emulation_type))
+			if (reexecute_instruction(vcpu, cr2_or_gpa,
+						  write_fault_to_spt,
+						  emulation_type))
 				return 1;
 			if (ctxt->have_exception) {
 				/*
@@ -6724,7 +6722,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		return 1;
 	}
 
-	if (retry_instruction(ctxt, cr2, emulation_type))
+	if (retry_instruction(ctxt, cr2_or_gpa, emulation_type))
 		return 1;
 
 	/* this is needed for vmware backdoor interface to work since it
@@ -6736,7 +6734,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 
 restart:
 	/* Save the faulting GPA (cr2) in the address field */
-	ctxt->exception.address = cr2;
+	ctxt->exception.address = cr2_or_gpa;
 
 	r = x86_emulate_insn(ctxt);
 
@@ -6744,7 +6742,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		return 1;
 
 	if (r == EMULATION_FAILED) {
-		if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
+		if (reexecute_instruction(vcpu, cr2_or_gpa, write_fault_to_spt,
 					emulation_type))
 			return 1;
 
@@ -10025,7 +10023,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->arch.cr3 != vcpu->arch.mmu->get_cr3(vcpu))
 		return;
 
-	vcpu->arch.mmu->page_fault(vcpu, work->gva, 0, true);
+	vcpu->arch.mmu->page_fault(vcpu, work->cr2_or_gpa, 0, true);
 }
 
 static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
@@ -10138,7 +10136,7 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 {
 	struct x86_exception fault;
 
-	trace_kvm_async_pf_not_present(work->arch.token, work->gva);
+	trace_kvm_async_pf_not_present(work->arch.token, work->cr2_or_gpa);
 	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
 
 	if (kvm_can_deliver_async_pf(vcpu) &&
@@ -10173,7 +10171,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 		work->arch.token = ~0; /* broadcast wakeup */
 	else
 		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
-	trace_kvm_async_pf_ready(work->arch.token, work->gva);
+	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
 
 	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
 	    !apf_get_user(vcpu, &val)) {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 29391af8871d..cab5e71f0f0f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -289,7 +289,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
 bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 					  int page_num);
 bool kvm_vector_hashing_enabled(void);
-int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
+int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 
 #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0d632a75fce9..528ab7a814ab 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -204,7 +204,7 @@ struct kvm_async_pf {
 	struct list_head queue;
 	struct kvm_vcpu *vcpu;
 	struct mm_struct *mm;
-	gva_t gva;
+	gpa_t cr2_or_gpa;
 	unsigned long addr;
 	struct kvm_arch_async_pf arch;
 	bool   wakeup_all;
@@ -212,8 +212,8 @@ struct kvm_async_pf {
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
 void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
-int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, unsigned long hva,
-		       struct kvm_arch_async_pf *arch);
+int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+		       unsigned long hva, struct kvm_arch_async_pf *arch);
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 35305d6e68cc..d8ef708a2ef6 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -64,7 +64,7 @@ static void async_pf_execute(struct work_struct *work)
 	struct mm_struct *mm = apf->mm;
 	struct kvm_vcpu *vcpu = apf->vcpu;
 	unsigned long addr = apf->addr;
-	gva_t gva = apf->gva;
+	gpa_t cr2_or_gpa = apf->cr2_or_gpa;
 	int locked = 1;
 
 	might_sleep();
@@ -92,7 +92,7 @@ static void async_pf_execute(struct work_struct *work)
 	 * this point
 	 */
 
-	trace_kvm_async_pf_completed(addr, gva);
+	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
 
 	if (swq_has_sleeper(&vcpu->wq))
 		swake_up_one(&vcpu->wq);
@@ -165,8 +165,8 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 	}
 }
 
-int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, unsigned long hva,
-		       struct kvm_arch_async_pf *arch)
+int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+		       unsigned long hva, struct kvm_arch_async_pf *arch)
 {
 	struct kvm_async_pf *work;
 
@@ -185,7 +185,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, unsigned long hva,
 
 	work->wakeup_all = false;
 	work->vcpu = vcpu;
-	work->gva = gva;
+	work->cr2_or_gpa = cr2_or_gpa;
 	work->addr = hva;
 	work->arch = *arch;
 	work->mm = current->mm;

