Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5345AECC4
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241223AbiIFOUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241514AbiIFOSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:18:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32018193C2;
        Tue,  6 Sep 2022 06:49:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ED4C61562;
        Tue,  6 Sep 2022 13:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBF1C433D6;
        Tue,  6 Sep 2022 13:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472098;
        bh=poronbKLaQ8gfUqenQsdKfMK8ky2B+jaivpBo/e1OME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdYwqGxxUuZ7LqFr50Mlu6avuzNwWqfsABQAHLG7sDGXATR56x1nf7gbwryuFXX8n
         us2effpLzQq3+uhwLu/i4EcB+OYyKxZsArDeSAGTyVoYa2NVd1O4VFFM4rRutTWtW+
         B6QoxRPmId6g9NA5dZ1y/9GAVNxl1+SAqVADG6Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.19 148/155] drm/i915/backlight: Disable pps power hook for aux based backlight
Date:   Tue,  6 Sep 2022 15:31:36 +0200
Message-Id: <20220906132835.672539262@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Högander <jouni.hogander@intel.com>

commit 51fbbe8a3f8b9dd128fa98f6ea36058dfa3f36de upstream.

Pps power hook seems to be problematic for backlight controlled via
aux channel. Disable it for such cases.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3657
Cc: stable@vger.kernel.org
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220822140836.534432-1-jouni.hogander@intel.com
(cherry picked from commit 869e3bb7acb59d88c1226892136661810e8223a4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_backlight.c |   11 ++++++++---
 drivers/gpu/drm/i915/display/intel_dp.c        |    2 --
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_backlight.c
@@ -15,6 +15,7 @@
 #include "intel_dsi_dcs_backlight.h"
 #include "intel_panel.h"
 #include "intel_pci_config.h"
+#include "intel_pps.h"
 
 /**
  * scale - scale values from one range to another
@@ -1769,9 +1770,13 @@ void intel_backlight_init_funcs(struct i
 		panel->backlight.pwm_funcs = &i9xx_pwm_funcs;
 	}
 
-	if (connector->base.connector_type == DRM_MODE_CONNECTOR_eDP &&
-	    intel_dp_aux_init_backlight_funcs(connector) == 0)
-		return;
+	if (connector->base.connector_type == DRM_MODE_CONNECTOR_eDP) {
+		if (intel_dp_aux_init_backlight_funcs(connector) == 0)
+			return;
+
+		if (!(dev_priv->quirks & QUIRK_NO_PPS_BACKLIGHT_POWER_HOOK))
+			connector->panel.backlight.power = intel_pps_backlight_power;
+	}
 
 	/* We're using a standard PWM backlight interface */
 	panel->backlight.funcs = &pwm_bl_funcs;
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -5248,8 +5248,6 @@ static bool intel_edp_init_connector(str
 
 	intel_panel_init(intel_connector);
 
-	if (!(dev_priv->quirks & QUIRK_NO_PPS_BACKLIGHT_POWER_HOOK))
-		intel_connector->panel.backlight.power = intel_pps_backlight_power;
 	intel_backlight_setup(intel_connector, pipe);
 
 	intel_edp_add_properties(intel_dp);


