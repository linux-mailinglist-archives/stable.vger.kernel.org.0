Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067E12B63A5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732832AbgKQNkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732826AbgKQNkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A7B020870;
        Tue, 17 Nov 2020 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620411;
        bh=E9Io8XLxHspcMQcCzOCAH/XkfAhwNHImE3ViluL+oiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpTZM7UHNLSu19VGR4+DsiMtCkF2He6KDcKivOKCysyi7SSp+1u6N8LRgtMSoKoyi
         OU6e8F+xl1zkBpJrJ+Eyck5CQTSULQoAshkjDc0I9yNrxoamBVnRRBG4ktrzVwOQJr
         NqmvPYDj4tI6Tbs4wSRLitgysaowvd4eIrzWpL7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Shi <shy828301@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 209/255] mm/compaction: count pages and stop correctly during page isolation
Date:   Tue, 17 Nov 2020 14:05:49 +0100
Message-Id: <20201117122149.104711341@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

commit 38935861d85a4d9a353d1dd5a156c97700e2765d upstream.

In isolate_migratepages_block, when cc->alloc_contig is true, we are
able to isolate compound pages.  But nr_migratepages and nr_isolated did
not count compound pages correctly, causing us to isolate more pages
than we thought.

So count compound pages as the number of base pages they contain.
Otherwise, we might be trapped in too_many_isolated while loop, since
the actual isolated pages can go up to COMPACT_CLUSTER_MAX*512=16384,
where COMPACT_CLUSTER_MAX is 32, since we stop isolation after
cc->nr_migratepages reaches to COMPACT_CLUSTER_MAX.

In addition, after we fix the issue above, cc->nr_migratepages could
never be equal to COMPACT_CLUSTER_MAX if compound pages are isolated,
thus page isolation could not stop as we intended.  Change the isolation
stop condition to '>='.

The issue can be triggered as follows:

In a system with 16GB memory and an 8GB CMA region reserved by
hugetlb_cma, if we first allocate 10GB THPs and mlock them (so some THPs
are allocated in the CMA region and mlocked), reserving 6 1GB hugetlb
pages via /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages will
get stuck (looping in too_many_isolated function) until we kill either
task.  With the patch applied, oom will kill the application with 10GB
THPs and let hugetlb page reservation finish.

[ziy@nvidia.com: v3]

Link: https://lkml.kernel.org/r/20201030183809.3616803-1-zi.yan@sent.com
Fixes: 1da2f328fa64 ("cmm,thp,compaction,cma: allow THP migration for CMA allocations")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@surriel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201029200435.3386066-1-zi.yan@sent.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1013,8 +1013,8 @@ isolate_migratepages_block(struct compac
 
 isolate_success:
 		list_add(&page->lru, &cc->migratepages);
-		cc->nr_migratepages++;
-		nr_isolated++;
+		cc->nr_migratepages += compound_nr(page);
+		nr_isolated += compound_nr(page);
 
 		/*
 		 * Avoid isolating too much unless this block is being
@@ -1022,7 +1022,7 @@ isolate_success:
 		 * or a lock is contended. For contention, isolate quickly to
 		 * potentially remove one source of contention.
 		 */
-		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX &&
+		if (cc->nr_migratepages >= COMPACT_CLUSTER_MAX &&
 		    !cc->rescan && !cc->contended) {
 			++low_pfn;
 			break;
@@ -1133,7 +1133,7 @@ isolate_migratepages_range(struct compac
 		if (!pfn)
 			break;
 
-		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
+		if (cc->nr_migratepages >= COMPACT_CLUSTER_MAX)
 			break;
 	}
 


