Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42FD865D57A
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbjADOUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239375AbjADOTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:19:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8C81DDD1
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:19:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AFABB8166B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6504FC433D2;
        Wed,  4 Jan 2023 14:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841989;
        bh=IHoLrEJYEr1bzgb9VXw1X3BvRlvC3oyz1PHksBBwrWc=;
        h=Subject:To:Cc:From:Date:From;
        b=eiYHPiy2BgeoU45R0HqGdeLkUjEvOrtunEyTY8jwE8UMPr8WGSW6HGki+wPMKoqfn
         6sIX+eNbQstGn6mmaZf5JsJvRekww0UZIGKQJvhVGDpAlGMCJGq/dJs+ke260Czzhf
         KKS+s0OL9m5/Lo1pSr86cvlwIC8umG86albiv5KY=
Subject: FAILED: patch "[PATCH] drm/amdgpu/dm/mst: Fix uninitialized var in" failed to apply to 6.0-stable tree
To:     lyude@redhat.com, alexander.deucher@amd.com, harry.wentland@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:19:41 +0100
Message-ID: <1672841981194@kroah.com>
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

33ac94dbdfd5 ("drm/amdgpu/dm/mst: Fix uninitialized var in pre_compute_mst_dsc_configs_for_state()")
7cce4cd628be ("drm/amdgpu/mst: Stop ignoring error codes and deadlocking")
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

From 33ac94dbdfd5f0fdd820c82ef930e20ad346a063 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Fri, 18 Nov 2022 14:54:05 -0500
Subject: [PATCH] drm/amdgpu/dm/mst: Fix uninitialized var in
 pre_compute_mst_dsc_configs_for_state()

Coverity noticed this one, so let's fix it.

Fixes: 7cce4cd628be ("drm/amdgpu/mst: Stop ignoring error codes and deadlocking")
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Cc: stable@vger.kernel.org # v5.6+

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 24d859ad4712..1edf7385f8d8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1187,7 +1187,7 @@ static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 	struct amdgpu_dm_connector *aconnector;
 	struct drm_dp_mst_topology_mgr *mst_mgr;
 	int link_vars_start_index = 0;
-	int ret;
+	int ret = 0;
 
 	for (i = 0; i < dc_state->stream_count; i++)
 		computed_streams[i] = false;

