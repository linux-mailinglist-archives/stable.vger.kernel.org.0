Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522A517FB8F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731752AbgCJNPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731967AbgCJNPC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:15:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EACA7208E4;
        Tue, 10 Mar 2020 13:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846101;
        bh=hMgyNO9SwxdpDdXHi0vUFQ4xNWHFHxVSSKacno0+8aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYVtdVe+Rc+0w1ipiG+3Tc8Zj3Vr6NngmdJr0RxCg0dL/Y+mwnIytUYG0bJe/NZcj
         jNJha1XZhqr+sJkzwi6s9WUXNbX1wpmjvArLrbCTCBruxLAXtUeU0ORSDUBHXLBK24
         FN1uxw3b0Gmvxuwszg2xgEiKfz/5BzE6WgGWAz9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>
Subject: [PATCH 4.19 69/86] drm/sun4i: de2/de3: Remove unsupported VI layer formats
Date:   Tue, 10 Mar 2020 13:45:33 +0100
Message-Id: <20200310124534.502971450@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
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
@@ -257,12 +257,6 @@ static const struct de2_fmt_info de2_for
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
@@ -281,12 +275,6 @@ static const struct de2_fmt_info de2_for
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
@@ -363,11 +363,9 @@ static const u32 sun8i_vi_layer_formats[
 	DRM_FORMAT_YUV411,
 	DRM_FORMAT_YUV420,
 	DRM_FORMAT_YUV422,
-	DRM_FORMAT_YUV444,
 	DRM_FORMAT_YVU411,
 	DRM_FORMAT_YVU420,
 	DRM_FORMAT_YVU422,
-	DRM_FORMAT_YVU444,
 };
 
 struct sun8i_vi_layer *sun8i_vi_layer_init_one(struct drm_device *drm,


