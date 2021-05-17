Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA7A3837E0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244835AbhEQPrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344754AbhEQPph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2925561D33;
        Mon, 17 May 2021 14:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262631;
        bh=eLuid/kmF5F4tnB7tm+GcJuM4d6wwcP0W5n7vKBwE4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QjBeVtt8wAvDmx8AkX66Kc9VWEySSB8xOfn0Tb6gIFcHwv0Pm2/uBfjDntmiCf4Lv
         hokR6k1EpWIqotM18v99c/ahPbz6Bmipvg73H9X487h115tWe4Zwvme0YumeksgeA/
         WMS7qIZXcnG1ebZGORiSnto0iEd7vRGBZ8v4PP1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/289] blk-mq: Swap two calls in blk_mq_exit_queue()
Date:   Mon, 17 May 2021 16:02:44 +0200
Message-Id: <20210517140313.212672297@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index 4cd623a7383c..4bf9449b4586 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3256,10 +3256,12 @@ EXPORT_SYMBOL(blk_mq_init_allocated_queue);
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



