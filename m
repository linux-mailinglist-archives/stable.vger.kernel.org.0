Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DCEDF6F1
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 22:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbfJUUn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 16:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730121AbfJUUn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 16:43:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8B922067B;
        Mon, 21 Oct 2019 20:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571690605;
        bh=hbjK9E0CtkjgObEjeUg0lNIlPQ3jAIhgkD6OwRj/b2A=;
        h=Date:From:To:Subject:From;
        b=KFYaeym7RFCl5XLzEj4jO7OEuEmaZHDA51yBA2tF/q3Dk5By2mtQvvZHN58LmGgRJ
         VgQxF2z4hNsqEXuDJLXbG3XIY6tJnN9PCdZFE6yG/u3U5D8XME+IxdBb/p+4BV7W2k
         +6l9qcQmc+uNVFXGRMOcsrl41dNV3MlzcSSepFI8=
Date:   Mon, 21 Oct 2019 13:43:25 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@kernel.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?hugetlbfs-dont-access-uninitialized-memmaps-in-pfn=5Fra?=
 =?US-ASCII?Q?nge=5Fvalid=5Fgigantic.patch?= removed from -mm tree
Message-ID: <20191021204325.M6XNZMykS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlbfs: don't access uninitialized memmaps in pfn_range_valid_gigantic()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-dont-access-uninitialized-memmaps-in-pfn_range_valid_gigantic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: hugetlbfs: don't access uninitialized memmaps in pfn_range_valid_gigantic()

Uninitialized memmaps contain garbage and in the worst case trigger kernel
BUGs, especially with CONFIG_PAGE_POISONING.  They should not get touched.

Let's make sure that we only consider online memory (managed by the buddy)
that has initialized memmaps.  ZONE_DEVICE is not applicable.

page_zone() will call page_to_nid(), which will trigger
VM_BUG_ON_PGFLAGS(PagePoisoned(page), page) with CONFIG_PAGE_POISONING and
CONFIG_DEBUG_VM_PGFLAGS when called on uninitialized memmaps.  This can be
the case when an offline memory block (e.g., never onlined) is spanned by
a zone.

Note: As explained by Michal in [1], alloc_contig_range() will verify the
range.  So it boils down to the wrong access in this function.

[1] http://lkml.kernel.org/r/20180423000943.GO17484@dhcp22.suse.cz

Link: http://lkml.kernel.org/r/20191015120717.4858-1-david@redhat.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlbfs-dont-access-uninitialized-memmaps-in-pfn_range_valid_gigantic
+++ a/mm/hugetlb.c
@@ -1084,11 +1084,10 @@ static bool pfn_range_valid_gigantic(str
 	struct page *page;
 
 	for (i = start_pfn; i < end_pfn; i++) {
-		if (!pfn_valid(i))
+		page = pfn_to_online_page(i);
+		if (!page)
 			return false;
 
-		page = pfn_to_page(i);
-
 		if (page_zone(page) != z)
 			return false;
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory_hotplug-export-generic_online_page.patch
hv_balloon-use-generic_online_page.patch
mm-memory_hotplug-remove-__online_page_free-and-__online_page_increment_counters.patch
mm-memory_hotplug-dont-access-uninitialized-memmaps-in-shrink_zone_span.patch
mm-memory_hotplug-shrink-zones-when-offlining-memory.patch
mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone.patch
mm-memory_hotplug-we-always-have-a-zone-in-find_smallestbiggest_section_pfn.patch
mm-memory_hotplug-dont-check-for-all-holes-in-shrink_zone_span.patch
mm-memory_hotplug-drop-local-variables-in-shrink_zone_span.patch
mm-memory_hotplug-cleanup-__remove_pages.patch

