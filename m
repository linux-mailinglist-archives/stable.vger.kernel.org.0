Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB38D6D3F7E
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjDCIyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjDCIyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:54:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC90D1BE7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62098B815D1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA24C433D2;
        Mon,  3 Apr 2023 08:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680512081;
        bh=VS4xsGVhx3S46mu5dYeXfR9zx9SZh2URDXL6zue5cZo=;
        h=Subject:To:Cc:From:Date:From;
        b=NWPTknmKH1QbG+HSVpPrJ8C5n8kJcJW2DwYRrZqTgqIdgA9aVf2yHEEY8Efc7Ipte
         9dcdk7N80ehMOL/r14DcbVD8rYZfpVGikaDB1O8Skw87vqf6LYZP/8zGKI1E504hD2
         i8IwRrr6RZFAKfwzH3vJROFjcLnePUZ2UkutBwgw=
Subject: FAILED: patch "[PATCH] drm/i915: Add a .color_post_update() hook" failed to apply to 6.1-stable tree
To:     ville.syrjala@linux.intel.com, ddavenport@chromium.org,
        imre.deak@intel.com, jani.nikula@intel.com,
        jouni.hogander@intel.com, navaremanasi@google.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:54:30 +0200
Message-ID: <2023040330-seventeen-sappy-3f9a@gregkh>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x c880f855d1e240a956dcfce884269bad92fc849c
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040330-seventeen-sappy-3f9a@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

c880f855d1e2 ("drm/i915: Add a .color_post_update() hook")
efb2b57edf20 ("drm/i915: Move the DSB setup/cleaup into the color code")
f5e674e92e95 ("drm/i915: Introduce intel_crtc_needs_color_update()")
925ac8bc33bf ("drm/i915: Remove some local 'mode_changed' bools")
52a90349f2ed ("drm/i915: Introduce intel_crtc_needs_fastset()")
4c35e5d11900 ("drm/i915: Activate DRRS after state readout")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c880f855d1e240a956dcfce884269bad92fc849c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Mon, 20 Mar 2023 11:54:35 +0200
Subject: [PATCH] drm/i915: Add a .color_post_update() hook
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We're going to need stuff after the color management
register latching has happened. Add a corresponding hook.

Cc: <stable@vger.kernel.org> #v5.19+
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Drew Davenport <ddavenport@chromium.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-4-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit 3962ca4e080a525fc9eae87aa6b2286f1fae351d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_color.c b/drivers/gpu/drm/i915/display/intel_color.c
index aa702292779f..b1d0b49fe8ef 100644
--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -46,6 +46,11 @@ struct intel_color_funcs {
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
@@ -1411,6 +1416,14 @@ void intel_color_commit_arm(const struct intel_crtc_state *crtc_state)
 	i915->display.funcs.color->color_commit_arm(crtc_state);
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
 	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
diff --git a/drivers/gpu/drm/i915/display/intel_color.h b/drivers/gpu/drm/i915/display/intel_color.h
index d620b5b1e2a6..8002492be709 100644
--- a/drivers/gpu/drm/i915/display/intel_color.h
+++ b/drivers/gpu/drm/i915/display/intel_color.h
@@ -21,6 +21,7 @@ void intel_color_prepare_commit(struct intel_crtc_state *crtc_state);
 void intel_color_cleanup_commit(struct intel_crtc_state *crtc_state);
 void intel_color_commit_noarm(const struct intel_crtc_state *crtc_state);
 void intel_color_commit_arm(const struct intel_crtc_state *crtc_state);
+void intel_color_post_update(const struct intel_crtc_state *crtc_state);
 void intel_color_load_luts(const struct intel_crtc_state *crtc_state);
 void intel_color_get_config(struct intel_crtc_state *crtc_state);
 bool intel_color_lut_equal(const struct intel_crtc_state *crtc_state,
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 208b1b5b15dd..1a5ffa9642e8 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1209,6 +1209,9 @@ static void intel_post_plane_update(struct intel_atomic_state *state,
 	if (needs_cursorclk_wa(old_crtc_state) &&
 	    !needs_cursorclk_wa(new_crtc_state))
 		icl_wa_cursorclkgating(dev_priv, pipe, false);
+
+	if (intel_crtc_needs_color_update(new_crtc_state))
+		intel_color_post_update(new_crtc_state);
 }
 
 static void intel_crtc_enable_flip_done(struct intel_atomic_state *state,

