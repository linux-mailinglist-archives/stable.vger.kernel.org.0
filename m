Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80444C74B0
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238681AbiB1RqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239751AbiB1Rod (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AAC8AE7D;
        Mon, 28 Feb 2022 09:37:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E51161375;
        Mon, 28 Feb 2022 17:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26952C340E7;
        Mon, 28 Feb 2022 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069817;
        bh=TCc4XpVKrrwrvqe8z+8VZ37YD+Mdl9sfJq6e6QUpPwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soamDaBfW4AqrXC0VzP2nRKx8gNjudqRmnVT1uU8L1JuOKXUUhRaWEp/AdefDLQpQ
         SQCu46YsL/ctEMlRftw1Au2w/mj6h5Z+wBzrip8S5cDdO152XNoBNsNZ75qBS7JTWk
         rSykBUz4ziC9+MpTCoLP1q6aKq3Pat4PtgNoJkxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Subject: [PATCH 5.15 023/139] drm/i915: Fix bw atomic check when switching between SAGV vs. no SAGV
Date:   Mon, 28 Feb 2022 18:23:17 +0100
Message-Id: <20220228172350.246639515@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit ec663bca9128f13eada25cd0446e7fcb5fcdc088 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bw.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_bw.c
@@ -681,6 +681,7 @@ int intel_bw_atomic_check(struct intel_a
 	unsigned int max_bw_point = 0, max_bw = 0;
 	unsigned int num_qgv_points = dev_priv->max_bw[0].num_qgv_points;
 	unsigned int num_psf_gv_points = dev_priv->max_bw[0].num_psf_gv_points;
+	bool changed = false;
 	u32 mask = 0;
 
 	/* FIXME earlier gens need some checks too */
@@ -724,6 +725,8 @@ int intel_bw_atomic_check(struct intel_a
 		new_bw_state->data_rate[crtc->pipe] = new_data_rate;
 		new_bw_state->num_active_planes[crtc->pipe] = new_active_planes;
 
+		changed = true;
+
 		drm_dbg_kms(&dev_priv->drm,
 			    "pipe %c data rate %u num active planes %u\n",
 			    pipe_name(crtc->pipe),
@@ -731,7 +734,19 @@ int intel_bw_atomic_check(struct intel_a
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
@@ -814,7 +829,6 @@ int intel_bw_atomic_check(struct intel_a
 	 */
 	new_bw_state->qgv_points_mask = ~allowed_points & mask;
 
-	old_bw_state = intel_atomic_get_old_bw_state(state);
 	/*
 	 * If the actual mask had changed we need to make sure that
 	 * the commits are serialized(in case this is a nomodeset, nonblocking)


