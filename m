Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F195EA3EB
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbiIZLgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234298AbiIZLeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EC64D80F;
        Mon, 26 Sep 2022 03:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E70060B4A;
        Mon, 26 Sep 2022 10:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F576C433D6;
        Mon, 26 Sep 2022 10:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188899;
        bh=0BK0iDrVDjoH3fRvvgiRKrZ6nps587NI38WnoS0Treg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pr1TZvF2a5ubb9IMJ3YYpIHark0GZWWzj2N6LgnnuznrkCX/6olMidPR2TmLxjpht
         XIhc/0HmAlN3SfNbi+MX4STABS+jXOx5tcwoVyDe1pB19x2yJMJlilkkknTDBndmtV
         cZLharsfvvk0PISPRmdQiciknLvAFQT3/kjRrc1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 001/207] drm/i915: Extract intel_edp_fixup_vbt_bpp()
Date:   Mon, 26 Sep 2022 12:09:50 +0200
Message-Id: <20220926100806.581167017@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 822e5ae701af2964c5808b6ade1d6f3b1eaec967 ]

We have the same "override eDP VBT bpp with the current bpp" code
duplciated in two places. Extract it to a helper function.

TODO: Having this in .get_config() is pretty ugly. Should probably
try to move it somewhere else (setup_hw_state()/etc.)...

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220510104242.6099-3-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 607f41768a1e ("drm/i915/dsi: filter invalid backlight and CABC ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/g4x_dp.c    | 22 ++-------------------
 drivers/gpu/drm/i915/display/intel_ddi.c | 22 ++-------------------
 drivers/gpu/drm/i915/display/intel_dp.c  | 25 ++++++++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_dp.h  |  1 +
 4 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/g4x_dp.c b/drivers/gpu/drm/i915/display/g4x_dp.c
index 5a957acebfd6..82ad8fe7440c 100644
--- a/drivers/gpu/drm/i915/display/g4x_dp.c
+++ b/drivers/gpu/drm/i915/display/g4x_dp.c
@@ -395,26 +395,8 @@ static void intel_dp_get_config(struct intel_encoder *encoder,
 		intel_dotclock_calculate(pipe_config->port_clock,
 					 &pipe_config->dp_m_n);
 
-	if (intel_dp_is_edp(intel_dp) && dev_priv->vbt.edp.bpp &&
-	    pipe_config->pipe_bpp > dev_priv->vbt.edp.bpp) {
-		/*
-		 * This is a big fat ugly hack.
-		 *
-		 * Some machines in UEFI boot mode provide us a VBT that has 18
-		 * bpp and 1.62 GHz link bandwidth for eDP, which for reasons
-		 * unknown we fail to light up. Yet the same BIOS boots up with
-		 * 24 bpp and 2.7 GHz link. Use the same bpp as the BIOS uses as
-		 * max, not what it tells us to use.
-		 *
-		 * Note: This will still be broken if the eDP panel is not lit
-		 * up by the BIOS, and thus we can't get the mode at module
-		 * load.
-		 */
-		drm_dbg_kms(&dev_priv->drm,
-			    "pipe has %d bpp for eDP panel, overriding BIOS-provided max %d bpp\n",
-			    pipe_config->pipe_bpp, dev_priv->vbt.edp.bpp);
-		dev_priv->vbt.edp.bpp = pipe_config->pipe_bpp;
-	}
+	if (intel_dp_is_edp(intel_dp))
+		intel_edp_fixup_vbt_bpp(encoder, pipe_config->pipe_bpp);
 }
 
 static void
diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 9e6fa59eabba..333871cf3a2c 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3433,26 +3433,8 @@ static void intel_ddi_get_config(struct intel_encoder *encoder,
 	pipe_config->has_audio =
 		intel_ddi_is_audio_enabled(dev_priv, cpu_transcoder);
 
-	if (encoder->type == INTEL_OUTPUT_EDP && dev_priv->vbt.edp.bpp &&
-	    pipe_config->pipe_bpp > dev_priv->vbt.edp.bpp) {
-		/*
-		 * This is a big fat ugly hack.
-		 *
-		 * Some machines in UEFI boot mode provide us a VBT that has 18
-		 * bpp and 1.62 GHz link bandwidth for eDP, which for reasons
-		 * unknown we fail to light up. Yet the same BIOS boots up with
-		 * 24 bpp and 2.7 GHz link. Use the same bpp as the BIOS uses as
-		 * max, not what it tells us to use.
-		 *
-		 * Note: This will still be broken if the eDP panel is not lit
-		 * up by the BIOS, and thus we can't get the mode at module
-		 * load.
-		 */
-		drm_dbg_kms(&dev_priv->drm,
-			    "pipe has %d bpp for eDP panel, overriding BIOS-provided max %d bpp\n",
-			    pipe_config->pipe_bpp, dev_priv->vbt.edp.bpp);
-		dev_priv->vbt.edp.bpp = pipe_config->pipe_bpp;
-	}
+	if (encoder->type == INTEL_OUTPUT_EDP)
+		intel_edp_fixup_vbt_bpp(encoder, pipe_config->pipe_bpp);
 
 	ddi_dotclock_get(pipe_config);
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index fe8b6b72970a..affc820bf8d0 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2737,6 +2737,31 @@ static void intel_edp_mso_mode_fixup(struct intel_connector *connector,
 		    DRM_MODE_ARG(mode));
 }
 
+void intel_edp_fixup_vbt_bpp(struct intel_encoder *encoder, int pipe_bpp)
+{
+	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
+
+	if (dev_priv->vbt.edp.bpp && pipe_bpp > dev_priv->vbt.edp.bpp) {
+		/*
+		 * This is a big fat ugly hack.
+		 *
+		 * Some machines in UEFI boot mode provide us a VBT that has 18
+		 * bpp and 1.62 GHz link bandwidth for eDP, which for reasons
+		 * unknown we fail to light up. Yet the same BIOS boots up with
+		 * 24 bpp and 2.7 GHz link. Use the same bpp as the BIOS uses as
+		 * max, not what it tells us to use.
+		 *
+		 * Note: This will still be broken if the eDP panel is not lit
+		 * up by the BIOS, and thus we can't get the mode at module
+		 * load.
+		 */
+		drm_dbg_kms(&dev_priv->drm,
+			    "pipe has %d bpp for eDP panel, overriding BIOS-provided max %d bpp\n",
+			    pipe_bpp, dev_priv->vbt.edp.bpp);
+		dev_priv->vbt.edp.bpp = pipe_bpp;
+	}
+}
+
 static void intel_edp_mso_init(struct intel_dp *intel_dp)
 {
 	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
index d457e17bdc57..e794d910df56 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -63,6 +63,7 @@ enum irqreturn intel_dp_hpd_pulse(struct intel_digital_port *dig_port,
 void intel_edp_backlight_on(const struct intel_crtc_state *crtc_state,
 			    const struct drm_connector_state *conn_state);
 void intel_edp_backlight_off(const struct drm_connector_state *conn_state);
+void intel_edp_fixup_vbt_bpp(struct intel_encoder *encoder, int pipe_bpp);
 void intel_dp_mst_suspend(struct drm_i915_private *dev_priv);
 void intel_dp_mst_resume(struct drm_i915_private *dev_priv);
 int intel_dp_max_link_rate(struct intel_dp *intel_dp);
-- 
2.35.1



