Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1114A4391
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350394AbiAaLV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52264 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378455AbiAaLUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E69560B98;
        Mon, 31 Jan 2022 11:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB208C340E8;
        Mon, 31 Jan 2022 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628011;
        bh=kbjFMXoRMtc4U9Oa+ibffCyvoiXCyLaA/lmIK/CuFx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FC9zEGhXUmaHnAFAX6uWFkZobR9OAe23VyB6re/zbCN0FIvaEW0ssgz2sLLffB+b
         297YJT4xsPJ9FkzEf3LckfdXg7KUIDyBBtvHnKyK0AiReD5gYzCX2ojeGTRXhMp9yL
         awA7sm9+aZ1CseC8ok35J30lFqFeT/TN39sQaPI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 063/200] block: add bio_start_io_acct_time() to control start_time
Date:   Mon, 31 Jan 2022 11:55:26 +0100
Message-Id: <20220131105235.695349937@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit e45c47d1f94e0cc7b6b079fdb4bcce2995e2adc4 upstream.

bio_start_io_acct_time() interface is like bio_start_io_acct() that
allows start_time to be passed in. This gives drivers the ability to
defer starting accounting until after IO is issued (but possibily not
entirely due to bio splitting).

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Link: https://lore.kernel.org/r/20220128155841.39644-2-snitzer@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c       |   25 +++++++++++++++++++------
 include/linux/blkdev.h |    1 +
 2 files changed, 20 insertions(+), 6 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1258,22 +1258,34 @@ void __blk_account_io_start(struct reque
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
 }
 
 /**
+ * bio_start_io_acct_time - start I/O accounting for bio based drivers
+ * @bio:	bio to start account for
+ * @start_time:	start time that should be passed back to bio_end_io_acct().
+ */
+void bio_start_io_acct_time(struct bio *bio, unsigned long start_time)
+{
+	__part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
+			     bio_op(bio), start_time);
+}
+EXPORT_SYMBOL_GPL(bio_start_io_acct_time);
+
+/**
  * bio_start_io_acct - start I/O accounting for bio based drivers
  * @bio:	bio to start account for
  *
@@ -1281,14 +1293,15 @@ static unsigned long __part_start_io_acc
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
 
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1254,6 +1254,7 @@ unsigned long disk_start_io_acct(struct
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		unsigned long start_time);
 
+void bio_start_io_acct_time(struct bio *bio, unsigned long start_time);
 unsigned long bio_start_io_acct(struct bio *bio);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
 		struct block_device *orig_bdev);


