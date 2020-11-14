Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897442B2BCD
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 07:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgKNGvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 01:51:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:32986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgKNGvl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Nov 2020 01:51:41 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7A9120637;
        Sat, 14 Nov 2020 06:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336701;
        bh=ufBMx7Na/IFZ91XDGXDYFOLbhL92G0/1hZ5vbIXVwA0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KhnJXygRHdJM6+s4whOlRHGlTbJ8jmQzgYFOy+5LvIpyCKxPDaBFhSfKFgxTWhZyX
         xDRyFocBLLoDc15OkcQhqZGJTClLAitsshQZdq5olGo/4rFTlcEUnkUvRt8O/E14pA
         C9ogZJpzVVKyoaavZ38RHPao7PLJWAO3AoA755pY=
Date:   Fri, 13 Nov 2020 22:51:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, riel@surriel.com, shy828301@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, ziy@nvidia.com
Subject:  [patch 01/14] mm/compaction: count pages and stop
 correctly during page isolation
Message-ID: <20201114065140.81J4LaSck%akpm@linux-foundation.org>
In-Reply-To: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: count pages and stop correctly during page isolation

In isolate_migratepages_block, when cc->alloc_contig is true, we are able
to isolate compound pages, nr_migratepages and nr_isolated did not count
compound pages correctly, causing us to isolate more pages than we
thought.  Count compound pages as the number of base pages they contain. 
Otherwise, we might be trapped in too_many_isolated while loop, since the
actual isolated pages can go up to COMPACT_CLUSTER_MAX*512=16384, where
COMPACT_CLUSTER_MAX is 32, since we stop isolation after
cc->nr_migratepages reaches to COMPACT_CLUSTER_MAX.

In addition, after we fix the issue above, cc->nr_migratepages could never
be equal to COMPACT_CLUSTER_MAX if compound pages are isolated, thus page
isolation could not stop as we intended.  Change the isolation stop
condition to >=.

The issue can be triggered as follows: In a system with 16GB memory and an
8GB CMA region reserved by hugetlb_cma, if we first allocate 10GB THPs and
mlock them (so some THPs are allocated in the CMA region and mlocked),
reserving 6 1GB hugetlb pages via
/sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages will get stuck
(looping in too_many_isolated function) until we kill either task.  With
the patch applied, oom will kill the application with 10GB THPs and let
hugetlb page reservation finish.

[ziy@nvidia.com: v3]
  Link: https://lkml.kernel.org/r/20201030183809.3616803-1-zi.yan@sent.com
Link: https://lkml.kernel.org/r/20201029200435.3386066-1-zi.yan@sent.com
Fixes: 1da2f328fa64 ("cmm,thp,compaction,cma: allow THP migration for CMA allocations")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@surriel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-count-pages-and-stop-correctly-during-page-isolation
+++ a/mm/compaction.c
@@ -1012,8 +1012,8 @@ isolate_migratepages_block(struct compac
 
 isolate_success:
 		list_add(&page->lru, &cc->migratepages);
-		cc->nr_migratepages++;
-		nr_isolated++;
+		cc->nr_migratepages += compound_nr(page);
+		nr_isolated += compound_nr(page);
 
 		/*
 		 * Avoid isolating too much unless this block is being
@@ -1021,7 +1021,7 @@ isolate_success:
 		 * or a lock is contended. For contention, isolate quickly to
 		 * potentially remove one source of contention.
 		 */
-		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX &&
+		if (cc->nr_migratepages >= COMPACT_CLUSTER_MAX &&
 		    !cc->rescan && !cc->contended) {
 			++low_pfn;
 			break;
@@ -1132,7 +1132,7 @@ isolate_migratepages_range(struct compac
 		if (!pfn)
 			break;
 
-		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
+		if (cc->nr_migratepages >= COMPACT_CLUSTER_MAX)
 			break;
 	}
 
_
