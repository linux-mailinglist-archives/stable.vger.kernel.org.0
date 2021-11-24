Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978C545C641
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352003AbhKXOG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356459AbhKXOEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA1E761A8B;
        Wed, 24 Nov 2021 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759464;
        bh=7zVrVmV9jJTb5PlV1VlzDL0SGJx/XoXZS0EgV5cuZWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7eWFgtKpU985xCtOhKU8C5/ldWgVwp9UtVD7dxP2fx3VZ5L5igBAeT95VrUoTDS+
         1erXIWhPSVl9fQ4YH1INGa62UyYBDNLwrtURtCtBGGyE2LvqJfG6whsKYeHmP6Swkt
         8lIwvsepOQHGqaW7GNPi7X/ddypw59ZBToQHEOtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 251/279] drm/i915/dp: Ensure sink rate values are always valid
Date:   Wed, 24 Nov 2021 12:58:58 +0100
Message-Id: <20211124115727.401266902@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

commit 6c34bd4532a3f39952952ddc102737595729afc4 upstream.

Atm, there are no sink rate values set for DP (vs. eDP) sinks until the
DPCD capabilities are successfully read from the sink. During this time
intel_dp->num_common_rates is 0 which can lead to a

intel_dp->common_rates[-1]    (*)

access, which is an undefined behaviour, in the following cases:

- In intel_dp_sync_state(), if the encoder is enabled without a sink
  connected to the encoder's connector (BIOS enabled a monitor, but the
  user unplugged the monitor until the driver loaded).
- In intel_dp_sync_state() if the encoder is enabled with a sink
  connected, but for some reason the DPCD read has failed.
- In intel_dp_compute_link_config() if modesetting a connector without
  a sink connected on it.
- In intel_dp_compute_link_config() if modesetting a connector with a
  a sink connected on it, but before probing the connector first.

To avoid the (*) access in all the above cases, make sure that the sink
rate table - and hence the common rate table - is always valid, by
setting a default minimum sink rate when registering the connector
before anything could use it.

I also considered setting all the DP link rates by default, so that
modesetting with higher resolution modes also succeeds in the last two
cases above. However in case a sink is not connected that would stop
working after the first modeset, due to the LT fallback logic. So this
would need more work, beyond the scope of this fix.

As I mentioned in the previous patch, I don't think the issue this patch
fixes is user visible, however it is an undefined behaviour by
definition and triggers a BUG() in CONFIG_UBSAN builds, hence CC:stable.

v2: Clear the default sink rates, before initializing these for eDP.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4297
Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211018143417.1452632-1-imre.deak@intel.com
(cherry picked from commit 3f61ef9777c0ab0f03f4af0ed6fd3e5250537a8d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -111,6 +111,12 @@ bool intel_dp_is_edp(struct intel_dp *in
 static void intel_dp_unset_edid(struct intel_dp *intel_dp);
 static int intel_dp_dsc_compute_bpp(struct intel_dp *intel_dp, u8 dsc_max_bpc);
 
+static void intel_dp_set_default_sink_rates(struct intel_dp *intel_dp)
+{
+	intel_dp->sink_rates[0] = 162000;
+	intel_dp->num_sink_rates = 1;
+}
+
 /* update sink rates from dpcd */
 static void intel_dp_set_sink_rates(struct intel_dp *intel_dp)
 {
@@ -2462,6 +2468,9 @@ intel_edp_init_dpcd(struct intel_dp *int
 	 */
 	intel_psr_init_dpcd(intel_dp);
 
+	/* Clear the default sink rates */
+	intel_dp->num_sink_rates = 0;
+
 	/* Read the eDP 1.4+ supported link rates. */
 	if (intel_dp->edp_dpcd[0] >= DP_EDP_14) {
 		__le16 sink_rates[DP_MAX_SUPPORTED_RATES];
@@ -5296,6 +5305,8 @@ intel_dp_init_connector(struct intel_dig
 		return false;
 
 	intel_dp_set_source_rates(intel_dp);
+	intel_dp_set_default_sink_rates(intel_dp);
+	intel_dp_set_common_rates(intel_dp);
 
 	intel_dp->reset_link_params = true;
 	intel_dp->pps.pps_pipe = INVALID_PIPE;


