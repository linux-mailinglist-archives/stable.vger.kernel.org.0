Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1145229BC7B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810027AbgJ0QdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802486AbgJ0Pth (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:49:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A26C223C6;
        Tue, 27 Oct 2020 15:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813764;
        bh=EO+sVCLZuPtH9lMAYoB1dKEjFQdyQRcZ0CKObM1UlvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqfnLyi7oEIcERunfCOCupJG3pcZFOiPe7K+Be9pmEpUsWMW5CgbMkeaeZArlkw/W
         MhUjfESunfBxXV9aaDC2cmDmcXbbiKkbLrOBn6YOuJ1m0pEt2IDIM4AFWSMgbneAIy
         SJ5X5eSB/psHkbwqni10wL8FF7E9qnxXcL+i4+L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        David Milburn <dmilburn@redhat.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 662/757] blk-mq: always allow reserved allocation in hctx_may_queue
Date:   Tue, 27 Oct 2020 14:55:12 +0100
Message-Id: <20201027135521.592311582@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c27a61029cdd0..94a53d779c12b 100644
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



