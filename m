Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C596E6B83
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 19:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjDRR4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 13:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjDRR4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 13:56:00 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6356198E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 10:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681840557; x=1713376557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jcoNkbXmxLmrUtfWFmVA8DeXbqh1QEP3x+TSptatjgg=;
  b=n52VITvJ1N5WpfO5yKeekTaSKCm3BJ2Uq5g3K5MUCPVUhpHO2h4nLWp0
   XE0DclUqIQmxein1RGHfBEjdOzwXSZacs3DypHsFkWKvQJ8ouA3WUiCX2
   rWUtOePKkVEpr9habuSty8QlcTb7REa/m670/m7O1yrWy1nX6weDm5zm2
   stNmPPpfjviObXZGjSABmJZuaB4XPMmCUCjPPonx26eROLhwQp5ybAtK4
   5s0BWJTxyImgHowxc3slpjzjyOwM6XKmGwH42s1JIcvOku24lXWRW+QRB
   wnWYcVPQWudrWnchXf5hLKmsqypWvHr1GIfjjdAxyvFYScdR5SIZMVoQo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="334052748"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="334052748"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:55:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="641451575"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="641451575"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.70])
  by orsmga003.jf.intel.com with SMTP; 18 Apr 2023 10:55:31 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 18 Apr 2023 20:55:31 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>
Subject: [PATCH 01/15] drm/i915: Check pipe source size when using skl+ scalers
Date:   Tue, 18 Apr 2023 20:55:14 +0300
Message-Id: <20230418175528.13117-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230418175528.13117-1-ville.syrjala@linux.intel.com>
References: <20230418175528.13117-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The skl+ scalers only sample 12 bits of PIPESRC so we can't
do any plane scaling at all when the pipe source size is >4k.

Make sure the pipe source size is also below the scaler's src
size limits. Might not be 100% accurate, but should at least be
safe. We can refine the limits later if we discover that recent
hw is less restricted.

Cc: stable@vger.kernel.org
Tested-by: Ross Zwisler <zwisler@google.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8357
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/skl_scaler.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/skl_scaler.c b/drivers/gpu/drm/i915/display/skl_scaler.c
index 473d53610b92..0e7e014fcc71 100644
--- a/drivers/gpu/drm/i915/display/skl_scaler.c
+++ b/drivers/gpu/drm/i915/display/skl_scaler.c
@@ -111,6 +111,8 @@ skl_update_scaler(struct intel_crtc_state *crtc_state, bool force_detach,
 	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
 	const struct drm_display_mode *adjusted_mode =
 		&crtc_state->hw.adjusted_mode;
+	int pipe_src_w = drm_rect_width(&crtc_state->pipe_src);
+	int pipe_src_h = drm_rect_height(&crtc_state->pipe_src);
 	int min_src_w, min_src_h, min_dst_w, min_dst_h;
 	int max_src_w, max_src_h, max_dst_w, max_dst_h;
 
@@ -207,6 +209,21 @@ skl_update_scaler(struct intel_crtc_state *crtc_state, bool force_detach,
 		return -EINVAL;
 	}
 
+	/*
+	 * The pipe scaler does not use all the bits of PIPESRC, at least
+	 * on the earlier platforms. So even when we're scaling a plane
+	 * the *pipe* source size must not be too large. For simplicity
+	 * we assume the limits match the scaler source size limits. Might
+	 * not be 100% accurate on all platforms, but good enough for now.
+	 */
+	if (pipe_src_w > max_src_w || pipe_src_h > max_src_h) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "scaler_user index %u.%u: pipe src size %ux%u "
+			    "is out of scaler range\n",
+			    crtc->pipe, scaler_user, pipe_src_w, pipe_src_h);
+		return -EINVAL;
+	}
+
 	/* mark this plane as a scaler user in crtc_state */
 	scaler_state->scaler_users |= (1 << scaler_user);
 	drm_dbg_kms(&dev_priv->drm, "scaler_user index %u.%u: "
-- 
2.39.2

