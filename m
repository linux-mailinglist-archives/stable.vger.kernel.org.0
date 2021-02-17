Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737DC31DE5F
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 18:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbhBQRfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 12:35:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:37526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234417AbhBQRdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 12:33:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 40991B7C4;
        Wed, 17 Feb 2021 17:33:09 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] mm, compaction: make fast_isolate_freepages() stay within zone
Date:   Wed, 17 Feb 2021 18:33:00 +0100
Message-Id: <20210217173300.6394-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Compaction always operates on pages from a single given zone when isolating
both pages to migrate and freepages. Pageblock boundaries are intersected with
zone boundaries to be safe in case zone starts or ends in the middle of
pageblock. The use of pageblock_pfn_to_page() protects against non-contiguous
pageblocks.

The functions fast_isolate_freepages() and fast_isolate_around() don't
currently protect the fast freepage isolation thoroughly enough against these
corner cases, and can result in freepage isolation operate outside of zone
boundaries:

- in fast_isolate_freepages() if we get a pfn from the first pageblock of a
  zone that starts in the middle of that pageblock, 'highest' can be a pfn
  outside of the zone. If we fail to isolate anything in this function, we
  may then call fast_isolate_around() on a pfn outside of the zone and there
  effectively do a set_pageblock_skip(page_to_pfn(highest)) which may currently
  hit a VM_BUG_ON() in some configurations
- fast_isolate_around() checks only the zone end boundary and not beginning,
  nor that the pageblock is contiguous (with pageblock_pfn_to_page()) so it's
  possible that we end up calling isolate_freepages_block() on a range of pfn's
  from two different zones and end up e.g. isolating freepages under the wrong
  zone's lock.

This patch should fix the above issues.

Fixes: 5a811889de10 ("mm, compaction: use free lists to quickly locate a migration target")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/compaction.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Hi, as promised here's a fix for issues that I think exist regardless of the
memblock stuff, but were partially exposed by that. I will see if I can manage
to test that it does prevent the known symptoms (it should if I didn't miss
anything).

diff --git a/mm/compaction.c b/mm/compaction.c
index 190ccdaa6c19..22a35521e358 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1288,7 +1288,7 @@ static void
 fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long nr_isolated)
 {
 	unsigned long start_pfn, end_pfn;
-	struct page *page = pfn_to_page(pfn);
+	struct page *page;
 
 	/* Do not search around if there are enough pages already */
 	if (cc->nr_freepages >= cc->nr_migratepages)
@@ -1299,8 +1299,12 @@ fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long
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
@@ -1402,7 +1406,8 @@ fast_isolate_freepages(struct compact_control *cc)
 			pfn = page_to_pfn(freepage);
 
 			if (pfn >= highest)
-				highest = pageblock_start_pfn(pfn);
+				highest = max(pageblock_start_pfn(pfn),
+					      cc->zone->zone_start_pfn);
 
 			if (pfn >= low_pfn) {
 				cc->fast_search_fail = 0;
@@ -1472,7 +1477,8 @@ fast_isolate_freepages(struct compact_control *cc)
 			} else {
 				if (cc->direct_compaction && pfn_valid(min_pfn)) {
 					page = pageblock_pfn_to_page(min_pfn,
-						pageblock_end_pfn(min_pfn),
+						min(pageblock_end_pfn(min_pfn),
+						    zone_end_pfn(cc->zone)),
 						cc->zone);
 					cc->free_pfn = min_pfn;
 				}
-- 
2.30.0

