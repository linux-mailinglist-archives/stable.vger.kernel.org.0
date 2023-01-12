Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB59166793D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 16:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240071AbjALP3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 10:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240504AbjALP2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 10:28:49 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDFBF58
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 07:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673536910; x=1705072910;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b4Hw3YVwYprw7Fnppy3gXmqY88LXdWvxh7FxaoIEfD0=;
  b=bZEFz/SfcGYLx2AzGftuug/QzxFptjo24PY4S1I718nDw8SahImyuQ3p
   9/HdAymx4lHjP2ubdDDaTogApScwl5CKk3lSIekQYSNrn/geVOfRigVp8
   4BulxPYBjK1QxyloH6cGM7zgq/OB25ZkwfXfIBhGLfguwvm7AlIn3ZkRH
   j7g8TNfSi8L35gqCB1BZTdkT3mDhRY7lpRnjUHEXBqjI3n7feCV4qIQue
   U6DQsqpEBpzEu+o1Q9O3TjRpDc/yDH6KSd/fOTWAHTQjnc0/z011Uwvf0
   vjVffbzsAEYBnGVOAWojErDACvG29tp11B+EWBsCjPLCyBb4Xmny+rKI3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="409965661"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="409965661"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 07:21:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="688356212"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="688356212"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.55])
  by orsmga008.jf.intel.com with SMTP; 12 Jan 2023 07:21:46 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 12 Jan 2023 17:21:45 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        Drew Davenport <ddavenport@chromium.org>
Subject: [PATCH] drm/i915: Reject < 1x1 pixel plane source size
Date:   Thu, 12 Jan 2023 17:21:45 +0200
Message-Id: <20230112152145.1117-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.38.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

We don't have proper sub-pixel coordinate support (some platforms
simply can't do it, for others we've not implemented it). This
can cause us to treat a < 1 pixel source width/height as zero
which is not valid for the hardware, and can also cause a div
by zero in some cases.

Refuse < 1x1 plane source size to avoid these problems.

Cc: stable@vger.kernel.org
Cc: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Reported-by: Drew Davenport <ddavenport@chromium.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
The other option would be to clamp the source size to >=1x1 pixels,
but dunno if that has any real benefits.

 drivers/gpu/drm/i915/display/intel_atomic_plane.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_atomic_plane.c b/drivers/gpu/drm/i915/display/intel_atomic_plane.c
index 10e1fc9d0698..c6e43d684458 100644
--- a/drivers/gpu/drm/i915/display/intel_atomic_plane.c
+++ b/drivers/gpu/drm/i915/display/intel_atomic_plane.c
@@ -921,6 +921,21 @@ int intel_atomic_plane_check_clipping(struct intel_plane_state *plane_state,
 	 */
 	plane_state->uapi.visible = drm_rect_clip_scaled(src, dst, clip);
 
+	/*
+	 * Avoid zero source size when we later
+	 * discard the fractional coords.
+	 *
+	 * FIXME add proper sub-pixel coordinate handling
+	 * for platforms/planes that support it.
+	 */
+	if (plane_state->uapi.visible &&
+	    (drm_rect_width(src) < 0x10000 || drm_rect_height(src) < 0x10000)) {
+		drm_dbg_kms(&i915->drm, "Plane source must be at least 1x1 pixels\n");
+		drm_rect_debug_print("src: ", src, true);
+		drm_rect_debug_print("dst: ", dst, false);
+		return -EINVAL;
+	}
+
 	drm_rect_rotate_inv(src, fb->width << 16, fb->height << 16, rotation);
 
 	if (!can_position && plane_state->uapi.visible &&
-- 
2.38.2

