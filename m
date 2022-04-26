Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D910150F60B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345245AbiDZIlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345834AbiDZIjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87924793A4;
        Tue, 26 Apr 2022 01:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18725617D2;
        Tue, 26 Apr 2022 08:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA04C385A4;
        Tue, 26 Apr 2022 08:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961923;
        bh=+2Fi1ILVgr/TXV+c7AXwJyqn3eo8rkvAxRa7kZL1PaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucPp6hqTsWB8LXwXjnryLTcavWFL/9XLVhIr/K7W0Gube+xYeevWOfFlGm9laAn0W
         mvQ/ERMIjbQDNjeDpycZuDWBd/LGky+hgKvSVkRsvQOcD0MD/60qs2AfoTD5dZVUr1
         /EC43FTKm8ND3wvDkpFdQ/4N3PKNagjJQWe6AG8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/86] dmaengine: mediatek:Fix PM usage reference leak of mtk_uart_apdma_alloc_chan_resources
Date:   Tue, 26 Apr 2022 10:20:42 +0200
Message-Id: <20220426081741.617352615@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangqilong <zhangqilong3@huawei.com>

[ Upstream commit 545b2baac89b859180e51215468c05d85ea8465a ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
We fix it:
1) Replacing it with pm_runtime_resume_and_get to keep usage counter
   balanced.
2) Add putting operation before returning error.

Fixes:9135408c3ace4 ("dmaengine: mediatek: Add MediaTek UART APDMA support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220319022142.142709-1-zhangqilong3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mediatek/mtk-uart-apdma.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/mediatek/mtk-uart-apdma.c b/drivers/dma/mediatek/mtk-uart-apdma.c
index 375e7e647df6..a1517ef1f4a0 100644
--- a/drivers/dma/mediatek/mtk-uart-apdma.c
+++ b/drivers/dma/mediatek/mtk-uart-apdma.c
@@ -274,7 +274,7 @@ static int mtk_uart_apdma_alloc_chan_resources(struct dma_chan *chan)
 	unsigned int status;
 	int ret;
 
-	ret = pm_runtime_get_sync(mtkd->ddev.dev);
+	ret = pm_runtime_resume_and_get(mtkd->ddev.dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(chan->device->dev);
 		return ret;
@@ -288,18 +288,21 @@ static int mtk_uart_apdma_alloc_chan_resources(struct dma_chan *chan)
 	ret = readx_poll_timeout(readl, c->base + VFF_EN,
 			  status, !status, 10, 100);
 	if (ret)
-		return ret;
+		goto err_pm;
 
 	ret = request_irq(c->irq, mtk_uart_apdma_irq_handler,
 			  IRQF_TRIGGER_NONE, KBUILD_MODNAME, chan);
 	if (ret < 0) {
 		dev_err(chan->device->dev, "Can't request dma IRQ\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm;
 	}
 
 	if (mtkd->support_33bits)
 		mtk_uart_apdma_write(c, VFF_4G_SUPPORT, VFF_4G_SUPPORT_CLR_B);
 
+err_pm:
+	pm_runtime_put_noidle(mtkd->ddev.dev);
 	return ret;
 }
 
-- 
2.35.1



