Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504B9FD640
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfKOGWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbfKOGWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:54 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6DD620740;
        Fri, 15 Nov 2019 06:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798973;
        bh=eIyF+KhoN9NkenLxNwAzf6PC3kU6XHxtFwlmI18dGiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piaTt/r0Fvh+5HODST4cRl7SpbWQKtqvs1T81egrcKEuhdIdtQBmfIhEomn1x50C1
         flRPeYrrrUKKPWg8dLTP9RQ+/1HpApWOXZe6Qy4/mgsXANakwKTp9o5t70u/EqbPnb
         SEwGgV5zHmKK/WHiZUtyNY7Nl9C1rcQZQ0EwqEHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH 4.9 28/31] kvm: mmu: ITLB_MULTIHIT mitigation
Date:   Fri, 15 Nov 2019 14:20:57 +0800
Message-Id: <20191115062019.964907743@linuxfoundation.org>
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

commit b8e8c8303ff28c61046a4d0f6ea99aea609a7dc0 upstream.

With some Intel processors, putting the same virtual address in the TLB
as both a 4 KiB and 2 MiB page can confuse the instruction fetch unit
and cause the processor to issue a machine check resulting in a CPU lockup.

Unfortunately when EPT page tables use huge pages, it is possible for a
malicious guest to cause this situation.

Add a knob to mark huge pages as non-executable. When the nx_huge_pages
parameter is enabled (and we are using EPT), all huge pages are marked as
NX. If the guest attempts to execute in one of those pages, the page is
broken down into 4K pages, which are then marked executable.

This is not an issue for shadow paging (except nested EPT), because then
the host is in control of TLB flushes and the problematic situation cannot
happen.  With nested EPT, again the nested guest can cause problems shadow
and direct EPT is treated in the same way.

[ tglx: Fixup default to auto and massage wording a bit ]

Originally-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9:
 - Use kvm_mmu_invalidate_zap_all_pages() instead of kvm_mmu_zap_all_fast()
 - Don't provide mode for nx_largepages_splitted as all stats are read-only
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |   19 ++++
 arch/x86/include/asm/kvm_host.h     |    2 
 arch/x86/kernel/cpu/bugs.c          |   13 +++
 arch/x86/kvm/mmu.c                  |  141 ++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/paging_tmpl.h          |   29 +++++--
 arch/x86/kvm/x86.c                  |    9 ++
 6 files changed, 200 insertions(+), 13 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1975,6 +1975,19 @@ bytes respectively. Such letter suffixes
 			KVM MMU at runtime.
 			Default is 0 (off)
 
+	kvm.nx_huge_pages=
+			[KVM] Controls the software workaround for the
+			X86_BUG_ITLB_MULTIHIT bug.
+			force	: Always deploy workaround.
+			off	: Never deploy workaround.
+			auto    : Deploy workaround based on the presence of
+				  X86_BUG_ITLB_MULTIHIT.
+
+			Default is 'auto'.
+
+			If the software workaround is enabled for the host,
+			guests do need not to enable it for nested guests.
+
 	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.
 			Default is 1 (enabled)
 
@@ -2491,6 +2504,12 @@ bytes respectively. Such letter suffixes
 					       l1tf=off [X86]
 					       mds=off [X86]
 					       tsx_async_abort=off [X86]
+					       kvm.nx_huge_pages=off [X86]
+
+				Exceptions:
+					       This does not have any effect on
+					       kvm.nx_huge_pages when
+					       kvm.nx_huge_pages=force.
 
 			auto (default)
 				Mitigate all CPU vulnerabilities, but leave SMT
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -273,6 +273,7 @@ struct kvm_mmu_page {
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
 	bool unsync;
+	bool lpage_disallowed; /* Can't be replaced by an equiv large page */
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
 	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
@@ -811,6 +812,7 @@ struct kvm_vm_stat {
 	ulong mmu_unsync;
 	ulong remote_tlb_flush;
 	ulong lpages;
+	ulong nx_lpage_splits;
 };
 
 struct kvm_vcpu_stat {
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1233,6 +1233,9 @@ void x86_spec_ctrl_setup_ap(void)
 		x86_amd_ssb_disable();
 }
 
+bool itlb_multihit_kvm_mitigation;
+EXPORT_SYMBOL_GPL(itlb_multihit_kvm_mitigation);
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"L1TF: " fmt
 
@@ -1388,17 +1391,25 @@ static ssize_t l1tf_show_state(char *buf
 		       l1tf_vmx_states[l1tf_vmx_mitigation],
 		       sched_smt_active() ? "vulnerable" : "disabled");
 }
