Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D03E6210CB
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiKHMcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbiKHMcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:32:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A767120A8
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:32:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB89F61514
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D24C433D6;
        Tue,  8 Nov 2022 12:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667910765;
        bh=bfX/p/oGtbbGUMrENjDm8n2sCQ4DhwCmNd0tFq54jRQ=;
        h=Subject:To:Cc:From:Date:From;
        b=HmAh49+uOkimYU8k4APesA7YCc9WCA5kzIiw57aEtpZVDOAhAopWw9n+2l0PuuhTd
         EuYyoHn6xvjcaZIkT8HHRLYts17v3uEE8y4aZT3/Zxuv6/SBtvAIYSPjvtjweInF6x
         xVj6aftUAsU+WWdIAQSwO9sDgXCgFEUQ2hb2kUM4=
Subject: FAILED: patch "[PATCH] drm/i915/tgl+: Add locking around DKL PHY register accesses" failed to apply to 5.15-stable tree
To:     imre.deak@intel.com, jani.nikula@intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Nov 2022 13:32:34 +0100
Message-ID: <166791075463159@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d7164a5048e8 ("drm/i915/tgl+: Add locking around DKL PHY register accesses")
b7d1559038b6 ("drm/i915: move dbuf under display sub-struct")
90b87cf24304 ("drm/i915: move mipi_mmio_base to display.dsi")
d51309b4e9aa ("drm/i915: move and group cdclk under display.cdclk")
f0acaf9d6912 ("drm/i915: move and group max_bw and bw_obj under display.bw")
eb11eabc5f26 ("drm/i915: move and group hdcp under display.hdcp")
b3d81dafdc48 ("drm/i915: move and group fbdev under display.fbdev")
36d225f365e7 ("drm/i915: move dpll under display.dpll")
4be1c12c880e ("drm/i915: move and split audio under display.audio and display.funcs")
6c77055aa674 ("drm/i915: move dmc to display.dmc")
12dc50823845 ("drm/i915: move and group pps members under display.pps")
203eb5a98edb ("drm/i915: move and group gmbus members under display.gmbus")
34dc3cc5017f ("drm/i915: move color_funcs to display.funcs")
06a50913d96e ("drm/i915: move fdi_funcs to display.funcs")
103472c13f0a ("drm/i915: move wm_disp funcs to display.funcs")
5a04eb5be8e4 ("drm/i915: move hotplug_funcs to display.funcs")
ae611d171ec0 ("drm/i915: move dpll_funcs to display.funcs")
986531bd0e72 ("drm/i915: move cdclk_funcs to display.funcs")
3b10f8517648 ("drm/i915: add display sub-struct to drm_i915_private")
c247cd03898c ("drm/i915: fix null pointer dereference")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d7164a5048e8a6afe2cc4aaf7f12643c14e7f241 Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Tue, 25 Oct 2022 14:44:55 +0300
Subject: [PATCH] drm/i915/tgl+: Add locking around DKL PHY register accesses
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Accessing the TypeC DKL PHY registers during modeset-commit,
-verification, DP link-retraining and AUX power well toggling is racy
due to these code paths being concurrent and the PHY register bank
selection register (HIP_INDEX_REG) being shared between PHY instances
(aka TC ports) and the bank selection being not atomic wrt. the actual
PHY register access.

Add the required locking around each PHY register bank selection->
register access sequence.

Kudos to Ville for noticing the race conditions.

v2:
- Add the DKL PHY register accessors to intel_dkl_phy.[ch]. (Jani)
- Make the DKL_REG_TC_PORT macro independent of PHY internals.
- Move initing the DKL PHY lock to a more logical place.

v3:
- Fix parameter reuse in the DKL_REG_TC_PORT definition.
- Document the usage of phy_lock.

v4:
- Fix adding TC_PORT_1 offset in the DKL_REG_TC_PORT definition.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221025114457.2191004-1-imre.deak@intel.com
(cherry picked from commit 89cb0ba4ceee6bed1059904859c5723b3f39da68)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index a26edcdadc21..cea00aaca04b 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -282,6 +282,7 @@ i915-y += \
 	display/intel_ddi.o \
 	display/intel_ddi_buf_trans.o \
 	display/intel_display_trace.o \
+	display/intel_dkl_phy.o \
 	display/intel_dp.o \
 	display/intel_dp_aux.o \
 	display/intel_dp_aux_backlight.o \
diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index da8472cdc135..69ecf2a3d6c6 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -43,6 +43,7 @@
 #include "intel_de.h"
 #include "intel_display_power.h"
 #include "intel_display_types.h"
+#include "intel_dkl_phy.h"
 #include "intel_dp.h"
 #include "intel_dp_link_training.h"
 #include "intel_dp_mst.h"
@@ -1262,33 +1263,30 @@ static void tgl_dkl_phy_set_signal_levels(struct intel_encoder *encoder,
 	for (ln = 0; ln < 2; ln++) {
 		int level;
 
-		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
-			       HIP_INDEX_VAL(tc_port, ln));
-
-		intel_de_write(dev_priv, DKL_TX_PMD_LANE_SUS(tc_port), 0);
+		intel_dkl_phy_write(dev_priv, DKL_TX_PMD_LANE_SUS(tc_port), ln, 0);
 
 		level = intel_ddi_level(encoder, crtc_state, 2*ln+0);
 
-		intel_de_rmw(dev_priv, DKL_TX_DPCNTL0(tc_port),
-			     DKL_TX_PRESHOOT_COEFF_MASK |
-			     DKL_TX_DE_EMPAHSIS_COEFF_MASK |
-			     DKL_TX_VSWING_CONTROL_MASK,
-			     DKL_TX_PRESHOOT_COEFF(trans->entries[level].dkl.preshoot) |
-			     DKL_TX_DE_EMPHASIS_COEFF(trans->entries[level].dkl.de_emphasis) |
-			     DKL_TX_VSWING_CONTROL(trans->entries[level].dkl.vswing));
+		intel_dkl_phy_rmw(dev_priv, DKL_TX_DPCNTL0(tc_port), ln,
+				  DKL_TX_PRESHOOT_COEFF_MASK |
+				  DKL_TX_DE_EMPAHSIS_COEFF_MASK |
+				  DKL_TX_VSWING_CONTROL_MASK,
+				  DKL_TX_PRESHOOT_COEFF(trans->entries[level].dkl.preshoot) |
+				  DKL_TX_DE_EMPHASIS_COEFF(trans->entries[level].dkl.de_emphasis) |
+				  DKL_TX_VSWING_CONTROL(trans->entries[level].dkl.vswing));
 
 		level = intel_ddi_level(encoder, crtc_state, 2*ln+1);
 
-		intel_de_rmw(dev_priv, DKL_TX_DPCNTL1(tc_port),
-			     DKL_TX_PRESHOOT_COEFF_MASK |
-			     DKL_TX_DE_EMPAHSIS_COEFF_MASK |
-			     DKL_TX_VSWING_CONTROL_MASK,
-			     DKL_TX_PRESHOOT_COEFF(trans->entries[level].dkl.preshoot) |
-			     DKL_TX_DE_EMPHASIS_COEFF(trans->entries[level].dkl.de_emphasis) |
-			     DKL_TX_VSWING_CONTROL(trans->entries[level].dkl.vswing));
+		intel_dkl_phy_rmw(dev_priv, DKL_TX_DPCNTL1(tc_port), ln,
+				  DKL_TX_PRESHOOT_COEFF_MASK |
+				  DKL_TX_DE_EMPAHSIS_COEFF_MASK |
+				  DKL_TX_VSWING_CONTROL_MASK,
+				  DKL_TX_PRESHOOT_COEFF(trans->entries[level].dkl.preshoot) |
+				  DKL_TX_DE_EMPHASIS_COEFF(trans->entries[level].dkl.de_emphasis) |
+				  DKL_TX_VSWING_CONTROL(trans->entries[level].dkl.vswing));
 
-		intel_de_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port),
-			     DKL_TX_DP20BITMODE, 0);
+		intel_dkl_phy_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port), ln,
+				  DKL_TX_DP20BITMODE, 0);
 
 		if (IS_ALDERLAKE_P(dev_priv)) {
 			u32 val;
@@ -1306,10 +1304,10 @@ static void tgl_dkl_phy_set_signal_levels(struct intel_encoder *encoder,
 				val |= DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(0);
 			}
 
-			intel_de_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port),
-				     DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK |
-				     DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK,
-				     val);
+			intel_dkl_phy_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port), ln,
+					  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK |
+					  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK,
+					  val);
 		}
 	}
 }
