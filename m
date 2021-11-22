Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59836458E67
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 13:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhKVMfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 07:35:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233849AbhKVMfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Nov 2021 07:35:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30A0C60FC2;
        Mon, 22 Nov 2021 12:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637584353;
        bh=6rFv8KVrdFqu9DsMCIsyVPzAJfSDTaw9GpV4uqaFE1I=;
        h=Subject:To:Cc:From:Date:From;
        b=cWexAbvUvLHOS+va54MwgYOu09c8GiXXVE/mQe1qLS2Ek4m1BmzxfgUsM+nSoIGYv
         lvvVVfaJ/DvQGPqHnbqOa4J04AxDvIxmQomVtIRBKCHTqPDge1sEDZ+RtuoBwNPz/8
         OMw76zz6zjsOqGw+wFeAHf7xO7mLzK0FkUVh7CV8=
Subject: FAILED: patch "[PATCH] Revert "drm/i915/tgl/dsi: Gate the ddi clocks after pll" failed to apply to 5.4-stable tree
To:     vandita.kulkarni@intel.com, jani.nikula@intel.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Nov 2021 13:32:18 +0100
Message-ID: <1637584338221152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f15863b27752682bb700c21de5f83f613a0fb77e Mon Sep 17 00:00:00 2001
From: Vandita Kulkarni <vandita.kulkarni@intel.com>
Date: Tue, 9 Nov 2021 17:34:28 +0530
Subject: [PATCH] Revert "drm/i915/tgl/dsi: Gate the ddi clocks after pll
 mapping"

This reverts commit 991d9557b0c4 ("drm/i915/tgl/dsi: Gate the ddi clocks
after pll mapping"). The Bspec was updated recently with the pll ungate
sequence similar to that of icl dsi enable sequence. Hence reverting.

Bspec: 49187
Fixes: 991d9557b0c4 ("drm/i915/tgl/dsi: Gate the ddi clocks after pll mapping")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Vandita Kulkarni <vandita.kulkarni@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211109120428.15211-1-vandita.kulkarni@intel.com
(cherry picked from commit 4579509ef181480f4e4510d436c691519167c5c2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 168c84a74d30..00f270c41894 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -696,10 +696,7 @@ static void gen11_dsi_map_pll(struct intel_encoder *encoder,
 	intel_de_write(dev_priv, ICL_DPCLKA_CFGCR0, val);
 
 	for_each_dsi_phy(phy, intel_dsi->phys) {
-		if (DISPLAY_VER(dev_priv) >= 12)
-			val |= ICL_DPCLKA_CFGCR0_DDI_CLK_OFF(phy);
-		else
-			val &= ~ICL_DPCLKA_CFGCR0_DDI_CLK_OFF(phy);
+		val &= ~ICL_DPCLKA_CFGCR0_DDI_CLK_OFF(phy);
 	}
 	intel_de_write(dev_priv, ICL_DPCLKA_CFGCR0, val);
 
@@ -1135,8 +1132,6 @@ static void
 gen11_dsi_enable_port_and_phy(struct intel_encoder *encoder,
 			      const struct intel_crtc_state *crtc_state)
 {
-	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
-
 	/* step 4a: power up all lanes of the DDI used by DSI */
 	gen11_dsi_power_up_lanes(encoder);
 
@@ -1162,8 +1157,7 @@ gen11_dsi_enable_port_and_phy(struct intel_encoder *encoder,
 	gen11_dsi_configure_transcoder(encoder, crtc_state);
 
 	/* Step 4l: Gate DDI clocks */
-	if (DISPLAY_VER(dev_priv) == 11)
-		gen11_dsi_gate_clocks(encoder);
+	gen11_dsi_gate_clocks(encoder);
 }
 
 static void gen11_dsi_powerup_panel(struct intel_encoder *encoder)

