Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01111D8749
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgERRi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbgERRi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:38:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02265207C4;
        Mon, 18 May 2020 17:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823538;
        bh=TEoHXFMTbejUrHlaEUHwHNavdgX9+aD2ECPMfE4eKks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDS0WHmuYvQIslNGO/h5SYpH7o7Xg4tkQhA3XnqRTB8CTckZnJEC3kVqDx5oEdpvz
         55AbYmbS0Bilsc1wk22yj2Nljkemvls80tu+zekR7ydMpXdQO/eNVbm2reOiuBZlFN
         cCmJJ04U+eGP3B39O4+fReDSLZ/lHfQc+RbR/4dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Waiman Long <longman@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 23/86] blktrace: Fix potential deadlock between delete & sysfs ops
Date:   Mon, 18 May 2020 19:35:54 +0200
Message-Id: <20200518173455.161566394@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c        |    3 +++
 include/linux/blkdev.h  |    1 +
 kernel/trace/blktrace.c |   18 ++++++++++++------
 3 files changed, 16 insertions(+), 6 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -719,6 +719,9 @@ struct request_queue *blk_alloc_queue_no
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
 
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+	mutex_init(&q->blk_trace_mutex);
+#endif
 	mutex_init(&q->sysfs_lock);
 	spin_lock_init(&q->__queue_lock);
 
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -432,6 +432,7 @@ struct request_queue {
 	int			node;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	struct blk_trace	*blk_trace;
+	struct mutex		blk_trace_mutex;
 #endif
 	/*
 	 * for flush operations
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -644,6 +644,12 @@ int blk_trace_startstop(struct request_q
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
@@ -661,7 +667,7 @@ int blk_trace_ioctl(struct block_device
 	if (!q)
 		return -ENXIO;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&q->blk_trace_mutex);
 
 	switch (cmd) {
 	case BLKTRACESETUP:
@@ -687,7 +693,7 @@ int blk_trace_ioctl(struct block_device
 		break;
 	}
 
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&q->blk_trace_mutex);
 	return ret;
 }
 
@@ -1652,7 +1658,7 @@ static ssize_t sysfs_blk_trace_attr_show
 	if (q == NULL)
 		goto out_bdput;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&q->blk_trace_mutex);
 
 	if (attr == &dev_attr_enable) {
 		ret = sprintf(buf, "%u\n", !!q->blk_trace);
@@ -1671,7 +1677,7 @@ static ssize_t sysfs_blk_trace_attr_show
 		ret = sprintf(buf, "%llu\n", q->blk_trace->end_lba);
 
 out_unlock_bdev:
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&q->blk_trace_mutex);
 out_bdput:
 	bdput(bdev);
 out:
@@ -1713,7 +1719,7 @@ static ssize_t sysfs_blk_trace_attr_stor
 	if (q == NULL)
 		goto out_bdput;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&q->blk_trace_mutex);
 
 	if (attr == &dev_attr_enable) {
 		if (!!value == !!q->blk_trace) {
@@ -1743,7 +1749,7 @@ static ssize_t sysfs_blk_trace_attr_stor
 	}
 
 out_unlock_bdev:
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&q->blk_trace_mutex);
 out_bdput:
 	bdput(bdev);
 out:


