Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F30F4E570
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 12:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfFUKI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 06:08:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35293 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfFUKI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 06:08:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id d126so3364043pfd.2
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 03:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4SPraGDzclWuT3efoUm3xPe2MzB92ZDV2QWTPxmM3UY=;
        b=mUQe6fO4dQs2IRacKAZnFOuphu2px+DxSp+EGUUO7MmLNoT3+GpD9MosgZ6a51ddsW
         ScjNHd7BMsw5xrMXrYl490RqKBgwLd5F/ix97P2E6wojS9WHN4CGQw32DeY9oiXMRhTk
         Zd/1INUZeW/q5BCDGdPEzswohCE1N4JLoUbMICDb2+Z+bvx9N0B3Xg80qibgH3NaX2z4
         FLeAy5TxUlAdOIda9E76uq6z6rHJ2UMrcib2Mn7shd3VgsqTpK0RHlihfhF/ICH7mSsS
         GbYVS72z0522e4m//4w5yfCuFpbemkTMIce2OAewIdg3sK7X0O1w5RY34WZO7PcuRH6l
         vFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4SPraGDzclWuT3efoUm3xPe2MzB92ZDV2QWTPxmM3UY=;
        b=gOIwIwzOGYBKibsRCH56fOb1tVbRtbKgVBidqKZ7WaDd2DuzdfTU9abEBvcm7rTH0a
         1jO7Yxk9CFReUjL+BkJVW36h0FORPMusb/Fg+Byife7N7k0GNjau9dzMl5r7VtgMBZPf
         Rt52wnOkOkcivNtVXdw2OHjfwfGEJ/ysyxIv2AvVs9hd5bRfBH0x9sZilYKnLtmBmtAC
         OonGqPn58h4VV5+f/mI8g6LHGlwUcg1Q7v6EnKbcka1WIacWwxnuWFpkr74tiwmHA4+5
         GCN3+GfRY1JbTfYp5lELYQ90G4z4H6mJyv7OhXxB8myZVL7rmJQ41GvMBZ73821OG7xZ
         NbKw==
X-Gm-Message-State: APjAAAWpG9pIB6tHTuTLkeosx0ltsmv1WxuSKY+Nk5xlFsfBXZKwUE4W
        bv1YwLWnBOEIgne9dU7HEbL6wg==
X-Google-Smtp-Source: APXvYqzY5X6LsMNazOflDJ4Au52HpWQ8yXtBqElxh02B58Iy+FZVwYOwbtQNTemkFqz3olezOEeoUA==
X-Received: by 2002:a17:90a:1d8:: with SMTP id 24mr5689192pjd.70.1561111706677;
        Fri, 21 Jun 2019 03:08:26 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id c18sm2246892pfc.180.2019.06.21.03.08.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 03:08:26 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>, tiwai@suse.de,
        hui.wang@canonical.com, linux@endlessm.com,
        Clint Taylor <Clinton.A.Taylor@intel.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH stable-5.1 v2 4/4] drm/i915: Skip modeset for cdclk changes if possible
Date:   Fri, 21 Jun 2019 18:07:17 +0800
Message-Id: <20190621100716.8032-5-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190621100716.8032-1-jian-hong@endlessm.com>
References: <20190620141949.GD9832@kroah.com>
 <20190621100716.8032-1-jian-hong@endlessm.com>
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
Cc: <stable@vger.kernel.org> # 5.1.x
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
---
 drivers/gpu/drm/i915/i915_drv.h      |   3 +-
 drivers/gpu/drm/i915/intel_cdclk.c   | 135 +++++++++++++++++++++------
 drivers/gpu/drm/i915/intel_display.c |  42 ++++++++-
 drivers/gpu/drm/i915/intel_drv.h     |  17 +++-
 4 files changed, 163 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 5c9bb1b2d1f3..0c4a76bca5c6 100644
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
diff --git a/drivers/gpu/drm/i915/intel_cdclk.c b/drivers/gpu/drm/i915/intel_cdclk.c
index 9814a6f2b3c4..00f76261924c 100644
--- a/drivers/gpu/drm/i915/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/intel_cdclk.c
@@ -516,7 +516,8 @@ static void vlv_program_pfi_credits(struct drm_i915_private *dev_priv)
 }
 
 static void vlv_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	u32 val, cmd = cdclk_state->voltage_level;
@@ -598,7 +599,8 @@ static void vlv_set_cdclk(struct drm_i915_private *dev_priv,
 }
 
 static void chv_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	u32 val, cmd = cdclk_state->voltage_level;
@@ -697,7 +699,8 @@ static void bdw_get_cdclk(struct drm_i915_private *dev_priv,
 }
 
 static void bdw_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	u32 val;
