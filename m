Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8824BB2A1
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 07:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiBRGlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 01:41:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiBRGlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 01:41:01 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B0F2D1EE
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 22:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645166445; x=1676702445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RxjBblgEix/nG+RaF5OEQSHMg1zo/6g55lP0mLfSpbk=;
  b=Me2UDFBTDlMA7bnmVHxRUB/N3N+8Kw/6ouNueDWS5+8TnoSj3LH2BfSe
   Tj/dxnPg72GtWaoX+98uYS71XuTjUYkr3C69HgM6MeggiD17/e5djohdr
   HUloP4EN2M2MU1sng3Azgt3wWVtwoR8+i4LnStVUps/81IJ34QkfHsTDV
   RMwkeOV2g29cpddVGOmX3pLwSuFagtlEzyGCjJZfV03hzlEV8f8JMKKb+
   Mfy/swnEW0Tnq80FK5ev9HjPAogpx+ULtwpCm2zcTAm9VKdU537bzWgR2
   E2b40CZTpihUitVb3WxLIkuvrtYIrZmMa+z4deHEe43XYJDfHKfatlHA5
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="234596110"
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="234596110"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 22:40:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="530798049"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga007.jf.intel.com with SMTP; 17 Feb 2022 22:40:42 -0800
Received: by stinkbox (sSMTP sendmail emulation); Fri, 18 Feb 2022 08:40:42 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Subject: [PATCH v3 1/6] drm/i915: Correctly populate use_sagv_wm for all pipes
Date:   Fri, 18 Feb 2022 08:40:34 +0200
Message-Id: <20220218064039.12834-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218064039.12834-1-ville.syrjala@linux.intel.com>
References: <20220218064039.12834-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index d4d487f040a1..d0fcc4586983 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4008,6 +4008,17 @@ static int intel_compute_sagv_mask(struct intel_atomic_state *state)
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
@@ -4023,17 +4034,6 @@ static int intel_compute_sagv_mask(struct intel_atomic_state *state)
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

