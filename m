Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A98A4D6A60
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 00:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiCKWsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 17:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiCKWsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 17:48:08 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA7E1B126B
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 14:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647038152; x=1678574152;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4lEWJKHmkSDk4CpKKqLaMP5QtppZ/wZXsXiAHF1ybME=;
  b=jSOwo4VFLtiR5L/E//b6jqlDDmwBsib4GI6eZlfP2voj/byY1v0phEfn
   baaZ28kFZ3rB6497HaznrLZzG5zoyT4npIVehCHk3q/LNEDZNbu2Y6dy3
   0qcl4BKLjrYDe2+K9rHGT5U+rnWcqGSKDX9Hi7rdDPgYKMcq+4pQ6bH6C
   iFTSGgFTIl5dRVFehgVgh6Cp1gRUEelARM8suPrku//HhLVR9M1snU6rw
   dxg/qMVIBZArQik+e3Hvbtr/Nm0YkScoRlEOLesvmum46Oe8YrOH9paMB
   6+Kpbm+od6wSOkLAajxJN2AYJbBvlpzWvKx9qO/EVOOYbfUlBOq9BjQFT
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="254485821"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="254485821"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 13:28:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="511511787"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga002.jf.intel.com with SMTP; 11 Mar 2022 13:28:46 -0800
Received: by stinkbox (sSMTP sendmail emulation); Fri, 11 Mar 2022 23:28:45 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915: Reject unsupported TMDS rates on ICL+
Date:   Fri, 11 Mar 2022 23:28:45 +0200
Message-Id: <20220311212845.32358-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

ICL+ PLLs can't genenerate certain frequencies. Running the PLL
algorithms through for all frequencies 25-594MHz we see a gap just
above 500 MHz. Specifically 500-522.8MHZ for TC PLLs, and 500-533.2
MHz for combo PHY PLLs. Reject those frequencies hdmi_port_clock_valid()
so that we properly filter out unsupported modes and/or color depths
for HDMI.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5247
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_hdmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
index f3e688f739f3..a4a6f8bd2841 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -1837,6 +1837,7 @@ hdmi_port_clock_valid(struct intel_hdmi *hdmi,
 		      bool has_hdmi_sink)
 {
 	struct drm_i915_private *dev_priv = intel_hdmi_to_i915(hdmi);
+	enum phy phy = intel_port_to_phy(dev_priv, hdmi_to_dig_port(hdmi)->base.port);
 
 	if (clock < 25000)
 		return MODE_CLOCK_LOW;
@@ -1857,6 +1858,14 @@ hdmi_port_clock_valid(struct intel_hdmi *hdmi,
 	if (IS_CHERRYVIEW(dev_priv) && clock > 216000 && clock < 240000)
 		return MODE_CLOCK_RANGE;
 
+	/* ICL+ combo PHY PLL can't generate 500-533.2 MHz */
+	if (intel_phy_is_combo(dev_priv, phy) && clock > 500000 && clock < 533200)
+		return MODE_CLOCK_RANGE;
+
+	/* ICL+ TC PHY PLL can't generate 500-532.8 MHz */
+	if (intel_phy_is_tc(dev_priv, phy) && clock > 500000 && clock < 532800)
+		return MODE_CLOCK_RANGE;
+
 	/*
 	 * SNPS PHYs' MPLLB table-based programming can only handle a fixed
 	 * set of link rates.
-- 
2.34.1

