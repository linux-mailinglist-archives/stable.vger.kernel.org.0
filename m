Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8895E6AEDF3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjCGSId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCGSIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:08:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D09AFB88
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:02:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2286B6150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D407C433EF;
        Tue,  7 Mar 2023 18:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212132;
        bh=xgtWi96OauJmz4ApKH2SacDz/uEdnespMY6QEWNjH+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szk3lX0AwPCtFBqGsHv+zln1MYKv9wV+Z5Hi862X6OmXX4QTeomNGWAP/pJHLbqdM
         q9pN7n2h88WV1tdM5H9XuRVeLVfIIYXgKGqd8h7QoDkXQLitQ1xRLiArqjAHVqOLOP
         fE5k2PW0kKITFv8G9WcM/i97Chr61WqO6VCMlw1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kemeng Shi <shikemeng@huaweicloud.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/885] blk-mq: Fix potential io hung for shared sbitmap per tagset
Date:   Tue,  7 Mar 2023 17:50:22 +0100
Message-Id: <20230307170005.639584382@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 47df9ce95cd568d3f84218c4f65e9fbd4dfeda55 ]

Commit f906a6a0f4268 ("blk-mq: improve tag waiting setup for non-shared
tags") mark restart for unshared tags for improvement. At that time,
tags is only shared betweens queues and we can check if tags is shared
by test BLK_MQ_F_TAG_SHARED.
Afterwards, commit 32bc15afed04b ("blk-mq: Facilitate a shared sbitmap per
tagset") enabled tags share betweens hctxs inside a queue. We only
mark restart for shared hctxs inside a queue and may cause io hung if
there is no tag currently allocated by hctxs going to be marked restart.
Wait on sbitmap_queue instead of mark restart for shared hctxs case to
fix this.

Fixes: 32bc15afed04 ("blk-mq: Facilitate a shared sbitmap per tagset")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index faffc64fe4ce8..fe0a3a882f465 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1799,7 +1799,8 @@ static bool blk_mq_mark_tag_wait(struct blk_mq_hw_ctx *hctx,
 	wait_queue_entry_t *wait;
 	bool ret;
 
-	if (!(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)) {
+	if (!(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) &&
+	    !(blk_mq_is_shared_tags(hctx->flags))) {
 		blk_mq_sched_mark_restart_hctx(hctx);
 
 		/*
@@ -2069,7 +2070,8 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 		bool needs_restart;
 		/* For non-shared tags, the RESTART check will suffice */
 		bool no_tag = prep == PREP_DISPATCH_NO_TAG &&
-			(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED);
+			((hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) ||
+			blk_mq_is_shared_tags(hctx->flags));
 
 		if (nr_budgets)
 			blk_mq_release_budgets(q, list);
-- 
2.39.2



