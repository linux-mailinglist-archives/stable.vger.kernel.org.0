Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866C3200938
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732942AbgFSM7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 08:59:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30762 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732914AbgFSM7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 08:59:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592571580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8MQWLpEjUwKS/f3ehtlBKkUYUgruSbsLYJMJymo8VE=;
        b=WD1xPzReyEQnP4GzY7yF9G3YJTn4onodFQ8GTiucQcoBuWvQo6kaERYnpLhSbPJur33/nW
        6SEj9QhMwxg4SRvoZS46UXvZkzcvYovdCQnR8uIJ8eyJzG0xoN0+3hDmEUtew8HjJk/tC2
        op8cxQFHprTh8UuM7/wsaiG7VjMl5oQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-gYNxaS0bPK2dCVjUmxwz4g-1; Fri, 19 Jun 2020 08:59:36 -0400
X-MC-Unique: gYNxaS0bPK2dCVjUmxwz4g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95F54835B45;
        Fri, 19 Jun 2020 12:59:34 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-137.ams2.redhat.com [10.36.113.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21CEC5D9CA;
        Fri, 19 Jun 2020 12:59:31 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Huang Ying <ying.huang@intel.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH v2 1/3] mm/shuffle: don't move pages between zones and don't read garbage memmaps
Date:   Fri, 19 Jun 2020 14:59:20 +0200
Message-Id: <20200619125923.22602-2-david@redhat.com>
In-Reply-To: <20200619125923.22602-1-david@redhat.com>
References: <20200619125923.22602-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Especially with memory hotplug, we can have offline sections (with a
garbage memmap) and overlapping zones. We have to make sure to only
touch initialized memmaps (online sections managed by the buddy) and that
the zone matches, to not move pages between zones.

To test if this can actually happen, I added a simple
	BUG_ON(page_zone(page_i) != page_zone(page_j));
right before the swap. When hotplugging a 256M DIMM to a 4G x86-64 VM and
onlining the first memory block "online_movable" and the second memory
block "online_kernel", it will trigger the BUG, as both zones (NORMAL
and MOVABLE) overlap.

This might result in all kinds of weird situations (e.g., double
allocations, list corruptions, unmovable allocations ending up in the
movable zone).

Fixes: e900a918b098 ("mm: shuffle initial free memory to improve memory-side-cache utilization")
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: stable@vger.kernel.org # v5.2+
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/shuffle.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/shuffle.c b/mm/shuffle.c
index 44406d9977c77..dd13ab851b3ee 100644
--- a/mm/shuffle.c
+++ b/mm/shuffle.c
@@ -58,25 +58,25 @@ module_param_call(shuffle, shuffle_store, shuffle_show, &shuffle_param, 0400);
  * For two pages to be swapped in the shuffle, they must be free (on a
  * 'free_area' lru), have the same order, and have the same migratetype.
  */
-static struct page * __meminit shuffle_valid_page(unsigned long pfn, int order)
+static struct page * __meminit shuffle_valid_page(struct zone *zone,
+						  unsigned long pfn, int order)
 {
-	struct page *page;
+	struct page *page = pfn_to_online_page(pfn);
 
 	/*
 	 * Given we're dealing with randomly selected pfns in a zone we
 	 * need to ask questions like...
 	 */
 
-	/* ...is the pfn even in the memmap? */
-	if (!pfn_valid_within(pfn))
+	/* ... is the page managed by the buddy? */
+	if (!page)
 		return NULL;
 
-	/* ...is the pfn in a present section or a hole? */
-	if (!pfn_in_present_section(pfn))
+	/* ... is the page assigned to the same zone? */
+	if (page_zone(page) != zone)
 		return NULL;
 
 	/* ...is the page free and currently on a free_area list? */
-	page = pfn_to_page(pfn);
 	if (!PageBuddy(page))
 		return NULL;
 
@@ -123,7 +123,7 @@ void __meminit __shuffle_zone(struct zone *z)
 		 * page_j randomly selected in the span @zone_start_pfn to
 		 * @spanned_pages.
 		 */
-		page_i = shuffle_valid_page(i, order);
+		page_i = shuffle_valid_page(z, i, order);
 		if (!page_i)
 			continue;
 
@@ -137,7 +137,7 @@ void __meminit __shuffle_zone(struct zone *z)
 			j = z->zone_start_pfn +
 				ALIGN_DOWN(get_random_long() % z->spanned_pages,
 						order_pages);
-			page_j = shuffle_valid_page(j, order);
+			page_j = shuffle_valid_page(z, j, order);
 			if (page_j && page_j != page_i)
 				break;
 		}
-- 
2.26.2

