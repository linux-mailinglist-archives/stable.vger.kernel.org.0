Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602766B3E51
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCJLrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCJLrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:47:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D0011052F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:46:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9555B82278
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BEAC433EF;
        Fri, 10 Mar 2023 11:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448808;
        bh=mp1+iElC2jLk/oV19GjD59LzARhomJ+/i+a6Iid1ttg=;
        h=Subject:To:Cc:From:Date:From;
        b=RlGxZjRqJTPVZs8BNySz+MCOT8XlKDVMQSSFWmdtYhtisV3oe0iIfSJzsFXRqu+Ln
         Pn8Vwr0RKIA7TCwWSnzGWSCETFNUeIyngq4trIeRt20OIawtudu9oIh5Uley46UJaf
         /HDaIoa9b6/hHwVrUYR9x0/gUm6Mkdd8NWJonHiA=
Subject: FAILED: patch "[PATCH] drm/i915: Pick the backlight controller based on VBT on ICP+" failed to apply to 5.15-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:46:35 +0100
Message-ID: <167844879564163@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x c90b155148e9632ae46e6778ee958c319457415f
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167844879564163@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

c90b155148e9 ("drm/i915: Pick the backlight controller based on VBT on ICP+")
6cc42fbeb150 ("drm/i915/backlight: extract backlight code to a separate file")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c90b155148e9632ae46e6778ee958c319457415f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Tue, 7 Feb 2023 08:43:37 +0200
Subject: [PATCH] drm/i915: Pick the backlight controller based on VBT on ICP+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use the second backlight controller on ICP+ if the VBT asks
us to do so.

On pre-MTP we also check the chicken bit to make sure the
pins have been correctly muxed by the firmware.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8016
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230207064337.18697-4-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit b33771546309b46b681388b3540b69a75a0e2e69)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_backlight.c b/drivers/gpu/drm/i915/display/intel_backlight.c
index 5b7da72c95b8..a4e4b7f79e4d 100644
--- a/drivers/gpu/drm/i915/display/intel_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_backlight.c
@@ -1431,6 +1431,30 @@ bxt_setup_backlight(struct intel_connector *connector, enum pipe unused)
 	return 0;
 }
 
+static int cnp_num_backlight_controllers(struct drm_i915_private *i915)
+{
+	if (INTEL_PCH_TYPE(i915) >= PCH_DG1)
+		return 1;
+
+	if (INTEL_PCH_TYPE(i915) >= PCH_ICP)
+		return 2;
+
+	return 1;
+}
+
+static bool cnp_backlight_controller_is_valid(struct drm_i915_private *i915, int controller)
+{
+	if (controller < 0 || controller >= cnp_num_backlight_controllers(i915))
+		return false;
+
+	if (controller == 1 &&
+	    INTEL_PCH_TYPE(i915) >= PCH_ICP &&
+	    INTEL_PCH_TYPE(i915) < PCH_MTP)
+		return intel_de_read(i915, SOUTH_CHICKEN1) & ICP_SECOND_PPS_IO_SELECT;
+
+	return true;
+}
+
 static int
 cnp_setup_backlight(struct intel_connector *connector, enum pipe unused)
 {
@@ -1440,10 +1464,14 @@ cnp_setup_backlight(struct intel_connector *connector, enum pipe unused)
 
 	/*
 	 * CNP has the BXT implementation of backlight, but with only one
-	 * controller. TODO: ICP has multiple controllers but we only use
-	 * controller 0 for now.
+	 * controller. ICP+ can have two controllers, depending on pin muxing.
 	 */
-	panel->backlight.controller = 0;
+	panel->backlight.controller = connector->panel.vbt.backlight.controller;
+	if (!cnp_backlight_controller_is_valid(i915, panel->backlight.controller)) {
+		drm_dbg_kms(&i915->drm, "Invalid backlight controller %d, assuming 0\n",
+			    panel->backlight.controller);
+		panel->backlight.controller = 0;
+	}
 
 	pwm_ctl = intel_de_read(i915,
 				BXT_BLC_PWM_CTL(panel->backlight.controller));

