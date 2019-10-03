Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFA5CA44A
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390532AbfJCQXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390504AbfJCQXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:23:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AABDC215EA;
        Thu,  3 Oct 2019 16:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119799;
        bh=uYQAJ5LDyh3Z5MJz34Hk8yYd1V2313HOuUXPRmrI03c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pl+4/BxMs/o0Y11o/KQzGZ5zQXwHh+GzY255oFAuL2zbihDUFadD4W1Mtjl947ys0
         rAVfusPqKf1k+J4k5bifCpJyG/YK25JCDGiWuHSUpE009QikYxJcnGk9OWE6Mnh1sc
         zbFIX+Nom7hFlxKAZEW1y3MmxkcGasJ6qlsrIfLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/211] blk-mq: add callback of .cleanup_rq
Date:   Thu,  3 Oct 2019 17:53:46 +0200
Message-Id: <20191003154524.508873544@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 226b4fc75c78f9c497c5182d939101b260cfb9f3 ]

SCSI maintains its own driver private data hooked off of each SCSI
request, and the pridate data won't be freed after scsi_queue_rq()
returns BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE. An upper layer driver
(e.g. dm-rq) may need to retry these SCSI requests, before SCSI has
fully dispatched them, due to a lower level SCSI driver's resource
limitation identified in scsi_queue_rq(). Currently SCSI's per-request
private data is leaked when the upper layer driver (dm-rq) frees and
then retries these requests in response to BLK_STS_RESOURCE or
BLK_STS_DEV_RESOURCE returns from scsi_queue_rq().

This usecase is so specialized that it doesn't warrant training an
existing blk-mq interface (e.g. blk_mq_free_request) to allow SCSI to
account for freeing its driver private data -- doing so would add an
extra branch for handling a special case that all other consumers of
SCSI (and blk-mq) won't ever need to worry about.

So the most pragmatic way forward is to delegate freeing SCSI driver
private data to the upper layer driver (dm-rq).  Do so by adding
new .cleanup_rq callback and calling a new blk_mq_cleanup_rq() method
from dm-rq.  A following commit will implement the .cleanup_rq() hook
in scsi_mq_ops.

Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: <stable@vger.kernel.org>
Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-rq.c     |  1 +
 include/linux/blk-mq.h | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 17c6a73c536c6..4d36373e1c0f0 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -505,6 +505,7 @@ static int map_request(struct dm_rq_target_io *tio)
 		ret = dm_dispatch_clone_request(clone, rq);
 		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
 			blk_rq_unprep_clone(clone);
+			blk_mq_cleanup_rq(clone);
 			tio->ti->type->release_clone_rq(clone, &tio->info);
 			tio->clone = NULL;
 			if (!rq->q->mq_ops)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 1da59c16f6377..2885dce1ad496 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -114,6 +114,7 @@ typedef void (busy_iter_fn)(struct blk_mq_hw_ctx *, struct request *, void *,
 typedef void (busy_tag_iter_fn)(struct request *, void *, bool);
 typedef int (poll_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (map_queues_fn)(struct blk_mq_tag_set *set);
+typedef void (cleanup_rq_fn)(struct request *);
 
 
 struct blk_mq_ops {
@@ -165,6 +166,12 @@ struct blk_mq_ops {
 	/* Called from inside blk_get_request() */
 	void (*initialize_rq_fn)(struct request *rq);
 
+	/*
+	 * Called before freeing one request which isn't completed yet,
+	 * and usually for freeing the driver private data
+	 */
+	cleanup_rq_fn		*cleanup_rq;
+
 	map_queues_fn		*map_queues;
 
 #ifdef CONFIG_BLK_DEBUG_FS
@@ -324,4 +331,10 @@ static inline void *blk_mq_rq_to_pdu(struct request *rq)
 	for ((i) = 0; (i) < (hctx)->nr_ctx &&				\
 	     ({ ctx = (hctx)->ctxs[(i)]; 1; }); (i)++)
 
+static inline void blk_mq_cleanup_rq(struct request *rq)
+{
+	if (rq->q->mq_ops->cleanup_rq)
+		rq->q->mq_ops->cleanup_rq(rq);
+}
+
 #endif
-- 
2.20.1