@@ -2019,12 +2017,8 @@ icl_program_mg_dp_mode(struct intel_digital_port *dig_port,
 		return;
 
 	if (DISPLAY_VER(dev_priv) >= 12) {
-		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
-			       HIP_INDEX_VAL(tc_port, 0x0));
-		ln0 = intel_de_read(dev_priv, DKL_DP_MODE(tc_port));
-		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
-			       HIP_INDEX_VAL(tc_port, 0x1));
-		ln1 = intel_de_read(dev_priv, DKL_DP_MODE(tc_port));
+		ln0 = intel_dkl_phy_read(dev_priv, DKL_DP_MODE(tc_port), 0);
+		ln1 = intel_dkl_phy_read(dev_priv, DKL_DP_MODE(tc_port), 1);
 	} else {
 		ln0 = intel_de_read(dev_priv, MG_DP_MODE(0, tc_port));
 		ln1 = intel_de_read(dev_priv, MG_DP_MODE(1, tc_port));
@@ -2085,12 +2079,8 @@ icl_program_mg_dp_mode(struct intel_digital_port *dig_port,
 	}
 
 	if (DISPLAY_VER(dev_priv) >= 12) {
-		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
-			       HIP_INDEX_VAL(tc_port, 0x0));
-		intel_de_write(dev_priv, DKL_DP_MODE(tc_port), ln0);
-		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
-			       HIP_INDEX_VAL(tc_port, 0x1));
-		intel_de_write(dev_priv, DKL_DP_MODE(tc_port), ln1);
+		intel_dkl_phy_write(dev_priv, DKL_DP_MODE(tc_port), 0, ln0);
+		intel_dkl_phy_write(dev_priv, DKL_DP_MODE(tc_port), 1, ln1);
 	} else {
 		intel_de_write(dev_priv, MG_DP_MODE(0, tc_port), ln0);
 		intel_de_write(dev_priv, MG_DP_MODE(1, tc_port), ln1);
@@ -3094,10 +3084,8 @@ static void adlp_tbt_to_dp_alt_switch_wa(struct intel_encoder *encoder)
 	enum tc_port tc_port = intel_port_to_tc(i915, encoder->port);
 	int ln;
 
-	for (ln = 0; ln < 2; ln++) {
-		intel_de_write(i915, HIP_INDEX_REG(tc_port), HIP_INDEX_VAL(tc_port, ln));
-		intel_de_rmw(i915, DKL_PCS_DW5(tc_port), DKL_PCS_DW5_CORE_SOFTRESET, 0);
-	}
+	for (ln = 0; ln < 2; ln++)
+		intel_dkl_phy_rmw(i915, DKL_PCS_DW5(tc_port), ln, DKL_PCS_DW5_CORE_SOFTRESET, 0);
 }
 
 static void intel_ddi_prepare_link_retrain(struct intel_dp *intel_dp,
diff --git a/drivers/gpu/drm/i915/display/intel_display_core.h b/drivers/gpu/drm/i915/display/intel_display_core.h
index 96cf994b0ad1..9b51148e8ba5 100644
--- a/drivers/gpu/drm/i915/display/intel_display_core.h
+++ b/drivers/gpu/drm/i915/display/intel_display_core.h
@@ -315,6 +315,14 @@ struct intel_display {
 		struct intel_global_obj obj;
 	} dbuf;
 
+	struct {
+		/*
+		 * dkl.phy_lock protects against concurrent access of the
+		 * Dekel TypeC PHYs.
+		 */
+		spinlock_t phy_lock;
+	} dkl;
+
 	struct {
 		/* VLV/CHV/BXT/GLK DSI MMIO register base address */
 		u32 mmio_base;
diff --git a/drivers/gpu/drm/i915/display/intel_display_power_well.c b/drivers/gpu/drm/i915/display/intel_display_power_well.c
index df7ee4969ef1..1d18eee56253 100644
--- a/drivers/gpu/drm/i915/display/intel_display_power_well.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power_well.c
@@ -12,6 +12,7 @@
 #include "intel_de.h"
 #include "intel_display_power_well.h"
 #include "intel_display_types.h"
+#include "intel_dkl_phy.h"
 #include "intel_dmc.h"
 #include "intel_dpio_phy.h"
 #include "intel_dpll.h"
@@ -529,11 +530,9 @@ icl_tc_phy_aux_power_well_enable(struct drm_i915_private *dev_priv,
 		enum tc_port tc_port;
 
 		tc_port = TGL_AUX_PW_TO_TC_PORT(i915_power_well_instance(power_well)->hsw.idx);
-		intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
-			       HIP_INDEX_VAL(tc_port, 0x2));
 
-		if (intel_de_wait_for_set(dev_priv, DKL_CMN_UC_DW_27(tc_port),
-					  DKL_CMN_UC_DW27_UC_HEALTH, 1))
+		if (wait_for(intel_dkl_phy_read(dev_priv, DKL_CMN_UC_DW_27(tc_port), 2) &
+			     DKL_CMN_UC_DW27_UC_HEALTH, 1))
 			drm_warn(&dev_priv->drm,
 				 "Timeout waiting TC uC health\n");
 	}
diff --git a/drivers/gpu/drm/i915/display/intel_dkl_phy.c b/drivers/gpu/drm/i915/display/intel_dkl_phy.c
new file mode 100644
index 000000000000..710b030c7ed5
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_dkl_phy.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright © 2022 Intel Corporation
+ */
+
+#include "i915_drv.h"
+#include "i915_reg.h"
+
+#include "intel_de.h"
+#include "intel_display.h"
+#include "intel_dkl_phy.h"
+
+static void
+dkl_phy_set_hip_idx(struct drm_i915_private *i915, i915_reg_t reg, int idx)
+{
+	enum tc_port tc_port = DKL_REG_TC_PORT(reg);
+
+	drm_WARN_ON(&i915->drm, tc_port < TC_PORT_1 || tc_port >= I915_MAX_TC_PORTS);
+
+	intel_de_write(i915,
+		       HIP_INDEX_REG(tc_port),
+		       HIP_INDEX_VAL(tc_port, idx));
+}
+
+/**
+ * intel_dkl_phy_read - read a Dekel PHY register
+ * @i915: i915 device instance
+ * @reg: Dekel PHY register
+ * @ln: lane instance of @reg
+ *
+ * Read the @reg Dekel PHY register.
+ *
+ * Returns the read value.
+ */
+u32
+intel_dkl_phy_read(struct drm_i915_private *i915, i915_reg_t reg, int ln)
+{
+	u32 val;
+
+	spin_lock(&i915->display.dkl.phy_lock);
+
+	dkl_phy_set_hip_idx(i915, reg, ln);
+	val = intel_de_read(i915, reg);
+
+	spin_unlock(&i915->display.dkl.phy_lock);
+
+	return val;
+}
+
+/**
+ * intel_dkl_phy_write - write a Dekel PHY register
+ * @i915: i915 device instance
+ * @reg: Dekel PHY register
+ * @ln: lane instance of @reg
+ * @val: value to write
+ *
+ * Write @val to the @reg Dekel PHY register.
+ */
+void
+intel_dkl_phy_write(struct drm_i915_private *i915, i915_reg_t reg, int ln, u32 val)
+{
+	spin_lock(&i915->display.dkl.phy_lock);
+
+	dkl_phy_set_hip_idx(i915, reg, ln);
+	intel_de_write(i915, reg, val);
+
+	spin_unlock(&i915->display.dkl.phy_lock);
+}
+
+/**
+ * intel_dkl_phy_rmw - read-modify-write a Dekel PHY register
+ * @i915: i915 device instance
+ * @reg: Dekel PHY register
+ * @ln: lane instance of @reg
+ * @clear: mask to clear
+ * @set: mask to set
+ *
+ * Read the @reg Dekel PHY register, clearing then setting the @clear/@set bits in it, and writing
+ * this value back to the register if the value differs from the read one.
+ */
+void
+intel_dkl_phy_rmw(struct drm_i915_private *i915, i915_reg_t reg, int ln, u32 clear, u32 set)
+{
+	spin_lock(&i915->display.dkl.phy_lock);
+
+	dkl_phy_set_hip_idx(i915, reg, ln);
+	intel_de_rmw(i915, reg, clear, set);
+
+	spin_unlock(&i915->display.dkl.phy_lock);
+}
+
+/**
+ * intel_dkl_phy_posting_read - do a posting read from a Dekel PHY register
+ * @i915: i915 device instance
+ * @reg: Dekel PHY register
+ * @ln: lane instance of @reg
+ *
+ * Read the @reg Dekel PHY register without returning the read value.
+ */
+void
+intel_dkl_phy_posting_read(struct drm_i915_private *i915, i915_reg_t reg, int ln)
+{
+	spin_lock(&i915->display.dkl.phy_lock);
+
+	dkl_phy_set_hip_idx(i915, reg, ln);
+	intel_de_posting_read(i915, reg);
+
+	spin_unlock(&i915->display.dkl.phy_lock);
+}
diff --git a/drivers/gpu/drm/i915/display/intel_dkl_phy.h b/drivers/gpu/drm/i915/display/intel_dkl_phy.h
new file mode 100644
index 000000000000..260ad121a0b1
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_dkl_phy.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2022 Intel Corporation
+ */
+
+#ifndef __INTEL_DKL_PHY_H__
+#define __INTEL_DKL_PHY_H__
+
+#include <linux/types.h>
+
+#include "i915_reg_defs.h"
+
+struct drm_i915_private;
+
+u32
+intel_dkl_phy_read(struct drm_i915_private *i915, i915_reg_t reg, int ln);
+void
+intel_dkl_phy_write(struct drm_i915_private *i915, i915_reg_t reg, int ln, u32 val);
+void
+intel_dkl_phy_rmw(struct drm_i915_private *i915, i915_reg_t reg, int ln, u32 clear, u32 set);
+void
+intel_dkl_phy_posting_read(struct drm_i915_private *i915, i915_reg_t reg, int ln);
+
+#endif /* __INTEL_DKL_PHY_H__ */
diff --git a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
index e5fb66a5dd02..64dd603dc69a 100644
--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -25,6 +25,7 @@
 
 #include "intel_de.h"
 #include "intel_display_types.h"
+#include "intel_dkl_phy.h"
 #include "intel_dpio_phy.h"
 #include "intel_dpll.h"
 #include "intel_dpll_mgr.h"
@@ -3508,15 +3509,12 @@ static bool dkl_pll_get_hw_state(struct drm_i915_private *dev_priv,
 	 * All registers read here have the same HIP_INDEX_REG even though
 	 * they are on different building blocks
 	 */
-	intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
-		       HIP_INDEX_VAL(tc_port, 0x2));
-
-	hw_state->mg_refclkin_ctl = intel_de_read(dev_priv,
-						  DKL_REFCLKIN_CTL(tc_port));
+	hw_state->mg_refclkin_ctl = intel_dkl_phy_read(dev_priv,
+						       DKL_REFCLKIN_CTL(tc_port), 2);
 	hw_state->mg_refclkin_ctl &= MG_REFCLKIN_CTL_OD_2_MUX_MASK;
 
 	hw_state->mg_clktop2_hsclkctl =
-		intel_de_read(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port));
+		intel_dkl_phy_read(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port), 2);
 	hw_state->mg_clktop2_hsclkctl &=
 		MG_CLKTOP2_HSCLKCTL_TLINEDRV_CLKSEL_MASK |
 		MG_CLKTOP2_HSCLKCTL_CORE_INPUTSEL_MASK |
