Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4931A6E1E59
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 10:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjDNIch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 04:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDNIcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 04:32:36 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4EA8F
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 01:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681461155; x=1712997155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cizAa6LeXSOpydsKGwGBUsyWeqdiD8KSNK9mjvq1cd0=;
  b=aMyzLUHt3RykY5heaj01LtNLDASO461zUK69M1dYIhJ4nmoHxu6pbQwR
   k++5Kek1xVwtCZdD8XKGzWOgVaNvZ/qe2VbNmPmwOMnq/Nl1G/zeAnhdP
   z8sfZyR6Dsma4dM9vjXrY6KNHKt1LcD5vMwX0u+U6NFksEpE8LcomyGYi
   eYAfZeeWn8os22yzVCST2SzqL5mYG8YctwuNRJ5UMmO6N+XbvEA01WDVL
   N9VZ79dNmvlIQuKbh1/qeqF6UuK1lh7KHucj1wyhZFRQdY9ally1F2Ceq
   J+kdL0Aoju+9UTOOV9VaDg+0CcfLmC+5FB29d5d7ibIrgfC496IKxXMsL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="346245852"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="346245852"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 01:31:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="779110862"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="779110862"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.70])
  by FMSMGA003.fm.intel.com with SMTP; 14 Apr 2023 01:31:45 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 14 Apr 2023 11:31:44 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     Greg KH <greg@kroah.com>, Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>
Subject: [PATCH 6.1.y 2/2] drm/i915: Workaround ICL CSC_MODE sticky arming
Date:   Fri, 14 Apr 2023 11:31:40 +0300
Message-Id: <20230414083140.24095-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414083140.24095-1-ville.syrjala@linux.intel.com>
References: <2023041254-wok-shine-8aaf@gregkh>
 <20230414083140.24095-1-ville.syrjala@linux.intel.com>
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
index caa87187ee45..ed60a294d7b3 100644
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
 
@@ -583,6 +591,28 @@ static void skl_color_commit_arm(const struct intel_crtc_state *crtc_state)
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
@@ -2222,10 +2252,19 @@ static const struct intel_color_funcs i9xx_color_funcs = {
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
@@ -2301,7 +2340,9 @@ void intel_color_init_hooks(struct drm_i915_private *i915)
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

