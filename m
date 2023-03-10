Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1F16B44E1
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjCJO33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjCJO3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:29:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32790E387
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:27:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C73D6B822DC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288FAC433EF;
        Fri, 10 Mar 2023 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458436;
        bh=6FLmu30NDWfViyxeenKYP3KtquEMuHX/W7mv26Paiu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sufy8jOMTXAppAfebSPjoG//6mjzBp2FeN2X7LkymXHlYKnDTxMRFVQFTyjE1elsf
         8UCXObzYCyWHWggqHW3MjIRHjfwSE/G9uUari5S/I4u1//Xwi5SZPRpbZ3NZMl15M0
         iCV9brxloEGRVco/jQhAomT3pvWf6lxe075+kWK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kemeng Shi <shikemeng@huaweicloud.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/357] blk-mq: correct stale comment of .get_budget
Date:   Fri, 10 Mar 2023 14:35:15 +0100
Message-Id: <20230310133735.153466052@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

[ Upstream commit 01542f651a9f58a9b176c3d3dc3eefbacee53b78 ]

Commit 88022d7201e96 ("blk-mq: don't handle failure in .get_budget")
remove BLK_STS_RESOURCE return value and we only check if we can get
the budget from .get_budget() now.
Correct stale comment that ".get_budget() returns BLK_STS_NO_RESOURCE"
to ".get_budget() fails to get the budget".

Fixes: 88022d7201e9 ("blk-mq: don't handle failure in .get_budget")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 31d1e7150192e..126a9a6355948 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -91,7 +91,7 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
- * restart queue if .get_budget() returns BLK_STS_NO_RESOURCE.
+ * restart queue if .get_budget() fails to get the budget.
  *
  * Returns -EAGAIN if hctx->dispatch was found non-empty and run_work has to
  * be run again.  This is necessary to avoid starving flushes.
@@ -148,7 +148,7 @@ static struct blk_mq_ctx *blk_mq_next_ctx(struct blk_mq_hw_ctx *hctx,
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
- * restart queue if .get_budget() returns BLK_STS_NO_RESOURCE.
+ * restart queue if .get_budget() fails to get the budget.
  *
  * Returns -EAGAIN if hctx->dispatch was found non-empty and run_work has to
  * to be run again.  This is necessary to avoid starving flushes.
-- 
2.39.2



