Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2048349C7C4
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 11:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbiAZKoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 05:44:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:49169 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240143AbiAZKoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jan 2022 05:44:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643193841; x=1674729841;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f+7+QoBhlzImHYkfJJm3hZlgyky9AOV+11LcpKZ8Bbo=;
  b=bsb6nLqa/dCWRhU83tVvQCKkO9zXMr2qjdlYplBkO/BlbWyGgyoAXlEE
   EnyiEGRciBMIYQs3eeKgFAUyErdrpSPDmFBEsBzow7xA0nWQ2BEpq+KBs
   GlMPsNegjSyZKQ+k5HE3fyRURyfxYvZkHFBveI1agUyMfDcWaDjJkedFZ
   ceXtWhBk1CCWYsmY6/sMRA6Eo/Gd4YFaMpUqFZv8C4Lso2aKio6Hlj1uC
   aOUwRhQfW/36tu+je22sgNVt9JVC75DkxjELf3q3b1heZ1oC1bYDe44h6
   Qx/3qbE/cXCYPkqaAm5+IQ/pdhH+J/6q47MMr0yxt2GE8MGAQFdQq5I5w
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="233899492"
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="233899492"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 02:44:01 -0800
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="479842901"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 02:43:59 -0800
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chia-Lin Kao <acelan.kao@canonical.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/adlp: Fix TypeC PHY-ready status readout
Date:   Wed, 26 Jan 2022 12:43:56 +0200
Message-Id: <20220126104356.2022975-1-imre.deak@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The TCSS_DDI_STATUS register is indexed by tc_port not by the FIA port
index, fix this up. This only caused an issue on TC#3/4 ports in legacy
mode, as in all other cases the two indices either match (on TC#1/2) or
the TCSS_DDI_STATUS_READY flag is set regardless of something being
connected or not (on TC#1/2/3/4 in dp-alt and tbt-alt modes).

Reported-and-tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Fixes: 55ce306c2aa1 ("drm/i915/adl_p: Implement TC sequences")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4698
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: <stable@vger.kernel.org> # v5.14+
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/display/intel_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_tc.c b/drivers/gpu/drm/i915/display/intel_tc.c
index 4eefe7b0bb263..3291124a99e5a 100644
--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -346,10 +346,11 @@ static bool icl_tc_phy_status_complete(struct intel_digital_port *dig_port)
 static bool adl_tc_phy_status_complete(struct intel_digital_port *dig_port)
 {
 	struct drm_i915_private *i915 = to_i915(dig_port->base.base.dev);
+	enum tc_port tc_port = intel_port_to_tc(i915, dig_port->base.port);
 	struct intel_uncore *uncore = &i915->uncore;
 	u32 val;
 
-	val = intel_uncore_read(uncore, TCSS_DDI_STATUS(dig_port->tc_phy_fia_idx));
+	val = intel_uncore_read(uncore, TCSS_DDI_STATUS(tc_port));
 	if (val == 0xffffffff) {
 		drm_dbg_kms(&i915->drm,
 			    "Port %s: PHY in TCCOLD, assuming not complete\n",
-- 
2.27.0

