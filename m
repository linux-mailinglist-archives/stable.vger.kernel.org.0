Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346BC328C63
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240325AbhCASvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:51:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240086AbhCASok (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:44:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E73564FD2;
        Mon,  1 Mar 2021 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620757;
        bh=F86b2V/C8EXOsNM2cXgkGjcucovl4qwPuHtGY4Zi8x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtY8YfVPw4o5ytYGmB9OA4xeOHdqnBnCcDtYKc3rdQK9bryRhubVCZM/DnE/q+NWX
         bnz+gQLYV6j02htWWP11BFHl29VvHzvwo9S8fVZMAaTusUzH747RTCpMMfkGHmFrNJ
         yVWnt6wWAm+AYFG8A4QPDfh8aEPkr7l16C2pZkv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 238/775] ASoC: qcom: lpass-cpu: Remove bit clock state check
Date:   Mon,  1 Mar 2021 17:06:46 +0100
Message-Id: <20210301161213.391650567@linuxfoundation.org>
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

[ Upstream commit 6c28377b7114d04cf82eedffe9dcc8fa66ecec48 ]

No need of BCLK state maintenance from driver side as
clock_enable and clk_disable API's maintaing state counter.

One of the major issue was spotted when Headset jack inserted
while playback continues, due to same PCM device node opens twice
for playaback/capture and closes once for capture and playback continues.

It can resolve the errors in such scenarios.

Fixes: b1824968221c ("ASoC: qcom: Fix enabling BCLK and LRCLK in LPAIF invalid state")

Signed-off-by: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210127151824.8929-1-srivasam@codeaurora.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c       | 22 ++++++++--------------
 sound/soc/qcom/lpass-lpaif-reg.h |  3 ---
 sound/soc/qcom/lpass.h           |  1 -
 3 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 66b834312f330..73ca24c0a08b7 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -286,16 +286,12 @@ static int lpass_cpu_daiops_trigger(struct snd_pcm_substream *substream,
 			dev_err(dai->dev, "error writing to i2sctl reg: %d\n",
 				ret);
 
-		if (drvdata->bit_clk_state[id] == LPAIF_BIT_CLK_DISABLE) {
-			ret = clk_enable(drvdata->mi2s_bit_clk[id]);
-			if (ret) {
-				dev_err(dai->dev, "error in enabling mi2s bit clk: %d\n", ret);
-				clk_disable(drvdata->mi2s_osr_clk[id]);
-				return ret;
-			}
-			drvdata->bit_clk_state[id] = LPAIF_BIT_CLK_ENABLE;
+		ret = clk_enable(drvdata->mi2s_bit_clk[id]);
+		if (ret) {
+			dev_err(dai->dev, "error in enabling mi2s bit clk: %d\n", ret);
+			clk_disable(drvdata->mi2s_osr_clk[id]);
+			return ret;
 		}
-
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
@@ -310,10 +306,9 @@ static int lpass_cpu_daiops_trigger(struct snd_pcm_substream *substream,
 		if (ret)
 			dev_err(dai->dev, "error writing to i2sctl reg: %d\n",
 				ret);
-		if (drvdata->bit_clk_state[id] == LPAIF_BIT_CLK_ENABLE) {
-			clk_disable(drvdata->mi2s_bit_clk[dai->driver->id]);
-			drvdata->bit_clk_state[id] = LPAIF_BIT_CLK_DISABLE;
-		}
+
+		clk_disable(drvdata->mi2s_bit_clk[dai->driver->id]);
+
 		break;
 	}
 
@@ -866,7 +861,6 @@ int asoc_qcom_lpass_cpu_platform_probe(struct platform_device *pdev)
 				PTR_ERR(drvdata->mi2s_bit_clk[dai_id]));
 			return PTR_ERR(drvdata->mi2s_bit_clk[dai_id]);
 		}
-		drvdata->bit_clk_state[dai_id] = LPAIF_BIT_CLK_DISABLE;
 	}
 
 	/* Allocation for i2sctl regmap fields */
diff --git a/sound/soc/qcom/lpass-lpaif-reg.h b/sound/soc/qcom/lpass-lpaif-reg.h
index baf72f124ea9b..2eb03ad9b7c74 100644
--- a/sound/soc/qcom/lpass-lpaif-reg.h
+++ b/sound/soc/qcom/lpass-lpaif-reg.h
@@ -60,9 +60,6 @@
 #define LPAIF_I2SCTL_BITWIDTH_24	1
 #define LPAIF_I2SCTL_BITWIDTH_32	2
 
-#define LPAIF_BIT_CLK_DISABLE		0
-#define LPAIF_BIT_CLK_ENABLE		1
-
 #define LPAIF_I2SCTL_RESET_STATE	0x003C0004
 #define LPAIF_DMACTL_RESET_STATE	0x00200000
 
diff --git a/sound/soc/qcom/lpass.h b/sound/soc/qcom/lpass.h
index 2d68af0da34d8..83b2e08ade060 100644
--- a/sound/soc/qcom/lpass.h
+++ b/sound/soc/qcom/lpass.h
@@ -68,7 +68,6 @@ struct lpass_data {
 	unsigned int mi2s_playback_sd_mode[LPASS_MAX_MI2S_PORTS];
 	unsigned int mi2s_capture_sd_mode[LPASS_MAX_MI2S_PORTS];
 	int hdmi_port_enable;
-	int bit_clk_state[LPASS_MAX_MI2S_PORTS];
 
 	/* low-power audio interface (LPAIF) registers */
 	void __iomem *lpaif;
-- 
2.27.0



