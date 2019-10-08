Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00D2CFD9E
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfJHP3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:29:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:50234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbfJHP3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 11:29:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D112B1B6;
        Tue,  8 Oct 2019 15:29:30 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Florian Weimer <fw@deneb.enyo.de>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] mm, compaction: fix wrong pfn handling in __reset_isolation_pfn()
Date:   Tue,  8 Oct 2019 17:29:15 +0200
Message-Id: <20191008152915.24704-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Florian and Dave reported [1] a NULL pointer dereference in
__reset_isolation_pfn(). While the exact cause is unclear, staring at the code
revealed two bugs, which might be related.

One bug is that if zone starts in the middle of pageblock, block_page might
correspond to different pfn than block_pfn, and then the pfn_valid_within()
checks will check different pfn's than those accessed via struct page. This
might result in acessing an unitialized page in CONFIG_HOLES_IN_ZONE configs.

The other bug is that end_page refers to the first page of next pageblock and
not last page of current pageblock. The online and valid check is then wrong
and with sections, the while (page < end_page) loop might wander off actual
struct page arrays.

[1] https://lore.kernel.org/linux-xfs/87o8z1fvqu.fsf@mid.deneb.enyo.de/

Reported-by: Florian Weimer <fw@deneb.enyo.de>
Reported-by: Dave Chinner <david@fromorbit.com>
Fixes: 6b0868c820ff ("mm/compaction.c: correct zone boundary handling when resetting pageblock skip hints")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/compaction.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index ce08b39d85d4..672d3c78c6ab 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -270,14 +270,15 @@ __reset_isolation_pfn(struct zone *zone, unsigned long pfn, bool check_source,
 
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
@@ -303,7 +304,7 @@ __reset_isolation_pfn(struct zone *zone, unsigned long pfn, bool check_source,
 
 		page += (1 << PAGE_ALLOC_COSTLY_ORDER);
 		pfn += (1 << PAGE_ALLOC_COSTLY_ORDER);
-	} while (page < end_page);
+	} while (page <= end_page);
 
 	return false;
 }
-- 
2.23.0

