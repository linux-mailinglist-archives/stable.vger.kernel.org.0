Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA383C4AB5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240290AbhGLGx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240751AbhGLGwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 438BD60FE3;
        Mon, 12 Jul 2021 06:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072560;
        bh=qGnIMxTlyW37AFv9vA1hjkpK0wuINS+XfDTYg+/xTZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wln3ebHe2iPGeWot9/gJQD7DopRb0pfmiQ9V7BeryDi2fCy+Dp1smksL1dWdBuvnp
         WCStFiHDycITDs3mvf0o/ura7Nv5zqXvOh+jzE/ihXUuqW8DxzOCYz/PjiZqZGM5JD
         oF17bAUqdTCRKOprqh4AtcSCFL6IlpBDadU3fvXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 521/593] ASoC: fsl_spdif: Fix error handler with pm_runtime_enable
Date:   Mon, 12 Jul 2021 08:11:21 +0200
Message-Id: <20210712060949.972787526@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 28108d71ee11a7232e1102effab3361049dcd3b8 ]

There is error message when defer probe happens:

fsl-spdif-dai 2dab0000.spdif: Unbalanced pm_runtime_enable!

Fix the error handler with pm_runtime_enable and add
fsl_spdif_remove() for pm_runtime_disable.

Fixes: 9cb2b3796e08 ("ASoC: fsl_spdif: Add pm runtime function")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1623392318-26304-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_spdif.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index b0f643fefe1e..1fbc6d780700 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -1358,16 +1358,29 @@ static int fsl_spdif_probe(struct platform_device *pdev)
 					      &spdif_priv->cpu_dai_drv, 1);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register DAI: %d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	ret = imx_pcm_dma_init(pdev, IMX_SPDIF_DMABUF_SIZE);
-	if (ret && ret != -EPROBE_DEFER)
-		dev_err(&pdev->dev, "imx_pcm_dma_init failed: %d\n", ret);
+	if (ret) {
+		dev_err_probe(&pdev->dev, ret, "imx_pcm_dma_init failed\n");
+		goto err_pm_disable;
+	}
+
+	return ret;
 
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
 	return ret;
 }
 
+static int fsl_spdif_remove(struct platform_device *pdev)
+{
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int fsl_spdif_runtime_suspend(struct device *dev)
 {
@@ -1469,6 +1482,7 @@ static struct platform_driver fsl_spdif_driver = {
 		.pm = &fsl_spdif_pm,
 	},
 	.probe = fsl_spdif_probe,
+	.remove = fsl_spdif_remove,
 };
 
 module_platform_driver(fsl_spdif_driver);
-- 
2.30.2



