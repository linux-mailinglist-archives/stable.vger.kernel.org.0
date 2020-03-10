Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC3E17FA0B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgCJNCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbgCJNCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:02:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78AF32468F;
        Tue, 10 Mar 2020 13:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845336;
        bh=hYvlEhsu2VBzrFXY5oOYRyECZtpv8QkOW6M+2w6acDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8M23eI31ah3j7I7eqFRwDfajnJ152LQf5bEZ5TsfKe83ALv+FojzgaZoA1yuWkk3
         Vtn3wX4h3v6Pp4pAwiqOnCA2mj1qrBnBhx3pogvHmYgZjmVLoDcmemMYawnWfgZ7yd
         ySnqYhV7q4MD/ymnoa/m6bMI+in05oVOfC+5SjGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>
Subject: [PATCH 5.5 145/189] drm/sun4i: Add separate DE3 VI layer formats
Date:   Tue, 10 Mar 2020 13:39:42 +0100
Message-Id: <20200310123654.503963050@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

commit 169ca4b38932112e8b2ee8baef9cea44678625b3 upstream.

DE3 VI layers support alpha blending, but DE2 VI layers do not.
Additionally, DE3 VI layers support 10-bit RGB and YUV formats.

Make a separate list for DE3.

Fixes: c50519e6db4d ("drm/sun4i: Add basic support for DE3")
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20200224173901.174016-3-jernej.skrabec@siol.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/sun4i/sun8i_mixer.c    |   36 ++++++++++++++++++++
 drivers/gpu/drm/sun4i/sun8i_mixer.h    |   11 ++++++
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c |   58 +++++++++++++++++++++++++++++++--
 3 files changed, 102 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/sun4i/sun8i_mixer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_mixer.c
@@ -149,6 +149,30 @@ static const struct de2_fmt_info de2_for
 		.csc = SUN8I_CSC_MODE_OFF,
 	},
 	{
+		.drm_fmt = DRM_FORMAT_ARGB2101010,
+		.de2_fmt = SUN8I_MIXER_FBFMT_ARGB2101010,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
+		.drm_fmt = DRM_FORMAT_ABGR2101010,
+		.de2_fmt = SUN8I_MIXER_FBFMT_ABGR2101010,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
+		.drm_fmt = DRM_FORMAT_RGBA1010102,
+		.de2_fmt = SUN8I_MIXER_FBFMT_RGBA1010102,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
+		.drm_fmt = DRM_FORMAT_BGRA1010102,
+		.de2_fmt = SUN8I_MIXER_FBFMT_BGRA1010102,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
 		.drm_fmt = DRM_FORMAT_UYVY,
 		.de2_fmt = SUN8I_MIXER_FBFMT_UYVY,
 		.rgb = false,
@@ -244,6 +268,18 @@ static const struct de2_fmt_info de2_for
 		.rgb = false,
 		.csc = SUN8I_CSC_MODE_YVU2RGB,
 	},
+	{
+		.drm_fmt = DRM_FORMAT_P010,
+		.de2_fmt = SUN8I_MIXER_FBFMT_P010_YUV,
+		.rgb = false,
+		.csc = SUN8I_CSC_MODE_YUV2RGB,
+	},
+	{
+		.drm_fmt = DRM_FORMAT_P210,
+		.de2_fmt = SUN8I_MIXER_FBFMT_P210_YUV,
+		.rgb = false,
+		.csc = SUN8I_CSC_MODE_YUV2RGB,
+	},
 };
 
 const struct de2_fmt_info *sun8i_mixer_format_info(u32 format)
--- a/drivers/gpu/drm/sun4i/sun8i_mixer.h
+++ b/drivers/gpu/drm/sun4i/sun8i_mixer.h
@@ -93,6 +93,10 @@
 #define SUN8I_MIXER_FBFMT_ABGR1555	17
 #define SUN8I_MIXER_FBFMT_RGBA5551	18
 #define SUN8I_MIXER_FBFMT_BGRA5551	19
+#define SUN8I_MIXER_FBFMT_ARGB2101010	20
+#define SUN8I_MIXER_FBFMT_ABGR2101010	21
+#define SUN8I_MIXER_FBFMT_RGBA1010102	22
+#define SUN8I_MIXER_FBFMT_BGRA1010102	23
 
 #define SUN8I_MIXER_FBFMT_YUYV		0
 #define SUN8I_MIXER_FBFMT_UYVY		1
