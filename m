Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300E16BB262
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbjCOMfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbjCOMfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D179FBD5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:34:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F3EA61D73
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82539C433EF;
        Wed, 15 Mar 2023 12:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883658;
        bh=kYmJMuH1RHptYLax/FeNczIXPRoxT8ugEKfVU/uKWeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+a9fvliRT1dEk/7qK3ztZbhGXHJz+V/mbxAkzz2k0QgBasmsacaEH4Ohl9xn5ONr
         a4px4O8QPAvrxXqun+zKKyznWLhsGCFxTo3AqvsPlnyT1JNxA4SK+fmOrfrO1+ifR7
         gH1JQoXxStJiGvTlcQ80WET5s3fVL7qzhEJAPpW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/143] drm/i915: Populate encoder->devdata for DSI on icl+
Date:   Wed, 15 Mar 2023 13:12:17 +0100
Message-Id: <20230315115742.068171883@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 14e591a1930c2790fe862af5b01ee3ca587f752f ]

We now have some eDP+DSI dual panel systems floating around
where the DSI panel is the secondary LFP and thus needs to
consult "panel type 2" in VBT in order to locate all the
other panel type dependant stuff correctly.

To that end we need to pass in the devdata to
intel_bios_init_panel_late(), otherwise it'll just assume
we want the primary panel type. So let's try to just populate
the vbt.ports[] stuff and encoder->devdata for icl+ DSI
panels as well.

We can't do this on older platforms as there we risk a DSI
port aliasing with a HDMI/DP port, which is a totally legal
thing as the DSI ports live in their own little parallel
universe.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8016
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230207064337.18697-3-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit ba00eb6a4bfbe5194ddda50730aba063951f8ce0)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c    |  3 ++-
 drivers/gpu/drm/i915/display/intel_bios.c | 15 ++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 34b3ff967a272..ecd6c5c3f4ded 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -2053,7 +2053,8 @@ void icl_dsi_init(struct drm_i915_private *dev_priv)
 	/* attach connector to encoder */
 	intel_connector_attach_encoder(intel_connector, encoder);
 
-	intel_bios_init_panel_late(dev_priv, &intel_connector->panel, NULL, NULL);
+	encoder->devdata = intel_bios_encoder_data_lookup(dev_priv, port);
+	intel_bios_init_panel_late(dev_priv, &intel_connector->panel, encoder->devdata, NULL);
 
 	mutex_lock(&dev->mode_config.mutex);
 	intel_panel_add_vbt_lfp_fixed_mode(intel_connector);
diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 2378a2a48716e..a70b7061742a8 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -2593,6 +2593,12 @@ intel_bios_encoder_supports_edp(const struct intel_bios_encoder_data *devdata)
 		devdata->child.device_type & DEVICE_TYPE_INTERNAL_CONNECTOR;
 }
 
+static bool
+intel_bios_encoder_supports_dsi(const struct intel_bios_encoder_data *devdata)
+{
+	return devdata->child.device_type & DEVICE_TYPE_MIPI_OUTPUT;
+}
+
 static int _intel_bios_hdmi_level_shift(const struct intel_bios_encoder_data *devdata)
 {
 	if (!devdata || devdata->i915->display.vbt.version < 158)
@@ -2643,7 +2649,7 @@ static void print_ddi_port(const struct intel_bios_encoder_data *devdata,
 {
 	struct drm_i915_private *i915 = devdata->i915;
 	const struct child_device_config *child = &devdata->child;
-	bool is_dvi, is_hdmi, is_dp, is_edp, is_crt, supports_typec_usb, supports_tbt;
+	bool is_dvi, is_hdmi, is_dp, is_edp, is_dsi, is_crt, supports_typec_usb, supports_tbt;
 	int dp_boost_level, dp_max_link_rate, hdmi_boost_level, hdmi_level_shift, max_tmds_clock;
 
 	is_dvi = intel_bios_encoder_supports_dvi(devdata);
@@ -2651,13 +2657,14 @@ static void print_ddi_port(const struct intel_bios_encoder_data *devdata,
 	is_crt = intel_bios_encoder_supports_crt(devdata);
 	is_hdmi = intel_bios_encoder_supports_hdmi(devdata);
 	is_edp = intel_bios_encoder_supports_edp(devdata);
+	is_dsi = intel_bios_encoder_supports_dsi(devdata);
 
 	supports_typec_usb = intel_bios_encoder_supports_typec_usb(devdata);
 	supports_tbt = intel_bios_encoder_supports_tbt(devdata);
 
 	drm_dbg_kms(&i915->drm,
-		    "Port %c VBT info: CRT:%d DVI:%d HDMI:%d DP:%d eDP:%d LSPCON:%d USB-Type-C:%d TBT:%d DSC:%d\n",
-		    port_name(port), is_crt, is_dvi, is_hdmi, is_dp, is_edp,
+		    "Port %c VBT info: CRT:%d DVI:%d HDMI:%d DP:%d eDP:%d DSI:%d LSPCON:%d USB-Type-C:%d TBT:%d DSC:%d\n",
+		    port_name(port), is_crt, is_dvi, is_hdmi, is_dp, is_edp, is_dsi,
 		    HAS_LSPCON(i915) && child->lspcon,
 		    supports_typec_usb, supports_tbt,
 		    devdata->dsc != NULL);
@@ -2702,6 +2709,8 @@ static void parse_ddi_port(struct intel_bios_encoder_data *devdata)
 	enum port port;
 
 	port = dvo_port_to_port(i915, child->dvo_port);
+	if (port == PORT_NONE && DISPLAY_VER(i915) >= 11)
+		port = dsi_dvo_port_to_port(i915, child->dvo_port);
 	if (port == PORT_NONE)
 		return;
 
-- 
2.39.2



