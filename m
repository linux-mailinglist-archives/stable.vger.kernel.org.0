Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCD4BBE8B
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 00:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503400AbfIWWg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 18:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391900AbfIWWg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Sep 2019 18:36:57 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 661B521D7A;
        Mon, 23 Sep 2019 22:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569278215;
        bh=3kod0HlyDJJGTk5KZi6gBA6MivVXNbI+DfBLxF25kCU=;
        h=Date:From:To:Subject:From;
        b=Jsw1sMglk/5IZPcfhTludWvpdT8A7+7m12Mf/Obagpq1nnpK6glhmaAmojrEPbtL/
         xBR8lFJh/bnc7Y6h7qgf7SWJSPFhIgNsaZauW0jU1DHHi/rJPCrPofidZ3ovZSGm6J
         1Z3iRxaK5hf7xS5D/BMkKqg6BGU5Uf8ug61l77Pw=
Date:   Mon, 23 Sep 2019 15:36:54 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, laoar.shao@gmail.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shaoyafang@didiglobal.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 080/134] mm/compaction.c: clear
 total_{migrate,free}_scanned before scanning a new zone
Message-ID: <20190923223654.bfJHSd5uP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/compaction.c: clear total_{migrate,free}_scanned before scanning a new zone

total_{migrate,free}_scanned will be added to COMPACTMIGRATE_SCANNED and
COMPACTFREE_SCANNED in compact_zone().  We should clear them before
scanning a new zone.  In the proc triggered compaction, we forgot clearing
them.

[laoar.shao@gmail.com: introduce a helper compact_zone_counters_init()]
  Link: http://lkml.kernel.org/r/1563869295-25748-1-git-send-email-laoar.shao@gmail.com
[akpm@linux-foundation.org: expand compact_zone_counters_init() into its single callsite, per mhocko]
[vbabka@suse.cz: squash compact_zone() list_head init as well]
  Link: http://lkml.kernel.org/r/1fb6f7da-f776-9e42-22f8-bbb79b030b98@suse.cz
[akpm@linux-foundation.org: kcompactd_do_work(): avoid unnecessary initialization of cc.zone]
Link: http://lkml.kernel.org/r/1563789275-9639-1-git-send-email-laoar.shao@gmail.com
Fixes: 7f354a548d1c ("mm, compaction: add vmstats for kcompactd work")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Yafang Shao <shaoyafang@didiglobal.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

--- a/mm/compaction.c~mm-compaction-clear-total_migratefree_scanned-before-scanning-a-new-zone
+++ a/mm/compaction.c
@@ -2078,6 +2078,17 @@ compact_zone(struct compact_control *cc,
 	const bool sync = cc->mode != MIGRATE_ASYNC;
 	bool update_cached;
 
+	/*
+	 * These counters track activities during zone compaction.  Initialize
+	 * them before compacting a new zone.
+	 */
+	cc->total_migrate_scanned = 0;
+	cc->total_free_scanned = 0;
+	cc->nr_migratepages = 0;
+	cc->nr_freepages = 0;
+	INIT_LIST_HEAD(&cc->freepages);
+	INIT_LIST_HEAD(&cc->migratepages);
+
 	cc->migratetype = gfpflags_to_migratetype(cc->gfp_mask);
 	ret = compaction_suitable(cc->zone, cc->order, cc->alloc_flags,
 							cc->classzone_idx);
@@ -2281,10 +2292,6 @@ static enum compact_result compact_zone_
 {
 	enum compact_result ret;
 	struct compact_control cc = {
-		.nr_freepages = 0,
-		.nr_migratepages = 0,
-		.total_migrate_scanned = 0,
-		.total_free_scanned = 0,
 		.order = order,
 		.search_order = order,
 		.gfp_mask = gfp_mask,
@@ -2305,8 +2312,6 @@ static enum compact_result compact_zone_
 
 	if (capture)
 		current->capture_control = &capc;
-	INIT_LIST_HEAD(&cc.freepages);
-	INIT_LIST_HEAD(&cc.migratepages);
 
 	ret = compact_zone(&cc, &capc);
 
@@ -2408,8 +2413,6 @@ static void compact_node(int nid)
 	struct zone *zone;
 	struct compact_control cc = {
 		.order = -1,
-		.total_migrate_scanned = 0,
-		.total_free_scanned = 0,
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 		.whole_zone = true,
@@ -2423,11 +2426,7 @@ static void compact_node(int nid)
 		if (!populated_zone(zone))
 			continue;
 
-		cc.nr_freepages = 0;
-		cc.nr_migratepages = 0;
 		cc.zone = zone;
-		INIT_LIST_HEAD(&cc.freepages);
-		INIT_LIST_HEAD(&cc.migratepages);
 
 		compact_zone(&cc, NULL);
 
@@ -2529,8 +2528,6 @@ static void kcompactd_do_work(pg_data_t
 	struct compact_control cc = {
 		.order = pgdat->kcompactd_max_order,
 		.search_order = pgdat->kcompactd_max_order,
-		.total_migrate_scanned = 0,
-		.total_free_scanned = 0,
 		.classzone_idx = pgdat->kcompactd_classzone_idx,
 		.mode = MIGRATE_SYNC_LIGHT,
 		.ignore_skip_hint = false,
@@ -2554,16 +2551,10 @@ static void kcompactd_do_work(pg_data_t
 							COMPACT_CONTINUE)
 			continue;
 
-		cc.nr_freepages = 0;
-		cc.nr_migratepages = 0;
-		cc.total_migrate_scanned = 0;
-		cc.total_free_scanned = 0;
-		cc.zone = zone;
-		INIT_LIST_HEAD(&cc.freepages);
-		INIT_LIST_HEAD(&cc.migratepages);
-
 		if (kthread_should_stop())
 			return;
+
+		cc.zone = zone;
 		status = compact_zone(&cc, NULL);
 
 		if (status == COMPACT_SUCCESS) {
_
