Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86834420F10
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237796AbhJDNaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237594AbhJDN2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:28:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95F2F63219;
        Mon,  4 Oct 2021 13:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353182;
        bh=ZQFhLovf9cK9e7rHiKmBKbVrGRguF8IQZ1ubrOn7PC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlcEjhDTjd4lFeqtuQBB/ilEQItY97FYypMMN6NJwwB1ridiLlbGSwiobeHZPQzTV
         1RDeg67Dbz38X5K7/qOttM0SJ2Yy6akVG5XRkZKFjNouEi+H5FIxEdgqJkk/tW2NK3
         PED2OZQ5Xh4hVWDa4Nske9AzbVM0jCeEOBJyM13I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 007/172] ASoC: fsl_spdif: register platform component before registering cpu dai
Date:   Mon,  4 Oct 2021 14:50:57 +0200
Message-Id: <20211004125045.195007437@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit ee8ccc2eb5840e34fce088bdb174fd5329153ef0 ]

There is no defer probe when adding platform component to
snd_soc_pcm_runtime(rtd), the code is in snd_soc_add_pcm_runtime()

snd_soc_register_card()
  -> snd_soc_bind_card()
    -> snd_soc_add_pcm_runtime()
      -> adding cpu dai
      -> adding codec dai
      -> adding platform component.

So if the platform component is not ready at that time, then the
sound card still registered successfully, but platform component
is empty, the sound card can't be used.

As there is defer probe checking for cpu dai component, then register
platform component before cpu dai to avoid such issue.

Fixes: a2388a498ad2 ("ASoC: fsl: Add S/PDIF CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1630665006-31437-5-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_spdif.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index 8ffb1a6048d6..1c53719bb61e 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -1434,16 +1434,20 @@ static int fsl_spdif_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	regcache_cache_only(spdif_priv->regmap, true);
 
-	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_spdif_component,
-					      &spdif_priv->cpu_dai_drv, 1);
+	/*
+	 * Register platform component before registering cpu dai for there
+	 * is not defer probe for platform component in snd_soc_add_pcm_runtime().
+	 */
+	ret = imx_pcm_dma_init(pdev, IMX_SPDIF_DMABUF_SIZE);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to register DAI: %d\n", ret);
+		dev_err_probe(&pdev->dev, ret, "imx_pcm_dma_init failed\n");
 		goto err_pm_disable;
 	}
 
-	ret = imx_pcm_dma_init(pdev, IMX_SPDIF_DMABUF_SIZE);
+	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_spdif_component,
+					      &spdif_priv->cpu_dai_drv, 1);
 	if (ret) {
-		dev_err_probe(&pdev->dev, ret, "imx_pcm_dma_init failed\n");
+		dev_err(&pdev->dev, "failed to register DAI: %d\n", ret);
 		goto err_pm_disable;
 	}
 
-- 
2.33.0



