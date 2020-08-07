Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197EA23E72A
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 08:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgHGGRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 02:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgHGGRP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2BE8221E5;
        Fri,  7 Aug 2020 06:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781034;
        bh=OVWvsSaIpqu3QJpZgPxOm+EG3djcXSl2jWK7tt7skCc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=W5XaOy7e8UMN+AXcaZp4uK7XILFl6Hz+VBo+fOn7tNQlNuOCQ6VU1o1S6uyTXVQeS
         wqOj/3im35gr42zzC4RZE1lDJXCdxlMSwZu8lXBQCPfrQ42RxLkGQfTqQs3evQhDuR
         cPYrVRd+TWFBxUXlZeyfBeeR/dBuxcllYB5fSmMo=
Date:   Thu, 06 Aug 2020 23:17:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        david@redhat.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        richard.weiyang@linux.alibaba.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, ying.huang@intel.com
Subject:  [patch 003/163] mm/shuffle: don't move pages between
 zones and don't read garbage memmaps
Message-ID: <20200807061713.iMOMr3Cb5%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/shuffle: don't move pages between zones and don't read garbage memmaps

Especially with memory hotplug, we can have offline sections (with a
garbage memmap) and overlapping zones.  We have to make sure to only touch
initialized memmaps (online sections managed by the buddy) and that the
zone matches, to not move pages between zones.

To test if this can actually happen, I added a simple

	BUG_ON(page_zone(page_i) != page_zone(page_j));

right before the swap.  When hotplugging a 256M DIMM to a 4G x86-64 VM and
onlining the first memory block "online_movable" and the second memory
block "online_kernel", it will trigger the BUG, as both zones (NORMAL and
MOVABLE) overlap.

This might result in all kinds of weird situations (e.g., double
allocations, list corruptions, unmovable allocations ending up in the
movable zone).

Link: http://lkml.kernel.org/r/20200624094741.9918-2-david@redhat.com
Fixes: e900a918b098 ("mm: shuffle initial free memory to improve memory-side-cache utilization")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[5.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shuffle.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/shuffle.c~mm-shuffle-dont-move-pages-between-zones-and-dont-read-garbage-memmaps
+++ a/mm/shuffle.c
@@ -58,25 +58,25 @@ module_param_call(shuffle, shuffle_store
  * For two pages to be swapped in the shuffle, they must be free (on a
  * 'free_area' lru), have the same order, and have the same migratetype.
  */
-static struct page * __meminit shuffle_valid_page(unsigned long pfn, int order)
+static struct page * __meminit shuffle_valid_page(struct zone *zone,
+						  unsigned long pfn, int order)
 {
-	struct page *page;
+	struct page *page = pfn_to_online_page(pfn);
 
 	/*
 	 * Given we're dealing with randomly selected pfns in a zone we
 	 * need to ask questions like...
 	 */
 
-	/* ...is the pfn even in the memmap? */
-	if (!pfn_valid_within(pfn))
+	/* ... is the page managed by the buddy? */
+	if (!page)
 		return NULL;
 
-	/* ...is the pfn in a present section or a hole? */
-	if (!pfn_in_present_section(pfn))
+	/* ... is the page assigned to the same zone? */
+	if (page_zone(page) != zone)
 		return NULL;
 
 	/* ...is the page free and currently on a free_area list? */
-	page = pfn_to_page(pfn);
 	if (!PageBuddy(page))
 		return NULL;
 
@@ -123,7 +123,7 @@ void __meminit __shuffle_zone(struct zon
 		 * page_j randomly selected in the span @zone_start_pfn to
 		 * @spanned_pages.
 		 */
-		page_i = shuffle_valid_page(i, order);
+		page_i = shuffle_valid_page(z, i, order);
 		if (!page_i)
 			continue;
 
@@ -137,7 +137,7 @@ void __meminit __shuffle_zone(struct zon
 			j = z->zone_start_pfn +
 				ALIGN_DOWN(get_random_long() % z->spanned_pages,
 						order_pages);
-			page_j = shuffle_valid_page(j, order);
+			page_j = shuffle_valid_page(z, j, order);
 			if (page_j && page_j != page_i)
 				break;
 		}
_
