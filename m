Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC9CE0C0C
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 20:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732509AbfJVS4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 14:56:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:59250 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731740AbfJVS4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Oct 2019 14:56:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 11:56:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,217,1569308400"; 
   d="scan'208";a="197208822"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga007.fm.intel.com with SMTP; 22 Oct 2019 11:56:44 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 22 Oct 2019 21:56:43 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Andrija <akijo97@gmail.com>
Subject: [PATCH] drm/i915: Fix PCH reference clock for FDI on HSW/BDW
Date:   Tue, 22 Oct 2019 21:56:43 +0300
Message-Id: <20191022185643.1483-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The change to skip the PCH reference initialization during fastboot
did end up breaking FDI. To fix that let's try to do the PCH reference
init whenever we're disabling a DPLL that was using said reference
previously.

Cc: stable@vger.kernel.org
Tested-by: Andrija <akijo97@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=112084
Fixes: b16c7ed95caf ("drm/i915: Do not touch the PCH SSC reference if a PLL is using it")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_display.c  | 11 ++++++-----
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c | 15 +++++++++++++++
 drivers/gpu/drm/i915/i915_drv.h               |  2 ++
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 236fdf122e47..da76f794a965 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -9359,7 +9359,6 @@ static bool wrpll_uses_pch_ssc(struct drm_i915_private *dev_priv,
 static void lpt_init_pch_refclk(struct drm_i915_private *dev_priv)
 {
 	struct intel_encoder *encoder;
-	bool pch_ssc_in_use = false;
 	bool has_fdi = false;
 
 	for_each_intel_encoder(&dev_priv->drm, encoder) {
@@ -9387,22 +9386,24 @@ static void lpt_init_pch_refclk(struct drm_i915_private *dev_priv)
 	 * clock hierarchy. That would also allow us to do
 	 * clock bending finally.
 	 */
+	dev_priv->pch_ssc_use = 0;
+
 	if (spll_uses_pch_ssc(dev_priv)) {
 		DRM_DEBUG_KMS("SPLL using PCH SSC\n");
-		pch_ssc_in_use = true;
+		dev_priv->pch_ssc_use |= BIT(DPLL_ID_SPLL);
 	}
 
 	if (wrpll_uses_pch_ssc(dev_priv, DPLL_ID_WRPLL1)) {
 		DRM_DEBUG_KMS("WRPLL1 using PCH SSC\n");
-		pch_ssc_in_use = true;
+		dev_priv->pch_ssc_use |= BIT(DPLL_ID_WRPLL1);
 	}
 
 	if (wrpll_uses_pch_ssc(dev_priv, DPLL_ID_WRPLL2)) {
 		DRM_DEBUG_KMS("WRPLL2 using PCH SSC\n");
-		pch_ssc_in_use = true;
+		dev_priv->pch_ssc_use |= BIT(DPLL_ID_WRPLL2);
 	}
 
-	if (pch_ssc_in_use)
+	if (dev_priv->pch_ssc_use)
 		return;
 
 	if (has_fdi) {
diff --git a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
index ec10fa7d3c69..3ce0a023eee0 100644
--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -526,16 +526,31 @@ static void hsw_ddi_wrpll_disable(struct drm_i915_private *dev_priv,
 	val = I915_READ(WRPLL_CTL(id));
 	I915_WRITE(WRPLL_CTL(id), val & ~WRPLL_PLL_ENABLE);
 	POSTING_READ(WRPLL_CTL(id));
+
+	/*
+	 * Try to set up the PCH reference clock once all DPLLs
+	 * that depend on it have been shut down.
+	 */
+	if (dev_priv->pch_ssc_use & BIT(id))
+		intel_init_pch_refclk(dev_priv);
 }
 
 static void hsw_ddi_spll_disable(struct drm_i915_private *dev_priv,
 				 struct intel_shared_dpll *pll)
 {
+	enum intel_dpll_id id = pll->info->id;
 	u32 val;
 
 	val = I915_READ(SPLL_CTL);
 	I915_WRITE(SPLL_CTL, val & ~SPLL_PLL_ENABLE);
 	POSTING_READ(SPLL_CTL);
+
+	/*
+	 * Try to set up the PCH reference clock once all DPLLs
+	 * that depend on it have been shut down.
+	 */
+	if (dev_priv->pch_ssc_use & BIT(id))
+		intel_init_pch_refclk(dev_priv);
 }
 
 static bool hsw_ddi_wrpll_get_hw_state(struct drm_i915_private *dev_priv,
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 8882c0908c3b..5332825e0ce4 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1348,6 +1348,8 @@ struct drm_i915_private {
 		} contexts;
 	} gem;
 
+	u8 pch_ssc_use;
+
 	/* For i915gm/i945gm vblank irq workaround */
 	u8 vblank_enabled;
 
-- 
2.21.0

