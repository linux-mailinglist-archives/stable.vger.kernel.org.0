Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D924F2BA7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343684AbiDEI5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbiDEIjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:39:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90D21BB;
        Tue,  5 Apr 2022 01:33:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EC34B81C14;
        Tue,  5 Apr 2022 08:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85A1C385A0;
        Tue,  5 Apr 2022 08:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147611;
        bh=c04I7xSLn2X3v4DHKriGZ3PkJ9qQh69X1RKAjzC5s9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9OuOpystmZwaXX+ei8PjXP8YsAOYMlIHzfFDtToBAllZhjRVjfC6ssJTe0jM+GoQ
         ye4ypyGNzYYqRNq4b49y4zVNmWYWYnJSc0WExqQ+/yQESMBAV2ZJj+ZslkwnUAg6Kz
         TnYINRJsY35CPnImZ7C+Z/hcNs/hR9k9+qvRIplY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Subject: [PATCH 5.16 0031/1017] block: flush plug based on hardware and software queue order
Date:   Tue,  5 Apr 2022 09:15:44 +0200
Message-Id: <20220405070355.102575591@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
 block/blk-mq.c |   60 +++++++++++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2244,13 +2244,35 @@ static void blk_mq_plug_issue_direct(str
 		blk_mq_commit_rqs(hctx, &queued, from_schedule);
 }
 
-void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
+static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
 {
-	struct blk_mq_hw_ctx *this_hctx;
-	struct blk_mq_ctx *this_ctx;
-	unsigned int depth;
+	struct blk_mq_hw_ctx *this_hctx = NULL;
+	struct blk_mq_ctx *this_ctx = NULL;
+	struct request *requeue_list = NULL;
+	unsigned int depth = 0;
 	LIST_HEAD(list);
 
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
+void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
+{
 	if (rq_list_empty(plug->mq_list))
 		return;
 	plug->rq_count = 0;
@@ -2261,37 +2283,9 @@ void blk_mq_flush_plug_list(struct blk_p
 			return;
 	}
 
-	this_hctx = NULL;
-	this_ctx = NULL;
-	depth = 0;
 	do {
-		struct request *rq;
-
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
 
 static void blk_mq_bio_to_request(struct request *rq, struct bio *bio,


