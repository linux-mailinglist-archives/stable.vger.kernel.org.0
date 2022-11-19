Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9146563092D
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiKSCLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiKSCLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:11:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8167E2FC25;
        Fri, 18 Nov 2022 18:11:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ADC6B82677;
        Sat, 19 Nov 2022 02:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C227AC43147;
        Sat, 19 Nov 2022 02:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823892;
        bh=TOLqu0LbFYDS5QL1E942g7sbSUH5VdBr7xnwJtZrtr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNNmdzh1RaIpb+JTkTVrV2qTmJHAvSjp5yzhHD4YB0eir8AvnDXa8NMyd+EAC/lOr
         tYJ11cPPAK2AnFUsX4l5jgz6aYwksm4d+6fTa0XFM8sAheCYCO9L3Je67fIXraV75a
         s4aX9a5bTApezcJnxYcqkCMBUEIhR1wX70WPTnBXflz4996eCi8QT1gTKXuWte0lpH
         u4rPt63HsfBe/p/ebzRUEYBTTdbdWutBoPHTwD5uvU0veF+HizYvRT7c9q0MyGm/zB
         LgQYCJP4kE6E0aG3d4sGDMH5957g2OF8kv9LN3EGf3GGN7W4K2o9ahWm2Q6I8cPtfc
         hbUphI5iSxBuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, thierry.reding@gmail.com,
        skomatineni@nvidia.com, ldewangan@nvidia.com,
        linux-tegra@vger.kernel.org, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 04/44] spi: tegra210-quad: Don't initialise DMA if not supported
Date:   Fri, 18 Nov 2022 21:10:44 -0500
Message-Id: <20221119021124.1773699-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
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

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit ae4b3c1252f0fd0951d2f072a02ba46cac8d6c92 ]

The following error messages are observed on boot for Tegra234 ...

 ERR KERN tegra-qspi 3270000.spi: cannot use DMA: -19
 ERR KERN tegra-qspi 3270000.spi: falling back to PIO

Tegra234 does not support DMA for the QSPI and so initialising the DMA
is expected to fail. The above error messages are misleading for devices
that don't support DMA and so fix this by skipping the DMA
initialisation for devices that don't support DMA.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20221026155633.141792-1-jonathanh@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index c89592b21ffc..d66ef7fa592b 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -720,6 +720,9 @@ static int tegra_qspi_start_cpu_based_transfer(struct tegra_qspi *qspi, struct s
 
 static void tegra_qspi_deinit_dma(struct tegra_qspi *tqspi)
 {
+	if (!tqspi->soc_data->has_dma)
+		return;
+
 	if (tqspi->tx_dma_buf) {
 		dma_free_coherent(tqspi->dev, tqspi->dma_buf_size,
 				  tqspi->tx_dma_buf, tqspi->tx_dma_phys);
@@ -750,6 +753,9 @@ static int tegra_qspi_init_dma(struct tegra_qspi *tqspi)
 	u32 *dma_buf;
 	int err;
 
+	if (!tqspi->soc_data->has_dma)
+		return 0;
+
 	dma_chan = dma_request_chan(tqspi->dev, "rx");
 	if (IS_ERR(dma_chan)) {
 		err = PTR_ERR(dma_chan);
-- 
2.35.1

