Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5956D4D9A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 18:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjDCQ0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 12:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDCQ0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 12:26:38 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738C8171C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 09:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680539197; x=1712075197;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6eFiHv2P3WlTDK1VW/xqcvIPLidu8XNWSmZDw3RQG6k=;
  b=g/Z0mDKjlMyJlhZo2grK1foGJB/B0etQW9aH+XorBB4O0ElCHIcO6Sml
   ecp0q1Gw4AxhWJJvauSp1sMfFcocahOzajqDOFfP6YjNLEiIZ9tfY6yWX
   iuQAdnccrvQmpmwM7EKX1feO2p6+q7ckT4gQ9C4Q9MQ/w2k0+9Wyr6bZj
   nfSN0+kBr748hV4JXFjG8fEPStoK7Wb3+aaKi/RgGUim7S9jVR845iFMn
   ELTiBzAHtj3WsPdivZSEDxLi5wmlTrJ/YX/Y+X2yESR1OiPvfct6p7OLX
   47SFhSRvd776175JxRFRwA7L1xrnx3j/ldICeYZLkvyqgujyIYnowS2J0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="322343643"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="322343643"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 09:26:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="829623018"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="829623018"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.70])
  by fmsmga001.fm.intel.com with SMTP; 03 Apr 2023 09:26:19 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 03 Apr 2023 19:26:18 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>
Subject: [PATCH 6.1.y 1/3] drm/i915: Split icl_color_commit_noarm() from skl_color_commit_noarm()
Date:   Mon,  3 Apr 2023 19:26:16 +0300
Message-Id: <20230403162618.18469-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <2023040313-periscope-celery-403f@gregkh>
References: <2023040313-periscope-celery-403f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

We're going to want different behavior for skl/glk vs. icl
in .color_commit_noarm(), so split the hook into two. Arguably
we already had slightly different behaviour since
csc_enable/gamma_enable are never set on icl+, so the old
code was perhaps a bit confusing as well.

Cc: <stable@vger.kernel.org> #v5.19+
Cc: <stable@vger.kernel.org> # 05ca98523481: drm/i915: Use _MMIO_PIPE() for SKL_BOTTOM_COLOR
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Drew Davenport <ddavenport@chromium.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-2-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit f161eb01f50ab31f2084975b43bce54b7b671e17)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 76b767d4d1cd052e455cf18e06929e8b2b70101d)
---
 drivers/gpu/drm/i915/display/intel_color.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_color.c b/drivers/gpu/drm/i915/display/intel_color.c
index e3db80ad050c..61e2008c694c 100644
--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -559,6 +559,25 @@ static void skl_color_commit_arm(const struct intel_crtc_state *crtc_state)
 			  crtc_state->csc_mode);
 }
 
+static void icl_color_commit_arm(const struct intel_crtc_state *crtc_state)
+{
+	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
+	struct drm_i915_private *i915 = to_i915(crtc->base.dev);
+	enum pipe pipe = crtc->pipe;
+
+	/*
+	 * We don't (yet) allow userspace to control the pipe background color,
+	 * so force it to black.
+	 */
+	intel_de_write(i915, SKL_BOTTOM_COLOR(pipe), 0);
+
+	intel_de_write(i915, GAMMA_MODE(crtc->pipe),
+		       crtc_state->gamma_mode);
+
+	intel_de_write_fw(i915, PIPE_CSC_MODE(crtc->pipe),
+			  crtc_state->csc_mode);
+}
+
 static void i9xx_load_lut_8(struct intel_crtc *crtc,
 			    const struct drm_property_blob *blob)
 {
@@ -2164,7 +2183,7 @@ static const struct intel_color_funcs i9xx_color_funcs = {
 static const struct intel_color_funcs icl_color_funcs = {
 	.color_check = icl_color_check,
 	.color_commit_noarm = icl_color_commit_noarm,
-	.color_commit_arm = skl_color_commit_arm,
+	.color_commit_arm = icl_color_commit_arm,
 	.load_luts = icl_load_luts,
 	.read_luts = icl_read_luts,
 };
-- 
2.39.2

