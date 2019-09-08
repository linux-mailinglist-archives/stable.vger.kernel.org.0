Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67F1ACE1A
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732263AbfIHMvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732405AbfIHMvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:51:00 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00E8920863;
        Sun,  8 Sep 2019 12:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947058;
        bh=ACc+YmBwGbHCLj2cy/Y2CoS3DCdMEMMLQoOqdBRoTdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npPJHzgBqA8g6GLeLfwnXO3/Sod+GZPpnOfJasKY8GoXz7j5ShEfY0QiqNIaKuq/Z
         zXzl0sxl/JFA8VKox/XrRzxy2eMnsWsszieCqIZxKgiFCEV3DwAuZ9TI0B+O88ZAgI
         KJrW84BssZunLd5P5tlb8fg/0QPJrhuma4wHpAds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>, CK Hu <ck.hu@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 44/94] drm/mediatek: set DMA max segment size
Date:   Sun,  8 Sep 2019 13:41:40 +0100
Message-Id: <20190908121151.699854408@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 070955558e820b9a89c570b91b1f21762f62b288 ]

This driver requires imported PRIME buffers to appear contiguously in
its IO address space. Make sure this is the case by setting the maximum
DMA segment size to a more suitable value than the default 64KB.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 35 ++++++++++++++++++++++++--
 drivers/gpu/drm/mediatek/mtk_drm_drv.h |  2 ++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 8b18a00a58c7e..c021d4c8324f5 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -213,6 +213,7 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 	struct mtk_drm_private *private = drm->dev_private;
 	struct platform_device *pdev;
 	struct device_node *np;
+	struct device *dma_dev;
 	int ret;
 
 	if (!iommu_present(&platform_bus_type))
@@ -275,7 +276,29 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 		goto err_component_unbind;
 	}
 
-	private->dma_dev = &pdev->dev;
+	dma_dev = &pdev->dev;
+	private->dma_dev = dma_dev;
+
+	/*
+	 * Configure the DMA segment size to make sure we get contiguous IOVA
+	 * when importing PRIME buffers.
+	 */
+	if (!dma_dev->dma_parms) {
+		private->dma_parms_allocated = true;
+		dma_dev->dma_parms =
+			devm_kzalloc(drm->dev, sizeof(*dma_dev->dma_parms),
+				     GFP_KERNEL);
+	}
+	if (!dma_dev->dma_parms) {
+		ret = -ENOMEM;
+		goto err_component_unbind;
+	}
+
+	ret = dma_set_max_seg_size(dma_dev, (unsigned int)DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(dma_dev, "Failed to set DMA segment size\n");
+		goto err_unset_dma_parms;
+	}
 
 	/*
 	 * We don't use the drm_irq_install() helpers provided by the DRM
@@ -285,13 +308,16 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 	drm->irq_enabled = true;
 	ret = drm_vblank_init(drm, MAX_CRTC);
 	if (ret < 0)
-		goto err_component_unbind;
+		goto err_unset_dma_parms;
 
 	drm_kms_helper_poll_init(drm);
 	drm_mode_config_reset(drm);
 
 	return 0;
 
+err_unset_dma_parms:
+	if (private->dma_parms_allocated)
+		dma_dev->dma_parms = NULL;
 err_component_unbind:
 	component_unbind_all(drm->dev, drm);
 err_config_cleanup:
@@ -302,9 +328,14 @@ err_config_cleanup:
 
 static void mtk_drm_kms_deinit(struct drm_device *drm)
 {
+	struct mtk_drm_private *private = drm->dev_private;
+
 	drm_kms_helper_poll_fini(drm);
 	drm_atomic_helper_shutdown(drm);
 
+	if (private->dma_parms_allocated)
+		private->dma_dev->dma_parms = NULL;
+
 	component_unbind_all(drm->dev, drm);
 	drm_mode_config_cleanup(drm);
 }
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.h b/drivers/gpu/drm/mediatek/mtk_drm_drv.h
index 598ff3e704465..e03fea12ff598 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.h
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.h
@@ -51,6 +51,8 @@ struct mtk_drm_private {
 	} commit;
 
 	struct drm_atomic_state *suspend_state;
+
+	bool dma_parms_allocated;
 };
 
 extern struct platform_driver mtk_ddp_driver;
-- 
2.20.1



