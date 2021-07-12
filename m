Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4B23C5360
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352347AbhGLHyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350272AbhGLHus (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A9FD619B2;
        Mon, 12 Jul 2021 07:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075859;
        bh=1o/EPkiVtXhvVfmXjShWcDVSYPIUVdVKqQjORRabH3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYGo+XnOgRIBbAbojGPsUezx/j0ZYOXkfvefz5FjPCDBMxYoTb0td+cuXi9nLYg6q
         s+KqVSnHO8Q3Z+BQoorNr4suORj3GWzqTk5sxBOpq9fTtLP0IgBMHHfNPdZQN3jveI
         16eL8FtjvohY6KXYrdBRfHh+jcKZ4CCKoKwJD7W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 396/800] drm/imx: ipuv3-plane: do not advertise YUV formats on planes without CSC
Date:   Mon, 12 Jul 2021 08:06:59 +0200
Message-Id: <20210712061009.301816533@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 06841148c570832d4d247b0f6befc1922a84120b ]

Only planes that are displayed via the Display Processor (DP) path
support color space conversion. Limit formats on planes that are
shown via the direct Display Controller (DC) path to RGB.

Reported-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-plane.c | 41 ++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-plane.c b/drivers/gpu/drm/imx/ipuv3-plane.c
index fa5009705365..fc8f4834ed7b 100644
--- a/drivers/gpu/drm/imx/ipuv3-plane.c
+++ b/drivers/gpu/drm/imx/ipuv3-plane.c
@@ -35,7 +35,7 @@ static inline struct ipu_plane *to_ipu_plane(struct drm_plane *p)
 	return container_of(p, struct ipu_plane, base);
 }
 
-static const uint32_t ipu_plane_formats[] = {
+static const uint32_t ipu_plane_all_formats[] = {
 	DRM_FORMAT_ARGB1555,
 	DRM_FORMAT_XRGB1555,
 	DRM_FORMAT_ABGR1555,
@@ -72,6 +72,31 @@ static const uint32_t ipu_plane_formats[] = {
 	DRM_FORMAT_BGRX8888_A8,
 };
 
+static const uint32_t ipu_plane_rgb_formats[] = {
+	DRM_FORMAT_ARGB1555,
+	DRM_FORMAT_XRGB1555,
+	DRM_FORMAT_ABGR1555,
+	DRM_FORMAT_XBGR1555,
+	DRM_FORMAT_RGBA5551,
+	DRM_FORMAT_BGRA5551,
+	DRM_FORMAT_ARGB4444,
+	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_ABGR8888,
+	DRM_FORMAT_XBGR8888,
+	DRM_FORMAT_RGBA8888,
+	DRM_FORMAT_RGBX8888,
+	DRM_FORMAT_BGRA8888,
+	DRM_FORMAT_BGRX8888,
+	DRM_FORMAT_RGB565,
+	DRM_FORMAT_RGB565_A8,
+	DRM_FORMAT_BGR565_A8,
+	DRM_FORMAT_RGB888_A8,
+	DRM_FORMAT_BGR888_A8,
+	DRM_FORMAT_RGBX8888_A8,
+	DRM_FORMAT_BGRX8888_A8,
+};
+
 static const uint64_t ipu_format_modifiers[] = {
 	DRM_FORMAT_MOD_LINEAR,
 	DRM_FORMAT_MOD_INVALID
@@ -830,16 +855,24 @@ struct ipu_plane *ipu_plane_init(struct drm_device *dev, struct ipu_soc *ipu,
 	struct ipu_plane *ipu_plane;
 	const uint64_t *modifiers = ipu_format_modifiers;
 	unsigned int zpos = (type == DRM_PLANE_TYPE_PRIMARY) ? 0 : 1;
+	unsigned int format_count;
+	const uint32_t *formats;
 	int ret;
 
 	DRM_DEBUG_KMS("channel %d, dp flow %d, possible_crtcs=0x%x\n",
 		      dma, dp, possible_crtcs);
 
+	if (dp == IPU_DP_FLOW_SYNC_BG || dp == IPU_DP_FLOW_SYNC_FG) {
+		formats = ipu_plane_all_formats;
+		format_count = ARRAY_SIZE(ipu_plane_all_formats);
+	} else {
+		formats = ipu_plane_rgb_formats;
+		format_count = ARRAY_SIZE(ipu_plane_rgb_formats);
+	}
 	ipu_plane = drmm_universal_plane_alloc(dev, struct ipu_plane, base,
 					       possible_crtcs, &ipu_plane_funcs,
-					       ipu_plane_formats,
-					       ARRAY_SIZE(ipu_plane_formats),
-					       modifiers, type, NULL);
+					       formats, format_count, modifiers,
+					       type, NULL);
 	if (IS_ERR(ipu_plane)) {
 		DRM_ERROR("failed to allocate and initialize %s plane\n",
 			  zpos ? "overlay" : "primary");
-- 
2.30.2



