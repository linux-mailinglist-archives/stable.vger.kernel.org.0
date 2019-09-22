Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61562BA41E
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389806AbfIVSqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389732AbfIVSqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:46:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E796420665;
        Sun, 22 Sep 2019 18:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177962;
        bh=PXGyuAPnXiAbwagSHmuY/DyLAwPdHDjmxWdSWUh6/3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2ljBtX2+0UOL6vFWFcDiwS0B4Pf2t9Mi30IfuU5VXt3k1Bm/mwq1yfyPmPF4oziI
         Wnxu8DMsUcTPFMAvMAH3q3w6UnWlqXXnCNTTn9QAT+1nGdTLqoBvRtGnQpWtala4ud
         lVG1Rgn+z8Ol2Ff24Du6tTHkyYYcWRCz1CZpvy6U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 066/203] blk-mq: Fix memory leak in blk_mq_init_allocated_queue error handling
Date:   Sun, 22 Sep 2019 14:41:32 -0400
Message-Id: <20190922184350.30563-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit 73d9c8d4c0017e21e1ff519474ceb1450484dc9a ]

If blk_mq_init_allocated_queue->elevator_init_mq fails, need to release
the previously requested resources.

Fixes: d34849913819 ("blk-mq-sched: allow setting of default IO scheduler")
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0835f4d8d42e7..a38ebb2a380c2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2841,6 +2841,8 @@ static unsigned int nr_hw_queues(struct blk_mq_tag_set *set)
 struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 						  struct request_queue *q)
 {
+	int ret = -ENOMEM;
+
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
 
@@ -2902,17 +2904,18 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_mq_map_swqueue(q);
 
 	if (!(set->flags & BLK_MQ_F_NO_SCHED)) {
-		int ret;
-
 		ret = elevator_init_mq(q);
 		if (ret)
-			return ERR_PTR(ret);
+			goto err_tag_set;
 	}
 
 	return q;
 
+err_tag_set:
+	blk_mq_del_queue_tag_set(q);
 err_hctxs:
 	kfree(q->queue_hw_ctx);
+	q->nr_hw_queues = 0;
 err_sys_init:
 	blk_mq_sysfs_deinit(q);
 err_poll:
-- 
2.20.1

