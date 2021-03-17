Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C1E33E742
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 03:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCQC4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 22:56:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:57617 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhCQC4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 22:56:02 -0400
IronPort-SDR: lpoUFozXU2I2qmAm2xYEBHA7eTx81WylWxhyxRsf9BRSyR4PoBQBSNo0pS0XpDta5yxvEJVCPY
 4B4b6ExBiuQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="209332668"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="209332668"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 19:56:02 -0700
IronPort-SDR: kz9hG2WBY9Mq5q9UcwYgBLEt8EgANf4hdcTyOoJImZEKgZo1m8bu2sbB8im719+fxsCzuKGTgA
 QgtDDrgi/YuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="590888374"
Received: from unknown (HELO coxu-arch-shz.sh.intel.com) ([10.239.160.25])
  by orsmga005.jf.intel.com with ESMTP; 16 Mar 2021 19:56:00 -0700
From:   Colin Xu <colin.xu@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com,
        colin.xu@intel.com
Subject: [PATCH 3/5] drm/i915/gvt: Fix virtual display setup for BXT/APL
Date:   Wed, 17 Mar 2021 10:55:02 +0800
Message-Id: <280168619124c762cb29add7e68952222a0e4801.1615946755.git.colin.xu@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1615946755.git.colin.xu@intel.com>
References: <cover.1615946755.git.colin.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a5a8ef937cfa79167f4b2a5602092b8d14fd6b9a upstream

Program display related vregs to proper value at initialization, setup
virtual monitor and hotplug.

vGPU virtual display vregs inherit the value from pregs. The virtual DP
monitor is always setup on PORT_B for BXT/APL. However the host may
connect monitor on other PORT or without any monitor connected. Without
properly setup PIPE/DDI/PLL related vregs, guest driver may not setup
the virutal display as expected, and the guest desktop may not be
created.
Since only one virtual display is supported, enable PIPE_A only. And
enable transcoder/DDI/PLL based on which port is setup for BXT/APL.

V2:
Revise commit message.

V3:
set_edid should on PORT_B for BXT.
Inject hpd event for BXT.

V4:
Temporarily disable vfio edid on BXT/APL until issue fixed.

V5:
Rebase to use new HPD define GEN8_DE_PORT_HOTPLUG for BXT.
Put vfio edid disabling on BXT/APL to a separate patch.

Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Colin Xu <colin.xu@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20201109073922.757759-1-colin.xu@intel.com
(cherry picked from commit a5a8ef937cfa79167f4b2a5602092b8d14fd6b9a)
Signed-off-by: Colin Xu <colin.xu@intel.com>
Cc: <stable@vger.kernel.org> # 5.4.y
---
 drivers/gpu/drm/i915/gvt/display.c | 173 +++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/gvt/mmio.c    |   5 +
 2 files changed, 178 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/display.c b/drivers/gpu/drm/i915/gvt/display.c
index 59aa5e64acb0..4aec43a3588b 100644
--- a/drivers/gpu/drm/i915/gvt/display.c
+++ b/drivers/gpu/drm/i915/gvt/display.c
@@ -172,21 +172,161 @@ static void emulate_monitor_status_change(struct intel_vgpu *vgpu)
 	int pipe;
 
 	if (IS_BROXTON(dev_priv)) {
+		enum transcoder trans;
+		enum port port;
+
+		/* Clear PIPE, DDI, PHY, HPD before setting new */
 		vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) &= ~(BXT_DE_PORT_HP_DDIA |
 			BXT_DE_PORT_HP_DDIB |
 			BXT_DE_PORT_HP_DDIC);
 
