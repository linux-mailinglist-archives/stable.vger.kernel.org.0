Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B2E6AF340
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbjCGTCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjCGTCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:02:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CC0AB8BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:48:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7849B819CA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34492C433EF;
        Tue,  7 Mar 2023 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214901;
        bh=hEmoMWYBUXEAyYEiPiREgit81uMbxcLhiQJnlKujpvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVF+4TC5DavCtB0QVkwrINRSURJ7mEH0WqCkqMVKNsMSGOHk/U2lps06L2lgCJi8z
         cEfRdhRT2pXmZpK/DLIwj1fHapzNBBDlhMQb+H3ThVfylixwBgmAfU/dj8bRnXQRkH
         okX9mh/KU62KxSdmN0Uf4OLvVgyNJZkXGTQoUE4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kemeng Shi <shikemeng@huaweicloud.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/567] blk-mq: correct stale comment of .get_budget
Date:   Tue,  7 Mar 2023 17:56:32 +0100
Message-Id: <20230307165908.342377186@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index de45a28925d83..ff1021dbb0d22 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -109,7 +109,7 @@ static bool blk_mq_dispatch_hctx_list(struct list_head *rq_list)
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
- * restart queue if .get_budget() returns BLK_STS_NO_RESOURCE.
+ * restart queue if .get_budget() fails to get the budget.
  *
  * Returns -EAGAIN if hctx->dispatch was found non-empty and run_work has to
  * be run again.  This is necessary to avoid starving flushes.
@@ -237,7 +237,7 @@ static struct blk_mq_ctx *blk_mq_next_ctx(struct blk_mq_hw_ctx *hctx,
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
- * restart queue if .get_budget() returns BLK_STS_NO_RESOURCE.
+ * restart queue if .get_budget() fails to get the budget.
  *
  * Returns -EAGAIN if hctx->dispatch was found non-empty and run_work has to
  * be run again.  This is necessary to avoid starving flushes.
-- 
2.39.2



