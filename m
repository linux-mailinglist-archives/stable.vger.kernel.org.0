Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19E86AEDF2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbjCGSIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjCGSIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:08:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25389AFB85
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:02:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3E3EB8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B630C4339C;
        Tue,  7 Mar 2023 18:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212129;
        bh=vtW6lQsvubAYIdtMeItCiTV47bl8+16JPge962Tixmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vesd0TQa7eEYGJM39nW5G9UEq5WIzehQXvMklajHt4X1osYBNsy7nOkYMwjreQHbL
         cP1hpzDvl+I/5W0RX0MSRKP9FXZIQIKlpWJXDSwQAtVRzMJuAqvYr+FGUcLT+keisd
         iWg+5yDBIo0ey9BvZkIRVUU1KZkAyvjKswRpbq4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/885] blk-mq: wait on correct sbitmap_queue in blk_mq_mark_tag_wait
Date:   Tue,  7 Mar 2023 17:50:21 +0100
Message-Id: <20230307170005.596885765@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 98b99e9412d0cde8c7b442bf5efb09528a2ede8b ]

For shared queues case, we will only wait on bitmap_tags if we fail to get
driver tag. However, rq could be from breserved_tags, then two problems
will occur:
1. io hung if no tag is currently allocated from bitmap_tags.
2. unnecessary wakeup when tag is freed to bitmap_tags while no tag is
freed to breserved_tags.
Wait on the bitmap which rq from to fix this.

Fixes: f906a6a0f426 ("blk-mq: improve tag waiting setup for non-shared tags")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2983ace812667..faffc64fe4ce8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1794,7 +1794,7 @@ static int blk_mq_dispatch_wake(wait_queue_entry_t *wait, unsigned mode,
 static bool blk_mq_mark_tag_wait(struct blk_mq_hw_ctx *hctx,
 				 struct request *rq)
 {
-	struct sbitmap_queue *sbq = &hctx->tags->bitmap_tags;
+	struct sbitmap_queue *sbq;
 	struct wait_queue_head *wq;
 	wait_queue_entry_t *wait;
 	bool ret;
@@ -1817,6 +1817,10 @@ static bool blk_mq_mark_tag_wait(struct blk_mq_hw_ctx *hctx,
 	if (!list_empty_careful(&wait->entry))
 		return false;
 
+	if (blk_mq_tag_is_reserved(rq->mq_hctx->sched_tags, rq->internal_tag))
+		sbq = &hctx->tags->breserved_tags;
+	else
+		sbq = &hctx->tags->bitmap_tags;
 	wq = &bt_wait_ptr(sbq, hctx)->wait;
 
 	spin_lock_irq(&wq->lock);
-- 
2.39.2



