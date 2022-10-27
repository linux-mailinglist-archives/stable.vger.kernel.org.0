Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2CC6102AE
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 22:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbiJ0U1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 16:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbiJ0U1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 16:27:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A29C72B45;
        Thu, 27 Oct 2022 13:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEAA5B827BE;
        Thu, 27 Oct 2022 20:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3FEC433C1;
        Thu, 27 Oct 2022 20:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666902429;
        bh=nGBN2zsMijkjnAjczxoyWuUPsBfXOKbWFRiqfXAmJX0=;
        h=Date:To:From:Subject:From;
        b=fNKYdOaLv7uvEtYUZj4zYISup0HTH2OfPzWInrvz+84vfuXvrmVENwRm+NbO6ba5k
         S+hqhLFTln6q3A0/h24C2sUbu3ewrdnVoXG2CnCmbVKrz8j+eiwhGDnHGmDz6pgD04
         WHJPg+8eaAna5zk/uhq8BeOoVrEoZwieSqEAjt/U=
Date:   Thu, 27 Oct 2022 13:27:08 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        rientjes@google.com, mgorman@techsingularity.net,
        a.naribayashi@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fix-fast_isolate_around-to-stay-within-boundaries.patch added to mm-hotfixes-unstable branch
Message-Id: <20221027202709.3A3FEC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, compaction: fix fast_isolate_around() to stay within boundaries
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-compaction-fix-fast_isolate_around-to-stay-within-boundaries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-fix-fast_isolate_around-to-stay-within-boundaries.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: NARIBAYASHI Akira <a.naribayashi@fujitsu.com>
Subject: mm, compaction: fix fast_isolate_around() to stay within boundaries
Date: Wed, 26 Oct 2022 20:24:38 +0900

Depending on the memory configuration, isolate_freepages_block() may scan
pages out of the target range and causes panic.

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

mm-compaction-fix-fast_isolate_around-to-stay-within-boundaries.patch

