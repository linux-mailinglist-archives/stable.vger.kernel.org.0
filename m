Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC174406BC7
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhIJMeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:34:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233918AbhIJMd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77022611EF;
        Fri, 10 Sep 2021 12:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277166;
        bh=ZBqY2Sh08tkx1x7/Pj9gi0ePyXfVZYSCpi/cQzQDo+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ae1k5S9eOp74CFHIOYBRJTv2TbQkTjf4lgzHNhFNgjlXM1qORGDhNpePxfbdQY/g0
         tBGZ/LbjKaMQPP+OFQeL0IHDUG9GiII33gqgmlUXfphFX/a4+qwG8kixvvabgEY6K3
         lxQrwBLfh4kAbWyTry+012HI4ASxBg5xDiLDUBOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Blank-Burian, Markus, Dr." <blankburian@uni-muenster.de>,
        Yufen Yu <yuyufen@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>
Subject: [PATCH 5.13 06/22] blk-mq: fix is_flush_rq
Date:   Fri, 10 Sep 2021 14:30:05 +0200
Message-Id: <20210910122916.147508479@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122915.942645251@linuxfoundation.org>
References: <20210910122915.942645251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit a9ed27a764156929efe714033edb3e9023c5f321 upstream.

is_flush_rq() is called from bt_iter()/bt_tags_iter(), and runs the
following check:

	hctx->fq->flush_rq == req

but the passed hctx from bt_iter()/bt_tags_iter() may be NULL because:

1) memory re-order in blk_mq_rq_ctx_init():

	rq->mq_hctx = data->hctx;
	...
	refcount_set(&rq->ref, 1);

OR

2) tag re-use and ->rqs[] isn't updated with new request.

Fix the issue by re-writing is_flush_rq() as:

	return rq->end_io == flush_end_io;

which turns out simpler to follow and immune to data race since we have
ordered WRITE rq->end_io and refcount_set(&rq->ref, 1).

Fixes: 2e315dc07df0 ("blk-mq: grab rq->refcount before calling ->fn in blk_mq_tagset_busy_iter")
Cc: "Blank-Burian, Markus, Dr." <blankburian@uni-muenster.de>
Cc: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210818010925.607383-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-flush.c |    5 +++++
 block/blk-mq.c    |    2 +-
 block/blk.h       |    6 +-----
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -262,6 +262,11 @@ static void flush_end_io(struct request
 	spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
 }
 
+bool is_flush_rq(struct request *rq)
+{
+	return rq->end_io == flush_end_io;
+}
+
 /**
  * blk_kick_flush - consider issuing flush request
  * @q: request_queue being kicked
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -911,7 +911,7 @@ static bool blk_mq_req_expired(struct re
 
 void blk_mq_put_rq_ref(struct request *rq)
 {
-	if (is_flush_rq(rq, rq->mq_hctx))
+	if (is_flush_rq(rq))
 		rq->end_io(rq, 0);
 	else if (refcount_dec_and_test(&rq->ref))
 		__blk_mq_free_request(rq);
--- a/block/blk.h
+++ b/block/blk.h
@@ -44,11 +44,7 @@ static inline void __blk_get_queue(struc
 	kobject_get(&q->kobj);
 }
 
-static inline bool
-is_flush_rq(struct request *req, struct blk_mq_hw_ctx *hctx)
-{
-	return hctx->fq->flush_rq == req;
-}
+bool is_flush_rq(struct request *req);
 
 struct blk_flush_queue *blk_alloc_flush_queue(int node, int cmd_size,
 					      gfp_t flags);


