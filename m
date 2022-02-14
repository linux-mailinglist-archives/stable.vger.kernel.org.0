Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C39B4B4573
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242800AbiBNJS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:18:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242801AbiBNJS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:18:26 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A979606F9
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 01:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644830299; x=1676366299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vSGqAIXBHTVau+Z74ihcbhTbV8P9kps5GCRYhPrgstA=;
  b=iOJTIPK1XuVD7LAktsgdJCMq+vjQhPW2Kl+bX+rohNWc0Oc23nuiXkjj
   I25KA3cQCN8fajYb4Q4WlMxQoZiByrktxp+D3ZWwRhp/yydwJBSKWgFxg
   5eHlumwnEl6Mr7afxncY4pTnbWYgLa3XVjriVfyIIBk3Jjn5Cu5z2IYxl
   qpC0qrh+IcF2XZpotsiQuNwxlNr0WUFreftTxI7ZEL76otskxLxqWZ3Dv
   ijX970GauLRDBbgIkRo6Fx/+goxv7Or4lMHxE5b6/KnGMUbbCrPsPI78q
   8KDylAWCCEjvuqjaLPbgyKhzqL1nBAmRPiI4V4SRj7l2gjFt6GMN34bSs
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="248882360"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="248882360"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 01:18:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="570026660"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga001.jf.intel.com with SMTP; 14 Feb 2022 01:18:16 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 14 Feb 2022 11:18:15 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Subject: [PATCH 1/6] drm/i915: Correctly populate use_sagv_wm for all pipes
Date:   Mon, 14 Feb 2022 11:18:06 +0200
Message-Id: <20220214091811.13725-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214091811.13725-1-ville.syrjala@linux.intel.com>
References: <20220214091811.13725-1-ville.syrjala@linux.intel.com>
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
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: 7241c57d3140 ("drm/i915: Add TGL+ SAGV support")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 1179bf31f743..d8eb553ffad3 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4009,6 +4009,17 @@ static int intel_compute_sagv_mask(struct intel_atomic_state *state)
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
@@ -4024,17 +4035,6 @@ static int intel_compute_sagv_mask(struct intel_atomic_state *state)
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

