Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0782592109
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240602AbiHNPcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239597AbiHNPcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:32:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E7F1ADA4;
        Sun, 14 Aug 2022 08:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B58DD60C0B;
        Sun, 14 Aug 2022 15:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C38C433C1;
        Sun, 14 Aug 2022 15:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490994;
        bh=/EAzLTw2LDeTTq+gH0iIZMFAkA3J3B3MG6b3v5PKd8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r63qp95N/c4gsRykwxvp9MnvQXPGzaZ63CdzEaiJ05gsN4QFdynGywpQ1s8CiNtlj
         aApf3tbve+J6QHEEWcMMzCC6GzkwRilGxIkZyU8p1YG4ni5wB9jLnhguFIhj9+nTyb
         QcSFSbDmrtP7NRlx6uTtBusJT3fktPMv4MWjg1cBjNy4+gYDaAvGxcmtTRIOM1NegI
         10JD/l5K9QLgY+TZ2q64lQYq4VEJT/1O/H7HonpnNITt2Gi+V25GxDlslM1ViSjnt6
         H82h+9jmplrINaHAnTnWAadfRNRHv3mTc4b4/FGCeXCoUYblDtzdOqiMidcXewkxZ8
         JGQcfSaa5WL+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akhil R <akhilrajeev@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        ldewangan@nvidia.com, thierry.reding@gmail.com,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 51/64] dmaengine: tegra: Add terminate() for Tegra234
Date:   Sun, 14 Aug 2022 11:24:24 -0400
Message-Id: <20220814152437.2374207-51-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit 36834c67016794b8fa03d7672a5b7f2cc4529298 ]

In certain cases where the DMA client bus gets corrupted or if the
end device ceases to send/receive data, DMA can wait indefinitely
for the data to be received/sent. Attempting to terminate the transfer
will put the DMA in pause flush mode and it remains there.

The channel is irrecoverable once this pause times out in Tegra194 and
earlier chips. Whereas, from Tegra234, it can be recovered by disabling
the channel and reprograming it.

Hence add a new terminate() function that ignores the outcome of
dma_pause() so that terminate_all() can proceed to disable the channel.

Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20220720104045.16099-3-akhilrajeev@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra186-gpc-dma.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/tegra186-gpc-dma.c b/drivers/dma/tegra186-gpc-dma.c
index 05cd451f541d..fa9bda4a2bc6 100644
--- a/drivers/dma/tegra186-gpc-dma.c
+++ b/drivers/dma/tegra186-gpc-dma.c
@@ -157,8 +157,8 @@
  * If any burst is in flight and DMA paused then this is the time to complete
  * on-flight burst and update DMA status register.
  */
-#define TEGRA_GPCDMA_BURST_COMPLETE_TIME	20
-#define TEGRA_GPCDMA_BURST_COMPLETION_TIMEOUT	100
+#define TEGRA_GPCDMA_BURST_COMPLETE_TIME	10
+#define TEGRA_GPCDMA_BURST_COMPLETION_TIMEOUT	5000 /* 5 msec */
 
 /* Channel base address offset from GPCDMA base address */
 #define TEGRA_GPCDMA_CHANNEL_BASE_ADD_OFFSET	0x20000
@@ -432,6 +432,17 @@ static int tegra_dma_device_resume(struct dma_chan *dc)
 	return 0;
 }
 
+static inline int tegra_dma_pause_noerr(struct tegra_dma_channel *tdc)
+{
+	/* Return 0 irrespective of PAUSE status.
+	 * This is useful to recover channels that can exit out of flush
+	 * state when the channel is disabled.
+	 */
+
+	tegra_dma_pause(tdc);
+	return 0;
+}
+
 static void tegra_dma_disable(struct tegra_dma_channel *tdc)
 {
 	u32 csr, status;
@@ -1292,6 +1303,14 @@ static const struct tegra_dma_chip_data tegra194_dma_chip_data = {
 	.terminate = tegra_dma_pause,
 };
 
+static const struct tegra_dma_chip_data tegra234_dma_chip_data = {
+	.nr_channels = 31,
+	.channel_reg_size = SZ_64K,
+	.max_dma_count = SZ_1G,
+	.hw_support_pause = true,
+	.terminate = tegra_dma_pause_noerr,
+};
+
 static const struct of_device_id tegra_dma_of_match[] = {
 	{
 		.compatible = "nvidia,tegra186-gpcdma",
@@ -1299,6 +1318,9 @@ static const struct of_device_id tegra_dma_of_match[] = {
 	}, {
 		.compatible = "nvidia,tegra194-gpcdma",
 		.data = &tegra194_dma_chip_data,
+	}, {
+		.compatible = "nvidia,tegra234-gpcdma",
+		.data = &tegra234_dma_chip_data,
 	}, {
 	},
 };
-- 
2.35.1

