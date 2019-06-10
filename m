Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0733AEE0
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 08:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387788AbfFJGEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 02:04:05 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37258 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387724AbfFJGEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 02:04:04 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so3796977pfa.4
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 23:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h1DrgLY1vsB0iuTaawRlV6zaV5AF4PM9Jzji7ikOSPM=;
        b=A2Adz8t3mxoFeH4xwvkWj+wN1nvkC96H1H+fXh41EALRay9ulBe6Tut2kCt8hZQR74
         3h78BPAuN5p5R1uBqJd8OVwGZyTt9lPV0NKWwvr3WHipgnuEXw26E+rY3t2O7yT5y4iy
         e6SxmZ/iUzSTty39Mr2weUBpdZN6/fAIheWt81t0hdoDvNcyB97zroW7O9hP+W1ePlq0
         qrsyR6SYvuEkdr15990MFoKJ2hp/CURtEXjap5gNJB1nWqvHWI5lZoWy7nz4id5S1YjL
         bK5o6onNerZ5IXb6Hocn8SlH0jtbwVCsZcAxtDf3GVsQGaAXu8II+5xOvjI8bguXfmMR
         MiYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h1DrgLY1vsB0iuTaawRlV6zaV5AF4PM9Jzji7ikOSPM=;
        b=dzZ/44SkJ8v7boFv86YfyDHut2iAdQOJwLxKM8swnP8y04jddQepHrxNJF/FpwtJ6H
         g2RdMiQ9Uy9KgNFMJ3g/6wm1s3YSRJ/vppOjquIMvqb6T/XaLXvP2WNQu4cVIeeuLTWT
         hrx8odBMYRaAEo/eueSJ4j5ju8v3iNwVRUN3y81d3AoUSJOjr86Q0fIkbuKkAijBx72K
         56Uuwsa9036R45ySZcA7U6Zmh1OBeoTzEPQYjdhlhDjD6GeZtWgaq/n6fAjyQLbH53iN
         iE/gmp1Fmd8BBeec+vSEPJm894En32k4dpsnU3cmtm9BLxEFARWs27Sg6tK40NMv//tv
         uwEg==
X-Gm-Message-State: APjAAAWgq+7kEaBpFoV792HBUOzA9gcSL+3FBZpMdJyuQESSQxmmok0M
        +YQuPLOgDza+ykrDSF0a8EhjOHdXIPWsgPQLesILU7TsPJSsvuYitcG2csB7fm1C1A6Pm3RKWEh
        gaK/EhVJowHb23g5gIzlPBDZbmKIAWk9F87pH79AVvaE4MqHAiJIw78EZdR1Brp4TgwycED9CKw
        ==
X-Google-Smtp-Source: APXvYqwv7cJ4X6dkOtS7lveQI5x3/EiMpwcCFaiDsnNz3qlB2WUh/a3BIR913U1wUSLmdnN+qPmOWw==
X-Received: by 2002:aa7:818b:: with SMTP id g11mr31377147pfi.207.1560146643574;
        Sun, 09 Jun 2019 23:04:03 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id x17sm8914263pgk.72.2019.06.09.23.04.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 23:04:03 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     stable@vger.kernel.org
Cc:     linux@endlessm.com, hui.wang@canonical.com,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Clint Taylor <Clinton.A.Taylor@intel.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH stable-5.1 3/3] drm/i915: Skip modeset for cdclk changes if possible
Date:   Mon, 10 Jun 2019 14:01:43 +0800
Message-Id: <20190610060141.5377-4-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190603100938.5414-1-jian-hong@endlessm.com>
References: <20190603100938.5414-1-jian-hong@endlessm.com>
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
index aa16804687c2..044c9235a86d 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -12778,6 +12778,7 @@ static int intel_modeset_checks(struct drm_atomic_state *state)
 	intel_state->active_crtcs = dev_priv->active_crtcs;
 	intel_state->cdclk.logical = dev_priv->cdclk.logical;
 	intel_state->cdclk.actual = dev_priv->cdclk.actual;
+	intel_state->cdclk.pipe = INVALID_PIPE;
 
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
 		if (new_crtc_state->active)
@@ -12797,6 +12798,8 @@ static int intel_modeset_checks(struct drm_atomic_state *state)
 	 * adjusted_mode bits in the crtc directly.
 	 */
 	if (dev_priv->display.modeset_calc_cdclk) {
+		enum pipe pipe;
+
 		ret = dev_priv->display.modeset_calc_cdclk(state);
 		if (ret < 0)
 			return ret;
@@ -12813,12 +12816,36 @@ static int intel_modeset_checks(struct drm_atomic_state *state)
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
@@ -13227,7 +13254,10 @@ static void intel_atomic_commit_tail(struct drm_atomic_state *state)
 	if (intel_state->modeset) {
 		drm_atomic_helper_update_legacy_modeset_state(state->dev, state);
 
-		intel_set_cdclk(dev_priv, &dev_priv->cdclk.actual);
+		intel_set_cdclk_pre_plane_update(dev_priv,
+						 &intel_state->cdclk.actual,
+						 &dev_priv->cdclk.actual,
+						 intel_state->cdclk.pipe);
 
 		/*
 		 * SKL workaround: bspec recommends we disable the SAGV when we
@@ -13256,6 +13286,12 @@ static void intel_atomic_commit_tail(struct drm_atomic_state *state)
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
index a9183579700d..18b60016f0ed 100644
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

