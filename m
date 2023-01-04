Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A08765D61C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbjADOkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239728AbjADOkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:40:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A0FE7E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:39:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 116E461762
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272F6C433D2;
        Wed,  4 Jan 2023 14:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843194;
        bh=95pXLTZclGSlc4DelQ73RXQvgAcZL+8dtO7nLhyhdKQ=;
        h=Subject:To:Cc:From:Date:From;
        b=DblPwHp+vIzME66MfOJZtYHJO+0izOwdUIChv70B/hW9DR4z+EsVDKXmpS1gVSbdg
         UK19TB9IN8+7/11fRNoDdL5i+ZpJ0iyTnm1FZn8q1JsBG3sgOGDYaBz849RyMPfiCy
         a/TvsJEGlvjJ4bh0z6pBz8/ElSUURA6VDXcA6ze0=
Subject: FAILED: patch "[PATCH] drm/i915/sdvo: Setup DDC fully before output init" failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:39:43 +0100
Message-ID: <167284318319732@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

64b7b557dc8a ("drm/i915/sdvo: Setup DDC fully before output init")
cc1e66394daa ("drm/i915/sdvo: Filter out invalid outputs more sensibly")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 64b7b557dc8a96d9cfed6aedbf81de2df80c025d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Wed, 26 Oct 2022 13:11:28 +0300
Subject: [PATCH] drm/i915/sdvo: Setup DDC fully before output init
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index c38b75fbabd3..e62f41354789 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2755,13 +2755,10 @@ intel_sdvo_dvi_init(struct intel_sdvo *intel_sdvo, int device)
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
@@ -2816,7 +2813,6 @@ intel_sdvo_tv_init(struct intel_sdvo *intel_sdvo, int type)
 	encoder->encoder_type = DRM_MODE_ENCODER_TVDAC;
 	connector->connector_type = DRM_MODE_CONNECTOR_SVIDEO;
 
-	intel_sdvo->controlled_output |= type;
 	intel_sdvo_connector->output_flag = type;
 
 	if (intel_sdvo_connector_init(intel_sdvo_connector, intel_sdvo) < 0) {
@@ -2857,13 +2853,10 @@ intel_sdvo_analog_init(struct intel_sdvo *intel_sdvo, int device)
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
@@ -2893,13 +2886,10 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, int device)
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
@@ -2954,8 +2944,14 @@ static u16 intel_sdvo_filter_output_flags(u16 flags)
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
@@ -2996,7 +2992,6 @@ intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
 	if (flags == 0) {
 		unsigned char bytes[2];
 
-		intel_sdvo->controlled_output = 0;
 		memcpy(bytes, &intel_sdvo->caps.output_flags, 2);
 		DRM_DEBUG_KMS("%s: Unknown SDVO output type (0x%02x%02x)\n",
 			      SDVO_NAME(intel_sdvo),
@@ -3408,8 +3403,6 @@ bool intel_sdvo_init(struct drm_i915_private *dev_priv,
 	 */
 	intel_sdvo->base.cloneable = 0;
 
-	intel_sdvo_select_ddc_bus(dev_priv, intel_sdvo);
-
 	/* Set the input timing to the screen. Assume always input 0. */
 	if (!intel_sdvo_set_target_input(intel_sdvo))
 		goto err_output;