@@ -109,6 +113,13 @@
 /* format 12 is semi-planar YUV411 UVUV */
 /* format 13 is semi-planar YUV411 VUVU */
 #define SUN8I_MIXER_FBFMT_YUV411	14
+/* format 15 doesn't exist */
+/* format 16 is P010 YVU */
+#define SUN8I_MIXER_FBFMT_P010_YUV	17
+/* format 18 is P210 YVU */
+#define SUN8I_MIXER_FBFMT_P210_YUV	19
+/* format 20 is packed YVU444 10-bit */
+/* format 21 is packed YUV444 10-bit */
 
 /*
  * Sub-engines listed bellow are unused for now. The EN registers are here only
--- a/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
@@ -438,24 +438,76 @@ static const u32 sun8i_vi_layer_formats[
 	DRM_FORMAT_YVU444,
 };
 
+static const u32 sun8i_vi_layer_de3_formats[] = {
+	DRM_FORMAT_ABGR1555,
+	DRM_FORMAT_ABGR2101010,
+	DRM_FORMAT_ABGR4444,
+	DRM_FORMAT_ABGR8888,
+	DRM_FORMAT_ARGB1555,
+	DRM_FORMAT_ARGB2101010,
+	DRM_FORMAT_ARGB4444,
+	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_BGR565,
+	DRM_FORMAT_BGR888,
+	DRM_FORMAT_BGRA1010102,
+	DRM_FORMAT_BGRA5551,
+	DRM_FORMAT_BGRA4444,
+	DRM_FORMAT_BGRA8888,
+	DRM_FORMAT_BGRX8888,
+	DRM_FORMAT_RGB565,
+	DRM_FORMAT_RGB888,
+	DRM_FORMAT_RGBA1010102,
+	DRM_FORMAT_RGBA4444,
+	DRM_FORMAT_RGBA5551,
+	DRM_FORMAT_RGBA8888,
+	DRM_FORMAT_RGBX8888,
+	DRM_FORMAT_XBGR8888,
+	DRM_FORMAT_XRGB8888,
+
+	DRM_FORMAT_NV16,
+	DRM_FORMAT_NV12,
+	DRM_FORMAT_NV21,
+	DRM_FORMAT_NV61,
+	DRM_FORMAT_P010,
+	DRM_FORMAT_P210,
+	DRM_FORMAT_UYVY,
+	DRM_FORMAT_VYUY,
+	DRM_FORMAT_YUYV,
+	DRM_FORMAT_YVYU,
+	DRM_FORMAT_YUV411,
+	DRM_FORMAT_YUV420,
+	DRM_FORMAT_YUV422,
+	DRM_FORMAT_YVU411,
+	DRM_FORMAT_YVU420,
+	DRM_FORMAT_YVU422,
+};
+
 struct sun8i_vi_layer *sun8i_vi_layer_init_one(struct drm_device *drm,
 					       struct sun8i_mixer *mixer,
 					       int index)
 {
 	u32 supported_encodings, supported_ranges;
+	unsigned int plane_cnt, format_count;
 	struct sun8i_vi_layer *layer;
-	unsigned int plane_cnt;
+	const u32 *formats;
 	int ret;
 
 	layer = devm_kzalloc(drm->dev, sizeof(*layer), GFP_KERNEL);
 	if (!layer)
 		return ERR_PTR(-ENOMEM);
 
+	if (mixer->cfg->is_de3) {
+		formats = sun8i_vi_layer_de3_formats;
+		format_count = ARRAY_SIZE(sun8i_vi_layer_de3_formats);
+	} else {
+		formats = sun8i_vi_layer_formats;
+		format_count = ARRAY_SIZE(sun8i_vi_layer_formats);
+	}
+
 	/* possible crtcs are set later */
 	ret = drm_universal_plane_init(drm, &layer->plane, 0,
 				       &sun8i_vi_layer_funcs,
-				       sun8i_vi_layer_formats,
-				       ARRAY_SIZE(sun8i_vi_layer_formats),
+				       formats, format_count,
 				       NULL, DRM_PLANE_TYPE_OVERLAY, NULL);
 	if (ret) {
 		dev_err(drm->dev, "Couldn't initialize layer\n");


