Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD056B3DED
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjCJLfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjCJLfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:35:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A343512CE1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:35:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E7466137B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3032BC433EF;
        Fri, 10 Mar 2023 11:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448128;
        bh=DgX5VP3d4Ui+dhZvf6aeJRogE53mMKVO/UErYlYOmg4=;
        h=Subject:To:Cc:From:Date:From;
        b=WQa7/EIlFFTbqof3lo6qBmntlZnM0yb9x8yZjchrWti6HQ1UiGp9JNhP8D3T//VvZ
         BRDjX5M9YKV6fKKxF5T22MyfNYzj+jU90iwIe0XT06QbafiNVTJePyWOCxs9MunX6A
         iCWWEF/txgM12mz8oVFgspUqMquQTk7SdWSDqqAM=
Subject: FAILED: patch "[PATCH] drm/display/dp_mst: Handle old/new payload states in" failed to apply to 6.1-stable tree
To:     imre.deak@intel.com, Wayne.Lin@amd.com, alexander.deucher@amd.com,
        bskeggs@redhat.com, daniel@ffwll.ch, harry.wentland@amd.com,
        jani.nikula@intel.com, kherbst@redhat.com, lyude@redhat.com,
        ville.syrjala@linux.intel.com, wayne.lin@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:35:25 +0100
Message-ID: <167844812517527@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
git cherry-pick -x e761cc20946a0094df71cb31a565a6a0d03bd8be
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167844812517527@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

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

From e761cc20946a0094df71cb31a565a6a0d03bd8be Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Mon, 6 Feb 2023 13:48:54 +0200
Subject: [PATCH] drm/display/dp_mst: Handle old/new payload states in
 drm_dp_remove_payload()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Atm, drm_dp_remove_payload() uses the same payload state to both get the
vc_start_slot required for the payload removal DPCD message and to
deduct time_slots from vc_start_slot of all payloads after the one being
removed.

The above isn't always correct, as vc_start_slot must be the up-to-date
version contained in the new payload state, but time_slots must be the
one used when the payload was previously added, contained in the old
payload state. The new payload's time_slots can change vs. the old one
if the current atomic commit changes the corresponding mode.

This patch let's drivers pass the old and new payload states to
drm_dp_remove_payload(), but keeps these the same for now in all drivers
not to change the behavior. A follow-up i915 patch will pass in that
driver the correct old and new states to the function.

Cc: Lyude Paul <lyude@redhat.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org # 6.1
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Acked-by: Lyude Paul <lyude@redhat.com>
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230206114856.2665066-2-imre.deak@intel.com

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index a50319fc42b1..180d3893b68d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -208,7 +208,7 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
 	if (enable)
 		drm_dp_add_payload_part1(mst_mgr, mst_state, payload);
 	else
-		drm_dp_remove_payload(mst_mgr, mst_state, payload);
+		drm_dp_remove_payload(mst_mgr, mst_state, payload, payload);
 
 	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD or
 	 * AUX message. The sequence is slot 1-63 allocated sequence for each
diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 847c10aa2098..1990ff5dc7dd 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3342,7 +3342,8 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1);
  * drm_dp_remove_payload() - Remove an MST payload
  * @mgr: Manager to use.
  * @mst_state: The MST atomic state
- * @payload: The payload to write
+ * @old_payload: The payload with its old state
+ * @new_payload: The payload to write
  *
  * Removes a payload from an MST topology if it was successfully assigned a start slot. Also updates
  * the starting time slots of all other payloads which would have been shifted towards the start of
@@ -3350,36 +3351,37 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1);
  */
 void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
 			   struct drm_dp_mst_topology_state *mst_state,
