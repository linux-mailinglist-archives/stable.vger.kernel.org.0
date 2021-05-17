Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CAD3831E1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237557AbhEQOlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241103AbhEQOjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:39:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4839961940;
        Mon, 17 May 2021 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261117;
        bh=w0+6Qfrb1eI4hDll0vQaVzxrvkB9iFCcVUGwXflR2Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKa8ZbY6T5ykREf4eQT8IrbhD8cI5zU+hsiu0GmAeiwZbOXBylIw1jKT2N68TyNm1
         tiLZdlGryTddNYmRp40fHutrov4WC6aI+qYLFrxvcmxSSjI4gtQvPSDGprUouTA6r1
         j/JAfDjXPCLxWx4yA/v5eO83SZSYFuM/ZIVbwibY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 307/363] blk-mq: Swap two calls in blk_mq_exit_queue()
Date:   Mon, 17 May 2021 16:02:53 +0200
Message-Id: <20210517140312.980190855@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 630ef623ed26c18a457cdc070cf24014e50129c2 ]

If a tag set is shared across request queues (e.g. SCSI LUNs) then the
block layer core keeps track of the number of active request queues in
tags->active_queues. blk_mq_tag_busy() and blk_mq_tag_idle() update that
atomic counter if the hctx flag BLK_MQ_F_TAG_QUEUE_SHARED is set. Make
sure that blk_mq_exit_queue() calls blk_mq_tag_idle() before that flag is
cleared by blk_mq_del_queue_tag_set().

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Fixes: 0d2602ca30e4 ("blk-mq: improve support for shared tags maps")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210513171529.7977-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c0b740be62ad..0e120547ccb7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3270,10 +3270,12 @@ EXPORT_SYMBOL(blk_mq_init_allocated_queue);
 /* tags can _not_ be used after returning from blk_mq_exit_queue */
 void blk_mq_exit_queue(struct request_queue *q)
 {
-	struct blk_mq_tag_set	*set = q->tag_set;
+	struct blk_mq_tag_set *set = q->tag_set;
 
-	blk_mq_del_queue_tag_set(q);
+	/* Checks hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED. */
 	blk_mq_exit_hw_queues(q, set, set->nr_hw_queues);
+	/* May clear BLK_MQ_F_TAG_QUEUE_SHARED in hctx->flags. */
+	blk_mq_del_queue_tag_set(q);
 }
 
 static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
-- 
2.30.2



