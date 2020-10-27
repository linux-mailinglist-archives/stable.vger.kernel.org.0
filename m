Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF4C29C286
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1820650AbgJ0RhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760711AbgJ0OgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:36:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD81C207BB;
        Tue, 27 Oct 2020 14:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809361;
        bh=g975v8wUm1M1txfr455ndY6jeJAWydIyWNJ5MBqKuE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJt9QpfLP/1CSjTGEIRgrNeAXWSZMsqBDqp3+HCOoFtk94jgc/NBuV7MUX0OBr10w
         L/6JHXZlkRfk2oyhdVfpqfTN5i6XBuuL+WRi9ajfgxkvPEdxoN+lwKa/FMtkxzA3hK
         mabkfQJy+HObO3idiD+bzq77dHALGTUil15oee/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/408] ASoC: fsl_sai: Instantiate snd_soc_dai_driver
Date:   Tue, 27 Oct 2020 14:51:46 +0100
Message-Id: <20201027135502.888538514@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index 914b75c23d1bf..027259695551c 100644
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
@@ -965,12 +965,15 @@ static int fsl_sai_probe(struct platform_device *pdev)
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
@@ -987,9 +990,9 @@ static int fsl_sai_probe(struct platform_device *pdev)
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
@@ -1018,7 +1021,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
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



