Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19182E42EA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406903AbgL1Nv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:51:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406890AbgL1Nv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:51:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BC9E20715;
        Mon, 28 Dec 2020 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163447;
        bh=akz7nByIKvgDJzQgKTh2hbYlCWq3gOtcjvTq+o5Az4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QB4yW1hjiwS8et1yUIgAbK/ICY7hBwB0yaUgFVTjIfVTKxc3y+uiixgIXADW7RRS+
         aIbaF7WElBhFRh/VY8CvJt0SGr5z7y1/OT9FK9gm8ik6UQvaLM4zMnqndP6SWb277o
         GdjmcQsPIuM1T8AcA2Zz4GuKpIzqS1y+Po2S5BxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 289/453] mm: dont wake kswapd prematurely when watermark boosting is disabled
Date:   Mon, 28 Dec 2020 13:48:45 +0100
Message-Id: <20201228124951.113816771@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit 597c892038e08098b17ccfe65afd9677e6979800 ]

On 2-node NUMA hosts we see bursts of kswapd reclaim and subsequent
pressure spikes and stalls from cache refaults while there is plenty of
free memory in the system.

Usually, kswapd is woken up when all eligible nodes in an allocation are
full.  But the code related to watermark boosting can wake kswapd on one
full node while the other one is mostly empty.  This may be justified to
fight fragmentation, but is currently unconditionally done whether
watermark boosting is occurring or not.

In our case, many of our workloads' throughput scales with available
memory, and pure utilization is a more tangible concern than trends
around longer-term fragmentation.  As a result we generally disable
watermark boosting.

Wake kswapd only woken when watermark boosting is requested.

Link: https://lkml.kernel.org/r/20201020175833.397286-1-hannes@cmpxchg.org
Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1c869c6b825f3..4357f5475a504 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2346,12 +2346,12 @@ static bool can_steal_fallback(unsigned int order, int start_mt)
 	return false;
 }
 
-static inline void boost_watermark(struct zone *zone)
+static inline bool boost_watermark(struct zone *zone)
 {
 	unsigned long max_boost;
 
 	if (!watermark_boost_factor)
-		return;
+		return false;
 	/*
 	 * Don't bother in zones that are unlikely to produce results.
 	 * On small machines, including kdump capture kernels running
@@ -2359,7 +2359,7 @@ static inline void boost_watermark(struct zone *zone)
 	 * memory situation immediately.
 	 */
 	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
-		return;
+		return false;
 
 	max_boost = mult_frac(zone->_watermark[WMARK_HIGH],
 			watermark_boost_factor, 10000);
@@ -2373,12 +2373,14 @@ static inline void boost_watermark(struct zone *zone)
 	 * boosted watermark resulting in a hang.
 	 */
 	if (!max_boost)
-		return;
+		return false;
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
 	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
 		max_boost);
+
+	return true;
 }
 
 /*
@@ -2417,8 +2419,7 @@ static void steal_suitable_fallback(struct zone *zone, struct page *page,
 	 * likelihood of future fallbacks. Wake kswapd now as the node
 	 * may be balanced overall and kswapd will not wake naturally.
 	 */
-	boost_watermark(zone);
-	if (alloc_flags & ALLOC_KSWAPD)
+	if (boost_watermark(zone) && (alloc_flags & ALLOC_KSWAPD))
 		set_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
 
 	/* We are not allowed to try stealing from the whole block */
-- 
2.27.0



