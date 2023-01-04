Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEAA65D770
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbjADPo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbjADPoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:44:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CC5321B7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:44:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C8E561780
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10FDC433D2;
        Wed,  4 Jan 2023 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672847051;
        bh=7FkDezX4ZhLJfTKSAW1cB7lkVW+ym8DfqvZvmWgEkh8=;
        h=Subject:To:Cc:From:Date:From;
        b=NKqMbhpgu4oqDeE7ny3f7Y6mmQ3y+uDDwS6mZ2Miy2xGFp7F3B+TUL07w5RGjkxxL
         IjdiraAm1gNGdI+oxy9n3om5IiiOMRfJbX6XS4+hzmAmpISFx+IP4GZPjPsWaIEg4c
         t4wQtEz1xKNLU8/vg0Q3i/K3a6an9FHJsbeAjIq4=
Subject: FAILED: patch "[PATCH] drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence" failed to apply to 6.1-stable tree
To:     jani.nikula@intel.com, lkp@intel.com, rodrigo.vivi@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:44:08 +0100
Message-ID: <167284704812263@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

963bbdb32b47 ("drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence")
8cee664d3eb6 ("drm/i915: use proper helper for register updates")
e58c2cac2c21 ("drm/i915/display: Use intel_uncore alias if defined")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 963bbdb32b47cfa67a449e715e1dcc525fbd01fc Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Mon, 19 Dec 2022 12:59:55 +0200
Subject: [PATCH] drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
index fce69fa446d5..41f025f089d9 100644
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
index edfe363af838..91c533986041 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1974,7 +1974,10 @@ static void icp_irq_handler(struct drm_i915_private *dev_priv, u32 pch_iir)
 	if (ddi_hotplug_trigger) {
 		u32 dig_hotplug_reg;
 
+		/* Locking due to DSI native GPIO sequences */
+		spin_lock(&dev_priv->irq_lock);
 		dig_hotplug_reg = intel_uncore_rmw(&dev_priv->uncore, SHOTPLUG_CTL_DDI, 0, 0);
+		spin_unlock(&dev_priv->irq_lock);
 
 		intel_get_hpd_pins(dev_priv, &pin_mask, &long_mask,
 				   ddi_hotplug_trigger, dig_hotplug_reg,
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 8e1892d14774..916176872544 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -5988,6 +5988,7 @@
 
 #define SHOTPLUG_CTL_DDI				_MMIO(0xc4030)
 #define   SHOTPLUG_CTL_DDI_HPD_ENABLE(hpd_pin)			(0x8 << (_HPD_PIN_DDI(hpd_pin) * 4))
+#define   SHOTPLUG_CTL_DDI_HPD_OUTPUT_DATA(hpd_pin)		(0x4 << (_HPD_PIN_DDI(hpd_pin) * 4))
 #define   SHOTPLUG_CTL_DDI_HPD_STATUS_MASK(hpd_pin)		(0x3 << (_HPD_PIN_DDI(hpd_pin) * 4))
 #define   SHOTPLUG_CTL_DDI_HPD_NO_DETECT(hpd_pin)		(0x0 << (_HPD_PIN_DDI(hpd_pin) * 4))
 #define   SHOTPLUG_CTL_DDI_HPD_SHORT_DETECT(hpd_pin)		(0x1 << (_HPD_PIN_DDI(hpd_pin) * 4))

