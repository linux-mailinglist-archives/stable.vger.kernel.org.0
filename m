Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808932B6B76
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 18:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgKQROR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 12:14:17 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:63606 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728890AbgKQROR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 12:14:17 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23021599-1500050 
        for multiple; Tue, 17 Nov 2020 17:14:09 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Clinton A Taylor <clinton.a.taylor@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/phy: Quieten state loss across suspend
Date:   Tue, 17 Nov 2020 17:14:11 +0000
Message-Id: <20201117171411.10030-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the HW is powered down, the register state and links are lost. This
may be an issue in the firmware, or in the code expectations; whatever
it is, it is expected behaviour now for Tigerlake; stop warning!

References: https://gitlab.freedesktop.org/drm/intel/-/issues/2411
Fixes: 239bef676d8e ("drm/i915/display: Implement new combo phy initialization step")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Clinton A Taylor <clinton.a.taylor@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: <stable@vger.kernel.org> # v5.9+
---
 drivers/gpu/drm/i915/display/intel_combo_phy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_combo_phy.c b/drivers/gpu/drm/i915/display/intel_combo_phy.c
index d5ad61e4083e..9a87df982af8 100644
--- a/drivers/gpu/drm/i915/display/intel_combo_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_combo_phy.c
@@ -428,9 +428,9 @@ static void icl_combo_phys_uninit(struct drm_i915_private *dev_priv)
 
 		if (phy == PHY_A &&
 		    !icl_combo_phy_verify_state(dev_priv, phy))
-			drm_warn(&dev_priv->drm,
-				 "Combo PHY %c HW state changed unexpectedly\n",
-				 phy_name(phy));
+			drm_dbg_kms(&dev_priv->drm,
+				    "Combo PHY %c HW state changed unexpectedly\n",
+				    phy_name(phy));
 
 		if (!has_phy_misc(dev_priv, phy))
 			goto skip_phy_misc;
-- 
2.20.1

