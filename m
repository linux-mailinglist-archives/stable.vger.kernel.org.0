Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F11ED00E3
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 20:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfJHS5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 14:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfJHS5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 14:57:24 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0297E21721;
        Tue,  8 Oct 2019 18:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570561043;
        bh=c4YRXWdPGFNd5hBHtGyc54K1HGpFH30decmaD1YI6dg=;
        h=Date:From:To:Subject:From;
        b=OfJPRjzSUMhNLFZ1HFaO2lw93gsmoAsOwywLJi/bnXJp8SBLm3nU12WPzAtixqdcN
         47IV6TlLjXkFJZizwInfJX778MaCPQYcVhDw+INnSdATx/iKHPvxdGuzkbign0rYZw
         usI5B3NZpws3UMUokgeXITFjqx9hbyejybMf4wVs=
Date:   Tue, 08 Oct 2019 11:57:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mgorman@techsingularity.net, fw@deneb.enyo.de, david@fromorbit.com,
        vbabka@suse.cz
Subject:  +
 mm-compaction-fix-wrong-pfn-handling-in-__reset_isolation_pfn.patch added to
 -mm tree
Message-ID: <20191008185722.Nef03%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, compaction: fix wrong pfn handling in __reset_isolation_pfn()
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-wrong-pfn-handling-in-__reset_isolation_pfn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-fix-wrong-pfn-handling-in-__reset_isolation_pfn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-fix-wrong-pfn-handling-in-__reset_isolation_pfn.patch

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
Subject: mm, compaction: fix wrong pfn handling in __reset_isolation_pfn()

Florian and Dave reported [1] a NULL pointer dereference in
__reset_isolation_pfn().  While the exact cause is unclear, staring at the
code revealed two bugs, which might be related.

One bug is that if zone starts in the middle of pageblock, block_page
might correspond to different pfn than block_pfn, and then the
pfn_valid_within() checks will check different pfn's than those accessed
via struct page.  This might result in acessing an unitialized page in
CONFIG_HOLES_IN_ZONE configs.

The other bug is that end_page refers to the first page of next pageblock
and not last page of current pageblock.  The online and valid check is
then wrong and with sections, the while (page < end_page) loop might
wander off actual struct page arrays.

[1] https://lore.kernel.org/linux-xfs/87o8z1fvqu.fsf@mid.deneb.enyo.de/

Link: http://lkml.kernel.org/r/20191008152915.24704-1-vbabka@suse.cz
Fixes: 6b0868c820ff ("mm/compaction.c: correct zone boundary handling when resetting pageblock skip hints")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Florian Weimer <fw@deneb.enyo.de>
Reported-by: Dave Chinner <david@fromorbit.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-fix-wrong-pfn-handling-in-__reset_isolation_pfn
+++ a/mm/compaction.c
@@ -270,14 +270,15 @@ __reset_isolation_pfn(struct zone *zone,
 
 	/* Ensure the start of the pageblock or zone is online and valid */
 	block_pfn = pageblock_start_pfn(pfn);
-	block_page = pfn_to_online_page(max(block_pfn, zone->zone_start_pfn));
+	block_pfn = max(block_pfn, zone->zone_start_pfn);
+	block_page = pfn_to_online_page(block_pfn);
 	if (block_page) {
 		page = block_page;
 		pfn = block_pfn;
 	}
 
 	/* Ensure the end of the pageblock or zone is online and valid */
-	block_pfn += pageblock_nr_pages;
+	block_pfn = pageblock_end_pfn(pfn) - 1;
 	block_pfn = min(block_pfn, zone_end_pfn(zone) - 1);
 	end_page = pfn_to_online_page(block_pfn);
 	if (!end_page)
@@ -303,7 +304,7 @@ __reset_isolation_pfn(struct zone *zone,
 
 		page += (1 << PAGE_ALLOC_COSTLY_ORDER);
 		pfn += (1 << PAGE_ALLOC_COSTLY_ORDER);
-	} while (page < end_page);
+	} while (page <= end_page);
 
 	return false;
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_owner-fix-off-by-one-error-in-__set_page_owner_handle.patch
mm-page_owner-decouple-freeing-stack-trace-from-debug_pagealloc.patch
mm-page_owner-decouple-freeing-stack-trace-from-debug_pagealloc-v3.patch
mm-page_owner-rename-flag-indicating-that-page-is-allocated.patch
mm-compaction-fix-wrong-pfn-handling-in-__reset_isolation_pfn.patch

