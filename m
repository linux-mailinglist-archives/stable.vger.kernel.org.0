Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA4F4F25B1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiDEHvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiDEHrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186CCE01E;
        Tue,  5 Apr 2022 00:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36F52B81B7F;
        Tue,  5 Apr 2022 07:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09D8C340EE;
        Tue,  5 Apr 2022 07:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144629;
        bh=ZxgY+DG0V/m8ix9O/dK77iX00sKsYy35vR68jBeaAoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSU3bm9a8/o5kN/FK9G/wKiJGIfft8CluobWG2JXNU9y+S/j824m6ULKIoIe3UZhv
         OESRd9PsPI6boFfaW0CFtF4fYpihaayj9t/dRknoOSOk8poX2uHrCR33bjmxYXHoed
         yXhehS++jSA6lg/HsRhntnKKmwxzcbC9IjW6o2C0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.17 0114/1126] dm: fix double accounting of flush with data
Date:   Tue,  5 Apr 2022 09:14:21 +0200
Message-Id: <20220405070410.916850191@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

commit 8d394bc4adf588ca4a0650745167cb83f86c18c9 upstream.

DM handles a flush with data by first issuing an empty flush and then
once it completes the REQ_PREFLUSH flag is removed and the payload is
issued.  The problem fixed by this commit is that both the empty flush
bio and the data payload will account the full extent of the data
payload.

Fix this by factoring out dm_io_acct() and having it wrap all IO
accounting to set the size of  bio with REQ_PREFLUSH to 0, account the
IO, and then restore the original size.

Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    6 ++++--
 drivers/md/dm-stats.h |    2 +-
 drivers/md/dm.c       |   47 +++++++++++++++++++++++++++++++++--------------
 3 files changed, 38 insertions(+), 17 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -644,13 +644,14 @@ static void __dm_stat_bio(struct dm_stat
 
 void dm_stats_account_io(struct dm_stats *stats, unsigned long bi_rw,
 			 sector_t bi_sector, unsigned bi_sectors, bool end,
-			 unsigned long duration_jiffies,
+			 unsigned long start_time,
 			 struct dm_stats_aux *stats_aux)
 {
 	struct dm_stat *s;
 	sector_t end_sector;
 	struct dm_stats_last_position *last;
 	bool got_precise_time;
+	unsigned long duration_jiffies = 0;
 
 	if (unlikely(!bi_sectors))
 		return;
@@ -670,7 +671,8 @@ void dm_stats_account_io(struct dm_stats
 				       ));
 		WRITE_ONCE(last->last_sector, end_sector);
 		WRITE_ONCE(last->last_rw, bi_rw);
-	}
+	} else
+		duration_jiffies = jiffies - start_time;
 
 	rcu_read_lock();
 
--- a/drivers/md/dm-stats.h
+++ b/drivers/md/dm-stats.h
@@ -31,7 +31,7 @@ int dm_stats_message(struct mapped_devic
 
 void dm_stats_account_io(struct dm_stats *stats, unsigned long bi_rw,
 			 sector_t bi_sector, unsigned bi_sectors, bool end,
-			 unsigned long duration_jiffies,
+			 unsigned long start_time,
 			 struct dm_stats_aux *aux);
 
 static inline bool dm_stats_used(struct dm_stats *st)
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -484,29 +484,48 @@ u64 dm_start_time_ns_from_clone(struct b
 }
 EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
 
-static void start_io_acct(struct dm_io *io)
+static bool bio_is_flush_with_data(struct bio *bio)
 {
-	struct mapped_device *md = io->md;
-	struct bio *bio = io->orig_bio;
+	return ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size);
+}
+
+static void dm_io_acct(bool end, struct mapped_device *md, struct bio *bio,
+		       unsigned long start_time, struct dm_stats_aux *stats_aux)
+{
+	bool is_flush_with_data;
+	unsigned int bi_size;
+
+	/* If REQ_PREFLUSH set save any payload but do not account it */
+	is_flush_with_data = bio_is_flush_with_data(bio);
+	if (is_flush_with_data) {
+		bi_size = bio->bi_iter.bi_size;
+		bio->bi_iter.bi_size = 0;
+	}
+
+	if (!end)
+		bio_start_io_acct_time(bio, start_time);
+	else
+		bio_end_io_acct(bio, start_time);
 
-	bio_start_io_acct_time(bio, io->start_time);
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
-				    false, 0, &io->stats_aux);
+				    end, start_time, stats_aux);
+
+	/* Restore bio's payload so it does get accounted upon requeue */
+	if (is_flush_with_data)
+		bio->bi_iter.bi_size = bi_size;
+}
+
+static void start_io_acct(struct dm_io *io)
+{
+	dm_io_acct(false, io->md, io->orig_bio, io->start_time, &io->stats_aux);
 }
 
 static void end_io_acct(struct mapped_device *md, struct bio *bio,
 			unsigned long start_time, struct dm_stats_aux *stats_aux)
 {
-	unsigned long duration = jiffies - start_time;
-
-	bio_end_io_acct(bio, start_time);
-
-	if (unlikely(dm_stats_used(&md->stats)))
-		dm_stats_account_io(&md->stats, bio_data_dir(bio),
-				    bio->bi_iter.bi_sector, bio_sectors(bio),
-				    true, duration, stats_aux);
+	dm_io_acct(true, md, bio, start_time, stats_aux);
 }
 
 static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
@@ -835,7 +854,7 @@ void dm_io_dec_pending(struct dm_io *io,
 		if (io_error == BLK_STS_DM_REQUEUE)
 			return;
 
-		if ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size) {
+		if (bio_is_flush_with_data(bio)) {
 			/*
 			 * Preflush done for flush with data, reissue
 			 * without REQ_PREFLUSH.


