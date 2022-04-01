Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9774EEB46
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245745AbiDAK3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245675AbiDAK3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:29:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1148526E56F;
        Fri,  1 Apr 2022 03:27:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A3CBA21A9B;
        Fri,  1 Apr 2022 10:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648808874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZNsnxIKTavjIHNIjtiVoZn5e2Xzy2WQNZ6NrPs/wvPE=;
        b=U55FlFMkxxe4Ayw50E4HNh0B694mjLaRuw8kMH+XsQvn3j/EzzCIR/xm/ivp9rshDWS3q4
        S9uiUhrvkjm8Ehb2Xuu0PFXK//WeiKzjxzKK1wkqoWSPBw3gAHgzOInp5Rg6TJtssu+PcR
        6OX6Kn5++V04rdhCNhsmMLEvN9xl4nI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648808874;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZNsnxIKTavjIHNIjtiVoZn5e2Xzy2WQNZ6NrPs/wvPE=;
        b=VUP7OekIG1gFTWpWDAHnD/SsqDjv4nHQZ++k77EkNEeHgDhGfMO6O9ujnn8W+mDXJVdaOU
        VstVeiIseielcvAA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 822F1A3B94;
        Fri,  1 Apr 2022 10:27:54 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 93C4AA061C; Fri,  1 Apr 2022 12:27:52 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 6/9] bfq: Remove pointless bfq_init_rq() calls
Date:   Fri,  1 Apr 2022 12:27:47 +0200
Message-Id: <20220401102752.8599-6-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401102325.17617-1-jack@suse.cz>
References: <20220401102325.17617-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2865; h=from:subject; bh=FpjUl5jP9AHT8IEvZDKrq5z048n3tCBdPWcF/ubs6jc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRtOjUBZ6tsjycaAfA+Aimb2kxDiN2ywujGvSawd3 SHt/IXiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkbTowAKCRCcnaoHP2RA2dg0B/ 4022/+xJxqhHg5UXlbYZeQTAbhdLNy1n54JPxUFdmJhtgRIAMFvkJS52ru3ABHEY6ShTuvZN0IveXK MYp1OlF983t3PW8sAgIKFQQ41j2amMhUde+feQhhQjoOhwHzt5pmL2h+a/3U7PMTSyYstiES4Q9f4C qrv9gnZXbvw/3CbiNceE4baqOnjSQoTLQb9ubGaH7iqd4EnJS5h3xPvSz5n3q5i1qKH6jGk8o3KK1V k9m45DACuNGt1GlHF+2e7sRTr1iNQpG6098+ZO7+5/5Wrag+aRIL7d7WlggLJR+IkXS1qp1GEpfgzK 1uA+w4PTdoRYCl6ERRAXu4UHc/SYkQ
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
---
 block/bfq-iosched.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 19082e14f3c1..d7cf930b47bb 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2497,8 +2497,6 @@ static int bfq_request_merge(struct request_queue *q, struct request **req,
 	return ELEVATOR_NO_MERGE;
 }
 
-static struct bfq_queue *bfq_init_rq(struct request *rq);
-
 static void bfq_request_merged(struct request_queue *q, struct request *req,
 			       enum elv_merge type)
 {
@@ -2507,7 +2505,7 @@ static void bfq_request_merged(struct request_queue *q, struct request *req,
 	    blk_rq_pos(req) <
 	    blk_rq_pos(container_of(rb_prev(&req->rb_node),
 				    struct request, rb_node))) {
-		struct bfq_queue *bfqq = bfq_init_rq(req);
+		struct bfq_queue *bfqq = RQ_BFQQ(req);
 		struct bfq_data *bfqd;
 		struct request *prev, *next_rq;
 
@@ -2559,8 +2557,8 @@ static void bfq_request_merged(struct request_queue *q, struct request *req,
 static void bfq_requests_merged(struct request_queue *q, struct request *rq,
 				struct request *next)
 {
-	struct bfq_queue *bfqq = bfq_init_rq(rq),
-		*next_bfqq = bfq_init_rq(next);
+	struct bfq_queue *bfqq = RQ_BFQQ(rq),
+		*next_bfqq = RQ_BFQQ(next);
 
 	if (!bfqq)
 		goto remove;
@@ -6129,6 +6127,8 @@ static inline void bfq_update_insert_stats(struct request_queue *q,
 					   unsigned int cmd_flags) {}
 #endif /* CONFIG_BFQ_CGROUP_DEBUG */
 
+static struct bfq_queue *bfq_init_rq(struct request *rq);
+
 static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 			       bool at_head)
 {
@@ -6144,6 +6144,7 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 		bfqg_stats_update_legacy_io(q, rq);
 #endif
 	spin_lock_irq(&bfqd->lock);
+	bfqq = bfq_init_rq(rq);
 	if (blk_mq_sched_try_insert_merge(q, rq, &free)) {
 		spin_unlock_irq(&bfqd->lock);
 		blk_mq_free_requests(&free);
@@ -6152,7 +6153,6 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	trace_block_rq_insert(rq);
 
-	bfqq = bfq_init_rq(rq);
 	if (!bfqq || at_head) {
 		if (at_head)
 			list_add(&rq->queuelist, &bfqd->dispatch);
-- 
2.34.1

