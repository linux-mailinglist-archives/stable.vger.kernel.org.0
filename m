Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1D2379D50
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 05:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhEKDEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 23:04:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:58554 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhEKDEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 23:04:35 -0400
IronPort-SDR: dlDPbSaBOl1LfOZBdy6lziBG8QGZjpmLB3DXatXVNn5+Ap6BgH/JzqgAI8WSxsIlj6B7nkctBb
 5k0x1w8mmSqA==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="186785379"
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="186785379"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 20:03:26 -0700
IronPort-SDR: VAQ0+z4buULq2EYnCGz3Gu9wdCUWKSjq9V1GajksSl+1Au6pH0+l/3bJaAAbg8IpaT+MQuno5w
 pZDsQSiEniHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="609329166"
Received: from unknown (HELO coxu-arch-shz.sh.intel.com) ([10.239.160.26])
  by orsmga005.jf.intel.com with ESMTP; 10 May 2021 20:03:25 -0700
From:   Colin Xu <colin.xu@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com,
        colin.xu@intel.com
Subject: [PATCH 2/2] drm/i915/gvt: Fix vfio_edid issue for BXT/APL
Date:   Tue, 11 May 2021 11:02:55 +0800
Message-Id: <8c1fb62008ad4dbd80c962cda470cbdc57ae0d20.1620702000.git.colin.xu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620702000.git.colin.xu@intel.com>
References: <cover.1620702000.git.colin.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4ceb06e7c336f4a8d3f3b6ac9a4fea2e9c97dc07 upstream

BXT/APL has different isr/irr/hpd regs compared with other GEN9. If not
setting these regs bits correctly according to the emulated monitor
(currently a DP on PORT_B), although gvt still triggers a virtual HPD
event, the guest driver won't detect a valid HPD pulse thus no full
display detection will be executed to read the updated EDID.

With this patch, the vfio_edid is enabled again on BXT/APL, which is
previously disabled.

Fixes: 642403e3599e ("drm/i915/gvt: Temporarily disable vfio_edid for BXT/APL")
Signed-off-by: Colin Xu <colin.xu@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20201201060329.142375-1-colin.xu@intel.com
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
(cherry picked from commit 4ceb06e7c336f4a8d3f3b6ac9a4fea2e9c97dc07)
Cc: <stable@vger.kernel.org> # 5.10.y
---
 drivers/gpu/drm/i915/gvt/display.c | 83 ++++++++++++++++++++++--------
 drivers/gpu/drm/i915/gvt/vgpu.c    |  5 +-
 2 files changed, 63 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/display.c b/drivers/gpu/drm/i915/gvt/display.c
index b2d28457ee9d..234650230701 100644
--- a/drivers/gpu/drm/i915/gvt/display.c
+++ b/drivers/gpu/drm/i915/gvt/display.c
@@ -216,6 +216,15 @@ static void emulate_monitor_status_change(struct intel_vgpu *vgpu)
 				  DDI_BUF_CTL_ENABLE);
 			vgpu_vreg_t(vgpu, DDI_BUF_CTL(port)) |= DDI_BUF_IS_IDLE;
 		}
+		vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) &=
+			~(PORTA_HOTPLUG_ENABLE | PORTA_HOTPLUG_STATUS_MASK);
+		vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) &=
+			~(PORTB_HOTPLUG_ENABLE | PORTB_HOTPLUG_STATUS_MASK);
+		vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) &=
+			~(PORTC_HOTPLUG_ENABLE | PORTC_HOTPLUG_STATUS_MASK);
+		/* No hpd_invert set in vgpu vbt, need to clear invert mask */
+		vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) &= ~BXT_DDI_HPD_INVERT_MASK;
+		vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) &= ~BXT_DE_PORT_HOTPLUG_MASK;
 
 		vgpu_vreg_t(vgpu, BXT_P_CR_GT_DISP_PWRON) &= ~(BIT(0) | BIT(1));
 		vgpu_vreg_t(vgpu, BXT_PORT_CL1CM_DW0(DPIO_PHY0)) &=
@@ -272,6 +281,8 @@ static void emulate_monitor_status_change(struct intel_vgpu *vgpu)
 			vgpu_vreg_t(vgpu, TRANS_DDI_FUNC_CTL(TRANSCODER_EDP)) |=
 				(TRANS_DDI_BPC_8 | TRANS_DDI_MODE_SELECT_DP_SST |
 				 TRANS_DDI_FUNC_ENABLE);
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
+				PORTA_HOTPLUG_ENABLE;
 			vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
 				BXT_DE_PORT_HP_DDIA;
 		}
@@ -300,6 +311,8 @@ static void emulate_monitor_status_change(struct intel_vgpu *vgpu)
 				(TRANS_DDI_BPC_8 | TRANS_DDI_MODE_SELECT_DP_SST |
 				 (PORT_B << TRANS_DDI_PORT_SHIFT) |
 				 TRANS_DDI_FUNC_ENABLE);
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
+				PORTB_HOTPLUG_ENABLE;
 			vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
 				BXT_DE_PORT_HP_DDIB;
 		}
