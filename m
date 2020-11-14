Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981352B2BD3
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 07:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgKNGvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 01:51:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgKNGvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Nov 2020 01:51:47 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23EA320678;
        Sat, 14 Nov 2020 06:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336707;
        bh=/eWME7bikkfFWXPjUIomPu63eG2bMX1juxXJj9t3KP4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hIR/jf7GFS/H290/pN5u0rSbMS06UeJhIMcI5MhKniqOhf4mGjR79Oh0jpxI7rmK5
         ltjYfgQGhPOACM6bOtgu1O7p7l+ngCWelK+9DMDJOW2SB7OKr8vYNlVSEuXvrczk1u
         yQRYSJTAmLSKBSeiCCDKqn88g8Ezuk+Z3QHpj6sk=
Date:   Fri, 13 Nov 2020 22:51:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     a.sahrawat@samsung.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, maninder1.s@samsung.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        v.narang@samsung.com, vbabka@suse.cz
Subject:  [patch 03/14] mm/vmscan: fix NR_ISOLATED_FILE corruption
 on 64-bit
Message-ID: <20201114065146.3H6OX7gIF%akpm@linux-foundation.org>
In-Reply-To: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
