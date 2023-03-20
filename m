Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FFB6C18B4
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbjCTP0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbjCTP0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:26:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B8C31E20
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:19:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91E7EB80EC5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D473DC433D2;
        Mon, 20 Mar 2023 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325537;
        bh=K/d7B1d5nJmC3yZ09eO/+KaCt5Sa6DnyLc22sCCMx/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Db06j/f1s+4BfE1tDMgqpLJdqBM9+4hc9hIUlaiyICVOHDeLGc30ZHEgazSZDixTm
         pn8RaLlinVazwVPYTNrRjKcCbwngtkBocF+VNrhGcOJJ84wZgYZZHSJ2huOBCQui0E
         QiLP6VenKNQ9NmvLUrOrcGs7s/9xUsaVefOfuWJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marco Patalano <mpatalan@redhat.com>,
        Chris Leech <cleech@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 054/211] blk-mq: fix "bad unlock balance detected" on q->srcu in __blk_mq_run_dispatch_ops
Date:   Mon, 20 Mar 2023 15:53:09 +0100
Message-Id: <20230320145515.504413292@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



