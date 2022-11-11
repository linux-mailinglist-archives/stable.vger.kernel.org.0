Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF52625063
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiKKCfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbiKKCeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:34:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5276567125;
        Thu, 10 Nov 2022 18:34:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E61F961E87;
        Fri, 11 Nov 2022 02:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD91C43143;
        Fri, 11 Nov 2022 02:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134046;
        bh=uKIU1CJtuWD1BtfjIRTB7YVoax7aTeNSNtkCVCL5NYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlVwVg4k+hM7J3gA8+1rQqKzkBRMZ6ynelNCiEFGhEX0a8ZlZphkPA5IzpDdnfguH
         vCYVZU1v14591Rg0+0SLHUyVxvzyj+D0gFbIqrHlB/mz5dCk3a/0veug/Jjrm8QRiy
         nuC+a/b5DYW6Ue2iXivw4RDuarob1w/9l1qx4vbYurtnsXFMEqL2zkqlFyifNJIc7X
         0SvHqa+TAV42o87svbYUu7e/ZeQpVRaeKCSbf8pkqqaep5gJJSUoiSqRGeBGfZTjp+
         a2gc/ybw/zEuXF6ZPwy6fx97v0poOiNQ+UNrwCK24LiZeN5asIUM3gCH0dOgWdEKyK
         ZQaoY/iGG4GuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        ldewangan@nvidia.com, thierry.reding@gmail.com,
        jonathanh@nvidia.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 6.0 14/30] i2c: tegra: Allocate DMA memory for DMA engine
Date:   Thu, 10 Nov 2022 21:33:22 -0500
Message-Id: <20221111023340.227279-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit cdbf26251d3b35c4ccaea0c3a6de4318f727d3d2 ]

When the I2C controllers are running in DMA mode, it is the DMA engine
that performs the memory accesses rather than the I2C controller. Pass
the DMA engine's struct device pointer to the DMA API to make sure the
correct DMA operations are used.

This fixes an issue where the DMA engine's SMMU stream ID needs to be
misleadingly set for the I2C controllers in device tree.

Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 031c78ac42e6..a24cc413c89b 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -284,6 +284,7 @@ struct tegra_i2c_dev {
 	struct dma_chan *tx_dma_chan;
 	struct dma_chan *rx_dma_chan;
 	unsigned int dma_buf_size;
+	struct device *dma_dev;
 	dma_addr_t dma_phys;
 	void *dma_buf;
 
@@ -420,7 +421,7 @@ static int tegra_i2c_dma_submit(struct tegra_i2c_dev *i2c_dev, size_t len)
 static void tegra_i2c_release_dma(struct tegra_i2c_dev *i2c_dev)
 {
 	if (i2c_dev->dma_buf) {
-		dma_free_coherent(i2c_dev->dev, i2c_dev->dma_buf_size,
+		dma_free_coherent(i2c_dev->dma_dev, i2c_dev->dma_buf_size,
 				  i2c_dev->dma_buf, i2c_dev->dma_phys);
 		i2c_dev->dma_buf = NULL;
 	}
@@ -467,10 +468,13 @@ static int tegra_i2c_init_dma(struct tegra_i2c_dev *i2c_dev)
 
 	i2c_dev->tx_dma_chan = chan;
 
+	WARN_ON(i2c_dev->tx_dma_chan->device != i2c_dev->rx_dma_chan->device);
+	i2c_dev->dma_dev = chan->device->dev;
+
 	i2c_dev->dma_buf_size = i2c_dev->hw->quirks->max_write_len +
 				I2C_PACKET_HEADER_SIZE;
 
-	dma_buf = dma_alloc_coherent(i2c_dev->dev, i2c_dev->dma_buf_size,
+	dma_buf = dma_alloc_coherent(i2c_dev->dma_dev, i2c_dev->dma_buf_size,
 				     &dma_phys, GFP_KERNEL | __GFP_NOWARN);
 	if (!dma_buf) {
 		dev_err(i2c_dev->dev, "failed to allocate DMA buffer\n");
@@ -1267,7 +1271,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 
 	if (i2c_dev->dma_mode) {
 		if (i2c_dev->msg_read) {
-			dma_sync_single_for_device(i2c_dev->dev,
+			dma_sync_single_for_device(i2c_dev->dma_dev,
 						   i2c_dev->dma_phys,
 						   xfer_size, DMA_FROM_DEVICE);
 
@@ -1275,7 +1279,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 			if (err)
 				return err;
 		} else {
-			dma_sync_single_for_cpu(i2c_dev->dev,
+			dma_sync_single_for_cpu(i2c_dev->dma_dev,
 						i2c_dev->dma_phys,
 						xfer_size, DMA_TO_DEVICE);
 		}
@@ -1288,7 +1292,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 			memcpy(i2c_dev->dma_buf + I2C_PACKET_HEADER_SIZE,
 			       msg->buf, msg->len);
 
-			dma_sync_single_for_device(i2c_dev->dev,
+			dma_sync_single_for_device(i2c_dev->dma_dev,
 						   i2c_dev->dma_phys,
 						   xfer_size, DMA_TO_DEVICE);
 
@@ -1339,7 +1343,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 		}
 
 		if (i2c_dev->msg_read && i2c_dev->msg_err == I2C_ERR_NONE) {
-			dma_sync_single_for_cpu(i2c_dev->dev,
+			dma_sync_single_for_cpu(i2c_dev->dma_dev,
 						i2c_dev->dma_phys,
 						xfer_size, DMA_FROM_DEVICE);
 
-- 
2.35.1

