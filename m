Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744B363DC2D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 18:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiK3Rik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 12:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiK3Rii (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 12:38:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074DD43AD6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 09:38:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9993B61D21
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 17:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDC5C433C1;
        Wed, 30 Nov 2022 17:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669829917;
        bh=mPTVArNDitgazeC/AYIb050Zcph3hsHXJ2tHfl07Qcs=;
        h=Subject:To:Cc:From:Date:From;
        b=huEE6hWgXKYpZWIAtbYtc4y1+VwFzolB2uBGHs5g01cjjiy0LePT/Rs3i3DiGNrDo
         vr5CO8ovTqnhtSgEVJfv2Psll0Mf5DNp0WwuVtCqmmyNE+SaxBmHjhasVMnUixgVxA
         NecTGgRtSbFjSBhPiIYbqA0leFxQPBWtLml4iij8=
Subject: FAILED: patch "[PATCH] drm/amdgpu/dm/mst: Fix uninitialized var in" failed to apply to 6.0-stable tree
To:     lyude@redhat.com, alexander.deucher@amd.com, harry.wentland@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 18:38:21 +0100
Message-ID: <16698299015117@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

85ef1679a190 ("drm/amdgpu/dm/mst: Fix uninitialized var in pre_compute_mst_dsc_configs_for_state()")
ba891436c2d2 ("drm/amdgpu/mst: Stop ignoring error codes and deadlocking")
876fcc4222e1 ("drm/amd/display: Validate DSC After Enable All New CRTCs")
4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
6366fc70deb9 ("drm/display/dp_mst: Maintain time slot allocations when deleting payloads")
a5c2c0d164e9 ("drm/display/dp_mst: Add nonblocking helpers for DP MST")
0b4e477e08a1 ("drm/display/dp_mst: Add helper for finding payloads in atomic MST state")
0bee2ae29eb4 ("drm/display/dp_mst: Add some missing kdocs for atomic MST structs")
df78f7f660cd ("drm/display/dp_mst: Call them time slots, not VCPI slots")
48b6b3726fb7 ("drm/display/dp_mst: Rename drm_dp_mst_vcpi_allocation")
dbaadb3cebaa ("drm/amdgpu/dm/mst: Rename get_payload_table()")
8c5e9bbb3662 ("drm/amdgpu/dc/mst: Rename dp_mst_stream_allocation(_table)")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85ef1679a190a9740f6b72217cb139a0d9c58706 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Fri, 18 Nov 2022 14:54:05 -0500
Subject: [PATCH] drm/amdgpu/dm/mst: Fix uninitialized var in
 pre_compute_mst_dsc_configs_for_state()

Coverity noticed this one, so let's fix it.

Fixes: ba891436c2d2b2 ("drm/amdgpu/mst: Stop ignoring error codes and deadlocking")
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Cc: stable@vger.kernel.org # v5.6+

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 59648f5ffb59..6483ba266893 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1180,7 +1180,7 @@ static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 	struct amdgpu_dm_connector *aconnector;
 	struct drm_dp_mst_topology_mgr *mst_mgr;
 	int link_vars_start_index = 0;
-	int ret;
+	int ret = 0;
 
 	for (i = 0; i < dc_state->stream_count; i++)
 		computed_streams[i] = false;

