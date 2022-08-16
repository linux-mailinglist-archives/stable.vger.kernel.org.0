Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF58595F55
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 17:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiHPPix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 11:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbiHPPiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 11:38:18 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B676B169
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 08:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660664254; x=1692200254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VCExacxdWUP4V/BC+9n4OY0AEAUDKb6+gvdpP6SUTSs=;
  b=Ph9u7TZneXJtPnjEuqAqvn5LjZaIDgKgPP1vJ3JVWlDe1IUf/O7s4wmA
   lK9DCJY80f9AC6uX4cS2e/04NMopb9/kkMFa4RrvOgcqb7S91gi/YhygX
   kVk/SksR8zLm3caTwMVccIf/wimJ2eB6/QMaXe+QQp+cktLQDOsFcqxAs
   INh2xU3/SuDDnPBNqsgN5f3TtAR5rW1k5yXKeEjWrqxJdD9TOeIg5R0SM
   C9r3Y5g0tiMKsWp2kN1SrgHrcWs7pnA238N5fPgsSzzmdPuspr/x+cJFc
   1liPcwfiIr9savYkklunkyRejpFqFDWgUXcG4p7bjUHVnccP82jyPlT7f
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="272645977"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="272645977"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 08:37:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="635938151"
Received: from kinzelba-mobl.ger.corp.intel.com (HELO localhost) ([10.252.39.194])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 08:37:33 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     jani.nikula@intel.com, stable@vger.kernel.org
Subject: [RESEND 2/3] drm/i915/dsi: fix dual-link DSI backlight and CABC ports for display 11+
Date:   Tue, 16 Aug 2022 18:37:21 +0300
Message-Id: <8c462718bcc7b36a83e09d0a5eef058b6bc8b1a2.1660664162.git.jani.nikula@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1660664162.git.jani.nikula@intel.com>
References: <cover.1660664162.git.jani.nikula@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The VBT dual-link DSI backlight and CABC still use ports A and C, both
in Bspec and code, while display 11+ DSI only supports ports A and
B. Assume port C actually means port B for display 11+ when parsing VBT.

Bspec: 20154
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6476
Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/display/intel_bios.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 51dde5bfd956..198a2f4920cc 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -1596,6 +1596,8 @@ static void parse_dsi_backlight_ports(struct drm_i915_private *i915,
 				      struct intel_panel *panel,
 				      enum port port)
 {
+	enum port port_bc = DISPLAY_VER(i915) >= 11 ? PORT_B : PORT_C;
+
 	if (!panel->vbt.dsi.config->dual_link || i915->vbt.version < 197) {
 		panel->vbt.dsi.bl_ports = BIT(port);
 		if (panel->vbt.dsi.config->cabc_supported)
@@ -1609,11 +1611,11 @@ static void parse_dsi_backlight_ports(struct drm_i915_private *i915,
 		panel->vbt.dsi.bl_ports = BIT(PORT_A);
 		break;
 	case DL_DCS_PORT_C:
-		panel->vbt.dsi.bl_ports = BIT(PORT_C);
+		panel->vbt.dsi.bl_ports = BIT(port_bc);
 		break;
 	default:
 	case DL_DCS_PORT_A_AND_C:
-		panel->vbt.dsi.bl_ports = BIT(PORT_A) | BIT(PORT_C);
+		panel->vbt.dsi.bl_ports = BIT(PORT_A) | BIT(port_bc);
 		break;
 	}
 
@@ -1625,12 +1627,12 @@ static void parse_dsi_backlight_ports(struct drm_i915_private *i915,
 		panel->vbt.dsi.cabc_ports = BIT(PORT_A);
 		break;
 	case DL_DCS_PORT_C:
-		panel->vbt.dsi.cabc_ports = BIT(PORT_C);
+		panel->vbt.dsi.cabc_ports = BIT(port_bc);
 		break;
 	default:
 	case DL_DCS_PORT_A_AND_C:
 		panel->vbt.dsi.cabc_ports =
-					BIT(PORT_A) | BIT(PORT_C);
+					BIT(PORT_A) | BIT(port_bc);
 		break;
 	}
 }
-- 
2.34.1