@@ -3524,32 +3522,32 @@ static bool dkl_pll_get_hw_state(struct drm_i915_private *dev_priv,
 		MG_CLKTOP2_HSCLKCTL_DSDIV_RATIO_MASK;
 
 	hw_state->mg_clktop2_coreclkctl1 =
-		intel_de_read(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port));
+		intel_dkl_phy_read(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port), 2);
 	hw_state->mg_clktop2_coreclkctl1 &=
 		MG_CLKTOP2_CORECLKCTL1_A_DIVRATIO_MASK;
 
-	hw_state->mg_pll_div0 = intel_de_read(dev_priv, DKL_PLL_DIV0(tc_port));
+	hw_state->mg_pll_div0 = intel_dkl_phy_read(dev_priv, DKL_PLL_DIV0(tc_port), 2);
 	val = DKL_PLL_DIV0_MASK;
 	if (dev_priv->display.vbt.override_afc_startup)
 		val |= DKL_PLL_DIV0_AFC_STARTUP_MASK;
 	hw_state->mg_pll_div0 &= val;
 
-	hw_state->mg_pll_div1 = intel_de_read(dev_priv, DKL_PLL_DIV1(tc_port));
+	hw_state->mg_pll_div1 = intel_dkl_phy_read(dev_priv, DKL_PLL_DIV1(tc_port), 2);
 	hw_state->mg_pll_div1 &= (DKL_PLL_DIV1_IREF_TRIM_MASK |
 				  DKL_PLL_DIV1_TDC_TARGET_CNT_MASK);
 
