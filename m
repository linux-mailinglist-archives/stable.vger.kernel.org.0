Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22836E639A
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjDRMmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbjDRMmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:42:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6461447E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 579996330F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFFCC433EF;
        Tue, 18 Apr 2023 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821703;
        bh=8sb2Wy+tm6fkbGioQL/zhQrwbOwJbe8jjWAoDa8Jwks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ylpti39OK66vuH8GMLHRPfpeitR++ZArJvts/UI2IFKRoTB8bLAnY8PtgE0+gox5E
         esgEzM8LRfufsyDAMcm0mxV4IgHXuD8X022J7vlIKFDJddYJ/s+qLn6adq5SSvZ4dh
         ZUcNl85KXt7JwrijKHcZcLlgzbHXe1luu7jjJz34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jerry Zuo <Jerry.Zuo@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Veronika Schwan <veronika@pisquaredover6.de>
Subject: [PATCH 6.1 002/134] drm/amd/display: Pass the right info to drm_dp_remove_payload
Date:   Tue, 18 Apr 2023 14:20:58 +0200
Message-Id: <20230418120313.099853730@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

commit b8ca445f550a9a079134f836466ddda3bfad6108 upstream.

[Why & How]
drm_dp_remove_payload() interface was changed. Correct amdgpu dm code
to pass the right parameter to the drm helper function.

Reviewed-by: Jerry Zuo <Jerry.Zuo@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry-picked from b8ca445f550a9a079134f836466ddda3bfad6108)
[Hand modified due to missing f0127cb11299df80df45583b216e13f27c408545 which
 failed to apply due to missing 94dfeaa46925bb6b4d43645bbb6234e846dec257]
Reported-and-tested-by: Veronika Schwan <veronika@pisquaredover6.de>
Fixes: d7b5638bd337 ("drm/amd/display: Take FEC Overhead into Timeslot Calculation")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |   57 ++++++++++++--
 1 file changed, 50 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -175,6 +175,40 @@ void dm_helpers_dp_update_branch_info(
 	const struct dc_link *link)
 {}
 
+static void dm_helpers_construct_old_payload(
+			struct dc_link *link,
+			int pbn_per_slot,
+			struct drm_dp_mst_atomic_payload *new_payload,
+			struct drm_dp_mst_atomic_payload *old_payload)
+{
+	struct link_mst_stream_allocation_table current_link_table =
+									link->mst_stream_alloc_table;
+	struct link_mst_stream_allocation *dc_alloc;
+	int i;
+
+	*old_payload = *new_payload;
+
+	/* Set correct time_slots/PBN of old payload.
+	 * other fields (delete & dsc_enabled) in
+	 * struct drm_dp_mst_atomic_payload are don't care fields
+	 * while calling drm_dp_remove_payload()
+	 */
+	for (i = 0; i < current_link_table.stream_count; i++) {
+		dc_alloc =
+			&current_link_table.stream_allocations[i];
+
+		if (dc_alloc->vcp_id == new_payload->vcpi) {
+			old_payload->time_slots = dc_alloc->slot_count;
+			old_payload->pbn = dc_alloc->slot_count * pbn_per_slot;
+			break;
+		}
+	}
+
+	/* make sure there is an old payload*/
+	ASSERT(i != current_link_table.stream_count);
+
+}
+
 /*
  * Writes payload allocation table in immediate downstream device.
  */
@@ -186,7 +220,7 @@ bool dm_helpers_dp_mst_write_payload_all
 {
 	struct amdgpu_dm_connector *aconnector;
 	struct drm_dp_mst_topology_state *mst_state;
-	struct drm_dp_mst_atomic_payload *payload;
+	struct drm_dp_mst_atomic_payload *target_payload, *new_payload, old_payload;
 	struct drm_dp_mst_topology_mgr *mst_mgr;
 
 	aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
@@ -202,17 +236,26 @@ bool dm_helpers_dp_mst_write_payload_all
 	mst_state = to_drm_dp_mst_topology_state(mst_mgr->base.state);
 
 	/* It's OK for this to fail */
-	payload = drm_atomic_get_mst_payload_state(mst_state, aconnector->port);
-	if (enable)
-		drm_dp_add_payload_part1(mst_mgr, mst_state, payload);
-	else
-		drm_dp_remove_payload(mst_mgr, mst_state, payload, payload);
+	new_payload = drm_atomic_get_mst_payload_state(mst_state, aconnector->port);
+
+	if (enable) {
+		target_payload = new_payload;
+
+		drm_dp_add_payload_part1(mst_mgr, mst_state, new_payload);
+	} else {
+		/* construct old payload by VCPI*/
+		dm_helpers_construct_old_payload(stream->link, mst_state->pbn_div,
+						new_payload, &old_payload);
+		target_payload = &old_payload;
+
+		drm_dp_remove_payload(mst_mgr, mst_state, &old_payload, new_payload);
+	}
 
 	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD or
 	 * AUX message. The sequence is slot 1-63 allocated sequence for each
 	 * stream. AMD ASIC stream slot allocation should follow the same
 	 * sequence. copy DRM MST allocation to dc */
-	fill_dc_mst_payload_table_from_drm(stream->link, enable, payload, proposed_table);
+	fill_dc_mst_payload_table_from_drm(stream->link, enable, target_payload, proposed_table);
 
 	return true;
 }


