Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E17B5CA6E
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfGBIEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbfGBIEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:04:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE14F21479;
        Tue,  2 Jul 2019 08:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054640;
        bh=g2Khj+G+F5O8KplQF5b239p5OEDAi7vYj6z0uVqr6Rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TirxbjBuB6muPaVaCQGgF8+O6hTLg3ku8InPzm0rUYz8RhufKW0GMu1Anap7v2lv5
         r0kGnSx8uM9LJjIj60AQuU2rf/5r6jtCVgjglLok8LErgf7Xqn8Y/9zAvEb6Gvt3ml
         7XD26EQ79++ynm5jWjYicpSJ+HX46UfYjOWrhwGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Clint Taylor <Clinton.A.Taylor@intel.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH 5.1 09/55] drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio power is enabled
Date:   Tue,  2 Jul 2019 10:01:17 +0200
Message-Id: <20190702080124.514060132@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 905801fe72377b4dc53c6e13eea1a91c6a4aa0c4 upstream.

CDCLK has to be at least twice the BLCK regardless of audio. Audio
driver has to probe using this hook and increase the clock even in
absence of any display.

v2: Use atomic refcount for get_power, put_power so that we can
    call each once(Abhay).
v3: Reset power well 2 to avoid any transaction on iDisp link
    during cdclk change(Abhay).
v4: Remove Power well 2 reset workaround(Ville).
v5: Remove unwanted Power well 2 register defined in v4(Abhay).
v6:
- Use a dedicated flag instead of state->modeset for min CDCLK changes
- Make get/put audio power domain symmetric
- Rebased on top of intel_wakeref tracking changes.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Abhay Kumar <abhay.kumar@intel.com>
Tested-by: Abhay Kumar <abhay.kumar@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Clint Taylor <Clinton.A.Taylor@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190320135439.12201-1-imre.deak@intel.com
Cc: <stable@vger.kernel.org> # 5.1.x
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=203623
Buglink: https://bugs.freedesktop.org/show_bug.cgi?id=110916
Link: https://www.spinics.net/lists/stable/msg310910.html
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_drv.h      |    3 +
 drivers/gpu/drm/i915/intel_audio.c   |   62 +++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/i915/intel_cdclk.c   |   30 +++++-----------
 drivers/gpu/drm/i915/intel_display.c |    9 ++++-
 drivers/gpu/drm/i915/intel_drv.h     |    3 +
 5 files changed, 83 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1622,6 +1622,8 @@ struct drm_i915_private {
 		struct intel_cdclk_state actual;
 		/* The current hardware cdclk state */
 		struct intel_cdclk_state hw;
+
+		int force_min_cdclk;
 	} cdclk;
 
 	/**
@@ -1741,6 +1743,7 @@ struct drm_i915_private {
 	 *
 	 */
 	struct mutex av_mutex;
+	int audio_power_refcount;
 
 	struct {
 		struct mutex mutex;
--- a/drivers/gpu/drm/i915/intel_audio.c
+++ b/drivers/gpu/drm/i915/intel_audio.c
@@ -741,15 +741,71 @@ void intel_init_audio_hooks(struct drm_i
 	}
 }
 
