Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899B34B8F8C
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 18:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiBPRnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 12:43:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiBPRnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 12:43:12 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976C315C1AB
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 09:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645033379; x=1676569379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VYGCyd12BQzMGVyqbgMrgzm2BF3UhRG18MnduDdt6mE=;
  b=flKt2CBvPhrKteA0hyx75dLbYhElFj/lH+5uVPTjLxDOcfhP5U05+o0M
   bJ+TIkL2x50vsZq6DP1kll/9NGFZQ5YczVzBlSw8nQJEq79434n6jMzhv
   KeslBfLdfkvZMIf0CDMzB+U8LifmIGH/IOolPBMi01yZH11dBlShW+Q1r
   VxuG8SLCuEn+XRv6aRmrfrIam9gYNzg//PxBm5AA1smbRMqmyO5mg9JM6
   aWKPr4X8OSPAUSLwUvqIEM+036Or67lTwm5kRpdsDLI1LsfYldvznVVW0
   fxem1vQKfeTXijXzCoo1/AM8m9lwjpfS4I2JGE242S02lCkUmtubTeF7M
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="337122094"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="337122094"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 09:42:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="633789452"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by fmsmga002.fm.intel.com with SMTP; 16 Feb 2022 09:42:54 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 16 Feb 2022 19:42:54 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Subject: [PATCH v2 1/6] drm/i915: Correctly populate use_sagv_wm for all pipes
Date:   Wed, 16 Feb 2022 19:42:45 +0200
Message-Id: <20220216174250.4449-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216174250.4449-1-ville.syrjala@linux.intel.com>
References: <20220216174250.4449-1-ville.syrjala@linux.intel.com>
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

When changing between SAGV vs. no SAGV on tgl+ we have to
update the use_sagv_wm flag for all the crtcs or else
an active pipe not already in the state will end up using
the wrong watermarks. That is especially bad when we end up
with the tighter non-SAGV watermarks with SAGV enabled.
Usually ends up in underruns.

Cc: stable@vger.kernel.org
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: 7241c57d3140 ("drm/i915: Add TGL+ SAGV support")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 9f5e3c399f8d..bd32fd70e6b2 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4007,6 +4007,17 @@ static int intel_compute_sagv_mask(struct intel_atomic_state *state)
 			return ret;
 	}
 
+	if (intel_can_enable_sagv(dev_priv, new_bw_state) !=
+	    intel_can_enable_sagv(dev_priv, old_bw_state)) {
+		ret = intel_atomic_serialize_global_state(&new_bw_state->base);
+		if (ret)
+			return ret;
+	} else if (new_bw_state->pipe_sagv_reject != old_bw_state->pipe_sagv_reject) {
+		ret = intel_atomic_lock_global_state(&new_bw_state->base);
+		if (ret)
+			return ret;
+	}
+
 	for_each_new_intel_crtc_in_state(state, crtc,
 					 new_crtc_state, i) {
 		struct skl_pipe_wm *pipe_wm = &new_crtc_state->wm.skl.optimal;
@@ -4022,17 +4033,6 @@ static int intel_compute_sagv_mask(struct intel_atomic_state *state)
 			intel_can_enable_sagv(dev_priv, new_bw_state);
 	}
 
-	if (intel_can_enable_sagv(dev_priv, new_bw_state) !=
-	    intel_can_enable_sagv(dev_priv, old_bw_state)) {
-		ret = intel_atomic_serialize_global_state(&new_bw_state->base);
-		if (ret)
-			return ret;
-	} else if (new_bw_state->pipe_sagv_reject != old_bw_state->pipe_sagv_reject) {
-		ret = intel_atomic_lock_global_state(&new_bw_state->base);
-		if (ret)
-			return ret;
-	}
-
 	return 0;
 }
 
-- 
2.34.1