-	hw_state->mg_pll_ssc = intel_de_read(dev_priv, DKL_PLL_SSC(tc_port));
+	hw_state->mg_pll_ssc = intel_dkl_phy_read(dev_priv, DKL_PLL_SSC(tc_port), 2);
 	hw_state->mg_pll_ssc &= (DKL_PLL_SSC_IREF_NDIV_RATIO_MASK |
 				 DKL_PLL_SSC_STEP_LEN_MASK |
 				 DKL_PLL_SSC_STEP_NUM_MASK |
 				 DKL_PLL_SSC_EN);
 
-	hw_state->mg_pll_bias = intel_de_read(dev_priv, DKL_PLL_BIAS(tc_port));
+	hw_state->mg_pll_bias = intel_dkl_phy_read(dev_priv, DKL_PLL_BIAS(tc_port), 2);
 	hw_state->mg_pll_bias &= (DKL_PLL_BIAS_FRAC_EN_H |
 				  DKL_PLL_BIAS_FBDIV_FRAC_MASK);
 
 	hw_state->mg_pll_tdc_coldst_bias =
-		intel_de_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port));
+		intel_dkl_phy_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port), 2);
 	hw_state->mg_pll_tdc_coldst_bias &= (DKL_PLL_TDC_SSC_STEP_SIZE_MASK |
 					     DKL_PLL_TDC_FEED_FWD_GAIN_MASK);
 
