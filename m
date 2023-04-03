Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0230C6D3FAC
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 11:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjDCJDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 05:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjDCJDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 05:03:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F344AD29
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 02:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E5C9616E7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 09:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED90C433EF;
        Mon,  3 Apr 2023 09:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680512572;
        bh=h3wNe8/4WKisfQ0AjI8Oi7uvkw95yJRkONeYtzyptXk=;
        h=Subject:To:Cc:From:Date:From;
        b=tV5ad2HEenjV0Dlofny7U+datcdu3lnJ7Jgd/lC88HOBmOI9VZPsP2qay3GjSLE5K
         YepsCvJzYdS8jys1bo5pUX6phKBlo7PK0GSGvncj+UEVN6eOwOeS5c3ISgBrMB6Q8x
         Vv2NI78rA7mkqFG3nXCFgTgj7EVE1paX5lUFheA0=
Subject: FAILED: patch "[PATCH] drm/i915: Workaround ICL CSC_MODE sticky arming" failed to apply to 6.2-stable tree
To:     ville.syrjala@linux.intel.com, ddavenport@chromium.org,
        imre.deak@intel.com, jani.nikula@intel.com,
        jouni.hogander@intel.com, navaremanasi@google.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 11:02:50 +0200
Message-ID: <2023040350-surfer-virus-66bb@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 4d4e766f8b7dbdefa7a78e91eb9c7a29d0d818b8
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040350-surfer-virus-66bb@gregkh' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

4d4e766f8b7d ("drm/i915: Workaround ICL CSC_MODE sticky arming")
76b767d4d1cd ("drm/i915: Split icl_color_commit_noarm() from skl_color_commit_noarm()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4d4e766f8b7dbdefa7a78e91eb9c7a29d0d818b8 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Mon, 20 Mar 2023 11:54:36 +0200
Subject: [PATCH] drm/i915: Workaround ICL CSC_MODE sticky arming
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/i915/display/intel_color.c b/drivers/gpu/drm/i915/display/intel_color.c
index b1d0b49fe8ef..bd598a7f5047 100644
--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -619,6 +619,14 @@ static void ilk_lut_12p4_pack(struct drm_color_lut *entry, u32 ldw, u32 udw)
 
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
 
@@ -720,6 +728,28 @@ static void icl_color_commit_arm(const struct intel_crtc_state *crtc_state)
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
 static struct drm_property_blob *
 create_linear_lut(struct drm_i915_private *i915, int lut_size)
 {
@@ -3115,10 +3145,20 @@ static const struct intel_color_funcs i9xx_color_funcs = {
 	.lut_equal = i9xx_lut_equal,
 };
 
+static const struct intel_color_funcs tgl_color_funcs = {
+	.color_check = icl_color_check,
+	.color_commit_noarm = icl_color_commit_noarm,
+	.color_commit_arm = icl_color_commit_arm,
+	.load_luts = icl_load_luts,
+	.read_luts = icl_read_luts,
+	.lut_equal = icl_lut_equal,
+};
+
 static const struct intel_color_funcs icl_color_funcs = {
 	.color_check = icl_color_check,
 	.color_commit_noarm = icl_color_commit_noarm,
 	.color_commit_arm = icl_color_commit_arm,
+	.color_post_update = icl_color_post_update,
 	.load_luts = icl_load_luts,
 	.read_luts = icl_read_luts,
 	.lut_equal = icl_lut_equal,
@@ -3231,7 +3271,9 @@ void intel_color_init_hooks(struct drm_i915_private *i915)
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

