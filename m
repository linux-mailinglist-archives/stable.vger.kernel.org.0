Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AE0259671
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgIAQCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731465AbgIAPnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:43:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C67C2078B;
        Tue,  1 Sep 2020 15:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974996;
        bh=QQmK0YgX6jTfA/hhW+0BDjtr3e/de+VhR6umLQnHSfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJXgTS31uEwy+L833uM6hsxxg7+f4xOXWzgjUiIUnkAPeJkdnYs62afpqgi7oeZEY
         fXMvzVFJFArfQJwbVuThCfyUS3J4Oo7G28FdLWA7FoBJedQGfpqkIDcC8dGGO1cKIg
         yvQGmdi01NgwxeAdZwo3oGfSR5DAxNg5FyTDMxv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>,
        Hannes Reinecke <hare@suse.com>, Xiao Ni <xni@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 169/255] block: loop: set discard granularity and alignment for block device backed loop
Date:   Tue,  1 Sep 2020 17:10:25 +0200
Message-Id: <20200901151008.792032374@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit bcb21c8cc9947286211327d663ace69f07d37a76 upstream.

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
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/loop.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -877,6 +877,7 @@ static void loop_config_discard(struct l
 	struct file *file = lo->lo_backing_file;
 	struct inode *inode = file->f_mapping->host;
 	struct request_queue *q = lo->lo_queue;
+	u32 granularity, max_discard_sectors;
 
 	/*
 	 * If the backing device is a block device, mirror its zeroing
@@ -889,11 +890,10 @@ static void loop_config_discard(struct l
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
@@ -902,23 +902,26 @@ static void loop_config_discard(struct l
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


