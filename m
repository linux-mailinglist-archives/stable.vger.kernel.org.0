Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7135560652C
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 18:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiJTQAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 12:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiJTQAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 12:00:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC293164BD4
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 09:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666281629; x=1697817629;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C5sZ4bEanc7cjQ23Lepnt+7FeA1m8vSVlEBw3fV5hYo=;
  b=NTaXQSc059+zDpM+wb/sVSLa267QVg/m7RhyYBlqfEATJlWqzJVaIXx6
   1LxzLJa/Z/fJmhNefd9XfsiwfJ8//+W6oHKQ9Nbcgv/Iafs60ZevyQQXL
   rBDjBNQ8ZvJmsF2+U+pXpMbbtv4m8K6jYOB+mqaD3wuPFCjqBOHSQdGKc
   wAOv6d4zEBtJh7EVmwXGGKatSXEX6DYyHO2tBKTC/CDo+KqVy7esGuf9S
   dQ8DxbpRE/fKI8s/WgnxKcaLOWHYwQqyHVcER3vrHLygSCz9TljnyLHFs
   2UZXxbHI4Q3LuVf4EzP5D7LxKSB96zICZjM5G49o/ExXh8NJKae8TzkR0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="307851212"
X-IronPort-AV: E=Sophos;i="5.95,199,1661842800"; 
   d="scan'208";a="307851212"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 09:00:28 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="755219834"
X-IronPort-AV: E=Sophos;i="5.95,199,1661842800"; 
   d="scan'208";a="755219834"
Received: from ideak-desk.fi.intel.com ([10.237.72.175])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 09:00:26 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/4] drm/i915/tgl+: Add locking around DKL PHY register accesses
Date:   Thu, 20 Oct 2022 19:00:19 +0300
Message-Id: <20221020160022.1823365-2-imre.deak@intel.com>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20221020160022.1823365-1-imre.deak@intel.com>
References: <20221020160022.1823365-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/Makefile                 |   1 +
 drivers/gpu/drm/i915/display/intel_ddi.c      |  68 +++++-------
 .../gpu/drm/i915/display/intel_display_core.h |   4 +
 .../i915/display/intel_display_power_well.c   |   7 +-
 drivers/gpu/drm/i915/display/intel_dkl_phy.c  | 104 ++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_dkl_phy.h  |  20 ++++
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |  59 +++++-----
 drivers/gpu/drm/i915/i915_driver.c            |   1 +
 drivers/gpu/drm/i915/i915_reg.h               |   3 +
 9 files changed, 191 insertions(+), 76 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/display/intel_dkl_phy.c
 create mode 100644 drivers/gpu/drm/i915/display/intel_dkl_phy.h

diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 2535593ab379e..51704b54317cf 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -285,6 +285,7 @@ i915-y += \
 	display/intel_ddi.o \
 	display/intel_ddi_buf_trans.o \
 	display/intel_display_trace.o \
+	display/intel_dkl_phy.o \
 	display/intel_dp.o \
 	display/intel_dp_aux.o \
 	display/intel_dp_aux_backlight.o \
diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 971356237eca3..7708ccbbdeb75 100644
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
index 96cf994b0ad1f..17e9823989bcf 100644
--- a/drivers/gpu/drm/i915/display/intel_display_core.h
+++ b/drivers/gpu/drm/i915/display/intel_display_core.h
@@ -315,6 +315,10 @@ struct intel_display {
 		struct intel_global_obj obj;
 	} dbuf;
 
+	struct {
+		spinlock_t phy_lock;
+	} dkl;
+
 	struct {
 		/* VLV/CHV/BXT/GLK DSI MMIO register base address */
 		u32 mmio_base;
diff --git a/drivers/gpu/drm/i915/display/intel_display_power_well.c b/drivers/gpu/drm/i915/display/intel_display_power_well.c
index df7ee4969ef17..1d18eee562534 100644
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
index 0000000000000..79b4fe6c72825
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_dkl_phy.c
@@ -0,0 +1,104 @@
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
+static void dkl_phy_set_hip_idx(struct drm_i915_private *i915, i915_reg_t reg, int idx)
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
+u32 intel_dkl_phy_read(struct drm_i915_private *i915, i915_reg_t reg, int ln)
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
+void intel_dkl_phy_write(struct drm_i915_private *i915, i915_reg_t reg, int ln, u32 val)
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
+void intel_dkl_phy_rmw(struct drm_i915_private *i915, i915_reg_t reg, int ln, u32 clear, u32 set)
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
+void intel_dkl_phy_posting_read(struct drm_i915_private *i915, i915_reg_t reg, int ln)
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
index 0000000000000..1c6c638de7068
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_dkl_phy.h
@@ -0,0 +1,20 @@
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
+u32 intel_dkl_phy_read(struct drm_i915_private *i915, i915_reg_t reg, int ln);
+void intel_dkl_phy_write(struct drm_i915_private *i915, i915_reg_t reg, int ln, u32 val);
+void intel_dkl_phy_rmw(struct drm_i915_private *i915, i915_reg_t reg, int ln, u32 clear, u32 set);
+void intel_dkl_phy_posting_read(struct drm_i915_private *i915, i915_reg_t reg, int ln);
+
+#endif /* __INTEL_DKL_PHY_H__ */
diff --git a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
index b63600d8ebeb0..58e5c6f7de750 100644
--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -25,6 +25,7 @@
 
 #include "intel_de.h"
 #include "intel_display_types.h"
+#include "intel_dkl_phy.h"
 #include "intel_dpio_phy.h"
 #include "intel_dpll.h"
 #include "intel_dpll_mgr.h"
@@ -3486,15 +3487,12 @@ static bool dkl_pll_get_hw_state(struct drm_i915_private *dev_priv,
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
@@ -3502,32 +3500,32 @@ static bool dkl_pll_get_hw_state(struct drm_i915_private *dev_priv,
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
 
@@ -3715,61 +3713,58 @@ static void dkl_pll_write(struct drm_i915_private *dev_priv,
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
+			 hw_state->mg_pll_div0);
 
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
index ffff49868dc51..c3d43f9b1e45d 100644
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -355,6 +355,7 @@ static int i915_driver_early_probe(struct drm_i915_private *dev_priv)
 	mutex_init(&dev_priv->display.wm.wm_mutex);
 	mutex_init(&dev_priv->display.pps.mutex);
 	mutex_init(&dev_priv->display.hdcp.comp_mutex);
+	spin_lock_init(&dev_priv->display.dkl.phy_lock);
 
 	i915_memcpy_init_early(dev_priv);
 	intel_runtime_pm_init_early(&dev_priv->runtime_pm);
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 99a8535193957..8d202b37aa9e0 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7442,6 +7442,9 @@ enum skl_power_gate {
 #define _DKL_PHY5_BASE			0x16C000
 #define _DKL_PHY6_BASE			0x16D000
 
+#define DKL_REG_TC_PORT(reg) \
+	(((reg).reg - _DKL_PHY1_BASE) / (_DKL_PHY2_BASE - _DKL_PHY1_BASE))
+
 /* DEKEL PHY MMIO Address = Phy base + (internal address & ~index_mask) */
 #define _DKL_PCS_DW5			0x14
 #define DKL_PCS_DW5(tc_port)		_MMIO(_PORT(tc_port, _DKL_PHY1_BASE, \
-- 
2.37.1

