Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B365931DF73
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 20:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhBQTPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 14:15:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230332AbhBQTPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 14:15:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9ADD64DE0;
        Wed, 17 Feb 2021 19:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613589277;
        bh=iU3PfsIzGA3sNcC86BCTvbXOB6J4qS6l8Qb/VUL2WvM=;
        h=Date:From:To:Subject:From;
        b=TDCLKv8MD52tX/yxslVCbLAsc9vZNLLeiO+syitIxzOfrQwYMgdMbbrvkpR4dbey+
         KjJLQ85XzJu1jjhjG/8g//lhDJCOY86lU24XLOPnrYAj80GOno2tgXtZEmFom+x72x
         B10DCLiH/kYgF23yDkF8BSNtyEJ5RvAqq/W5HRmY=
Date:   Wed, 17 Feb 2021 11:14:36 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@kernel.org, rientjes@google.com, mhocko@kernel.org,
        mgorman@techsingularity.net, david@redhat.com, aarcange@redhat.com,
        vbabka@suse.cz
Subject:  +
 mm-compaction-make-fast_isolate_freepages-stay-within-zone.patch added to -mm
 tree
Message-ID: <20210217191436.shTJB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, compaction: make fast_isolate_freepages() stay within zone
has been added to the -mm tree.  Its filename is
     mm-compaction-make-fast_isolate_freepages-stay-within-zone.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-make-fast_isolate_freepages-stay-within-zone.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-make-fast_isolate_freepages-stay-within-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline.patch
mm-slab-slub-stop-taking-memory-hotplug-lock.patch
mm-slab-slub-stop-taking-cpu-hotplug-lock.patch
mm-slub-splice-cpu-and-page-freelists-in-deactivate_slab.patch
mm-slub-remove-slub_memcg_sysfs-boot-param-and-config_slub_memcg_sysfs_on.patch
mm-compaction-make-fast_isolate_freepages-stay-within-zone.patch
maintainers-add-uapi-directories-to-api-abi-section.patch

