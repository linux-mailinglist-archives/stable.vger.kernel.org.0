Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F026D495E
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbjDCOhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbjDCOhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:37:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCA51765B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 647E961E7B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D7BC433D2;
        Mon,  3 Apr 2023 14:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532617;
        bh=K/d7B1d5nJmC3yZ09eO/+KaCt5Sa6DnyLc22sCCMx/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZwXGGKjRvpO8IBiRQFBT0Cu289X034LhPpJKAA4l6YY590cdgRevmoj928Gxr+iR
         rpG4xDePbuIajOu26lDV3Pr3Oz/J9Te2scgiJzqKBRnHYbKWIUanNsbhyIxi8UoZJo
         iQxWCjnwuVqkW/QTPQO4YS/M63qv4FmlFOUo3A40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marco Patalano <mpatalan@redhat.com>,
        Chris Leech <cleech@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/181] blk-mq: fix "bad unlock balance detected" on q->srcu in __blk_mq_run_dispatch_ops
Date:   Mon,  3 Apr 2023 16:07:37 +0200
Message-Id: <20230403140415.869808922@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Leech <cleech@redhat.com>

[ Upstream commit 00e885efcfbb8712d3e1bfc1ae30639c15ca1d3b ]

The 'q' parameter of the macro __blk_mq_run_dispatch_ops may not be one
local variable, such as, it is rq->q, then request queue pointed by
this variable could be changed to another queue in case of
BLK_MQ_F_TAG_QUEUE_SHARED after 'dispatch_ops' returns, then
'bad unlock balance' is triggered.

Fixes the issue by adding one local variable for doing srcu lock/unlock.

Fixes: 2a904d00855f ("blk-mq: remove hctx_lock and hctx_unlock")
Cc: Marco Patalano <mpatalan@redhat.com>
Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230310010913.1014789-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.h b/block/blk-mq.h
index ef59fee62780d..a7482d2cc82e7 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -378,12 +378,13 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 #define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops)	\
 do {								\
 	if ((q)->tag_set->flags & BLK_MQ_F_BLOCKING) {		\
+		struct blk_mq_tag_set *__tag_set = (q)->tag_set; \
 		int srcu_idx;					\
 								\
 		might_sleep_if(check_sleep);			\
-		srcu_idx = srcu_read_lock((q)->tag_set->srcu);	\
+		srcu_idx = srcu_read_lock(__tag_set->srcu);	\
 		(dispatch_ops);					\
-		srcu_read_unlock((q)->tag_set->srcu, srcu_idx);	\
+		srcu_read_unlock(__tag_set->srcu, srcu_idx);	\
 	} else {						\
 		rcu_read_lock();				\
 		(dispatch_ops);					\
-- 
2.39.2



