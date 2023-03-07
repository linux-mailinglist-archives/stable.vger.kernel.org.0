Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA536AEE26
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjCGSKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbjCGSJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD6898875
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:03:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E77EB8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FE1C433EF;
        Tue,  7 Mar 2023 18:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212222;
        bh=ENLdNDxHKZgRxjiXGQB68f8Wvr4nYrt6LVehWIILZac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijPdVvo+Jw4mVboH4Z/6JR/ZBw0FNCDqluU3yMiu3CIxtYuqkgB+1qXafM3GDRuoB
         A9muFGxLQow/LrPp5vjeC+O6i0/lPsQ2NIR8qoEkTa3SGWY3Nf8S8nUCIiFUC2AZsX
         LEpD6viLYSWjbM+4j4fz7/Na5J8kOgFl58TjsDD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/885] blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx
Date:   Tue,  7 Mar 2023 17:50:20 +0100
Message-Id: <20230307170005.555447827@linuxfoundation.org>
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
index a4f7c101b53b2..176704a0e4da4 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -19,8 +19,7 @@
 #include "blk-wbt.h"
 
 /*
- * Mark a hardware queue as needing a restart. For shared queues, maintain
- * a count of how many hardware queues are marked for restart.
+ * Mark a hardware queue as needing a restart.
  */
 void blk_mq_sched_mark_restart_hctx(struct blk_mq_hw_ctx *hctx)
 {
-- 
2.39.2