@@ -3737,61 +3735,58 @@ static void dkl_pll_write(struct drm_i915_private *dev_priv,
 	 * All registers programmed here have the same HIP_INDEX_REG even
 	 * though on different building block
 	 */
-	intel_de_write(dev_priv, HIP_INDEX_REG(tc_port),
-		       HIP_INDEX_VAL(tc_port, 0x2));
-
 	/* All the registers are RMW */
-	val = intel_de_read(dev_priv, DKL_REFCLKIN_CTL(tc_port));
+	val = intel_dkl_phy_read(dev_priv, DKL_REFCLKIN_CTL(tc_port), 2);
 	val &= ~MG_REFCLKIN_CTL_OD_2_MUX_MASK;
 	val |= hw_state->mg_refclkin_ctl;
-	intel_de_write(dev_priv, DKL_REFCLKIN_CTL(tc_port), val);
+	intel_dkl_phy_write(dev_priv, DKL_REFCLKIN_CTL(tc_port), 2, val);
 
-	val = intel_de_read(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port));
+	val = intel_dkl_phy_read(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port), 2);
 	val &= ~MG_CLKTOP2_CORECLKCTL1_A_DIVRATIO_MASK;
 	val |= hw_state->mg_clktop2_coreclkctl1;
-	intel_de_write(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port), val);
+	intel_dkl_phy_write(dev_priv, DKL_CLKTOP2_CORECLKCTL1(tc_port), 2, val);
 
-	val = intel_de_read(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port));
+	val = intel_dkl_phy_read(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port), 2);
 	val &= ~(MG_CLKTOP2_HSCLKCTL_TLINEDRV_CLKSEL_MASK |
 		 MG_CLKTOP2_HSCLKCTL_CORE_INPUTSEL_MASK |
 		 MG_CLKTOP2_HSCLKCTL_HSDIV_RATIO_MASK |
 		 MG_CLKTOP2_HSCLKCTL_DSDIV_RATIO_MASK);
 	val |= hw_state->mg_clktop2_hsclkctl;
-	intel_de_write(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port), val);
+	intel_dkl_phy_write(dev_priv, DKL_CLKTOP2_HSCLKCTL(tc_port), 2, val);
 
 	val = DKL_PLL_DIV0_MASK;
 	if (dev_priv->display.vbt.override_afc_startup)
 		val |= DKL_PLL_DIV0_AFC_STARTUP_MASK;