+		for_each_pipe(dev_priv, pipe) {
+			vgpu_vreg_t(vgpu, PIPECONF(pipe)) &=
+				~(PIPECONF_ENABLE | I965_PIPECONF_ACTIVE);
+			vgpu_vreg_t(vgpu, DSPCNTR(pipe)) &= ~DISPLAY_PLANE_ENABLE;
+			vgpu_vreg_t(vgpu, SPRCTL(pipe)) &= ~SPRITE_ENABLE;
+			vgpu_vreg_t(vgpu, CURCNTR(pipe)) &= ~MCURSOR_MODE;
+			vgpu_vreg_t(vgpu, CURCNTR(pipe)) |= MCURSOR_MODE_DISABLE;
+		}
+
+		for (trans = TRANSCODER_A; trans <= TRANSCODER_EDP; trans++) {
+			vgpu_vreg_t(vgpu, TRANS_DDI_FUNC_CTL(trans)) &=
+				~(TRANS_DDI_BPC_MASK | TRANS_DDI_MODE_SELECT_MASK |
+				  TRANS_DDI_PORT_MASK | TRANS_DDI_FUNC_ENABLE);
+		}
+		vgpu_vreg_t(vgpu, TRANS_DDI_FUNC_CTL(TRANSCODER_A)) &=
+			~(TRANS_DDI_BPC_MASK | TRANS_DDI_MODE_SELECT_MASK |
+			  TRANS_DDI_PORT_MASK);
+
+		for (port = PORT_A; port <= PORT_C; port++) {
+			vgpu_vreg_t(vgpu, BXT_PHY_CTL(port)) &=
+				~BXT_PHY_LANE_ENABLED;
+			vgpu_vreg_t(vgpu, BXT_PHY_CTL(port)) |=
+				(BXT_PHY_CMNLANE_POWERDOWN_ACK |
+				 BXT_PHY_LANE_POWERDOWN_ACK);
+
+			vgpu_vreg_t(vgpu, BXT_PORT_PLL_ENABLE(port)) &=
+				~(PORT_PLL_POWER_STATE | PORT_PLL_POWER_ENABLE |
+				  PORT_PLL_REF_SEL | PORT_PLL_LOCK |
+				  PORT_PLL_ENABLE);
+
+			vgpu_vreg_t(vgpu, DDI_BUF_CTL(port)) &=
+				~(DDI_INIT_DISPLAY_DETECTED |
+				  DDI_BUF_CTL_ENABLE);
+			vgpu_vreg_t(vgpu, DDI_BUF_CTL(port)) |= DDI_BUF_IS_IDLE;
+		}
+
+		vgpu_vreg_t(vgpu, BXT_P_CR_GT_DISP_PWRON) &= ~(BIT(0) | BIT(1));
+		vgpu_vreg_t(vgpu, BXT_PORT_CL1CM_DW0(DPIO_PHY0)) &=
+			~PHY_POWER_GOOD;
+		vgpu_vreg_t(vgpu, BXT_PORT_CL1CM_DW0(DPIO_PHY1)) &=
+			~PHY_POWER_GOOD;
+		vgpu_vreg_t(vgpu, BXT_PHY_CTL_FAMILY(DPIO_PHY0)) &= ~BIT(30);
+		vgpu_vreg_t(vgpu, BXT_PHY_CTL_FAMILY(DPIO_PHY1)) &= ~BIT(30);
+
+		vgpu_vreg_t(vgpu, SFUSE_STRAP) &= ~SFUSE_STRAP_DDIB_DETECTED;
+		vgpu_vreg_t(vgpu, SFUSE_STRAP) &= ~SFUSE_STRAP_DDIC_DETECTED;
+
+		/*
+		 * Only 1 PIPE enabled in current vGPU display and PIPE_A is
+		 *  tied to TRANSCODER_A in HW, so it's safe to assume PIPE_A,
+		 *   TRANSCODER_A can be enabled. PORT_x depends on the input of
+		 *   setup_virtual_dp_monitor.
+		 */
+		vgpu_vreg_t(vgpu, PIPECONF(PIPE_A)) |= PIPECONF_ENABLE;
+		vgpu_vreg_t(vgpu, PIPECONF(PIPE_A)) |= I965_PIPECONF_ACTIVE;
+
+		/*
+		 * Golden M/N are calculated based on:
+		 *   24 bpp, 4 lanes, 154000 pixel clk (from virtual EDID),
+		 *   DP link clk 1620 MHz and non-constant_n.
+		 * TODO: calculate DP link symbol clk and stream clk m/n.
+		 */
+		vgpu_vreg_t(vgpu, PIPE_DATA_M1(TRANSCODER_A)) = 63 << TU_SIZE_SHIFT;
+		vgpu_vreg_t(vgpu, PIPE_DATA_M1(TRANSCODER_A)) |= 0x5b425e;
+		vgpu_vreg_t(vgpu, PIPE_DATA_N1(TRANSCODER_A)) = 0x800000;
+		vgpu_vreg_t(vgpu, PIPE_LINK_M1(TRANSCODER_A)) = 0x3cd6e;
+		vgpu_vreg_t(vgpu, PIPE_LINK_N1(TRANSCODER_A)) = 0x80000;
+
+		/* Enable per-DDI/PORT vreg */
 		if (intel_vgpu_has_monitor_on_port(vgpu, PORT_A)) {
+			vgpu_vreg_t(vgpu, BXT_P_CR_GT_DISP_PWRON) |= BIT(1);
+			vgpu_vreg_t(vgpu, BXT_PORT_CL1CM_DW0(DPIO_PHY1)) |=
+				PHY_POWER_GOOD;
+			vgpu_vreg_t(vgpu, BXT_PHY_CTL_FAMILY(DPIO_PHY1)) |=
+				BIT(30);
+			vgpu_vreg_t(vgpu, BXT_PHY_CTL(PORT_A)) |=
+				BXT_PHY_LANE_ENABLED;
+			vgpu_vreg_t(vgpu, BXT_PHY_CTL(PORT_A)) &=
+				~(BXT_PHY_CMNLANE_POWERDOWN_ACK |
+				  BXT_PHY_LANE_POWERDOWN_ACK);
+			vgpu_vreg_t(vgpu, BXT_PORT_PLL_ENABLE(PORT_A)) |=
+				(PORT_PLL_POWER_STATE | PORT_PLL_POWER_ENABLE |
+				 PORT_PLL_REF_SEL | PORT_PLL_LOCK |
+				 PORT_PLL_ENABLE);
+			vgpu_vreg_t(vgpu, DDI_BUF_CTL(PORT_A)) |=
+				(DDI_BUF_CTL_ENABLE | DDI_INIT_DISPLAY_DETECTED);
+			vgpu_vreg_t(vgpu, DDI_BUF_CTL(PORT_A)) &=
+				~DDI_BUF_IS_IDLE;
+			vgpu_vreg_t(vgpu, TRANS_DDI_FUNC_CTL(TRANSCODER_EDP)) |=
+				(TRANS_DDI_BPC_8 | TRANS_DDI_MODE_SELECT_DP_SST |
+				 TRANS_DDI_FUNC_ENABLE);
 			vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
 				BXT_DE_PORT_HP_DDIA;
 		}
 
 		if (intel_vgpu_has_monitor_on_port(vgpu, PORT_B)) {
+			vgpu_vreg_t(vgpu, SFUSE_STRAP) |= SFUSE_STRAP_DDIB_DETECTED;
+			vgpu_vreg_t(vgpu, BXT_P_CR_GT_DISP_PWRON) |= BIT(0);
+			vgpu_vreg_t(vgpu, BXT_PORT_CL1CM_DW0(DPIO_PHY0)) |=
+				PHY_POWER_GOOD;
+			vgpu_vreg_t(vgpu, BXT_PHY_CTL_FAMILY(DPIO_PHY0)) |=
+				BIT(30);
+			vgpu_vreg_t(vgpu, BXT_PHY_CTL(PORT_B)) |=
+				BXT_PHY_LANE_ENABLED;
+			vgpu_vreg_t(vgpu, BXT_PHY_CTL(PORT_B)) &=
+				~(BXT_PHY_CMNLANE_POWERDOWN_ACK |
+				  BXT_PHY_LANE_POWERDOWN_ACK);
+			vgpu_vreg_t(vgpu, BXT_PORT_PLL_ENABLE(PORT_B)) |=
+				(PORT_PLL_POWER_STATE | PORT_PLL_POWER_ENABLE |
+				 PORT_PLL_REF_SEL | PORT_PLL_LOCK |
+				 PORT_PLL_ENABLE);
+			vgpu_vreg_t(vgpu, DDI_BUF_CTL(PORT_B)) |=
+				DDI_BUF_CTL_ENABLE;
+			vgpu_vreg_t(vgpu, DDI_BUF_CTL(PORT_B)) &=
+				~DDI_BUF_IS_IDLE;
+			vgpu_vreg_t(vgpu, TRANS_DDI_FUNC_CTL(TRANSCODER_A)) |=
+				(TRANS_DDI_BPC_8 | TRANS_DDI_MODE_SELECT_DP_SST |
+				 (PORT_B << TRANS_DDI_PORT_SHIFT) |
+				 TRANS_DDI_FUNC_ENABLE);
 			vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
 				BXT_DE_PORT_HP_DDIB;
 		}
 
 		if (intel_vgpu_has_monitor_on_port(vgpu, PORT_C)) {
+			vgpu_vreg_t(vgpu, SFUSE_STRAP) |= SFUSE_STRAP_DDIC_DETECTED;
+			vgpu_vreg_t(vgpu, BXT_P_CR_GT_DISP_PWRON) |= BIT(0);
+			vgpu_vreg_t(vgpu, BXT_PORT_CL1CM_DW0(DPIO_PHY0)) |=
+				PHY_POWER_GOOD;
+			vgpu_vreg_t(vgpu, BXT_PHY_CTL_FAMILY(DPIO_PHY0)) |=
+				BIT(30);
+			vgpu_vreg_t(vgpu, BXT_PHY_CTL(PORT_C)) |=
+				BXT_PHY_LANE_ENABLED;
+			vgpu_vreg_t(vgpu, BXT_PHY_CTL(PORT_C)) &=
+				~(BXT_PHY_CMNLANE_POWERDOWN_ACK |
+				  BXT_PHY_LANE_POWERDOWN_ACK);
+			vgpu_vreg_t(vgpu, BXT_PORT_PLL_ENABLE(PORT_C)) |=
+				(PORT_PLL_POWER_STATE | PORT_PLL_POWER_ENABLE |
+				 PORT_PLL_REF_SEL | PORT_PLL_LOCK |
+				 PORT_PLL_ENABLE);
+			vgpu_vreg_t(vgpu, DDI_BUF_CTL(PORT_C)) |=
+				DDI_BUF_CTL_ENABLE;
+			vgpu_vreg_t(vgpu, DDI_BUF_CTL(PORT_C)) &=
+				~DDI_BUF_IS_IDLE;
+			vgpu_vreg_t(vgpu, TRANS_DDI_FUNC_CTL(TRANSCODER_A)) |=
+				(TRANS_DDI_BPC_8 | TRANS_DDI_MODE_SELECT_DP_SST |
+				 (PORT_B << TRANS_DDI_PORT_SHIFT) |
+				 TRANS_DDI_FUNC_ENABLE);
 			vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
 				BXT_DE_PORT_HP_DDIC;
 		}
