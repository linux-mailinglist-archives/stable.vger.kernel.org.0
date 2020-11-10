Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C58C2AE159
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 22:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgKJVEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 16:04:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:4063 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgKJVEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 16:04:51 -0500
IronPort-SDR: K9M1n061tWpfoDpcm4F5IErARtoFCKCFahGjROIpbzY69f4GsWX0ZuIeTYflvo3Lp6JM+2z8yV
 tBz/EZ1+NA3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="166541028"
X-IronPort-AV: E=Sophos;i="5.77,467,1596524400"; 
   d="scan'208";a="166541028"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 13:04:50 -0800
IronPort-SDR: O9CkldqJ2EaOgcj7/Dx90dcTA5MiSWx4prfzQPMS12XtA/pd/dbIwSoVPBvOVctWoIjsjzf0Q6
 LoXQxpNV/gSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,467,1596524400"; 
   d="scan'208";a="428523406"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga001.fm.intel.com with SMTP; 10 Nov 2020 13:04:48 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 10 Nov 2020 23:04:47 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915: Handle max_bpc==16
Date:   Tue, 10 Nov 2020 23:04:47 +0200
Message-Id: <20201110210447.27454-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

EDID can declare the maximum supported bpc up to 16,
and apparently there are displays that do so. Currently
we assume 12 bpc is tha max. Fix the assumption and
toss in a MISSING_CASE() for any other value we don't
expect to see.

This fixes modesets with a display with EDID max bpc > 12.
Previously any modeset would just silently fail on platforms
that didn't otherwise limit this via the max_bpc property.
In particular we don't add the max_bpc property to HDMI
ports on gmch platforms, and thus we would see the raw
max_bpc coming from the EDID.

I suppose we could already adjust this to also allow 16bpc,
but seeing as no current platform supports that there is
little point.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2632
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_display.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 2729c852c668..2a6eb1ca9c8e 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -13060,10 +13060,11 @@ compute_sink_pipe_bpp(const struct drm_connector_state *conn_state,
 	case 10 ... 11:
 		bpp = 10 * 3;
 		break;
-	case 12:
+	case 12 ... 16:
 		bpp = 12 * 3;
 		break;
 	default:
+		MISSING_CASE(conn_state->max_bpc);
 		return -EINVAL;
 	}
 
-- 
2.26.2

