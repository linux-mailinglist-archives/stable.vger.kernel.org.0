Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22FEDA2335
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfH2SOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbfH2SOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:14:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AC4823427;
        Thu, 29 Aug 2019 18:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102440;
        bh=u2HAGG7hT+Bcz8+BAkrHj6sRlGaGgfU6rFtQSDz5A+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkB/9n2uGbTac40D81tk1ciyh7hKal+d7lDcYKVLp18775TVi9DWvNBpOEoBxThCx
         vC4+GPHJ/xQbzDRZTm0yin3cwyZ5u7gHVDI6jPiHhCwVpJO94kLbE7YpoDj9LA7axC
         o7IFsOLoS93s/2lwlRz3uO+ChEK/yrT918DzUpag=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>, CK Hu <ck.hu@mediatek.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 28/76] drm/mediatek: set DMA max segment size
Date:   Thu, 29 Aug 2019 14:12:23 -0400
Message-Id: <20190829181311.7562-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Courbot <acourbot@chromium.org>

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
@@ -302,9 +328,14 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 
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

