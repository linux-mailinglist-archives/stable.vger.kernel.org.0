Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FA7291F80
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 22:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgJRTSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbgJRTSf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51F68222C3;
        Sun, 18 Oct 2020 19:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048715;
        bh=AFKSqP4Sk2XqD1p6XQv5tDp/EspU/W0wAQxsWRRx6is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/OCeEvLb8KiAJNBuuMw01NrgoG3dor7BeNJsrYY+DZmjGoLf0NQ+IGQ42xnpk20J
         LayffzL5g+wTI+Wx6x+jPEB4ORLfkmbUCT6mjatnQjHAwGNX91Zxok4Q1B4uPE22dJ
         +rMslXJitOJyGvb6iQd7bdWhGPBWNXxD5bz563ss=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        David Milburn <dmilburn@redhat.com>,
        "Ewan D . Milne" <emilne@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 022/111] blk-mq: always allow reserved allocation in hctx_may_queue
Date:   Sun, 18 Oct 2020 15:16:38 -0400
Message-Id: <20201018191807.4052726-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 285008501c65a3fcee05d2c2c26cbf629ceff2f0 ]

NVMe shares tagset between fabric queue and admin queue or between
connect_q and NS queue, so hctx_may_queue() can be called to allocate
request for these queues.

Tags can be reserved in these tagset. Before error recovery, there is
often lots of in-flight requests which can't be completed, and new
reserved request may be needed in error recovery path. However,
hctx_may_queue() can always return false because there is too many
in-flight requests which can't be completed during error handling.
Finally, nothing can proceed.

Fix this issue by always allowing reserved tag allocation in
hctx_may_queue(). This is reasonable because reserved tags are supposed
to always be available.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: David Milburn <dmilburn@redhat.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-tag.c | 3 ++-
 block/blk-mq.c     | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 32d82e23b0953..a1c1e7c611f7b 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -59,7 +59,8 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 static int __blk_mq_get_tag(struct blk_mq_alloc_data *data,
 			    struct sbitmap_queue *bt)
 {
-	if (!data->q->elevator && !hctx_may_queue(data->hctx, bt))
+	if (!data->q->elevator && !(data->flags & BLK_MQ_REQ_RESERVED) &&
+			!hctx_may_queue(data->hctx, bt))
 		return BLK_MQ_NO_TAG;
 
 	if (data->shallow_depth)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index cdced4aca2e81..96425e4bd2b2c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1105,10 +1105,11 @@ static bool __blk_mq_get_driver_tag(struct request *rq)
 	if (blk_mq_tag_is_reserved(rq->mq_hctx->sched_tags, rq->internal_tag)) {
 		bt = &rq->mq_hctx->tags->breserved_tags;
 		tag_offset = 0;
+	} else {
+		if (!hctx_may_queue(rq->mq_hctx, bt))
+			return false;
 	}
 
-	if (!hctx_may_queue(rq->mq_hctx, bt))
-		return false;
 	tag = __sbitmap_queue_get(bt);
 	if (tag == BLK_MQ_NO_TAG)
 		return false;
-- 
2.25.1

