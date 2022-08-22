Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E363A59B8FD
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 08:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiHVGHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 02:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiHVGHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 02:07:31 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289772654F;
        Sun, 21 Aug 2022 23:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661148450; x=1692684450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uTzjeHMuaQ3rAxd1ZRogFQwnAI4EP4Y4qOJvuxXEpKs=;
  b=LrDuo7UKi6G9hCzVqd4nhJEu3hiV/J50GWAQRXoJqAgpOLot3z9OEy4u
   +WIr0kLAvzYntYHZObMaGxFbwf254d29sCAcjWfPUHABKI9yVnNELEG+V
   N/oYNMj13twALs6ZNLQ3YjmVBdXAKjk+efEA4m2i/k5U4jIrKkoBjRlhn
   RRt7NlLHtULkGWJLI6UE/DSqM/obRjl0RmuSz2YEegWE1DKYw198eZgbv
   uufMEs0SZkg3/5tfd+CThRrx9Z6C3C1xwkzjlbavH7j5hDgj95skKZvVj
   rSFQ9wXVr+FImRfbLU3C9c0+cI+WMUmM2JbiY6z9YeRntVBh18y/mbetH
   w==;
X-IronPort-AV: E=Sophos;i="5.93,254,1654531200"; 
   d="scan'208";a="321397068"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2022 14:07:28 +0800
IronPort-SDR: ZHaq/NIRYFcSQYlsZnXVDoSlpmKygiQY1sg4LXRmi7Nw9t4msyLrWCSI9m67pQJ+8T8BuDuGVS
 WaBQ3+EyLkQxj0I3ENIUYOqeplswR7P6Z7MgnDALCriZtYyX0PuNdslJfRjsGGTrzDLkIja+LA
 sRS/vkz7OObJiDzrDKM+1BP82bbWo7i9L0Rf3MnmPuvQVVjFbY9f9DfWiXeOET8lZRsWkK9QlD
 y6BbykfODJfZQqnW4YG3dn/1enpZTNnRycBraOFKTmjkeQ5vNNBUJLuiGNQZGiEdS+rr4ToP1U
 e7VmO2IYwW1lV9B3XYHKjk6I
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Aug 2022 22:28:10 -0700
IronPort-SDR: eqGWKlkldmlQ0+qt+8I1np5XfedE7evW+cUHvysNqmwC/qsGs5vupOJR7IFQoYDBI1mzoDSSJv
 fbwJLFXoFDwEXj/BTt0I099nNe1fR7Uil1nRjyYZng0ppsE9BBiHmfMPnzkkY/yhSKyHIFsagH
 /GpvrIFZOrocyl3aC+Jvii67XPgoOIufXSIPMXq6kbcX4JAzViBYc4G57So4ydoRrxP9fSabt/
 DB0j3+0ji2wDvrhGq3fuWNpDyUnrmGuh3sX5zTp5ic11+UaLdfCgdkePUViqYSn32BkZWHrpit
 aGY=
WDCIronportException: Internal
Received: from unknown (HELO naota-xeon.wdc.com) ([10.225.50.191])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Aug 2022 23:07:27 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH STABLE 5.15 1/5] block: add a bdev_max_zone_append_sectors helper
Date:   Mon, 22 Aug 2022 15:07:00 +0900
Message-Id: <20220822060704.1278361-2-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220822060704.1278361-1-naohiro.aota@wdc.com>
References: <20220822060704.1278361-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 2aba0d19f4d8c8929b4b3b94a9cfde2aa20e6ee2 upstream

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
---
 drivers/nvme/target/zns.c | 3 +--
 fs/zonefs/super.c         | 3 +--
 include/linux/blkdev.h    | 6 ++++++
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 46bc30fe85d2..235553337fb2 100644
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
index ecf564d150b3..f8feaed0b54d 100644
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
index 8863b4a378af..2f4ba6e345d5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1387,6 +1387,12 @@ static inline unsigned int queue_max_zone_append_sectors(const struct request_qu
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
2.37.2

