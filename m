Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7942689592
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbjBCKWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbjBCKWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:22:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1B19E9C0
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:22:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9832B61ECC
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C83BC433D2;
        Fri,  3 Feb 2023 10:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419724;
        bh=ptS80CaKmAaxnVgO5uFtYCDNS250QnOe4rrGaZZzuYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AF9MkOYUlx66ovC/y9VqkrcfCiB8IrwORDj0fVAF8BoNYU1q4mhKkWPuL6yeQ3i/p
         lH5kIdVzRAb9fDWFMDZMksryfo/p9H+T+JjXjmY26DClFnNUylF9ad7JcoyDeqnD6Z
         iptk2MGI0JSzSIgmk951+4Hsz3HL/dRDDXXfKGbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/28] block: fix hctx checks for batch allocation
Date:   Fri,  3 Feb 2023 11:13:04 +0100
Message-Id: <20230203101010.657044513@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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