+
+static ssize_t itlb_multihit_show_state(char *buf)
+{
+	if (itlb_multihit_kvm_mitigation)
+		return sprintf(buf, "KVM: Mitigation: Split huge pages\n");
+	else
+		return sprintf(buf, "KVM: Vulnerable\n");
+}
 #else
 static ssize_t l1tf_show_state(char *buf)
 {
 	return sprintf(buf, "%s\n", L1TF_DEFAULT_MSG);
 }
-#endif
 
 static ssize_t itlb_multihit_show_state(char *buf)
 {
 	return sprintf(buf, "Processor vulnerable\n");
 }
+#endif
 
 static ssize_t mds_show_state(char *buf)
 {
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -44,6 +44,20 @@
 #include <asm/vmx.h>
 #include <asm/kvm_page_track.h>
 
+extern bool itlb_multihit_kvm_mitigation;
+
+static int __read_mostly nx_huge_pages = -1;
+
+static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
+
+static struct kernel_param_ops nx_huge_pages_ops = {
+	.set = set_nx_huge_pages,
+	.get = param_get_bool,
+};
+
+module_param_cb(nx_huge_pages, &nx_huge_pages_ops, &nx_huge_pages, 0644);
+__MODULE_PARM_TYPE(nx_huge_pages, "bool");
+
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
  * where the hardware walks 2 page tables:
@@ -202,6 +216,11 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
+static bool is_nx_huge_page_enabled(void)
+{
+	return READ_ONCE(nx_huge_pages);
+}
+
 /*
  * the low bit of the generation number is always presumed to be zero.
  * This disables mmio caching during memslot updates.  The concept is
@@ -855,6 +874,15 @@ static void account_shadowed(struct kvm
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 }
 
+static void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	if (sp->lpage_disallowed)
+		return;
+
+	++kvm->stat.nx_lpage_splits;
+	sp->lpage_disallowed = true;
+}
+
 static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	struct kvm_memslots *slots;
@@ -872,6 +900,12 @@ static void unaccount_shadowed(struct kv
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
 
+static void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	--kvm->stat.nx_lpage_splits;
+	sp->lpage_disallowed = false;
+}
+
 static bool __mmu_gfn_lpage_is_disallowed(gfn_t gfn, int level,
 					  struct kvm_memory_slot *slot)
 {
@@ -2408,6 +2442,9 @@ static int kvm_mmu_prepare_zap_page(stru
 			kvm_reload_remote_mmus(kvm);
 	}
 
+	if (sp->lpage_disallowed)
+		unaccount_huge_nx_page(kvm, sp);
+
 	sp->role.invalid = 1;
 	return ret;
 }
@@ -2559,6 +2596,11 @@ static int set_spte(struct kvm_vcpu *vcp
 	if (!speculative)
 		spte |= shadow_accessed_mask;
 
+	if (level > PT_PAGE_TABLE_LEVEL && (pte_access & ACC_EXEC_MASK) &&
+	    is_nx_huge_page_enabled()) {
+		pte_access &= ~ACC_EXEC_MASK;
+	}
+
 	if (pte_access & ACC_EXEC_MASK)
 		spte |= shadow_x_mask;
 	else
@@ -2766,9 +2808,32 @@ static void direct_pte_prefetch(struct k
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
+static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
+				       gfn_t gfn, kvm_pfn_t *pfnp, int *levelp)
+{
+	int level = *levelp;
+	u64 spte = *it.sptep;
+
+	if (it.level == level && level > PT_PAGE_TABLE_LEVEL &&
+	    is_nx_huge_page_enabled() &&
+	    is_shadow_present_pte(spte) &&
+	    !is_large_pte(spte)) {
+		/*
+		 * A small SPTE exists for this pfn, but FNAME(fetch)
+		 * and __direct_map would like to create a large PTE
+		 * instead: just force them to go down another level,
+		 * patching back for them into pfn the next 9 bits of
+		 * the address.
+		 */
+		u64 page_mask = KVM_PAGES_PER_HPAGE(level) - KVM_PAGES_PER_HPAGE(level - 1);
+		*pfnp |= gfn & page_mask;
+		(*levelp)--;
+	}
+}
+
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 			int map_writable, int level, kvm_pfn_t pfn,
-			bool prefault)
+			bool prefault, bool lpage_disallowed)
 {
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
@@ -2781,6 +2846,12 @@ static int __direct_map(struct kvm_vcpu
 
 	trace_kvm_mmu_spte_requested(gpa, level, pfn);
 	for_each_shadow_entry(vcpu, gpa, it) {
+		/*
+		 * We cannot overwrite existing page tables with an NX
+		 * large page, as the leaf could be executable.
+		 */
+		disallowed_hugepage_adjust(it, gfn, &pfn, &level);
+
 		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
 			break;
@@ -2791,6 +2862,8 @@ static int __direct_map(struct kvm_vcpu
 					      it.level - 1, true, ACC_ALL);
 
 			link_shadow_page(vcpu, it.sptep, sp);
+			if (lpage_disallowed)
+				account_huge_nx_page(vcpu->kvm, sp);
 		}
 	}
 
@@ -3031,11 +3104,14 @@ static int nonpaging_map(struct kvm_vcpu
 {
 	int r;
 	int level;
-	bool force_pt_level = false;
+	bool force_pt_level;
 	kvm_pfn_t pfn;
 	unsigned long mmu_seq;
 	bool map_writable, write = error_code & PFERR_WRITE_MASK;
+	bool lpage_disallowed = (error_code & PFERR_FETCH_MASK) &&
+				is_nx_huge_page_enabled();
 
+	force_pt_level = lpage_disallowed;
 	level = mapping_level(vcpu, gfn, &force_pt_level);
 	if (likely(!force_pt_level)) {
 		/*
@@ -3068,7 +3144,8 @@ static int nonpaging_map(struct kvm_vcpu
 	make_mmu_pages_available(vcpu);
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
-	r = __direct_map(vcpu, v, write, map_writable, level, pfn, prefault);
+	r = __direct_map(vcpu, v, write, map_writable, level, pfn,
+			 prefault, false);
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
@@ -3564,6 +3641,8 @@ static int tdp_page_fault(struct kvm_vcp
 	unsigned long mmu_seq;
 	int write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
+	bool lpage_disallowed = (error_code & PFERR_FETCH_MASK) &&
+				is_nx_huge_page_enabled();
 
 	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
@@ -3574,8 +3653,9 @@ static int tdp_page_fault(struct kvm_vcp
 	if (r)
 		return r;
 
-	force_pt_level = !check_hugepage_cache_consistency(vcpu, gfn,
-							   PT_DIRECTORY_LEVEL);
+	force_pt_level =
+		lpage_disallowed ||
+		!check_hugepage_cache_consistency(vcpu, gfn, PT_DIRECTORY_LEVEL);
 	level = mapping_level(vcpu, gfn, &force_pt_level);
 	if (likely(!force_pt_level)) {
 		if (level > PT_DIRECTORY_LEVEL &&
@@ -3603,7 +3683,8 @@ static int tdp_page_fault(struct kvm_vcp
 	make_mmu_pages_available(vcpu);
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
-	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn, prefault);
+	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn,
+			 prefault, lpage_disallowed);
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
@@ -5053,8 +5134,56 @@ static void mmu_destroy_caches(void)
 		kmem_cache_destroy(mmu_page_header_cache);
 }
 
+static bool get_nx_auto_mode(void)
+{
+	/* Return true when CPU has the bug, and mitigations are ON */
+	return boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT) && !cpu_mitigations_off();
+}
+
+static void __set_nx_huge_pages(bool val)
+{
+	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
+}
+
+static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
+{
+	bool old_val = nx_huge_pages;
+	bool new_val;
+
+	/* In "auto" mode deploy workaround only if CPU has the bug. */
+	if (sysfs_streq(val, "off"))
+		new_val = 0;
+	else if (sysfs_streq(val, "force"))
+		new_val = 1;
+	else if (sysfs_streq(val, "auto"))
+		new_val = get_nx_auto_mode();
+	else if (strtobool(val, &new_val) < 0)
+		return -EINVAL;
+
+	__set_nx_huge_pages(new_val);
+
+	if (new_val != old_val) {
+		struct kvm *kvm;
+		int idx;
+
+		mutex_lock(&kvm_lock);
+
+		list_for_each_entry(kvm, &vm_list, vm_list) {
+			idx = srcu_read_lock(&kvm->srcu);
+			kvm_mmu_invalidate_zap_all_pages(kvm);
+			srcu_read_unlock(&kvm->srcu, idx);
+		}
+		mutex_unlock(&kvm_lock);
+	}
+
+	return 0;
+}
+
 int kvm_mmu_module_init(void)
 {
+	if (nx_huge_pages == -1)
+		__set_nx_huge_pages(get_nx_auto_mode());
+
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
 					    sizeof(struct pte_list_desc),
 					    0, SLAB_ACCOUNT, NULL);
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -573,13 +573,14 @@ static void FNAME(pte_prefetch)(struct k
 static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *gw,
 			 int write_fault, int hlevel,
-			 kvm_pfn_t pfn, bool map_writable, bool prefault)
+			 kvm_pfn_t pfn, bool map_writable, bool prefault,
+			 bool lpage_disallowed)
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
 	unsigned direct_access, access = gw->pt_access;
 	int top_level, ret;
-	gfn_t base_gfn;
+	gfn_t gfn, base_gfn;
 
 	direct_access = gw->pte_access;
 
@@ -624,13 +625,25 @@ static int FNAME(fetch)(struct kvm_vcpu
 			link_shadow_page(vcpu, it.sptep, sp);
 	}
 
-	base_gfn = gw->gfn;
+	/*
+	 * FNAME(page_fault) might have clobbered the bottom bits of
+	 * gw->gfn, restore them from the virtual address.
+	 */
+	gfn = gw->gfn | ((addr & PT_LVL_OFFSET_MASK(gw->level)) >> PAGE_SHIFT);
+	base_gfn = gfn;
 
 	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
 
 	for (; shadow_walk_okay(&it); shadow_walk_next(&it)) {
 		clear_sp_write_flooding_count(it.sptep);
-		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
+
+		/*
+		 * We cannot overwrite existing page tables with an NX
+		 * large page, as the leaf could be executable.
+		 */
+		disallowed_hugepage_adjust(it, gfn, &pfn, &hlevel);
+
+		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == hlevel)
 			break;
 
@@ -642,6 +655,8 @@ static int FNAME(fetch)(struct kvm_vcpu
 			sp = kvm_mmu_get_page(vcpu, base_gfn, addr,
 					      it.level - 1, true, direct_access);
 			link_shadow_page(vcpu, it.sptep, sp);
+			if (lpage_disallowed)
+				account_huge_nx_page(vcpu->kvm, sp);
 		}
 	}
 
