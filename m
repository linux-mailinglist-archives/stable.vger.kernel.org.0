Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32626B4398
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjCJOQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjCJOPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:15:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F96311A999
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:14:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8609617CF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A43C433EF;
        Fri, 10 Mar 2023 14:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457671;
        bh=MzHVV2SAdIaosX4r2iT03klKd05bYP278kyQ9k4Ngwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdNQFkV6Uyb2IXhAL0LJalFlhJpFg1oDvYQBWe9ZB79BtBPGB/877xbpdsOy5YfAy
         t3Gn5PnOuWye5mSu+uiSZAldgVM5ZVBJeeJ/iHYTxPmPPqAH4tDD7ql5BKxjyEKIfn
         btn5cfOwmBoDjo83F1ftoZZ87NXddr0fJojrDRwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/252] blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx
Date:   Fri, 10 Mar 2023 14:36:28 +0100
Message-Id: <20230310133719.378845457@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

[ Upstream commit c31e76bcc379182fe67a82c618493b7b8868c672 ]

Commit 97889f9ac24f8 ("blk-mq: remove synchronize_rcu() from
blk_mq_del_queue_tag_set()") remove handle of TAG_SHARED in restart,
then shared_hctx_restart counted for how many hardware queues are marked
for restart is removed too.
Remove the stale comment that we still count hardware queues need restart.

Fixes: 97889f9ac24f ("blk-mq: remove synchronize_rcu() from blk_mq_del_queue_tag_set()")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index d89a757cbde0f..dfa0a21a1fe46 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -51,8 +51,7 @@ void blk_mq_sched_assign_ioc(struct request *rq, struct bio *bio)
 }
 
 /*
- * Mark a hardware queue as needing a restart. For shared queues, maintain
- * a count of how many hardware queues are marked for restart.
+ * Mark a hardware queue as needing a restart.
  */
 void blk_mq_sched_mark_restart_hctx(struct blk_mq_hw_ctx *hctx)
 {
-- 
2.39.2



