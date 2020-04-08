Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC901A2540
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 17:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgDHPeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 11:34:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:25812 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgDHPeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 11:34:16 -0400
IronPort-SDR: DFnVnsDqyUYyUiEEULLA5KtLEEq8fH9qDMM+FlU3x6ZRlP9BhKxYZX9rbDjm2M/t2eQv6bhCeP
 4/RWWHVHH7ng==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2020 08:34:14 -0700
IronPort-SDR: TMxMx+fv9CyskFfa5D7RFgWQcGeYSA2CvGbXJVzDqb4gw5GckJYgipMzC9zyr4D3I0+EmiSENq
 teSiDrTeOI8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,359,1580803200"; 
   d="scan'208,223";a="361872649"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 08 Apr 2020 08:34:14 -0700
Date:   Wed, 8 Apr 2020 08:34:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200408153413.GA11322@linux.intel.com>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 08, 2020 at 10:23:58AM +0200, Paolo Bonzini wrote:
> Page-not-present async page faults are almost a perfect match for the
> hardware use of #VE (and it might even be possible to let the processor
> deliver the exceptions).

My "async" page fault knowledge is limited, but if the desired behavior is
to reflect a fault into the guest for select EPT Violations, then yes,
enabling EPT Violation #VEs in hardware is doable.  The big gotcha is that
KVM needs to set the suppress #VE bit for all EPTEs when allocating a new
MMU page, otherwise not-present faults on zero-initialized EPTEs will get
reflected.

Attached a patch that does the prep work in the MMU.  The VMX usage would be:

	kvm_mmu_set_spte_init_value(VMX_EPT_SUPPRESS_VE_BIT);

when EPT Violation #VEs are enabled.  It's 64-bit only as it uses stosq to
initialize EPTEs.  32-bit could also be supported by doing memcpy() from
a static page.

--nFreZHaLTZJo0R7j
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-KVM-x86-mmu-Allow-non-zero-init-value-for-shadow-PTE.patch"

From 078b485e8a64e6d72ebad58bf66f950763ba30bb Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Mon, 29 Jul 2019 19:23:46 -0700
Subject: [PATCH] KVM: x86/mmu: Allow non-zero init value for shadow PTE

Add support for using a non-zero "init" value for shadow PTEs, which is
required to enable EPT Violation #VEs in hardware.  When #VEs are
enabled, KVM needs to set the "suppress #VE" bit in unused PTEs to avoid
unintentionally reflecting not-present EPT Violations into the guest.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.h             |  1 +
 arch/x86/kvm/mmu/mmu.c         | 43 ++++++++++++++++++++++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 8a3b1bce722a..139db8a125d6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -52,6 +52,7 @@ static inline u64 rsvd_bits(int s, int e)
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask);
+void kvm_mmu_set_spte_init_value(u64 init_value);
 
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8071952e9cf2..742ea9c254c4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -250,6 +250,8 @@ static u64 __read_mostly shadow_mmio_access_mask;
 static u64 __read_mostly shadow_present_mask;
 static u64 __read_mostly shadow_me_mask;
 
+static u64 __read_mostly shadow_init_value;
+
 /*
  * SPTEs used by MMUs without A/D bits are marked with SPTE_AD_DISABLED_MASK;
  * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
@@ -538,6 +540,13 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 
+void kvm_mmu_set_spte_init_value(u64 init_value)
+{
+	WARN_ON(!IS_ENABLED(CONFIG_X86_64) && init_value);
+	shadow_init_value = init_value;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_spte_init_value);
+
 static u8 kvm_get_shadow_phys_bits(void)
 {
 	/*
@@ -569,6 +578,7 @@ static void kvm_mmu_reset_all_pte_masks(void)
 	shadow_mmio_mask = 0;
 	shadow_present_mask = 0;
 	shadow_acc_track_mask = 0;
+	shadow_init_value = 0;
 
 	shadow_phys_bits = kvm_get_shadow_phys_bits();
 
@@ -610,7 +620,7 @@ static int is_nx(struct kvm_vcpu *vcpu)
 
 static int is_shadow_present_pte(u64 pte)
 {
-	return (pte != 0) && !is_mmio_spte(pte);
+	return (pte != 0 && pte != shadow_init_value && !is_mmio_spte(pte));
 }
 
 static int is_large_pte(u64 pte)
@@ -921,9 +931,9 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 	u64 old_spte = *sptep;
 
 	if (!spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, 0ull);
+		__update_clear_spte_fast(sptep, shadow_init_value);
 	else
-		old_spte = __update_clear_spte_slow(sptep, 0ull);
+		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
 
 	if (!is_shadow_present_pte(old_spte))
 		return 0;
@@ -953,7 +963,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
  */
 static void mmu_spte_clear_no_track(u64 *sptep)
 {
-	__update_clear_spte_fast(sptep, 0ull);
+	__update_clear_spte_fast(sptep, shadow_init_value);
 }
 
 static u64 mmu_spte_get_lockless(u64 *sptep)
@@ -2473,6 +2483,20 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sp);
 }
 
+#ifdef CONFIG_X86_64
+static inline void kvm_clear_ptes(void *page)
+{
+	int ign;
+
+	asm volatile (
+		"rep stosq\n\t"
+		: "=c"(ign), "=D"(page)
+		: "a"(shadow_init_value), "c"(4096/8), "D"(page)
+		: "memory"
+	);
+}
+#endif
+
 static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
@@ -2553,7 +2577,12 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (level > PT_PAGE_TABLE_LEVEL && need_sync)
 			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
 	}
-	clear_page(sp->spt);
+#ifdef CONFIG_X86_64
+	if (shadow_init_value)
+		kvm_clear_ptes(sp->spt);
+	else
+#endif
+		clear_page(sp->spt);
 	trace_kvm_mmu_get_page(sp, true);
 
 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
@@ -3515,7 +3544,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
 	bool fault_handled = false;
-	u64 spte = 0ull;
+	u64 spte = shadow_init_value;
 	uint retry_count = 0;
 
 	if (!page_fault_can_be_fast(error_code))
@@ -3951,7 +3980,7 @@ static bool
 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	u64 sptes[PT64_ROOT_MAX_LEVEL], spte = 0ull;
+	u64 sptes[PT64_ROOT_MAX_LEVEL], spte = shadow_init_value;
 	struct rsvd_bits_validate *rsvd_check;
 	int root, leaf;
 	bool reserved = false;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 9bdf9b7d9a96..949deed15933 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1025,7 +1025,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!sp->spt[i])
+		if (!sp->spt[i] || sp->spt[i] == shadow_init_value)
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
-- 
2.24.1


--nFreZHaLTZJo0R7j--
