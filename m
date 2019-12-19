Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79183126BA9
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbfLSSzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730396AbfLSSzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F12F124679;
        Thu, 19 Dec 2019 18:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781711;
        bh=OqFCLd4WftZqa6i+YaD9py48siWJszgq0jImbq5JZ8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mr5OhWRIrVq16HotMv1lAAhs8N2qNRc6maThsDsahTd7UwkWJj49f0gLZJrgham3z
         2KZFf/oS8sK74/c7ChnvknRU0eOEc86x4Tv23U++kybS6h6g4484fukzG+xuDzgrDR
         AZOjh3ipxo6bY9fVsRsTvuKf9rT38zBeH8AdVO+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH 5.4 50/80] drm: meson: venc: cvbs: fix CVBS mode matching
Date:   Thu, 19 Dec 2019 19:34:42 +0100
Message-Id: <20191219183121.752291356@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit 43cb86799ff03e9819c07f37f72f80f8246ad7ed upstream.

With commit 222ec1618c3ace ("drm: Add aspect ratio parsing in DRM
layer") the drm core started honoring the picture_aspect_ratio field
when comparing two drm_display_modes. Prior to that it was ignored.
When the CVBS encoder driver was initially submitted there was no aspect
ratio check.

Switch from drm_mode_equal() to drm_mode_match() without
DRM_MODE_MATCH_ASPECT_RATIO to fix "kmscube" and X.org output using the
CVBS connector. When (for example) kmscube sets the output mode when
using the CVBS connector it passes HDMI_PICTURE_ASPECT_NONE, making the
drm_mode_equal() fail as it include the aspect ratio.

Prior to this patch kmscube reported:
  failed to set mode: Invalid argument

The CVBS mode checking in the sun4i (drivers/gpu/drm/sun4i/sun4i_tv.c
sun4i_tv_mode_to_drm_mode) and ZTE (drivers/gpu/drm/zte/zx_tvenc.c
tvenc_mode_{pal,ntsc}) drivers don't set the "picture_aspect_ratio" at
all. The Meson VPU driver does not rely on the aspect ratio for the CVBS
output so we can safely decouple it from the hdmi_picture_aspect
setting.

Cc: <stable@vger.kernel.org>
Fixes: 222ec1618c3ace ("drm: Add aspect ratio parsing in DRM layer")
Fixes: bbbe775ec5b5da ("drm: Add support for Amlogic Meson Graphic Controller")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
[narmstrong: squashed with drm: meson: venc: cvbs: deduplicate the meson_cvbs_mode lookup code]
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191208171832.1064772-3-martin.blumenstingl@googlemail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/meson/meson_venc_cvbs.c |   48 ++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 21 deletions(-)

--- a/drivers/gpu/drm/meson/meson_venc_cvbs.c
+++ b/drivers/gpu/drm/meson/meson_venc_cvbs.c
@@ -64,6 +64,25 @@ struct meson_cvbs_mode meson_cvbs_modes[
 	},
 };
 
+static const struct meson_cvbs_mode *
+meson_cvbs_get_mode(const struct drm_display_mode *req_mode)
+{
+	int i;
+
+	for (i = 0; i < MESON_CVBS_MODES_COUNT; ++i) {
+		struct meson_cvbs_mode *meson_mode = &meson_cvbs_modes[i];
+
+		if (drm_mode_match(req_mode, &meson_mode->mode,
+				   DRM_MODE_MATCH_TIMINGS |
+				   DRM_MODE_MATCH_CLOCK |
+				   DRM_MODE_MATCH_FLAGS |
+				   DRM_MODE_MATCH_3D_FLAGS))
+			return meson_mode;
+	}
+
+	return NULL;
+}
+
 /* Connector */
 
 static void meson_cvbs_connector_destroy(struct drm_connector *connector)
@@ -136,14 +155,8 @@ static int meson_venc_cvbs_encoder_atomi
 					struct drm_crtc_state *crtc_state,
 					struct drm_connector_state *conn_state)
 {
-	int i;
-
-	for (i = 0; i < MESON_CVBS_MODES_COUNT; ++i) {
-		struct meson_cvbs_mode *meson_mode = &meson_cvbs_modes[i];
-
-		if (drm_mode_equal(&crtc_state->mode, &meson_mode->mode))
-			return 0;
-	}
+	if (meson_cvbs_get_mode(&crtc_state->mode))
+		return 0;
 
 	return -EINVAL;
 }
@@ -191,24 +204,17 @@ static void meson_venc_cvbs_encoder_mode
 				   struct drm_display_mode *mode,
 				   struct drm_display_mode *adjusted_mode)
 {
+	const struct meson_cvbs_mode *meson_mode = meson_cvbs_get_mode(mode);
 	struct meson_venc_cvbs *meson_venc_cvbs =
 					encoder_to_meson_venc_cvbs(encoder);
 	struct meson_drm *priv = meson_venc_cvbs->priv;
-	int i;
 
-	for (i = 0; i < MESON_CVBS_MODES_COUNT; ++i) {
-		struct meson_cvbs_mode *meson_mode = &meson_cvbs_modes[i];
+	if (meson_mode) {
+		meson_venci_cvbs_mode_set(priv, meson_mode->enci);
 
-		if (drm_mode_equal(mode, &meson_mode->mode)) {
-			meson_venci_cvbs_mode_set(priv,
-						  meson_mode->enci);
-
-			/* Setup 27MHz vclk2 for ENCI and VDAC */
-			meson_vclk_setup(priv, MESON_VCLK_TARGET_CVBS,
-					 MESON_VCLK_CVBS, MESON_VCLK_CVBS,
-					 MESON_VCLK_CVBS, true);
-			break;
-		}
+		/* Setup 27MHz vclk2 for ENCI and VDAC */
+		meson_vclk_setup(priv, MESON_VCLK_TARGET_CVBS, MESON_VCLK_CVBS,
+				 MESON_VCLK_CVBS, MESON_VCLK_CVBS, true);
 	}
 }
 


