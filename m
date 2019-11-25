Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B6A1093E3
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 20:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbfKYTE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 14:04:59 -0500
Received: from mga17.intel.com ([192.55.52.151]:18948 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfKYTE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 14:04:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Nov 2019 11:04:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,242,1571727600"; 
   d="scan'208";a="291480287"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 25 Nov 2019 11:04:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.19 STABLE] KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved
Date:   Mon, 25 Nov 2019 11:04:56 -0800
Message-Id: <20191125190456.28679-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a78986aae9b2988f8493f9f65a587ee433e83bc3 ]

Explicitly exempt ZONE_DEVICE pages from kvm_is_reserved_pfn() and
instead manually handle ZONE_DEVICE on a case-by-case basis.  For things
like page refcounts, KVM needs to treat ZONE_DEVICE pages like normal
pages, e.g. put pages grabbed via gup().  But for flows such as setting
A/D bits or shifting refcounts for transparent huge pages, KVM needs to
to avoid processing ZONE_DEVICE pages as the flows in question lack the
underlying machinery for proper handling of ZONE_DEVICE pages.

This fixes a hang reported by Adam Borowski[*] in dev_pagemap_cleanup()
when running a KVM guest backed with /dev/dax memory, as KVM straight up
doesn't put any references to ZONE_DEVICE pages acquired by gup().

Note, Dan Williams proposed an alternative solution of doing put_page()
on ZONE_DEVICE pages immediately after gup() in order to simplify the
auditing needed to ensure is_zone_device_page() is called if and only if
the backing device is pinned (via gup()).  But that approach would break
kvm_vcpu_{un}map() as KVM requires the page to be pinned from map() 'til
unmap() when accessing guest memory, unlike KVM's secondary MMU, which
coordinates with mmu_notifier invalidations to avoid creating stale
page references, i.e. doesn't rely on pages being pinned.

[*] http://lkml.kernel.org/r/20190919115547.GA17963@angband.pl

Reported-by: Adam Borowski <kilobyte@angband.pl>
Analyzed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: stable@vger.kernel.org
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sean: backport to 4.x; resolve conflict in mmu.c]
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c       |  8 ++++----
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 26 +++++++++++++++++++++++---
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d7db7608de5f..eddf91a0e363 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3261,7 +3261,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	 * here.
 	 */
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
-	    level == PT_PAGE_TABLE_LEVEL &&
+	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
 	    PageTransCompoundMap(pfn_to_page(pfn)) &&
 	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
 		unsigned long mask;
@@ -5709,9 +5709,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * the guest, and the guest page table is using 4K page size
 		 * mapping if the indirect sp has level = 1.
 		 */
-		if (sp->role.direct &&
-			!kvm_is_reserved_pfn(pfn) &&
-			PageTransCompoundMap(pfn_to_page(pfn))) {
+		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
+		    !kvm_is_zone_device_pfn(pfn) &&
+		    PageTransCompoundMap(pfn_to_page(pfn))) {
 			drop_spte(kvm, sptep);
 			need_tlb_flush = 1;
 			goto restart;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 96207939d862..748016ae01e3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -911,6 +911,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
 bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
+bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
 
 struct kvm_irq_ack_notifier {
 	struct hlist_node link;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7a0d86d52230..df3fc0f214ec 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -147,10 +147,30 @@ __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 	return 0;
 }
 
+bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
+{
+	/*
+	 * The metadata used by is_zone_device_page() to determine whether or
+	 * not a page is ZONE_DEVICE is guaranteed to be valid if and only if
+	 * the device has been pinned, e.g. by get_user_pages().  WARN if the
+	 * page_count() is zero to help detect bad usage of this helper.
+	 */
+	if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
+		return false;
+
+	return is_zone_device_page(pfn_to_page(pfn));
+}
+
 bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 {
+	/*
+	 * ZONE_DEVICE pages currently set PG_reserved, but from a refcounting
+	 * perspective they are "normal" pages, albeit with slightly different
+	 * usage rules.
+	 */
 	if (pfn_valid(pfn))
-		return PageReserved(pfn_to_page(pfn));
+		return PageReserved(pfn_to_page(pfn)) &&
+		       !kvm_is_zone_device_pfn(pfn);
 
 	return true;
 }
@@ -1727,7 +1747,7 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
 
 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn)) {
+	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
 		struct page *page = pfn_to_page(pfn);
 
 		if (!PageReserved(page))
@@ -1738,7 +1758,7 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
 void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn))
+	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
 		mark_page_accessed(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
-- 
2.24.0

