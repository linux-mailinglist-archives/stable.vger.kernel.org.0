Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F2E6E6E09
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 23:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjDRVXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 17:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbjDRVXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 17:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018BD9779;
        Tue, 18 Apr 2023 14:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1C556392E;
        Tue, 18 Apr 2023 21:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CCBC433D2;
        Tue, 18 Apr 2023 21:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681852968;
        bh=e6lQOW9BkI4BMB/MU/ZzYwKytdf4QQLzTDeQWs3nadA=;
        h=Date:To:From:Subject:From;
        b=jDxDFMczzP4qa3qgn+i15d8MVRcWUq0mHjZAmkB8PhgTrrjRKPdR/cyMcg6uFSbWh
         hIIvPRvoVn8d5/z097eaGQUCg1Lf2S12yGQK0iWr+IcAXoE471KQEbwY39pq4VxMJK
         tldzPvb7PoajUUO3BtH1K2tT7/uceZq06WovTekA=
Date:   Tue, 18 Apr 2023 14:22:47 -0700
To:     mm-commits@vger.kernel.org, y.liu@naruida.com, willy@infradead.org,
        vbabka@suse.cz, stable@vger.kernel.org, osalvador@suse.de,
        mhocko@suse.com, david@redhat.com, mgorman@techsingularity.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-skip-regions-with-hugetlbfs-pages-when-allocating-1g-pages.patch removed from -mm tree
Message-Id: <20230418212248.42CCBC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-skip-regions-with-hugetlbfs-pages-when-allocating-1g-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages
Date: Fri, 14 Apr 2023 15:14:29 +0100

A bug was reported by Yuanxi Liu where allocating 1G pages at runtime is
taking an excessive amount of time for large amounts of memory.  Further
testing allocating huge pages that the cost is linear i.e.  if allocating
1G pages in batches of 10 then the time to allocate nr_hugepages from
10->20->30->etc increases linearly even though 10 pages are allocated at
each step.  Profiles indicated that much of the time is spent checking the
validity within already existing huge pages and then attempting a
migration that fails after isolating the range, draining pages and a whole
lot of other useless work.

Commit eb14d4eefdc4 ("mm,page_alloc: drop unnecessary checks from
pfn_range_valid_contig") removed two checks, one which ignored huge pages
for contiguous allocations as huge pages can sometimes migrate.  While
there may be value on migrating a 2M page to satisfy a 1G allocation, it's
potentially expensive if the 1G allocation fails and it's pointless to try
moving a 1G page for a new 1G allocation or scan the tail pages for valid
PFNs.

Reintroduce the PageHuge check and assume any contiguous region with
hugetlbfs pages is unsuitable for a new 1G allocation.

The hpagealloc test allocates huge pages in batches and reports the
average latency per page over time.  This test happens just after boot
when fragmentation is not an issue.  Units are in milliseconds.

hpagealloc
                               6.3.0-rc6              6.3.0-rc6              6.3.0-rc6
                                 vanilla   hugeallocrevert-v1r1   hugeallocsimple-v1r2
Min       Latency       26.42 (   0.00%)        5.07 (  80.82%)       18.94 (  28.30%)
1st-qrtle Latency      356.61 (   0.00%)        5.34 (  98.50%)       19.85 (  94.43%)
2nd-qrtle Latency      697.26 (   0.00%)        5.47 (  99.22%)       20.44 (  97.07%)
3rd-qrtle Latency      972.94 (   0.00%)        5.50 (  99.43%)       20.81 (  97.86%)
Max-1     Latency       26.42 (   0.00%)        5.07 (  80.82%)       18.94 (  28.30%)
Max-5     Latency       82.14 (   0.00%)        5.11 (  93.78%)       19.31 (  76.49%)
Max-10    Latency      150.54 (   0.00%)        5.20 (  96.55%)       19.43 (  87.09%)
Max-90    Latency     1164.45 (   0.00%)        5.53 (  99.52%)       20.97 (  98.20%)
Max-95    Latency     1223.06 (   0.00%)        5.55 (  99.55%)       21.06 (  98.28%)
Max-99    Latency     1278.67 (   0.00%)        5.57 (  99.56%)       22.56 (  98.24%)
Max       Latency     1310.90 (   0.00%)        8.06 (  99.39%)       26.62 (  97.97%)
Amean     Latency      678.36 (   0.00%)        5.44 *  99.20%*       20.44 *  96.99%*

                   6.3.0-rc6   6.3.0-rc6   6.3.0-rc6
                     vanilla   revert-v1   hugeallocfix-v2
Duration User           0.28        0.27        0.30
Duration System       808.66       17.77       35.99
Duration Elapsed      830.87       18.08       36.33

The vanilla kernel is poor, taking up to 1.3 second to allocate a huge
page and almost 10 minutes in total to run the test.  Reverting the
problematic commit reduces it to 8ms at worst and the patch takes 26ms. 
This patch fixes the main issue with skipping huge pages but leaves the
page_count() out because a page with an elevated count potentially can
migrate.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=217022
Link: https://lkml.kernel.org/r/20230414141429.pwgieuwluxwez3rj@techsingularity.net
Fixes: eb14d4eefdc4 ("mm,page_alloc: drop unnecessary checks from pfn_range_valid_contig")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Yuanxi Liu <y.liu@naruida.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-skip-regions-with-hugetlbfs-pages-when-allocating-1g-pages
+++ a/mm/page_alloc.c
@@ -9466,6 +9466,9 @@ static bool pfn_range_valid_contig(struc
 
 		if (PageReserved(page))
 			return false;
+
+		if (PageHuge(page))
+			return false;
 	}
 	return true;
 }
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


