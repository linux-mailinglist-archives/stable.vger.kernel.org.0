Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333C01D810E
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgERRoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729736AbgERRoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:44:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BB2C2083E;
        Mon, 18 May 2020 17:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823863;
        bh=jXxum+FmUUGILJRGxLjczPGmCfLYinVX7ZXMCgYkQ8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vx/4++j7WLlaUdcje1pj7u1cdt+tGDTSQLJgrOrb0dq42WEvj5yKhXwA2l4cdj0e3
         GOsxFeMk17oaVcQ+pwmAQ97114sf4bpnPLObDsQcBRzw10yljQLitn4vX03tXslPC0
         4kJeNWJVciq+eN8L+Xmqt9C80dqrtoBJoOilltZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Waiman Long <longman@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 29/90] blktrace: Fix potential deadlock between delete & sysfs ops
Date:   Mon, 18 May 2020 19:36:07 +0200
Message-Id: <20200518173457.150429785@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit 5acb3cc2c2e9d3020a4fee43763c6463767f1572 upstream.

The lockdep code had reported the following unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(s_active#228);
                               lock(&bdev->bd_mutex/1);
                               lock(s_active#228);
  lock(&bdev->bd_mutex);

 *** DEADLOCK ***

The deadlock may happen when one task (CPU1) is trying to delete a
partition in a block device and another task (CPU0) is accessing
tracing sysfs file (e.g. /sys/block/dm-1/trace/act_mask) in that
partition.

The s_active isn't an actual lock. It is a reference count (kn->count)
on the sysfs (kernfs) file. Removal of a sysfs file, however, require
a wait until all the references are gone. The reference count is
treated like a rwsem using lockdep instrumentation code.

The fact that a thread is in the sysfs callback method or in the
ioctl call means there is a reference to the opended sysfs or device
file. That should prevent the underlying block structure from being
removed.

Instead of using bd_mutex in the block_device structure, a new
blk_trace_mutex is now added to the request_queue structure to protect
access to the blk_trace structure.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Fix typo in patch subject line, and prune a comment detailing how
the code used to work.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c        |  3 +++
 include/linux/blkdev.h  |  1 +
 kernel/trace/blktrace.c | 18 ++++++++++++------
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bdb906bbfe198..4987f312a95f4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -729,6 +729,9 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
 
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+	mutex_init(&q->blk_trace_mutex);
+#endif
 	mutex_init(&q->sysfs_lock);
 	spin_lock_init(&q->__queue_lock);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2fc4ba6fa07f9..a8dfbad42d1b0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -446,6 +446,7 @@ struct request_queue {
 	int			node;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	struct blk_trace	*blk_trace;
+	struct mutex		blk_trace_mutex;
 #endif
 	/*
 	 * for flush operations
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index bfa8bb3a6e196..ff1384c5884c5 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -644,6 +644,12 @@ int blk_trace_startstop(struct request_queue *q, int start)
 }
 EXPORT_SYMBOL_GPL(blk_trace_startstop);
 
+/*
+ * When reading or writing the blktrace sysfs files, the references to the
+ * opened sysfs or device files should prevent the underlying block device
+ * from being removed. So no further delete protection is really needed.
+ */
+
 /**
  * blk_trace_ioctl: - handle the ioctls associated with tracing
  * @bdev:	the block device
@@ -661,7 +667,7 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 	if (!q)
 		return -ENXIO;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&q->blk_trace_mutex);
 
 	switch (cmd) {
 	case BLKTRACESETUP:
@@ -687,7 +693,7 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 		break;
 	}
 
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&q->blk_trace_mutex);
 	return ret;
 }
 
@@ -1656,7 +1662,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 	if (q == NULL)
 		goto out_bdput;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&q->blk_trace_mutex);
 
 	if (attr == &dev_attr_enable) {
 		ret = sprintf(buf, "%u\n", !!q->blk_trace);
@@ -1675,7 +1681,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 		ret = sprintf(buf, "%llu\n", q->blk_trace->end_lba);
 
 out_unlock_bdev:
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&q->blk_trace_mutex);
 out_bdput:
 	bdput(bdev);
 out:
@@ -1717,7 +1723,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 	if (q == NULL)
 		goto out_bdput;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&q->blk_trace_mutex);
 
 	if (attr == &dev_attr_enable) {
 		if (!!value == !!q->blk_trace) {
@@ -1747,7 +1753,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 	}
 
 out_unlock_bdev:
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&q->blk_trace_mutex);
 out_bdput:
 	bdput(bdev);
 out:
-- 
2.20.1



