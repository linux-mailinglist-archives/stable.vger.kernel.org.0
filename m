Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6B14C43EF
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 12:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbiBYLvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 06:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240279AbiBYLvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 06:51:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31444225034
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 03:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C22D3619F1
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 11:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE3AC340E7;
        Fri, 25 Feb 2022 11:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645789845;
        bh=6QaLbdcJliTq5/fgDOxl2Chzvy5aL8kTTwl1A3izw4s=;
        h=Subject:To:Cc:From:Date:From;
        b=aV/zvTAiQl8Q6Irw0TXG1lUh0n6ODBWDeL2C/1ybOVYoQVEccMGx1oipLhgSJXkGY
         HYNuhNhuGu/8KRYtw5q/2Msp0Sz5WxDf6DLQS6skRS7dOznNj3aQViFlZaLFj6JM25
         PQFNlxIvT76zEVijOcmLJ6KE/vgOGj25kf1S41UY=
Subject: FAILED: patch "[PATCH] drm/i915: Fix bw atomic check when switching between SAGV vs." failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, stanislav.lisovskiy@intel.com,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 12:50:42 +0100
Message-ID: <1645789842242144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ec663bca9128f13eada25cd0446e7fcb5fcdc088 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Fri, 18 Feb 2022 08:40:35 +0200
Subject: [PATCH] drm/i915: Fix bw atomic check when switching between SAGV vs.
 no SAGV
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If the only thing that is changing is SAGV vs. no SAGV but
the number of active planes and the total data rates end up
unchanged we currently bail out of intel_bw_atomic_check()
early and forget to actually compute the new WGV point
mask and thus won't actually enable/disable SAGV as requested.
This ends up poorly if we end up running with SAGV enabled
when we shouldn't. Usually ends up in underruns.

To fix this let's go through the QGV point mask computation
if either the data rates/number of planes, or the state
of SAGV is changing.

v2: Check more carefully if things are changing to avoid
    the extra calculations/debugs from introducing unwanted
    overhead

Cc: stable@vger.kernel.org
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com> #v1
Fixes: 20f505f22531 ("drm/i915: Restrict qgv points which don't have enough bandwidth.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220218064039.12834-3-ville.syrjala@linux.intel.com
(cherry picked from commit 6b728595ffa51c087343c716bccbfc260f120e72)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_bw.c b/drivers/gpu/drm/i915/display/intel_bw.c
index 2da4aacc956b..8ac196e814d5 100644
--- a/drivers/gpu/drm/i915/display/intel_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_bw.c
@@ -825,6 +825,7 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 	unsigned int max_bw_point = 0, max_bw = 0;
 	unsigned int num_qgv_points = dev_priv->max_bw[0].num_qgv_points;
 	unsigned int num_psf_gv_points = dev_priv->max_bw[0].num_psf_gv_points;
+	bool changed = false;
 	u32 mask = 0;
 
 	/* FIXME earlier gens need some checks too */
@@ -868,6 +869,8 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 		new_bw_state->data_rate[crtc->pipe] = new_data_rate;
 		new_bw_state->num_active_planes[crtc->pipe] = new_active_planes;
 
+		changed = true;
+
 		drm_dbg_kms(&dev_priv->drm,
 			    "pipe %c data rate %u num active planes %u\n",
 			    pipe_name(crtc->pipe),
@@ -875,7 +878,19 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 			    new_bw_state->num_active_planes[crtc->pipe]);
 	}
 
-	if (!new_bw_state)
+	old_bw_state = intel_atomic_get_old_bw_state(state);
+	new_bw_state = intel_atomic_get_new_bw_state(state);
+
+	if (new_bw_state &&
+	    intel_can_enable_sagv(dev_priv, old_bw_state) !=
+	    intel_can_enable_sagv(dev_priv, new_bw_state))
+		changed = true;
+
+	/*
+	 * If none of our inputs (data rates, number of active
+	 * planes, SAGV yes/no) changed then nothing to do here.
+	 */
+	if (!changed)
 		return 0;
 
 	ret = intel_atomic_lock_global_state(&new_bw_state->base);
@@ -961,7 +976,6 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 	 */
 	new_bw_state->qgv_points_mask = ~allowed_points & mask;
 
-	old_bw_state = intel_atomic_get_old_bw_state(state);
 	/*
 	 * If the actual mask had changed we need to make sure that
 	 * the commits are serialized(in case this is a nomodeset, nonblocking)

