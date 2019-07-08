Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46087622C8
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389380AbfGHP27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389399AbfGHP26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B6E021537;
        Mon,  8 Jul 2019 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599737;
        bh=v3p0s9VV7bGgXKLIwcoxYndAsqwbD/So0jRgwNwg3So=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhIE2QPGgWHQ0aBbotWu0/zIyF3zGS9AatglNebAj++X/6WPy+TzqyAoBFe63bi8S
         5zPJnpN0fY0q3CG2fCHh4qd8Gtd/tjWtEiwdgpCj2c7bLumoJjR4rQD/sokB3Df/AJ
         mvRfSmT9kzfUcZrHT2OdzYf4duoI+/01oLkhWtP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Hillf Danton <hdanton@sina.com>, Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 61/90] mm/vmscan.c: prevent useless kswapd loops
Date:   Mon,  8 Jul 2019 17:13:28 +0200
Message-Id: <20190708150525.495665322@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

commit dffcac2cb88e4ec5906235d64a83d802580b119e upstream.

In production we have noticed hard lockups on large machines running
large jobs due to kswaps hoarding lru lock within isolate_lru_pages when
sc->reclaim_idx is 0 which is a small zone.  The lru was couple hundred
GiBs and the condition (page_zonenum(page) > sc->reclaim_idx) in
isolate_lru_pages() was basically skipping GiBs of pages while holding
the LRU spinlock with interrupt disabled.

On further inspection, it seems like there are two issues:

(1) If kswapd on the return from balance_pgdat() could not sleep (i.e.
    node is still unbalanced), the classzone_idx is unintentionally set
    to 0 and the whole reclaim cycle of kswapd will try to reclaim only
    the lowest and smallest zone while traversing the whole memory.

(2) Fundamentally isolate_lru_pages() is really bad when the
    allocation has woken kswapd for a smaller zone on a very large machine
    running very large jobs.  It can hoard the LRU spinlock while skipping
    over 100s of GiBs of pages.

This patch only fixes (1).  (2) needs a more fundamental solution.  To
fix (1), in the kswapd context, if pgdat->kswapd_classzone_idx is
invalid use the classzone_idx of the previous kswapd loop otherwise use
the one the waker has requested.

Link: http://lkml.kernel.org/r/20190701201847.251028-1-shakeelb@google.com
Fixes: e716f2eb24de ("mm, vmscan: prevent kswapd sleeping prematurely due to mismatched classzone_idx")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Yang Shi <yang.shi@linux.alibaba.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3599,19 +3599,18 @@ out:
 }
 
 /*
- * pgdat->kswapd_classzone_idx is the highest zone index that a recent
- * allocation request woke kswapd for. When kswapd has not woken recently,
- * the value is MAX_NR_ZONES which is not a valid index. This compares a
- * given classzone and returns it or the highest classzone index kswapd
- * was recently woke for.
+ * The pgdat->kswapd_classzone_idx is used to pass the highest zone index to be
+ * reclaimed by kswapd from the waker. If the value is MAX_NR_ZONES which is not
+ * a valid index then either kswapd runs for first time or kswapd couldn't sleep
+ * after previous reclaim attempt (node is still unbalanced). In that case
+ * return the zone index of the previous kswapd reclaim cycle.
  */
 static enum zone_type kswapd_classzone_idx(pg_data_t *pgdat,
-					   enum zone_type classzone_idx)
+					   enum zone_type prev_classzone_idx)
 {
 	if (pgdat->kswapd_classzone_idx == MAX_NR_ZONES)
-		return classzone_idx;
-
-	return max(pgdat->kswapd_classzone_idx, classzone_idx);
+		return prev_classzone_idx;
+	return pgdat->kswapd_classzone_idx;
 }
 
 static void kswapd_try_to_sleep(pg_data_t *pgdat, int alloc_order, int reclaim_order,
@@ -3752,7 +3751,7 @@ kswapd_try_sleep:
 
 		/* Read the new order and classzone_idx */
 		alloc_order = reclaim_order = pgdat->kswapd_order;
-		classzone_idx = kswapd_classzone_idx(pgdat, 0);
+		classzone_idx = kswapd_classzone_idx(pgdat, classzone_idx);
 		pgdat->kswapd_order = 0;
 		pgdat->kswapd_classzone_idx = MAX_NR_ZONES;
 
@@ -3806,8 +3805,12 @@ void wakeup_kswapd(struct zone *zone, gf
 	if (!cpuset_zone_allowed(zone, gfp_flags))
 		return;
 	pgdat = zone->zone_pgdat;
-	pgdat->kswapd_classzone_idx = kswapd_classzone_idx(pgdat,
-							   classzone_idx);
+
+	if (pgdat->kswapd_classzone_idx == MAX_NR_ZONES)
+		pgdat->kswapd_classzone_idx = classzone_idx;
+	else
+		pgdat->kswapd_classzone_idx = max(pgdat->kswapd_classzone_idx,
+						  classzone_idx);
 	pgdat->kswapd_order = max(pgdat->kswapd_order, order);
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;


