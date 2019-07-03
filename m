Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E8A5CBEB
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfGBICq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbfGBICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:02:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D4E820659;
        Tue,  2 Jul 2019 08:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054562;
        bh=OWxOJS7ubiJHu5iag/U6h3UZbKI9JVC2zcbE7jIac2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+3QsZINlrf2XFt04MMdR2yTEW98XqQCWL7Hrzej+eBqzpa+R9pQ34JGnKqkb4ZbS
         15ucUFUCSsuYIFt1+VYpmwgyBVr8ZwoXQmkjrZsI4O72zXZs04myUjijnhCT6kkN/t
         BPRWxrZEbX3cFCB8SVjUE7swuXCZvLRTHE0hyvgA=
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
Subject: [PATCH 5.1 12/55] drm/i915: Skip modeset for cdclk changes if possible
Date:   Tue,  2 Jul 2019 10:01:20 +0200
Message-Id: <20190702080124.659364060@linuxfoundation.org>
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

commit 59f9e9cab3a1e6762fb707d0d829b982930f1349 upstream.

If we have only a single active pipe and the cdclk change only requires
the cd2x divider to be updated bxt+ can do the update with forcing a full
modeset on the pipe. Try to hook that up.

v2:
- Wait for vblank after an optimized CDCLK change.
- Avoid optimization if the pipe needs a modeset (or was disabled).
- Split CDCLK change to a pre/post plane update step.
v3:
- Use correct version of CDCLK state as old state. (Ville)
- Remove unused intel_cdclk_can_skip_modeset()
v4:
- For consistency call intel_set_cdclk_post_plane_update() only during
  modesets (and not fastsets).
v5:
- Remove the logic to update the CD2X divider on-the-fly on ICL, since
  only a divider of 1 is supported there. Clint also noticed that the
  pipe select bits in CDCLK_CTL are oddly defined on ICL, it's not clear
  yet whether that's only an error in the specification.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Abhay Kumar <abhay.kumar@intel.com>
Tested-by: Abhay Kumar <abhay.kumar@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Clint Taylor <Clinton.A.Taylor@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190327101321.3095-1-imre.deak@intel.com
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.h      |    3 
 drivers/gpu/drm/i915/intel_cdclk.c   |  135 +++++++++++++++++++++++++++--------
 drivers/gpu/drm/i915/intel_display.c |   42 ++++++++++
 drivers/gpu/drm/i915/intel_drv.h     |   17 +++-
 4 files changed, 163 insertions(+), 34 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -280,7 +280,8 @@ struct drm_i915_display_funcs {
 	void (*get_cdclk)(struct drm_i915_private *dev_priv,
 			  struct intel_cdclk_state *cdclk_state);
 	void (*set_cdclk)(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state);
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe);
 	int (*get_fifo_size)(struct drm_i915_private *dev_priv,
 			     enum i9xx_plane_id i9xx_plane);
 	int (*compute_pipe_wm)(struct intel_crtc_state *cstate);
--- a/drivers/gpu/drm/i915/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/intel_cdclk.c
@@ -516,7 +516,8 @@ static void vlv_program_pfi_credits(stru
 }
 
 static void vlv_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	u32 val, cmd = cdclk_state->voltage_level;
@@ -598,7 +599,8 @@ static void vlv_set_cdclk(struct drm_i91
 }
 
 static void chv_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	u32 val, cmd = cdclk_state->voltage_level;
@@ -697,7 +699,8 @@ static void bdw_get_cdclk(struct drm_i91
 }
 
 static void bdw_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	u32 val;
@@ -987,7 +990,8 @@ static void skl_dpll0_disable(struct drm
 }
 
 static void skl_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	int vco = cdclk_state->vco;
