Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3ACE25B408
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 20:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgIBSna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 14:43:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:55080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgIBSna (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 14:43:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 26FE8B5B7;
        Wed,  2 Sep 2020 18:43:30 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     stable@vger.kernel.org
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 4.4] mm, page_alloc: remove unnecessary variable from free_pcppages_bulk
Date:   Wed,  2 Sep 2020 20:43:27 +0200
Message-Id: <20200902184327.12530-1-dwagner@suse.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

[ Upstream commit e5b31ac2ca2cd0cf6bf2fcbb708ed01466c89aaa ]

The original count is never reused so it can be removed.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[dwagner: update context]
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
Hi,

The backport commit 0c9ce43da97d ("mm, page_alloc: fix core hung in
free_pcppages_bulk()") has the depency to this commit. It went in v4.6
so only v4.4 is effected.

Thanks,
Daniel

 mm/page_alloc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 14bab5fa1b65..3570aaf2a620 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -835,7 +835,6 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 {
 	int migratetype = 0;
 	int batch_free = 0;
-	int to_free = count;
 	unsigned long nr_scanned;
 
 	spin_lock(&zone->lock);
@@ -848,7 +847,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	 * below while (list_empty(list)) loop.
 	 */
 	count = min(pcp->count, count);
-	while (to_free) {
+	while (count) {
 		struct page *page;
 		struct list_head *list;
 
@@ -868,7 +867,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 
 		/* This is the only non-empty list. Free them all. */
 		if (batch_free == MIGRATE_PCPTYPES)
-			batch_free = to_free;
+			batch_free = count;
 
 		do {
 			int mt;	/* migratetype of the to-be-freed page */
@@ -886,7 +885,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 
 			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
-		} while (--to_free && --batch_free && !list_empty(list));
+		} while (--count && --batch_free && !list_empty(list));
 	}
 	spin_unlock(&zone->lock);
 }
-- 
2.28.0

