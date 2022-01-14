Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7C448E579
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbiANISV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:18:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59010 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239655AbiANISE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:18:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BB53B82439;
        Fri, 14 Jan 2022 08:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9255C36AEA;
        Fri, 14 Jan 2022 08:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148282;
        bh=qEKH8Hv6tCFOyHN7M0/KuxWJ4wmjMiLR2Q83GKs74Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hw8O/nUlLnbLLETkKpLQeao5PK8BFAH9wghbAPzcoefG8Ham2u3tbwAtU0g0dyr5C
         Mm/3XkkmnjAejnO1m2bNwpupR97N2alKzSKfenPAewQJErM2cRFJzxp6awR/mNovTY
         UR2k3w7Vy7xl0MhXyce73aoT1biL/6XvopKHc28U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Song Liu <song@kernel.org>,
        Guillaume Morin <guillaume@morinfr.org>
Subject: [PATCH 5.10 01/25] md: revert io stats accounting
Date:   Fri, 14 Jan 2022 09:16:09 +0100
Message-Id: <20220114081542.746291845@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
References: <20220114081542.698002137@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <jgq516@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |   57 +++++++++++---------------------------------------------
 drivers/md/md.h |    1 
 2 files changed, 12 insertions(+), 46 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -459,34 +459,12 @@ check_suspended:
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
@@ -507,26 +485,21 @@ static blk_qc_t md_submit_bio(struct bio
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
 
@@ -5732,11 +5704,6 @@ static int md_alloc(dev_t dev, char *nam
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
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -487,7 +487,6 @@ struct mddev {
 	struct bio_set			sync_set; /* for sync operations like
 						   * metadata and bitmap writes
 						   */
-	mempool_t			md_io_pool;
 
 	/* Generic flush handling.
 	 * The last to finish preflush schedules a worker to submit


