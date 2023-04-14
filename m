Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006EC6E1E58
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 10:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjDNIch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 04:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDNIcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 04:32:36 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5851B2719
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 01:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681461155; x=1712997155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cKDsouNK9k5k548Y7/ahdR7jLFjpd9Rvo/qhCLGcY6c=;
  b=gI65MIzWmEPGnzoEHktlkHBjTdUW+eUyTdstqv8fJ4LNVy6Z/RHuLLim
   Pu07BtyIHY/RMMcz94MeH5AShO3n41yq77jxR7E0z3tBXog/+4s8xe5oT
   qLEyixXqPZrPi92CWqoBujdyQarPObiYi0YzRONO7BKEd5RJcDZIXNire
   PqCoiyu7s5zqJK2N+QmbKQLSe3xJlBs6B8AmaW/PTuEQStj9S5MTscl1b
   7/ojggwhPL18bOGZTWwOyYf0DlavqcL3SCdnW2LucC6yvuNRv7C2Hfi3T
   DGzOaMWDtnO7VzWd0KKqb4ib9rN4cERqgT/gRUPcoD0qwsjYWVmU7Y9j+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="346245826"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="346245826"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 01:31:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="779110840"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="779110840"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.70])
  by FMSMGA003.fm.intel.com with SMTP; 14 Apr 2023 01:31:41 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 14 Apr 2023 11:31:40 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     Greg KH <greg@kroah.com>, Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>
Subject: [PATCH 6.1.y 1/2] drm/i915: Add a .color_post_update() hook
Date:   Fri, 14 Apr 2023 11:31:39 +0300
Message-Id: <20230414083140.24095-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <2023041254-wok-shine-8aaf@gregkh>
References: <2023041254-wok-shine-8aaf@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

We're going to need stuff after the color management
register latching has happened. Add a corresponding hook.

Cc: <stable@vger.kernel.org> #v5.19+
Cc: <stable@vger.kernel.org> # 52a90349f2ed: drm/i915: Introduce intel_crtc_needs_fastset()
Cc: <stable@vger.kernel.org> # 925ac8bc33bf: drm/i915: Remove some local 'mode_changed' bools
Cc: <stable@vger.kernel.org> # f5e674e92e95: drm/i915: Introduce intel_crtc_needs_color_update()
Cc: <stable@vger.kernel.org> # 4c35e5d11900: drm/i915: Activate DRRS after state readout
Cc: <stable@vger.kernel.org> # efb2b57edf20: drm/i915: Move the DSB setup/cleaup into the color code
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Drew Davenport <ddavenport@chromium.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-4-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit 3962ca4e080a525fc9eae87aa6b2286f1fae351d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit c880f855d1e240a956dcfce884269bad92fc849c)
---
Picked up one more dependency to ease the backport.

 drivers/gpu/drm/i915/display/intel_color.c   | 13 +++++++++++++
 drivers/gpu/drm/i915/display/intel_color.h   |  1 +
 drivers/gpu/drm/i915/display/intel_display.c |  3 +++
 3 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_color.c b/drivers/gpu/drm/i915/display/intel_color.c
index 537106c98220..caa87187ee45 100644
--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -47,6 +47,11 @@ struct intel_color_funcs {
 	 * registers involved with the same commit.
 	 */
 	void (*color_commit_arm)(const struct intel_crtc_state *crtc_state);
+	/*
+	 * Perform any extra tasks needed after all the
+	 * double buffered registers have been latched.
+	 */
+	void (*color_post_update)(const struct intel_crtc_state *crtc_state);
 	/*
 	 * Load LUTs (and other single buffered color management
 	 * registers). Will (hopefully) be called during the vblank
@@ -1205,6 +1210,14 @@ void intel_color_commit_arm(const struct intel_crtc_state *crtc_state)
 	dev_priv->display.funcs.color->color_commit_arm(crtc_state);
 }
 
+void intel_color_post_update(const struct intel_crtc_state *crtc_state)
+{
+	struct drm_i915_private *i915 = to_i915(crtc_state->uapi.crtc->dev);
+
+	if (i915->display.funcs.color->color_post_update)
+		i915->display.funcs.color->color_post_update(crtc_state);
+}
+
 void intel_color_prepare_commit(struct intel_crtc_state *crtc_state)
 {
 	intel_dsb_prepare(crtc_state);
diff --git a/drivers/gpu/drm/i915/display/intel_color.h b/drivers/gpu/drm/i915/display/intel_color.h
index 2fa6e40ebd22..5ebe040a6042 100644
--- a/drivers/gpu/drm/i915/display/intel_color.h
+++ b/drivers/gpu/drm/i915/display/intel_color.h
@@ -20,6 +20,7 @@ void intel_color_prepare_commit(struct intel_crtc_state *crtc_state);
 void intel_color_cleanup_commit(struct intel_crtc_state *crtc_state);
 void intel_color_commit_noarm(const struct intel_crtc_state *crtc_state);
 void intel_color_commit_arm(const struct intel_crtc_state *crtc_state);
+void intel_color_post_update(const struct intel_crtc_state *crtc_state);
 void intel_color_load_luts(const struct intel_crtc_state *crtc_state);
 void intel_color_get_config(struct intel_crtc_state *crtc_state);
 int intel_color_get_gamma_bit_precision(const struct intel_crtc_state *crtc_state);
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index bfaf17a219ff..067bb11c5ebe 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1251,6 +1251,9 @@ static void intel_post_plane_update(struct intel_atomic_state *state,
 	if (needs_cursorclk_wa(old_crtc_state) &&
 	    !needs_cursorclk_wa(new_crtc_state))
 		icl_wa_cursorclkgating(dev_priv, pipe, false);
+
+	if (intel_crtc_needs_color_update(new_crtc_state))
+		intel_color_post_update(new_crtc_state);
 }
 
 static void intel_crtc_enable_flip_done(struct intel_atomic_state *state,
-- 
2.39.2

