Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1BC4BB2A7
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 07:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiBRGlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 01:41:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiBRGlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 01:41:18 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCD557161
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 22:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645166463; x=1676702463;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SKb8u8AFC4xdRkpdlCya0x/FajE/QbHu+Jdi2/UHI0Q=;
  b=fgOBY395u8BLschNPq5hNx25cWXo9pedR41IOAma276G85cDH6bm3EDY
   crh+CGhL0LROlhq7vfjW9Hv7AGBbVa1qmNU6Qa8Q0q3r18OXXcuswXfOT
   MuMr75hl8hfrQ/QO/w8QOJ28LtKwQC8ShsP+L3/0m0WKmfDgcHNJtY89V
   CTvsYZvPPc358WF5kHZE0SADTSr7lz+VqtJZ2YokNc2IyA1gKDq08OxyX
   9rTP+7EXDMN93Hr+M8VgITck5UkVIIkRtY73U/7p8tpTLBssbb+6i6l6f
   CXSjUBkbxR1Li1eN7IQyvrpe/91sMTIhVP48ztBQ6+vxSevsW33vEWCcI
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="337509776"
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="337509776"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 22:40:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="504912664"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga006.jf.intel.com with SMTP; 17 Feb 2022 22:40:46 -0800
Received: by stinkbox (sSMTP sendmail emulation); Fri, 18 Feb 2022 08:40:45 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Subject: [PATCH v3 2/6] drm/i915: Fix bw atomic check when switching between SAGV vs. no SAGV
Date:   Fri, 18 Feb 2022 08:40:35 +0200
Message-Id: <20220218064039.12834-3-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218064039.12834-1-ville.syrjala@linux.intel.com>
References: <20220218064039.12834-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

If the only thing that is changing is SAGV vs. no SAGV but
the number of active planes and the total data rates end up
unchanged we currently bail out of intel_bw_atomic_check()
early and forget to actually compute the new WGV point
mask and thus won't actually enable/disable SAGV as requested.
This ends up poorly if we end up running with SAGV enabled
when we shouldn't. Usually ends up in underruns.

To fix this let's go through the QGV point mask computation
if either the data rates/number of planes, or the state
of SAGV is changing.

v2: Check more carefully if things are changing to avoid
    the extra calculations/debugs from introducing unwanted
    overhead

Cc: stable@vger.kernel.org
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com> #v1
Fixes: 20f505f22531 ("drm/i915: Restrict qgv points which don't have enough bandwidth.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_bw.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bw.c b/drivers/gpu/drm/i915/display/intel_bw.c
index 7bbe0dc5926b..1fd1d2182d8f 100644
--- a/drivers/gpu/drm/i915/display/intel_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_bw.c
@@ -830,6 +830,7 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 	unsigned int max_bw_point = 0, max_bw = 0;
 	unsigned int num_qgv_points = dev_priv->max_bw[0].num_qgv_points;
 	unsigned int num_psf_gv_points = dev_priv->max_bw[0].num_psf_gv_points;
+	bool changed = false;
 	u32 mask = 0;
 
 	/* FIXME earlier gens need some checks too */
@@ -873,6 +874,8 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 		new_bw_state->data_rate[crtc->pipe] = new_data_rate;
 		new_bw_state->num_active_planes[crtc->pipe] = new_active_planes;
 
+		changed = true;
+
 		drm_dbg_kms(&dev_priv->drm,
 			    "pipe %c data rate %u num active planes %u\n",
 			    pipe_name(crtc->pipe),
@@ -880,7 +883,19 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 			    new_bw_state->num_active_planes[crtc->pipe]);
 	}
 
-	if (!new_bw_state)
+	old_bw_state = intel_atomic_get_old_bw_state(state);
+	new_bw_state = intel_atomic_get_new_bw_state(state);
+
+	if (new_bw_state &&
+	    intel_can_enable_sagv(dev_priv, old_bw_state) !=
+	    intel_can_enable_sagv(dev_priv, new_bw_state))
+		changed = true;
+
+	/*
+	 * If none of our inputs (data rates, number of active
+	 * planes, SAGV yes/no) changed then nothing to do here.
+	 */
+	if (!changed)
 		return 0;
 
 	ret = intel_atomic_lock_global_state(&new_bw_state->base);
@@ -966,7 +981,6 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 	 */
 	new_bw_state->qgv_points_mask = ~allowed_points & mask;
 
-	old_bw_state = intel_atomic_get_old_bw_state(state);
 	/*
 	 * If the actual mask had changed we need to make sure that
 	 * the commits are serialized(in case this is a nomodeset, nonblocking)
-- 
2.34.1

