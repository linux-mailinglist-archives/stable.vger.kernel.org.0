Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DDA313872
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhBHPsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:48:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:27981 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231821AbhBHPqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:46:47 -0500
IronPort-SDR: nqmMFtZ1sbX0wbpJt0p2LWXtIvWPkUFIaTfsLCXWjfn8CwjdADelsICZLilH6jQAEBHD8tLIEZ
 j4K9KlAHBQPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="181876399"
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="181876399"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 07:43:08 -0800
IronPort-SDR: sn3QyS2oGRgab5jNjl5mVjEEpyCbJ1Ey0l7Lj085o0M04fKNxN1GkhJ/hFvNcQntluWFbLR1fy
 hfLr62MkvGfA==
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="395482465"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 07:43:06 -0800
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH] drm/i915/tgl+: Make sure TypeC FIA is powered up when initializing it
Date:   Mon,  8 Feb 2021 17:43:03 +0200
Message-Id: <20210208154303.6839-1-imre.deak@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The TypeC FIA can be powered down if the TC-COLD power state is allowed,
so block the TC-COLD state when initializing the FIA.

Note that this isn't needed on ICL where the FIA is never modular and
which has no generic way to block TC-COLD (except for platforms with a
legacy TypeC port and on those too only via these legacy ports, not via
a DP-alt/TBT port).

Cc: <stable@vger.kernel.org> # v5.10+
Cc: José Roberto de Souza <jose.souza@intel.com>
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3027
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/display/intel_tc.c | 67 ++++++++++++++-----------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_tc.c b/drivers/gpu/drm/i915/display/intel_tc.c
index 27dc2dad6809c..2cefc13535a0f 100644
--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -23,36 +23,6 @@ static const char *tc_port_mode_name(enum tc_port_mode mode)
 	return names[mode];
 }
 
-static void
-tc_port_load_fia_params(struct drm_i915_private *i915,
-			struct intel_digital_port *dig_port)
-{
-	enum port port = dig_port->base.port;
-	enum tc_port tc_port = intel_port_to_tc(i915, port);
-	u32 modular_fia;
-
-	if (INTEL_INFO(i915)->display.has_modular_fia) {
-		modular_fia = intel_uncore_read(&i915->uncore,
-						PORT_TX_DFLEXDPSP(FIA1));
-		drm_WARN_ON(&i915->drm, modular_fia == 0xffffffff);
-		modular_fia &= MODULAR_FIA_MASK;
-	} else {
-		modular_fia = 0;
-	}
-
-	/*
-	 * Each Modular FIA instance houses 2 TC ports. In SOC that has more
-	 * than two TC ports, there are multiple instances of Modular FIA.
-	 */
-	if (modular_fia) {
-		dig_port->tc_phy_fia = tc_port / 2;
-		dig_port->tc_phy_fia_idx = tc_port % 2;
-	} else {
-		dig_port->tc_phy_fia = FIA1;
-		dig_port->tc_phy_fia_idx = tc_port;
-	}
-}
-
 static enum intel_display_power_domain
 tc_cold_get_power_domain(struct intel_digital_port *dig_port)
 {
@@ -646,6 +616,43 @@ void intel_tc_port_put_link(struct intel_digital_port *dig_port)
 	mutex_unlock(&dig_port->tc_lock);
 }
 
+static bool
+tc_has_modular_fia(struct drm_i915_private *i915, struct intel_digital_port *dig_port)
+{
+	intel_wakeref_t wakeref;
+	u32 val;
+
+	if (!INTEL_INFO(i915)->display.has_modular_fia)
+		return false;
+
+	wakeref = tc_cold_block(dig_port);
+	val = intel_uncore_read(&i915->uncore, PORT_TX_DFLEXDPSP(FIA1));
+	tc_cold_unblock(dig_port, wakeref);
+
+	drm_WARN_ON(&i915->drm, val == 0xffffffff);
+
+	return val & MODULAR_FIA_MASK;
+}
+
+static void
+tc_port_load_fia_params(struct drm_i915_private *i915, struct intel_digital_port *dig_port)
+{
+	enum port port = dig_port->base.port;
+	enum tc_port tc_port = intel_port_to_tc(i915, port);
+
+	/*
+	 * Each Modular FIA instance houses 2 TC ports. In SOC that has more
+	 * than two TC ports, there are multiple instances of Modular FIA.
+	 */
+	if (tc_has_modular_fia(i915, dig_port)) {
+		dig_port->tc_phy_fia = tc_port / 2;
+		dig_port->tc_phy_fia_idx = tc_port % 2;
+	} else {
+		dig_port->tc_phy_fia = FIA1;
+		dig_port->tc_phy_fia_idx = tc_port;
+	}
+}
+
 void intel_tc_port_init(struct intel_digital_port *dig_port, bool is_legacy)
 {
 	struct drm_i915_private *i915 = to_i915(dig_port->base.base.dev);
-- 
2.25.1

