Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E68721BE88
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 22:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgGJUeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 16:34:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:17989 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgGJUeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 16:34:15 -0400
IronPort-SDR: qb7KGYWh28diyHV1U/NpQ3u8VtMJxnoou2SXHdpt4XXsD53gfZXbE0ySRscCnXqqaJAYosshbj
 xygDnBgayKXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="136484095"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="136484095"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 13:34:11 -0700
IronPort-SDR: fL4KZe1zZTwwyc9VwUjIxVtU4sxlsqDGRvmM7TzgrV7gJr9ttosz7DmVwONen2M1J92dydwvw9
 MhuWMtGgMkXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="389628455"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga001.fm.intel.com with SMTP; 10 Jul 2020 13:34:08 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 10 Jul 2020 23:34:08 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915: Recalculate FBC w/a stride when needed
Date:   Fri, 10 Jul 2020 23:34:08 +0300
Message-Id: <20200710203408.23039-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
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

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_fbc.c | 29 ++++++++++++++++++------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fbc.c b/drivers/gpu/drm/i915/display/intel_fbc.c
index ef2eb14f6157..ff199374ed36 100644
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
@@ -1218,7 +1237,8 @@ void intel_fbc_enable(struct intel_atomic_state *state,
 
 	if (fbc->crtc) {
 		if (fbc->crtc != crtc ||
-		    !intel_fbc_cfb_size_changed(dev_priv))
+		    (!intel_fbc_cfb_size_changed(dev_priv) &&
+		     !intel_fbc_gen9_wa_cfb_stride_changed(dev_priv)))
 			goto out;
 
 		__intel_fbc_disable(dev_priv);
@@ -1240,12 +1260,7 @@ void intel_fbc_enable(struct intel_atomic_state *state,
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
-- 
2.26.2

