Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDCF595E9F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiHPOzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 10:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235713AbiHPOz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 10:55:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C4C7D790
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 07:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660661723; x=1692197723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VCExacxdWUP4V/BC+9n4OY0AEAUDKb6+gvdpP6SUTSs=;
  b=IL+Z3lGOKju2aaJSocDIx7buK6pBmDGwcvUwQJMr3dbzxrwXde9ZxnKE
   4MgZvbZkLX7SFfeBLkFRkuThmvR06N8k+wqf840R06Vwxy810RDJZK+wZ
   8FFMfct6eHx3xW+rtfWY7vIPK4MJKqf43AyiIgWy0qO6zYblk3wU3yh9X
   0CLeP471/gZpo8ILXV4DUOpl3Hvoe5CFu9gl30puOaLFaWgczXBeTM4ms
   WGLaqAmZBqXwvR5ZoR17jNpmAFqMPxTpUrs1sD+BZJgPj6/M/8M4IH84g
   78pP4oaiiWo6fS3CCHxMZTM7wo7+ouiqduVw86ekfVRfn8P8mx1RrNbH7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="279202186"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="279202186"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 07:55:23 -0700
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="667142443"
Received: from kinzelba-mobl.ger.corp.intel.com (HELO localhost) ([10.252.39.194])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 07:55:21 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     jani.nikula@intel.com, stable@vger.kernel.org
Subject: [PATCH 2/3] drm/i915/dsi: fix dual-link DSI backlight and CABC ports for display 11+
Date:   Tue, 16 Aug 2022 17:55:09 +0300
Message-Id: <8c462718bcc7b36a83e09d0a5eef058b6bc8b1a2.1660661647.git.jani.nikula@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1660661647.git.jani.nikula@intel.com>
References: <cover.1660661647.git.jani.nikula@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

