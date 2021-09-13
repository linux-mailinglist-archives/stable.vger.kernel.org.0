Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A9A4093BC
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345802AbhIMO0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346540AbhIMOYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:24:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F69261260;
        Mon, 13 Sep 2021 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540911;
        bh=XiDtveJprzscL9tlffUBoV5vcZn/VTSikhdAvGKho7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1YuxnhH15xIi+6AyZywOPvxasEOr30seNqyHjDXpqVw3sLCQ/wT4K7Aq9+OJ6hfU
         EygMaznTcraVFwyZETHR9HijGHRFnHMWNiYL5x/H3r3/nKxvtD9o4u36tj4q2o9hrm
         zcrA0KjUJGaxlPLj1sFGIEU0lT2tspkKzhY3pqX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 085/334] ASoC: mediatek: mt8183: Fix Unbalanced pm_runtime_enable in mt8183_afe_pcm_dev_probe
Date:   Mon, 13 Sep 2021 15:12:19 +0200
Message-Id: <20210913131116.261261722@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 19f479c37f76e926a6c0bec974a4d09826e32fc6 ]

Add missing pm_runtime_disable() when probe error out. It could
avoid pm_runtime implementation complains when removing and probing
again the driver.

Fixes:a94aec035a122 ("ASoC: mediatek: mt8183: add platform driver")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20210618141104.105047-3-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c | 43 ++++++++++++++--------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c b/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
index c4a598cbbdaa..14e77df06b01 100644
--- a/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
+++ b/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
@@ -1119,25 +1119,26 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 	afe->regmap = syscon_node_to_regmap(dev->parent->of_node);
 	if (IS_ERR(afe->regmap)) {
 		dev_err(dev, "could not get regmap from parent\n");
-		return PTR_ERR(afe->regmap);
+		ret = PTR_ERR(afe->regmap);
+		goto err_pm_disable;
 	}
 	ret = regmap_attach_dev(dev, afe->regmap, &mt8183_afe_regmap_config);
 	if (ret) {
 		dev_warn(dev, "regmap_attach_dev fail, ret %d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	rstc = devm_reset_control_get(dev, "audiosys");
 	if (IS_ERR(rstc)) {
 		ret = PTR_ERR(rstc);
 		dev_err(dev, "could not get audiosys reset:%d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	ret = reset_control_reset(rstc);
 	if (ret) {
 		dev_err(dev, "failed to trigger audio reset:%d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	/* enable clock for regcache get default value from hw */
@@ -1147,7 +1148,7 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 	ret = regmap_reinit_cache(afe->regmap, &mt8183_afe_regmap_config);
 	if (ret) {
 		dev_err(dev, "regmap_reinit_cache fail, ret %d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	pm_runtime_put_sync(&pdev->dev);
@@ -1160,8 +1161,10 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 	afe->memif_size = MT8183_MEMIF_NUM;
 	afe->memif = devm_kcalloc(dev, afe->memif_size, sizeof(*afe->memif),
 				  GFP_KERNEL);
-	if (!afe->memif)
-		return -ENOMEM;
+	if (!afe->memif) {
+		ret = -ENOMEM;
+		goto err_pm_disable;
+	}
 
 	for (i = 0; i < afe->memif_size; i++) {
 		afe->memif[i].data = &memif_data[i];
@@ -1178,22 +1181,26 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 	afe->irqs_size = MT8183_IRQ_NUM;
 	afe->irqs = devm_kcalloc(dev, afe->irqs_size, sizeof(*afe->irqs),
 				 GFP_KERNEL);
-	if (!afe->irqs)
-		return -ENOMEM;
+	if (!afe->irqs) {
+		ret = -ENOMEM;
+		goto err_pm_disable;
+	}
 
 	for (i = 0; i < afe->irqs_size; i++)
 		afe->irqs[i].irq_data = &irq_data[i];
 
 	/* request irq */
 	irq_id = platform_get_irq(pdev, 0);
-	if (irq_id < 0)
-		return irq_id;
+	if (irq_id < 0) {
+		ret = irq_id;
+		goto err_pm_disable;
+	}
 
 	ret = devm_request_irq(dev, irq_id, mt8183_afe_irq_handler,
 			       IRQF_TRIGGER_NONE, "asys-isr", (void *)afe);
 	if (ret) {
 		dev_err(dev, "could not request_irq for asys-isr\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	/* init sub_dais */
@@ -1204,7 +1211,7 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_warn(afe->dev, "dai register i %d fail, ret %d\n",
 				 i, ret);
-			return ret;
+			goto err_pm_disable;
 		}
 	}
 
@@ -1213,7 +1220,7 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_warn(afe->dev, "mtk_afe_combine_sub_dai fail, ret %d\n",
 			 ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	afe->mtk_afe_hardware = &mt8183_afe_hardware;
@@ -1229,7 +1236,7 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 					      NULL, 0);
 	if (ret) {
 		dev_warn(dev, "err_platform\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	ret = devm_snd_soc_register_component(afe->dev,
@@ -1238,10 +1245,14 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 					      afe->num_dai_drivers);
 	if (ret) {
 		dev_warn(dev, "err_dai_component\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	return ret;
+
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
+	return ret;
 }
 
 static int mt8183_afe_pcm_dev_remove(struct platform_device *pdev)
-- 
2.30.2



