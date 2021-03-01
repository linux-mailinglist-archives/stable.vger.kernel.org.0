Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3419328EA8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242058AbhCATfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:35:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241864AbhCAT3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF69D65028;
        Mon,  1 Mar 2021 17:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620724;
        bh=frr9Q74IdcFPXnlqXg0YiQVMnua1tYVFcXImVBBl0h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efgfKUNKlMqlzZOBn8b+yMbLFQkIYrFeg2eg85oX8J1SgCD+vqMhk0y4KhtY8kyAs
         eRp3q5YTsMsYx4XxOyWUK5cyafdghI9sPURqvTLwgSFMsq5rQyh6HRqzjhcUZKpdqE
         ZdtM9ShWPYCLn2KRggLIeavIoF9hSMfP92jdDyeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 256/775] ASoC: qcom: Fix typo error in HDMI regmap config callbacks
Date:   Mon,  1 Mar 2021 17:07:04 +0100
Message-Id: <20210301161214.285808997@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>

[ Upstream commit e681b1a6d706b4e54c3847bb822531b4660234f3 ]

Had a typo in lpass platform driver that resulted in crash
during suspend/resume with an HDMI dongle connected.

The regmap read/write/volatile regesters validation callbacks in lpass-cpu
were using MI2S rdma_channels count instead of hdmi_rdma_channels.

This typo error causing to read registers from the regmap beyond the length
of the mapping created by ioremap().

This fix avoids the need for reducing number hdmi_rdma_channels,
which is done in
commit 7dfe20ee92f6 ("ASoC: qcom: Fix number of HDMI RDMA channels on sc7180").
So reverting the same.

Fixes: 7cb37b7bd0d3c ("ASoC: qcom: Add support for lpass hdmi driver")
Signed-off-by: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
Link: https://lore.kernel.org/r/20210202062727.22469-1-srivasam@codeaurora.org
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c    | 8 ++++----
 sound/soc/qcom/lpass-sc7180.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 73ca24c0a08b7..8e5415c9234f1 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -594,7 +594,7 @@ static bool lpass_hdmi_regmap_writeable(struct device *dev, unsigned int reg)
 			return true;
 	}
 
-	for (i = 0; i < v->rdma_channels; ++i) {
+	for (i = 0; i < v->hdmi_rdma_channels; ++i) {
 		if (reg == LPAIF_HDMI_RDMACTL_REG(v, i))
 			return true;
 		if (reg == LPAIF_HDMI_RDMABASE_REG(v, i))
@@ -640,7 +640,7 @@ static bool lpass_hdmi_regmap_readable(struct device *dev, unsigned int reg)
 	if (reg == LPASS_HDMITX_APP_IRQSTAT_REG(v))
 		return true;
 
-	for (i = 0; i < v->rdma_channels; ++i) {
+	for (i = 0; i < v->hdmi_rdma_channels; ++i) {
 		if (reg == LPAIF_HDMI_RDMACTL_REG(v, i))
 			return true;
 		if (reg == LPAIF_HDMI_RDMABASE_REG(v, i))
@@ -667,7 +667,7 @@ static bool lpass_hdmi_regmap_volatile(struct device *dev, unsigned int reg)
 	if (reg == LPASS_HDMI_TX_LEGACY_ADDR(v))
 		return true;
 
-	for (i = 0; i < v->rdma_channels; ++i) {
+	for (i = 0; i < v->hdmi_rdma_channels; ++i) {
 		if (reg == LPAIF_HDMI_RDMACURR_REG(v, i))
 			return true;
 	}
@@ -817,7 +817,7 @@ int asoc_qcom_lpass_cpu_platform_probe(struct platform_device *pdev)
 		}
 
 		lpass_hdmi_regmap_config.max_register = LPAIF_HDMI_RDMAPER_REG(variant,
-					variant->hdmi_rdma_channels);
+					variant->hdmi_rdma_channels - 1);
 		drvdata->hdmiif_map = devm_regmap_init_mmio(dev, drvdata->hdmiif,
 					&lpass_hdmi_regmap_config);
 		if (IS_ERR(drvdata->hdmiif_map)) {
diff --git a/sound/soc/qcom/lpass-sc7180.c b/sound/soc/qcom/lpass-sc7180.c
index 735c9dac28f26..8c168d3c589e9 100644
--- a/sound/soc/qcom/lpass-sc7180.c
+++ b/sound/soc/qcom/lpass-sc7180.c
@@ -171,7 +171,7 @@ static struct lpass_variant sc7180_data = {
 	.rdma_channels		= 5,
 	.hdmi_rdma_reg_base		= 0x64000,
 	.hdmi_rdma_reg_stride	= 0x1000,
-	.hdmi_rdma_channels		= 3,
+	.hdmi_rdma_channels		= 4,
 	.dmactl_audif_start	= 1,
 	.wrdma_reg_base		= 0x18000,
 	.wrdma_reg_stride	= 0x1000,
-- 
2.27.0



