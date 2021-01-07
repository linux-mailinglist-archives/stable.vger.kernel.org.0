Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB452ED287
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbhAGOdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729687AbhAGOdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F19A32333E;
        Thu,  7 Jan 2021 14:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610030019;
        bh=XMYBFcx+Ms83AdlWa61yPDSppy10G1ZWHIb76aL7VHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cND5N0Qx/S1spSOewP3+URfgUej6R5OO79Mb12KuhVCUnZkawslCNKqJsz82uvj8D
         2pNvEqBpdoyRIn01UoReGquuWz0kNUY8GAyUstM+NaqqFZ34kAQ4bd2jw4yLf7P6mx
         YEoL2bUnuIV55XJeFgwO/xi+vL6kDEaLC4P9/9qU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>
Subject: [PATCH 5.10 10/20] drm/i915/tgl: Fix Combo PHY DPLL fractional divider for 38.4MHz ref clock
Date:   Thu,  7 Jan 2021 15:34:05 +0100
Message-Id: <20210107143053.839232037@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 0e2497e334de42dbaaee8e325241b5b5b34ede7e upstream.

Apply Display WA #22010492432 for combo PHY PLLs too. This should fix a
problem where the PLL output frequency is slightly off with the current
PLL fractional divider value.

I haven't seen an actual case where this causes a problem, but let's
follow the spec. It's also needed on some EHL platforms, but for that we
also need a way to distinguish the affected EHL SKUs, so I leave that
for a follow-up.

v2:
- Apply the WA at one place when calculating the PLL dividers from the
  frequency and the frequency from the dividers for all the combo PLL
  use cases (DP, HDMI, TBT). (Ville)

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201003001846.1271151-6-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |   41 +++++++++++++++-----------
 1 file changed, 25 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -2622,11 +2622,22 @@ static bool cnl_ddi_hdmi_pll_dividers(st
 	return true;
 }
 
+/*
+ * Display WA #22010492432: tgl
+ * Program half of the nominal DCO divider fraction value.
+ */
+static bool
+tgl_combo_pll_div_frac_wa_needed(struct drm_i915_private *i915)
+{
+	return IS_TIGERLAKE(i915) && i915->dpll.ref_clks.nssc == 38400;
+}
+
 static int __cnl_ddi_wrpll_get_freq(struct drm_i915_private *dev_priv,
 				    const struct intel_shared_dpll *pll,
 				    int ref_clock)
 {
 	const struct intel_dpll_hw_state *pll_state = &pll->state.hw_state;
+	u32 dco_fraction;
 	u32 p0, p1, p2, dco_freq;
 
 	p0 = pll_state->cfgcr1 & DPLL_CFGCR1_PDIV_MASK;
@@ -2669,8 +2680,13 @@ static int __cnl_ddi_wrpll_get_freq(stru
 	dco_freq = (pll_state->cfgcr0 & DPLL_CFGCR0_DCO_INTEGER_MASK) *
 		   ref_clock;
 
-	dco_freq += (((pll_state->cfgcr0 & DPLL_CFGCR0_DCO_FRACTION_MASK) >>
-		      DPLL_CFGCR0_DCO_FRACTION_SHIFT) * ref_clock) / 0x8000;
+	dco_fraction = (pll_state->cfgcr0 & DPLL_CFGCR0_DCO_FRACTION_MASK) >>
+		       DPLL_CFGCR0_DCO_FRACTION_SHIFT;
+
+	if (tgl_combo_pll_div_frac_wa_needed(dev_priv))
+		dco_fraction *= 2;
+
+	dco_freq += (dco_fraction * ref_clock) / 0x8000;
 
 	if (drm_WARN_ON(&dev_priv->drm, p0 == 0 || p1 == 0 || p2 == 0))
 		return 0;
@@ -2948,16 +2964,6 @@ static const struct skl_wrpll_params tgl
 	/* the following params are unused */
 };
 
-/*
- * Display WA #22010492432: tgl
- * Divide the nominal .dco_fraction value by 2.
- */
-static const struct skl_wrpll_params tgl_tbt_pll_38_4MHz_values = {
-	.dco_integer = 0x54, .dco_fraction = 0x1800,
-	/* the following params are unused */
-	.pdiv = 0, .kdiv = 0, .qdiv_mode = 0, .qdiv_ratio = 0,
-};
-
 static bool icl_calc_dp_combo_pll(struct intel_crtc_state *crtc_state,
 				  struct skl_wrpll_params *pll_params)
 {
@@ -2991,14 +2997,12 @@ static bool icl_calc_tbt_pll(struct inte
 			MISSING_CASE(dev_priv->dpll.ref_clks.nssc);
 			fallthrough;
 		case 19200:
+		case 38400:
 			*pll_params = tgl_tbt_pll_19_2MHz_values;
 			break;
 		case 24000:
 			*pll_params = tgl_tbt_pll_24MHz_values;
 			break;
-		case 38400:
-			*pll_params = tgl_tbt_pll_38_4MHz_values;
-			break;
 		}
 	} else {
 		switch (dev_priv->dpll.ref_clks.nssc) {
@@ -3065,9 +3069,14 @@ static void icl_calc_dpll_state(struct d
 				const struct skl_wrpll_params *pll_params,
 				struct intel_dpll_hw_state *pll_state)
 {
+	u32 dco_fraction = pll_params->dco_fraction;
+
 	memset(pll_state, 0, sizeof(*pll_state));
 
-	pll_state->cfgcr0 = DPLL_CFGCR0_DCO_FRACTION(pll_params->dco_fraction) |
+	if (tgl_combo_pll_div_frac_wa_needed(i915))
+		dco_fraction = DIV_ROUND_CLOSEST(dco_fraction, 2);
+
+	pll_state->cfgcr0 = DPLL_CFGCR0_DCO_FRACTION(dco_fraction) |
 			    pll_params->dco_integer;
 
 	pll_state->cfgcr1 = DPLL_CFGCR1_QDIV_RATIO(pll_params->qdiv_ratio) |


