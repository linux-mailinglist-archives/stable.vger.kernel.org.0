Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B5317FD68
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgCJMxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729264AbgCJMxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:53:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B14524697;
        Tue, 10 Mar 2020 12:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844829;
        bh=giPWIFLQhTb6fRSCPcpAHBBR+/snKGVAA2zAzJK+Kp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6Ga7n90UgAfWedMSCYIoDqeZ66fXaNAgJ1crlD4W4YuP2gr580JcHN6gXan+LGFa
         qeqI5b83+EpJNGQrFn9Ztanrfw+GcXr978QK860XjCauGpWLzf/WR6ymjxWiLiWlAm
         LnPmKbVMAcgwRLmvGJJobFTIGOFodi/yEwgm6MWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>
Subject: [PATCH 5.4 134/168] drm/sun4i: de2/de3: Remove unsupported VI layer formats
Date:   Tue, 10 Mar 2020 13:39:40 +0100
Message-Id: <20200310123649.070610186@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

commit a4769905f0ae32cae4f096f646ab03b8b4794c74 upstream.

YUV444 and YVU444 are planar formats, but HW format RGB888 is packed.
This means that those two mappings were never correct. Remove them.

Fixes: 60a3dcf96aa8 ("drm/sun4i: Add DE2 definitions for YUV formats")
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20200224173901.174016-2-jernej.skrabec@siol.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/sun4i/sun8i_mixer.c    |   12 ------------
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c |    2 --
 2 files changed, 14 deletions(-)

--- a/drivers/gpu/drm/sun4i/sun8i_mixer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_mixer.c
@@ -277,12 +277,6 @@ static const struct de2_fmt_info de2_for
 		.csc = SUN8I_CSC_MODE_YUV2RGB,
 	},
 	{
-		.drm_fmt = DRM_FORMAT_YUV444,
-		.de2_fmt = SUN8I_MIXER_FBFMT_RGB888,
-		.rgb = true,
-		.csc = SUN8I_CSC_MODE_YUV2RGB,
-	},
-	{
 		.drm_fmt = DRM_FORMAT_YUV422,
 		.de2_fmt = SUN8I_MIXER_FBFMT_YUV422,
 		.rgb = false,
@@ -301,12 +295,6 @@ static const struct de2_fmt_info de2_for
 		.csc = SUN8I_CSC_MODE_YUV2RGB,
 	},
 	{
-		.drm_fmt = DRM_FORMAT_YVU444,
-		.de2_fmt = SUN8I_MIXER_FBFMT_RGB888,
-		.rgb = true,
-		.csc = SUN8I_CSC_MODE_YVU2RGB,
-	},
-	{
 		.drm_fmt = DRM_FORMAT_YVU422,
 		.de2_fmt = SUN8I_MIXER_FBFMT_YUV422,
 		.rgb = false,
--- a/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
@@ -431,11 +431,9 @@ static const u32 sun8i_vi_layer_formats[
 	DRM_FORMAT_YUV411,
 	DRM_FORMAT_YUV420,
 	DRM_FORMAT_YUV422,
-	DRM_FORMAT_YUV444,
 	DRM_FORMAT_YVU411,
 	DRM_FORMAT_YVU420,
 	DRM_FORMAT_YVU422,
-	DRM_FORMAT_YVU444,
 };
 
 static const u32 sun8i_vi_layer_de3_formats[] = {


