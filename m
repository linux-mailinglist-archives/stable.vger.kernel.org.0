Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98F930D661
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 10:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBCJc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 04:32:57 -0500
Received: from mga05.intel.com ([192.55.52.43]:4633 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233461AbhBCJcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 04:32:33 -0500
IronPort-SDR: AKehEQr8PAiuntzstccfnn7RuzpR4Y8XHk0/TGjv7oK+JJXQomUFvMyjECqdWaFYJpR/rjbVfT
 fEnRQYggU7TQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="265845235"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="265845235"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 01:30:47 -0800
IronPort-SDR: plsLEjxuFOe/ml+vJEWuRTD7G7oyTdaNNALy0AWh/4s2aI4Lh0Su04fD6MPjVL08IKma5fSx/o
 Tujov3rMr43A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="372313456"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga002.jf.intel.com with SMTP; 03 Feb 2021 01:30:44 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 03 Feb 2021 11:30:44 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915: Reject 446-480MHz HDMI clock on GLK
Date:   Wed,  3 Feb 2021 11:30:44 +0200
Message-Id: <20210203093044.30532-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The BXT/GLK DPLL can't generate certain frequencies. We already
reject the 233-240MHz range on both. But on GLK the DPLL max
frequency was bumped from 300MHz to 594MHz, so now we get to
also worry about the 446-480MHz range (double the original
problem range). Reject any frequency within the higher
problematic range as well.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3000
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_hdmi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
index 66e1ac3887c6..b593a71e6517 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -2218,7 +2218,11 @@ hdmi_port_clock_valid(struct intel_hdmi *hdmi,
 					  has_hdmi_sink))
 		return MODE_CLOCK_HIGH;
 
-	/* BXT DPLL can't generate 223-240 MHz */
+	/* GLK DPLL can't generate 446-480 MHz */
+	if (IS_GEMINILAKE(dev_priv) && clock > 446666 && clock < 480000)
+		return MODE_CLOCK_RANGE;
+
+	/* BXT/GLK DPLL can't generate 223-240 MHz */
 	if (IS_GEN9_LP(dev_priv) && clock > 223333 && clock < 240000)
 		return MODE_CLOCK_RANGE;
 
-- 
2.26.2

