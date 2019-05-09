Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB8019186
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfEISw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbfEISw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:52:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A92F12183F;
        Thu,  9 May 2019 18:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427946;
        bh=x/6DoZU6/oawNfhsfKZGZE1WvjtrrBpQkTWHMEsssKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iyo7kLAEtHCtxd01dwmtg0BfcM+ZkbQQ+QWeuZnRXeS/iM5tPxsVhsMgbN2w3/C1/
         EJZ7Vn+umKiw6QtvZIBL3PnXSgCbCdNe23YNPgMZ60InBFuRPYJ/+RCppMh9is5uYv
         V0PIAi70ENonVe6SqXofW4bFQtFnkeK1B0M8K3j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 62/95] ASoC: stm32: sai: fix master clock management
Date:   Thu,  9 May 2019 20:42:19 +0200
Message-Id: <20190509181313.818369796@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e37c2deafe7058cf7989c4c47bbf1140cc867d89 ]

When master clock is used, master clock rate is set exclusively.
Parent clocks of master clock cannot be changed after a call to
clk_set_rate_exclusive(). So the parent clock of SAI kernel clock
must be set before.
Ensure also that exclusive rate operations are balanced
in STM32 SAI driver.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 64 +++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 17 deletions(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index bc69e68191ad1..1cf9df4b6f11c 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -70,6 +70,7 @@
 #define SAI_IEC60958_STATUS_BYTES	24
 
 #define SAI_MCLK_NAME_LEN		32
+#define SAI_RATE_11K			11025
 
 /**
  * struct stm32_sai_sub_data - private data of SAI sub block (block A or B)
@@ -309,6 +310,25 @@ static int stm32_sai_set_clk_div(struct stm32_sai_sub_data *sai,
 	return ret;
 }
 
+static int stm32_sai_set_parent_clock(struct stm32_sai_sub_data *sai,
+				      unsigned int rate)
+{
+	struct platform_device *pdev = sai->pdev;
+	struct clk *parent_clk = sai->pdata->clk_x8k;
+	int ret;
+
+	if (!(rate % SAI_RATE_11K))
+		parent_clk = sai->pdata->clk_x11k;
+
+	ret = clk_set_parent(sai->sai_ck, parent_clk);
+	if (ret)
+		dev_err(&pdev->dev, " Error %d setting sai_ck parent clock. %s",
+			ret, ret == -EBUSY ?
+			"Active stream rates conflict\n" : "\n");
+
+	return ret;
+}
+
 static long stm32_sai_mclk_round_rate(struct clk_hw *hw, unsigned long rate,
 				      unsigned long *prate)
 {
@@ -490,25 +510,29 @@ static int stm32_sai_set_sysclk(struct snd_soc_dai *cpu_dai,
 	struct stm32_sai_sub_data *sai = snd_soc_dai_get_drvdata(cpu_dai);
 	int ret;
 
-	if (dir == SND_SOC_CLOCK_OUT) {
+	if (dir == SND_SOC_CLOCK_OUT && sai->sai_mclk) {
 		ret = regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX,
 					 SAI_XCR1_NODIV,
 					 (unsigned int)~SAI_XCR1_NODIV);
 		if (ret < 0)
 			return ret;
 
-		dev_dbg(cpu_dai->dev, "SAI MCLK frequency is %uHz\n", freq);
-		sai->mclk_rate = freq;
+		/* If master clock is used, set parent clock now */
+		ret = stm32_sai_set_parent_clock(sai, freq);
+		if (ret)
+			return ret;
 
-		if (sai->sai_mclk) {
-			ret = clk_set_rate_exclusive(sai->sai_mclk,
-						     sai->mclk_rate);
-			if (ret) {
-				dev_err(cpu_dai->dev,
-					"Could not set mclk rate\n");
-				return ret;
-			}
+		ret = clk_set_rate_exclusive(sai->sai_mclk, freq);
+		if (ret) {
+			dev_err(cpu_dai->dev,
+				ret == -EBUSY ?
+				"Active streams have incompatible rates" :
+				"Could not set mclk rate\n");
+			return ret;
 		}
+
+		dev_dbg(cpu_dai->dev, "SAI MCLK frequency is %uHz\n", freq);
+		sai->mclk_rate = freq;
 	}
 
 	return 0;
@@ -916,11 +940,13 @@ static int stm32_sai_configure_clock(struct snd_soc_dai *cpu_dai,
 	int cr1, mask, div = 0;
 	int sai_clk_rate, mclk_ratio, den;
 	unsigned int rate = params_rate(params);
+	int ret;
 
-	if (!(rate % 11025))
-		clk_set_parent(sai->sai_ck, sai->pdata->clk_x11k);
-	else
-		clk_set_parent(sai->sai_ck, sai->pdata->clk_x8k);
+	if (!sai->sai_mclk) {
+		ret = stm32_sai_set_parent_clock(sai, rate);
+		if (ret)
+			return ret;
+	}
 	sai_clk_rate = clk_get_rate(sai->sai_ck);
 
 	if (STM_SAI_IS_F4(sai->pdata)) {
@@ -1075,9 +1101,13 @@ static void stm32_sai_shutdown(struct snd_pcm_substream *substream,
 	regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX, SAI_XCR1_NODIV,
 			   SAI_XCR1_NODIV);
 
-	clk_disable_unprepare(sai->sai_ck);
+	/* Release mclk rate only if rate was actually set */
+	if (sai->mclk_rate) {
+		clk_rate_exclusive_put(sai->sai_mclk);
+		sai->mclk_rate = 0;
+	}
 
-	clk_rate_exclusive_put(sai->sai_mclk);
+	clk_disable_unprepare(sai->sai_ck);
 
 	spin_lock_irqsave(&sai->irq_lock, flags);
 	sai->substream = NULL;
-- 
2.20.1



