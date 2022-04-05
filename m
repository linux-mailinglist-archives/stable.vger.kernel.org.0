Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7AE4F24C5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiDEHlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiDEHlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:41:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA492DD78;
        Tue,  5 Apr 2022 00:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85FAA61690;
        Tue,  5 Apr 2022 07:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF7CC340EE;
        Tue,  5 Apr 2022 07:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144341;
        bh=6xkDEweOfEzoGoiNJXTy88t2266cuaPp/Iftm3Wjg30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ock9BViuE6FFGCUR4qQjh0iTQ4vhrC1CMVCNHv9ZdKM14+npQ9pCdiR62b/G7Vcn1
         gpSFIstf1IiKTqxl7dkmvAZFQldW3P9a3C9TiSO1/he634FH78to0rdCt2QiFDz5PA
         kwTyiECU7vMlFydwtOqcnfpbQMk6+hNe9PDOEmZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Subject: [PATCH 5.17 0011/1126] block: flush plug based on hardware and software queue order
Date:   Tue,  5 Apr 2022 09:12:38 +0200
Message-Id: <20220405070407.870039665@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 26fed4ac4eab09c27fbae1859696cc38f0536407 upstream.

We used to sort the plug list if we had multiple queues before dispatching
requests to the IO scheduler. This usually isn't needed, but for certain
workloads that interleave requests to disks, it's a less efficient to
process the plug list one-by-one if everything is interleaved.

Don't sort the list, but skip through it and flush out entries that have
the same target at the same time.

Fixes: df87eb0fce8f ("block: get rid of plug list sorting")
Reported-and-tested-by: Song Liu <song@kernel.org>
Reviewed-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |   59 +++++++++++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2561,13 +2561,36 @@ static void __blk_mq_flush_plug_list(str
 	q->mq_ops->queue_rqs(&plug->mq_list);
 }
 
+static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
+{
+	struct blk_mq_hw_ctx *this_hctx = NULL;
+	struct blk_mq_ctx *this_ctx = NULL;
+	struct request *requeue_list = NULL;
+	unsigned int depth = 0;
+	LIST_HEAD(list);
+
+	do {
+		struct request *rq = rq_list_pop(&plug->mq_list);
+
+		if (!this_hctx) {
+			this_hctx = rq->mq_hctx;
+			this_ctx = rq->mq_ctx;
+		} else if (this_hctx != rq->mq_hctx || this_ctx != rq->mq_ctx) {
+			rq_list_add(&requeue_list, rq);
+			continue;
+		}
+		list_add_tail(&rq->queuelist, &list);
+		depth++;
+	} while (!rq_list_empty(plug->mq_list));
+
+	plug->mq_list = requeue_list;
+	trace_block_unplug(this_hctx->queue, depth, !from_sched);
+	blk_mq_sched_insert_requests(this_hctx, this_ctx, &list, from_sched);
+}
+
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
-	struct blk_mq_hw_ctx *this_hctx;
-	struct blk_mq_ctx *this_ctx;
 	struct request *rq;
-	unsigned int depth;
-	LIST_HEAD(list);
 
 	if (rq_list_empty(plug->mq_list))
 		return;
@@ -2603,35 +2626,9 @@ void blk_mq_flush_plug_list(struct blk_p
 			return;
 	}
 
-	this_hctx = NULL;
-	this_ctx = NULL;
-	depth = 0;
 	do {
-		rq = rq_list_pop(&plug->mq_list);
-
-		if (!this_hctx) {
-			this_hctx = rq->mq_hctx;
-			this_ctx = rq->mq_ctx;
-		} else if (this_hctx != rq->mq_hctx || this_ctx != rq->mq_ctx) {
-			trace_block_unplug(this_hctx->queue, depth,
-						!from_schedule);
-			blk_mq_sched_insert_requests(this_hctx, this_ctx,
-						&list, from_schedule);
-			depth = 0;
-			this_hctx = rq->mq_hctx;
-			this_ctx = rq->mq_ctx;
-
-		}
-
-		list_add(&rq->queuelist, &list);
-		depth++;
+		blk_mq_dispatch_plug_list(plug, from_schedule);
 	} while (!rq_list_empty(plug->mq_list));
-
-	if (!list_empty(&list)) {
-		trace_block_unplug(this_hctx->queue, depth, !from_schedule);
-		blk_mq_sched_insert_requests(this_hctx, this_ctx, &list,
-						from_schedule);
-	}
 }
 
 void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,


