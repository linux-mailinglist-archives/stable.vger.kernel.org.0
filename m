Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7DA1F085
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbfEOLpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732101AbfEOL0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:26:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A39EF2089E;
        Wed, 15 May 2019 11:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919562;
        bh=0x8tNMF2GxGVdUOlx+DPgH3PHdSC/X+m1eoIStvq3HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VO05Fb0xeKjnTdXHGJIcFMQyxd1UtwBFNwddr2VZV8rWVtEw73iSYARw/XrOzdSDm
         r8/AveqANDunXTC+rlnlh4C+3UrzUOugHLPXZdM61wfMUD6CEKZ7kcE+huiWxivrHB
         lWNpUF/6yVY/ngXtxbgsXgxkmOYqB+amWjNsn+ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Krakow <kai@kaishome.de>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 001/137] bfq: update internal depth state when queue depth changes
Date:   Wed, 15 May 2019 12:54:42 +0200
Message-Id: <20190515090651.807776995@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 77f1e0a52d26242b6c2dba019f6ebebfb9ff701e ]

A previous commit moved the shallow depth and BFQ depth map calculations
to be done at init time, moving it outside of the hotter IO path. This
potentially causes hangs if the users changes the depth of the scheduler
map, by writing to the 'nr_requests' sysfs file for that device.

Add a blk-mq-sched hook that allows blk-mq to inform the scheduler if
the depth changes, so that the scheduler can update its internal state.

Tested-by: Kai Krakow <kai@kaishome.de>
Reported-by: Paolo Valente <paolo.valente@linaro.org>
Fixes: f0635b8a416e ("bfq: calculate shallow depths at init time")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c      | 8 +++++++-
 block/blk-mq.c           | 2 ++
 include/linux/elevator.h | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 72510c4700014..356620414cf94 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5353,7 +5353,7 @@ static unsigned int bfq_update_depths(struct bfq_data *bfqd,
 	return min_shallow;
 }
 
-static int bfq_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int index)
+static void bfq_depth_updated(struct blk_mq_hw_ctx *hctx)
 {
 	struct bfq_data *bfqd = hctx->queue->elevator->elevator_data;
 	struct blk_mq_tags *tags = hctx->sched_tags;
@@ -5361,6 +5361,11 @@ static int bfq_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int index)
 
 	min_shallow = bfq_update_depths(bfqd, &tags->bitmap_tags);
 	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, min_shallow);
+}
+
+static int bfq_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int index)
+{
+	bfq_depth_updated(hctx);
 	return 0;
 }
 
@@ -5783,6 +5788,7 @@ static struct elevator_type iosched_bfq_mq = {
 		.requests_merged	= bfq_requests_merged,
 		.request_merged		= bfq_request_merged,
 		.has_work		= bfq_has_work,
+		.depth_updated		= bfq_depth_updated,
 		.init_hctx		= bfq_init_hctx,
 		.init_sched		= bfq_init_queue,
 		.exit_sched		= bfq_exit_queue,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6930c82ab75fc..5b920a82bfe60 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3131,6 +3131,8 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		}
 		if (ret)
 			break;
+		if (q->elevator && q->elevator->type->ops.depth_updated)
+			q->elevator->type->ops.depth_updated(hctx);
 	}
 
 	if (!ret)
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 2e9e2763bf47d..6e8bc53740f05 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -31,6 +31,7 @@ struct elevator_mq_ops {
 	void (*exit_sched)(struct elevator_queue *);
 	int (*init_hctx)(struct blk_mq_hw_ctx *, unsigned int);
 	void (*exit_hctx)(struct blk_mq_hw_ctx *, unsigned int);
+	void (*depth_updated)(struct blk_mq_hw_ctx *);
 
 	bool (*allow_merge)(struct request_queue *, struct request *, struct bio *);
 	bool (*bio_merge)(struct blk_mq_hw_ctx *, struct bio *);
-- 
2.20.1



