Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FFE6B3DF1
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjCJLfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjCJLfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:35:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC2810E27B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:35:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A0E613C5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE810C4339B;
        Fri, 10 Mar 2023 11:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448140;
        bh=FqtdI1y5xRQIB3i7KQNF2+cnQp3g+ey1HZ8Lro1rkJM=;
        h=Subject:To:Cc:From:Date:From;
        b=dZXPiCQ0Wb3xagqvbZAKIjmyCjH4WAIjOZz6R5TD6czF0jKsg2Csj5vabhDo9aJGW
         X3m5VkojKxvb/UIHl8/PpCw1hMWqpo6qD8oeIysC0gKbjLidyIdZh3ULuduMiWV/bu
         wgUcjujG0u6xMEqosN+wiO2j2crJG8jXAdEJJDB4=
Subject: FAILED: patch "[PATCH] drm/i915/dp_mst: Fix payload removal during output disabling" failed to apply to 6.1-stable tree
To:     imre.deak@intel.com, daniel@ffwll.ch, jani.nikula@intel.com,
        lyude@redhat.com, ville.syrjala@linux.intel.com, wayne.lin@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:35:37 +0100
Message-ID: <167844813723892@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
git cherry-pick -x eb50912ec931913e70640cecf75cb993fd26995f
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167844813723892@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

eb50912ec931 ("drm/i915/dp_mst: Fix payload removal during output disabling")
e761cc20946a ("drm/display/dp_mst: Handle old/new payload states in drm_dp_remove_payload()")
9b2d019144a0 ("drm/display/dp_mst: Correct the kref of port.")
8c7d980da9ba ("drm/nouveau/disp: move DP MST payload config method")
8bb30c882334 ("drm/nouveau/disp: add method to trigger DP link retrain")
016dacb60e6d ("drm/nouveau/kms: pass event mask to hpd handler")
d62f8e982cb8 ("drm/nouveau/kms: switch hpd_lock from mutex to spinlock")
a62b74939063 ("drm/nouveau/disp: add method to control DPAUX pad power")
813443721331 ("drm/nouveau/disp: move DP link config into acquire")
a9f5d7721923 ("drm/nouveau/disp: move HDA ELD method")
f530bc60a30b ("drm/nouveau/disp: move HDMI config into acquire + infoframe methods")
9793083f1dd9 ("drm/nouveau/disp: move LVDS protocol information into acquire")
ea6143a86c67 ("drm/nouveau/disp: move and extend the role of outp acquire/release methods")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eb50912ec931913e70640cecf75cb993fd26995f Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Mon, 6 Feb 2023 13:48:56 +0200
Subject: [PATCH] drm/i915/dp_mst: Fix payload removal during output disabling
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use the correct old/new topology and payload states in
intel_mst_disable_dp(). So far drm_atomic_get_mst_topology_state() it
used returned either the old state, in case the state was added already
earlier during the atomic check phase or otherwise the new state (but
the latter could fail, which can't be handled in the enable/disable
hooks). After the first patch in the patchset, the state should always
get added already during the check phase, so here we can get the
old/new states without a failure.

drm_dp_remove_payload() should use time_slots from the old payload state
and vc_start_slot in the new one. It should update the new payload
states to reflect the sink's current payload table after the payload is
removed. Pass the new topology state and the old and new payload states
accordingly.

This also fixes a problem where the payload allocations for multiple MST
streams on the same link got inconsistent after a few commits, as
during payload removal the old instead of the new payload state got
updated, so the subsequent enabling sequence and commits used a stale
payload state.

v2: Constify the old payload state pointer. (Ville)

Cc: Lyude Paul <lyude@redhat.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org # 6.1
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Acked-by: Lyude Paul <lyude@redhat.com>
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230206114856.2665066-4-imre.deak@intel.com

diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index dc4e5ff1dbb3..054a009e800d 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -524,10 +524,14 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
 	struct intel_dp *intel_dp = &dig_port->dp;
 	struct intel_connector *connector =
 		to_intel_connector(old_conn_state->connector);
-	struct drm_dp_mst_topology_state *mst_state =
-		drm_atomic_get_mst_topology_state(&state->base, &intel_dp->mst_mgr);
-	struct drm_dp_mst_atomic_payload *payload =
-		drm_atomic_get_mst_payload_state(mst_state, connector->port);
+	struct drm_dp_mst_topology_state *old_mst_state =
+		drm_atomic_get_old_mst_topology_state(&state->base, &intel_dp->mst_mgr);
+	struct drm_dp_mst_topology_state *new_mst_state =
+		drm_atomic_get_new_mst_topology_state(&state->base, &intel_dp->mst_mgr);
+	const struct drm_dp_mst_atomic_payload *old_payload =
+		drm_atomic_get_mst_payload_state(old_mst_state, connector->port);
+	struct drm_dp_mst_atomic_payload *new_payload =
+		drm_atomic_get_mst_payload_state(new_mst_state, connector->port);
 	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 
 	drm_dbg_kms(&i915->drm, "active links %d\n",
@@ -535,8 +539,8 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
 
 	intel_hdcp_disable(intel_mst->connector);
 
-	drm_dp_remove_payload(&intel_dp->mst_mgr, mst_state,
-			      payload, payload);
+	drm_dp_remove_payload(&intel_dp->mst_mgr, new_mst_state,
+			      old_payload, new_payload);
 
 	intel_audio_codec_disable(encoder, old_crtc_state, old_conn_state);
 }

