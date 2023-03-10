Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2661D6B46C1
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbjCJOqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbjCJOp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:45:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF68120E84
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:45:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23B64B822AD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5394DC4339B;
        Fri, 10 Mar 2023 14:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459552;
        bh=oLY7hPbCis5K26plMTC8JwfPXXOtOyEaDl+eMWbdJHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWPUr5Y/zcil3h3dJVasHYwxi6KuBTutyi0mD//YtRCUJiSs9CgzjioKT3Y2a/l/6
         FiabPGnr5Dh8jrXQrcwds5sMMuCepq59cLfYg/awIsL8GHgbWi0QL2r1pvJGYi1WhA
         ZknCivaxT8rBa0WB0FFarR5dU5zOB6GZf7SFVx70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/529] blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx
Date:   Fri, 10 Mar 2023 14:33:04 +0100
Message-Id: <20230310133806.884082559@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index 72e64ba661fc7..862acb5a84523 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -45,8 +45,7 @@ void blk_mq_sched_assign_ioc(struct request *rq)
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



