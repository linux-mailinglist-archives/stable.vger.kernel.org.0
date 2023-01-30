Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E086810CE
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbjA3OG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237099AbjA3OG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEB13B3FE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98A6E6102F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C4AC433EF;
        Mon, 30 Jan 2023 14:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087614;
        bh=/LJomUwJeln5kBIwnKZfFr7jgYhsd961uQUBRomjUes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnWW3WncJO5EbOdRaIJoSxtcocnmL0HusLTyM5ACLQEtkDV6xzlVlRT6iJJkrepGQ
         7hqZHG2wxm+Nx5FRcTDKi21NiyzzqUsAQmX8v8XZZLMQ8X1XoTMqk4wYGAtcnwzyjf
         6F3lM+T5e5Yt1PeAo69nfMqgs8pvgeO3Kom7w4Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lyude Paul <lyude@redhat.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Didier Raboud <odyx@debian.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 237/313] drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count assignments
Date:   Mon, 30 Jan 2023 14:51:12 +0100
Message-Id: <20230130134347.722527537@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 1119e1f9636b76aef14068c7fd0b4d55132b86b8 upstream.

Looks like I made a pretty big mistake here without noticing: it seems when
I moved the assignments of mst_state->pbn_div I completely missed the fact
that the reason for us calling drm_dp_mst_update_slots() earlier was to
account for the fact that we need to call this function using info from the
root MST connector, instead of just trying to do this from each MST
encoder's atomic check function. Otherwise, we end up filling out all of
DC's link information with zeroes.

So, let's restore that and hopefully fix this DSC regression.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Didier Raboud <odyx@debian.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |   24 ++++++++++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    5 --
 2 files changed, 24 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9393,6 +9393,8 @@ static int amdgpu_dm_atomic_check(struct
 	struct drm_connector_state *old_con_state, *new_con_state;
 	struct drm_crtc *crtc;
 	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
+	struct drm_dp_mst_topology_mgr *mgr;
+	struct drm_dp_mst_topology_state *mst_state;
 	struct drm_plane *plane;
 	struct drm_plane_state *old_plane_state, *new_plane_state;
 	enum dc_status status;
@@ -9648,6 +9650,28 @@ static int amdgpu_dm_atomic_check(struct
 		lock_and_validation_needed = true;
 	}
 
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	/* set the slot info for each mst_state based on the link encoding format */
+	for_each_new_mst_mgr_in_state(state, mgr, mst_state, i) {
+		struct amdgpu_dm_connector *aconnector;
+		struct drm_connector *connector;
+		struct drm_connector_list_iter iter;
+		u8 link_coding_cap;
+
+		drm_connector_list_iter_begin(dev, &iter);
+		drm_for_each_connector_iter(connector, &iter) {
+			if (connector->index == mst_state->mgr->conn_base_id) {
+				aconnector = to_amdgpu_dm_connector(connector);
+				link_coding_cap = dc_link_dp_mst_decide_link_encoding_format(aconnector->dc_link);
+				drm_dp_mst_update_slots(mst_state, link_coding_cap);
+
+				break;
+			}
+		}
+		drm_connector_list_iter_end(&iter);
+	}
+#endif
+
 	/**
 	 * Streams and planes are reset when there are changes that affect
 	 * bandwidth. Anything that affects bandwidth needs to go through
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -896,11 +896,6 @@ static int compute_mst_dsc_configs_for_l
 	if (IS_ERR(mst_state))
 		return PTR_ERR(mst_state);
 
-	mst_state->pbn_div = dm_mst_get_pbn_divider(dc_link);
-#if defined(CONFIG_DRM_AMD_DC_DCN)
-	drm_dp_mst_update_slots(mst_state, dc_link_dp_mst_decide_link_encoding_format(dc_link));
-#endif
-
 	/* Set up params */
 	for (i = 0; i < dc_state->stream_count; i++) {
 		struct dc_dsc_policy dsc_policy = {0};