@@ -987,7 +990,8 @@ static void skl_dpll0_disable(struct drm_i915_private *dev_priv)
 }
 
 static void skl_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	int vco = cdclk_state->vco;
@@ -1158,7 +1162,7 @@ void skl_init_cdclk(struct drm_i915_private *dev_priv)
 	cdclk_state.cdclk = skl_calc_cdclk(0, cdclk_state.vco);
 	cdclk_state.voltage_level = skl_calc_voltage_level(cdclk_state.cdclk);
 
-	skl_set_cdclk(dev_priv, &cdclk_state);
+	skl_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 /**
@@ -1176,7 +1180,7 @@ void skl_uninit_cdclk(struct drm_i915_private *dev_priv)
 	cdclk_state.vco = 0;
 	cdclk_state.voltage_level = skl_calc_voltage_level(cdclk_state.cdclk);
 
-	skl_set_cdclk(dev_priv, &cdclk_state);
+	skl_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 static int bxt_calc_cdclk(int min_cdclk)
@@ -1355,7 +1359,8 @@ static void bxt_de_pll_enable(struct drm_i915_private *dev_priv, int vco)
 }
 
 static void bxt_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	int vco = cdclk_state->vco;
@@ -1408,11 +1413,10 @@ static void bxt_set_cdclk(struct drm_i915_private *dev_priv,
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
@@ -1421,6 +1425,9 @@ static void bxt_set_cdclk(struct drm_i915_private *dev_priv,
 		val |= BXT_CDCLK_SSA_PRECHARGE_ENABLE;
 	I915_WRITE(CDCLK_CTL, val);
 
+	if (pipe != INVALID_PIPE)
+		intel_wait_for_vblank(dev_priv, pipe);
+
 	mutex_lock(&dev_priv->pcu_lock);
 	/*
 	 * The timeout isn't specified, the 2ms used here is based on
@@ -1525,7 +1532,7 @@ void bxt_init_cdclk(struct drm_i915_private *dev_priv)
 	}
 	cdclk_state.voltage_level = bxt_calc_voltage_level(cdclk_state.cdclk);
 
-	bxt_set_cdclk(dev_priv, &cdclk_state);
+	bxt_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 /**
@@ -1543,7 +1550,7 @@ void bxt_uninit_cdclk(struct drm_i915_private *dev_priv)
 	cdclk_state.vco = 0;
 	cdclk_state.voltage_level = bxt_calc_voltage_level(cdclk_state.cdclk);
 
-	bxt_set_cdclk(dev_priv, &cdclk_state);
+	bxt_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 static int cnl_calc_cdclk(int min_cdclk)
@@ -1663,7 +1670,8 @@ static void cnl_cdclk_pll_enable(struct drm_i915_private *dev_priv, int vco)
 }
 
 static void cnl_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	int cdclk = cdclk_state->cdclk;
 	int vco = cdclk_state->vco;
@@ -1704,13 +1712,15 @@ static void cnl_set_cdclk(struct drm_i915_private *dev_priv,
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
@@ -1847,7 +1857,8 @@ static int icl_calc_cdclk_pll_vco(struct drm_i915_private *dev_priv, int cdclk)
 }
 
 static void icl_set_cdclk(struct drm_i915_private *dev_priv,
-			  const struct intel_cdclk_state *cdclk_state)
+			  const struct intel_cdclk_state *cdclk_state,
+			  enum pipe pipe)
 {
 	unsigned int cdclk = cdclk_state->cdclk;
 	unsigned int vco = cdclk_state->vco;
@@ -1872,6 +1883,11 @@ static void icl_set_cdclk(struct drm_i915_private *dev_priv,
 	if (dev_priv->cdclk.hw.vco != vco)
 		cnl_cdclk_pll_enable(dev_priv, vco);
 
+	/*
+	 * On ICL CD2X_DIV can only be 1, so we'll never end up changing the
+	 * divider here synchronized to a pipe while CDCLK is on, nor will we
+	 * need the corresponding vblank wait.
+	 */
 	I915_WRITE(CDCLK_CTL, ICL_CDCLK_CD2X_PIPE_NONE |
 			      skl_cdclk_decimal(cdclk));
 
@@ -2002,7 +2018,7 @@ void icl_init_cdclk(struct drm_i915_private *dev_priv)
 	sanitized_state.voltage_level =
 				icl_calc_voltage_level(sanitized_state.cdclk);
 
