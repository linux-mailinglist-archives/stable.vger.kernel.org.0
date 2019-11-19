Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D356910130A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfKSFVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:21:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbfKSFVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:21:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEC722231E;
        Tue, 19 Nov 2019 05:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140905;
        bh=SmWTtC00I/W3MBF24Muk28GmlRgpglXRziTfV6MQVLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dM7B0qggBh++rcDiolTIzW8ChjrfHcCsMC0pMmEqyOeMFkOTckYcpoovtJ5HzSBZF
         5mWgzxAuWIBcxI7uRct3mjci09cZmLvJ6tUNu9oHhq6ee4ffUg4cl5NlAYliQofC/6
         SUhqkFF6PwEGbdngljIW2ZFH16sJzGnZqawvX9oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        Dan Williams <dan.j.williams@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.3 26/48] KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved
Date:   Tue, 19 Nov 2019 06:19:46 +0100
Message-Id: <20191119051008.145283241@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit a78986aae9b2988f8493f9f65a587ee433e83bc3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.c       |    8 ++++----
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   26 +++++++++++++++++++++++---
 3 files changed, 28 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3352,7 +3352,7 @@ static void transparent_hugepage_adjust(
 	 * here.
 	 */
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
-	    level == PT_PAGE_TABLE_LEVEL &&
+	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
 	    PageTransCompoundMap(pfn_to_page(pfn)) &&
 	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
 		unsigned long mask;
@@ -5961,9 +5961,9 @@ restart:
 		 * the guest, and the guest page table is using 4K page size
 		 * mapping if the indirect sp has level = 1.
 		 */
-		if (sp->role.direct &&
-			!kvm_is_reserved_pfn(pfn) &&
-			PageTransCompoundMap(pfn_to_page(pfn))) {
+		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
+		    !kvm_is_zone_device_pfn(pfn) &&
+		    PageTransCompoundMap(pfn_to_page(pfn))) {
 			pte_list_remove(rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -966,6 +966,7 @@ int kvm_cpu_has_pending_timer(struct kvm
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
 bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
+bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
 
 struct kvm_irq_ack_notifier {
 	struct hlist_node link;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -150,10 +150,30 @@ __weak int kvm_arch_mmu_notifier_invalid
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
@@ -1882,7 +1902,7 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty)
 
 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn)) {
+	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
 		struct page *page = pfn_to_page(pfn);
 
 		SetPageDirty(page);
@@ -1892,7 +1912,7 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
 void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn))
+	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
 		mark_page_accessed(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);


