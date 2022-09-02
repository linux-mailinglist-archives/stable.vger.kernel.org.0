Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F19E5AA87B
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 09:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiIBHD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 03:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbiIBHDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 03:03:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4114BCC1A
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 00:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662102202; x=1693638202;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2kEVMerJzzNBHXgKnx0r6fq6Mc/Ic+VfiRCxqauUitY=;
  b=lhXWirzS/5ICzB8vGQCbG/ysG1ZAcbAgHwGjcOzS8yd4VRjzpOB2GS88
   NSg1T1hZu94li6v03V3GsAEgxQ37io8XruZOsHBYWN7HIMSa3/0/VKcd5
   l2R1aK5X1lJ2u2P0/xL2ByMC64vVkg07dN9P2lUFV+d3IyMWCcjZ3Rj1n
   PUO6fBQ/3QMwD94OuIFcclq+MUTB8TLtpemlRDelGe8hPtm0l5yAzmNMg
   B30V0qoSyV5P1dZ1IMu9xI0f0nXepIm91FrQtBKR1eHQxRxGmvUIroHhB
   LWz7583nea2lvfhsPPYq0EAHQ7JHVTf+h5UJrfhhhAeKGYM126dUTlz/u
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="293488687"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="293488687"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 00:03:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="716417089"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by fmsmga002.fm.intel.com with SMTP; 02 Sep 2022 00:03:19 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 02 Sep 2022 10:03:19 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 1/2] drm/i915: Implement WaEdpLinkRateDataReload
Date:   Fri,  2 Sep 2022 10:03:18 +0300
Message-Id: <20220902070319.15395-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

A lot of modern laptops use the Parade PS8461E MUX for eDP
switching. The MUX can operate in jitter cleaning mode or
redriver mode, the first one resulting in higher link
quality. The jitter cleaning mode needs to know the link
rate used and the MUX achieves this by snooping the
LINK_BW_SET, LINK_RATE_SELECT and SUPPORTED_LINK_RATES
DPCD accesses.

When the MUX is powered down (seems this can happen whenever
the display is turned off) it loses track of the snooped
link rates so when we do the LINK_RATE_SELECT write it no
longer knowns which link rate we're selecting, and thus it
falls back to the lower quality redriver mode. This results
in unstable high link rates (eg. usually 8.1Gbps link rate
no longer works correctly).

In order to avoid all that let's re-snoop SUPPORTED_LINK_RATES
from the sink at the start of every link training.

Unfortunately we don't have a way to detect the presence of
the MUX. It looks like the set of laptops equipped with this
MUX is fairly large and contains devices from multiple
manufacturers. It may also still be growing with new models.
So a quirk doesn't seem like a very easily maintainable
option, thus we shall attempt to do this unconditionally on
all machines that use LINK_RATE_SELECT. Hopefully this extra
DPCD read doesn't cause issues for any unaffected machine.
If that turns out to be the case we'll need to convert this
into a quirk in the future.

Cc: stable@vger.kernel.org
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6205
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 .../drm/i915/display/intel_dp_link_training.c | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index 9feaf1a589f3..d213d8ad1ea5 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -671,6 +671,28 @@ intel_dp_prepare_link_train(struct intel_dp *intel_dp,
 	intel_dp_compute_rate(intel_dp, crtc_state->port_clock,
 			      &link_bw, &rate_select);
 
+	/*
+	 * WaEdpLinkRateDataReload
+	 *
+	 * Parade PS8461E MUX (used on varius TGL+ laptops) needs
+	 * to snoop the link rates reported by the sink when we
+	 * use LINK_RATE_SET in order to operate in jitter cleaning
+	 * mode (as opposed to redriver mode). Unfortunately it
+	 * loses track of the snooped link rates when powered down,
+	 * so we need to make it re-snoop often. Without this high
+	 * link rates are not stable.
+	 */
+	if (!link_bw) {
+		struct intel_connector *connector = intel_dp->attached_connector;
+		__le16 sink_rates[DP_MAX_SUPPORTED_RATES];
+
+		drm_dbg_kms(&i915->drm, "[CONNECTOR:%d:%s] Reloading eDP link rates\n",
+			    connector->base.base.id, connector->base.name);
+
+		drm_dp_dpcd_read(&intel_dp->aux, DP_SUPPORTED_LINK_RATES,
+				 sink_rates, sizeof(sink_rates));
+	}
+
 	if (link_bw)
 		drm_dbg_kms(&i915->drm,
 			    "[ENCODER:%d:%s] Using LINK_BW_SET value %02x\n",
-- 
2.35.1