-			   struct drm_dp_mst_atomic_payload *payload)
+			   const struct drm_dp_mst_atomic_payload *old_payload,
+			   struct drm_dp_mst_atomic_payload *new_payload)
 {
 	struct drm_dp_mst_atomic_payload *pos;
 	bool send_remove = false;
 
 	/* We failed to make the payload, so nothing to do */
-	if (payload->vc_start_slot == -1)
+	if (new_payload->vc_start_slot == -1)
 		return;
 
 	mutex_lock(&mgr->lock);
-	send_remove = drm_dp_mst_port_downstream_of_branch(payload->port, mgr->mst_primary);
+	send_remove = drm_dp_mst_port_downstream_of_branch(new_payload->port, mgr->mst_primary);
 	mutex_unlock(&mgr->lock);
 
 	if (send_remove)
-		drm_dp_destroy_payload_step1(mgr, mst_state, payload);
+		drm_dp_destroy_payload_step1(mgr, mst_state, new_payload);
 	else
 		drm_dbg_kms(mgr->dev, "Payload for VCPI %d not in topology, not sending remove\n",
-			    payload->vcpi);
+			    new_payload->vcpi);
 
 	list_for_each_entry(pos, &mst_state->payloads, next) {
-		if (pos != payload && pos->vc_start_slot > payload->vc_start_slot)
-			pos->vc_start_slot -= payload->time_slots;
+		if (pos != new_payload && pos->vc_start_slot > new_payload->vc_start_slot)
+			pos->vc_start_slot -= old_payload->time_slots;
 	}
-	payload->vc_start_slot = -1;
+	new_payload->vc_start_slot = -1;
 
 	mgr->payload_count--;
-	mgr->next_start_slot -= payload->time_slots;
+	mgr->next_start_slot -= old_payload->time_slots;
 
-	if (payload->delete)
-		drm_dp_mst_put_port_malloc(payload->port);
+	if (new_payload->delete)
+		drm_dp_mst_put_port_malloc(new_payload->port);
 }
 EXPORT_SYMBOL(drm_dp_remove_payload);
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index f3cb12dcfe0a..dc4e5ff1dbb3 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -526,6 +526,8 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
 		to_intel_connector(old_conn_state->connector);
 	struct drm_dp_mst_topology_state *mst_state =
 		drm_atomic_get_mst_topology_state(&state->base, &intel_dp->mst_mgr);
+	struct drm_dp_mst_atomic_payload *payload =
+		drm_atomic_get_mst_payload_state(mst_state, connector->port);
 	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 
 	drm_dbg_kms(&i915->drm, "active links %d\n",
@@ -534,7 +536,7 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
 	intel_hdcp_disable(intel_mst->connector);
 
 	drm_dp_remove_payload(&intel_dp->mst_mgr, mst_state,
-			      drm_atomic_get_mst_payload_state(mst_state, connector->port));
+			      payload, payload);
 
 	intel_audio_codec_disable(encoder, old_crtc_state, old_conn_state);
 }
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index edcb2529b402..ed9d374147b8 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -885,7 +885,7 @@ nv50_msto_prepare(struct drm_atomic_state *state,
 
 	// TODO: Figure out if we want to do a better job of handling VCPI allocation failures here?
 	if (msto->disabled) {
-		drm_dp_remove_payload(mgr, mst_state, payload);
+		drm_dp_remove_payload(mgr, mst_state, payload, payload);
 
 		nvif_outp_dp_mst_vcpi(&mstm->outp->outp, msto->head->base.index, 0, 0, 0, 0);
 	} else {
diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/display/drm_dp_mst_helper.h
index 41fd8352ab65..f5eb9aa152b1 100644
--- a/include/drm/display/drm_dp_mst_helper.h
+++ b/include/drm/display/drm_dp_mst_helper.h
@@ -841,7 +841,8 @@ int drm_dp_add_payload_part2(struct drm_dp_mst_topology_mgr *mgr,
 			     struct drm_dp_mst_atomic_payload *payload);
 void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
 			   struct drm_dp_mst_topology_state *mst_state,
-			   struct drm_dp_mst_atomic_payload *payload);
+			   const struct drm_dp_mst_atomic_payload *old_payload,
+			   struct drm_dp_mst_atomic_payload *new_payload);
 
 int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr);
 

