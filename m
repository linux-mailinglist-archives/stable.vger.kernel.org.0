Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044E32E4169
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438918AbgL1PGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:06:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438906AbgL1OJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:09:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF71A207A9;
        Mon, 28 Dec 2020 14:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164556;
        bh=yrUpkunsziuQQgjws7/th4KevViFFmMo2wWwfKC5NfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqsPCqlAt+NSCDuHwI7r/d9ZTVM38rHddmfMBkHnPnr9HpAj+KpW2rICKdhS/zE+P
         fTozQXyiJRDr3MoGCgtMfVRFLAkAK43MRSF5VQCKfEpG7TNqt0sO2fCDVn6EeVUYc9
         ic74wWsV69tTTn4hmztuhhV4j2tvKZ0EBV23rQOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/717] drm/imx/dcss: fix rotations for Vivante tiled formats
Date:   Mon, 28 Dec 2020 13:43:27 +0100
Message-Id: <20201228125030.994986948@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>

[ Upstream commit 59cb403f38099506ddbe05fd09126f3f0890860b ]

DCSS supports 90/180/270 degree rotations for Vivante tiled and super-tiled
formats. Unfortunately, with the current code, they didn't work properly.

This simple patch makes the rotations work by fixing the way the scaler is set
up for 90/270 degree rotations. In this particular case, the source width and
height need to be swapped since DPR is sending the buffer to scaler already
rotated.

Also, make sure to allow full rotations for DRM_FORMAT_MOD_VIVANTE_SUPER_TILED.

Fixes: 9021c317b770 ("drm/imx: Add initial support for DCSS on iMX8MQ")
Signed-off-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20201105140127.25249-2-laurentiu.palcu@oss.nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/dcss/dcss-plane.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/imx/dcss/dcss-plane.c b/drivers/gpu/drm/imx/dcss/dcss-plane.c
index 961d671f171b4..f54087ac44d35 100644
--- a/drivers/gpu/drm/imx/dcss/dcss-plane.c
+++ b/drivers/gpu/drm/imx/dcss/dcss-plane.c
@@ -111,7 +111,8 @@ static bool dcss_plane_can_rotate(const struct drm_format_info *format,
 		supported_rotation = DRM_MODE_ROTATE_0 | DRM_MODE_ROTATE_180 |
 				     DRM_MODE_REFLECT_MASK;
 	else if (!format->is_yuv &&
-		 modifier == DRM_FORMAT_MOD_VIVANTE_TILED)
+		 (modifier == DRM_FORMAT_MOD_VIVANTE_TILED ||
+		  modifier == DRM_FORMAT_MOD_VIVANTE_SUPER_TILED))
 		supported_rotation = DRM_MODE_ROTATE_MASK |
 				     DRM_MODE_REFLECT_MASK;
 	else if (format->is_yuv && linear_format &&
@@ -273,6 +274,7 @@ static void dcss_plane_atomic_update(struct drm_plane *plane,
 	u32 src_w, src_h, dst_w, dst_h;
 	struct drm_rect src, dst;
 	bool enable = true;
+	bool is_rotation_90_or_270;
 
 	if (!fb || !state->crtc || !state->visible)
 		return;
@@ -311,8 +313,13 @@ static void dcss_plane_atomic_update(struct drm_plane *plane,
 
 	dcss_plane_atomic_set_base(dcss_plane);
 
+	is_rotation_90_or_270 = state->rotation & (DRM_MODE_ROTATE_90 |
+						   DRM_MODE_ROTATE_270);
+
 	dcss_scaler_setup(dcss->scaler, dcss_plane->ch_num,
-			  state->fb->format, src_w, src_h,
+			  state->fb->format,
+			  is_rotation_90_or_270 ? src_h : src_w,
+			  is_rotation_90_or_270 ? src_w : src_h,
 			  dst_w, dst_h,
 			  drm_mode_vrefresh(&crtc_state->mode));
 
-- 
2.27.0



