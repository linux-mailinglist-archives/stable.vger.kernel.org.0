Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD8D30CC6B
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240223AbhBBTzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232280AbhBBNvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:51:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40D3A64FB5;
        Tue,  2 Feb 2021 13:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273391;
        bh=ufaMzL7TiqZe+u9GZOmZ3fEDwaLksqPXHlTmxfqAIe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WO1r5KcqHZVA8aLU1RPv/+rHGyhnixlN3y+nFzUJsYiZQYkUmMgNJKrBRMNv9ixPe
         LeJ2kfAc9InPfggZ1DiNukiUQhBW5RGVvMhq1SwBBltMm5P1XmP3D7Gfuvt7H5V5iB
         aivg6UKX9jtk4H8mafs2FYkN6+ZgD3DFZZ66LlUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        V Sujith Kumar Reddy <vsujithk@codeaurora.org>,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/142] ASoC: qcom: Fix incorrect volatile registers
Date:   Tue,  2 Feb 2021 14:37:33 +0100
Message-Id: <20210202133001.418485443@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>

[ Upstream commit 315fbe4cef98ee5fb6085bc54c7f25eb06466c70 ]

MI2S and DMA control registers are not volatile, so remove these from volatile registers list.
Registers reset state check by reading non volatile registers makes no use,
so remove error check from cpu and platform trigger callbacks.
Initialized map variable two times in lpass platform trigger API,
so remove redundant initialization.

Fixes commit b1824968221cc ("ASoC: qcom: Fix enabling BCLK and LRCLK in LPAIF invalid state")

Signed-off-by: V Sujith Kumar Reddy <vsujithk@codeaurora.org>
Signed-off-by: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
Link: https://lore.kernel.org/r/1608192514-29695-2-git-send-email-srivasam@codeaurora.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c      | 20 ++------------------
 sound/soc/qcom/lpass-platform.c | 15 ---------------
 2 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 426235a217ec6..97b920ab50685 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -270,18 +270,6 @@ static int lpass_cpu_daiops_trigger(struct snd_pcm_substream *substream,
 	struct lpaif_i2sctl *i2sctl = drvdata->i2sctl;
 	unsigned int id = dai->driver->id;
 	int ret = -EINVAL;
-	unsigned int val = 0;
-
-	ret = regmap_read(drvdata->lpaif_map,
-				LPAIF_I2SCTL_REG(drvdata->variant, dai->driver->id), &val);
-	if (ret) {
-		dev_err(dai->dev, "error reading from i2sctl reg: %d\n", ret);
-		return ret;
-	}
-	if (val == LPAIF_I2SCTL_RESET_STATE) {
-		dev_err(dai->dev, "error in i2sctl register state\n");
-		return -ENOTRECOVERABLE;
-	}
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
@@ -454,20 +442,16 @@ static bool lpass_cpu_regmap_volatile(struct device *dev, unsigned int reg)
 	struct lpass_variant *v = drvdata->variant;
 	int i;
 
-	for (i = 0; i < v->i2s_ports; ++i)
-		if (reg == LPAIF_I2SCTL_REG(v, i))
-			return true;
 	for (i = 0; i < v->irq_ports; ++i)
 		if (reg == LPAIF_IRQSTAT_REG(v, i))
 			return true;
 
 	for (i = 0; i < v->rdma_channels; ++i)
-		if (reg == LPAIF_RDMACURR_REG(v, i) || reg == LPAIF_RDMACTL_REG(v, i))
+		if (reg == LPAIF_RDMACURR_REG(v, i))
 			return true;
 
 	for (i = 0; i < v->wrdma_channels; ++i)
-		if (reg == LPAIF_WRDMACURR_REG(v, i + v->wrdma_channel_start) ||
-			reg == LPAIF_WRDMACTL_REG(v, i + v->wrdma_channel_start))
+		if (reg == LPAIF_WRDMACURR_REG(v, i + v->wrdma_channel_start))
 			return true;
 
 	return false;
diff --git a/sound/soc/qcom/lpass-platform.c b/sound/soc/qcom/lpass-platform.c
index 80b09dede5f9c..232deee6fde56 100644
--- a/sound/soc/qcom/lpass-platform.c
+++ b/sound/soc/qcom/lpass-platform.c
@@ -452,7 +452,6 @@ static int lpass_platform_pcmops_trigger(struct snd_soc_component *component,
 	unsigned int reg_irqclr = 0, val_irqclr = 0;
 	unsigned int  reg_irqen = 0, val_irqen = 0, val_mask = 0;
 	unsigned int dai_id = cpu_dai->driver->id;
-	unsigned int dma_ctrl_reg = 0;
 
 	ch = pcm_data->dma_ch;
 	if (dir ==  SNDRV_PCM_STREAM_PLAYBACK) {
@@ -469,17 +468,7 @@ static int lpass_platform_pcmops_trigger(struct snd_soc_component *component,
 		id = pcm_data->dma_ch - v->wrdma_channel_start;
 		map = drvdata->lpaif_map;
 	}
-	ret = regmap_read(map, LPAIF_DMACTL_REG(v, ch, dir, dai_id), &dma_ctrl_reg);
-	if (ret) {
-		dev_err(soc_runtime->dev, "error reading from rdmactl reg: %d\n", ret);
-		return ret;
-	}
 
-	if (dma_ctrl_reg == LPAIF_DMACTL_RESET_STATE ||
-		dma_ctrl_reg == LPAIF_DMACTL_RESET_STATE + 1) {
-		dev_err(soc_runtime->dev, "error in rdmactl register state\n");
-		return -ENOTRECOVERABLE;
-	}
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
@@ -500,7 +489,6 @@ static int lpass_platform_pcmops_trigger(struct snd_soc_component *component,
 					"error writing to rdmactl reg: %d\n", ret);
 				return ret;
 			}
-			map = drvdata->hdmiif_map;
 			reg_irqclr = LPASS_HDMITX_APP_IRQCLEAR_REG(v);
 			val_irqclr = (LPAIF_IRQ_ALL(ch) |
 					LPAIF_IRQ_HDMI_REQ_ON_PRELOAD(ch) |
@@ -519,7 +507,6 @@ static int lpass_platform_pcmops_trigger(struct snd_soc_component *component,
 			break;
 		case MI2S_PRIMARY:
 		case MI2S_SECONDARY:
-			map = drvdata->lpaif_map;
 			reg_irqclr = LPAIF_IRQCLEAR_REG(v, LPAIF_IRQ_PORT_HOST);
 			val_irqclr = LPAIF_IRQ_ALL(ch);
 
@@ -563,7 +550,6 @@ static int lpass_platform_pcmops_trigger(struct snd_soc_component *component,
 					"error writing to rdmactl reg: %d\n", ret);
 				return ret;
 			}
-			map = drvdata->hdmiif_map;
 			reg_irqen = LPASS_HDMITX_APP_IRQEN_REG(v);
 			val_mask = (LPAIF_IRQ_ALL(ch) |
 					LPAIF_IRQ_HDMI_REQ_ON_PRELOAD(ch) |
@@ -573,7 +559,6 @@ static int lpass_platform_pcmops_trigger(struct snd_soc_component *component,
 			break;
 		case MI2S_PRIMARY:
 		case MI2S_SECONDARY:
-			map = drvdata->lpaif_map;
 			reg_irqen = LPAIF_IRQEN_REG(v, LPAIF_IRQ_PORT_HOST);
 			val_mask = LPAIF_IRQ_ALL(ch);
 			val_irqen = 0;
-- 
2.27.0



