Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C6163E635
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 01:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiLAALW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 19:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiLAAKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 19:10:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD91E89317;
        Wed, 30 Nov 2022 16:03:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8848D6176C;
        Thu,  1 Dec 2022 00:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77A1C4347C;
        Thu,  1 Dec 2022 00:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852989;
        bh=YWsGIX5D63rJIFGGPqxfsb89nSUQOE3Ujx8IqHScZQc=;
        h=Date:To:From:Subject:From;
        b=gSIC1nMbWiM93hoHCMHyBldOOgNhT6MzydnVjRtTGDeaJ9wvHxvWZ9cTRKpgsXMIu
         icYdSStKV7yua7mCbVNVhTpjGVIg+Bcnxps1FOwbpDXGpdxKcANP8p2SnO64Z5CcUf
         jAyRGcMstg/w27Hs6lPNAIuMsVI0cRVi1GEYIkPE=
Date:   Wed, 30 Nov 2022 16:03:09 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        rientjes@google.com, mgorman@techsingularity.net,
        a.naribayashi@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-fix-fast_isolate_around-to-stay-within-boundaries.patch removed from -mm tree
Message-Id: <20221201000309.C77A1C4347C@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm, compaction: fix fast_isolate_around() to stay within boundaries
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-fast_isolate_around-to-stay-within-boundaries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: NARIBAYASHI Akira <a.naribayashi@fujitsu.com>
Subject: mm, compaction: fix fast_isolate_around() to stay within boundaries
Date: Wed, 26 Oct 2022 20:24:38 +0900

Depending on the memory configuration, isolate_freepages_block() may scan
pages out of the target range and causes panic.

Panic can occur on systems with multiple zones in a single pageblock.

The reason it is rare is that it only happens in special
configurations.  Depending on how many similar systems there are, it
may be a good idea to fix this problem for older kernels as well.

The problem is that pfn as argument of fast_isolate_around() could be out
of the target range.  Therefore we should consider the case where pfn <
start_pfn, and also the case where end_pfn < pfn.

This problem should have been addressd by the commit 6e2b7044c199 ("mm,
compaction: make fast_isolate_freepages() stay within zone") but there was
an oversight.

 Case1: pfn < start_pfn

  <at memory compaction for node Y>
  |  node X's zone  | node Y's zone
  +-----------------+------------------------------...
   pageblock    ^   ^     ^
  +-----------+-----------+-----------+-----------+...
                ^   ^     ^
                ^   ^      end_pfn
                ^    start_pfn = cc->zone->zone_start_pfn
                 pfn
                <---------> scanned range by "Scan After"

 Case2: end_pfn < pfn

  <at memory compaction for node X>
  |  node X's zone  | node Y's zone
  +-----------------+------------------------------...
   pageblock  ^     ^   ^
  +-----------+-----------+-----------+-----------+...
              ^     ^   ^
              ^     ^    pfn
              ^      end_pfn
               start_pfn
              <---------> scanned range by "Scan Before"

It seems that there is no good reason to skip nr_isolated pages just after
given pfn.  So let perform simple scan from start to end instead of
dividing the scan into "Before" and "After".

Link: https://lkml.kernel.org/r/20221026112438.236336-1-a.naribayashi@fujitsu.com
Fixes: 6e2b7044c199 ("mm, compaction: make fast_isolate_freepages() stay within zone").
Signed-off-by: NARIBAYASHI Akira <a.naribayashi@fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/mm/compaction.c~mm-compaction-fix-fast_isolate_around-to-stay-within-boundaries
+++ a/mm/compaction.c
@@ -1344,7 +1344,7 @@ move_freelist_tail(struct list_head *fre
 }
 
 static void
-fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long nr_isolated)
+fast_isolate_around(struct compact_control *cc, unsigned long pfn)
 {
 	unsigned long start_pfn, end_pfn;
 	struct page *page;
@@ -1365,21 +1365,13 @@ fast_isolate_around(struct compact_contr
 	if (!page)
 		return;
 
-	/* Scan before */
-	if (start_pfn != pfn) {
-		isolate_freepages_block(cc, &start_pfn, pfn, &cc->freepages, 1, false);
-		if (cc->nr_freepages >= cc->nr_migratepages)
-			return;
-	}
-
-	/* Scan after */
-	start_pfn = pfn + nr_isolated;
-	if (start_pfn < end_pfn)
-		isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
+	isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
 
 	/* Skip this pageblock in the future as it's full or nearly full */
 	if (cc->nr_freepages < cc->nr_migratepages)
 		set_pageblock_skip(page);
+
+	return;
 }
 
 /* Search orders in round-robin fashion */
@@ -1556,7 +1548,7 @@ fast_isolate_freepages(struct compact_co
 		return cc->free_pfn;
 
 	low_pfn = page_to_pfn(page);
-	fast_isolate_around(cc, low_pfn, nr_isolated);
+	fast_isolate_around(cc, low_pfn);
 	return low_pfn;
 }
 
_

Patches currently in -mm which might be from a.naribayashi@fujitsu.com are


