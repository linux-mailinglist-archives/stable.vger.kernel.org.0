Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93D33C4D39
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245387AbhGLHMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244859AbhGLHLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F37B60FE7;
        Mon, 12 Jul 2021 07:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073703;
        bh=K8kTOfEhkk2gtylmi6uBeVbTzRw5rgMvbI+KuRRCQVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nh7abRvIWVPog5BigtQVhSu3SSVZ2cPSR+e3fgF+CKDXSoY8uhKsB61+IPx+tezEk
         bqiQcjd70fSOrUN+AKFgFVDB/57BZtPryGg/b72YLkGBE6pwFIWFsC65P0l9KeQJXW
         X522giTE1Mp/IF+Ti8k1lxbJ4u1mybVIV1t+jFws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 331/700] md: revert io stats accounting
Date:   Mon, 12 Jul 2021 08:06:54 +0200
Message-Id: <20210712061011.621582967@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <jgq516@gmail.com>

[ Upstream commit ad3fc798800fb7ca04c1dfc439dba946818048d8 ]

The commit 41d2d848e5c0 ("md: improve io stats accounting") could cause
double fault problem per the report [1], and also it is not correct to
change ->bi_end_io if md don't own it, so let's revert it.

And io stats accounting will be replemented in later commits.

[1]. https://lore.kernel.org/linux-raid/3bf04253-3fad-434a-63a7-20214e38cf26@gmail.com/T/#t

Fixes: 41d2d848e5c0 ("md: improve io stats accounting")
Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 45 ---------------------------------------------
 drivers/md/md.h |  1 -
 2 files changed, 46 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2a9553efc2d1..c21ce8070d3c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -441,30 +441,6 @@ check_suspended:
 }
 EXPORT_SYMBOL(md_handle_request);
 
-struct md_io {
-	struct mddev *mddev;
-	bio_end_io_t *orig_bi_end_io;
-	void *orig_bi_private;
-	struct block_device *orig_bi_bdev;
-	unsigned long start_time;
-};
-
-static void md_end_io(struct bio *bio)
-{
-	struct md_io *md_io = bio->bi_private;
-	struct mddev *mddev = md_io->mddev;
-
-	bio_end_io_acct_remapped(bio, md_io->start_time, md_io->orig_bi_bdev);
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
@@ -489,21 +465,6 @@ static blk_qc_t md_submit_bio(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	if (bio->bi_end_io != md_end_io) {
-		struct md_io *md_io;
-
-		md_io = mempool_alloc(&mddev->md_io_pool, GFP_NOIO);
-		md_io->mddev = mddev;
-		md_io->orig_bi_end_io = bio->bi_end_io;
-		md_io->orig_bi_private = bio->bi_private;
-		md_io->orig_bi_bdev = bio->bi_bdev;
-
-		bio->bi_end_io = md_end_io;
-		bio->bi_private = md_io;
-
-		md_io->start_time = bio_start_io_acct(bio);
-	}
-
 	/* bio could be mergeable after passing to underlayer */
 	bio->bi_opf &= ~REQ_NOMERGE;
 
@@ -5614,7 +5575,6 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	mempool_exit(&mddev->md_io_pool);
 	kfree(mddev);
 }
 
@@ -5710,11 +5670,6 @@ static int md_alloc(dev_t dev, char *name)
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
index bcbba1b5ec4a..5b2da02e2e75 100644
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
2.30.2



