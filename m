Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D9F627F99
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbiKNNAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237667AbiKNNAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:00:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E00928719
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:00:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17A5661185
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156E3C433B5;
        Mon, 14 Nov 2022 13:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430845;
        bh=OM7nq5pL4CfYNaf1/+dnRX+qwTCW8NfBEJyj0YUKo3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHGnfK7gFZaB7o/FMkRyu5Zd0JkIdkqNCiNUdzXdb7cQfQQuTinjE8rtF53gvZA38
         NCgPxyqytRB2kIm9hzSqKvDhMYBc9vzwoE7aa+7Pp3whVBMZpIfP5bl9Z5H8gXmzn0
         ZVRNDzriGfPRyW/P7ghmjUYz4naKaHp2Dd3ZNGdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 005/190] drm/i915: Allow more varied alternate fixed modes for panels
Date:   Mon, 14 Nov 2022 13:43:49 +0100
Message-Id: <20221114124459.040332082@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit a5810f551d0a8c83b4817b53a446bd115e7182ce ]

On some systems the panel reports alternate modes with
different blanking periods. If the EDID reports them and VBT
doesn't tell us otherwise then I can't really see why they
should be rejected. So allow their use for the purposes of
static DRRS.

For seamless DRRS we still require a much more exact match
of course. But that logic only kicks in when selecting the
downclock mode (or in the future when determining whether
we can do a seamless refresh rate change due to a user
modeset).

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6374
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220830212436.2021-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 12caf46cf4fc ("drm/i915/sdvo: Grab mode_config.mutex during LVDS init to avoid WARNs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_panel.c | 25 ++++++----------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_panel.c b/drivers/gpu/drm/i915/display/intel_panel.c
index 237a40623dd7..cb44984bb9a2 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -81,15 +81,14 @@ static bool is_alt_drrs_mode(const struct drm_display_mode *mode,
 		mode->clock != preferred_mode->clock;
 }
 
-static bool is_alt_vrr_mode(const struct drm_display_mode *mode,
-			    const struct drm_display_mode *preferred_mode)
+static bool is_alt_fixed_mode(const struct drm_display_mode *mode,
+			      const struct drm_display_mode *preferred_mode)
 {
 	return drm_mode_match(mode, preferred_mode,
 			      DRM_MODE_MATCH_FLAGS |
 			      DRM_MODE_MATCH_3D_FLAGS) &&
 		mode->hdisplay == preferred_mode->hdisplay &&
-		mode->vdisplay == preferred_mode->vdisplay &&
-		mode->clock != preferred_mode->clock;
+		mode->vdisplay == preferred_mode->vdisplay;
 }
 
 const struct drm_display_mode *
@@ -172,19 +171,7 @@ int intel_panel_compute_config(struct intel_connector *connector,
 	return 0;
 }
 
-static bool is_alt_fixed_mode(const struct drm_display_mode *mode,
-			      const struct drm_display_mode *preferred_mode,
-			      bool has_vrr)
-{
-	/* is_alt_drrs_mode() is a subset of is_alt_vrr_mode() */
-	if (has_vrr)
-		return is_alt_vrr_mode(mode, preferred_mode);
-	else
-		return is_alt_drrs_mode(mode, preferred_mode);
-}
-
-static void intel_panel_add_edid_alt_fixed_modes(struct intel_connector *connector,
-						 bool has_vrr)
+static void intel_panel_add_edid_alt_fixed_modes(struct intel_connector *connector)
 {
 	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
 	const struct drm_display_mode *preferred_mode =
@@ -192,7 +179,7 @@ static void intel_panel_add_edid_alt_fixed_modes(struct intel_connector *connect
 	struct drm_display_mode *mode, *next;
 
 	list_for_each_entry_safe(mode, next, &connector->base.probed_modes, head) {
-		if (!is_alt_fixed_mode(mode, preferred_mode, has_vrr))
+		if (!is_alt_fixed_mode(mode, preferred_mode))
 			continue;
 
 		drm_dbg_kms(&dev_priv->drm,
@@ -255,7 +242,7 @@ void intel_panel_add_edid_fixed_modes(struct intel_connector *connector,
 {
 	intel_panel_add_edid_preferred_mode(connector);
 	if (intel_panel_preferred_fixed_mode(connector) && (has_drrs || has_vrr))
-		intel_panel_add_edid_alt_fixed_modes(connector, has_vrr);
+		intel_panel_add_edid_alt_fixed_modes(connector);
 	intel_panel_destroy_probed_modes(connector);
 }
 
-- 
2.35.1



