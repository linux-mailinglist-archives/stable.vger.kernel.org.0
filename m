Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922E93E2532
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243960AbhHFISJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243899AbhHFIQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:16:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AF606120D;
        Fri,  6 Aug 2021 08:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237794;
        bh=Z96LKcnVNwxnrISAAU9SJIcliho+x7CVWPtTaZgyrzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvFDUx2Z+u/cFwRzlddsR8Mv732lKt0UZlarYjXa1PALZ9XOUMYrAk+QIl67r5jb4
         9VjG5OCPw9ChBqSNtZcyIGv+RixSMfwILyLR20chrGMsUOKAfY50uQjni//yYW1cBt
         j9Eoytur54WSJRUbuZxHBWFOAobEjJVRcYYN+jMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/16] bdi: use bdi_dev_name() to get device name
Date:   Fri,  6 Aug 2021 10:14:59 +0200
Message-Id: <20210806081111.411943916@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
References: <20210806081111.144943357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit d51cfc53ade3189455a1b88ec7a2ff0c24597cf8 ]

Use the common interface bdi_dev_name() to get device name.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Add missing <linux/backing-dev.h> include BFQ

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c        | 6 ++++--
 block/blk-cgroup.c         | 2 +-
 fs/ceph/debugfs.c          | 2 +-
 include/trace/events/wbt.h | 8 ++++----
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index d984592b0995..5b3e5483c657 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -132,6 +132,7 @@
 #include <linux/ioprio.h>
 #include <linux/sbitmap.h>
 #include <linux/delay.h>
+#include <linux/backing-dev.h>
 
 #include "blk.h"
 #include "blk-mq.h"
@@ -4212,8 +4213,9 @@ bfq_set_next_ioprio_data(struct bfq_queue *bfqq, struct bfq_io_cq *bic)
 	ioprio_class = IOPRIO_PRIO_CLASS(bic->ioprio);
 	switch (ioprio_class) {
 	default:
-		dev_err(bfqq->bfqd->queue->backing_dev_info->dev,
-			"bfq: bad prio class %d\n", ioprio_class);
+		pr_err("bdi %s: bfq: bad prio class %d\n",
+				bdi_dev_name(bfqq->bfqd->queue->backing_dev_info),
+				ioprio_class);
 		/* fall through */
 	case IOPRIO_CLASS_NONE:
 		/*
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 85bd46e0a745..ddde117eb2e0 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -474,7 +474,7 @@ const char *blkg_dev_name(struct blkcg_gq *blkg)
 {
 	/* some drivers (floppy) instantiate a queue w/o disk registered */
 	if (blkg->q->backing_dev_info->dev)
-		return dev_name(blkg->q->backing_dev_info->dev);
+		return bdi_dev_name(blkg->q->backing_dev_info);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(blkg_dev_name);
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index abdf98deeec4..e6b7d43b5077 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -251,7 +251,7 @@ int ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 		goto out;
 
 	snprintf(name, sizeof(name), "../../bdi/%s",
-		 dev_name(fsc->sb->s_bdi->dev));
+		 bdi_dev_name(fsc->sb->s_bdi));
 	fsc->debugfs_bdi =
 		debugfs_create_symlink("bdi",
 				       fsc->client->debugfs_dir,
diff --git a/include/trace/events/wbt.h b/include/trace/events/wbt.h
index 37342a13c9cb..9996420d7ec4 100644
--- a/include/trace/events/wbt.h
+++ b/include/trace/events/wbt.h
@@ -33,7 +33,7 @@ TRACE_EVENT(wbt_stat,
 	),
 
 	TP_fast_assign(
-		strlcpy(__entry->name, dev_name(bdi->dev),
+		strlcpy(__entry->name, bdi_dev_name(bdi),
 			ARRAY_SIZE(__entry->name));
 		__entry->rmean		= stat[0].mean;
 		__entry->rmin		= stat[0].min;
@@ -68,7 +68,7 @@ TRACE_EVENT(wbt_lat,
 	),
 
 	TP_fast_assign(
-		strlcpy(__entry->name, dev_name(bdi->dev),
+		strlcpy(__entry->name, bdi_dev_name(bdi),
 			ARRAY_SIZE(__entry->name));
 		__entry->lat = div_u64(lat, 1000);
 	),
@@ -105,7 +105,7 @@ TRACE_EVENT(wbt_step,
 	),
 
 	TP_fast_assign(
-		strlcpy(__entry->name, dev_name(bdi->dev),
+		strlcpy(__entry->name, bdi_dev_name(bdi),
 			ARRAY_SIZE(__entry->name));
 		__entry->msg	= msg;
 		__entry->step	= step;
@@ -141,7 +141,7 @@ TRACE_EVENT(wbt_timer,
 	),
 
 	TP_fast_assign(
-		strlcpy(__entry->name, dev_name(bdi->dev),
+		strlcpy(__entry->name, bdi_dev_name(bdi),
 			ARRAY_SIZE(__entry->name));
 		__entry->status		= status;
 		__entry->step		= step;
-- 
2.30.2



