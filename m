Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A3720320C
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 10:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgFVI0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 04:26:42 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:38437 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgFVI0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 04:26:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=richard.weiyang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0U0KirUE_1592814395;
Received: from localhost(mailfrom:richard.weiyang@linux.alibaba.com fp:SMTPD_---0U0KirUE_1592814395)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Jun 2020 16:26:36 +0800
Date:   Mon, 22 Jun 2020 16:26:35 +0800
From:   Wei Yang <richard.weiyang@linux.alibaba.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Huang Ying <ying.huang@intel.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH v2 1/3] mm/shuffle: don't move pages between zones and
 don't read garbage memmaps
Message-ID: <20200622082635.GA93552@L-31X9LVDL-1304.local>
Reply-To: Wei Yang <richard.weiyang@linux.alibaba.com>
References: <20200619125923.22602-1-david@redhat.com>
 <20200619125923.22602-2-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619125923.22602-2-david@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 02:59:20PM +0200, David Hildenbrand wrote:
>Especially with memory hotplug, we can have offline sections (with a
>garbage memmap) and overlapping zones. We have to make sure to only
>touch initialized memmaps (online sections managed by the buddy) and that
>the zone matches, to not move pages between zones.
>
>To test if this can actually happen, I added a simple
>	BUG_ON(page_zone(page_i) != page_zone(page_j));
>right before the swap. When hotplugging a 256M DIMM to a 4G x86-64 VM and
>onlining the first memory block "online_movable" and the second memory
>block "online_kernel", it will trigger the BUG, as both zones (NORMAL
>and MOVABLE) overlap.
>
>This might result in all kinds of weird situations (e.g., double
>allocations, list corruptions, unmovable allocations ending up in the
>movable zone).
>
>Fixes: e900a918b098 ("mm: shuffle initial free memory to improve memory-side-cache utilization")
>Acked-by: Michal Hocko <mhocko@suse.com>
>Cc: stable@vger.kernel.org # v5.2+
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Johannes Weiner <hannes@cmpxchg.org>
>Cc: Michal Hocko <mhocko@suse.com>
>Cc: Minchan Kim <minchan@kernel.org>
>Cc: Huang Ying <ying.huang@intel.com>
>Cc: Wei Yang <richard.weiyang@gmail.com>
>Cc: Mel Gorman <mgorman@techsingularity.net>
>Signed-off-by: David Hildenbrand <david@redhat.com>
>---
> mm/shuffle.c | 18 +++++++++---------
> 1 file changed, 9 insertions(+), 9 deletions(-)
>
>diff --git a/mm/shuffle.c b/mm/shuffle.c
>index 44406d9977c77..dd13ab851b3ee 100644
>--- a/mm/shuffle.c
>+++ b/mm/shuffle.c
>@@ -58,25 +58,25 @@ module_param_call(shuffle, shuffle_store, shuffle_show, &shuffle_param, 0400);
>  * For two pages to be swapped in the shuffle, they must be free (on a
>  * 'free_area' lru), have the same order, and have the same migratetype.
>  */
>-static struct page * __meminit shuffle_valid_page(unsigned long pfn, int order)
>+static struct page * __meminit shuffle_valid_page(struct zone *zone,
>+						  unsigned long pfn, int order)
> {
>-	struct page *page;
>+	struct page *page = pfn_to_online_page(pfn);

Hi, David and Dan,

One thing I want to confirm here is we won't have partially online section,
right? We can add a sub-section to system, but we won't manage it by buddy.

With this confirmed:

Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>

> 
> 	/*
> 	 * Given we're dealing with randomly selected pfns in a zone we
> 	 * need to ask questions like...
> 	 */
> 
>-	/* ...is the pfn even in the memmap? */
>-	if (!pfn_valid_within(pfn))
>+	/* ... is the page managed by the buddy? */
>+	if (!page)
> 		return NULL;
> 
>-	/* ...is the pfn in a present section or a hole? */
>-	if (!pfn_in_present_section(pfn))
>+	/* ... is the page assigned to the same zone? */
>+	if (page_zone(page) != zone)
> 		return NULL;
> 
> 	/* ...is the page free and currently on a free_area list? */
>-	page = pfn_to_page(pfn);
> 	if (!PageBuddy(page))
> 		return NULL;
> 
>@@ -123,7 +123,7 @@ void __meminit __shuffle_zone(struct zone *z)
> 		 * page_j randomly selected in the span @zone_start_pfn to
> 		 * @spanned_pages.
> 		 */
>-		page_i = shuffle_valid_page(i, order);
>+		page_i = shuffle_valid_page(z, i, order);
> 		if (!page_i)
> 			continue;
> 
>@@ -137,7 +137,7 @@ void __meminit __shuffle_zone(struct zone *z)
> 			j = z->zone_start_pfn +
> 				ALIGN_DOWN(get_random_long() % z->spanned_pages,
> 						order_pages);
>-			page_j = shuffle_valid_page(j, order);
>+			page_j = shuffle_valid_page(z, j, order);
> 			if (page_j && page_j != page_i)
> 				break;
> 		}
>-- 
>2.26.2

-- 
Wei Yang
Help you, Help me
