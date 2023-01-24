Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715E46799EC
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbjAXNnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbjAXNm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:42:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA33146148;
        Tue, 24 Jan 2023 05:42:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C46961050;
        Tue, 24 Jan 2023 13:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10626C433EF;
        Tue, 24 Jan 2023 13:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567744;
        bh=ptS80CaKmAaxnVgO5uFtYCDNS250QnOe4rrGaZZzuYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyo8uSvZRQ6kWIeWKE4ERRPhX/O1KXCU3i1wST1hDl/3wt9UD8N5X7qT8CkGhkr/p
         ot0cMRkZ70jTjecgKpfLAta88CjCI7xTfDs3TEhzMsz2BRMfQXEliSH1r2S+gkjRra
         VZaaI1pTpcAb5HQtWmauD+UPHkXazXzJDfbwJeD2eJIrTV6NpFqu6PycUtc95tRn6C
         nU4AQzmXZTYCbFOH/uPdJO/ryHhVzJg43Dn9V3cDUPKGnqNqa5D3j/D+oaITmFY8ak
         Q0Pj233Nysq6cGuNEaKwxqYFJTJL07RGHrVu9W2noKEwPYVrRlACs7yVM9KHLjsGxv
         2lUJh4KKjV+kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 19/35] block: fix hctx checks for batch allocation
Date:   Tue, 24 Jan 2023 08:41:15 -0500
Message-Id: <20230124134131.637036-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 7746564793978fe2f43b18a302b22dca0ad3a0e8 ]

When there are no read queues read requests will be assigned a
default queue on allocation. However, blk_mq_get_cached_request() is not
prepared for that and will fail all attempts to grab read requests from
the cache. Worst case it doubles the number of requests allocated,
roughly half of which will be returned by blk_mq_free_plug_rqs().

It only affects batched allocations and so is io_uring specific.
For reference, QD8 t/io_uring benchmark improves by 20-35%.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/80d4511011d7d4751b4cf6375c4e38f237d935e3.1673955390.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 63abbe342b28..83fbc7c54617 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2858,6 +2858,7 @@ static inline struct request *blk_mq_get_cached_request(struct request_queue *q,
 		struct blk_plug *plug, struct bio **bio, unsigned int nsegs)
 {
 	struct request *rq;
+	enum hctx_type type, hctx_type;
 
 	if (!plug)
 		return NULL;
@@ -2870,7 +2871,10 @@ static inline struct request *blk_mq_get_cached_request(struct request_queue *q,
 		return NULL;
 	}
 
-	if (blk_mq_get_hctx_type((*bio)->bi_opf) != rq->mq_hctx->type)
+	type = blk_mq_get_hctx_type((*bio)->bi_opf);
+	hctx_type = rq->mq_hctx->type;
+	if (type != hctx_type &&
+	    !(type == HCTX_TYPE_READ && hctx_type == HCTX_TYPE_DEFAULT))
 		return NULL;
 	if (op_is_flush(rq->cmd_flags) != op_is_flush((*bio)->bi_opf))
 		return NULL;
-- 
2.39.0

