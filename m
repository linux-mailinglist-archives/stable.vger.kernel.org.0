Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A7432893E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239045AbhCARw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:52:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238601AbhCARq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:46:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5775264FDE;
        Mon,  1 Mar 2021 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617961;
        bh=GAieCucoDde/ZnMItvPfj7iAPnikNWND+5KHjCPNB6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WngwqxWpWdVvN0zuOJz/VpI5rtU14kb1+8SILw3wO1fFNqxA6G6kTG9hATOJxpaMv
         bMzHXVmKL9k0+LyBlXBfDD20y4iqzNia3bB/l8uCp3MZyEpk9M7Nd/Zshn/SbUr9mc
         4cnoefUdmFwGKvXHfTqckjSjm06GhPO9UaWdO778=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wonhyuk Yang <vvghjk1234@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 229/340] mm/compaction: fix misbehaviors of fast_find_migrateblock()
Date:   Mon,  1 Mar 2021 17:12:53 +0100
Message-Id: <20210301161059.565899423@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wonhyuk Yang <vvghjk1234@gmail.com>

[ Upstream commit 15d28d0d11609c7a4f217b3d85e26456d9beb134 ]

In the fast_find_migrateblock(), it iterates ocer the freelist to find the
proper pageblock.  But there are some misbehaviors.

First, if the page we found is equal to cc->migrate_pfn, it is considered
that we didn't find a suitable pageblock.  Secondly, if the loop was
terminated because order is less than PAGE_ALLOC_COSTLY_ORDER, it could be
considered that we found a suitable one.  Thirdly, if the skip bit is set
on the page block and we goto continue, it doesn't check nr_scanned.
Fourthly, if the page block's skip bit is set, it checks that page block
is the last of list, which is unnecessary.

Link: https://lkml.kernel.org/r/20210128130411.6125-1-vvghjk1234@gmail.com
Fixes: 70b44595eafe9 ("mm, compaction: use free lists to quickly locate a migration source")
Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/compaction.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 88c3f6bad1aba..d686887856fee 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1630,6 +1630,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 	unsigned long pfn = cc->migrate_pfn;
 	unsigned long high_pfn;
 	int order;
+	bool found_block = false;
 
 	/* Skip hints are relied on to avoid repeats on the fast search */
 	if (cc->ignore_skip_hint)
@@ -1672,7 +1673,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 	high_pfn = pageblock_start_pfn(cc->migrate_pfn + distance);
 
 	for (order = cc->order - 1;
-	     order >= PAGE_ALLOC_COSTLY_ORDER && pfn == cc->migrate_pfn && nr_scanned < limit;
+	     order >= PAGE_ALLOC_COSTLY_ORDER && !found_block && nr_scanned < limit;
 	     order--) {
 		struct free_area *area = &cc->zone->free_area[order];
 		struct list_head *freelist;
@@ -1687,7 +1688,11 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 		list_for_each_entry(freepage, freelist, lru) {
 			unsigned long free_pfn;
 
-			nr_scanned++;
+			if (nr_scanned++ >= limit) {
+				move_freelist_tail(freelist, freepage);
+				break;
+			}
+
 			free_pfn = page_to_pfn(freepage);
 			if (free_pfn < high_pfn) {
 				/*
@@ -1696,12 +1701,8 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 				 * the list assumes an entry is deleted, not
 				 * reordered.
 				 */
-				if (get_pageblock_skip(freepage)) {
-					if (list_is_last(freelist, &freepage->lru))
-						break;
-
+				if (get_pageblock_skip(freepage))
 					continue;
-				}
 
 				/* Reorder to so a future search skips recent pages */
 				move_freelist_tail(freelist, freepage);
@@ -1709,15 +1710,10 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 				update_fast_start_pfn(cc, free_pfn);
 				pfn = pageblock_start_pfn(free_pfn);
 				cc->fast_search_fail = 0;
+				found_block = true;
 				set_pageblock_skip(freepage);
 				break;
 			}
-
-			if (nr_scanned >= limit) {
-				cc->fast_search_fail++;
-				move_freelist_tail(freelist, freepage);
-				break;
-			}
 		}
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 	}
@@ -1728,9 +1724,10 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 	 * If fast scanning failed then use a cached entry for a page block
 	 * that had free pages as the basis for starting a linear scan.
 	 */
-	if (pfn == cc->migrate_pfn)
+	if (!found_block) {
+		cc->fast_search_fail++;
 		pfn = reinit_migrate_pfn(cc);
-
+	}
 	return pfn;
 }
 
-- 
2.27.0