+static void glk_force_audio_cdclk(struct drm_i915_private *dev_priv,
+				  bool enable)
+{
+	struct drm_modeset_acquire_ctx ctx;
+	struct drm_atomic_state *state;
+	int ret;
+
+	drm_modeset_acquire_init(&ctx, 0);
+	state = drm_atomic_state_alloc(&dev_priv->drm);
+	if (WARN_ON(!state))
+		return;
+
+	state->acquire_ctx = &ctx;
+
+retry:
+	to_intel_atomic_state(state)->cdclk.force_min_cdclk_changed = true;
+	to_intel_atomic_state(state)->cdclk.force_min_cdclk =
+		enable ? 2 * 96000 : 0;
+
+	/*
+	 * Protects dev_priv->cdclk.force_min_cdclk
+	 * Need to lock this here in case we have no active pipes
+	 * and thus wouldn't lock it during the commit otherwise.
+	 */
+	ret = drm_modeset_lock(&dev_priv->drm.mode_config.connection_mutex,
+			       &ctx);
+	if (!ret)
+		ret = drm_atomic_commit(state);
+
+	if (ret == -EDEADLK) {
+		drm_atomic_state_clear(state);
+		drm_modeset_backoff(&ctx);
+		goto retry;
+	}
+
+	WARN_ON(ret);
+
+	drm_atomic_state_put(state);
+
+	drm_modeset_drop_locks(&ctx);
+	drm_modeset_acquire_fini(&ctx);
+}
+
 static void i915_audio_component_get_power(struct device *kdev)
 {
-	intel_display_power_get(kdev_to_i915(kdev), POWER_DOMAIN_AUDIO);
+	struct drm_i915_private *dev_priv = kdev_to_i915(kdev);
+
+	intel_display_power_get(dev_priv, POWER_DOMAIN_AUDIO);
+
+	/* Force CDCLK to 2*BCLK as long as we need audio to be powered. */
+	if (dev_priv->audio_power_refcount++ == 0)
+		if (IS_CANNONLAKE(dev_priv) || IS_GEMINILAKE(dev_priv))
+			glk_force_audio_cdclk(dev_priv, true);
 }
 
 static void i915_audio_component_put_power(struct device *kdev)
 {
-	intel_display_power_put_unchecked(kdev_to_i915(kdev),
-					  POWER_DOMAIN_AUDIO);
+	struct drm_i915_private *dev_priv = kdev_to_i915(kdev);
+
+	/* Stop forcing CDCLK to 2*BCLK if no need for audio to be powered. */
+	if (--dev_priv->audio_power_refcount == 0)
+		if (IS_CANNONLAKE(dev_priv) || IS_GEMINILAKE(dev_priv))
+			glk_force_audio_cdclk(dev_priv, false);
+
+	intel_display_power_put_unchecked(dev_priv, POWER_DOMAIN_AUDIO);
 }
 
 static void i915_audio_component_codec_wake_override(struct device *kdev,
--- a/drivers/gpu/drm/i915/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/intel_cdclk.c
@@ -2187,19 +2187,8 @@ int intel_crtc_compute_min_cdclk(const s
 	/*
 	 * According to BSpec, "The CD clock frequency must be at least twice
 	 * the frequency of the Azalia BCLK." and BCLK is 96 MHz by default.
-	 *
-	 * FIXME: Check the actual, not default, BCLK being used.
-	 *
-	 * FIXME: This does not depend on ->has_audio because the higher CDCLK
-	 * is required for audio probe, also when there are no audio capable
-	 * displays connected at probe time. This leads to unnecessarily high
-	 * CDCLK when audio is not required.
-	 *
-	 * FIXME: This limit is only applied when there are displays connected
-	 * at probe time. If we probe without displays, we'll still end up using
-	 * the platform minimum CDCLK, failing audio probe.
 	 */
-	if (INTEL_GEN(dev_priv) >= 9)
+	if (crtc_state->has_audio && INTEL_GEN(dev_priv) >= 9)
 		min_cdclk = max(2 * 96000, min_cdclk);
 
 	/*
@@ -2239,7 +2228,7 @@ static int intel_compute_min_cdclk(struc
 		intel_state->min_cdclk[i] = min_cdclk;
 	}
 
-	min_cdclk = 0;
+	min_cdclk = intel_state->cdclk.force_min_cdclk;
 	for_each_pipe(dev_priv, pipe)
 		min_cdclk = max(intel_state->min_cdclk[pipe], min_cdclk);
 
@@ -2300,7 +2289,8 @@ static int vlv_modeset_calc_cdclk(struct
 		vlv_calc_voltage_level(dev_priv, cdclk);
 
 	if (!intel_state->active_crtcs) {
-		cdclk = vlv_calc_cdclk(dev_priv, 0);
+		cdclk = vlv_calc_cdclk(dev_priv,
+				       intel_state->cdclk.force_min_cdclk);
 
 		intel_state->cdclk.actual.cdclk = cdclk;
 		intel_state->cdclk.actual.voltage_level =
@@ -2333,7 +2323,7 @@ static int bdw_modeset_calc_cdclk(struct
 		bdw_calc_voltage_level(cdclk);
 
 	if (!intel_state->active_crtcs) {
-		cdclk = bdw_calc_cdclk(0);
+		cdclk = bdw_calc_cdclk(intel_state->cdclk.force_min_cdclk);
 
 		intel_state->cdclk.actual.cdclk = cdclk;
 		intel_state->cdclk.actual.voltage_level =
@@ -2405,7 +2395,7 @@ static int skl_modeset_calc_cdclk(struct
 		skl_calc_voltage_level(cdclk);
 
 	if (!intel_state->active_crtcs) {
-		cdclk = skl_calc_cdclk(0, vco);
+		cdclk = skl_calc_cdclk(intel_state->cdclk.force_min_cdclk, vco);
 
 		intel_state->cdclk.actual.vco = vco;
 		intel_state->cdclk.actual.cdclk = cdclk;
@@ -2444,10 +2434,10 @@ static int bxt_modeset_calc_cdclk(struct
 
 	if (!intel_state->active_crtcs) {
 		if (IS_GEMINILAKE(dev_priv)) {
-			cdclk = glk_calc_cdclk(0);
+			cdclk = glk_calc_cdclk(intel_state->cdclk.force_min_cdclk);
 			vco = glk_de_pll_vco(dev_priv, cdclk);
 		} else {
-			cdclk = bxt_calc_cdclk(0);
+			cdclk = bxt_calc_cdclk(intel_state->cdclk.force_min_cdclk);
 			vco = bxt_de_pll_vco(dev_priv, cdclk);
 		}
 
@@ -2483,7 +2473,7 @@ static int cnl_modeset_calc_cdclk(struct
 		    cnl_compute_min_voltage_level(intel_state));
 
 	if (!intel_state->active_crtcs) {
-		cdclk = cnl_calc_cdclk(0);
+		cdclk = cnl_calc_cdclk(intel_state->cdclk.force_min_cdclk);
 		vco = cnl_cdclk_pll_vco(dev_priv, cdclk);
 
 		intel_state->cdclk.actual.vco = vco;
@@ -2519,7 +2509,7 @@ static int icl_modeset_calc_cdclk(struct
 		    cnl_compute_min_voltage_level(intel_state));
 
 	if (!intel_state->active_crtcs) {
-		cdclk = icl_calc_cdclk(0, ref);
+		cdclk = icl_calc_cdclk(intel_state->cdclk.force_min_cdclk, ref);
 		vco = icl_calc_cdclk_pll_vco(dev_priv, cdclk);
 
 		intel_state->cdclk.actual.vco = vco;
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -12770,6 +12770,11 @@ static int intel_modeset_checks(struct d
 		return -EINVAL;
 	}
 
+	/* keep the current setting */
+	if (!intel_state->cdclk.force_min_cdclk_changed)
+		intel_state->cdclk.force_min_cdclk =
+			dev_priv->cdclk.force_min_cdclk;
+
 	intel_state->modeset = true;
 	intel_state->active_crtcs = dev_priv->active_crtcs;
 	intel_state->cdclk.logical = dev_priv->cdclk.logical;
@@ -12892,7 +12897,7 @@ static int intel_atomic_check(struct drm
 	struct drm_crtc *crtc;
 	struct drm_crtc_state *old_crtc_state, *crtc_state;
 	int ret, i;
-	bool any_ms = false;
+	bool any_ms = intel_state->cdclk.force_min_cdclk_changed;
 
 	/* Catch I915_MODE_FLAG_INHERITED */
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state,
@@ -13480,6 +13485,8 @@ static int intel_atomic_commit(struct dr
 		dev_priv->active_crtcs = intel_state->active_crtcs;
 		dev_priv->cdclk.logical = intel_state->cdclk.logical;
 		dev_priv->cdclk.actual = intel_state->cdclk.actual;
+		dev_priv->cdclk.force_min_cdclk =
+			intel_state->cdclk.force_min_cdclk;
 	}
 
 	drm_atomic_state_get(state);
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -480,6 +480,9 @@ struct intel_atomic_state {
 		 * state only when all crtc's are DPMS off.
 		 */
 		struct intel_cdclk_state actual;
+
+		int force_min_cdclk;
+		bool force_min_cdclk_changed;
 	} cdclk;
 
 	bool dpll_set, modeset;


