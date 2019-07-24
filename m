Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC9572524
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 05:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbfGXDN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 23:13:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbfGXDN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 23:13:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4BAFD30C26A8;
        Wed, 24 Jul 2019 03:13:28 +0000 (UTC)
Received: from localhost (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97F785D9C5;
        Wed, 24 Jul 2019 03:13:17 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH V3 1/2] blk-mq: add callback of .cleanup_rq
Date:   Wed, 24 Jul 2019 11:12:57 +0800
Message-Id: <20190724031258.31688-2-ming.lei@redhat.com>
In-Reply-To: <20190724031258.31688-1-ming.lei@redhat.com>
References: <20190724031258.31688-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 24 Jul 2019 03:13:28 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

dm-rq needs to free request which has been dispatched and not completed
by underlying queue. However, the underlying queue may have allocated
private data for this request in .queue_rq(), so the request private data
will be leaked in dm multipath IO code path.

Add one new callback of .cleanup_rq() to fix the memory leak.

Another use case is to free request when the hctx is dead during
cpu hotplug context.

Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: <stable@vger.kernel.org>
Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-rq.c     |  1 +
 include/linux/blk-mq.h | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index c9e44ac1f9a6..21d5c1784d0c 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -408,6 +408,7 @@ static int map_request(struct dm_rq_target_io *tio)
 		ret = dm_dispatch_clone_request(clone, rq);
 		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
 			blk_rq_unprep_clone(clone);
+			blk_mq_cleanup_rq(clone);
 			tio->ti->type->release_clone_rq(clone, &tio->info);
 			tio->clone = NULL;
 			return DM_MAPIO_REQUEUE;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 3fa1fa59f9b2..ab25e69a15d1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -140,6 +140,7 @@ typedef int (poll_fn)(struct blk_mq_hw_ctx *);
 typedef int (map_queues_fn)(struct blk_mq_tag_set *set);
 typedef bool (busy_fn)(struct request_queue *);
 typedef void (complete_fn)(struct request *);
+typedef void (cleanup_rq_fn)(struct request *);
 
 
 struct blk_mq_ops {
@@ -200,6 +201,12 @@ struct blk_mq_ops {
 	/* Called from inside blk_get_request() */
 	void (*initialize_rq_fn)(struct request *rq);
 
+	/*
+	 * Called before freeing one request which isn't completed yet,
+	 * and usually for freeing the driver private data
+	 */
+	cleanup_rq_fn		*cleanup_rq;
+
 	/*
 	 * If set, returns whether or not this queue currently is busy
 	 */
@@ -366,4 +373,10 @@ static inline blk_qc_t request_to_qc_t(struct blk_mq_hw_ctx *hctx,
 			BLK_QC_T_INTERNAL;
 }
 
+static inline void blk_mq_cleanup_rq(struct request *rq)
+{
+	if (rq->q->mq_ops->cleanup_rq)
+		rq->q->mq_ops->cleanup_rq(rq);
+}
+
 #endif
-- 
2.20.1

