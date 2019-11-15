Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F9FFD612
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfKOGWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727621AbfKOGWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:12 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A399C207FC;
        Fri, 15 Nov 2019 06:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798932;
        bh=aembyKkNwnQdKyORIcdGPDuQMUoQXmBjYnUeXhN7uwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8KvqTCrnsPHcXWyGo00ngJXhJCL/QMww16+C4YDzLcBh6dOo24+7bs47DEvSEJUo
         kOFBNnmIRleNwBuqqzuSdew9Vg7c7uF6OfK2o9v23lZGxK32pRDipfmNLi9CDJIUE2
         M23M9sFeoB8rQqKloMVzDFAgFr6ygbCEHfgB7ymg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 17/31] KVM: x86: extend usage of RET_MMIO_PF_* constants
Date:   Fri, 15 Nov 2019 14:20:46 +0800
Message-Id: <20191115062017.119192578@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 9b8ebbdb74b5ad76b9dfd8b101af17839174b126 upstream.

The x86 MMU if full of code that returns 0 and 1 for retry/emulate.  Use
the existing RET_MMIO_PF_RETRY/RET_MMIO_PF_EMULATE enum, renaming it to
drop the MMIO part.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu.c         |   93 +++++++++++++++++++++------------------------
 arch/x86/kvm/paging_tmpl.h |   18 ++++----
 2 files changed, 54 insertions(+), 57 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -142,6 +142,20 @@ module_param(dbg, bool, 0644);
 /* make pte_list_desc fit well in cache line */
 #define PTE_LIST_EXT 3
 
+/*
+ * Return values of handle_mmio_page_fault and mmu.page_fault:
+ * RET_PF_RETRY: let CPU fault again on the address.
+ * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
+ *
+ * For handle_mmio_page_fault only:
+ * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
+ */
+enum {
+	RET_PF_RETRY = 0,
+	RET_PF_EMULATE = 1,
+	RET_PF_INVALID = 2,
+};
+
 struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
 	struct pte_list_desc *more;
@@ -2598,13 +2612,13 @@ done:
 	return ret;
 }
 
-static bool mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
-			 int write_fault, int level, gfn_t gfn, kvm_pfn_t pfn,
-			 bool speculative, bool host_writable)
+static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
+			int write_fault, int level, gfn_t gfn, kvm_pfn_t pfn,
+		       	bool speculative, bool host_writable)
 {
 	int was_rmapped = 0;
 	int rmap_count;
-	bool emulate = false;
+	int ret = RET_PF_RETRY;
 
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
 		 *sptep, write_fault, gfn);
@@ -2634,12 +2648,12 @@ static bool mmu_set_spte(struct kvm_vcpu
 	if (set_spte(vcpu, sptep, pte_access, level, gfn, pfn, speculative,
 	      true, host_writable)) {
 		if (write_fault)
-			emulate = true;
+			ret = RET_PF_EMULATE;
 		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 	}
 
 	if (unlikely(is_mmio_spte(*sptep)))
-		emulate = true;
+		ret = RET_PF_EMULATE;
 
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 	pgprintk("instantiating %s PTE (%s) at %llx (%llx) addr %p\n",
@@ -2659,7 +2673,7 @@ static bool mmu_set_spte(struct kvm_vcpu
 
 	kvm_release_pfn_clean(pfn);
 
-	return emulate;
+	return ret;
 }
 
 static kvm_pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
@@ -2798,14 +2812,13 @@ static int kvm_handle_bad_page(struct kv
 	 * Do not cache the mmio info caused by writing the readonly gfn
 	 * into the spte otherwise read access on readonly gfn also can
 	 * caused mmio page fault and treat it as mmio access.
-	 * Return 1 to tell kvm to emulate it.
 	 */
 	if (pfn == KVM_PFN_ERR_RO_FAULT)
-		return 1;
+		return RET_PF_EMULATE;
 
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(kvm_vcpu_gfn_to_hva(vcpu, gfn), current);
-		return 0;
+		return RET_PF_RETRY;
 	}
 
 	return -EFAULT;
@@ -3031,13 +3044,13 @@ static int nonpaging_map(struct kvm_vcpu
 	}
 
 	if (fast_page_fault(vcpu, v, level, error_code))
-		return 0;
+		return RET_PF_RETRY;
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
 	if (try_async_pf(vcpu, prefault, gfn, v, &pfn, write, &map_writable))
-		return 0;
+		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, v, gfn, pfn, ACC_ALL, &r))
 		return r;
@@ -3056,7 +3069,7 @@ static int nonpaging_map(struct kvm_vcpu
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
-	return 0;
+	return RET_PF_RETRY;
 }
 
 
@@ -3383,54 +3396,38 @@ exit:
 	return reserved;
 }
 
