Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71D05BF8D
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 17:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfGAPRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 11:17:08 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52183 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbfGAPRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 11:17:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2F6A520E94;
        Mon,  1 Jul 2019 11:17:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 01 Jul 2019 11:17:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tnpjQU
        vNmPUXWZWGuxygtyEJWky5sxZrpalZEh5Zv0s=; b=xxv7IL5TQPMTSzAelUCVkb
        0oaYWkHlXWogUUcn2bBrjZBerN0SzXiYB1UtzAOuO/pu07iYGN8uRB4hZ2XWX6gl
        2VdPTZUo2rgytIJ946UtsNnr+SC0+I+PxW6EJAMHti9oPz8MFlCTGwaEVtdO2K1F
        iUdiUTcKdiDPsx+OXVqEefFW8m+mSlM+cQde/tVsA5j771KJpQeXhmeLxpB4KIKN
        QQv17pDYSwbl7AKUmswgmUJ6G8KY+WaCaGdAOF6OP0DazqwfbMOU71Sw+pa665SH
        cDy6IProueSGSj7G3dQB5+0MUr52yfxg7BEkRK6HmbPt4BnjAHOETv8YqqT3/RuQ
        ==
X-ME-Sender: <xms:8iMaXVZ7XV0NComTD8R3mQs1sXEOT4fv54vJf5nec5PrgoeHfiFzsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdeigdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:8iMaXaGu-A3v7Ox0u4EDr8Gn0nX5S1nF_7XV0I3BGqwha8rMHRTMmg>
    <xmx:8iMaXZvqpU2J8HcF9CrK0sE9elP32Df2hsQ_NOEtvpRRzG8r5y97VQ>
    <xmx:8iMaXQLfu0wg0jeq0X0ayMgh6XmqDij112iGkvtsQunwpDw3K3bGpw>
    <xmx:8yMaXYxOy0RCGnjsxTkfjdBEfuvUPTp4hUcjyDuhq06TUbBqhj941g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4B599380087;
        Mon,  1 Jul 2019 11:17:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm log writes: make sure super sector log updates are written" failed to apply to 4.9-stable tree
To:     yi.zhang@huawei.com, josef@toxicpanda.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jul 2019 17:16:56 +0200
Message-ID: <156199421622318@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 211ad4b733037f66f9be0a79eade3da7ab11cbb8 Mon Sep 17 00:00:00 2001
From: "zhangyi (F)" <yi.zhang@huawei.com>
Date: Wed, 5 Jun 2019 21:27:08 +0800
Subject: [PATCH] dm log writes: make sure super sector log updates are written
 in order

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

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 9ea2b0291f20..e549392e0ea5 100644
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
@@ -215,7 +225,8 @@ static int write_metadata(struct log_writes_c *lc, void *entry,
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_sector = sector;
 	bio_set_dev(bio, lc->logdev->bdev);
-	bio->bi_end_io = log_end_io;
+	bio->bi_end_io = (sector == WRITE_LOG_SUPER_SECTOR) ?
+			  log_end_super : log_end_io;
 	bio->bi_private = lc;
 	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
@@ -418,11 +429,18 @@ static int log_super(struct log_writes_c *lc)
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
 
@@ -531,6 +549,7 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	INIT_LIST_HEAD(&lc->unflushed_blocks);
 	INIT_LIST_HEAD(&lc->logging_blocks);
 	init_waitqueue_head(&lc->wait);
+	init_completion(&lc->super_done);
 	atomic_set(&lc->io_blocks, 0);
 	atomic_set(&lc->pending_blocks, 0);
 

