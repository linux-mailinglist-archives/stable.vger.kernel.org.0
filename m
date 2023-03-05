Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B3D6AAF36
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 11:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjCEK6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 05:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCEK6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 05:58:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C507CDC3
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 02:58:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C967EB80A37
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 10:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D743FC433D2;
        Sun,  5 Mar 2023 10:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678013895;
        bh=znR4GkzLxw9b18bjFctVE/58KWwmSl7WL9fNJbtIcxU=;
        h=Subject:To:Cc:From:Date:From;
        b=aoWNVnRnxI4Wioz1EahuTmw8oz0apHNc6lGfsXFfdGZ8lNfxnuB3vNoCVvRpCpEJj
         ZM2fR/3jnRGpV9ljUbc5TYn4egx6Is4sJbqVs0zrZsaOwpQkU3CJBzI85Ev01rGiwh
         2b7IyqtDw8guBd26IIEtoP86JjS6/k5OZmeglvWE=
Subject: FAILED: patch "[PATCH] drm/vc4: kms: Sort the CRTCs by output before assigning them" failed to apply to 6.2-stable tree
To:     maxime@cerno.tech, javierm@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Mar 2023 11:58:10 +0100
Message-ID: <167801389076111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
git cherry-pick -x e3479398bcf4f92c1ee513a277f5d3732a90e9f1
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167801389076111@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

e3479398bcf4 ("drm/vc4: kms: Sort the CRTCs by output before assigning them")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e3479398bcf4f92c1ee513a277f5d3732a90e9f1 Mon Sep 17 00:00:00 2001
From: Maxime Ripard <maxime@cerno.tech>
Date: Wed, 23 Nov 2022 16:25:52 +0100
Subject: [PATCH] drm/vc4: kms: Sort the CRTCs by output before assigning them

On the vc4 devices (and later), the blending is done by a single device
called the HVS. The HVS has three FIFO that can operate in parallel, and
route their output to 6 CRTCs and 7 encoders on the BCM2711.

Each of these CRTCs and encoders have some constraints on which FIFO
they can feed from, so we need some code to take all those constraints
into account and assign FIFOs to CRTCs.

The problem can be simplified by assigning those FIFOs to CRTCs by
ascending output index number. We had a comment mentioning it already,
but we were never actually enforcing it.

It was working still in most situations because the probe order is
roughly equivalent, except for the (optional, and fairly rarely used on
the Pi4) VEC which was last in the probe order sequence, but one of the
earliest device to assign.

This resulted in configurations that were rejected by our code but were
still valid with a different assignment.

We can fix this by making sure we assign CRTCs to FIFOs by ordering
them by ascending HVS output index.

Fixes: 87ebcd42fb7b ("drm/vc4: crtc: Assign output to channel automatically")
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20221123-rpi-kunit-tests-v1-10-051a0bb60a16@cerno.tech

diff --git a/drivers/gpu/drm/vc4/vc4_kms.c b/drivers/gpu/drm/vc4/vc4_kms.c
index f5a52c56891c..7282545c54a1 100644
--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/sort.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
@@ -776,6 +777,20 @@ static int vc4_hvs_channels_obj_init(struct vc4_dev *vc4)
 	return drmm_add_action_or_reset(&vc4->base, vc4_hvs_channels_obj_fini, NULL);
 }
 
