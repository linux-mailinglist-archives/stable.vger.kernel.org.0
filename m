Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C7CEEDD8
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390569AbfKDWKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:10:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390188AbfKDWKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:10:37 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5BB920650;
        Mon,  4 Nov 2019 22:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905436;
        bh=K2pzYJ8HddRm03R078tzZkhn6KGzSIfNgPYAnIJfaKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oI3TFQCzo5qVeRRxrh7sHCiRi2xYHzg6hwCxjoHuIt2v0NQYx4Jw8olSEOhS7en5f
         suVHKgLsf73rKQ9/wXgpakHSFcVpcKpZjN+hT3pmme/7vnl/IF8hl54267gUmblSF+
         HFr7ndnRFdaR+s5gbCbOVC12Bf/BhLPKH46afpoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrija <akijo97@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 138/163] drm/i915: Fix PCH reference clock for FDI on HSW/BDW
Date:   Mon,  4 Nov 2019 22:45:28 +0100
Message-Id: <20191104212150.343939389@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 59cd826fb5e7889515bf5771e295e0624c348571 upstream.

The change to skip the PCH reference initialization during fastboot
did end up breaking FDI. To fix that let's try to do the PCH reference
init whenever we're disabling a DPLL that was using said reference
previously.

Cc: stable@vger.kernel.org
Tested-by: Andrija <akijo97@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=112084
Fixes: b16c7ed95caf ("drm/i915: Do not touch the PCH SSC reference if a PLL is using it")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191022185643.1483-1-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit dd5279c71405533d4ddbb9453effc60f0f5bf211)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_display.c  |   11 ++++++-----
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |   15 +++++++++++++++
 drivers/gpu/drm/i915/i915_drv.h               |    2 ++
 3 files changed, 23 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -9186,7 +9186,6 @@ static bool wrpll_uses_pch_ssc(struct dr
 static void lpt_init_pch_refclk(struct drm_i915_private *dev_priv)
 {
 	struct intel_encoder *encoder;
-	bool pch_ssc_in_use = false;
 	bool has_fdi = false;
 
 	for_each_intel_encoder(&dev_priv->drm, encoder) {
@@ -9214,22 +9213,24 @@ static void lpt_init_pch_refclk(struct d
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
--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -498,16 +498,31 @@ static void hsw_ddi_wrpll_disable(struct
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
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1881,6 +1881,8 @@ struct drm_i915_private {
 		struct work_struct idle_work;
 	} gem;
 
+	u8 pch_ssc_use;
+
 	/* For i945gm vblank irq vs. C3 workaround */
 	struct {
 		struct work_struct work;


