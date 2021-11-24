Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965BF45C5FB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348739AbhKXOEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:04:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353589AbhKXOAf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4D4361222;
        Wed, 24 Nov 2021 13:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759349;
        bh=jclETTsaseaTm6oenpZ1mIjTvmcFtQtfA5En+NFhhqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFI+j7ZqLi+POEvdC3DdjkjiGDGUifDSa0jKmvRlc0ob8slrU/JUlzqlB5IfNCt8u
         swZGVg3X9uotKKZYeTYnpxAbK6HW+/VUjgXcC1bjGi2K2jJOPBFfVvskkgWCJ0OaTw
         nyX/2tUNmt6/+eYERAmzCkx86oWE89vheKHyeFvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vandita Kulkarni <vandita.kulkarni@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 211/279] Revert "drm/i915/tgl/dsi: Gate the ddi clocks after pll mapping"
Date:   Wed, 24 Nov 2021 12:58:18 +0100
Message-Id: <20211124115726.029799939@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vandita Kulkarni <vandita.kulkarni@intel.com>

commit f15863b27752682bb700c21de5f83f613a0fb77e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -711,10 +711,7 @@ static void gen11_dsi_map_pll(struct int
 	intel_de_write(dev_priv, ICL_DPCLKA_CFGCR0, val);
 
 	for_each_dsi_phy(phy, intel_dsi->phys) {
-		if (DISPLAY_VER(dev_priv) >= 12)
-			val |= ICL_DPCLKA_CFGCR0_DDI_CLK_OFF(phy);
-		else
-			val &= ~ICL_DPCLKA_CFGCR0_DDI_CLK_OFF(phy);
+		val &= ~ICL_DPCLKA_CFGCR0_DDI_CLK_OFF(phy);
 	}
 	intel_de_write(dev_priv, ICL_DPCLKA_CFGCR0, val);
 
@@ -1150,8 +1147,6 @@ static void
 gen11_dsi_enable_port_and_phy(struct intel_encoder *encoder,
 			      const struct intel_crtc_state *crtc_state)
 {
-	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
-
 	/* step 4a: power up all lanes of the DDI used by DSI */
 	gen11_dsi_power_up_lanes(encoder);
 
@@ -1177,8 +1172,7 @@ gen11_dsi_enable_port_and_phy(struct int
 	gen11_dsi_configure_transcoder(encoder, crtc_state);
 
 	/* Step 4l: Gate DDI clocks */
-	if (DISPLAY_VER(dev_priv) == 11)
-		gen11_dsi_gate_clocks(encoder);
+	gen11_dsi_gate_clocks(encoder);
 }
 
 static void gen11_dsi_powerup_panel(struct intel_encoder *encoder)