+static int cmp_vc4_crtc_hvs_output(const void *a, const void *b)
+{
+	const struct vc4_crtc *crtc_a =
+		to_vc4_crtc(*(const struct drm_crtc **)a);
+	const struct vc4_crtc_data *data_a =
+		vc4_crtc_to_vc4_crtc_data(crtc_a);
+	const struct vc4_crtc *crtc_b =
+		to_vc4_crtc(*(const struct drm_crtc **)b);
+	const struct vc4_crtc_data *data_b =
+		vc4_crtc_to_vc4_crtc_data(crtc_b);
+
+	return data_a->hvs_output - data_b->hvs_output;
+}
+
 /*
  * The BCM2711 HVS has up to 7 outputs connected to the pixelvalves and
  * the TXP (and therefore all the CRTCs found on that platform).
@@ -810,10 +825,11 @@ static int vc4_pv_muxing_atomic_check(struct drm_device *dev,
 				      struct drm_atomic_state *state)
 {
 	struct vc4_hvs_state *hvs_new_state;
-	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
+	struct drm_crtc **sorted_crtcs;
 	struct drm_crtc *crtc;
 	unsigned int unassigned_channels = 0;
 	unsigned int i;
+	int ret;
 
 	hvs_new_state = vc4_hvs_get_global_state(state);
 	if (IS_ERR(hvs_new_state))
@@ -823,15 +839,59 @@ static int vc4_pv_muxing_atomic_check(struct drm_device *dev,
 		if (!hvs_new_state->fifo_state[i].in_use)
 			unassigned_channels |= BIT(i);
 
-	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
-		struct vc4_crtc_state *old_vc4_crtc_state =
-			to_vc4_crtc_state(old_crtc_state);
-		struct vc4_crtc_state *new_vc4_crtc_state =
-			to_vc4_crtc_state(new_crtc_state);
-		struct vc4_crtc *vc4_crtc = to_vc4_crtc(crtc);
+	/*
+	 * The problem we have to solve here is that we have up to 7
+	 * encoders, connected to up to 6 CRTCs.
+	 *
+	 * Those CRTCs, depending on the instance, can be routed to 1, 2
+	 * or 3 HVS FIFOs, and we need to set the muxing between FIFOs and
+	 * outputs in the HVS accordingly.
+	 *
+	 * It would be pretty hard to come up with an algorithm that
+	 * would generically solve this. However, the current routing
+	 * trees we support allow us to simplify a bit the problem.
+	 *
+	 * Indeed, with the current supported layouts, if we try to
+	 * assign in the ascending crtc index order the FIFOs, we can't
+	 * fall into the situation where an earlier CRTC that had
+	 * multiple routes is assigned one that was the only option for
+	 * a later CRTC.
+	 *
+	 * If the layout changes and doesn't give us that in the future,
+	 * we will need to have something smarter, but it works so far.
+	 */
+	sorted_crtcs = kmalloc_array(dev->num_crtcs, sizeof(*sorted_crtcs), GFP_KERNEL);
+	if (!sorted_crtcs)
+		return -ENOMEM;
+
+	i = 0;
+	drm_for_each_crtc(crtc, dev)
+		sorted_crtcs[i++] = crtc;
+
+	sort(sorted_crtcs, i, sizeof(*sorted_crtcs), cmp_vc4_crtc_hvs_output, NULL);
+
+	for (i = 0; i < dev->num_crtcs; i++) {
+		struct vc4_crtc_state *old_vc4_crtc_state, *new_vc4_crtc_state;
+		struct drm_crtc_state *old_crtc_state, *new_crtc_state;
+		struct vc4_crtc *vc4_crtc;
 		unsigned int matching_channels;
 		unsigned int channel;
 
+		crtc = sorted_crtcs[i];
+		if (!crtc)
+			continue;
+		vc4_crtc = to_vc4_crtc(crtc);
+
+		old_crtc_state = drm_atomic_get_old_crtc_state(state, crtc);
+		if (!old_crtc_state)
+			continue;
+		old_vc4_crtc_state = to_vc4_crtc_state(old_crtc_state);
+
+		new_crtc_state = drm_atomic_get_new_crtc_state(state, crtc);
+		if (!new_crtc_state)
+			continue;
+		new_vc4_crtc_state = to_vc4_crtc_state(new_crtc_state);
+
 		drm_dbg(dev, "%s: Trying to find a channel.\n", crtc->name);
 
 		/* Nothing to do here, let's skip it */
@@ -860,33 +920,11 @@ static int vc4_pv_muxing_atomic_check(struct drm_device *dev,
 			continue;
 		}
 
-		/*
-		 * The problem we have to solve here is that we have
-		 * up to 7 encoders, connected to up to 6 CRTCs.
-		 *
-		 * Those CRTCs, depending on the instance, can be
-		 * routed to 1, 2 or 3 HVS FIFOs, and we need to set
-		 * the change the muxing between FIFOs and outputs in
-		 * the HVS accordingly.
-		 *
-		 * It would be pretty hard to come up with an
-		 * algorithm that would generically solve
-		 * this. However, the current routing trees we support
-		 * allow us to simplify a bit the problem.
-		 *
-		 * Indeed, with the current supported layouts, if we
-		 * try to assign in the ascending crtc index order the
-		 * FIFOs, we can't fall into the situation where an
-		 * earlier CRTC that had multiple routes is assigned
-		 * one that was the only option for a later CRTC.
-		 *
-		 * If the layout changes and doesn't give us that in
-		 * the future, we will need to have something smarter,
-		 * but it works so far.
-		 */
 		matching_channels = unassigned_channels & vc4_crtc->data->hvs_available_channels;
-		if (!matching_channels)
-			return -EINVAL;
+		if (!matching_channels) {
+			ret = -EINVAL;
+			goto err_free_crtc_array;
+		}
 
 		channel = ffs(matching_channels) - 1;
 
@@ -896,7 +934,12 @@ static int vc4_pv_muxing_atomic_check(struct drm_device *dev,
 		hvs_new_state->fifo_state[channel].in_use = true;
 	}
 
+	kfree(sorted_crtcs);
 	return 0;
+
+err_free_crtc_array:
+	kfree(sorted_crtcs);
+	return ret;
 }
 
 static int

