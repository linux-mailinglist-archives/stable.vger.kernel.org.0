Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65BF406BDD
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhIJMfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233394AbhIJMe3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:34:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F853611F2;
        Fri, 10 Sep 2021 12:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277199;
        bh=N+X6dDOdaFYryrWTgzWwsS6fY5MCzcMnHkhpuV1FUEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3VGrslV3p9IapjnBfEfI5+Wkfv34Ljix/9KdCWDuU0yKZAP9U3NFfGLvy5dYzFC5
         +WD8O7g/cpjfBE74G9jDrkQEsKRDSfvTL5HnIFB3wIqbIxUh80OsJStT+pTkNjigPc
         TwT6fIv5v9GbiBeakEJSrC50XlqGn+UB3KMqiY9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        David Jeffery <djeffery@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 16/26] blk-mq: clearing flush request reference in tags->rqs[]
Date:   Fri, 10 Sep 2021 14:30:20 +0200
Message-Id: <20210910122916.774523957@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
References: <20210910122916.253646001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 364b61818f65045479e42e76ed8dd6f051778280 upstream.

Before we free request queue, clearing flush request reference in
tags->rqs[], so that potential UAF can be avoided.

Based on one patch written by David Jeffery.

Tested-by: John Garry <john.garry@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210511152236.763464-5-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2589,16 +2589,49 @@ static void blk_mq_remove_cpuhp(struct b
 					    &hctx->cpuhp_dead);
 }
 
+/*
+ * Before freeing hw queue, clearing the flush request reference in
+ * tags->rqs[] for avoiding potential UAF.
+ */
+static void blk_mq_clear_flush_rq_mapping(struct blk_mq_tags *tags,
+		unsigned int queue_depth, struct request *flush_rq)
+{
+	int i;
+	unsigned long flags;
+
+	/* The hw queue may not be mapped yet */
+	if (!tags)
+		return;
+
+	WARN_ON_ONCE(refcount_read(&flush_rq->ref) != 0);
+
+	for (i = 0; i < queue_depth; i++)
+		cmpxchg(&tags->rqs[i], flush_rq, NULL);
+
+	/*
+	 * Wait until all pending iteration is done.
+	 *
+	 * Request reference is cleared and it is guaranteed to be observed
+	 * after the ->lock is released.
+	 */
+	spin_lock_irqsave(&tags->lock, flags);
+	spin_unlock_irqrestore(&tags->lock, flags);
+}
+
 /* hctx->ctxs will be freed in queue's release handler */
 static void blk_mq_exit_hctx(struct request_queue *q,
 		struct blk_mq_tag_set *set,
 		struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
 {
+	struct request *flush_rq = hctx->fq->flush_rq;
+
 	if (blk_mq_hw_queue_mapped(hctx))
 		blk_mq_tag_idle(hctx);
 
+	blk_mq_clear_flush_rq_mapping(set->tags[hctx_idx],
+			set->queue_depth, flush_rq);
 	if (set->ops->exit_request)
-		set->ops->exit_request(set, hctx->fq->flush_rq, hctx_idx);
+		set->ops->exit_request(set, flush_rq, hctx_idx);
 
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);


