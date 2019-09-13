Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4EFB210A
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390411AbfIMNbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388894AbfIMNOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:17 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96CF9206BB;
        Fri, 13 Sep 2019 13:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380456;
        bh=dJNcMUrF4d+5ai/nzCp/2wnmvg7jODEbqCsqyHQX1bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAw9N/4h6MxRgW3Gbj1w8YNs1voV1wx019TVeuXEwJbbGv3iE2eQPFsKrDNR70TbO
         6/3QcZCKP16ZvOKKlupJ+osjMPCwHT+kDdzlRJfTt5IdOUCID6rnWi2U6DODQ0mlq5
         tdyxFmjICNa1Ztz+yDOVmcm+AD5vnx4jsTX0rhik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>, ronald@innovation.ch,
        Imre Deak <imre.deak@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/190] drm/i915/gen9+: Fix initial readout for Y tiled framebuffers
Date:   Fri, 13 Sep 2019 14:05:02 +0100
Message-Id: <20190913130603.530686793@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 914a4fd8cd28016038ce749a818a836124a8d270 ]

If BIOS configured a Y tiled FB we failed to set up the backing object
tiling accordingly, leading to a lack of GT fence installed and a
garbled console.

The problem was bisected to
commit 011f22eb545a ("drm/i915: Do NOT skip the first 4k of stolen memory for pre-allocated buffers v2")
but it just revealed a pre-existing issue.

Kudos to Ville who suspected a missing fence looking at the corruption
on the screen.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: <ronald@innovation.ch>
Cc: <stable@vger.kernel.org>
Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reported-by: <ronald@innovation.ch>
Tested-by: <ronald@innovation.ch>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=108264
Fixes: bc8d7dffacb1 ("drm/i915/skl: Provide a Skylake version of get_plane_config()")
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20181016160011.28347-1-imre.deak@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_display.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index f5367bdc04049..2622dfc7d2d9a 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2712,6 +2712,17 @@ intel_alloc_initial_plane_obj(struct intel_crtc *crtc,
 	if (size_aligned * 2 > dev_priv->stolen_usable_size)
 		return false;
 
+	switch (fb->modifier) {
+	case DRM_FORMAT_MOD_LINEAR:
+	case I915_FORMAT_MOD_X_TILED:
+	case I915_FORMAT_MOD_Y_TILED:
+		break;
+	default:
+		DRM_DEBUG_DRIVER("Unsupported modifier for initial FB: 0x%llx\n",
+				 fb->modifier);
+		return false;
+	}
+
 	mutex_lock(&dev->struct_mutex);
 	obj = i915_gem_object_create_stolen_for_preallocated(dev_priv,
 							     base_aligned,
@@ -2721,8 +2732,17 @@ intel_alloc_initial_plane_obj(struct intel_crtc *crtc,
 	if (!obj)
 		return false;
 
-	if (plane_config->tiling == I915_TILING_X)
-		obj->tiling_and_stride = fb->pitches[0] | I915_TILING_X;
+	switch (plane_config->tiling) {
+	case I915_TILING_NONE:
+		break;
+	case I915_TILING_X:
+	case I915_TILING_Y:
+		obj->tiling_and_stride = fb->pitches[0] | plane_config->tiling;
+		break;
+	default:
+		MISSING_CASE(plane_config->tiling);
+		return false;
+	}
 
 	mode_cmd.pixel_format = fb->format->format;
 	mode_cmd.width = fb->width;
@@ -8812,6 +8832,7 @@ skylake_get_initial_plane_config(struct intel_crtc *crtc,
 		fb->modifier = I915_FORMAT_MOD_X_TILED;
 		break;
 	case PLANE_CTL_TILED_Y:
+		plane_config->tiling = I915_TILING_Y;
 		if (val & PLANE_CTL_RENDER_DECOMPRESSION_ENABLE)
 			fb->modifier = I915_FORMAT_MOD_Y_TILED_CCS;
 		else
-- 
2.20.1



