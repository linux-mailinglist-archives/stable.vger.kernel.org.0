Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54C25EA5BE
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239512AbiIZMPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbiIZMPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:15:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEA3EE1A;
        Mon, 26 Sep 2022 03:59:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3865F60A5B;
        Mon, 26 Sep 2022 10:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6B9C433D6;
        Mon, 26 Sep 2022 10:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188970;
        bh=qiAtx4nM4YVJnX2eKxyU5dvImu1sEbPiukUfSOlhmkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYRdBvmKYMR/XB+Udht2hFH1pharmJW97LkNe4D2cYTnCtI5CAcc+JtZXZQaTWuth
         029GlhQkdJBaUgbchRrj1/a6lPQmYaYq+DdXE3iO6Zh/cIm0GfHqhsf59h6gssVpP6
         kV/k+O5ZC2Os622KKkdLZumX0139QP+tmgUV3yYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 004/207] drm/i915/bios: Split VBT parsing to global vs. panel specific parts
Date:   Mon, 26 Sep 2022 12:09:53 +0200
Message-Id: <20220926100806.695308865@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit c2fdb424d32204faf5be29d55f0086b611c94e38 ]

Parsing the panel specific data (anything that depends on panel_type)
from VBT is currently happening too early. Split the whole thing
into global vs. panel specific parts so that we can start doing
the panel specific parsing at a later time.

v2: Clarify that this is about panel_type (Jani)
    Split out the leak checks (Jani)

Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220510104242.6099-12-ville.syrjala@linux.intel.com
Stable-dep-of: 607f41768a1e ("drm/i915/dsi: filter invalid backlight and CABC ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c    | 26 +++++++++++---------
 drivers/gpu/drm/i915/display/intel_bios.h    |  1 +
 drivers/gpu/drm/i915/display/intel_display.c |  1 +
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 5ceabc380808..d5cae64b916b 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -2969,18 +2969,7 @@ void intel_bios_init(struct drm_i915_private *i915)
 	/* Grab useful general definitions */
 	parse_general_features(i915);
 	parse_general_definitions(i915);
-	parse_panel_options(i915);
-	parse_generic_dtd(i915);
-	parse_lfp_data(i915);
-	parse_lfp_backlight(i915);
-	parse_sdvo_panel_data(i915);
 	parse_driver_features(i915);
-	parse_panel_driver_features(i915);
-	parse_power_conservation_features(i915);
-	parse_edp(i915);
-	parse_psr(i915);
-	parse_mipi_config(i915);
-	parse_mipi_sequence(i915);
 
 	/* Depends on child device list */
 	parse_compression_parameters(i915);
@@ -2999,6 +2988,21 @@ void intel_bios_init(struct drm_i915_private *i915)
 	kfree(oprom_vbt);
 }
 
+void intel_bios_init_panel(struct drm_i915_private *i915)
+{
+	parse_panel_options(i915);
+	parse_generic_dtd(i915);
+	parse_lfp_data(i915);
+	parse_lfp_backlight(i915);
+	parse_sdvo_panel_data(i915);
+	parse_panel_driver_features(i915);
+	parse_power_conservation_features(i915);
+	parse_edp(i915);
+	parse_psr(i915);
+	parse_mipi_config(i915);
+	parse_mipi_sequence(i915);
+}
+
 /**
  * intel_bios_driver_remove - Free any resources allocated by intel_bios_init()
  * @i915: i915 device instance
diff --git a/drivers/gpu/drm/i915/display/intel_bios.h b/drivers/gpu/drm/i915/display/intel_bios.h
index 4709c4d29805..c744d75fa435 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.h
+++ b/drivers/gpu/drm/i915/display/intel_bios.h
@@ -230,6 +230,7 @@ struct mipi_pps_data {
 } __packed;
 
 void intel_bios_init(struct drm_i915_private *dev_priv);
+void intel_bios_init_panel(struct drm_i915_private *dev_priv);
 void intel_bios_driver_remove(struct drm_i915_private *dev_priv);
 bool intel_bios_is_valid_vbt(const void *buf, size_t size);
 bool intel_bios_is_tv_present(struct drm_i915_private *dev_priv);
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 806d50b302ab..e384db157f34 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -9580,6 +9580,7 @@ int intel_modeset_init_noirq(struct drm_i915_private *i915)
 	}
 
 	intel_bios_init(i915);
+	intel_bios_init_panel(i915);
 
 	ret = intel_vga_register(i915);
 	if (ret)
-- 
2.35.1