@@ -718,9 +733,11 @@ static int FNAME(page_fault)(struct kvm_
 	int r;
 	kvm_pfn_t pfn;
 	int level = PT_PAGE_TABLE_LEVEL;
-	bool force_pt_level = false;
 	unsigned long mmu_seq;
 	bool map_writable, is_self_change_mapping;
+	bool lpage_disallowed = (error_code & PFERR_FETCH_MASK) &&
+				is_nx_huge_page_enabled();
+	bool force_pt_level = lpage_disallowed;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
@@ -810,7 +827,7 @@ static int FNAME(page_fault)(struct kvm_
 	if (!force_pt_level)
 		transparent_hugepage_adjust(vcpu, walker.gfn, &pfn, &level);
 	r = FNAME(fetch)(vcpu, addr, &walker, write_fault,
-			 level, pfn, map_writable, prefault);
+			 level, pfn, map_writable, prefault, lpage_disallowed);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -191,6 +191,7 @@ struct kvm_stats_debugfs_item debugfs_en
 	{ "mmu_unsync", VM_STAT(mmu_unsync) },
 	{ "remote_tlb_flush", VM_STAT(remote_tlb_flush) },
 	{ "largepages", VM_STAT(lpages) },
+	{ "nx_largepages_splitted", VM_STAT(nx_lpage_splits) },
 	{ NULL }
 };
 
@@ -1032,6 +1033,14 @@ u64 kvm_get_arch_capabilities(void)
 	rdmsrl_safe(MSR_IA32_ARCH_CAPABILITIES, &data);
 
 	/*
+	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
+	 * the nested hypervisor runs with NX huge pages.  If it is not,
+	 * L1 is anyway vulnerable to ITLB_MULTIHIT explots from other
+	 * L1 guests, so it need not worry about its own (L2) guests.
+	 */
+	data |= ARCH_CAP_PSCHANGE_MC_NO;
+
+	/*
 	 * If we're doing cache flushes (either "always" or "cond")
 	 * we will do one whenever the guest does a vmlaunch/vmresume.
 	 * If an outer hypervisor is doing the cache flush for us


