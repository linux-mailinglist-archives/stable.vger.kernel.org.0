Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFD860ABF5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbiJXN7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237067AbiJXN7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:59:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6908C002;
        Mon, 24 Oct 2022 05:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACCB8612B3;
        Mon, 24 Oct 2022 12:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B7EC433C1;
        Mon, 24 Oct 2022 12:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615597;
        bh=jggFdXoYPgsmJa9ZXLL1sfM4l5+1zveb2heyzFPoVHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebSBJLyexLfwmKBfPDJWqiYGxeWWQMfovxmCqV8pzneJQMgtwf9YTF2zlMVjogAEx
         8dUCNgVHBj4Fu9YikLOIU65MXjufmrdepVQInDVZPg3v6gjmiDDs6yFFgeNyx6EIUM
         WizmtImyojSVsh2vTkDDllb6nOrFeYhiX21/TEcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Hai <haijie1@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 294/530] dmaengine: hisilicon: Disable channels when unregister hisi_dma
Date:   Mon, 24 Oct 2022 13:30:38 +0200
Message-Id: <20221024113058.376538032@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Hai <haijie1@huawei.com>

[ Upstream commit e3bdaa04ada31f46d0586df83a2789b8913053c5 ]

When hisi_dma is unloaded or unbinded, all of channels should be
disabled. This patch disables DMA channels when driver is unloaded
or unbinded.

Fixes: e9f08b65250d ("dmaengine: hisilicon: Add Kunpeng DMA engine support")
Signed-off-by: Jie Hai <haijie1@huawei.com>
Acked-by: Zhou Wang <wangzhou1@hisilicon.com>
Link: https://lore.kernel.org/r/20220830062251.52993-2-haijie1@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/hisi_dma.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/hisi_dma.c b/drivers/dma/hisi_dma.c
index f680e9b40bf7..70a0d784a6a3 100644
--- a/drivers/dma/hisi_dma.c
+++ b/drivers/dma/hisi_dma.c
@@ -180,7 +180,8 @@ static void hisi_dma_reset_qp_point(struct hisi_dma_dev *hdma_dev, u32 index)
 	hisi_dma_chan_write(hdma_dev->base, HISI_DMA_CQ_HEAD_PTR, index, 0);
 }
 
-static void hisi_dma_reset_hw_chan(struct hisi_dma_chan *chan)
+static void hisi_dma_reset_or_disable_hw_chan(struct hisi_dma_chan *chan,
+					      bool disable)
 {
 	struct hisi_dma_dev *hdma_dev = chan->hdma_dev;
 	u32 index = chan->qp_num, tmp;
@@ -201,8 +202,11 @@ static void hisi_dma_reset_hw_chan(struct hisi_dma_chan *chan)
 	hisi_dma_do_reset(hdma_dev, index);
 	hisi_dma_reset_qp_point(hdma_dev, index);
 	hisi_dma_pause_dma(hdma_dev, index, false);
-	hisi_dma_enable_dma(hdma_dev, index, true);
-	hisi_dma_unmask_irq(hdma_dev, index);
+
+	if (!disable) {
+		hisi_dma_enable_dma(hdma_dev, index, true);
+		hisi_dma_unmask_irq(hdma_dev, index);
+	}
 
 	ret = readl_relaxed_poll_timeout(hdma_dev->base +
 		HISI_DMA_Q_FSM_STS + index * HISI_DMA_OFFSET, tmp,
@@ -218,7 +222,7 @@ static void hisi_dma_free_chan_resources(struct dma_chan *c)
 	struct hisi_dma_chan *chan = to_hisi_dma_chan(c);
 	struct hisi_dma_dev *hdma_dev = chan->hdma_dev;
 
-	hisi_dma_reset_hw_chan(chan);
+	hisi_dma_reset_or_disable_hw_chan(chan, false);
 	vchan_free_chan_resources(&chan->vc);
 
 	memset(chan->sq, 0, sizeof(struct hisi_dma_sqe) * hdma_dev->chan_depth);
@@ -394,7 +398,7 @@ static void hisi_dma_enable_qp(struct hisi_dma_dev *hdma_dev, u32 qp_index)
 
 static void hisi_dma_disable_qp(struct hisi_dma_dev *hdma_dev, u32 qp_index)
 {
-	hisi_dma_reset_hw_chan(&hdma_dev->chan[qp_index]);
+	hisi_dma_reset_or_disable_hw_chan(&hdma_dev->chan[qp_index], true);
 }
 
 static void hisi_dma_enable_qps(struct hisi_dma_dev *hdma_dev)
-- 
2.35.1



