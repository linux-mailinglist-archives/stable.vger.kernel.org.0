Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1244F30CF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244403AbiDEKip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbiDEJeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:34:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35C0811A1;
        Tue,  5 Apr 2022 02:23:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E010C615E4;
        Tue,  5 Apr 2022 09:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF16CC385A2;
        Tue,  5 Apr 2022 09:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150602;
        bh=F2sXadztW3MARwarwpZlIp38N5A1LAVO17ur1+LgINs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihZBfF/UwaZROb9R6rcCsdYRgyNCENTJdkpgjasUuKq3rOLqS0fNpoQlXfdaCEntR
         lhYyAkM5esxT2U1WkrlFpNpmP21dNKlBWbUnofSU/CuYe1s1XaYj4/H60+Eken3Zn6
         eOAxePca+qjUrasxsxu1waKLj7HijREORUed6z5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.15 112/913] dm stats: fix too short end duration_ns when using precise_timestamps
Date:   Tue,  5 Apr 2022 09:19:34 +0200
Message-Id: <20220405070343.184612912@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit 0cdb90f0f306384ecbc60dfd6dc48cdbc1f2d0d8 upstream.

dm_stats_account_io()'s STAT_PRECISE_TIMESTAMPS support doesn't handle
the fact that with commit b879f915bc48 ("dm: properly fix redundant
bio-based IO accounting") io->start_time _may_ be in the past (meaning
the start_io_acct() was deferred until later).

Add a new dm_stats_recalc_precise_timestamps() helper that will
set/clear a new 'precise_timestamps' flag in the dm_stats struct based
on whether any configured stats enable STAT_PRECISE_TIMESTAMPS.
And update DM core's alloc_io() to use dm_stats_record_start() to set
stats_aux.duration_ns if stats->precise_timestamps is true.

Also, remove unused 'last_sector' and 'last_rw' members from the
dm_stats struct.

Fixes: b879f915bc48 ("dm: properly fix redundant bio-based IO accounting")
Cc: stable@vger.kernel.org
Co-developed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |   28 +++++++++++++++++++++++++---
 drivers/md/dm-stats.h |    9 +++++++--
 drivers/md/dm.c       |    2 ++
 3 files changed, 34 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -195,6 +195,7 @@ void dm_stats_init(struct dm_stats *stat
 
 	mutex_init(&stats->mutex);
 	INIT_LIST_HEAD(&stats->list);
+	stats->precise_timestamps = false;
 	stats->last = alloc_percpu(struct dm_stats_last_position);
 	for_each_possible_cpu(cpu) {
 		last = per_cpu_ptr(stats->last, cpu);
@@ -231,6 +232,22 @@ void dm_stats_cleanup(struct dm_stats *s
 	mutex_destroy(&stats->mutex);
 }
 
+static void dm_stats_recalc_precise_timestamps(struct dm_stats *stats)
+{
+	struct list_head *l;
+	struct dm_stat *tmp_s;
+	bool precise_timestamps = false;
+
+	list_for_each(l, &stats->list) {
+		tmp_s = container_of(l, struct dm_stat, list_entry);
+		if (tmp_s->stat_flags & STAT_PRECISE_TIMESTAMPS) {
+			precise_timestamps = true;
+			break;
+		}
+	}
+	stats->precise_timestamps = precise_timestamps;
+}
+
 static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 			   sector_t step, unsigned stat_flags,
 			   unsigned n_histogram_entries,
@@ -376,6 +393,9 @@ static int dm_stats_create(struct dm_sta
 	}
 	ret_id = s->id;
 	list_add_tail_rcu(&s->list_entry, l);
+
+	dm_stats_recalc_precise_timestamps(stats);
+
 	mutex_unlock(&stats->mutex);
 
 	resume_callback(md);
@@ -418,6 +438,9 @@ static int dm_stats_delete(struct dm_sta
 	}
 
 	list_del_rcu(&s->list_entry);
+
+	dm_stats_recalc_precise_timestamps(stats);
+
 	mutex_unlock(&stats->mutex);
 
 	/*
@@ -654,9 +677,8 @@ void dm_stats_account_io(struct dm_stats
 	got_precise_time = false;
 	list_for_each_entry_rcu(s, &stats->list, list_entry) {
 		if (s->stat_flags & STAT_PRECISE_TIMESTAMPS && !got_precise_time) {
-			if (!end)
-				stats_aux->duration_ns = ktime_to_ns(ktime_get());
-			else
+			/* start (!end) duration_ns is set by DM core's alloc_io() */
+			if (end)
 				stats_aux->duration_ns = ktime_to_ns(ktime_get()) - stats_aux->duration_ns;
 			got_precise_time = true;
 		}
--- a/drivers/md/dm-stats.h
+++ b/drivers/md/dm-stats.h
@@ -13,8 +13,7 @@ struct dm_stats {
 	struct mutex mutex;
 	struct list_head list;	/* list of struct dm_stat */
 	struct dm_stats_last_position __percpu *last;
-	sector_t last_sector;
-	unsigned last_rw;
+	bool precise_timestamps;
 };
 
 struct dm_stats_aux {
@@ -40,4 +39,10 @@ static inline bool dm_stats_used(struct
 	return !list_empty(&st->list);
 }
 
+static inline void dm_stats_record_start(struct dm_stats *stats, struct dm_stats_aux *aux)
+{
+	if (unlikely(stats->precise_timestamps))
+		aux->duration_ns = ktime_to_ns(ktime_get());
+}
+
 #endif
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -537,6 +537,8 @@ static struct dm_io *alloc_io(struct map
 
 	io->start_time = jiffies;
 
+	dm_stats_record_start(&md->stats, &io->stats_aux);
+
 	return io;
 }
 


