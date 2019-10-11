Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988D6D4942
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 22:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbfJKUUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 16:20:34 -0400
Received: from mga07.intel.com ([134.134.136.100]:15555 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbfJKUUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 16:20:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 13:20:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,285,1566889200"; 
   d="scan'208";a="193646468"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga008.fm.intel.com with SMTP; 11 Oct 2019 13:20:31 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 11 Oct 2019 23:20:30 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        Masami Ichikawa <masami256@gmail.com>,
        Torsten <freedesktop201910@liggy.de>
Subject: [PATCH] drm/i915: Favor last VBT child device with conflicting AUX ch/DDC pin
Date:   Fri, 11 Oct 2019 23:20:30 +0300
Message-Id: <20191011202030.8829-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The first come first served apporoach to handling the VBT
child device AUX ch conflicts has backfired. We have machines
in the wild where the VBT specifies both port A eDP and
port E DP (in that order) with port E being the real one.

So let's try to flip the preference around and let the last
child device win once again.

Cc: stable@vger.kernel.org
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Masami Ichikawa <masami256@gmail.com>
Tested-by: Torsten <freedesktop201910@liggy.de>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111966
Fixes: 36a0f92020dc ("drm/i915/bios: make child device order the priority order")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_bios.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 9628b485b179..f0307b04cc13 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -1270,7 +1270,7 @@ static void sanitize_ddc_pin(struct drm_i915_private *dev_priv,
 		DRM_DEBUG_KMS("port %c trying to use the same DDC pin (0x%x) as port %c, "
 			      "disabling port %c DVI/HDMI support\n",
 			      port_name(port), info->alternate_ddc_pin,
-			      port_name(p), port_name(port));
+			      port_name(p), port_name(p));
 
 		/*
 		 * If we have multiple ports supposedly sharing the
@@ -1278,9 +1278,14 @@ static void sanitize_ddc_pin(struct drm_i915_private *dev_priv,
 		 * port. Otherwise they share the same ddc bin and
 		 * system couldn't communicate with them separately.
 		 *
-		 * Give child device order the priority, first come first
-		 * served.
+		 * Give inverse child device order the priority,
+		 * last one wins. Yes, there are real machines
+		 * (eg. Asrock B250M-HDV) where VBT has both
+		 * port A and port E with the same AUX ch and
+		 * we must pick port E :(
 		 */
+		info = &dev_priv->vbt.ddi_port_info[p];
+
 		info->supports_dvi = false;
 		info->supports_hdmi = false;
 		info->alternate_ddc_pin = 0;
@@ -1316,7 +1321,7 @@ static void sanitize_aux_ch(struct drm_i915_private *dev_priv,
 		DRM_DEBUG_KMS("port %c trying to use the same AUX CH (0x%x) as port %c, "
 			      "disabling port %c DP support\n",
 			      port_name(port), info->alternate_aux_channel,
-			      port_name(p), port_name(port));
+			      port_name(p), port_name(p));
 
 		/*
 		 * If we have multiple ports supposedlt sharing the
@@ -1324,9 +1329,14 @@ static void sanitize_aux_ch(struct drm_i915_private *dev_priv,
 		 * port. Otherwise they share the same aux channel
 		 * and system couldn't communicate with them separately.
 		 *
-		 * Give child device order the priority, first come first
-		 * served.
+		 * Give inverse child device order the priority,
+		 * last one wins. Yes, there are real machines
+		 * (eg. Asrock B250M-HDV) where VBT has both
+		 * port A and port E with the same AUX ch and
+		 * we must pick port E :(
 		 */
+		info = &dev_priv->vbt.ddi_port_info[p];
+
 		info->supports_dp = false;
 		info->alternate_aux_channel = 0;
 	}
-- 
2.21.0