-/*
- * Return values of handle_mmio_page_fault:
- * RET_MMIO_PF_EMULATE: it is a real mmio page fault, emulate the instruction
- *			directly.
- * RET_MMIO_PF_INVALID: invalid spte is detected then let the real page
- *			fault path update the mmio spte.
- * RET_MMIO_PF_RETRY: let CPU fault again on the address.
- * RET_MMIO_PF_BUG: a bug was detected (and a WARN was printed).
- */
-enum {
-	RET_MMIO_PF_EMULATE = 1,
-	RET_MMIO_PF_INVALID = 2,
-	RET_MMIO_PF_RETRY = 0,
-	RET_MMIO_PF_BUG = -1
-};
-
 static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 {
 	u64 spte;
 	bool reserved;
 
 	if (mmio_info_in_cache(vcpu, addr, direct))
-		return RET_MMIO_PF_EMULATE;
+		return RET_PF_EMULATE;
 
 	reserved = walk_shadow_page_get_mmio_spte(vcpu, addr, &spte);
 	if (WARN_ON(reserved))
-		return RET_MMIO_PF_BUG;
+		return -EINVAL;
 
 	if (is_mmio_spte(spte)) {
 		gfn_t gfn = get_mmio_spte_gfn(spte);
 		unsigned access = get_mmio_spte_access(spte);
 
 		if (!check_mmio_spte(vcpu, spte))
-			return RET_MMIO_PF_INVALID;
+			return RET_PF_INVALID;
 
 		if (direct)
 			addr = 0;
 
 		trace_handle_mmio_page_fault(addr, gfn, access);
 		vcpu_cache_mmio_info(vcpu, addr, gfn, access);
-		return RET_MMIO_PF_EMULATE;
+		return RET_PF_EMULATE;
 	}
 
 	/*
 	 * If the page table is zapped by other cpus, let CPU fault again on
 	 * the address.
 	 */
-	return RET_MMIO_PF_RETRY;
+	return RET_PF_RETRY;
 }
 EXPORT_SYMBOL_GPL(handle_mmio_page_fault);
 
@@ -3480,7 +3477,7 @@ static int nonpaging_page_fault(struct k
 	pgprintk("%s: gva %lx error %x\n", __func__, gva, error_code);
 
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
-		return 1;
+		return RET_PF_EMULATE;
 
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
@@ -3568,7 +3565,7 @@ static int tdp_page_fault(struct kvm_vcp
 	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
-		return 1;
+		return RET_PF_EMULATE;
 
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
@@ -3585,13 +3582,13 @@ static int tdp_page_fault(struct kvm_vcp
 	}
 
 	if (fast_page_fault(vcpu, gpa, level, error_code))
-		return 0;
+		return RET_PF_RETRY;
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
 	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
-		return 0;
+		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, 0, gfn, pfn, ACC_ALL, &r))
 		return r;
@@ -3610,7 +3607,7 @@ static int tdp_page_fault(struct kvm_vcp
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
-	return 0;
+	return RET_PF_RETRY;
 }
 
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
@@ -4526,24 +4523,24 @@ int kvm_mmu_page_fault(struct kvm_vcpu *
 	enum emulation_result er;
 	bool direct = vcpu->arch.mmu.direct_map || mmu_is_nested(vcpu);
 
+	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
 		r = handle_mmio_page_fault(vcpu, cr2, direct);
-		if (r == RET_MMIO_PF_EMULATE) {
+		if (r == RET_PF_EMULATE) {
 			emulation_type = 0;
 			goto emulate;
 		}
-		if (r == RET_MMIO_PF_RETRY)
-			return 1;
-		if (r < 0)
-			return r;
-		/* Must be RET_MMIO_PF_INVALID.  */
 	}
 
-	r = vcpu->arch.mmu.page_fault(vcpu, cr2, error_code, false);
+	if (r == RET_PF_INVALID) {
+		r = vcpu->arch.mmu.page_fault(vcpu, cr2, error_code, false);
+		WARN_ON(r == RET_PF_INVALID);
+	}
+
+	if (r == RET_PF_RETRY)
+		return 1;
 	if (r < 0)
 		return r;
-	if (!r)
-		return 1;
 
 	if (mmio_info_in_cache(vcpu, cr2, direct))
 		emulation_type = 0;
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -577,7 +577,7 @@ static int FNAME(fetch)(struct kvm_vcpu
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
 	unsigned direct_access, access = gw->pt_access;
-	int top_level, emulate;
+	int top_level, ret;
 
 	direct_access = gw->pte_access;
 
@@ -643,15 +643,15 @@ static int FNAME(fetch)(struct kvm_vcpu
 	}
 
 	clear_sp_write_flooding_count(it.sptep);
-	emulate = mmu_set_spte(vcpu, it.sptep, gw->pte_access, write_fault,
-			       it.level, gw->gfn, pfn, prefault, map_writable);
+	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, write_fault,
+			   it.level, gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
 
-	return emulate;
+	return ret;
 
 out_gpte_changed:
 	kvm_release_pfn_clean(pfn);
-	return 0;
+	return RET_PF_RETRY;
 }
 
  /*
@@ -746,12 +746,12 @@ static int FNAME(page_fault)(struct kvm_
 		if (!prefault)
 			inject_page_fault(vcpu, &walker.fault);
 
-		return 0;
+		return RET_PF_RETRY;
 	}
 
 	if (page_fault_handle_page_track(vcpu, error_code, walker.gfn)) {
 		shadow_page_table_clear_flood(vcpu, addr);
-		return 1;
+		return RET_PF_EMULATE;
 	}
 
 	vcpu->arch.write_fault_to_shadow_pgtable = false;
@@ -773,7 +773,7 @@ static int FNAME(page_fault)(struct kvm_
 
 	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, write_fault,
 			 &map_writable))
-		return 0;
+		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, mmu_is_nested(vcpu) ? 0 : addr,
 				walker.gfn, pfn, walker.pte_access, &r))
@@ -818,7 +818,7 @@ static int FNAME(page_fault)(struct kvm_
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
-	return 0;
+	return RET_PF_RETRY;
 }
 
 static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)


