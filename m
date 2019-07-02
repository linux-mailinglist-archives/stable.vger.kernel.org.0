Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD715CB80
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfGBIGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfGBIGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:06:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 123752184C;
        Tue,  2 Jul 2019 08:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054800;
        bh=8NSgKZxTWmWUF8pmUzhakLWr3ssJicyhNk8pH+WBQgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMVmfElZNLExR46JgmJ3776wzc1/0k6vp5XLSvSEJXUoZY9RyDuhbMZSYtdf6rNbB
         XYYbE3P5lRW7KHpFZqIpV1Dyl5UeEExmK4Vfs7A1PXVe2zglD2b9Ys6ZB92toBPU+h
         wEEW6lj2gzBFZE5VihGb5Qqq5GWz9rJYJGat9qsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 39/72] dm log writes: make sure super sector log updates are written in order
Date:   Tue,  2 Jul 2019 10:01:40 +0200
Message-Id: <20190702080126.689999193@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

commit 211ad4b733037f66f9be0a79eade3da7ab11cbb8 upstream.

Currently, although we submit super bios in order (and super.nr_entries
is incremented by each logged entry), submit_bio() is async so each
super sector may not be written to log device in order and then the
final nr_entries may be smaller than it should be.

This problem can be reproduced by the xfstests generic/455 with ext4:

  QA output created by 455
 -Silence is golden
 +mark 'end' does not exist

Fix this by serializing submission of super sectors to make sure each
is written to the log disk in order.

Fixes: 0e9cebe724597 ("dm: add log writes target")
Cc: stable@vger.kernel.org
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Suggested-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-log-writes.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -60,6 +60,7 @@
 
 #define WRITE_LOG_VERSION 1ULL
 #define WRITE_LOG_MAGIC 0x6a736677736872ULL
+#define WRITE_LOG_SUPER_SECTOR 0
 
 /*
  * The disk format for this is braindead simple.
@@ -115,6 +116,7 @@ struct log_writes_c {
 	struct list_head logging_blocks;
 	wait_queue_head_t wait;
 	struct task_struct *log_kthread;
+	struct completion super_done;
 };
 
 struct pending_block {
@@ -180,6 +182,14 @@ static void log_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
+static void log_end_super(struct bio *bio)
+{
+	struct log_writes_c *lc = bio->bi_private;
+
+	complete(&lc->super_done);
+	log_end_io(bio);
+}
+
 /*
  * Meant to be called if there is an error, it will free all the pages
  * associated with the block.
@@ -215,7 +225,8 @@ static int write_metadata(struct log_wri
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_sector = sector;
 	bio_set_dev(bio, lc->logdev->bdev);
-	bio->bi_end_io = log_end_io;
+	bio->bi_end_io = (sector == WRITE_LOG_SUPER_SECTOR) ?
+			  log_end_super : log_end_io;
 	bio->bi_private = lc;
 	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
@@ -418,11 +429,18 @@ static int log_super(struct log_writes_c
 	super.nr_entries = cpu_to_le64(lc->logged_entries);
 	super.sectorsize = cpu_to_le32(lc->sectorsize);
 
-	if (write_metadata(lc, &super, sizeof(super), NULL, 0, 0)) {
+	if (write_metadata(lc, &super, sizeof(super), NULL, 0,
+			   WRITE_LOG_SUPER_SECTOR)) {
 		DMERR("Couldn't write super");
 		return -1;
 	}
 
+	/*
+	 * Super sector should be writen in-order, otherwise the
+	 * nr_entries could be rewritten incorrectly by an old bio.
+	 */
+	wait_for_completion_io(&lc->super_done);
+
 	return 0;
 }
 
@@ -531,6 +549,7 @@ static int log_writes_ctr(struct dm_targ
 	INIT_LIST_HEAD(&lc->unflushed_blocks);
 	INIT_LIST_HEAD(&lc->logging_blocks);
 	init_waitqueue_head(&lc->wait);
+	init_completion(&lc->super_done);
 	atomic_set(&lc->io_blocks, 0);
 	atomic_set(&lc->pending_blocks, 0);
 


