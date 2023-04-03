Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5796D6D4AE5
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbjDCOvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbjDCOur (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944FE35032
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7DC661843
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEEDC433D2;
        Mon,  3 Apr 2023 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533412;
        bh=duG2v45e11lxeLkR+NFhv1VqCMvhwhJOv3fpi58oGJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCzKoeB9iei23fA4I61rtMRi1LrcTMZoQGth1jT+xLTfcHYwAM9mMl3Rxy846KFeH
         i/agBFdEq/WXxYbxzit4nPqIdjBeb9+jVzKeJBDiZD2nI1KEWSO89zRCXeeG70zBt7
         X51lNQGgxV1vOmFtfUZFhZ7ocU+6edQgbl/dfg6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.2 173/187] drm/i915: Disable DC states for all commits
Date:   Mon,  3 Apr 2023 16:10:18 +0200
Message-Id: <20230403140421.937079993@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit a2b6e99d8a623544f3bdccd28ee35b9c1b00daa5 upstream.

Keeping DC states enabled is incompatible with the _noarm()/_arm()
split we use for writing pipe/plane registers. When DC5 and PSR
are enabled, all pipe/plane registers effectively become self-arming
on account of DC5 exit arming the update, and PSR exit latching it.

What probably saves us most of the time is that (with PIPE_MISC[21]=0)
all pipe register writes themselves trigger PSR exit, and then
we don't re-enter PSR until the idle frame count has elapsed.
So it may be that the PSR exit happens already before we've
updated the state too much.

Also the PSR1 panel (at least on this KBL) seems to discard the first
frame we trasmit, presumably still scanning out from its internal
framebuffer at that point. So only the second frame we transmit is
actually visible. But I suppose that could also be panel specific
behaviour. I haven't checked out how other PSR panels behave, nor
did I bother to check what the eDP spec has to say about this.

And since this really is all about DC states, let's switch from
the MODESET domain to the DC_OFF domain. Functionally they are
100% identical. We should probably remove the MODESET domain...

And for good measure let's toss in an assert to the place where
we do the _noarm() register writes to make sure DC states are
in fact off.

v2: Just use intel_display_power_is_enabled() (Imre)

Cc: <stable@vger.kernel.org> #v5.17+
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Drew Davenport <ddavenport@chromium.org>
Cc: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Fixes: d13dde449580 ("drm/i915: Split pipe+output CSC programming to noarm+arm pair")
Fixes: f8a005eb8972 ("drm/i915: Optimize icl+ universal plane programming")
Fixes: 890b6ec4a522 ("drm/i915: Split skl+ plane update into noarm+arm pair")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320183532.17727-1-ville.syrjala@linux.intel.com
(cherry picked from commit 41b4c7fe72b6105a4b49395eea9aa40cef94288d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |   28 ++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -7107,6 +7107,8 @@ static void intel_update_crtc(struct int
 
 	intel_fbc_update(state, crtc);
 
+	drm_WARN_ON(&i915->drm, !intel_display_power_is_enabled(i915, POWER_DOMAIN_DC_OFF));
+
 	if (!modeset &&
 	    intel_crtc_needs_color_update(new_crtc_state))
 		intel_color_commit_noarm(new_crtc_state);
@@ -7480,8 +7482,28 @@ static void intel_atomic_commit_tail(str
 	drm_atomic_helper_wait_for_dependencies(&state->base);
 	drm_dp_mst_atomic_wait_for_dependencies(&state->base);
 
-	if (state->modeset)
-		wakeref = intel_display_power_get(dev_priv, POWER_DOMAIN_MODESET);
+	/*
+	 * During full modesets we write a lot of registers, wait
+	 * for PLLs, etc. Doing that while DC states are enabled
+	 * is not a good idea.
+	 *
+	 * During fastsets and other updates we also need to
+	 * disable DC states due to the following scenario:
+	 * 1. DC5 exit and PSR exit happen
+	 * 2. Some or all _noarm() registers are written
+	 * 3. Due to some long delay PSR is re-entered
+	 * 4. DC5 entry -> DMC saves the already written new
+	 *    _noarm() registers and the old not yet written
+	 *    _arm() registers
+	 * 5. DC5 exit -> DMC restores a mixture of old and
+	 *    new register values and arms the update
+	 * 6. PSR exit -> hardware latches a mixture of old and
+	 *    new register values -> corrupted frame, or worse
+	 * 7. New _arm() registers are finally written
+	 * 8. Hardware finally latches a complete set of new
+	 *    register values, and subsequent frames will be OK again
+	 */
+	wakeref = intel_display_power_get(dev_priv, POWER_DOMAIN_DC_OFF);
 
 	intel_atomic_prepare_plane_clear_colors(state);
 
@@ -7625,8 +7647,8 @@ static void intel_atomic_commit_tail(str
 		 * the culprit.
 		 */
 		intel_uncore_arm_unclaimed_mmio_detection(&dev_priv->uncore);
-		intel_display_power_put(dev_priv, POWER_DOMAIN_MODESET, wakeref);
 	}
+	intel_display_power_put(dev_priv, POWER_DOMAIN_DC_OFF, wakeref);
 	intel_runtime_pm_put(&dev_priv->runtime_pm, state->wakeref);
 
 	/*


