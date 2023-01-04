Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BB165D571
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbjADOTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239439AbjADOTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:19:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425A51CB2E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:19:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7C56B8166B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E2EC433D2;
        Wed,  4 Jan 2023 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841960;
        bh=5D2GcCv3d3xSbPVDGsqBpzeN057MPHvpe2ZbhhOPdpA=;
        h=Subject:To:Cc:From:Date:From;
        b=LlktbJR3DYMfGrNEO6FgKJODdRUh8oCN4oVuE7kFUaabOQR/kxDG8yQbHZEZVPEG9
         XqQtC5ETnhG4h+TWfYKxzXMQ5rOSeWSeGFCnSVeCtEUFJ6ta4wPkwrIjn1VHtNgBAy
         rAzgjkHs0NfSZjEmNp7HtQDwSTZS7ZFH60cp7Bx8=
Subject: FAILED: patch "[PATCH] drm/amdgpu/dm/dp_mst: Don't grab mst_mgr->lock when computing" failed to apply to 6.1-stable tree
To:     lyude@redhat.com, Wayne.Lin@amd.com, alexander.deucher@amd.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:19:17 +0100
Message-ID: <167284195720388@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

14b651b22224 ("drm/amdgpu/dm/dp_mst: Don't grab mst_mgr->lock when computing DSC state")
d3e2c664ec9a ("drm/amdgpu/dm/mst: Use the correct topology mgr pointer in amdgpu_dm_connector")
7cce4cd628be ("drm/amdgpu/mst: Stop ignoring error codes and deadlocking")

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
 

