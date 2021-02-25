Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF793256D1
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhBYThR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234942AbhBYTfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA26264FBC;
        Thu, 25 Feb 2021 19:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280731;
        bh=nYMIHv6+aNwba1OhKW4oyLvpwZSTLMPBxnwBmszH718=;
        h=Date:From:To:Subject:From;
        b=i0W0zclbWTB6JswfgtwMLiJjH/7/W1zdoRxUnU6TRhEcXwPOUR7DhLACQVEusL7QH
         DqGVxisyMQwT+RCGf29hdjSbsowvgXv7tt1yqVWgTqfevho0M0uaxSg+WOeoqw/yGr
         3cXaTZpKGa1VbrRETf4v1ff7epFnppReHax/vFrk=
Date:   Thu, 25 Feb 2021 11:18:50 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, david@redhat.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, rientjes@google.com,
        rppt@kernel.org, stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-compaction-make-fast_isolate_freepages-stay-within-zone.patch removed
 from -mm tree
Message-ID: <20210225191850.2w_qtWW2V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, compaction: make fast_isolate_freepages() stay within zone
has been removed from the -mm tree.  Its filename was
     mm-compaction-make-fast_isolate_freepages-stay-within-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: make fast_isolate_freepages() stay within zone

Compaction always operates on pages from a single given zone when
isolating both pages to migrate and freepages.  Pageblock boundaries are
intersected with zone boundaries to be safe in case zone starts or ends in
the middle of pageblock.  The use of pageblock_pfn_to_page() protects
against non-contiguous pageblocks.

The functions fast_isolate_freepages() and fast_isolate_around() don't
currently protect the fast freepage isolation thoroughly enough against
these corner cases, and can result in freepage isolation operate outside
of zone boundaries:

- in fast_isolate_freepages() if we get a pfn from the first pageblock
  of a zone that starts in the middle of that pageblock, 'highest' can be
  a pfn outside of the zone.  If we fail to isolate anything in this
  function, we may then call fast_isolate_around() on a pfn outside of the
  zone and there effectively do a set_pageblock_skip(page_to_pfn(highest))
  which may currently hit a VM_BUG_ON() in some configurations

- fast_isolate_around() checks only the zone end boundary and not
  beginning, nor that the pageblock is contiguous (with
  pageblock_pfn_to_page()) so it's possible that we end up calling
  isolate_freepages_block() on a range of pfn's from two different zones
  and end up e.g.  isolating freepages under the wrong zone's lock.

This patch should fix the above issues.

Link: https://lkml.kernel.org/r/20210217173300.6394-1-vbabka@suse.cz
Fixes: 5a811889de10 ("mm, compaction: use free lists to quickly locate a migration target")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/compaction.c~mm-compaction-make-fast_isolate_freepages-stay-within-zone
+++ a/mm/compaction.c
@@ -1284,7 +1284,7 @@ static void
 fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long nr_isolated)
 {
 	unsigned long start_pfn, end_pfn;
-	struct page *page = pfn_to_page(pfn);
+	struct page *page;
 
 	/* Do not search around if there are enough pages already */
 	if (cc->nr_freepages >= cc->nr_migratepages)
@@ -1295,8 +1295,12 @@ fast_isolate_around(struct compact_contr
 		return;
 
 	/* Pageblock boundaries */
-	start_pfn = pageblock_start_pfn(pfn);
-	end_pfn = min(pageblock_end_pfn(pfn), zone_end_pfn(cc->zone)) - 1;
+	start_pfn = max(pageblock_start_pfn(pfn), cc->zone->zone_start_pfn);
+	end_pfn = min(pageblock_end_pfn(pfn), zone_end_pfn(cc->zone));
+
+	page = pageblock_pfn_to_page(start_pfn, end_pfn, cc->zone);
+	if (!page)
+		return;
 
 	/* Scan before */
 	if (start_pfn != pfn) {
@@ -1398,7 +1402,8 @@ fast_isolate_freepages(struct compact_co
 			pfn = page_to_pfn(freepage);
 
 			if (pfn >= highest)
-				highest = pageblock_start_pfn(pfn);
+				highest = max(pageblock_start_pfn(pfn),
+					      cc->zone->zone_start_pfn);
 
 			if (pfn >= low_pfn) {
 				cc->fast_search_fail = 0;
@@ -1468,7 +1473,8 @@ fast_isolate_freepages(struct compact_co
 			} else {
 				if (cc->direct_compaction && pfn_valid(min_pfn)) {
 					page = pageblock_pfn_to_page(min_pfn,
-						pageblock_end_pfn(min_pfn),
+						min(pageblock_end_pfn(min_pfn),
+						    zone_end_pfn(cc->zone)),
 						cc->zone);
 					cc->free_pfn = min_pfn;
 				}
_

Patches currently in -mm which might be from vbabka@suse.cz are

maintainers-add-uapi-directories-to-api-abi-section.patch