@@ -1158,7 +1162,7 @@ void skl_init_cdclk(struct drm_i915_priv
 	cdclk_state.cdclk = skl_calc_cdclk(0, cdclk_state.vco);
 	cdclk_state.voltage_level = skl_calc_voltage_level(cdclk_state.cdclk);
 
-	skl_set_cdclk(dev_priv, &cdclk_state);
+	skl_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 /**
@@ -1176,7 +1180,7 @@ void skl_uninit_cdclk(struct drm_i915_pr
 	cdclk_state.vco = 0;
 	cdclk_state.voltage_level = skl_calc_voltage_level(cdclk_state.cdclk);
 
-	skl_set_cdclk(dev_priv, &cdclk_state);
+	skl_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 static int bxt_calc_cdclk(int min_cdclk)
@@ -1355,7 +1359,8 @@ static void bxt_de_pll_enable(struct drm
 }
 
 static void bxt_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	int vco = cdclk_state->vco;
@@ -1408,11 +1413,10 @@ static void bxt_set_cdclk(struct drm_i91
 		bxt_de_pll_enable(dev_priv, vco);
 
 	val = divider | skl_cdclk_decimal(cdclk);
-	/*
-	 * FIXME if only the cd2x divider needs changing, it could be done
-	 * without shutting off the pipe (if only one pipe is active).
-	 */
-	val |= BXT_CDCLK_CD2X_PIPE_NONE;
+	if (pipe == INVALID_PIPE)
+		val |= BXT_CDCLK_CD2X_PIPE_NONE;
+	else
+		val |= BXT_CDCLK_CD2X_PIPE(pipe);
 	/*
 	 * Disable SSA Precharge when CD clock frequency < 500 MHz,
 	 * enable otherwise.
@@ -1421,6 +1425,9 @@ static void bxt_set_cdclk(struct drm_i91
 		val |= BXT_CDCLK_SSA_PRECHARGE_ENABLE;
 	I915_WRITE(CDCLK_CTL, val);
 
+	if (pipe != INVALID_PIPE)
+		intel_wait_for_vblank(dev_priv, pipe);
+
 	mutex_lock(&dev_priv->pcu_lock);
 	/*
 	 * The timeout isn't specified, the 2ms used here is based on
@@ -1525,7 +1532,7 @@ void bxt_init_cdclk(struct drm_i915_priv
 	}
 	cdclk_state.voltage_level = bxt_calc_voltage_level(cdclk_state.cdclk);
 
-	bxt_set_cdclk(dev_priv, &cdclk_state);
+	bxt_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 /**
@@ -1543,7 +1550,7 @@ void bxt_uninit_cdclk(struct drm_i915_pr
 	cdclk_state.vco = 0;
 	cdclk_state.voltage_level = bxt_calc_voltage_level(cdclk_state.cdclk);
 
-	bxt_set_cdclk(dev_priv, &cdclk_state);
+	bxt_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 static int cnl_calc_cdclk(int min_cdclk)
@@ -1663,7 +1670,8 @@ static void cnl_cdclk_pll_enable(struct
 }
 
 static void cnl_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	int vco = cdclk_state->vco;
@@ -1704,13 +1712,15 @@ static void cnl_set_cdclk(struct drm_i91
 		cnl_cdclk_pll_enable(dev_priv, vco);
 
 	val = divider | skl_cdclk_decimal(cdclk);
-	/*
-	 * FIXME if only the cd2x divider needs changing, it could be done
-	 * without shutting off the pipe (if only one pipe is active).
-	 */
-	val |= BXT_CDCLK_CD2X_PIPE_NONE;
+	if (pipe == INVALID_PIPE)
+		val |= BXT_CDCLK_CD2X_PIPE_NONE;
+	else
+		val |= BXT_CDCLK_CD2X_PIPE(pipe);
 	I915_WRITE(CDCLK_CTL, val);
 
+	if (pipe != INVALID_PIPE)
+		intel_wait_for_vblank(dev_priv, pipe);
+
 	/* inform PCU of the change */
 	mutex_lock(&dev_priv->pcu_lock);
 	sandybridge_pcode_write(dev_priv, SKL_PCODE_CDCLK_CONTROL,
@@ -1847,7 +1857,8 @@ static int icl_calc_cdclk_pll_vco(struct
 }
 
 static void icl_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	unsigned int cdclk = cdclk_state->cdclk;
 	unsigned int vco = cdclk_state->vco;
@@ -1872,6 +1883,11 @@ static void icl_set_cdclk(struct drm_i91
 	if (dev_priv->cdclk.hw.vco != vco)
 		cnl_cdclk_pll_enable(dev_priv, vco);
 
+	/*
+	 * On ICL CD2X_DIV can only be 1, so we'll never end up changing the
+	 * divider here synchronized to a pipe while CDCLK is on, nor will we
+	 * need the corresponding vblank wait.
+	 */
 	I915_WRITE(CDCLK_CTL, ICL_CDCLK_CD2X_PIPE_NONE |
 			      skl_cdclk_decimal(cdclk));
 
@@ -2002,7 +2018,7 @@ sanitize:
 	sanitized_state.voltage_level =
 				icl_calc_voltage_level(sanitized_state.cdclk);
 
-	icl_set_cdclk(dev_priv, &sanitized_state);
+	icl_set_cdclk(dev_priv, &sanitized_state, INVALID_PIPE);
 }
 
 /**
@@ -2020,7 +2036,7 @@ void icl_uninit_cdclk(struct drm_i915_pr
 	cdclk_state.vco = 0;
 	cdclk_state.voltage_level = icl_calc_voltage_level(cdclk_state.cdclk);
 
-	icl_set_cdclk(dev_priv, &cdclk_state);
+	icl_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 /**
@@ -2048,7 +2064,7 @@ void cnl_init_cdclk(struct drm_i915_priv
 	cdclk_state.vco = cnl_cdclk_pll_vco(dev_priv, cdclk_state.cdclk);
 	cdclk_state.voltage_level = cnl_calc_voltage_level(cdclk_state.cdclk);
 
-	cnl_set_cdclk(dev_priv, &cdclk_state);
+	cnl_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 /**
@@ -2066,7 +2082,7 @@ void cnl_uninit_cdclk(struct drm_i915_pr
 	cdclk_state.vco = 0;
 	cdclk_state.voltage_level = cnl_calc_voltage_level(cdclk_state.cdclk);
 
-	cnl_set_cdclk(dev_priv, &cdclk_state);
+	cnl_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 /**
@@ -2086,6 +2102,27 @@ bool intel_cdclk_needs_modeset(const str
 }
 
 /**
+ * intel_cdclk_needs_cd2x_update - Determine if two CDCLK states require a cd2x divider update
+ * @a: first CDCLK state
+ * @b: second CDCLK state
+ *
+ * Returns:
+ * True if the CDCLK states require just a cd2x divider update, false if not.
+ */
+bool intel_cdclk_needs_cd2x_update(struct drm_i915_private *dev_priv,
+				   const struct intel_cdclk_state *a,
+				   const struct intel_cdclk_state *b)
+{
+	/* Older hw doesn't have the capability */
+	if (INTEL_GEN(dev_priv) < 10 && !IS_GEN9_LP(dev_priv))
+		return false;
+
+	return a->cdclk != b->cdclk &&
+		a->vco == b->vco &&
+		a->ref == b->ref;
+}
+
+/**
  * intel_cdclk_changed - Determine if two CDCLK states are different
  * @a: first CDCLK state
  * @b: second CDCLK state
@@ -2133,12 +2170,14 @@ void intel_dump_cdclk_state(const struct
  * intel_set_cdclk - Push the CDCLK state to the hardware
  * @dev_priv: i915 device
  * @cdclk_state: new CDCLK state
+ * @pipe: pipe with which to synchronize the update
  *
  * Program the hardware based on the passed in CDCLK state,
  * if necessary.
  */
-void intel_set_cdclk(struct drm_i915_private *dev_priv,
-		     const struct intel_cdclk_state *cdclk_state)
+static void intel_set_cdclk(struct drm_i915_private *dev_priv,
+			    const struct intel_cdclk_state *cdclk_state,
+			    enum pipe pipe)
 {
 	if (!intel_cdclk_changed(&dev_priv->cdclk.hw, cdclk_state))
 		return;
@@ -2148,7 +2187,7 @@ void intel_set_cdclk(struct drm_i915_pri
 
 	intel_dump_cdclk_state(cdclk_state, "Changing CDCLK to");
 
-	dev_priv->display.set_cdclk(dev_priv, cdclk_state);
+	dev_priv->display.set_cdclk(dev_priv, cdclk_state, pipe);
 
 	if (WARN(intel_cdclk_changed(&dev_priv->cdclk.hw, cdclk_state),
 		 "cdclk state doesn't match!\n")) {
@@ -2157,6 +2196,46 @@ void intel_set_cdclk(struct drm_i915_pri
 	}
 }
 
+/**
+ * intel_set_cdclk_pre_plane_update - Push the CDCLK state to the hardware
+ * @dev_priv: i915 device
+ * @old_state: old CDCLK state
+ * @new_state: new CDCLK state
+ * @pipe: pipe with which to synchronize the update
+ *
+ * Program the hardware before updating the HW plane state based on the passed
+ * in CDCLK state, if necessary.
+ */
+void
+intel_set_cdclk_pre_plane_update(struct drm_i915_private *dev_priv,
+				 const struct intel_cdclk_state *old_state,
+				 const struct intel_cdclk_state *new_state,
+				 enum pipe pipe)
+{
+	if (pipe == INVALID_PIPE || old_state->cdclk <= new_state->cdclk)
+		intel_set_cdclk(dev_priv, new_state, pipe);
+}
+
+/**
+ * intel_set_cdclk_post_plane_update - Push the CDCLK state to the hardware
+ * @dev_priv: i915 device
+ * @old_state: old CDCLK state
+ * @new_state: new CDCLK state
+ * @pipe: pipe with which to synchronize the update
+ *
+ * Program the hardware after updating the HW plane state based on the passed
+ * in CDCLK state, if necessary.
+ */
+void
+intel_set_cdclk_post_plane_update(struct drm_i915_private *dev_priv,
+				  const struct intel_cdclk_state *old_state,
+				  const struct intel_cdclk_state *new_state,
+				  enum pipe pipe)
+{
+	if (pipe != INVALID_PIPE && old_state->cdclk > new_state->cdclk)
+		intel_set_cdclk(dev_priv, new_state, pipe);
+}
+
 static int intel_pixel_rate_to_cdclk(struct drm_i915_private *dev_priv,
 				     int pixel_rate)
 {
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -12779,6 +12779,7 @@ static int intel_modeset_checks(struct d
 	intel_state->active_crtcs = dev_priv->active_crtcs;
 	intel_state->cdclk.logical = dev_priv->cdclk.logical;
 	intel_state->cdclk.actual = dev_priv->cdclk.actual;
+	intel_state->cdclk.pipe = INVALID_PIPE;
 
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
 		if (new_crtc_state->active)
@@ -12798,6 +12799,8 @@ static int intel_modeset_checks(struct d
 	 * adjusted_mode bits in the crtc directly.
 	 */
 	if (dev_priv->display.modeset_calc_cdclk) {
+		enum pipe pipe;
+
 		ret = dev_priv->display.modeset_calc_cdclk(state);
 		if (ret < 0)
 			return ret;
@@ -12814,12 +12817,36 @@ static int intel_modeset_checks(struct d
 				return ret;
 		}
 
+		if (is_power_of_2(intel_state->active_crtcs)) {
+			struct drm_crtc *crtc;
+			struct drm_crtc_state *crtc_state;
+
+			pipe = ilog2(intel_state->active_crtcs);
+			crtc = &intel_get_crtc_for_pipe(dev_priv, pipe)->base;
+			crtc_state = drm_atomic_get_new_crtc_state(state, crtc);
+			if (crtc_state && needs_modeset(crtc_state))
+				pipe = INVALID_PIPE;
+		} else {
+			pipe = INVALID_PIPE;
+		}
+
 		/* All pipes must be switched off while we change the cdclk. */
-		if (intel_cdclk_needs_modeset(&dev_priv->cdclk.actual,
-					      &intel_state->cdclk.actual)) {
+		if (pipe != INVALID_PIPE &&
+		    intel_cdclk_needs_cd2x_update(dev_priv,
+						  &dev_priv->cdclk.actual,
+						  &intel_state->cdclk.actual)) {
+			ret = intel_lock_all_pipes(state);
+			if (ret < 0)
+				return ret;
+
+			intel_state->cdclk.pipe = pipe;
+		} else if (intel_cdclk_needs_modeset(&dev_priv->cdclk.actual,
+						     &intel_state->cdclk.actual)) {
 			ret = intel_modeset_all_pipes(state);
 			if (ret < 0)
 				return ret;
+
+			intel_state->cdclk.pipe = INVALID_PIPE;
 		}
 
 		DRM_DEBUG_KMS("New cdclk calculated to be logical %u kHz, actual %u kHz\n",
@@ -13251,7 +13278,10 @@ static void intel_atomic_commit_tail(str
 	if (intel_state->modeset) {
 		drm_atomic_helper_update_legacy_modeset_state(state->dev, state);
 
-		intel_set_cdclk(dev_priv, &dev_priv->cdclk.actual);
+		intel_set_cdclk_pre_plane_update(dev_priv,
+						 &intel_state->cdclk.actual,
+						 &dev_priv->cdclk.actual,
+						 intel_state->cdclk.pipe);
 
 		/*
 		 * SKL workaround: bspec recommends we disable the SAGV when we
@@ -13280,6 +13310,12 @@ static void intel_atomic_commit_tail(str
 	/* Now enable the clocks, plane, pipe, and connectors that we set up. */
 	dev_priv->display.update_crtcs(state);
 
+	if (intel_state->modeset)
+		intel_set_cdclk_post_plane_update(dev_priv,
+						  &intel_state->cdclk.actual,
+						  &dev_priv->cdclk.actual,
+						  intel_state->cdclk.pipe);
+
 	/* FIXME: We should call drm_atomic_helper_commit_hw_done() here
 	 * already, but still need the state for the delayed optimization. To
 	 * fix this:
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -483,6 +483,8 @@ struct intel_atomic_state {
 
 		int force_min_cdclk;
 		bool force_min_cdclk_changed;
+		/* pipe to which cd2x update is synchronized */
+		enum pipe pipe;
 	} cdclk;
 
 	bool dpll_set, modeset;
@@ -1593,13 +1595,24 @@ void intel_init_cdclk_hooks(struct drm_i
 void intel_update_max_cdclk(struct drm_i915_private *dev_priv);
 void intel_update_cdclk(struct drm_i915_private *dev_priv);
 void intel_update_rawclk(struct drm_i915_private *dev_priv);
+bool intel_cdclk_needs_cd2x_update(struct drm_i915_private *dev_priv,
+				   const struct intel_cdclk_state *a,
+				   const struct intel_cdclk_state *b);
 bool intel_cdclk_needs_modeset(const struct intel_cdclk_state *a,
 			       const struct intel_cdclk_state *b);
 bool intel_cdclk_changed(const struct intel_cdclk_state *a,
 			 const struct intel_cdclk_state *b);
 void intel_cdclk_swap_state(struct intel_atomic_state *state);
-void intel_set_cdclk(struct drm_i915_private *dev_priv,
-		     const struct intel_cdclk_state *cdclk_state);
+void
+intel_set_cdclk_pre_plane_update(struct drm_i915_private *dev_priv,
+				 const struct intel_cdclk_state *old_state,
+				 const struct intel_cdclk_state *new_state,
+				 enum pipe pipe);
+void
+intel_set_cdclk_post_plane_update(struct drm_i915_private *dev_priv,
+				  const struct intel_cdclk_state *old_state,
+				  const struct intel_cdclk_state *new_state,
+				  enum pipe pipe);
 void intel_dump_cdclk_state(const struct intel_cdclk_state *cdclk_state,
 			    const char *context);
 


