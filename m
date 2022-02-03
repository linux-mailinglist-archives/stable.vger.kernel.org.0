Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4244A8EB2
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354900AbiBCUig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355442AbiBCUfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:35:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE939C0613BB;
        Thu,  3 Feb 2022 12:34:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABFD561A73;
        Thu,  3 Feb 2022 20:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8A3C36AE7;
        Thu,  3 Feb 2022 20:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920485;
        bh=VxEQX6Dno7ifn5D1jOKQHelxxxyFWN1e7zDI/DHZSJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jos3s3uLYW3xdlYmDAhx36DlnRU2ogmYBvIr61sJjMzxMMTR7eYOmTNkfigZZ/bdm
         6Y5nNjFt/pIY9UULMajsVhV50dEIMilNI5TzK7cZn+Ha9YCr2wZdQTpK9X9QnhaX8s
         WKbuNJ9GKMYa2aKfoXvhF/p+ylnXYF9tjbxA7IIpgWvi3VuBvnwSXkQZnzNC789mf9
         npYiIwarU5q6WhM7JQazrcAYYaN3Y5Glh498Ns4ZVDP4ghxl8f4GgcrB0jWFGLOpCl
         Fu24iuhDr3UTp9vezfTLsAz7JvyLZEUEa4lCMTG06MmAER0J/monuq64ARalRbmZfl
         ha58cfGXe9J+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 41/41] block: add bio_start_io_acct_time() to control start_time
Date:   Thu,  3 Feb 2022 15:32:45 -0500
Message-Id: <20220203203245.3007-41-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit e45c47d1f94e0cc7b6b079fdb4bcce2995e2adc4 ]

bio_start_io_acct_time() interface is like bio_start_io_acct() that
allows start_time to be passed in. This gives drivers the ability to
defer starting accounting until after IO is issued (but possibily not
entirely due to bio splitting).

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Link: https://lore.kernel.org/r/20220128155841.39644-2-snitzer@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c       | 25 +++++++++++++++++++------
 include/linux/blkdev.h |  1 +
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c2d912d0c976c..d42a0f3ff7361 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1293,20 +1293,32 @@ void blk_account_io_start(struct request *rq)
 }
 
 static unsigned long __part_start_io_acct(struct block_device *part,
-					  unsigned int sectors, unsigned int op)
+					  unsigned int sectors, unsigned int op,
+					  unsigned long start_time)
 {
 	const int sgrp = op_stat_group(op);
-	unsigned long now = READ_ONCE(jiffies);
 
 	part_stat_lock();
-	update_io_ticks(part, now, false);
+	update_io_ticks(part, start_time, false);
 	part_stat_inc(part, ios[sgrp]);
 	part_stat_add(part, sectors[sgrp], sectors);
 	part_stat_local_inc(part, in_flight[op_is_write(op)]);
 	part_stat_unlock();
 
-	return now;
+	return start_time;
+}
+
+/**
+ * bio_start_io_acct_time - start I/O accounting for bio based drivers
+ * @bio:	bio to start account for
+ * @start_time:	start time that should be passed back to bio_end_io_acct().
+ */
+void bio_start_io_acct_time(struct bio *bio, unsigned long start_time)
+{
+	__part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
+			     bio_op(bio), start_time);
 }
+EXPORT_SYMBOL_GPL(bio_start_io_acct_time);
 
 /**
  * bio_start_io_acct - start I/O accounting for bio based drivers
@@ -1316,14 +1328,15 @@ static unsigned long __part_start_io_acct(struct block_device *part,
  */
 unsigned long bio_start_io_acct(struct bio *bio)
 {
-	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio), bio_op(bio));
+	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
+				    bio_op(bio), jiffies);
 }
 EXPORT_SYMBOL_GPL(bio_start_io_acct);
 
 unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 				 unsigned int op)
 {
-	return __part_start_io_acct(disk->part0, sectors, op);
+	return __part_start_io_acct(disk->part0, sectors, op, jiffies);
 }
 EXPORT_SYMBOL(disk_start_io_acct);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0a9fdcbbab83d..be8e7a55d803c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1947,6 +1947,7 @@ unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		unsigned long start_time);
 
+void bio_start_io_acct_time(struct bio *bio, unsigned long start_time);
 unsigned long bio_start_io_acct(struct bio *bio);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
 		struct block_device *orig_bdev);
-- 
2.34.1