-	intel_de_rmw(dev_priv, DKL_PLL_DIV0(tc_port), val,
-		     hw_state->mg_pll_div0);
+	intel_dkl_phy_rmw(dev_priv, DKL_PLL_DIV0(tc_port), 2, val,
+			  hw_state->mg_pll_div0);
 
-	val = intel_de_read(dev_priv, DKL_PLL_DIV1(tc_port));
+	val = intel_dkl_phy_read(dev_priv, DKL_PLL_DIV1(tc_port), 2);
 	val &= ~(DKL_PLL_DIV1_IREF_TRIM_MASK |
 		 DKL_PLL_DIV1_TDC_TARGET_CNT_MASK);
 	val |= hw_state->mg_pll_div1;
-	intel_de_write(dev_priv, DKL_PLL_DIV1(tc_port), val);
+	intel_dkl_phy_write(dev_priv, DKL_PLL_DIV1(tc_port), 2, val);
 
-	val = intel_de_read(dev_priv, DKL_PLL_SSC(tc_port));
+	val = intel_dkl_phy_read(dev_priv, DKL_PLL_SSC(tc_port), 2);
 	val &= ~(DKL_PLL_SSC_IREF_NDIV_RATIO_MASK |
 		 DKL_PLL_SSC_STEP_LEN_MASK |
 		 DKL_PLL_SSC_STEP_NUM_MASK |
 		 DKL_PLL_SSC_EN);
 	val |= hw_state->mg_pll_ssc;
-	intel_de_write(dev_priv, DKL_PLL_SSC(tc_port), val);
+	intel_dkl_phy_write(dev_priv, DKL_PLL_SSC(tc_port), 2, val);
 
-	val = intel_de_read(dev_priv, DKL_PLL_BIAS(tc_port));
+	val = intel_dkl_phy_read(dev_priv, DKL_PLL_BIAS(tc_port), 2);
 	val &= ~(DKL_PLL_BIAS_FRAC_EN_H |
 		 DKL_PLL_BIAS_FBDIV_FRAC_MASK);
 	val |= hw_state->mg_pll_bias;
-	intel_de_write(dev_priv, DKL_PLL_BIAS(tc_port), val);
+	intel_dkl_phy_write(dev_priv, DKL_PLL_BIAS(tc_port), 2, val);
 
-	val = intel_de_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port));
+	val = intel_dkl_phy_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port), 2);
 	val &= ~(DKL_PLL_TDC_SSC_STEP_SIZE_MASK |
 		 DKL_PLL_TDC_FEED_FWD_GAIN_MASK);
 	val |= hw_state->mg_pll_tdc_coldst_bias;
-	intel_de_write(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port), val);
+	intel_dkl_phy_write(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port), 2, val);
 
-	intel_de_posting_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port));
+	intel_dkl_phy_posting_read(dev_priv, DKL_PLL_TDC_COLDST_BIAS(tc_port), 2);
 }
 
 static void icl_pll_power_enable(struct drm_i915_private *dev_priv,
diff --git a/drivers/gpu/drm/i915/i915_driver.c b/drivers/gpu/drm/i915/i915_driver.c
index c459eb362c47..f2a15d8155f4 100644
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -353,6 +353,7 @@ static int i915_driver_early_probe(struct drm_i915_private *dev_priv)
 	mutex_init(&dev_priv->display.wm.wm_mutex);
 	mutex_init(&dev_priv->display.pps.mutex);
 	mutex_init(&dev_priv->display.hdcp.comp_mutex);
+	spin_lock_init(&dev_priv->display.dkl.phy_lock);
 
 	i915_memcpy_init_early(dev_priv);
 	intel_runtime_pm_init_early(&dev_priv->runtime_pm);
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 0b287a59dc2f..da35bb2db26b 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7420,6 +7420,9 @@ enum skl_power_gate {
 #define _DKL_PHY5_BASE			0x16C000
 #define _DKL_PHY6_BASE			0x16D000
 
+#define DKL_REG_TC_PORT(__reg) \
+	(TC_PORT_1 + ((__reg).reg - _DKL_PHY1_BASE) / (_DKL_PHY2_BASE - _DKL_PHY1_BASE))
+
 /* DEKEL PHY MMIO Address = Phy base + (internal address & ~index_mask) */
 #define _DKL_PCS_DW5			0x14
 #define DKL_PCS_DW5(tc_port)		_MMIO(_PORT(tc_port, _DKL_PHY1_BASE, \

