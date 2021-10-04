Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBE4420F0C
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbhJDNae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237576AbhJDN2i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:28:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3A5161AFC;
        Mon,  4 Oct 2021 13:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353174;
        bh=HvFSM/sWFbs4nnBZExz9C2GJG0KPexFl1Y8hNd1+wdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROqz7etKhEnhxNV3YtSh+rE18i6/aEncWlD9GGECbKDiLgyVFxhgV/7rVJfnImbR6
         U+cimTb10OZsYSDMHQir7P4buNeMczNMVKbkF0hFttaC70rVDf2BAqfp5W3y9/gS0y
         tF7KV2rZwCRwY8tLIUgk6ViupwaMcUxWrRSmV7+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 004/172] ASoC: fsl_sai: register platform component before registering cpu dai
Date:   Mon,  4 Oct 2021 14:50:54 +0200
Message-Id: <20211004125045.091502010@linuxfoundation.org>
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

[ Upstream commit 9c3ad33b5a412d8bc0a377e7cd9baa53ed52f22d ]

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

Fixes: 435508214942 ("ASoC: Add SAI SoC Digital Audio Interface driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1630665006-31437-2-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 223fcd15bfcc..38f6362099d5 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1152,11 +1152,10 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_pm_get_sync;
 
-	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_component,
-					      &sai->cpu_dai_drv, 1);
-	if (ret)
-		goto err_pm_get_sync;
-
+	/*
+	 * Register platform component before registering cpu dai for there
+	 * is not defer probe for platform component in snd_soc_add_pcm_runtime().
+	 */
 	if (sai->soc_data->use_imx_pcm) {
 		ret = imx_pcm_dma_init(pdev, IMX_SAI_DMABUF_SIZE);
 		if (ret)
@@ -1167,6 +1166,11 @@ static int fsl_sai_probe(struct platform_device *pdev)
 			goto err_pm_get_sync;
 	}
 
+	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_component,
+					      &sai->cpu_dai_drv, 1);
+	if (ret)
+		goto err_pm_get_sync;
+
 	return ret;
 
 err_pm_get_sync:
-- 
2.33.0



