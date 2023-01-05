Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA70865E958
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 11:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjAEKxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 05:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjAEKwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 05:52:41 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDBF50156
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 02:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672915959; x=1704451959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gVsZs6JLvEkcaiI02uVTmn//nNubkULvkJQ6h66Kv6M=;
  b=P29tQJuVgip4+UyMQgLlaNkMFiZWX32SnUOV2UE1ApenI2Mrr3NCPHjN
   bgvuvLEcZgbC+asoh/+B5X3GpLf+/+/I/OpIoXJOohexCQACmJATByj6d
   tzzar9PcqGnAY09eiLfQ0eWSKmD9nIbm3CwK2gM1/T0b6OXs2MDvCrSCG
   YdhCQcVNH8CqcR89NdxI/PbSWvOgtT+4TLCpBVql1+5fdJI59SG3V3rD3
   A9OyMgA9vWF9/INtRndUUaCdmY1kbsMpvUr6vsSmqWuqpK4Suwpym62OJ
   0koFL2nxAzADN7eFCJZy9hatusPabSa0ObA56q9H5NkxS1VOBd6FmQKT6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="384468241"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="384468241"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 02:52:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="648886603"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="648886603"
Received: from swathish-mobl.ger.corp.intel.com (HELO localhost) ([10.252.10.152])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 02:52:37 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     stable@vger.kernel.org
Cc:     jani.nikula@intel.com,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [6.1 BACKPORT 1/2] drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence
Date:   Thu,  5 Jan 2023 12:52:26 +0200
Message-Id: <20230105105227.689222-2-jani.nikula@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230105105227.689222-1-jani.nikula@intel.com>
References: <20230105105227.689222-1-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 963bbdb32b47cfa67a449e715e1dcc525fbd01fc upstream.

Starting from ICL, the default for MIPI GPIO sequences seems to be using
native GPIOs i.e. GPIOs available in the GPU. These native GPIOs reuse
many pins that quite frankly seem scary to poke based on the VBT
sequences. We pretty much have to trust that the board is configured
such that the relevant HPD, PP_CONTROL and GPIO bits aren't used for
anything else.

MIPI sequence v4 also adds a flag to fall back to non-native sequences.

v5:
- Wrap SHOTPLUG_CTL_DDI modification in spin_lock() in icp_irq_handler()
  too (Ville)
- References instead of Closes issue 6131 because this does not fix everything

v4:
- Wrap SHOTPLUG_CTL_DDI modification in spin_lock_irq() (Ville)

v3:
- Fix -Wbitwise-conditional-parentheses (kernel test robot <lkp@intel.com>)

v2:
- Fix HPD pin output set (impacts GPIOs 0 and 5)
- Fix GPIO data output direction set (impacts GPIOs 4 and 9)
- Reduce register accesses to single intel_de_rwm()

References: https://gitlab.freedesktop.org/drm/intel/-/issues/6131
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221219105955.4014451-1-jani.nikula@intel.com
(cherry picked from commit f087cfe6fcff58044f7aa3b284965af47f472fb0)
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c | 94 +++++++++++++++++++-
 drivers/gpu/drm/i915/i915_irq.c              |  3 +
 drivers/gpu/drm/i915/i915_reg.h              |  1 +
 3 files changed, 95 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
index 75e8cc4337c9..e3e0cb4da491 100644
--- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
@@ -41,9 +41,11 @@
 
 #include "i915_drv.h"
 #include "i915_reg.h"
+#include "intel_de.h"
 #include "intel_display_types.h"
 #include "intel_dsi.h"
 #include "intel_dsi_vbt.h"
+#include "intel_gmbus_regs.h"
 #include "vlv_dsi.h"
 #include "vlv_dsi_regs.h"
 #include "vlv_sideband.h"
@@ -377,6 +379,85 @@ static void icl_exec_gpio(struct intel_connector *connector,
 	drm_dbg_kms(&dev_priv->drm, "Skipping ICL GPIO element execution\n");
 }
 
