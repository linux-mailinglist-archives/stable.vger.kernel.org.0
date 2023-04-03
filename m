Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58DA6D4D9B
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 18:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjDCQ0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 12:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDCQ0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 12:26:40 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5DC170C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 09:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680539198; x=1712075198;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yJzHkVGbi01WYrgRlZ8c+xEhFla0nLeQOOSEuOEST7I=;
  b=lMCRD9cln8Rtl2t3XeBlf1z+DhYNZaQ6vAEsCr7gTiv+sGMizZopekum
   hp2S0k1l1ThndafSvJggL7v7oGYwxCXCLarlPoxrtd+7Z/e+oVVBR6Q0W
   +uiSuVql1z8ji2dEFuAp7ezUpr0sbMZAI/Cq7SGIND3efrs4ePN+QEDsN
   vsSXjgQ+Dpr8sF3oH1sXhokBf4zNnqkHw3F25awr0mt/S9mnwQFaFTltJ
   Vbkls2SV6gwwmJGNTjIoDeCviq4/ZPkN/zXAWGmk8ZnI1A4KL3MK4lLSm
   2t4p2iosO/x+KgKrxC2ZnCoLSySPJmFiiBWh9pSCA4ONotF5CgVT6jPFv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="322343668"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="322343668"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 09:26:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="829623026"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="829623026"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.70])
  by fmsmga001.fm.intel.com with SMTP; 03 Apr 2023 09:26:22 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 03 Apr 2023 19:26:22 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>
Subject: [PATCH 6.1.y 2/3] drm/i915: Add a .color_post_update() hook
Date:   Mon,  3 Apr 2023 19:26:17 +0300
Message-Id: <20230403162618.18469-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403162618.18469-1-ville.syrjala@linux.intel.com>
References: <2023040313-periscope-celery-403f@gregkh>
 <20230403162618.18469-1-ville.syrjala@linux.intel.com>
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

We're going to need stuff after the color management
register latching has happened. Add a corresponding hook.

Cc: <stable@vger.kernel.org> #v5.19+
Cc: <stable@vger.kernel.org> # 52a90349f2ed: drm/i915: Introduce intel_crtc_needs_fastset()
Cc: <stable@vger.kernel.org> # 925ac8bc33bf: drm/i915: Remove some local 'mode_changed' bools
Cc: <stable@vger.kernel.org> # f5e674e92e95: drm/i915: Introduce intel_crtc_needs_color_update()
Cc: <stable@vger.kernel.org> # 4c35e5d11900: drm/i915: Activate DRRS after state readout
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
 drivers/gpu/drm/i915/display/intel_color.c   | 13 +++++++++++++
 drivers/gpu/drm/i915/display/intel_color.h   |  1 +
 drivers/gpu/drm/i915/display/intel_display.c |  3 +++
 3 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_color.c b/drivers/gpu/drm/i915/display/intel_color.c
index 61e2008c694c..41bf3ab7264a 100644
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
 static bool intel_can_preload_luts(const struct intel_crtc_state *new_crtc_state)
 {
 	struct intel_crtc *crtc = to_intel_crtc(new_crtc_state->uapi.crtc);
diff --git a/drivers/gpu/drm/i915/display/intel_color.h b/drivers/gpu/drm/i915/display/intel_color.h
index 67702451e2fd..1ac4bf7e83bf 100644
--- a/drivers/gpu/drm/i915/display/intel_color.h
+++ b/drivers/gpu/drm/i915/display/intel_color.h
@@ -18,6 +18,7 @@ void intel_crtc_color_init(struct intel_crtc *crtc);
 int intel_color_check(struct intel_crtc_state *crtc_state);
 void intel_color_commit_noarm(const struct intel_crtc_state *crtc_state);
 void intel_color_commit_arm(const struct intel_crtc_state *crtc_state);
+void intel_color_post_update(const struct intel_crtc_state *crtc_state);
 void intel_color_load_luts(const struct intel_crtc_state *crtc_state);
 void intel_color_get_config(struct intel_crtc_state *crtc_state);
 int intel_color_get_gamma_bit_precision(const struct intel_crtc_state *crtc_state);
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 227e3ffbde47..df566866d038 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1252,6 +1252,9 @@ static void intel_post_plane_update(struct intel_atomic_state *state,
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

