Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212BB55C8F4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbiF0LtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238479AbiF0Lsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35E5101CC;
        Mon, 27 Jun 2022 04:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D82CB81144;
        Mon, 27 Jun 2022 11:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00658C3411D;
        Mon, 27 Jun 2022 11:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330104;
        bh=kCwdNzqMem6ihDmySz6U2kWUQrGOpG+87jgLRiwTaSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bn94/jzRm2jBhbEGf4eAAORjvJOssJ3MnWqOQqEOnUMzxRZwX1n8XLW+TRiHHYSrJ
         TPvJ4fwCQGsFCPUrFb7fzPSvYOI/cT4DUW/YzibAe9tM/GfjXeIhMQ6bfkRN3pMD6m
         JoMjx2/HYT297asB53+ncrcJzJZa9e8HFDb7vE8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 084/181] block: pop cached rq before potentially blocking rq_qos_throttle()
Date:   Mon, 27 Jun 2022 13:20:57 +0200
Message-Id: <20220627111946.996652252@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 2645672ffe21f0a1c139bfbc05ad30fd4e4f2583 ]

If rq_qos_throttle() ends up blocking, then we will have invalidated and
flushed our current plug. Since blk_mq_get_cached_request() hasn't
popped the cached request off the plug list just yet, we end holding a
pointer to a request that is no longer valid. This insta-crashes with
rq->mq_hctx being NULL in the validity checks just after.

Pop the request off the cached list before doing rq_qos_throttle() to
avoid using a potentially stale request.

Fixes: 0a5aa8d161d1 ("block: fix blk_mq_attempt_bio_merge and rq_qos_throttle protection")
Reported-by: Dylan Yudaken <dylany@fb.com>
Tested-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 631fb87b4976..37caa73bff89 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2777,15 +2777,20 @@ static inline struct request *blk_mq_get_cached_request(struct request_queue *q,
 		return NULL;
 	}
 
-	rq_qos_throttle(q, *bio);
-
 	if (blk_mq_get_hctx_type((*bio)->bi_opf) != rq->mq_hctx->type)
 		return NULL;
 	if (op_is_flush(rq->cmd_flags) != op_is_flush((*bio)->bi_opf))
 		return NULL;
 
-	rq->cmd_flags = (*bio)->bi_opf;
+	/*
+	 * If any qos ->throttle() end up blocking, we will have flushed the
+	 * plug and hence killed the cached_rq list as well. Pop this entry
+	 * before we throttle.
+	 */
 	plug->cached_rq = rq_list_next(rq);
+	rq_qos_throttle(q, *bio);
+
+	rq->cmd_flags = (*bio)->bi_opf;
 	INIT_LIST_HEAD(&rq->queuelist);
 	return rq;
 }
-- 
2.35.1



