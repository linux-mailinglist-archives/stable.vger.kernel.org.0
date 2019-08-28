Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14BA9FFA1
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 12:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfH1KVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 06:21:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:52539 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbfH1KVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 06:21:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 03:21:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="180524849"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga008.fm.intel.com with SMTP; 28 Aug 2019 03:21:00 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 28 Aug 2019 13:20:59 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Geoffrey Bennett <gmux22@gmail.com>
Subject: [PATCH] drm/i915: Limit MST to <= 8bpc once again
Date:   Wed, 28 Aug 2019 13:20:59 +0300
Message-Id: <20190828102059.2512-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

My attempt at allowing MST to use the higher color depths has
regressed some configurations. Apparently people have setups
where all MST streams will fit into the DP link with 8bpc but
won't fit with higher color depths.

What we really should be doing is reducing the bpc for all the
streams on the same link until they start to fit. But that requires
a bit more work, so in the meantime let's revert back closer to
the old behavior and limit MST to at most 8bpc.

Cc: stable@vger.kernel.org
Cc: Lyude Paul <lyude@redhat.com>
Cc: Geoffrey Bennett <gmux22@gmail.com>
Fixes: f1477219869c ("drm/i915: Remove the 8bpc shackles from DP MST")
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111505
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 2c5ac3dd647f..6df240a01b8c 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -128,7 +128,15 @@ static int intel_dp_mst_compute_config(struct intel_encoder *encoder,
 	limits.max_lane_count = intel_dp_max_lane_count(intel_dp);
 
 	limits.min_bpp = intel_dp_min_bpp(pipe_config);
-	limits.max_bpp = pipe_config->pipe_bpp;
+	/*
+	 * FIXME: If all the streams can't fit into the link with
+	 * their current pipe_bpp we should reduce pipe_bpp across
+	 * the board until things start to fit. Until then we
+	 * limit to <= 8bpc since that's what was hardcoded for all
+	 * MST streams previously. This hack should be removed once
+	 * we have the proper retry logic in place.
+	 */
+	limits.max_bpp = min(pipe_config->pipe_bpp, 24);
 
 	intel_dp_adjust_compliance_config(intel_dp, pipe_config, &limits);
 
-- 
2.21.0

