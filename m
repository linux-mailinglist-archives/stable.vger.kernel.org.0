Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EC429B1AD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902371AbgJ0Oc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902367AbgJ0Ocy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:32:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAA8420725;
        Tue, 27 Oct 2020 14:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809174;
        bh=YLXIVoUUsD7oLtHfedDeIn2EIULEmfZqsrfd4FKJ/4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6Y3WEoKMtGTL/+YAu6NwTKAMNwsijkJmEsSk0BazAJapAsS1QUCnpGEfi0TlYt25
         rixayYK46rSS8/NKZs4noaQri4PDxUXcvZsV29i2a+gn9bAevIW5idXeYc/U3A5vqj
         6HjCLhpvg++q6ATpN3WRQF8UfEjb1zSisw9DxRmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yang <yang.yang@vivo.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/408] blk-mq: move cancel of hctx->run_work to the front of blk_exit_queue
Date:   Tue, 27 Oct 2020 14:50:40 +0100
Message-Id: <20201027135459.829784146@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yang <yang.yang@vivo.com>

[ Upstream commit 47ce030b7ac5a5259a9a5919f230b52497afc31a ]

blk_exit_queue will free elevator_data, while blk_mq_run_work_fn
will access it. Move cancel of hctx->run_work to the front of
blk_exit_queue to avoid use-after-free.

Fixes: 1b97871b501f ("blk-mq: move cancel of hctx->run_work into blk_mq_hw_sysfs_release")
Signed-off-by: Yang Yang <yang.yang@vivo.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sysfs.c | 2 --
 block/blk-sysfs.c    | 9 ++++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index a09ab0c3d074d..5dafd7a8ec913 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -36,8 +36,6 @@ static void blk_mq_hw_sysfs_release(struct kobject *kobj)
 	struct blk_mq_hw_ctx *hctx = container_of(kobj, struct blk_mq_hw_ctx,
 						  kobj);
 
-	cancel_delayed_work_sync(&hctx->run_work);
-
 	if (hctx->flags & BLK_MQ_F_BLOCKING)
 		cleanup_srcu_struct(hctx->srcu);
 	blk_free_flush_queue(hctx->fq);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 46f5198be0173..bf33570da5ac7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -891,9 +891,16 @@ static void __blk_release_queue(struct work_struct *work)
 
 	blk_free_queue_stats(q->stats);
 
-	if (queue_is_mq(q))
+	if (queue_is_mq(q)) {
+		struct blk_mq_hw_ctx *hctx;
+		int i;
+
 		cancel_delayed_work_sync(&q->requeue_work);
 
+		queue_for_each_hw_ctx(q, hctx, i)
+			cancel_delayed_work_sync(&hctx->run_work);
+	}
+
 	blk_exit_queue(q);
 
 	blk_queue_free_zone_bitmaps(q);
-- 
2.25.1



