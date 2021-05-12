Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D2837C31C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhELPRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233916AbhELPP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:15:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A76416193F;
        Wed, 12 May 2021 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831902;
        bh=rQtphBlS+Vc4Pwtq7XOMRUiKAxZIaGse0GjhNFhUHzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FeGd/UYd6RAApW1s2m5obRKYnemQrZfdxtykjq19bp21044bGss4hvK1TwCIK9qk7
         ObgtXgJRqmMgFH0OiKpFEPhLVhSItLLkkkS9BR/yj8MmGVaHZ91cCz3eeAuttB8kEC
         eDN0M8xfIvRedKU2JwVejuVrLRjVHD7oR6lHrSzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Xu <colin.xu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 5.10 060/530] drm/i915/gvt: Fix vfio_edid issue for BXT/APL
Date:   Wed, 12 May 2021 16:42:50 +0200
Message-Id: <20210512144821.716292434@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Xu <colin.xu@intel.com>

commit 4ceb06e7c336f4a8d3f3b6ac9a4fea2e9c97dc07 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/display.c |   83 +++++++++++++++++++++++++++----------
 drivers/gpu/drm/i915/gvt/vgpu.c    |    5 --
 2 files changed, 63 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/display.c
+++ b/drivers/gpu/drm/i915/gvt/display.c
@@ -216,6 +216,15 @@ static void emulate_monitor_status_chang
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
@@ -272,6 +281,8 @@ static void emulate_monitor_status_chang
 			vgpu_vreg_t(vgpu, TRANS_DDI_FUNC_CTL(TRANSCODER_EDP)) |=
 				(TRANS_DDI_BPC_8 | TRANS_DDI_MODE_SELECT_DP_SST |
 				 TRANS_DDI_FUNC_ENABLE);
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
+				PORTA_HOTPLUG_ENABLE;
 			vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
 				BXT_DE_PORT_HP_DDIA;
 		}
@@ -300,6 +311,8 @@ static void emulate_monitor_status_chang
 				(TRANS_DDI_BPC_8 | TRANS_DDI_MODE_SELECT_DP_SST |
 				 (PORT_B << TRANS_DDI_PORT_SHIFT) |
 				 TRANS_DDI_FUNC_ENABLE);
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
+				PORTB_HOTPLUG_ENABLE;
 			vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
 				BXT_DE_PORT_HP_DDIB;
 		}
@@ -328,6 +341,8 @@ static void emulate_monitor_status_chang
 				(TRANS_DDI_BPC_8 | TRANS_DDI_MODE_SELECT_DP_SST |
 				 (PORT_B << TRANS_DDI_PORT_SHIFT) |
 				 TRANS_DDI_FUNC_ENABLE);
+			vgpu_vreg_t(vgpu, PCH_PORT_HOTPLUG) |=
+				PORTC_HOTPLUG_ENABLE;
 			vgpu_vreg_t(vgpu, GEN8_DE_PORT_ISR) |=
 				BXT_DE_PORT_HP_DDIC;
 		}
@@ -660,38 +675,62 @@ void intel_vgpu_emulate_hotplug(struct i
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
 
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -437,10 +437,9 @@ static struct intel_vgpu *__intel_gvt_cr
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


