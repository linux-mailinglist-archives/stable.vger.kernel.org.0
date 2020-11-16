Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128752B5001
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgKPSlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:41:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgKPSlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 13:41:13 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7682720A8B;
        Mon, 16 Nov 2020 18:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605552072;
        bh=G38MpKkrBk8WGhJmJarcDwNpXTyb+xIrgtwmI2DDSb0=;
        h=Date:From:To:Subject:From;
        b=i3GO+zrWldVawt40pDcBUEHWnZqJ9ePa926ATjN/DLQteBLhjapWXsWsIRbMtwbu2
         fFq4nJmzwT2ztEafN9P7EnEDxx55NzXX1RxGgJOTR42IUa+ti0t8546kDdWDBmn7Bi
         dl04QqAOZYipAIlesG3AoAOiMn72IRi/pX88ybKw=
Date:   Mon, 16 Nov 2020 10:41:12 -0800
From:   akpm@linux-foundation.org
To:     a.sahrawat@samsung.com, maninder1.s@samsung.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        stable@vger.kernel.org, v.narang@samsung.com, vbabka@suse.cz
Subject:  [merged]
 mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit.patch removed from -mm
 tree
Message-ID: <20201116184112.-hlOofP-O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit

Previously the negated unsigned long would be cast back to signed long
which would have the correct negative value.  After commit 730ec8c01a2b
("mm/vmscan.c: change prototype for shrink_page_list"), the large unsigned
int converts to a large positive signed long.

Symptoms include CMA allocations hanging forever holding the cma_mutex due
to alloc_contig_range->...->isolate_migratepages_block waiting forever in
"while (unlikely(too_many_isolated(pgdat)))".

[akpm@linux-foundation.org: fix -stat.nr_lazyfree_fail as well, per Michal]
Link: https://lkml.kernel.org/r/20201029032320.1448441-1-npiggin@gmail.com
Fixes: 730ec8c01a2b ("mm/vmscan.c: change prototype for shrink_page_list")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vaneet Narang <v.narang@samsung.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit
+++ a/mm/vmscan.c
@@ -1516,7 +1516,8 @@ unsigned int reclaim_clean_pages_from_li
 	nr_reclaimed = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
 			TTU_IGNORE_ACCESS, &stat, true);
 	list_splice(&clean_pages, page_list);
-	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -nr_reclaimed);
+	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
+			    -(long)nr_reclaimed);
 	/*
 	 * Since lazyfree pages are isolated from file LRU from the beginning,
 	 * they will rotate back to anonymous LRU in the end if it failed to
@@ -1526,7 +1527,7 @@ unsigned int reclaim_clean_pages_from_li
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_ANON,
 			    stat.nr_lazyfree_fail);
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
-			    -stat.nr_lazyfree_fail);
+			    -(long)stat.nr_lazyfree_fail);
 	return nr_reclaimed;
 }
 
_

Patches currently in -mm which might be from npiggin@gmail.com are


