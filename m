Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F093291B4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242859AbhCAUbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:31:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237019AbhCAUYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:24:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E2FC6540A;
        Mon,  1 Mar 2021 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621957;
        bh=tCIROGuBVPkvU7MlcGmSY5f1UiPr1XjO48Nw0Xj9wJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqvaO7w4wcpIe48cFl/Kdc6F6OMWPoFPg/vewyxbI6mEKHgDIGoYdG9EwVX4ifarU
         +g8hyTRoBls/6btHze3R+hUxJiVLTtvuG6LRPaXlB6IKNXI++Bvs9+Mkh2vynDLBLd
         tD630r3blLktq8eLm4IupI0R84VgI4AQEk6wk3so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 706/775] mm, compaction: make fast_isolate_freepages() stay within zone
Date:   Mon,  1 Mar 2021 17:14:34 +0100
Message-Id: <20210301161236.246190644@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

commit 6e2b7044c199229a3d20cefbd3184968238c4184 upstream.

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
   of a zone that starts in the middle of that pageblock, 'highest' can
   be a pfn outside of the zone.

   If we fail to isolate anything in this function, we may then call
   fast_isolate_around() on a pfn outside of the zone and there
   effectively do a set_pageblock_skip(page_to_pfn(highest)) which may
   currently hit a VM_BUG_ON() in some configurations

 - fast_isolate_around() checks only the zone end boundary and not
   beginning, nor that the pageblock is contiguous (with
   pageblock_pfn_to_page()) so it's possible that we end up calling
   isolate_freepages_block() on a range of pfn's from two different
   zones and end up e.g. isolating freepages under the wrong zone's
   lock.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

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
@@ -1299,8 +1299,12 @@ fast_isolate_around(struct compact_contr
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
@@ -1402,7 +1406,8 @@ fast_isolate_freepages(struct compact_co
 			pfn = page_to_pfn(freepage);
 
 			if (pfn >= highest)
-				highest = pageblock_start_pfn(pfn);
+				highest = max(pageblock_start_pfn(pfn),
+					      cc->zone->zone_start_pfn);
 
 			if (pfn >= low_pfn) {
 				cc->fast_search_fail = 0;
@@ -1472,7 +1477,8 @@ fast_isolate_freepages(struct compact_co
 			} else {
 				if (cc->direct_compaction && pfn_valid(min_pfn)) {
 					page = pageblock_pfn_to_page(min_pfn,
-						pageblock_end_pfn(min_pfn),
+						min(pageblock_end_pfn(min_pfn),
+						    zone_end_pfn(cc->zone)),
 						cc->zone);
 					cc->free_pfn = min_pfn;
 				}


