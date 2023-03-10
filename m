Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7179B6B3E02
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjCJLg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCJLg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:36:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C1012CC6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:36:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3D316128D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9123C433EF;
        Fri, 10 Mar 2023 11:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448216;
        bh=baQ1z7bO4JwSHaGRzWfMtXWomgKs6Lgnm7hnvL6Tkt8=;
        h=Subject:To:Cc:From:Date:From;
        b=gRsFJJ2thws7ztMiOfznAFGBA7VHlHgA+tzgsMTxJnaqlUyg4nJopxCvR8rp98+fV
         gBDTrsNWUgwxv5E9BHRJWputsnirDEhSl8Jybma3tq2NtnqmBz4FbY68kkeGg1wdCd
         kMtGLsKO0BsQj679Tu39NBBHcDPLgyzx7DhPnizY=
Subject: FAILED: patch "[PATCH] drm/amdgpu/display/mst: limit payload to be updated one by" failed to apply to 6.1-stable tree
To:     Wayne.Lin@amd.com, alexander.deucher@amd.com,
        harry.wentland@amd.com, lyude@redhat.com, odyx@debian.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:36:48 +0100
Message-ID: <1678448208107166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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
git cherry-pick -x ea38dd57b0a65a7d434a7d9528c7b0445a5ea3ed
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678448208107166@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

ea38dd57b0a6 ("drm/amdgpu/display/mst: limit payload to be updated one by one")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ea38dd57b0a65a7d434a7d9528c7b0445a5ea3ed Mon Sep 17 00:00:00 2001
From: Wayne Lin <Wayne.Lin@amd.com>
Date: Fri, 9 Dec 2022 19:05:33 +0800
Subject: [PATCH] drm/amdgpu/display/mst: limit payload to be updated one by
 one

[Why]
amdgpu expects to update payload table for one stream one time
by calling dm_helpers_dp_mst_write_payload_allocation_table().
Currently, it get modified to try to update HW payload table
at once by referring mst_state.

[How]
This is just a quick workaround. Should find way to remove the
temporary struct dc_dp_mst_stream_allocation_table later if set
struct link_mst_stream_allocatio directly is possible.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Acked-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Tested-by: Didier Raboud <odyx@debian.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index f8882c324ba6..0b1d1bb8cbc7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -123,23 +123,50 @@ enum dc_edid_status dm_helpers_parse_edid_caps(
 }
 
 static void
-fill_dc_mst_payload_table_from_drm(struct drm_dp_mst_topology_state *mst_state,
-				   struct amdgpu_dm_connector *aconnector,
+fill_dc_mst_payload_table_from_drm(struct dc_link *link,
+				   bool enable,
+				   struct drm_dp_mst_atomic_payload *target_payload,
 				   struct dc_dp_mst_stream_allocation_table *table)
 {
 	struct dc_dp_mst_stream_allocation_table new_table = { 0 };
 	struct dc_dp_mst_stream_allocation *sa;
-	struct drm_dp_mst_atomic_payload *payload;
+	struct link_mst_stream_allocation_table copy_of_link_table =
+										link->mst_stream_alloc_table;
 
-	/* Fill payload info*/
-	list_for_each_entry(payload, &mst_state->payloads, next) {
-		if (payload->delete)
-			continue;
+	int i;
+	int current_hw_table_stream_cnt = copy_of_link_table.stream_count;
+	struct link_mst_stream_allocation *dc_alloc;
+
+	/* TODO: refactor to set link->mst_stream_alloc_table directly if possible.*/
+	if (enable) {
+		dc_alloc =
+		&copy_of_link_table.stream_allocations[current_hw_table_stream_cnt];
+		dc_alloc->vcp_id = target_payload->vcpi;
+		dc_alloc->slot_count = target_payload->time_slots;
+	} else {
+		for (i = 0; i < copy_of_link_table.stream_count; i++) {
+			dc_alloc =
+			&copy_of_link_table.stream_allocations[i];
+
+			if (dc_alloc->vcp_id == target_payload->vcpi) {
+				dc_alloc->vcp_id = 0;
+				dc_alloc->slot_count = 0;
+				break;
+			}
+		}
+		ASSERT(i != copy_of_link_table.stream_count);
+	}
 
-		sa = &new_table.stream_allocations[new_table.stream_count];
-		sa->slot_count = payload->time_slots;
-		sa->vcp_id = payload->vcpi;
-		new_table.stream_count++;
+	/* Fill payload info*/
+	for (i = 0; i < MAX_CONTROLLER_NUM; i++) {
+		dc_alloc =
+			&copy_of_link_table.stream_allocations[i];
+		if (dc_alloc->vcp_id > 0 && dc_alloc->slot_count > 0) {
+			sa = &new_table.stream_allocations[new_table.stream_count];
+			sa->slot_count = dc_alloc->slot_count;
+			sa->vcp_id = dc_alloc->vcp_id;
+			new_table.stream_count++;
+		}
 	}
 
 	/* Overwrite the old table */
@@ -188,7 +215,7 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
 	 * AUX message. The sequence is slot 1-63 allocated sequence for each
 	 * stream. AMD ASIC stream slot allocation should follow the same
 	 * sequence. copy DRM MST allocation to dc */
-	fill_dc_mst_payload_table_from_drm(mst_state, aconnector, proposed_table);
+	fill_dc_mst_payload_table_from_drm(stream->link, enable, payload, proposed_table);
 
 	return true;
 }

