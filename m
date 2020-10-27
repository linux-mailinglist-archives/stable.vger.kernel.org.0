Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5319529B82B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799750AbgJ0PdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799744AbgJ0PdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:33:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E778420728;
        Tue, 27 Oct 2020 15:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812788;
        bh=13/GnTzYZUjhQrBNwuGyIgOcatlNf1iVHcRvGtwo36s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7W0Ne6mcxdIoUV83AEj97/lAcvcO3blrl1K1a2HkJbG4pDt0/tBEE0ILLwuNoruj
         kyTnTpMlTNQWWtKbFgqgOaPu4kvc0tPzuEZBeb60i45O+eDLMZAb6QZ8ehreTEH7Pc
         mSbD9ALgiOpS/qQpPipKqb+42X63Z7cgUDmhry+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 330/757] ASoC: fsl_sai: Instantiate snd_soc_dai_driver
Date:   Tue, 27 Oct 2020 14:49:40 +0100
Message-Id: <20201027135506.026727180@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 22a16145af824f91014d07f8664114859900b9e6 ]

Instantiate snd_soc_dai_driver for independent symmetric control.
Otherwise the symmetric setting may be overwritten by other
instance.

Fixes: 08fdf65e37d5 ("ASoC: fsl_sai: Add asynchronous mode support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1600424760-32071-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 19 +++++++++++--------
 sound/soc/fsl/fsl_sai.h |  1 +
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index cdff739924e2e..2ea354dd5434f 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -694,7 +694,7 @@ static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
 	return 0;
 }
 
-static struct snd_soc_dai_driver fsl_sai_dai = {
+static struct snd_soc_dai_driver fsl_sai_dai_template = {
 	.probe = fsl_sai_dai_probe,
 	.playback = {
 		.stream_name = "CPU-Playback",
@@ -966,12 +966,15 @@ static int fsl_sai_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	memcpy(&sai->cpu_dai_drv, &fsl_sai_dai_template,
+	       sizeof(fsl_sai_dai_template));
+
 	/* Sync Tx with Rx as default by following old DT binding */
 	sai->synchronous[RX] = true;
 	sai->synchronous[TX] = false;
-	fsl_sai_dai.symmetric_rates = 1;
-	fsl_sai_dai.symmetric_channels = 1;
-	fsl_sai_dai.symmetric_samplebits = 1;
+	sai->cpu_dai_drv.symmetric_rates = 1;
+	sai->cpu_dai_drv.symmetric_channels = 1;
+	sai->cpu_dai_drv.symmetric_samplebits = 1;
 
 	if (of_find_property(np, "fsl,sai-synchronous-rx", NULL) &&
 	    of_find_property(np, "fsl,sai-asynchronous", NULL)) {
@@ -988,9 +991,9 @@ static int fsl_sai_probe(struct platform_device *pdev)
 		/* Discard all settings for asynchronous mode */
 		sai->synchronous[RX] = false;
 		sai->synchronous[TX] = false;
-		fsl_sai_dai.symmetric_rates = 0;
-		fsl_sai_dai.symmetric_channels = 0;
-		fsl_sai_dai.symmetric_samplebits = 0;
+		sai->cpu_dai_drv.symmetric_rates = 0;
+		sai->cpu_dai_drv.symmetric_channels = 0;
+		sai->cpu_dai_drv.symmetric_samplebits = 0;
 	}
 
 	if (of_find_property(np, "fsl,sai-mclk-direction-output", NULL) &&
@@ -1020,7 +1023,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	regcache_cache_only(sai->regmap, true);
 
 	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_component,
-			&fsl_sai_dai, 1);
+					      &sai->cpu_dai_drv, 1);
 	if (ret)
 		goto err_pm_disable;
 
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 6aba7d28f5f34..677ecfc1ec68f 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -180,6 +180,7 @@ struct fsl_sai {
 	unsigned int bclk_ratio;
 
 	const struct fsl_sai_soc_data *soc_data;
+	struct snd_soc_dai_driver cpu_dai_drv;
 	struct snd_dmaengine_dai_dma_data dma_params_rx;
 	struct snd_dmaengine_dai_dma_data dma_params_tx;
 };
-- 
2.25.1



