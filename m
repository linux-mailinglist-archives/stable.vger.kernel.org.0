Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BF45490CC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356157AbiFMM5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358328AbiFMMzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB8810B5;
        Mon, 13 Jun 2022 04:15:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07889B80EA8;
        Mon, 13 Jun 2022 11:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63181C34114;
        Mon, 13 Jun 2022 11:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118901;
        bh=pKTkQpAxxNavDjMDwqRVRqBtgxLQrruyZOCEmjU4QY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHQ38Bzte6eqxIGJIiqJsmR4R9BgQJe6nRo0kLBjOowq4WDQ9bn/MA9S+VFyFFHG2
         5Y0dCRHcb3TfojLuNZMLF6+brO1wl48RA6EJ6NQ/8WvBYPoXNpym2tDfrm7+7cMqUx
         hbBv1QgrGlpfMRJtQAYaDrR2juyyZ97QnnKgU+d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/247] blk-mq: dont touch ->tagset in blk_mq_get_sq_hctx
Date:   Mon, 13 Jun 2022 12:09:30 +0200
Message-Id: <20220613094925.020722924@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 5d05426e2d5fd7df8afc866b78c36b37b00188b7 ]

blk_mq_run_hw_queues() could be run when there isn't queued request and
after queue is cleaned up, at that time tagset is freed, because tagset
lifetime is covered by driver, and often freed after blk_cleanup_queue()
returns.

So don't touch ->tagset for figuring out current default hctx by the mapping
built in request queue, so use-after-free on tagset can be avoided. Meantime
this way should be fast than retrieving mapping from tagset.

Cc: "yukuai (C)" <yukuai3@huawei.com>
Cc: Jan Kara <jack@suse.cz>
Fixes: b6e68ee82585 ("blk-mq: Improve performance of non-mq IO schedulers with multiple HW queues")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220522122350.743103-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 82de39926a9f..b70488e4db94 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1642,8 +1642,7 @@ static bool blk_mq_has_sqsched(struct request_queue *q)
  */
 static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(struct request_queue *q)
 {
-	struct blk_mq_hw_ctx *hctx;
-
+	struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
 	/*
 	 * If the IO scheduler does not respect hardware queues when
 	 * dispatching, we just don't bother with multiple HW queues and
@@ -1651,8 +1650,8 @@ static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(struct request_queue *q)
 	 * just causes lock contention inside the scheduler and pointless cache
 	 * bouncing.
 	 */
-	hctx = blk_mq_map_queue_type(q, HCTX_TYPE_DEFAULT,
-				     raw_smp_processor_id());
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, 0, ctx);
+
 	if (!blk_mq_hctx_stopped(hctx))
 		return hctx;
 	return NULL;
-- 
2.35.1



