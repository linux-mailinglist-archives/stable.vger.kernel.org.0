Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFBC028FAC
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 05:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387535AbfEXDmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 23:42:32 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46272 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387454AbfEXDmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 23:42:31 -0400
Received: by mail-pl1-f193.google.com with SMTP id r18so3569107pls.13
        for <stable@vger.kernel.org>; Thu, 23 May 2019 20:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=85F9Drrq7CMXCNzsKpNZJRMHfgJ5bcfMzhqrEDZwjn8=;
        b=M64Xj2bj71PYzj1dthL+HmS2Hh/mzO4vmEXC2k8cAAYGAxeXM6jDVHHeJ7KV2ncLC5
         caP5BNmJuGA5vypnYgTv2aGk5rdoAEHaJVKPpqfFD126e+kbB5b6qSkzbvOPsRvefXWd
         DYEDApSs1QPn5EEcNnrdi/5fgeF66JH7VsUEAq2OkLOe1jTZzDjLSRxw5jnBGctHEHqB
         h93hm/1Iu84QhItc9dL5n1FlDeB857bmooOzBp9J/WdcKcF4MNage7nPHCCk9ZqdjxaT
         ph17rawJwT2j/3rX+Nm5m7/6cFglouyWd5kdZPpKxTuuU8RH4rScERBzaKvp7rVdNWOg
         i0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=85F9Drrq7CMXCNzsKpNZJRMHfgJ5bcfMzhqrEDZwjn8=;
        b=sxhC50mzVBP4RznrLCO0tzXfZHTwGi2g5dQxyGyRitdmcNZe+semIe9qjC0fWZKl3Q
         JIeKc2sX6lcFdE7ZDHMdezQNesO5C9uOnC0mx5pU3P2dtK0AG2xe3PQoe5qGZfF9plBq
         jLHQq5ssWPew8w9rRQ50zgcOY5kF72hWkvzvBsmSHeTrj/O0N8Gsv9vqCaPMfNfev/r6
         n+fLCZtD4qgYr4+seljiOVJNrpztBdOyb3hLgxk/T/9gdjyDVTSqTRtQUK+e7dVOBsY+
         iSpKMYYACcsBId+DcKEUOrCQJA5DKt1bgx6BjzN+bZRqrkIZdV1LEFVTHpOUNvU93CrW
         9FxA==
X-Gm-Message-State: APjAAAXhvsT77yjHNxbtdqoh51l4CEmDZ55KKJK2NqP8JOiZoNZvu9IW
        mfLKMCP3RnKcen1W5w4k2hi2qTIoP9YU/7fHLPC6XoiiN04BcuiaJSXuLIE0c8Xw7I1/2eFaPeW
        aU6gfSeGxpPQSCjeAQVYDjq2YWGT+aEMoq0Uo8AM1X/s2/RawbuGk2b37k0f7MGA9cQHHztGbzQ
        ==
X-Google-Smtp-Source: APXvYqxEvZpcprf2+uzizdgBziGXRpBbRGMhhAI8Sy4ip/22DKLkP2TvNFHkZhvzjAT0Elq1693xWg==
X-Received: by 2002:a17:902:e492:: with SMTP id cj18mr44575300plb.341.1558669349754;
        Thu, 23 May 2019 20:42:29 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id a26sm938946pfl.177.2019.05.23.20.42.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 20:42:29 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     stable@vger.kernel.org
Cc:     linux@endlessm.com, tiwai@suse.de,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Clint Taylor <Clinton.A.Taylor@intel.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH] drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio power is enabled
Date:   Fri, 24 May 2019 11:41:55 +0800
Message-Id: <20190524034154.3376-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.21.0
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
Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=203623
Cc: <stable@vger.kernel.org> # 5.1.x: d31c85fc8642 snd/hda, drm/i915: Track the display_power_status using a cookie
Cc: <stable@vger.kernel.org> # 5.1.x
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
---
 drivers/gpu/drm/i915/i915_drv.h      |  3 ++
 drivers/gpu/drm/i915/intel_audio.c   | 64 +++++++++++++++++++++++++++-
 drivers/gpu/drm/i915/intel_cdclk.c   | 30 +++++--------
 drivers/gpu/drm/i915/intel_display.c |  9 +++-
 drivers/gpu/drm/i915/intel_drv.h     |  3 ++
 5 files changed, 86 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index a67a63b5aa84..5c9bb1b2d1f3 100644
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
diff --git a/drivers/gpu/drm/i915/intel_audio.c b/drivers/gpu/drm/i915/intel_audio.c
index 502b57ce72ab..20324b0d34c7 100644
--- a/drivers/gpu/drm/i915/intel_audio.c
+++ b/drivers/gpu/drm/i915/intel_audio.c
@@ -741,18 +741,78 @@ void intel_init_audio_hooks(struct drm_i915_private *dev_priv)
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
 static unsigned long i915_audio_component_get_power(struct device *kdev)
 {
+	struct drm_i915_private *dev_priv = kdev_to_i915(kdev);
+	intel_wakeref_t ret;
+
 	/* Catch potential impedance mismatches before they occur! */
 	BUILD_BUG_ON(sizeof(intel_wakeref_t) > sizeof(unsigned long));
 
-	return intel_display_power_get(kdev_to_i915(kdev), POWER_DOMAIN_AUDIO);
+	ret = intel_display_power_get(dev_priv, POWER_DOMAIN_AUDIO);
+
+	/* Force CDCLK to 2*BCLK as long as we need audio to be powered. */
+	if (dev_priv->audio_power_refcount++ == 0)
+		if (IS_CANNONLAKE(dev_priv) || IS_GEMINILAKE(dev_priv))
+			glk_force_audio_cdclk(dev_priv, true);
+
+	return ret;
 }
 
 static void i915_audio_component_put_power(struct device *kdev,
 					   unsigned long cookie)
 {
-	intel_display_power_put(kdev_to_i915(kdev), POWER_DOMAIN_AUDIO, cookie);
+	struct drm_i915_private *dev_priv = kdev_to_i915(kdev);
+
+	/* Stop forcing CDCLK to 2*BCLK if no need for audio to be powered. */
+	if (--dev_priv->audio_power_refcount == 0)
+		if (IS_CANNONLAKE(dev_priv) || IS_GEMINILAKE(dev_priv))
+			glk_force_audio_cdclk(dev_priv, false);
+
+	intel_display_power_put(dev_priv, POWER_DOMAIN_AUDIO, cookie);
 }
 
 static void i915_audio_component_codec_wake_override(struct device *kdev,
diff --git a/drivers/gpu/drm/i915/intel_cdclk.c b/drivers/gpu/drm/i915/intel_cdclk.c
index 15ba950dee00..553f57ff60f4 100644
--- a/drivers/gpu/drm/i915/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/intel_cdclk.c
@@ -2187,19 +2187,8 @@ int intel_crtc_compute_min_cdclk(const struct intel_crtc_state *crtc_state)
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
@@ -2239,7 +2228,7 @@ static int intel_compute_min_cdclk(struct drm_atomic_state *state)
 		intel_state->min_cdclk[i] = min_cdclk;
 	}
 
