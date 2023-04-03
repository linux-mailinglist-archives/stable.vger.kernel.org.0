Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E046D4D9C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 18:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjDCQ0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 12:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDCQ0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 12:26:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6216170C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 09:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680539200; x=1712075200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=viHd5cOskMwnGsybhx5bL/q7g3IZrvAfSaSU0Td8zjI=;
  b=BQAXGMCkh9KGUkMViKZavyRGK8vshwX1eMPWWpf6WOp3DIeWB/Cws44r
   yDwjJPJwQ/AzDpjz1FyEgbAZ1lEL7eK0vyUQYmTlAqOz0olk3GHBoNaSE
   0nVKbeKEZZVnjCLbz+ZGQavGzKqNTaI7DggxO8t2ASJsO15RXOm9LbISN
   xL1j9/EPjIS54R8WhlVOjF5i5+zKrEJiNmoSR6DVtqAgx8S3xeO2jGCJZ
   fRPJ+vKaQ08gJ6RYxuC2NBXoQFzXv0BOM9WcResM5ak6nG9F5h0p8LlHe
   Z3BpizFC9DEmoasUR+vYsd+4eLCVCA0lW/xid0GrTm5trRpcFCQO1gSEv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="322343689"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="322343689"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 09:26:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="829623033"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="829623033"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.70])
  by fmsmga001.fm.intel.com with SMTP; 03 Apr 2023 09:26:26 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 03 Apr 2023 19:26:25 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>
Subject: [PATCH 6.1.y 3/3] drm/i915: Workaround ICL CSC_MODE sticky arming
Date:   Mon,  3 Apr 2023 19:26:18 +0300
Message-Id: <20230403162618.18469-3-ville.syrjala@linux.intel.com>
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

Unlike SKL/GLK the ICL CSC unit suffers from a new issue where
CSC_MODE arming is sticky. That is, once armed it remains armed
causing the CSC coeff/offset registers to become effectively
self-arming.

CSC coeff/offset registers writes no longer disarm the CSC,
but fortunately register read still do. So we can use that
to disarm the CSC unit once the registers for the current
frame have been latched. This avoid s the self-arming behaviour
from persisting into the next frame's .color_commit_noarm()
call.

Cc: <stable@vger.kernel.org> #v5.19+
Cc: <stable@vger.kernel.org> # 064751a6c5dc: drm/i915: Split up intel_color_init()
Cc: <stable@vger.kernel.org> # 1bd3a1e5b1f7: drm/i915: Simplify the intel_color_init_hooks() if ladder
Cc: <stable@vger.kernel.org> # 7671fc626526: drm/i915: Clean up intel_color_init_hooks()
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Drew Davenport <ddavenport@chromium.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Fixes: d13dde449580 ("drm/i915: Split pipe+output CSC programming to noarm+arm pair")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-5-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit 92736f1b452bbb8a66bdb5b1d263ad00e04dd3b8)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 4d4e766f8b7dbdefa7a78e91eb9c7a29d0d818b8)
---
 drivers/gpu/drm/i915/display/intel_color.c | 43 +++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_color.c b/drivers/gpu/drm/i915/display/intel_color.c
index 41bf3ab7264a..f1d50ead6d6a 100644
--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -501,6 +501,14 @@ static void icl_lut_multi_seg_pack(struct drm_color_lut *entry, u32 ldw, u32 udw
 
 static void icl_color_commit_noarm(const struct intel_crtc_state *crtc_state)
 {
+	/*
+	 * Despite Wa_1406463849, ICL no longer suffers from the SKL
+	 * DC5/PSR CSC black screen issue (see skl_color_commit_noarm()).
+	 * Possibly due to the extra sticky CSC arming
+	 * (see icl_color_post_update()).
+	 *
+	 * On TGL+ all CSC arming issues have been properly fixed.
+	 */
 	icl_load_csc_matrix(crtc_state);
 }
 
@@ -583,6 +591,28 @@ static void icl_color_commit_arm(const struct intel_crtc_state *crtc_state)
 			  crtc_state->csc_mode);
 }
 
+static void icl_color_post_update(const struct intel_crtc_state *crtc_state)
+{
+	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
+	struct drm_i915_private *i915 = to_i915(crtc->base.dev);
+
+	/*
+	 * Despite Wa_1406463849, ICL CSC is no longer disarmed by
+	 * coeff/offset register *writes*. Instead, once CSC_MODE
+	 * is armed it stays armed, even after it has been latched.
+	 * Afterwards the coeff/offset registers become effectively
+	 * self-arming. That self-arming must be disabled before the
+	 * next icl_color_commit_noarm() tries to write the next set
+	 * of coeff/offset registers. Fortunately register *reads*
+	 * do still disarm the CSC. Naturally this must not be done
+	 * until the previously written CSC registers have actually
+	 * been latched.
+	 *
+	 * TGL+ no longer need this workaround.
+	 */
+	intel_de_read_fw(i915, PIPE_CSC_PREOFF_HI(crtc->pipe));
+}
+
 static void i9xx_load_lut_8(struct intel_crtc *crtc,
 			    const struct drm_property_blob *blob)
 {
@@ -2193,10 +2223,19 @@ static const struct intel_color_funcs i9xx_color_funcs = {
 	.read_luts = i9xx_read_luts,
 };
 
+static const struct intel_color_funcs tgl_color_funcs = {
+	.color_check = icl_color_check,
+	.color_commit_noarm = icl_color_commit_noarm,
+	.color_commit_arm = icl_color_commit_arm,
+	.load_luts = icl_load_luts,
+	.read_luts = icl_read_luts,
+};
+
 static const struct intel_color_funcs icl_color_funcs = {
 	.color_check = icl_color_check,
 	.color_commit_noarm = icl_color_commit_noarm,
 	.color_commit_arm = icl_color_commit_arm,
+	.color_post_update = icl_color_post_update,
 	.load_luts = icl_load_luts,
 	.read_luts = icl_read_luts,
 };
@@ -2272,7 +2311,9 @@ void intel_color_init_hooks(struct drm_i915_private *i915)
 		else
 			i915->display.funcs.color = &i9xx_color_funcs;
 	} else {
-		if (DISPLAY_VER(i915) >= 11)
+		if (DISPLAY_VER(i915) >= 12)
+			i915->display.funcs.color = &tgl_color_funcs;
+		else if (DISPLAY_VER(i915) == 11)
 			i915->display.funcs.color = &icl_color_funcs;
 		else if (DISPLAY_VER(i915) == 10)
 			i915->display.funcs.color = &glk_color_funcs;
-- 
2.39.2

