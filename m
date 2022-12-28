Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F390A657A23
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiL1PIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiL1PIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:08:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BC813D74
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:08:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A613B61541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF10C433D2;
        Wed, 28 Dec 2022 15:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240092;
        bh=wZRvbsLYcC1yESuPSWlS6s8qClEfnFnUpvgMWWqONMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jg2RWfKkhMw1RfKTNNlvhYxNPSwcSI8BFOFeEFLoCupu7TzWDOhIdX4RgQuNM5Dku
         epdh8U5SqsQ5qFd9S9xsBSck77rbQ91ICPwxex3iyinbQ2d76zksvmrVDishU9QC4p
         GxBl8nl9ZKUpDRn3LxrVz0Vd4iK1hzbNcgOnlRZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/731] memstick/ms_block: Add check for alloc_ordered_workqueue
Date:   Wed, 28 Dec 2022 15:36:55 +0100
Message-Id: <20221228144305.506212078@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 4f431a047a5c8698ed4b67e2760cfbeb5fffb69d ]

As the alloc_ordered_workqueue may return NULL pointer, it should be better
to add check for the return value. Moreover, the msb->io_queue should be
freed if error occurs later.

Fixes: 0ab30494bc4f ("memstick: add support for legacy memorysticks")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20221126012558.34374-1-jiasheng@iscas.ac.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/core/ms_block.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 29a69243cbd0..7619c30b4ee1 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2150,6 +2150,11 @@ static int msb_init_disk(struct memstick_dev *card)
 
 	msb->usage_count = 1;
 	msb->io_queue = alloc_ordered_workqueue("ms_block", WQ_MEM_RECLAIM);
+	if (!msb->io_queue) {
+		rc = -ENOMEM;
+		goto out_cleanup_disk;
+	}
+
 	INIT_WORK(&msb->io_work, msb_io_work);
 	sg_init_table(msb->prealloc_sg, MS_BLOCK_MAX_SEGS+1);
 
@@ -2159,10 +2164,12 @@ static int msb_init_disk(struct memstick_dev *card)
 	msb_start(card);
 	rc = device_add_disk(&card->dev, msb->disk, NULL);
 	if (rc)
-		goto out_cleanup_disk;
+		goto out_destroy_workqueue;
 	dbg("Disk added");
 	return 0;
 
+out_destroy_workqueue:
+	destroy_workqueue(msb->io_queue);
 out_cleanup_disk:
 	blk_cleanup_disk(msb->disk);
 out_free_tag_set:
-- 
2.35.1