-	min_cdclk = 0;
+	min_cdclk = intel_state->cdclk.force_min_cdclk;
 	for_each_pipe(dev_priv, pipe)
 		min_cdclk = max(intel_state->min_cdclk[pipe], min_cdclk);
 
@@ -2300,7 +2289,8 @@ static int vlv_modeset_calc_cdclk(struct drm_atomic_state *state)
 		vlv_calc_voltage_level(dev_priv, cdclk);
 
 	if (!intel_state->active_crtcs) {
-		cdclk = vlv_calc_cdclk(dev_priv, 0);
+		cdclk = vlv_calc_cdclk(dev_priv,
+				       intel_state->cdclk.force_min_cdclk);
 
 		intel_state->cdclk.actual.cdclk = cdclk;
 		intel_state->cdclk.actual.voltage_level =
@@ -2333,7 +2323,7 @@ static int bdw_modeset_calc_cdclk(struct drm_atomic_state *state)
 		bdw_calc_voltage_level(cdclk);
 
 	if (!intel_state->active_crtcs) {
-		cdclk = bdw_calc_cdclk(0);
+		cdclk = bdw_calc_cdclk(intel_state->cdclk.force_min_cdclk);
 
 		intel_state->cdclk.actual.cdclk = cdclk;
 		intel_state->cdclk.actual.voltage_level =
@@ -2405,7 +2395,7 @@ static int skl_modeset_calc_cdclk(struct drm_atomic_state *state)
 		skl_calc_voltage_level(cdclk);
 
 	if (!intel_state->active_crtcs) {
-		cdclk = skl_calc_cdclk(0, vco);
+		cdclk = skl_calc_cdclk(intel_state->cdclk.force_min_cdclk, vco);
 
 		intel_state->cdclk.actual.vco = vco;
 		intel_state->cdclk.actual.cdclk = cdclk;
@@ -2444,10 +2434,10 @@ static int bxt_modeset_calc_cdclk(struct drm_atomic_state *state)
 
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
 
@@ -2483,7 +2473,7 @@ static int cnl_modeset_calc_cdclk(struct drm_atomic_state *state)
 		    cnl_compute_min_voltage_level(intel_state));
 
 	if (!intel_state->active_crtcs) {
-		cdclk = cnl_calc_cdclk(0);
+		cdclk = cnl_calc_cdclk(intel_state->cdclk.force_min_cdclk);
 		vco = cnl_cdclk_pll_vco(dev_priv, cdclk);
 
 		intel_state->cdclk.actual.vco = vco;
@@ -2519,7 +2509,7 @@ static int icl_modeset_calc_cdclk(struct drm_atomic_state *state)
 		    cnl_compute_min_voltage_level(intel_state));
 
 	if (!intel_state->active_crtcs) {
-		cdclk = icl_calc_cdclk(0, ref);
+		cdclk = icl_calc_cdclk(intel_state->cdclk.force_min_cdclk, ref);
 		vco = icl_calc_cdclk_pll_vco(dev_priv, cdclk);
 
 		intel_state->cdclk.actual.vco = vco;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 421aac80a838..ebbac873b8f4 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -12769,6 +12769,11 @@ static int intel_modeset_checks(struct drm_atomic_state *state)
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
@@ -12864,7 +12869,7 @@ static int intel_atomic_check(struct drm_device *dev,
 	struct drm_crtc *crtc;
 	struct drm_crtc_state *old_crtc_state, *crtc_state;
 	int ret, i;
-	bool any_ms = false;
+	bool any_ms = intel_state->cdclk.force_min_cdclk_changed;
 
 	/* Catch I915_MODE_FLAG_INHERITED */
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state,
@@ -13456,6 +13461,8 @@ static int intel_atomic_commit(struct drm_device *dev,
 		dev_priv->active_crtcs = intel_state->active_crtcs;
 		dev_priv->cdclk.logical = intel_state->cdclk.logical;
 		dev_priv->cdclk.actual = intel_state->cdclk.actual;
+		dev_priv->cdclk.force_min_cdclk =
+			intel_state->cdclk.force_min_cdclk;
 	}
 
 	drm_atomic_state_get(state);
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index d5660ac1b0d6..539caca05da4 100644
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
-- 
2.21.0

