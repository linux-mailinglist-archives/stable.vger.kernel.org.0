Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB9F5407DD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348383AbiFGRwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349987AbiFGRvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7676F13FD45;
        Tue,  7 Jun 2022 10:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADFACB820C3;
        Tue,  7 Jun 2022 17:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2620CC36B00;
        Tue,  7 Jun 2022 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623508;
        bh=tyM7H0z0JY6XjH8ccFzhWzhTEOySrH0mR0zkxhylm3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyVftNFP6guKVJFafFRhFCvogkq7NPaNN3RroKiXpieLHFTZG5SPv0D2gc5xMlf8a
         8CjG5BbamvMGzefa+p6GG4e2WUEBXbCdaw29rUnnc1epjEIbE9ZlDCuThL3ciRG6Up
         zMpCMVvK/zgDnOq8WKZ64CCOA8U/An8EdFQmE7DA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 443/452] bfq: Remove pointless bfq_init_rq() calls
Date:   Tue,  7 Jun 2022 19:05:00 +0200
Message-Id: <20220607164921.768178714@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 5f550ede5edf846ecc0067be1ba80514e6fe7f8e upstream.

We call bfq_init_rq() from request merging functions where requests we
get should have already gone through bfq_init_rq() during insert and
anyway we want to do anything only if the request is already tracked by
BFQ. So replace calls to bfq_init_rq() with RQ_BFQQ() instead to simply
skip requests untracked by BFQ. We move bfq_init_rq() call in
bfq_insert_request() a bit earlier to cover request merging and thus
can transfer FIFO position in case of a merge.

CC: stable@vger.kernel.org
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220401102752.8599-6-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2267,8 +2267,6 @@ static int bfq_request_merge(struct requ
 	return ELEVATOR_NO_MERGE;
 }
 
-static struct bfq_queue *bfq_init_rq(struct request *rq);
-
 static void bfq_request_merged(struct request_queue *q, struct request *req,
 			       enum elv_merge type)
 {
@@ -2277,7 +2275,7 @@ static void bfq_request_merged(struct re
 	    blk_rq_pos(req) <
 	    blk_rq_pos(container_of(rb_prev(&req->rb_node),
 				    struct request, rb_node))) {
-		struct bfq_queue *bfqq = bfq_init_rq(req);
+		struct bfq_queue *bfqq = RQ_BFQQ(req);
 		struct bfq_data *bfqd;
 		struct request *prev, *next_rq;
 
@@ -2329,8 +2327,8 @@ static void bfq_request_merged(struct re
 static void bfq_requests_merged(struct request_queue *q, struct request *rq,
 				struct request *next)
 {
-	struct bfq_queue *bfqq = bfq_init_rq(rq),
-		*next_bfqq = bfq_init_rq(next);
+	struct bfq_queue *bfqq = RQ_BFQQ(rq),
+		*next_bfqq = RQ_BFQQ(next);
 
 	if (!bfqq)
 		return;
@@ -5518,6 +5516,8 @@ static inline void bfq_update_insert_sta
 					   unsigned int cmd_flags) {}
 #endif /* CONFIG_BFQ_CGROUP_DEBUG */
 
+static struct bfq_queue *bfq_init_rq(struct request *rq);
+
 static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 			       bool at_head)
 {
@@ -5532,6 +5532,7 @@ static void bfq_insert_request(struct bl
 		bfqg_stats_update_legacy_io(q, rq);
 #endif
 	spin_lock_irq(&bfqd->lock);
+	bfqq = bfq_init_rq(rq);
 	if (blk_mq_sched_try_insert_merge(q, rq)) {
 		spin_unlock_irq(&bfqd->lock);
 		return;
@@ -5539,7 +5540,6 @@ static void bfq_insert_request(struct bl
 
 	blk_mq_sched_request_inserted(rq);
 
-	bfqq = bfq_init_rq(rq);
 	if (!bfqq || at_head || blk_rq_is_passthrough(rq)) {
 		if (at_head)
 			list_add(&rq->queuelist, &bfqd->dispatch);


