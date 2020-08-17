Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919632463E6
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgHQKBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:01:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52857 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726366AbgHQKBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597658500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uQGY4azWMVhl1A9JCsigR5rVMe2Y9DMoiPd6OCny0ew=;
        b=a1wWfvwM02MxmlY4NwljynEnJLlaVnk4zuPeIHhWqpRW/ha01amJPbUMCScqBBb1/oEh7M
        JqFOzsqcT+RIF+uMsESesHeWsfozGIyaKp155J8QekJcnR+2WW7jZ1ZFeB+XzHENOzdDnZ
        iB69PNWh/sN9Td2iil/hNMSreciMzZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-k9ljQkJGNZ2ANV9j71SA4w-1; Mon, 17 Aug 2020 06:01:38 -0400
X-MC-Unique: k9ljQkJGNZ2ANV9j71SA4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 480F91019658;
        Mon, 17 Aug 2020 10:01:36 +0000 (UTC)
Received: from localhost (ovpn-13-146.pek2.redhat.com [10.72.13.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81B995D9F3;
        Mon, 17 Aug 2020 10:01:35 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.com>,
        Xiao Ni <xni@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: [PATCH RESEND] block: loop: set discard granularity and alignment for block device backed loop
Date:   Mon, 17 Aug 2020 18:01:30 +0800
Message-Id: <20200817100130.2496059-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case of block device backend, if the backend supports write zeros, the
loop device will set queue flag of QUEUE_FLAG_DISCARD. However,
limits.discard_granularity isn't setup, and this way is wrong,
see the following description in Documentation/ABI/testing/sysfs-block:

	A discard_granularity of 0 means that the device does not support
	discard functionality.

Especially 9b15d109a6b2 ("block: improve discard bio alignment in
__blkdev_issue_discard()") starts to take q->limits.discard_granularity
for computing max discard sectors. And zero discard granularity may cause
kernel oops, or fail discard request even though the loop queue claims
discard support via QUEUE_FLAG_DISCARD.

Fix the issue by setup discard granularity and alignment.

Fixes: c52abf563049 ("loop: Better discard support for block devices")
Acked-by: Coly Li <colyli@suse.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Xiao Ni <xni@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Evan Green <evgreen@chromium.org>
Cc: Gwendal Grignou <gwendal@chromium.org>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/loop.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 2f137d6ce169..3d7a1901bf28 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -878,6 +878,7 @@ static void loop_config_discard(struct loop_device *lo)
 	struct file *file = lo->lo_backing_file;
 	struct inode *inode = file->f_mapping->host;
 	struct request_queue *q = lo->lo_queue;
+	u32 granularity, max_discard_sectors;
 
 	/*
 	 * If the backing device is a block device, mirror its zeroing
@@ -890,11 +891,10 @@ static void loop_config_discard(struct loop_device *lo)
 		struct request_queue *backingq;
 
 		backingq = bdev_get_queue(inode->i_bdev);
-		blk_queue_max_discard_sectors(q,
-			backingq->limits.max_write_zeroes_sectors);
 
-		blk_queue_max_write_zeroes_sectors(q,
-			backingq->limits.max_write_zeroes_sectors);
+		max_discard_sectors = backingq->limits.max_write_zeroes_sectors;
+		granularity = backingq->limits.discard_granularity ?:
+			queue_physical_block_size(backingq);
 
 	/*
 	 * We use punch hole to reclaim the free space used by the
@@ -903,23 +903,26 @@ static void loop_config_discard(struct loop_device *lo)
 	 * useful information.
 	 */
 	} else if (!file->f_op->fallocate || lo->lo_encrypt_key_size) {
-		q->limits.discard_granularity = 0;
-		q->limits.discard_alignment = 0;
-		blk_queue_max_discard_sectors(q, 0);
-		blk_queue_max_write_zeroes_sectors(q, 0);
+		max_discard_sectors = 0;
+		granularity = 0;
 
 	} else {
-		q->limits.discard_granularity = inode->i_sb->s_blocksize;
-		q->limits.discard_alignment = 0;
-
-		blk_queue_max_discard_sectors(q, UINT_MAX >> 9);
-		blk_queue_max_write_zeroes_sectors(q, UINT_MAX >> 9);
+		max_discard_sectors = UINT_MAX >> 9;
+		granularity = inode->i_sb->s_blocksize;
 	}
 
-	if (q->limits.max_write_zeroes_sectors)
+	if (max_discard_sectors) {
+		q->limits.discard_granularity = granularity;
+		blk_queue_max_discard_sectors(q, max_discard_sectors);
+		blk_queue_max_write_zeroes_sectors(q, max_discard_sectors);
 		blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
-	else
+	} else {
+		q->limits.discard_granularity = 0;
+		blk_queue_max_discard_sectors(q, 0);
+		blk_queue_max_write_zeroes_sectors(q, 0);
 		blk_queue_flag_clear(QUEUE_FLAG_DISCARD, q);
+	}
+	q->limits.discard_alignment = 0;
 }
 
 static void loop_unprepare_queue(struct loop_device *lo)
-- 
2.25.2