@@ -511,6 +651,39 @@ void intel_vgpu_emulate_hotplug(struct intel_vgpu *vgpu, bool connected)
 		vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
 				PORTD_HOTPLUG_STATUS_MASK;
 		intel_vgpu_trigger_virtual_event(vgpu, DP_D_HOTPLUG);
+	} else if (IS_BROXTON(dev_priv)) {
+		if (connected) {
+			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_A)) {
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |= BXT_DE_PORT_HP_DDIA;
+			}
+			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_B)) {
+				vgpu_vreg_t(vgpu, SFUSE_STRAP) |=
+					SFUSE_STRAP_DDIB_DETECTED;
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |= BXT_DE_PORT_HP_DDIB;
+			}
+			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_C)) {
+				vgpu_vreg_t(vgpu, SFUSE_STRAP) |=
+					SFUSE_STRAP_DDIC_DETECTED;
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |= BXT_DE_PORT_HP_DDIC;
+			}
+		} else {
+			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_A)) {
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) &= ~BXT_DE_PORT_HP_DDIA;
+			}
+			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_B)) {
+				vgpu_vreg_t(vgpu, SFUSE_STRAP) &=
+					~SFUSE_STRAP_DDIB_DETECTED;
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) &= ~BXT_DE_PORT_HP_DDIB;
+			}
+			if (intel_vgpu_has_monitor_on_port(vgpu, PORT_C)) {
+				vgpu_vreg_t(vgpu, SFUSE_STRAP) &=
+					~SFUSE_STRAP_DDIC_DETECTED;
+				vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) &= ~BXT_DE_PORT_HP_DDIC;
+			}
+		}
+		vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
+			PORTB_HOTPLUG_STATUS_MASK;
+		intel_vgpu_trigger_virtual_event(vgpu, DP_B_HOTPLUG);
 	}
 }
 
diff --git a/drivers/gpu/drm/i915/gvt/mmio.c b/drivers/gpu/drm/i915/gvt/mmio.c
index a55178884d67..e0e7adc545a5 100644
--- a/drivers/gpu/drm/i915/gvt/mmio.c
+++ b/drivers/gpu/drm/i915/gvt/mmio.c
@@ -271,6 +271,11 @@ void intel_vgpu_reset_mmio(struct intel_vgpu *vgpu, bool dmlr)
 			vgpu_vreg_t(vgpu, BXT_PHY_CTL(PORT_C)) |=
 				    BXT_PHY_CMNLANE_POWERDOWN_ACK |
 				    BXT_PHY_LANE_POWERDOWN_ACK;
+			vgpu_vreg_t(vgpu, SKL_FUSE_STATUS) |=
+				SKL_FUSE_DOWNLOAD_STATUS |
+				SKL_FUSE_PG_DIST_STATUS(SKL_PG0) |
+				SKL_FUSE_PG_DIST_STATUS(SKL_PG1) |
+				SKL_FUSE_PG_DIST_STATUS(SKL_PG2);
 		}
 	} else {
 #define GVT_GEN8_MMIO_RESET_OFFSET		(0x44200)
-- 
2.30.2

