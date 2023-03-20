Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47346C18C7
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjCTP10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjCTP1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:27:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A562C36FF5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04D39615B3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12098C433EF;
        Mon, 20 Mar 2023 15:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325611;
        bh=WmZbr5/l0T2Zsn13zpb+uweuN0MM3d4DK6rEqxFvhQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAvowL6OVzMtJioRaod14f3CgOARhXniqGWhRn/rAY98yPtXp+JA7iQFg76ZIecfe
         qcRfZiH9f2yhVOI1oNniivGT5k7EnvBV6ZhdiSyv0QmH15Ykb2tdnBcmd2ai1NxCIF
         myXBm38k5lKmEnj9FlGMhQ1n7ZCbgqsZhERUTNE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 070/211] block: count ios and sectors when io is done for bio-based device
Date:   Mon, 20 Mar 2023 15:53:25 +0100
Message-Id: <20230320145516.173215346@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 5f27571382ca42daa3e3d40d1b252bf18c2b61d2 ]

While using iostat for raid, I observed very strange 'await'
occasionally, and turns out it's due to that 'ios' and 'sectors' is
counted in bdev_start_io_acct(), while 'nsecs' is counted in
bdev_end_io_acct(). I'm not sure why they are ccounted like that
but I think this behaviour is obviously wrong because user will get
wrong disk stats.

Fix the problem by counting 'ios' and 'sectors' when io is done, like
what rq-based device does.

Fixes: 394ffa503bc4 ("blk: introduce generic io stat accounting help function")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230223091226.1135678-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c              | 16 ++++++----------
 drivers/block/zram/zram_drv.c |  4 ++--
 drivers/md/dm.c               |  6 +++---
 drivers/nvme/host/multipath.c |  8 ++++----
 include/linux/blkdev.h        |  5 ++---
 5 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5a0049215ee72..597293151cd11 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -946,16 +946,11 @@ void update_io_ticks(struct block_device *part, unsigned long now, bool end)
 	}
 }
 
-unsigned long bdev_start_io_acct(struct block_device *bdev,
-				 unsigned int sectors, enum req_op op,
+unsigned long bdev_start_io_acct(struct block_device *bdev, enum req_op op,
 				 unsigned long start_time)
 {
-	const int sgrp = op_stat_group(op);
-
 	part_stat_lock();
 	update_io_ticks(bdev, start_time, false);
-	part_stat_inc(bdev, ios[sgrp]);
-	part_stat_add(bdev, sectors[sgrp], sectors);
 	part_stat_local_inc(bdev, in_flight[op_is_write(op)]);
 	part_stat_unlock();
 
@@ -971,13 +966,12 @@ EXPORT_SYMBOL(bdev_start_io_acct);
  */
 unsigned long bio_start_io_acct(struct bio *bio)
 {
-	return bdev_start_io_acct(bio->bi_bdev, bio_sectors(bio),
-				  bio_op(bio), jiffies);
+	return bdev_start_io_acct(bio->bi_bdev, bio_op(bio), jiffies);
 }
 EXPORT_SYMBOL_GPL(bio_start_io_acct);
 
 void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
-		      unsigned long start_time)
+		      unsigned int sectors, unsigned long start_time)
 {
 	const int sgrp = op_stat_group(op);
 	unsigned long now = READ_ONCE(jiffies);
@@ -985,6 +979,8 @@ void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
 
 	part_stat_lock();
 	update_io_ticks(bdev, now, true);
+	part_stat_inc(bdev, ios[sgrp]);
+	part_stat_add(bdev, sectors[sgrp], sectors);
 	part_stat_add(bdev, nsecs[sgrp], jiffies_to_nsecs(duration));
 	part_stat_local_dec(bdev, in_flight[op_is_write(op)]);
 	part_stat_unlock();
@@ -994,7 +990,7 @@ EXPORT_SYMBOL(bdev_end_io_acct);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
 			      struct block_device *orig_bdev)
 {
-	bdev_end_io_acct(orig_bdev, bio_op(bio), start_time);
+	bdev_end_io_acct(orig_bdev, bio_op(bio), bio_sectors(bio), start_time);
 }
 EXPORT_SYMBOL_GPL(bio_end_io_acct_remapped);
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e290d6d970474..03ef03e10618d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2108,9 +2108,9 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	bv.bv_offset = 0;
 
 	start_time = bdev_start_io_acct(bdev->bd_disk->part0,
-			SECTORS_PER_PAGE, op, jiffies);
+			op, jiffies);
 	ret = zram_bvec_rw(zram, &bv, index, offset, op, NULL);
-	bdev_end_io_acct(bdev->bd_disk->part0, op, start_time);
+	bdev_end_io_acct(bdev->bd_disk->part0, op, SECTORS_PER_PAGE, start_time);
 out:
 	/*
 	 * If I/O fails, just return error(ie, non-zero) without
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 605662935ce91..fdcf42554e2a9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -510,10 +510,10 @@ static void dm_io_acct(struct dm_io *io, bool end)
 		sectors = io->sectors;
 
 	if (!end)
-		bdev_start_io_acct(bio->bi_bdev, sectors, bio_op(bio),
-				   start_time);
+		bdev_start_io_acct(bio->bi_bdev, bio_op(bio), start_time);
 	else
-		bdev_end_io_acct(bio->bi_bdev, bio_op(bio), start_time);
+		bdev_end_io_acct(bio->bi_bdev, bio_op(bio), sectors,
+				 start_time);
 
 	if (static_branch_unlikely(&stats_enabled) &&
 	    unlikely(dm_stats_used(&md->stats))) {
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index fc39d01e7b63b..9171452e2f6d4 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -123,9 +123,8 @@ void nvme_mpath_start_request(struct request *rq)
 		return;
 
 	nvme_req(rq)->flags |= NVME_MPATH_IO_STATS;
-	nvme_req(rq)->start_time = bdev_start_io_acct(disk->part0,
-					blk_rq_bytes(rq) >> SECTOR_SHIFT,
-					req_op(rq), jiffies);
+	nvme_req(rq)->start_time = bdev_start_io_acct(disk->part0, req_op(rq),
+						      jiffies);
 }
 EXPORT_SYMBOL_GPL(nvme_mpath_start_request);
 
@@ -136,7 +135,8 @@ void nvme_mpath_end_request(struct request *rq)
 	if (!(nvme_req(rq)->flags & NVME_MPATH_IO_STATS))
 		return;
 	bdev_end_io_acct(ns->head->disk->part0, req_op(rq),
-		nvme_req(rq)->start_time);
+			 blk_rq_bytes(rq) >> SECTOR_SHIFT,
+			 nvme_req(rq)->start_time);
 }
 
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 43d4e073b1115..c3e066242941d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1434,11 +1434,10 @@ static inline void blk_wake_io_task(struct task_struct *waiter)
 		wake_up_process(waiter);
 }
 
-unsigned long bdev_start_io_acct(struct block_device *bdev,
-				 unsigned int sectors, enum req_op op,
+unsigned long bdev_start_io_acct(struct block_device *bdev, enum req_op op,
 				 unsigned long start_time);
 void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
-		unsigned long start_time);
+		      unsigned int sectors, unsigned long start_time);
 
 unsigned long bio_start_io_acct(struct bio *bio);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
-- 
2.39.2



