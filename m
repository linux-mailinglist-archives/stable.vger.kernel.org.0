Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9495948B7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbiHOXWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345022AbiHOXU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:20:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F562B4EAC;
        Mon, 15 Aug 2022 13:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF1A460693;
        Mon, 15 Aug 2022 20:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01D4C433C1;
        Mon, 15 Aug 2022 20:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593859;
        bh=NGilHNjrd5uqftgXcB6CgRGd4vGCjA/xtz5PynTnumU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBF663ivHNTIZh49MIWyHHjyTHdT+tTEiUnJdnLx8TMWVOvPu3Qe1MK+RFcx+rnkx
         Ed1/4KnwBqr4/tCqQMzo9Dr0S9Tys4y2kowmHsc1dG6K2tdATFWVuzoNKm4+M9MDSz
         4/77LrC8vsN1HIDPa1H4P4HaB3ytIxc0JqX26LmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1017/1095] block: add a bdev_max_zone_append_sectors helper
Date:   Mon, 15 Aug 2022 20:06:56 +0200
Message-Id: <20220815180511.162001359@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2aba0d19f4d8c8929b4b3b94a9cfde2aa20e6ee2 ]

Add a helper to check the max supported sectors for zone append based on
the block_device instead of having to poke into the block layer internal
request_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20220415045258.199825-16-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/zns.c | 3 +--
 fs/zonefs/super.c         | 3 +--
 include/linux/blkdev.h    | 6 ++++++
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index e34718b09550..82b61acf7a72 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -34,8 +34,7 @@ static int validate_conv_zones_cb(struct blk_zone *z,
 
 bool nvmet_bdev_zns_enable(struct nvmet_ns *ns)
 {
-	struct request_queue *q = ns->bdev->bd_disk->queue;
-	u8 zasl = nvmet_zasl(queue_max_zone_append_sectors(q));
+	u8 zasl = nvmet_zasl(bdev_max_zone_append_sectors(ns->bdev));
 	struct gendisk *bd_disk = ns->bdev->bd_disk;
 	int ret;
 
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 15a4c7c07a3b..b68798a572fc 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -723,13 +723,12 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	struct block_device *bdev = inode->i_sb->s_bdev;
-	unsigned int max;
+	unsigned int max = bdev_max_zone_append_sectors(bdev);
 	struct bio *bio;
 	ssize_t size;
 	int nr_pages;
 	ssize_t ret;
 
-	max = queue_max_zone_append_sectors(bdev_get_queue(bdev));
 	max = ALIGN_DOWN(max << SECTOR_SHIFT, inode->i_sb->s_blocksize);
 	iov_iter_truncate(from, max);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cc6b24a5098f..34f2b88dfd6e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1190,6 +1190,12 @@ static inline unsigned int queue_max_zone_append_sectors(const struct request_qu
 	return min(l->max_zone_append_sectors, l->max_sectors);
 }
 
+static inline unsigned int
+bdev_max_zone_append_sectors(struct block_device *bdev)
+{
+	return queue_max_zone_append_sectors(bdev_get_queue(bdev));
+}
+
 static inline unsigned queue_logical_block_size(const struct request_queue *q)
 {
 	int retval = 512;
-- 
2.35.1



