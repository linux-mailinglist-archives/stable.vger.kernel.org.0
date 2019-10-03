Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDC3CACAC
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbfJCQOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:14:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388541AbfJCQON (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:14:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B351520865;
        Thu,  3 Oct 2019 16:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119252;
        bh=jCpjBMoXOqDB2adKnl5Oq4QiFrn57XrTTlkr3kExZes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUgeEbP4zVg0R0FWs8Nh2FoUdZveyoXmEt54HgxVCiAEqQYOSmnrso+c2s1qsIzAR
         5SOgpEhK6Nv2HyHMeU6pmkYXqeWK4NBgbowYlrCqPpgatrenMsYO3osGFDpdu0hlZ7
         vs9kUL7eT5nYSeeQsq14c2jGyEzwUj/VlshglPaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Yafang Shao <shaoyafang@didiglobal.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 183/185] mm/compaction.c: clear total_{migrate,free}_scanned before scanning a new zone
Date:   Thu,  3 Oct 2019 17:54:21 +0200
Message-Id: <20191003154522.282309670@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit a94b525241c0fff3598809131d7cfcfe1d572d8c ]

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/compaction.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 85395dc6eb137..eb8e7f5d3a08e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1517,6 +1517,17 @@ static enum compact_result compact_zone(struct zone *zone, struct compact_contro
 	unsigned long end_pfn = zone_end_pfn(zone);
 	const bool sync = cc->mode != MIGRATE_ASYNC;
 
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
 	ret = compaction_suitable(zone, cc->order, cc->alloc_flags,
 							cc->classzone_idx);
@@ -1680,10 +1691,6 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
 {
 	enum compact_result ret;
 	struct compact_control cc = {
-		.nr_freepages = 0,
-		.nr_migratepages = 0,
-		.total_migrate_scanned = 0,
-		.total_free_scanned = 0,
 		.order = order,
 		.gfp_mask = gfp_mask,
 		.zone = zone,
@@ -1696,8 +1703,6 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
 		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY),
 		.ignore_block_suitable = (prio == MIN_COMPACT_PRIORITY)
 	};
-	INIT_LIST_HEAD(&cc.freepages);
-	INIT_LIST_HEAD(&cc.migratepages);
 
 	ret = compact_zone(zone, &cc);
 
@@ -1796,8 +1801,6 @@ static void compact_node(int nid)
 	struct zone *zone;
 	struct compact_control cc = {
 		.order = -1,
-		.total_migrate_scanned = 0,
-		.total_free_scanned = 0,
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 		.whole_zone = true,
@@ -1811,11 +1814,7 @@ static void compact_node(int nid)
 		if (!populated_zone(zone))
 			continue;
 
-		cc.nr_freepages = 0;
-		cc.nr_migratepages = 0;
 		cc.zone = zone;
-		INIT_LIST_HEAD(&cc.freepages);
-		INIT_LIST_HEAD(&cc.migratepages);
 
 		compact_zone(zone, &cc);
 
@@ -1924,8 +1923,6 @@ static void kcompactd_do_work(pg_data_t *pgdat)
 	struct zone *zone;
 	struct compact_control cc = {
 		.order = pgdat->kcompactd_max_order,
-		.total_migrate_scanned = 0,
-		.total_free_scanned = 0,
 		.classzone_idx = pgdat->kcompactd_classzone_idx,
 		.mode = MIGRATE_SYNC_LIGHT,
 		.ignore_skip_hint = true,
@@ -1950,16 +1947,10 @@ static void kcompactd_do_work(pg_data_t *pgdat)
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
 		status = compact_zone(zone, &cc);
 
 		if (status == COMPACT_SUCCESS) {
-- 
2.20.1



