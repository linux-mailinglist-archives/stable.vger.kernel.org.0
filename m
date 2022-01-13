Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5438C48DD18
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 18:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbiAMRrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 12:47:01 -0500
Received: from mga06.intel.com ([134.134.136.31]:21882 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbiAMRrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 12:47:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642096021; x=1673632021;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ycShh+m0FdhlSFegjmSDwT8nCfNx8A+fGs9+XEBxjbk=;
  b=g1JMobs7hlMtOmXP3g7MWXs3RrQnCz8mo86533/VlGv0mS5qYTFy/gJo
   CJTZTXlZvaqSL0pRgajfN3r12jR1v49XIAmOqLF3HdSWD+nhxrxg1cYIj
   qSXyfjviwz5ASNc+SUdovuQeDmCVQ+OBumNGCTb3Dkc7ThYNYputNe3cD
   KqPhTRbiLufI/asmxEa+OMGNknmbTbqDdv5AQ02SIZJzWB9z4rIYIEAjM
   2TCzEPf1tZXoz98YXqFS/3wT6kfTASDHQSi3Y9CWHCDn2rRL2Wii5y3r4
   KF3INKrOQRohkcDrU3jO9fHhg3sgU2iGquZmD0v6SxOR54eDVRh5iJ6HQ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="304803958"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="304803958"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 09:47:00 -0800
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="623933383"
Received: from unknown (HELO josouza-mobl2.intel.com) ([10.230.19.131])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 09:46:58 -0800
From:   =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Clint Taylor <clinton.a.taylor@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>
Subject: [PATCH] drm/i915/display/adlp: Implement new step in the TC voltage swing prog sequence
Date:   Thu, 13 Jan 2022 09:48:26 -0800
Message-Id: <20220113174826.50272-1-jose.souza@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TC voltage swing programming sequence was updated with a new step.

BSpec: 54956
Cc: stable@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Clint Taylor <clinton.a.taylor@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 22 ++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h          |  8 ++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 6ee0f77b79274..4e93eac926a56 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -1300,6 +1300,28 @@ static void tgl_dkl_phy_set_signal_levels(struct intel_encoder *encoder,
 
 		intel_de_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port),
 			     DKL_TX_DP20BITMODE, 0);
+
+		if (IS_ALDERLAKE_P(dev_priv)) {
+			u32 val;
+
+			if (intel_crtc_has_type(crtc_state, INTEL_OUTPUT_HDMI)) {
+				if (ln == 0) {
+					val = DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(0);
+					val |= DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(2);
+				} else {
+					val = DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(3);
+					val |= DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(3);
+				}
+			} else {
+				val = DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(0);
+				val |= DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(0);
+			}
+
+			intel_de_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port),
+				     DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK |
+				     DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK,
+				     val);
+		}
 	}
 }
 
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 7c4013a0db615..ef6bc81800738 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -10085,8 +10085,12 @@ enum skl_power_gate {
 						     _DKL_PHY2_BASE) + \
 						     _DKL_TX_DPCNTL1)
 
-#define _DKL_TX_DPCNTL2				0x2C8
-#define  DKL_TX_DP20BITMODE				(1 << 2)
+#define _DKL_TX_DPCNTL2					0x2C8
+#define  DKL_TX_DP20BITMODE				REG_BIT(2)
+#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK	REG_GENMASK(4, 3)
+#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(val)	REG_FIELD_PREP(DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK, (val))
+#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK	REG_GENMASK(6, 5)
+#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(val)	REG_FIELD_PREP(DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK, (val))
 #define DKL_TX_DPCNTL2(tc_port) _MMIO(_PORT(tc_port, \
 						     _DKL_PHY1_BASE, \
 						     _DKL_PHY2_BASE) + \
-- 
2.34.1

