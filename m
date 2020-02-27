Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D50171D1D
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389789AbgB0ORx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:17:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389786AbgB0ORx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:17:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40E8A246AC;
        Thu, 27 Feb 2020 14:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813072;
        bh=ykYgPFe5bZKcA7cDSYmSIwHSPxKFoHDgvX8LHFOhp/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyMw0EsVGWCe1n+BNXzPq1YQCh6NGoTjbPvGuUz5dOrKo1CeoZ48GfJPSA/Y7thkE
         sN2aKe8Lev/tvxMTiHDDSbqy8DasDKrAitsZsN0eUjG5hijDaStqWmJntlE5jA/q8p
         tfT52Resh0N400wDdV7HR2zvZUutLDP7aIFTyXjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 126/150] ASoC: fsl_sai: Fix exiting path on probing failure
Date:   Thu, 27 Feb 2020 14:37:43 +0100
Message-Id: <20200227132251.244029020@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>

commit d1520889782dff58610c0b6b54d4cf3211ceb690 upstream.

If the imx-sdma driver is built as a module, the fsl-sai device doesn't
disable on probing failure, which causes the warning in the next probing:

==================================================================
fsl-sai 308a0000.sai: Unbalanced pm_runtime_enable!
fsl-sai 308a0000.sai: Unbalanced pm_runtime_enable!
fsl-sai 308a0000.sai: Unbalanced pm_runtime_enable!
fsl-sai 308a0000.sai: Unbalanced pm_runtime_enable!
fsl-sai 308a0000.sai: Unbalanced pm_runtime_enable!
fsl-sai 308a0000.sai: Unbalanced pm_runtime_enable!
==================================================================

Disabling the device properly fixes the issue.

Fixes: 812ad463e089 ("ASoC: fsl_sai: Add support for runtime pm")
Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Link: https://lore.kernel.org/r/20200205160436.3813642-1-oleksandr.suvorov@toradex.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/fsl/fsl_sai.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1019,12 +1019,24 @@ static int fsl_sai_probe(struct platform
 	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_component,
 			&fsl_sai_dai, 1);
 	if (ret)
-		return ret;
+		goto err_pm_disable;
 
-	if (sai->soc_data->use_imx_pcm)
-		return imx_pcm_dma_init(pdev, IMX_SAI_DMABUF_SIZE);
-	else
-		return devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+	if (sai->soc_data->use_imx_pcm) {
+		ret = imx_pcm_dma_init(pdev, IMX_SAI_DMABUF_SIZE);
+		if (ret)
+			goto err_pm_disable;
+	} else {
+		ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+		if (ret)
+			goto err_pm_disable;
+	}
+
+	return ret;
+
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
+
+	return ret;
 }
 
 static int fsl_sai_remove(struct platform_device *pdev)


