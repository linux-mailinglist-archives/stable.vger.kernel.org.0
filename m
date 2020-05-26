Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2111E2C54
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgEZTOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392021AbgEZTOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:14:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D37120776;
        Tue, 26 May 2020 19:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520444;
        bh=XSQb4Zp5cDsFHLtoAkY8MQ1hc/uoWgOtYUAeCqjEU30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chw5r5Ak5NO/M2+IKN+TpzdX5xVTcWrtsgkhyNaOFbF0xKeEYP5bDsyLPqmLOMA4N
         KxFTw7iDr2UW9VTWL8rSSwZU1+CILl+JQS7FdmSWxf39zS7cq3Y9Ku1sn0NUzwREpo
         1goOza5mE5mDyFaMBn/SZj0wgkp6LEGi9h8baRpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Colin Xu <colin.xu@intel.com>
Subject: [PATCH 5.6 083/126] drm/i915/gvt: Init DPLL/DDI vreg for virtual display instead of inheritance.
Date:   Tue, 26 May 2020 20:53:40 +0200
Message-Id: <20200526183945.041012547@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Xu <colin.xu@intel.com>

commit f965b68188ab59a40a421ced1b05a2fea638465c upstream.

Init value of some display vregs rea inherited from host pregs. When
host display in different status, i.e. all monitors unpluged, different
display configurations, etc., GVT virtual display setup don't consistent
thus may lead to guest driver consider display goes malfunctional.

The added init vreg values are based on PRMs and fixed by calcuation
from current configuration (only PIPE_A) and the virtual EDID.

Fixes: 04d348ae3f0a ("drm/i915/gvt: vGPU display virtualization")
Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Colin Xu <colin.xu@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200508060506.216250-1-colin.xu@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/display.c |   49 +++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/display.c
+++ b/drivers/gpu/drm/i915/gvt/display.c
@@ -207,14 +207,41 @@ static void emulate_monitor_status_chang
 				SKL_FUSE_PG_DIST_STATUS(SKL_PG0) |
 				SKL_FUSE_PG_DIST_STATUS(SKL_PG1) |
 				SKL_FUSE_PG_DIST_STATUS(SKL_PG2);
-		vgpu_vreg_t(vgpu, LCPLL1_CTL) |=
-				LCPLL_PLL_ENABLE |
-				LCPLL_PLL_LOCK;
-		vgpu_vreg_t(vgpu, LCPLL2_CTL) |= LCPLL_PLL_ENABLE;
-
+		/*
+		 * Only 1 PIPE enabled in current vGPU display and PIPE_A is
+		 *  tied to TRANSCODER_A in HW, so it's safe to assume PIPE_A,
+		 *   TRANSCODER_A can be enabled. PORT_x depends on the input of
+		 *   setup_virtual_dp_monitor, we can bind DPLL0 to any PORT_x
+		 *   so we fixed to DPLL0 here.
+		 * Setup DPLL0: DP link clk 1620 MHz, non SSC, DP Mode
+		 */
+		vgpu_vreg_t(vgpu, DPLL_CTRL1) =
+			DPLL_CTRL1_OVERRIDE(DPLL_ID_SKL_DPLL0);
+		vgpu_vreg_t(vgpu, DPLL_CTRL1) |=
+			DPLL_CTRL1_LINK_RATE(DPLL_CTRL1_LINK_RATE_1620, DPLL_ID_SKL_DPLL0);
+		vgpu_vreg_t(vgpu, LCPLL1_CTL) =
+			LCPLL_PLL_ENABLE | LCPLL_PLL_LOCK;
+		vgpu_vreg_t(vgpu, DPLL_STATUS) = DPLL_LOCK(DPLL_ID_SKL_DPLL0);
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
 	}
 
 	if (intel_vgpu_has_monitor_on_port(vgpu, PORT_B)) {
+		vgpu_vreg_t(vgpu, DPLL_CTRL2) &=
+			~DPLL_CTRL2_DDI_CLK_OFF(PORT_B);
+		vgpu_vreg_t(vgpu, DPLL_CTRL2) |=
+			DPLL_CTRL2_DDI_CLK_SEL(DPLL_ID_SKL_DPLL0, PORT_B);
+		vgpu_vreg_t(vgpu, DPLL_CTRL2) |=
+			DPLL_CTRL2_DDI_SEL_OVERRIDE(PORT_B);
 		vgpu_vreg_t(vgpu, SFUSE_STRAP) |= SFUSE_STRAP_DDIB_DETECTED;
 		vgpu_vreg_t(vgpu, TRANS_DDI_FUNC_CTL(TRANSCODER_A)) &=
 			~(TRANS_DDI_BPC_MASK | TRANS_DDI_MODE_SELECT_MASK |
@@ -235,6 +262,12 @@ static void emulate_monitor_status_chang
 	}
 
 	if (intel_vgpu_has_monitor_on_port(vgpu, PORT_C)) {
+		vgpu_vreg_t(vgpu, DPLL_CTRL2) &=
+			~DPLL_CTRL2_DDI_CLK_OFF(PORT_C);
+		vgpu_vreg_t(vgpu, DPLL_CTRL2) |=
+			DPLL_CTRL2_DDI_CLK_SEL(DPLL_ID_SKL_DPLL0, PORT_C);
+		vgpu_vreg_t(vgpu, DPLL_CTRL2) |=
+			DPLL_CTRL2_DDI_SEL_OVERRIDE(PORT_C);
 		vgpu_vreg_t(vgpu, SDEISR) |= SDE_PORTC_HOTPLUG_CPT;
 		vgpu_vreg_t(vgpu, TRANS_DDI_FUNC_CTL(TRANSCODER_A)) &=
 			~(TRANS_DDI_BPC_MASK | TRANS_DDI_MODE_SELECT_MASK |
@@ -255,6 +288,12 @@ static void emulate_monitor_status_chang
 	}
 
 	if (intel_vgpu_has_monitor_on_port(vgpu, PORT_D)) {
+		vgpu_vreg_t(vgpu, DPLL_CTRL2) &=
+			~DPLL_CTRL2_DDI_CLK_OFF(PORT_D);
+		vgpu_vreg_t(vgpu, DPLL_CTRL2) |=
+			DPLL_CTRL2_DDI_CLK_SEL(DPLL_ID_SKL_DPLL0, PORT_D);
+		vgpu_vreg_t(vgpu, DPLL_CTRL2) |=
+			DPLL_CTRL2_DDI_SEL_OVERRIDE(PORT_D);
 		vgpu_vreg_t(vgpu, SDEISR) |= SDE_PORTD_HOTPLUG_CPT;
 		vgpu_vreg_t(vgpu, TRANS_DDI_FUNC_CTL(TRANSCODER_A)) &=
 			~(TRANS_DDI_BPC_MASK | TRANS_DDI_MODE_SELECT_MASK |