+enum {
+	MIPI_RESET_1 = 0,
+	MIPI_AVDD_EN_1,
+	MIPI_BKLT_EN_1,
+	MIPI_AVEE_EN_1,
+	MIPI_VIO_EN_1,
+	MIPI_RESET_2,
+	MIPI_AVDD_EN_2,
+	MIPI_BKLT_EN_2,
+	MIPI_AVEE_EN_2,
+	MIPI_VIO_EN_2,
+};
+
+static void icl_native_gpio_set_value(struct drm_i915_private *dev_priv,
+				      int gpio, bool value)
+{
+	int index;
+
+	if (drm_WARN_ON(&dev_priv->drm, DISPLAY_VER(dev_priv) == 11 && gpio >= MIPI_RESET_2))
+		return;
+
+	switch (gpio) {
+	case MIPI_RESET_1:
+	case MIPI_RESET_2:
+		index = gpio == MIPI_RESET_1 ? HPD_PORT_A : HPD_PORT_B;
+
+		/*
+		 * Disable HPD to set the pin to output, and set output
+		 * value. The HPD pin should not be enabled for DSI anyway,
+		 * assuming the board design and VBT are sane, and the pin isn't
+		 * used by a non-DSI encoder.
+		 *
+		 * The locking protects against concurrent SHOTPLUG_CTL_DDI
+		 * modifications in irq setup and handling.
+		 */
+		spin_lock_irq(&dev_priv->irq_lock);
+		intel_de_rmw(dev_priv, SHOTPLUG_CTL_DDI,
+			     SHOTPLUG_CTL_DDI_HPD_ENABLE(index) |
+			     SHOTPLUG_CTL_DDI_HPD_OUTPUT_DATA(index),
+			     value ? SHOTPLUG_CTL_DDI_HPD_OUTPUT_DATA(index) : 0);
+		spin_unlock_irq(&dev_priv->irq_lock);
+		break;
+	case MIPI_AVDD_EN_1:
+	case MIPI_AVDD_EN_2:
+		index = gpio == MIPI_AVDD_EN_1 ? 0 : 1;
+
+		intel_de_rmw(dev_priv, PP_CONTROL(index), PANEL_POWER_ON,
+			     value ? PANEL_POWER_ON : 0);
+		break;
+	case MIPI_BKLT_EN_1:
+	case MIPI_BKLT_EN_2:
+		index = gpio == MIPI_AVDD_EN_1 ? 0 : 1;
+
+		intel_de_rmw(dev_priv, PP_CONTROL(index), EDP_BLC_ENABLE,
+			     value ? EDP_BLC_ENABLE : 0);
+		break;
+	case MIPI_AVEE_EN_1:
+	case MIPI_AVEE_EN_2:
+		index = gpio == MIPI_AVEE_EN_1 ? 1 : 2;
+
+		intel_de_rmw(dev_priv, GPIO(dev_priv, index),
+			     GPIO_CLOCK_VAL_OUT,
+			     GPIO_CLOCK_DIR_MASK | GPIO_CLOCK_DIR_OUT |
+			     GPIO_CLOCK_VAL_MASK | (value ? GPIO_CLOCK_VAL_OUT : 0));
+		break;
+	case MIPI_VIO_EN_1:
+	case MIPI_VIO_EN_2:
+		index = gpio == MIPI_VIO_EN_1 ? 1 : 2;
+
+		intel_de_rmw(dev_priv, GPIO(dev_priv, index),
+			     GPIO_DATA_VAL_OUT,
+			     GPIO_DATA_DIR_MASK | GPIO_DATA_DIR_OUT |
+			     GPIO_DATA_VAL_MASK | (value ? GPIO_DATA_VAL_OUT : 0));
+		break;
+	default:
+		MISSING_CASE(gpio);
+	}
+}
+
 static const u8 *mipi_exec_gpio(struct intel_dsi *intel_dsi, const u8 *data)
 {
 	struct drm_device *dev = intel_dsi->base.base.dev;
@@ -384,8 +465,7 @@ static const u8 *mipi_exec_gpio(struct intel_dsi *intel_dsi, const u8 *data)
 	struct intel_connector *connector = intel_dsi->attached_connector;
 	u8 gpio_source, gpio_index = 0, gpio_number;
 	bool value;
-
-	drm_dbg_kms(&dev_priv->drm, "\n");
+	bool native = DISPLAY_VER(dev_priv) >= 11;
 
 	if (connector->panel.vbt.dsi.seq_version >= 3)
 		gpio_index = *data++;
@@ -398,10 +478,18 @@ static const u8 *mipi_exec_gpio(struct intel_dsi *intel_dsi, const u8 *data)
 	else
 		gpio_source = 0;
 
+	if (connector->panel.vbt.dsi.seq_version >= 4 && *data & BIT(1))
+		native = false;
+
 	/* pull up/down */
 	value = *data++ & 1;
 
-	if (DISPLAY_VER(dev_priv) >= 11)
+	drm_dbg_kms(&dev_priv->drm, "GPIO index %u, number %u, source %u, native %s, set to %s\n",
+		    gpio_index, gpio_number, gpio_source, str_yes_no(native), str_on_off(value));
+
+	if (native)
+		icl_native_gpio_set_value(dev_priv, gpio_number, value);
+	else if (DISPLAY_VER(dev_priv) >= 11)
 		icl_exec_gpio(connector, gpio_source, gpio_index, value);
 	else if (IS_VALLEYVIEW(dev_priv))
 		vlv_exec_gpio(connector, gpio_source, gpio_number, value);
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 86a42d9e8041..f93ffa6626a5 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1981,8 +1981,11 @@ static void icp_irq_handler(struct drm_i915_private *dev_priv, u32 pch_iir)
 	if (ddi_hotplug_trigger) {
 		u32 dig_hotplug_reg;
 
+		/* Locking due to DSI native GPIO sequences */
+		spin_lock(&dev_priv->irq_lock);
 		dig_hotplug_reg = intel_uncore_read(&dev_priv->uncore, SHOTPLUG_CTL_DDI);
 		intel_uncore_write(&dev_priv->uncore, SHOTPLUG_CTL_DDI, dig_hotplug_reg);
+		spin_unlock(&dev_priv->irq_lock);
 
 		intel_get_hpd_pins(dev_priv, &pin_mask, &long_mask,
 				   ddi_hotplug_trigger, dig_hotplug_reg,
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index da35bb2db26b..64eacd11b8bf 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -6035,6 +6035,7 @@
 
 #define SHOTPLUG_CTL_DDI				_MMIO(0xc4030)
 #define   SHOTPLUG_CTL_DDI_HPD_ENABLE(hpd_pin)			(0x8 << (_HPD_PIN_DDI(hpd_pin) * 4))
+#define   SHOTPLUG_CTL_DDI_HPD_OUTPUT_DATA(hpd_pin)		(0x4 << (_HPD_PIN_DDI(hpd_pin) * 4))
 #define   SHOTPLUG_CTL_DDI_HPD_STATUS_MASK(hpd_pin)		(0x3 << (_HPD_PIN_DDI(hpd_pin) * 4))
 #define   SHOTPLUG_CTL_DDI_HPD_NO_DETECT(hpd_pin)		(0x0 << (_HPD_PIN_DDI(hpd_pin) * 4))
 #define   SHOTPLUG_CTL_DDI_HPD_SHORT_DETECT(hpd_pin)		(0x1 << (_HPD_PIN_DDI(hpd_pin) * 4))
-- 
2.34.1

