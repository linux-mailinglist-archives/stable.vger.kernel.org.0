Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA6E65D573
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbjADOTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239514AbjADOTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:19:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C950BCAB
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:19:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12E27B81658
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7394AC433D2;
        Wed,  4 Jan 2023 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841966;
        bh=/z6kixWw9SAtvD7KrAzc2E67785veyUjfatsS6JEocY=;
        h=Subject:To:Cc:From:Date:From;
        b=fQuhRDm8Swn8i8PZI/ehsHv2JkVbYn3H0HSlrw6vU/nDf5eCu/QLud1nnwCWH5vnI
         N4QhZ4Ea6U6QtIWfDEWx9C+PtLs5mdy3ZY0DEa9Vi2/1g5BTQTlWMALyakovkZR432
         RjQthY3SR4dWBn+faadYaz9jttWgB56v1VUhbDKo=
Subject: FAILED: patch "[PATCH] drm/amdgpu/dm/dp_mst: Don't grab mst_mgr->lock when computing" failed to apply to 5.15-stable tree
To:     lyude@redhat.com, Wayne.Lin@amd.com, alexander.deucher@amd.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:19:19 +0100
Message-ID: <1672841959242182@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

14b651b22224 ("drm/amdgpu/dm/dp_mst: Don't grab mst_mgr->lock when computing DSC state")
d3e2c664ec9a ("drm/amdgpu/dm/mst: Use the correct topology mgr pointer in amdgpu_dm_connector")
7cce4cd628be ("drm/amdgpu/mst: Stop ignoring error codes and deadlocking")
876fcc4222e1 ("drm/amd/display: Validate DSC After Enable All New CRTCs")
47519d8224ba ("Merge tag 'amd-drm-next-6.1-2022-09-08' of https://gitlab.freedesktop.org/agd5f/linux into drm-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 14b651b22224251b35618259da714adb0b5f10ee Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Mon, 14 Nov 2022 17:17:55 -0500
Subject: [PATCH] drm/amdgpu/dm/dp_mst: Don't grab mst_mgr->lock when computing
 DSC state

Now that we've fixed the issue with using the incorrect topology manager,
we're actually grabbing the topology manager's lock - and consequently
deadlocking. Luckily for us though, there's actually nothing in AMD's DSC
state computation code that really should need this lock. The one exception
is the mutex_lock() in dm_dp_mst_is_port_support_mode(), however we grab no
locks beneath &mgr->lock there so that should be fine to leave be.

Gitlab issue: https://gitlab.freedesktop.org/drm/amd/-/issues/2171

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 8c20a1ed9b4f ("drm/amd/display: MST DSC compute fair share")
Cc: <stable@vger.kernel.org> # v5.6+
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index bb4801d7625e..24d859ad4712 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1155,10 +1155,8 @@ int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 			continue;
 
 		mst_mgr = aconnector->port->mgr;
-		mutex_lock(&mst_mgr->lock);
 		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars, mst_mgr,
 						       &link_vars_start_index);
-		mutex_unlock(&mst_mgr->lock);
 		if (ret != 0)
 			return ret;
 
@@ -1215,10 +1213,8 @@ static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 			continue;
 
 		mst_mgr = aconnector->port->mgr;
-		mutex_lock(&mst_mgr->lock);
 		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars, mst_mgr,
 						       &link_vars_start_index);
-		mutex_unlock(&mst_mgr->lock);
 		if (ret != 0)
 			return ret;
 

