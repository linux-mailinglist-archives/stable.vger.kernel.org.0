Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83DB31BCD4
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhBOPga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:36:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231258AbhBOPdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:33:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DF7164E37;
        Mon, 15 Feb 2021 15:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403059;
        bh=xUIPfj8AYIqGsDzTFoh0c55RCHMd+0mNLc0V15ODvY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loQN4Ire6O6XIlG5T3yhuCL5BPYxubbXfDMgFsgVrzH5rRTSSVGUksSzvuIvEcJBG
         dySY1q5SG4hWsV/KfQ7zYvh31L6sEDHbk38TCng3QecYgkUN9DM/FpucGb6hXieGQL
         GKqNxr6wC7RG/5WQbyg6s0s2SnQQmmpoh6EYAQvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 012/104] drm/i915/tgl+: Make sure TypeC FIA is powered up when initializing it
Date:   Mon, 15 Feb 2021 16:26:25 +0100
Message-Id: <20210215152719.858492911@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 2f51312bebb77962a518b4c6de777dd378b6110a upstream.

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
Link: https://patchwork.freedesktop.org/patch/msgid/20210208154303.6839-1-imre.deak@intel.com
Reviewed-by: Jos� Roberto de Souza <jose.souza@intel.com>
(cherry picked from commit f48993e5d26b079e8c80fff002499a213dbdb1b4)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c |   67 +++++++++++++++++---------------
 1 file changed, 37 insertions(+), 30 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -23,36 +23,6 @@ static const char *tc_port_mode_name(enu
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
@@ -646,6 +616,43 @@ void intel_tc_port_put_link(struct intel
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


