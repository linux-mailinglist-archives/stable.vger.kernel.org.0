Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB63553ED5A
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiFFR5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 13:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiFFR5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 13:57:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1255B2F9AFF;
        Mon,  6 Jun 2022 10:57:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 072501FAB4;
        Mon,  6 Jun 2022 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654538221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHkxjr2Ym/i8mJeccO571n7luRlOdtuAed072azC5j0=;
        b=ebRitawTLd0gPBOmRE6mDb1/UpAffDAkGfNyh4+GLCdca4kHtHtDsEGYTqLXfWka6fQ5aQ
        mNCAbEwjeQzjtxwHSIU9hfDRrvy0Mae1b9mFNxKIZojlrSGW8LSYHdFpGspUCM9IpYlyfc
        bBNYmQ9DePCYaPJ50VGgHd+OtltKQRg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654538221;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHkxjr2Ym/i8mJeccO571n7luRlOdtuAed072azC5j0=;
        b=+gzQphCqvLRn1/cFj3tY59A31gl7eS7FVRhWGvAbJ/P8Ky0X/s9FbGIZg45LGjlfYEczqp
        SqeZ28Ob0tRe7gDg==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E27FF2C145;
        Mon,  6 Jun 2022 17:57:00 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 1B85EA0637; Mon,  6 Jun 2022 19:56:55 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     <linux-block@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        "yukuai (C)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] bfq: Remove pointless bfq_init_rq() calls
Date:   Mon,  6 Jun 2022 19:56:38 +0200
Message-Id: <20220606175655.8993-3-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220606174118.10992-1-jack@suse.cz>
References: <20220606174118.10992-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3088; h=from:subject; bh=3klBZKaG8TQ6MLxmPuPqj5KLP4rIpGxj0PEejZkD6sA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinj/Wt0fJtlT36dh/RxOKXc22ad0vX7OD4CU6Y4+5 WGNAswyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp4/1gAKCRCcnaoHP2RA2dE6B/ 9xCeWgIaVpZPakL3+DdNWrM0/8YmFJwSiIsYqPTeDc5kHxHmhhRasQuedq8ymHfbav7dCnhTBg3eTT h3KS30hO8T1IinL9ShkA67vueIJ0YlRfJ28KSlbhw3s+BOT/tfhc188D97+lLWDja/9YDUXIZfY4PF 9XDxE3g1jO1ckBTLIFhrB+hBbVXZWnzZEQ2c9aPeo4dtlKrcj5TzzCR7RUPd4/7RL+n/Pi3EG5cv/S ooqLiBSai8PRPOJgwu7e+35y4iiYqRxXMs5d19aErTNFL9edRQMPJfrNVdt15qN8mXVkPsjGP7KCGD 3AHhFvLet+vWfcxtYQsdi7gLQaw3cK
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 block/bfq-iosched.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index bad088103279..3b605d8d99bf 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2267,8 +2267,6 @@ static int bfq_request_merge(struct request_queue *q, struct request **req,
 	return ELEVATOR_NO_MERGE;
 }
 
-static struct bfq_queue *bfq_init_rq(struct request *rq);
-
 static void bfq_request_merged(struct request_queue *q, struct request *req,
 			       enum elv_merge type)
 {
@@ -2277,7 +2275,7 @@ static void bfq_request_merged(struct request_queue *q, struct request *req,
 	    blk_rq_pos(req) <
 	    blk_rq_pos(container_of(rb_prev(&req->rb_node),
 				    struct request, rb_node))) {
-		struct bfq_queue *bfqq = bfq_init_rq(req);
+		struct bfq_queue *bfqq = RQ_BFQQ(req);
 		struct bfq_data *bfqd;
 		struct request *prev, *next_rq;
 
@@ -2329,8 +2327,8 @@ static void bfq_request_merged(struct request_queue *q, struct request *req,
 static void bfq_requests_merged(struct request_queue *q, struct request *rq,
 				struct request *next)
 {
-	struct bfq_queue *bfqq = bfq_init_rq(rq),
-		*next_bfqq = bfq_init_rq(next);
+	struct bfq_queue *bfqq = RQ_BFQQ(rq),
+		*next_bfqq = RQ_BFQQ(next);
 
 	if (!bfqq)
 		return;
@@ -5518,6 +5516,8 @@ static inline void bfq_update_insert_stats(struct request_queue *q,
 					   unsigned int cmd_flags) {}
 #endif /* CONFIG_BFQ_CGROUP_DEBUG */
 
+static struct bfq_queue *bfq_init_rq(struct request *rq);
+
 static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 			       bool at_head)
 {
@@ -5532,6 +5532,7 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 		bfqg_stats_update_legacy_io(q, rq);
 #endif
 	spin_lock_irq(&bfqd->lock);
+	bfqq = bfq_init_rq(rq);
 	if (blk_mq_sched_try_insert_merge(q, rq)) {
 		spin_unlock_irq(&bfqd->lock);
 		return;
@@ -5539,7 +5540,6 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	blk_mq_sched_request_inserted(rq);
 
-	bfqq = bfq_init_rq(rq);
 	if (!bfqq || at_head || blk_rq_is_passthrough(rq)) {
 		if (at_head)
 			list_add(&rq->queuelist, &bfqd->dispatch);
-- 
2.35.3