@@ -328,6 +341,8 @@ static void emulate_monitor_status_change(struct intel_vgpu *vgpu)
 				(TRANS_DDI_BPC_8 | TRANS_DDI_MODE_SELECT_DP_SST |
 				 (PORT_B << TRANS_DDI_PORT_SHIFT) |
 				 TRANS_DDI_FUNC_ENABLE);
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
+				PORTC_HOTPLUG_ENABLE;
 			vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
 				BXT_DE_PORT_HP_DDIC;
 		}
@@ -660,38 +675,62 @@ void intel_vgpu_emulate_hotplug(struct intel_vgpu *vgpu, bool connected)
 				PORTD_HOTPLUG_STATUS_MASK;
 		intel_vgpu_trigger_virtual_event(vgpu, DP_D_HOTPLUG);
 	} else if (IS_BROXTON(i915)) {
-		if (connected) {
-			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_A)) {
-				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |= BXT_DE_PORT_HP_DDIA;
+		if (intel_vgpu_has_monitor_on_port(vgpu, PORT_A)) {
+			if (connected) {
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
+					BXT_DE_PORT_HP_DDIA;
+			} else {
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) &=
+					~BXT_DE_PORT_HP_DDIA;
 			}
-			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_B)) {
+			vgpu_vreg_t(vgpu, GEN8_DE_PORT_IIR) |=
+				BXT_DE_PORT_HP_DDIA;
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) &=
+				~PORTA_HOTPLUG_STATUS_MASK;
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
+				PORTA_HOTPLUG_LONG_DETECT;
+			intel_vgpu_trigger_virtual_event(vgpu, DP_A_HOTPLUG);
+		}
+		if (intel_vgpu_has_monitor_on_port(vgpu, PORT_B)) {
+			if (connected) {
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
+					BXT_DE_PORT_HP_DDIB;
 				vgpu_vreg_t(vgpu, SFUSE_STRAP) |=
 					SFUSE_STRAP_DDIB_DETECTED;
-				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |= BXT_DE_PORT_HP_DDIB;
-			}
-			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_C)) {
-				vgpu_vreg_t(vgpu, SFUSE_STRAP) |=
-					SFUSE_STRAP_DDIC_DETECTED;
-				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |= BXT_DE_PORT_HP_DDIC;
-			}
-		} else {
-			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_A)) {
-				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) &= ~BXT_DE_PORT_HP_DDIA;
-			}
-			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_B)) {
+			} else {
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) &=
+					~BXT_DE_PORT_HP_DDIB;
 				vgpu_vreg_t(vgpu, SFUSE_STRAP) &=
 					~SFUSE_STRAP_DDIB_DETECTED;
-				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) &= ~BXT_DE_PORT_HP_DDIB;
 			}
-			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_C)) {
+			vgpu_vreg_t(vgpu, GEN8_DE_PORT_IIR) |=
+				BXT_DE_PORT_HP_DDIB;
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) &=
+				~PORTB_HOTPLUG_STATUS_MASK;
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
+				PORTB_HOTPLUG_LONG_DETECT;
+			intel_vgpu_trigger_virtual_event(vgpu, DP_B_HOTPLUG);
+		}
+		if (intel_vgpu_has_monitor_on_port(vgpu, PORT_C)) {
+			if (connected) {
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
+					BXT_DE_PORT_HP_DDIC;
+				vgpu_vreg_t(vgpu, SFUSE_STRAP) |=
+					SFUSE_STRAP_DDIC_DETECTED;
+			} else {
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) &=
+					~BXT_DE_PORT_HP_DDIC;
 				vgpu_vreg_t(vgpu, SFUSE_STRAP) &=
 					~SFUSE_STRAP_DDIC_DETECTED;
-				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) &= ~BXT_DE_PORT_HP_DDIC;
 			}
+			vgpu_vreg_t(vgpu, GEN8_DE_PORT_IIR) |=
+				BXT_DE_PORT_HP_DDIC;
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) &=
+				~PORTC_HOTPLUG_STATUS_MASK;
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
+				PORTC_HOTPLUG_LONG_DETECT;
+			intel_vgpu_trigger_virtual_event(vgpu, DP_C_HOTPLUG);
 		}
-		vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
-			PORTB_HOTPLUG_STATUS_MASK;
-		intel_vgpu_trigger_virtual_event(vgpu, DP_B_HOTPLUG);
 	}
 }
 
diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
index 399582aeeefb..821b6c3ff88b 100644
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -437,10 +437,9 @@ static struct intel_vgpu *__intel_gvt_create_vgpu(struct intel_gvt *gvt,
 	if (ret)
 		goto out_clean_sched_policy;
 
-	if (IS_BROADWELL(dev_priv))
+	if (IS_BROADWELL(dev_priv) || IS_BROXTON(dev_priv))
 		ret = intel_gvt_hypervisor_set_edid(vgpu, PORT_B);
-	/* FixMe: Re-enable APL/BXT once vfio_edid enabled */
-	else if (!IS_BROXTON(dev_priv))
+	else
 		ret = intel_gvt_hypervisor_set_edid(vgpu, PORT_D);
 	if (ret)
 		goto out_clean_sched_policy;
-- 
2.31.1

