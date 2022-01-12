Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A89848C94E
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 18:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355582AbiALR0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 12:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355578AbiALR0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 12:26:47 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [IPv6:2a01:e0c:1:1599::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4040AC06173F;
        Wed, 12 Jan 2022 09:26:47 -0800 (PST)
Received: from bender.morinfr.org (unknown [82.65.130.196])
        by smtp1-g21.free.fr (Postfix) with ESMTPS id 97F4FB005A3;
        Wed, 12 Jan 2022 18:26:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
        ; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bCR9f3y6Na/zZgiB1xxZdUKB4diqze6Tu0VOEOuV+5g=; b=nGK1e2QTco3m3U5FVoKFNrF1rU
        1vWsd6WEMwY4Nv35jlZ8ytxXNbQ6n1R4/33uzmDpdHIvLKcdcDT+8vIMVdKiX/laX/bQWuFJb25zj
        6yONC84KX3Gw9/Pu8qkO9eOxDewlS4OSYQxUeWBNS3feTrhSOGy5Qei5iVnS15ELf7V4=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.94.2)
        (envelope-from <guillaume@morinfr.org>)
        id 1n7hOW-00AvgO-Tv; Wed, 12 Jan 2022 18:26:44 +0100
Date:   Wed, 12 Jan 2022 18:26:44 +0100
From:   Guillaume Morin <guillaume@morinfr.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-raid@vger.kernel.org, stable@vger.kernel.org,
        guoqing.jiang@linux.dev, artur.paszkiewicz@intel.com,
        song@kernel.org
Subject: [PATCH backport for 5.10]: md: revert io stats accounting
Message-ID: <Yd8PVH8rBepVYXwg@bender.morinfr.org>
References: <Yd3PDbLH4v5Ea682@bender.morinfr.org>
 <Yd3STJyOHVBz8zUo@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd3STJyOHVBz8zUo@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ad3fc798800fb7ca04c1dfc439dba946818048d8 upstream.

The commit 41d2d848e5c0 ("md: improve io stats accounting") could cause
double fault problem per the report [1], and also it is not correct to
change ->bi_end_io if md don't own it, so let's revert it.

And io stats accounting will be replemented in later commits.

[1]. https://lore.kernel.org/linux-raid/3bf04253-3fad-434a-63a7-20214e38cf26@gmail.com/T/#t

Fixes: 41d2d848e5c0 ("md: improve io stats accounting")
Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
Signed-off-by: Song Liu <song@kernel.org>
[GM: backport to 5.10-stable]
Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
---
 drivers/md/md.c | 57 +++++++++++--------------------------------------
 drivers/md/md.h |  1 -
 2 files changed, 12 insertions(+), 46 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2069b16b50ec..cc3876500c4b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -459,34 +459,12 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_handle_request);
 
-struct md_io {
-	struct mddev *mddev;
-	bio_end_io_t *orig_bi_end_io;
-	void *orig_bi_private;
-	unsigned long start_time;
-	struct hd_struct *part;
-};
-
-static void md_end_io(struct bio *bio)
-{
-	struct md_io *md_io = bio->bi_private;
-	struct mddev *mddev = md_io->mddev;
-
-	part_end_io_acct(md_io->part, bio, md_io->start_time);
-
-	bio->bi_end_io = md_io->orig_bi_end_io;
-	bio->bi_private = md_io->orig_bi_private;
-
-	mempool_free(md_io, &mddev->md_io_pool);
-
-	if (bio->bi_end_io)
-		bio->bi_end_io(bio);
-}
-
 static blk_qc_t md_submit_bio(struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
+	const int sgrp = op_stat_group(bio_op(bio));
 	struct mddev *mddev = bio->bi_disk->private_data;
+	unsigned int sectors;
 
 	if (mddev == NULL || mddev->pers == NULL) {
 		bio_io_error(bio);
@@ -507,26 +485,21 @@ static blk_qc_t md_submit_bio(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	if (bio->bi_end_io != md_end_io) {
-		struct md_io *md_io;
-
-		md_io = mempool_alloc(&mddev->md_io_pool, GFP_NOIO);
-		md_io->mddev = mddev;
-		md_io->orig_bi_end_io = bio->bi_end_io;
-		md_io->orig_bi_private = bio->bi_private;
-
-		bio->bi_end_io = md_end_io;
-		bio->bi_private = md_io;
-
-		md_io->start_time = part_start_io_acct(mddev->gendisk,
-						       &md_io->part, bio);
-	}
-
+	/*
+	 * save the sectors now since our bio can
+	 * go away inside make_request
+	 */
+	sectors = bio_sectors(bio);
 	/* bio could be mergeable after passing to underlayer */
 	bio->bi_opf &= ~REQ_NOMERGE;
 
 	md_handle_request(mddev, bio);
 
+	part_stat_lock();
+	part_stat_inc(&mddev->gendisk->part0, ios[sgrp]);
+	part_stat_add(&mddev->gendisk->part0, sectors[sgrp], sectors);
+	part_stat_unlock();
+
 	return BLK_QC_T_NONE;
 }
 
@@ -5636,7 +5609,6 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	mempool_exit(&mddev->md_io_pool);
 	kfree(mddev);
 }
 
@@ -5732,11 +5704,6 @@ static int md_alloc(dev_t dev, char *name)
 		 */
 		mddev->hold_active = UNTIL_STOP;
 
-	error = mempool_init_kmalloc_pool(&mddev->md_io_pool, BIO_POOL_SIZE,
-					  sizeof(struct md_io));
-	if (error)
-		goto abort;
-
 	error = -ENOMEM;
 	mddev->queue = blk_alloc_queue(NUMA_NO_NODE);
 	if (!mddev->queue)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2175a5ac4f7c..c94811cf2600 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -487,7 +487,6 @@ struct mddev {
 	struct bio_set			sync_set; /* for sync operations like
 						   * metadata and bitmap writes
 						   */
-	mempool_t			md_io_pool;
 
 	/* Generic flush handling.
 	 * The last to finish preflush schedules a worker to submit
-- 
2.23.0

-- 
Guillaume Morin <guillaume@morinfr.org>
