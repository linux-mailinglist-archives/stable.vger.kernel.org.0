Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469866B3E20
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjCJLkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjCJLj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:39:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDEAF6384
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:39:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B631161369
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23F2C433D2;
        Fri, 10 Mar 2023 11:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448397;
        bh=geCPsbnWpv7zGeCw4NY1nNmbVYzLLzMcgexY/ltFooc=;
        h=Subject:To:Cc:From:Date:From;
        b=aZdfqtnaXouWJEEgEr7Ci6cZ5PU/nJNsLcag0iF60YctKP919xcTznHxJPmtxUwWQ
         NSki9dpMtmdqeoMJsGkTRjASaO2YiV5XsoIyRFP0f4iqdc9W8aVboD22MoEieEDmh3
         DH+1tk7ecoWMV2jpTgLZalseuIb3S9nfjx6ItJWQ=
Subject: FAILED: patch "[PATCH] drm/i915: Fix VBT DSI DVO port handling" failed to apply to 6.1-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:39:48 +0100
Message-ID: <167844838854243@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 8f9f5fb94dbea843621740e6b25b3b430a83cf29
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167844838854243@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

8f9f5fb94dbe ("drm/i915: Fix VBT DSI DVO port handling")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8f9f5fb94dbea843621740e6b25b3b430a83cf29 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Tue, 7 Feb 2023 08:43:35 +0200
Subject: [PATCH] drm/i915: Fix VBT DSI DVO port handling
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Turns out modern (icl+) VBTs still declare their DSI ports
as MIPI-A and MIPI-C despite the PHYs now being A and B.
Remap appropriately to allow the panels declared as MIPI-C
to work.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8016
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230207064337.18697-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 118b5c136c04da705b274b0d39982bb8b7430fc5)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index e6ca51232dcf..06a2d98d2277 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -2467,6 +2467,22 @@ static enum port dvo_port_to_port(struct drm_i915_private *i915,
 					  dvo_port);
 }
 
+static enum port
+dsi_dvo_port_to_port(struct drm_i915_private *i915, u8 dvo_port)
+{
+	switch (dvo_port) {
+	case DVO_PORT_MIPIA:
+		return PORT_A;
+	case DVO_PORT_MIPIC:
+		if (DISPLAY_VER(i915) >= 11)
+			return PORT_B;
+		else
+			return PORT_C;
+	default:
+		return PORT_NONE;
+	}
+}
+
 static int parse_bdb_230_dp_max_link_rate(const int vbt_max_link_rate)
 {
 	switch (vbt_max_link_rate) {
@@ -3442,19 +3458,16 @@ bool intel_bios_is_dsi_present(struct drm_i915_private *i915,
 
 		dvo_port = child->dvo_port;
 
-		if (dvo_port == DVO_PORT_MIPIA ||
-		    (dvo_port == DVO_PORT_MIPIB && DISPLAY_VER(i915) >= 11) ||
-		    (dvo_port == DVO_PORT_MIPIC && DISPLAY_VER(i915) < 11)) {
-			if (port)
-				*port = dvo_port - DVO_PORT_MIPIA;
-			return true;
-		} else if (dvo_port == DVO_PORT_MIPIB ||
-			   dvo_port == DVO_PORT_MIPIC ||
-			   dvo_port == DVO_PORT_MIPID) {
+		if (dsi_dvo_port_to_port(i915, dvo_port) == PORT_NONE) {
 			drm_dbg_kms(&i915->drm,
 				    "VBT has unsupported DSI port %c\n",
 				    port_name(dvo_port - DVO_PORT_MIPIA));
+			continue;
 		}
+
+		if (port)
+			*port = dsi_dvo_port_to_port(i915, dvo_port);
+		return true;
 	}
 
 	return false;
@@ -3539,7 +3552,7 @@ bool intel_bios_get_dsc_params(struct intel_encoder *encoder,
 		if (!(child->device_type & DEVICE_TYPE_MIPI_OUTPUT))
 			continue;
 
-		if (child->dvo_port - DVO_PORT_MIPIA == encoder->port) {
+		if (dsi_dvo_port_to_port(i915, child->dvo_port) == encoder->port) {
 			if (!devdata->dsc)
 				return false;
 

