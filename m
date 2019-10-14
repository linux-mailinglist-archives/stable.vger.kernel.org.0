Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745A7D6B1A
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 23:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732540AbfJNVMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 17:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732523AbfJNVMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 17:12:09 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 602DC21A4A;
        Mon, 14 Oct 2019 21:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571087528;
        bh=Q7X6T2PXxhj2oVmBCuIijm5tqwoHiwosN6cJNCTDK3I=;
        h=Date:From:To:Subject:From;
        b=JSe4FYbTRr8kBYPOM1gy0qxcYPApeUWJfxKPbti/2PapLeibX0Kc4mgOtca5zo94E
         smbyfUJgcInHPVw1FBfJAhEfoHQ7/2a+JK69pnsr/3IarX1c6pgPit2Xo5UcEKPnLV
         sfxr8fP9DSAbB/6NlRla7dgjPFBRd1fkJ9Wv9CG0=
Date:   Mon, 14 Oct 2019 14:12:07 -0700
From:   akpm@linux-foundation.org
To:     stable@vger.kernel.org, mgorman@techsingularity.net,
        fw@deneb.enyo.de, david@fromorbit.com, vbabka@suse.cz,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 09/16] mm, compaction: fix wrong pfn handling in
 __reset_isolation_pfn()
Message-ID: <20191014211207.DA832%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
