Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F07F1C65
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 18:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfKFRXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 12:23:53 -0500
Received: from mga03.intel.com ([134.134.136.65]:54990 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729511AbfKFRXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 12:23:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 09:23:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="228362733"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with SMTP; 06 Nov 2019 09:23:50 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 06 Nov 2019 19:23:49 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>
Subject: [PATCH] drm/i915: Don't oops in dumb_create ioctl if we have no crtcs
Date:   Wed,  6 Nov 2019 19:23:49 +0200
Message-Id: <20191106172349.11987-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Make sure we have a crtc before probing its primary plane's
max stride. Initially I thought we can't get this far without
crtcs, but looks like we can via the dumb_create ioctl.

Not sure if we shouldn't disable dumb buffer support entirely
when we have no crtcs, but that would require some amount of work
as the only thing currently being checked is dev->driver->dumb_create
which we'd have to convert to some device specific dynamic thing.

Cc: stable@vger.kernel.org
Reported-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Fixes: aa5ca8b7421c ("drm/i915: Align dumb buffer stride to 4k to allow for gtt remapping")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 1f93860fb897..331030765ca9 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -2543,6 +2543,9 @@ u32 intel_plane_fb_max_stride(struct drm_i915_private *dev_priv,
 	 * the highest stride limits of them all.
 	 */
 	crtc = intel_get_crtc_for_pipe(dev_priv, PIPE_A);
+	if (!crtc)
+		return 0;
+
 	plane = to_intel_plane(crtc->base.primary);
 
 	return plane->max_stride(plane, pixel_format, modifier,
-- 
2.23.0

