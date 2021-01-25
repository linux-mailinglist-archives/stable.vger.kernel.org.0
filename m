Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78BF302914
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 18:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbhAYRh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 12:37:58 -0500
Received: from mga18.intel.com ([134.134.136.126]:23216 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731166AbhAYRh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 12:37:29 -0500
IronPort-SDR: OXq48ZPVpswbgiqWwyPCnNHuy7Foxo8XbUhLm8MeIhCgDonJr/IIxI1Uz8Tis2NoR2nMx+KVTI
 c3CqiLUBCmtw==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="167443706"
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="167443706"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 09:36:41 -0800
IronPort-SDR: SS+t5iJRs09DMk6QYOyzzfYVPVmMxIXKqlKZ7nzHO6kZmW7Y3RpzamfrzdWD/tM1xxIZ4va1pL
 quJEHqucNfFg==
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="368762541"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 09:36:40 -0800
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Ville Syrjala <ville.syrjala@intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] drm/i915: Fix the MST PBN divider calculation
Date:   Mon, 25 Jan 2021 19:36:36 +0200
Message-Id: <20210125173636.1733812-2-imre.deak@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125173636.1733812-1-imre.deak@intel.com>
References: <20210125173636.1733812-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Atm the driver will calculate a wrong MST timeslots/MTP (aka time unit)
value for MST streams if the link parameters (link rate or lane count)
are limited in a way independent of the sink capabilities (reported by
DPCD).

One example of such a limitation is when a MUX between the sink and
source connects only a limited number of lanes to the display and
connects the rest of the lanes to other peripherals (USB).

Another issue is that atm MST core calculates the divider based on the
backwards compatible DPCD (at address 0x0000) vs. the extended
capability info (at address 0x2200). This can result in leaving some
part of the MST BW unused (For instance in case of the WD19TB dock).

Fix the above two issues by calculating the PBN divider value based on
the rate and lane count link parameters that the driver uses for all
other computation.

Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/2977
Cc: Lyude Paul <lyude@redhat.com>
Cc: Ville Syrjala <ville.syrjala@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index d6a1b961a0e8..b4621ed0127e 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -68,7 +68,9 @@ static int intel_dp_mst_compute_link_config(struct intel_encoder *encoder,
 
 		slots = drm_dp_atomic_find_vcpi_slots(state, &intel_dp->mst_mgr,
 						      connector->port,
-						      crtc_state->pbn, 0);
+						      crtc_state->pbn,
+						      drm_dp_get_vc_payload_bw(crtc_state->port_clock,
+									       crtc_state->lane_count));
 		if (slots == -EDEADLK)
 			return slots;
 		if (slots >= 0)
-- 
2.25.1

