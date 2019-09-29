Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F687C14E6
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfI2N66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729614AbfI2N65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93A5221835;
        Sun, 29 Sep 2019 13:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765537;
        bh=0vs7MKP/u+n+bqQbFXLZ3o3kg6UDGOoJgE5xJnQoLTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNU6ZakcpsH2dzJk1+2pWfdNguUlNMVH4CCJW9tlglnNETM7AMgH0AFAcvH9V0V+0
         lmAIlJwKCj/NFMxLjULmb72GGjjvYTbizUi0IlXcHc0ZCuRbJIVaLSwr+W1Jly43AC
         aPA3E+IiWNfkJMhNndhhtXZnFmTWBb00bdih+phc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        zhengbin <zhengbin13@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/63] blk-mq: move cancel of requeue_work to the front of blk_exit_queue
Date:   Sun, 29 Sep 2019 15:54:22 +0200
Message-Id: <20190929135039.979179041@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit e26cc08265dda37d2acc8394604f220ef412299d ]

blk_exit_queue will free elevator_data, while blk_mq_requeue_work
will access it. Move cancel of requeue_work to the front of
blk_exit_queue to avoid use-after-free.

blk_exit_queue                blk_mq_requeue_work
  __elevator_exit               blk_mq_run_hw_queues
    blk_mq_exit_sched             blk_mq_run_hw_queue
      dd_exit_queue                 blk_mq_hctx_has_pending
        kfree(elevator_data)          blk_mq_sched_has_work
                                        dd_has_work

Fixes: fbc2a15e3433 ("blk-mq: move cancel of requeue_work into blk_mq_release")
Cc: stable@vger.kernel.org
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c    | 2 --
 block/blk-sysfs.c | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9dfafee65bce2..7ea85ec52026e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2461,8 +2461,6 @@ void blk_mq_release(struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int i;
 
-	cancel_delayed_work_sync(&q->requeue_work);
-
 	/* hctx kobj stays in hctx */
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (!hctx)
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 3772671cf2bc5..bab47a17b96f4 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -836,6 +836,9 @@ static void __blk_release_queue(struct work_struct *work)
 
 	blk_free_queue_stats(q->stats);
 
+	if (q->mq_ops)
+		cancel_delayed_work_sync(&q->requeue_work);
+
 	blk_exit_rl(q, &q->root_rl);
 
 	if (q->queue_tags)
-- 
2.20.1