-	icl_set_cdclk(dev_priv, &sanitized_state);
+	icl_set_cdclk(dev_priv, &sanitized_state, INVALID_PIPE);
 }
 
 /**
@@ -2020,7 +2036,7 @@ void icl_uninit_cdclk(struct drm_i915_private *dev_priv)
 	cdclk_state.vco = 0;
 	cdclk_state.voltage_level = icl_calc_voltage_level(cdclk_state.cdclk);
 
-	icl_set_cdclk(dev_priv, &cdclk_state);
+	icl_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 /**
@@ -2048,7 +2064,7 @@ void cnl_init_cdclk(struct drm_i915_private *dev_priv)
 	cdclk_state.vco = cnl_cdclk_pll_vco(dev_priv, cdclk_state.cdclk);
 	cdclk_state.voltage_level = cnl_calc_voltage_level(cdclk_state.cdclk);
 
-	cnl_set_cdclk(dev_priv, &cdclk_state);
+	cnl_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 /**
@@ -2066,7 +2082,7 @@ void cnl_uninit_cdclk(struct drm_i915_private *dev_priv)
 	cdclk_state.vco = 0;
 	cdclk_state.voltage_level = cnl_calc_voltage_level(cdclk_state.cdclk);
 
-	cnl_set_cdclk(dev_priv, &cdclk_state);
+	cnl_set_cdclk(dev_priv, &cdclk_state, INVALID_PIPE);
 }
 
 /**
@@ -2085,6 +2101,27 @@ bool intel_cdclk_needs_modeset(const struct intel_cdclk_state *a,
 		a->ref != b->ref;
 }
 
+/**
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
 /**
  * intel_cdclk_changed - Determine if two CDCLK states are different
  * @a: first CDCLK state
@@ -2133,12 +2170,14 @@ void intel_dump_cdclk_state(const struct intel_cdclk_state *cdclk_state,
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
@@ -2148,7 +2187,7 @@ void intel_set_cdclk(struct drm_i915_private *dev_priv,
 
 	intel_dump_cdclk_state(cdclk_state, "Changing CDCLK to");
 
-	dev_priv->display.set_cdclk(dev_priv, cdclk_state);
+	dev_priv->display.set_cdclk(dev_priv, cdclk_state, pipe);
 
 	if (WARN(intel_cdclk_changed(&dev_priv->cdclk.hw, cdclk_state),
 		 "cdclk state doesn't match!\n")) {
@@ -2157,6 +2196,46 @@ void intel_set_cdclk(struct drm_i915_private *dev_priv,
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
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index d8fabe4643d9..d7c05c7750ae 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -12782,6 +12782,7 @@ static int intel_modeset_checks(struct drm_atomic_state *state)
 	intel_state->active_crtcs = dev_priv->active_crtcs;
 	intel_state->cdclk.logical = dev_priv->cdclk.logical;
 	intel_state->cdclk.actual = dev_priv->cdclk.actual;
+	intel_state->cdclk.pipe = INVALID_PIPE;
 
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
 		if (new_crtc_state->active)
@@ -12801,6 +12802,8 @@ static int intel_modeset_checks(struct drm_atomic_state *state)
 	 * adjusted_mode bits in the crtc directly.
 	 */
 	if (dev_priv->display.modeset_calc_cdclk) {
+		enum pipe pipe;
+
 		ret = dev_priv->display.modeset_calc_cdclk(state);
 		if (ret < 0)
 			return ret;
@@ -12817,12 +12820,36 @@ static int intel_modeset_checks(struct drm_atomic_state *state)
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
@@ -13231,7 +13258,10 @@ static void intel_atomic_commit_tail(struct drm_atomic_state *state)
 	if (intel_state->modeset) {
 		drm_atomic_helper_update_legacy_modeset_state(state->dev, state);
 
-		intel_set_cdclk(dev_priv, &dev_priv->cdclk.actual);
+		intel_set_cdclk_pre_plane_update(dev_priv,
+						 &intel_state->cdclk.actual,
+						 &dev_priv->cdclk.actual,
+						 intel_state->cdclk.pipe);
 
 		/*
 		 * SKL workaround: bspec recommends we disable the SAGV when we
@@ -13260,6 +13290,12 @@ static void intel_atomic_commit_tail(struct drm_atomic_state *state)
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
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 2a11dfc28a2a..ceaa05dfa0d0 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -483,6 +483,8 @@ struct intel_atomic_state {
 
 		int force_min_cdclk;
 		bool force_min_cdclk_changed;
+		/* pipe to which cd2x update is synchronized */
+		enum pipe pipe;
 	} cdclk;
 
 	bool dpll_set, modeset;
@@ -1593,13 +1595,24 @@ void intel_init_cdclk_hooks(struct drm_i915_private *dev_priv);
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
 
-- 
2.22.0

