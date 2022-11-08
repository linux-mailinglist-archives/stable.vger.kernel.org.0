Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F2C6215E4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbiKHOQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbiKHOQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED3B69DFF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:16:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0FEDB81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3BFC433C1;
        Tue,  8 Nov 2022 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916990;
        bh=8dZ/zTrpi1sBCZwxF2e9Oq7ixf4xDbwsWJJ/H0uQxPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apFiGXV9gCL1wML5xj7uGAf+bK7+E42K5xFjEN+cOgm5YX9nsnrwWj9YzTO1kQvyK
         zIu+7V5zbyEh2wb8Nxg/f2ahSQJyoPR66H+/8HhABTvK2Oa7p5h4V1RzjwiuK/ZV7K
         ntcecwRr5ZNfg1vgTZSDqv7fyHIDSyhblhfQ3rYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 6.0 196/197] drm/i915/sdvo: Setup DDC fully before output init
Date:   Tue,  8 Nov 2022 14:40:34 +0100
Message-Id: <20221108133403.764264859@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

commit e79762512120f11c51317570519a1553c70805d8 upstream.

Call intel_sdvo_select_ddc_bus() before initializing any
of the outputs. And before that is functional (assuming no VBT)
we have to set up the controlled_outputs thing. Otherwise DDC
won't be functional during the output init but LVDS really
needs it for the fixed mode setup.

Note that the whole multi output support still looks very
bogus, and more work will be needed to make it correct.
But for now this should at least fix the LVDS EDID fixed mode
setup.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7301
Fixes: aa2b88074a56 ("drm/i915/sdvo: Fix multi function encoder stuff")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221026101134.20865-3-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 64b7b557dc8a96d9cfed6aedbf81de2df80c025d)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_sdvo.c |   31 +++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2747,13 +2747,10 @@ intel_sdvo_dvi_init(struct intel_sdvo *i
 	if (!intel_sdvo_connector)
 		return false;
 
-	if (device == 0) {
-		intel_sdvo->controlled_output |= SDVO_OUTPUT_TMDS0;
+	if (device == 0)
 		intel_sdvo_connector->output_flag = SDVO_OUTPUT_TMDS0;
-	} else if (device == 1) {
-		intel_sdvo->controlled_output |= SDVO_OUTPUT_TMDS1;
+	else if (device == 1)
 		intel_sdvo_connector->output_flag = SDVO_OUTPUT_TMDS1;
-	}
 
 	intel_connector = &intel_sdvo_connector->base;
 	connector = &intel_connector->base;
@@ -2808,7 +2805,6 @@ intel_sdvo_tv_init(struct intel_sdvo *in
 	encoder->encoder_type = DRM_MODE_ENCODER_TVDAC;
 	connector->connector_type = DRM_MODE_CONNECTOR_SVIDEO;
 
-	intel_sdvo->controlled_output |= type;
 	intel_sdvo_connector->output_flag = type;
 
 	if (intel_sdvo_connector_init(intel_sdvo_connector, intel_sdvo) < 0) {
@@ -2849,13 +2845,10 @@ intel_sdvo_analog_init(struct intel_sdvo
 	encoder->encoder_type = DRM_MODE_ENCODER_DAC;
 	connector->connector_type = DRM_MODE_CONNECTOR_VGA;
 
-	if (device == 0) {
-		intel_sdvo->controlled_output |= SDVO_OUTPUT_RGB0;
+	if (device == 0)
 		intel_sdvo_connector->output_flag = SDVO_OUTPUT_RGB0;
-	} else if (device == 1) {
-		intel_sdvo->controlled_output |= SDVO_OUTPUT_RGB1;
+	else if (device == 1)
 		intel_sdvo_connector->output_flag = SDVO_OUTPUT_RGB1;
-	}
 
 	if (intel_sdvo_connector_init(intel_sdvo_connector, intel_sdvo) < 0) {
 		kfree(intel_sdvo_connector);
@@ -2885,13 +2878,10 @@ intel_sdvo_lvds_init(struct intel_sdvo *
 	encoder->encoder_type = DRM_MODE_ENCODER_LVDS;
 	connector->connector_type = DRM_MODE_CONNECTOR_LVDS;
 
-	if (device == 0) {
-		intel_sdvo->controlled_output |= SDVO_OUTPUT_LVDS0;
+	if (device == 0)
 		intel_sdvo_connector->output_flag = SDVO_OUTPUT_LVDS0;
-	} else if (device == 1) {
-		intel_sdvo->controlled_output |= SDVO_OUTPUT_LVDS1;
+	else if (device == 1)
 		intel_sdvo_connector->output_flag = SDVO_OUTPUT_LVDS1;
-	}
 
 	if (intel_sdvo_connector_init(intel_sdvo_connector, intel_sdvo) < 0) {
 		kfree(intel_sdvo_connector);
@@ -2946,8 +2936,14 @@ static u16 intel_sdvo_filter_output_flag
 static bool
 intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
 {
+	struct drm_i915_private *i915 = to_i915(intel_sdvo->base.base.dev);
+
 	flags = intel_sdvo_filter_output_flags(flags);
 
+	intel_sdvo->controlled_output = flags;
+
+	intel_sdvo_select_ddc_bus(i915, intel_sdvo);
+
 	if (flags & SDVO_OUTPUT_TMDS0)
 		if (!intel_sdvo_dvi_init(intel_sdvo, 0))
 			return false;
@@ -2988,7 +2984,6 @@ intel_sdvo_output_setup(struct intel_sdv
 	if (flags == 0) {
 		unsigned char bytes[2];
 
-		intel_sdvo->controlled_output = 0;
 		memcpy(bytes, &intel_sdvo->caps.output_flags, 2);
 		DRM_DEBUG_KMS("%s: Unknown SDVO output type (0x%02x%02x)\n",
 			      SDVO_NAME(intel_sdvo),
@@ -3400,8 +3395,6 @@ bool intel_sdvo_init(struct drm_i915_pri
 	 */
 	intel_sdvo->base.cloneable = 0;
 
-	intel_sdvo_select_ddc_bus(dev_priv, intel_sdvo);
-
 	/* Set the input timing to the screen. Assume always input 0. */
 	if (!intel_sdvo_set_target_input(intel_sdvo))
 		goto err_output;


