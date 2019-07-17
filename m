Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490A06BBB8
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 13:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbfGQLpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 07:45:39 -0400
Received: from mga04.intel.com ([192.55.52.120]:28556 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQLpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 07:45:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 04:45:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,274,1559545200"; 
   d="scan'208";a="158440138"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga007.jf.intel.com with SMTP; 17 Jul 2019 04:45:36 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 17 Jul 2019 14:45:36 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Stefan Gottwald <gottwald@igel.com>
Subject: [PATCH] drm/i915: Make sure cdclk is high enough for DP audio on VLV/CHV
Date:   Wed, 17 Jul 2019 14:45:36 +0300
Message-Id: <20190717114536.22937-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

On VLV/CHV there is some kind of linkage between the cdclk frequency
and the DP link frequency. The spec says:
"For DP audio configuration, cdclk frequency shall be set to
 meet the following requirements:
 DP Link Frequency(MHz) | Cdclk frequency(MHz)
 270                    | 320 or higher
 162                    | 200 or higher"

I suspect that would more accurately be expressed as
"cdclk >= DP link clock", and in any case we can express it like
that in the code because of the limited set of cdclk and link
frequencies we support.

Without this we can end up in a situation where the cdclk
is too low and enabling DP audio will kill the pipe. Happens
eg. with 2560x1440 modes where the 266MHz cdclk is sufficient
to pump the pixels (241.5 MHz dotclock) but is too low for
the DP audio due to the link frequency being 270 MHz.

Cc: stable@vger.kernel.org
Tested-by: Stefan Gottwald <gottwald@igel.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111149
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_cdclk.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_cdclk.c b/drivers/gpu/drm/i915/display/intel_cdclk.c
index d0581a1ac243..93b0d190c184 100644
--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -2262,6 +2262,17 @@ int intel_crtc_compute_min_cdclk(const struct intel_crtc_state *crtc_state)
 	if (crtc_state->has_audio && INTEL_GEN(dev_priv) >= 9)
 		min_cdclk = max(2 * 96000, min_cdclk);
 
+	/*
+	 * "For DP audio configuration, cdclk frequency shall be set to
+	 *  meet the following requirements:
+	 *  DP Link Frequency(MHz) | Cdclk frequency(MHz)
+	 *  270                    | 320 or higher
+	 *  162                    | 200 or higher"
+	 */
+	if ((IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv)) &&
+	    intel_crtc_has_dp_encoder(crtc_state) && crtc_state->has_audio)
+		min_cdclk = max(crtc_state->port_clock, min_cdclk);
+
 	/*
 	 * On Valleyview some DSI panels lose (v|h)sync when the clock is lower
 	 * than 320000KHz.
-- 
2.21.0

