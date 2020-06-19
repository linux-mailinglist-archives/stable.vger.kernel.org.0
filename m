Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7A32012BB
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405240AbgFSPzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392840AbgFSPVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5384A20706;
        Fri, 19 Jun 2020 15:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580079;
        bh=rl7zVDYqGxocr79XUZScztG4oxq9RmTVjQCEcsz10+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzHeQ5GSk7ojWbi/8Znhy7YCFJ3FiaBMXnwtI4A1eTkyk6Z11LzXDIbc/9a1UEGEl
         kh0u0PKEOPULFOx0SH75kQRSRSDNtCIVT3tkVIsAQ90HoqzzWCoAyxrByyd02iqqWS
         DDq60NWxW3Zv3rQf6DLTA1tRBsL5COtXRxnrPFdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tian Tao <tiantao6@hisilicon.com>,
        Gong junjie <gongjunjie2@huawei.com>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 084/376] drm/hisilicon: Enforce 128-byte stride alignment to fix the hardware limitation
Date:   Fri, 19 Jun 2020 16:30:02 +0200
Message-Id: <20200619141714.320930852@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tian Tao <tiantao6@hisilicon.com>

[ Upstream commit 9c9a8468de21895abc43f45fc86346467217c986 ]

because the hardware limitation,The initial color depth must set to 32bpp
and must set the FB Offset of the display hardware to 128Byte alignment,
which is used to solve the display problem at 800x600 and 1440x900
resolution under 16bpp.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Signed-off-by: Gong junjie <gongjunjie2@huawei.com>
Acked-by: Xinliang Liu <xinliang.liu@linaro.org>
Signed-off-by: Xinliang Liu <xinliang.liu@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1583466184-7060-4-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c  | 9 +++++----
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c | 4 ++--
 drivers/gpu/drm/hisilicon/hibmc/hibmc_ttm.c     | 2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c
index 55b46a7150a5..cc70e836522f 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c
@@ -94,6 +94,10 @@ static int hibmc_plane_atomic_check(struct drm_plane *plane,
 		return -EINVAL;
 	}
 
+	if (state->fb->pitches[0] % 128 != 0) {
+		DRM_DEBUG_ATOMIC("wrong stride with 128-byte aligned\n");
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -119,11 +123,8 @@ static void hibmc_plane_atomic_update(struct drm_plane *plane,
 	writel(gpu_addr, priv->mmio + HIBMC_CRT_FB_ADDRESS);
 
 	reg = state->fb->width * (state->fb->format->cpp[0]);
-	/* now line_pad is 16 */
-	reg = PADDING(16, reg);
 
-	line_l = state->fb->width * state->fb->format->cpp[0];
-	line_l = PADDING(16, line_l);
+	line_l = state->fb->pitches[0];
 	writel(HIBMC_FIELD(HIBMC_CRT_FB_WIDTH_WIDTH, reg) |
 	       HIBMC_FIELD(HIBMC_CRT_FB_WIDTH_OFFS, line_l),
 	       priv->mmio + HIBMC_CRT_FB_WIDTH);
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
index 222356a4f9a8..79a180ae4509 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
@@ -94,7 +94,7 @@ static int hibmc_kms_init(struct hibmc_drm_private *priv)
 	priv->dev->mode_config.max_height = 1200;
 
 	priv->dev->mode_config.fb_base = priv->fb_base;
-	priv->dev->mode_config.preferred_depth = 24;
+	priv->dev->mode_config.preferred_depth = 32;
 	priv->dev->mode_config.prefer_shadow = 1;
 
 	priv->dev->mode_config.funcs = (void *)&hibmc_mode_funcs;
@@ -307,7 +307,7 @@ static int hibmc_load(struct drm_device *dev)
 	/* reset all the states of crtc/plane/encoder/connector */
 	drm_mode_config_reset(dev);
 
-	ret = drm_fbdev_generic_setup(dev, 16);
+	ret = drm_fbdev_generic_setup(dev, dev->mode_config.preferred_depth);
 	if (ret) {
 		DRM_ERROR("failed to initialize fbdev: %d\n", ret);
 		goto err;
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_ttm.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_ttm.c
index 99397ac3b363..322bd542e89d 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_ttm.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_ttm.c
@@ -50,7 +50,7 @@ void hibmc_mm_fini(struct hibmc_drm_private *hibmc)
 int hibmc_dumb_create(struct drm_file *file, struct drm_device *dev,
 		      struct drm_mode_create_dumb *args)
 {
-	return drm_gem_vram_fill_create_dumb(file, dev, 0, 16, args);
+	return drm_gem_vram_fill_create_dumb(file, dev, 0, 128, args);
 }
 
 const struct drm_mode_config_funcs hibmc_mode_funcs = {
-- 
2.25.1



