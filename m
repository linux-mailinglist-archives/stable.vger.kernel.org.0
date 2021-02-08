Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD013137D0
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhBHPcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233105AbhBHP07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:26:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85FC164EFA;
        Mon,  8 Feb 2021 15:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797349;
        bh=WW71G7RIySAXrZ8w22mOhxvua5JhQmPYzLZ3M1tSoA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=na3KUVrj50CMEExkgH5aagTrsplUKs22sRs6ATkAAgvmc2QRBMvExtucml5oxrZq3
         qEVYveCi5+krKNMPd3UE8btO7RC+cn1i88229HdHSfLbrdVp4o9Cf6TD/gtNCygKnA
         NaaNnl1sJwkXJ2YWb7CymXKHpGV/oSBwYfenRwYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ville Syrjala <ville.syrjala@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 079/120] drm/i915: Fix the MST PBN divider calculation
Date:   Mon,  8 Feb 2021 16:01:06 +0100
Message-Id: <20210208145821.553572226@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 882554042d138dbc6fb1a43017d0b9c3b38ee5f5 upstream.

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
Reviewed-by: Ville Syrjala <ville.syrjala@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210125173636.1733812-2-imre.deak@intel.com
(cherry picked from commit b59c27cab257cfbff939615a87b72bce83925710)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -68,7 +68,9 @@ static int intel_dp_mst_compute_link_con
 
 		slots = drm_dp_atomic_find_vcpi_slots(state, &intel_dp->mst_mgr,
 						      connector->port,
-						      crtc_state->pbn, 0);
+						      crtc_state->pbn,
+						      drm_dp_get_vc_payload_bw(crtc_state->port_clock,
+									       crtc_state->lane_count));
 		if (slots == -EDEADLK)
 			return slots;
 		if (slots >= 0)


