Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8703517FA0C
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgCJNCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730388AbgCJNCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:02:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE0622468D;
        Tue, 10 Mar 2020 13:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845339;
        bh=ou0pUy4CoM4F8qZ8BHE3fnxE7lJC8hn0wClkbo6cd38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVhYKKnE7BUUtGmMmTQBw9UsQr3JfcIELVMYoeOPOAn0Mr3aNmx3zczIHOifzp/Ui
         YNydFRViEYSntli9skyfSDENt4iBUN8Yfucql6UG9ZnL/9VmsVpQ31H+FRlGjCXCFz
         oTpn10uBuxH0EnihGQlZHzjjhkmfJogkGs/8hnRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>
Subject: [PATCH 5.5 146/189] drm/sun4i: Fix DE2 VI layer format support
Date:   Tue, 10 Mar 2020 13:39:43 +0100
Message-Id: <20200310123654.602874291@linuxfoundation.org>
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

commit 20896ef137340e9426cf322606f764452f5eb960 upstream.

DE2 VI layer doesn't support blending which means alpha channel is
ignored. Replace all formats with alpha with "don't care" (X) channel.

Fixes: 7480ba4d7571 ("drm/sun4i: Add support for DE2 VI planes")
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20200224173901.174016-4-jernej.skrabec@siol.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/sun4i/sun8i_mixer.c    |   56 +++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c |   22 ++++++------
 2 files changed, 67 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/sun4i/sun8i_mixer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_mixer.c
@@ -107,46 +107,102 @@ static const struct de2_fmt_info de2_for
 		.csc = SUN8I_CSC_MODE_OFF,
 	},
 	{
+		/* for DE2 VI layer which ignores alpha */
+		.drm_fmt = DRM_FORMAT_XRGB4444,
+		.de2_fmt = SUN8I_MIXER_FBFMT_ARGB4444,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
 		.drm_fmt = DRM_FORMAT_ABGR4444,
 		.de2_fmt = SUN8I_MIXER_FBFMT_ABGR4444,
 		.rgb = true,
 		.csc = SUN8I_CSC_MODE_OFF,
 	},
 	{
+		/* for DE2 VI layer which ignores alpha */
+		.drm_fmt = DRM_FORMAT_XBGR4444,
+		.de2_fmt = SUN8I_MIXER_FBFMT_ABGR4444,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
 		.drm_fmt = DRM_FORMAT_RGBA4444,
 		.de2_fmt = SUN8I_MIXER_FBFMT_RGBA4444,
 		.rgb = true,
 		.csc = SUN8I_CSC_MODE_OFF,
 	},
 	{
+		/* for DE2 VI layer which ignores alpha */
+		.drm_fmt = DRM_FORMAT_RGBX4444,
+		.de2_fmt = SUN8I_MIXER_FBFMT_RGBA4444,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
 		.drm_fmt = DRM_FORMAT_BGRA4444,
 		.de2_fmt = SUN8I_MIXER_FBFMT_BGRA4444,
 		.rgb = true,
 		.csc = SUN8I_CSC_MODE_OFF,
 	},
 	{
+		/* for DE2 VI layer which ignores alpha */
+		.drm_fmt = DRM_FORMAT_BGRX4444,
+		.de2_fmt = SUN8I_MIXER_FBFMT_BGRA4444,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
 		.drm_fmt = DRM_FORMAT_ARGB1555,
 		.de2_fmt = SUN8I_MIXER_FBFMT_ARGB1555,
 		.rgb = true,
 		.csc = SUN8I_CSC_MODE_OFF,
 	},
 	{
+		/* for DE2 VI layer which ignores alpha */
+		.drm_fmt = DRM_FORMAT_XRGB1555,
+		.de2_fmt = SUN8I_MIXER_FBFMT_ARGB1555,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
 		.drm_fmt = DRM_FORMAT_ABGR1555,
 		.de2_fmt = SUN8I_MIXER_FBFMT_ABGR1555,
 		.rgb = true,
 		.csc = SUN8I_CSC_MODE_OFF,
 	},
 	{
+		/* for DE2 VI layer which ignores alpha */
+		.drm_fmt = DRM_FORMAT_XBGR1555,
+		.de2_fmt = SUN8I_MIXER_FBFMT_ABGR1555,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
 		.drm_fmt = DRM_FORMAT_RGBA5551,
 		.de2_fmt = SUN8I_MIXER_FBFMT_RGBA5551,
 		.rgb = true,
 		.csc = SUN8I_CSC_MODE_OFF,
 	},
 	{
+		/* for DE2 VI layer which ignores alpha */
+		.drm_fmt = DRM_FORMAT_RGBX5551,
+		.de2_fmt = SUN8I_MIXER_FBFMT_RGBA5551,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
 		.drm_fmt = DRM_FORMAT_BGRA5551,
 		.de2_fmt = SUN8I_MIXER_FBFMT_BGRA5551,
 		.rgb = true,
 		.csc = SUN8I_CSC_MODE_OFF,
+	},
+	{
+		/* for DE2 VI layer which ignores alpha */
+		.drm_fmt = DRM_FORMAT_BGRX5551,
+		.de2_fmt = SUN8I_MIXER_FBFMT_BGRA5551,
+		.rgb = true,
+		.csc = SUN8I_CSC_MODE_OFF,
 	},
 	{
 		.drm_fmt = DRM_FORMAT_ARGB2101010,
--- a/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
@@ -398,26 +398,26 @@ static const struct drm_plane_funcs sun8
 };
 
 /*
- * While all RGB formats are supported, VI planes don't support
- * alpha blending, so there is no point having formats with alpha
- * channel if their opaque analog exist.
+ * While DE2 VI layer supports same RGB formats as UI layer, alpha
+ * channel is ignored. This structure lists all unique variants
+ * where alpha channel is replaced with "don't care" (X) channel.
  */
 static const u32 sun8i_vi_layer_formats[] = {
-	DRM_FORMAT_ABGR1555,
-	DRM_FORMAT_ABGR4444,
-	DRM_FORMAT_ARGB1555,
-	DRM_FORMAT_ARGB4444,
 	DRM_FORMAT_BGR565,
 	DRM_FORMAT_BGR888,
-	DRM_FORMAT_BGRA5551,
-	DRM_FORMAT_BGRA4444,
+	DRM_FORMAT_BGRX4444,
+	DRM_FORMAT_BGRX5551,
 	DRM_FORMAT_BGRX8888,
 	DRM_FORMAT_RGB565,
 	DRM_FORMAT_RGB888,
-	DRM_FORMAT_RGBA4444,
-	DRM_FORMAT_RGBA5551,
+	DRM_FORMAT_RGBX4444,
+	DRM_FORMAT_RGBX5551,
 	DRM_FORMAT_RGBX8888,
+	DRM_FORMAT_XBGR1555,
+	DRM_FORMAT_XBGR4444,
 	DRM_FORMAT_XBGR8888,
+	DRM_FORMAT_XRGB1555,
+	DRM_FORMAT_XRGB4444,
 	DRM_FORMAT_XRGB8888,
 
 	DRM_FORMAT_NV16,


