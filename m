Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DA1420F73
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbhJDNe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237172AbhJDNdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:33:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54E2E61BA5;
        Mon,  4 Oct 2021 13:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353291;
        bh=6EsxzmryHjfkatAodB7A/kelLMtV/Zo6OI6kY/nZSi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNv2O6/Zt7dG2h3jxrIA8saJNIeSwwmdfFtXRKF+jkvSRyx2w+zAYA7w8uMjRWe1Y
         YyIipcZY0XEvTbY5OOmRv+ueKrR+AmSA1sRjP37+9dxwhuP3owjKnqKxgmqPDix2Tv
         UIvtX+17cNI0axvzcrj9U0V4rGALwFFumNocr0G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Subject: [PATCH 5.14 071/172] drm/amdgpu: check tiling flags when creating FB on GFX8-
Date:   Mon,  4 Oct 2021 14:52:01 +0200
Message-Id: <20211004125047.289306191@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

commit 98122e63a7ecc08c4172a17d97a06ef5536eb268 upstream.

On GFX9+, format modifiers are always enabled and ensure the
frame-buffers can be scanned out at ADDFB2 time.

On GFX8-, format modifiers are not supported and no other check
is performed. This means ADDFB2 IOCTLs will succeed even if the
tiling isn't supported for scan-out, and will result in garbage
displayed on screen [1].

Fix this by adding a check for tiling flags for GFX8 and older.
The check is taken from radeonsi in Mesa (see how is_displayable
is populated in gfx6_compute_surface).

Changes in v2: use drm_WARN_ONCE instead of drm_WARN (Michel)

[1]: https://github.com/swaywm/wlroots/issues/3185

Signed-off-by: Simon Ser <contact@emersion.fr>
Acked-by: Michel Dänzer <mdaenzer@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Cc: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c |   31 ++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -837,6 +837,28 @@ static int convert_tiling_flags_to_modif
 	return 0;
 }
 
+/* Mirrors the is_displayable check in radeonsi's gfx6_compute_surface */
+static int check_tiling_flags_gfx6(struct amdgpu_framebuffer *afb)
+{
+	u64 micro_tile_mode;
+
+	/* Zero swizzle mode means linear */
+	if (AMDGPU_TILING_GET(afb->tiling_flags, SWIZZLE_MODE) == 0)
+		return 0;
+
+	micro_tile_mode = AMDGPU_TILING_GET(afb->tiling_flags, MICRO_TILE_MODE);
+	switch (micro_tile_mode) {
+	case 0: /* DISPLAY */
+	case 3: /* RENDER */
+		return 0;
+	default:
+		drm_dbg_kms(afb->base.dev,
+			    "Micro tile mode %llu not supported for scanout\n",
+			    micro_tile_mode);
+		return -EINVAL;
+	}
+}
+
 static void get_block_dimensions(unsigned int block_log2, unsigned int cpp,
 				 unsigned int *width, unsigned int *height)
 {
@@ -1103,6 +1125,7 @@ int amdgpu_display_framebuffer_init(stru
 				    const struct drm_mode_fb_cmd2 *mode_cmd,
 				    struct drm_gem_object *obj)
 {
+	struct amdgpu_device *adev = drm_to_adev(dev);
 	int ret, i;
 
 	/*
@@ -1122,6 +1145,14 @@ int amdgpu_display_framebuffer_init(stru
 	if (ret)
 		return ret;
 
+	if (!dev->mode_config.allow_fb_modifiers) {
+		drm_WARN_ONCE(dev, adev->family >= AMDGPU_FAMILY_AI,
+			      "GFX9+ requires FB check based on format modifier\n");
+		ret = check_tiling_flags_gfx6(rfb);
+		if (ret)
+			return ret;
+	}
+
 	if (dev->mode_config.allow_fb_modifiers &&
 	    !(rfb->base.flags & DRM_MODE_FB_MODIFIERS)) {
 		ret = convert_tiling_flags_to_modifier(rfb);


