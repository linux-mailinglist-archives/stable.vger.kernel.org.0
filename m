Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A455D21C322
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 10:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgGKIDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jul 2020 04:03:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:19962 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728012AbgGKIDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jul 2020 04:03:40 -0400
IronPort-SDR: Rcz0PlFQ8vvY287nVkwtK9q7/cqDxWgiZNXxXSPE5V1YRte0iHosj/IHn7ByX/S9eEN1R46BkD
 3gV632Phm2cw==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="149830584"
X-IronPort-AV: E=Sophos;i="5.75,338,1589266800"; 
   d="scan'208";a="149830584"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2020 01:03:39 -0700
IronPort-SDR: vL2UUlTSfuHGJ0FVwIy2MMGLiDnEPbd5QWfiZkafe1iZlFCgIIkvTp+uFWzk6z6a1kvwW0vAM7
 M/8eeNo0mYQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,338,1589266800"; 
   d="scan'208";a="324929590"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga007.jf.intel.com with SMTP; 11 Jul 2020 01:03:37 -0700
Received: by stinkbox (sSMTP sendmail emulation); Sat, 11 Jul 2020 11:03:36 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2] drm/i915: Recalculate FBC w/a stride when needed
Date:   Sat, 11 Jul 2020 11:03:36 +0300
Message-Id: <20200711080336.13423-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710203408.23039-1-ville.syrjala@linux.intel.com>
References: <20200710203408.23039-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Currently we're failing to recalculate the gen9 FBC w/a stride
unless something more drastic than just the modifier itself has
changed. This often leaves us with FBC enabled with the linear
fbdev framebuffer without the w/a stride enabled. That will cause
an immediate underrun and FBC will get promptly disabled.

Fix the problem by checking if the w/a stride is about to change,
and go through the full dance if so. This part of the FBC code
is still pretty much a disaster and will need lots more work.
But this should at least fix the immediate issue.

v2: Deactivate FBC when the modifier changes since that will
    likely require resetting the w/a CFB stride

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_fbc.c | 33 +++++++++++++++++++-----
 drivers/gpu/drm/i915/i915_drv.h          |  1 +
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fbc.c b/drivers/gpu/drm/i915/display/intel_fbc.c
index ef2eb14f6157..85723fba6002 100644
--- a/drivers/gpu/drm/i915/display/intel_fbc.c
+++ b/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -742,6 +742,25 @@ static bool intel_fbc_cfb_size_changed(struct drm_i915_private *dev_priv)
 		fbc->compressed_fb.size * fbc->threshold;
 }
 
+static u16 intel_fbc_gen9_wa_cfb_stride(struct drm_i915_private *dev_priv)
+{
+	struct intel_fbc *fbc = &dev_priv->fbc;
+	struct intel_fbc_state_cache *cache = &fbc->state_cache;
+
+	if ((IS_GEN9_BC(dev_priv) || IS_BROXTON(dev_priv)) &&
+	    cache->fb.modifier != I915_FORMAT_MOD_X_TILED)
+		return DIV_ROUND_UP(cache->plane.src_w, 32 * fbc->threshold) * 8;
+	else
+		return 0;
+}
+
+static bool intel_fbc_gen9_wa_cfb_stride_changed(struct drm_i915_private *dev_priv)
+{
+	struct intel_fbc *fbc = &dev_priv->fbc;
+
+	return fbc->params.gen9_wa_cfb_stride != intel_fbc_gen9_wa_cfb_stride(dev_priv);
+}
+
 static bool intel_fbc_can_enable(struct drm_i915_private *dev_priv)
 {
 	struct intel_fbc *fbc = &dev_priv->fbc;
@@ -902,6 +921,7 @@ static void intel_fbc_get_reg_params(struct intel_crtc *crtc,
 	params->crtc.i9xx_plane = to_intel_plane(crtc->base.primary)->i9xx_plane;
 
 	params->fb.format = cache->fb.format;
+	params->fb.modifier = cache->fb.modifier;
 	params->fb.stride = cache->fb.stride;
 
 	params->cfb_size = intel_fbc_calculate_cfb_size(dev_priv, cache);
@@ -931,6 +951,9 @@ static bool intel_fbc_can_flip_nuke(const struct intel_crtc_state *crtc_state)
 	if (params->fb.format != cache->fb.format)
 		return false;
 
+	if (params->fb.modifier != cache->fb.modifier)
+		return false;
+
 	if (params->fb.stride != cache->fb.stride)
 		return false;
 
@@ -1218,7 +1241,8 @@ void intel_fbc_enable(struct intel_atomic_state *state,
 
 	if (fbc->crtc) {
 		if (fbc->crtc != crtc ||
-		    !intel_fbc_cfb_size_changed(dev_priv))
+		    (!intel_fbc_cfb_size_changed(dev_priv) &&
+		     !intel_fbc_gen9_wa_cfb_stride_changed(dev_priv)))
 			goto out;
 
 		__intel_fbc_disable(dev_priv);
@@ -1240,12 +1264,7 @@ void intel_fbc_enable(struct intel_atomic_state *state,
 		goto out;
 	}
 
-	if ((IS_GEN9_BC(dev_priv) || IS_BROXTON(dev_priv)) &&
-	    plane_state->hw.fb->modifier != I915_FORMAT_MOD_X_TILED)
-		cache->gen9_wa_cfb_stride =
-			DIV_ROUND_UP(cache->plane.src_w, 32 * fbc->threshold) * 8;
-	else
-		cache->gen9_wa_cfb_stride = 0;
+	cache->gen9_wa_cfb_stride = intel_fbc_gen9_wa_cfb_stride(dev_priv);
 
 	drm_dbg_kms(&dev_priv->drm, "Enabling FBC on pipe %c\n",
 		    pipe_name(crtc->pipe));
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 87973dedf8e7..14b095afab42 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -442,6 +442,7 @@ struct intel_fbc {
 		struct {
 			const struct drm_format_info *format;
 			unsigned int stride;
+			u64 modifier;
 		} fb;
 
 		int cfb_size;
-- 
2.26.2

