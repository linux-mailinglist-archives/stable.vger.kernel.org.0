Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCFD429075
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbhJKOJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238347AbhJKOGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:06:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A421E60555;
        Mon, 11 Oct 2021 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960818;
        bh=r/erOr2wd/wJui34zFBL7qz8H06wFIkkeP3HPhTbx60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suK5B5ZQ/pkdu7bnJpUt9/3BZvNSaMYwio4nF7HTWrxWcqBol88btJ6WiuY7T7MFF
         hSkshDcfqzTusJyPRD/FwcjZo6fBJdUJPzcr6NVbQgqtYtc19TBNs/I4zPnVgCHvpB
         HTTsLD6yumZV9aY0GgcxkFllcsVUDv1hsy5pZ3k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 084/151] drm/i915/tc: Fix TypeC port init/resume time sanitization
Date:   Mon, 11 Oct 2021 15:45:56 +0200
Message-Id: <20211011134520.559349738@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit a532cde31de3cae6ed60e60d6f9379771f652809 ]

Atm during driver loading and system resume TypeC ports are accessed
before their HW/SW state is synced. Move the TypeC port sanitization to
the encoder's sync_state hook to fix this.

v2: Handle the encoder disabled case in gen11_dsi_sync_state() as well
    (Jose, Jani)

Fixes: f9e76a6e68d3 ("drm/i915: Add an encoder hook to sanitize its state during init/resume")
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210929132833.2253961-1-imre.deak@intel.com
(cherry picked from commit 7194dc998dfffca096c30b3cd39625158608992d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c       | 10 ++++++++--
 drivers/gpu/drm/i915/display/intel_ddi.c     |  8 +++++++-
 drivers/gpu/drm/i915/display/intel_display.c | 20 +++++---------------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 970ba9e7f84e..13bafa9d49c0 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -1577,8 +1577,14 @@ static void gen11_dsi_sync_state(struct intel_encoder *encoder,
 				 const struct intel_crtc_state *crtc_state)
 {
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
-	struct intel_crtc *intel_crtc = to_intel_crtc(crtc_state->uapi.crtc);
-	enum pipe pipe = intel_crtc->pipe;
+	struct intel_crtc *intel_crtc;
+	enum pipe pipe;
+
+	if (!crtc_state)
+		return;
+
+	intel_crtc = to_intel_crtc(crtc_state->uapi.crtc);
+	pipe = intel_crtc->pipe;
 
 	/* wa verify 1409054076:icl,jsl,ehl */
 	if (DISPLAY_VER(dev_priv) == 11 && pipe == PIPE_B &&
diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 00dade49665b..89a109f65f38 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3899,7 +3899,13 @@ void hsw_ddi_get_config(struct intel_encoder *encoder,
 static void intel_ddi_sync_state(struct intel_encoder *encoder,
 				 const struct intel_crtc_state *crtc_state)
 {
-	if (intel_crtc_has_dp_encoder(crtc_state))
+	struct drm_i915_private *i915 = to_i915(encoder->base.dev);
+	enum phy phy = intel_port_to_phy(i915, encoder->port);
+
+	if (intel_phy_is_tc(i915, phy))
+		intel_tc_port_sanitize(enc_to_dig_port(encoder));
+
+	if (crtc_state && intel_crtc_has_dp_encoder(crtc_state))
 		intel_dp_sync_state(encoder, crtc_state);
 }
 
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 0a8a2395c8ac..bb1d2b19be15 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -12933,18 +12933,16 @@ static void intel_modeset_readout_hw_state(struct drm_device *dev)
 	readout_plane_state(dev_priv);
 
 	for_each_intel_encoder(dev, encoder) {
+		struct intel_crtc_state *crtc_state = NULL;
+
 		pipe = 0;
 
 		if (encoder->get_hw_state(encoder, &pipe)) {
-			struct intel_crtc_state *crtc_state;
-
 			crtc = intel_get_crtc_for_pipe(dev_priv, pipe);
 			crtc_state = to_intel_crtc_state(crtc->base.state);
 
 			encoder->base.crtc = &crtc->base;
 			intel_encoder_get_config(encoder, crtc_state);
-			if (encoder->sync_state)
-				encoder->sync_state(encoder, crtc_state);
 
 			/* read out to slave crtc as well for bigjoiner */
 			if (crtc_state->bigjoiner) {
@@ -12959,6 +12957,9 @@ static void intel_modeset_readout_hw_state(struct drm_device *dev)
 			encoder->base.crtc = NULL;
 		}
 
+		if (encoder->sync_state)
+			encoder->sync_state(encoder, crtc_state);
+
 		drm_dbg_kms(&dev_priv->drm,
 			    "[ENCODER:%d:%s] hw state readout: %s, pipe %c\n",
 			    encoder->base.base.id, encoder->base.name,
@@ -13241,17 +13242,6 @@ intel_modeset_setup_hw_state(struct drm_device *dev,
 	intel_modeset_readout_hw_state(dev);
 
 	/* HW state is read out, now we need to sanitize this mess. */
-
-	/* Sanitize the TypeC port mode upfront, encoders depend on this */
-	for_each_intel_encoder(dev, encoder) {
-		enum phy phy = intel_port_to_phy(dev_priv, encoder->port);
-
-		/* We need to sanitize only the MST primary port. */
-		if (encoder->type != INTEL_OUTPUT_DP_MST &&
-		    intel_phy_is_tc(dev_priv, phy))
-			intel_tc_port_sanitize(enc_to_dig_port(encoder));
-	}
-
 	get_encoder_power_domains(dev_priv);
 
 	if (HAS_PCH_IBX(dev_priv))
-- 
2.33.0



