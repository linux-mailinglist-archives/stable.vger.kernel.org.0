Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E80DF6E7
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 22:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbfJUUms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 16:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbfJUUms (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 16:42:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 983AD20882;
        Mon, 21 Oct 2019 20:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571690567;
        bh=/bfZVQXAvaqUMjkBnhMibJf9PBJ1hbKEtK3Thz+bVIQ=;
        h=Date:From:To:Subject:From;
        b=dNFMlGUb7gWwnDhSrMwoC/JmQc1iyCx/0cNe5P2TW5ZD9dQFEUbXPrh9LJROK8QVt
         VZnjJfG8nUn3aDYzmfdW62VBOhVDKG4L+okvgOrIYm/JBjGWxTe13MfaYluJP4nvUt
         AGRvUY1uFQm2HbsIa681xlmGPnO7BaXM5dgBrCDA=
Date:   Mon, 21 Oct 2019 13:42:47 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-memory-failurec-dont-access-uninitialized-memmaps-in-memo?=
 =?US-ASCII?Q?ry=5Ffailure.patch?= removed from -mm tree
Message-ID: <20191021204247.sglb4tIHl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: don't access uninitialized memmaps in memory_failure()
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-dont-access-uninitialized-memmaps-in-memory_failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory-failure.c: don't access uninitialized memmaps in memory_failure()

We should check for pfn_to_online_page() to not access uninitialized
memmaps. Reshuffle the code so 		we don't have to duplicate the error
message.

Link: http://lkml.kernel.org/r/20191009142435.3975-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-dont-access-uninitialized-memmaps-in-memory_failure
+++ a/mm/memory-failure.c
@@ -1257,17 +1257,19 @@ int memory_failure(unsigned long pfn, in
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
 
-	if (!pfn_valid(pfn)) {
+	p = pfn_to_online_page(pfn);
+	if (!p) {
+		if (pfn_valid(pfn)) {
+			pgmap = get_dev_pagemap(pfn, NULL);
+			if (pgmap)
+				return memory_failure_dev_pagemap(pfn, flags,
+								  pgmap);
+		}
 		pr_err("Memory failure: %#lx: memory outside kernel control\n",
 			pfn);
 		return -ENXIO;
 	}
 
-	pgmap = get_dev_pagemap(pfn, NULL);
-	if (pgmap)
-		return memory_failure_dev_pagemap(pfn, flags, pgmap);
-
-	p = pfn_to_page(pfn);
 	if (PageHuge(p))
 		return memory_failure_hugetlb(pfn, flags);
 	if (TestSetPageHWPoison(p)) {
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

