Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C856B3DEC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjCJLfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjCJLfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:35:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECB310F846
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:34:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B550B82267
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D04C433EF;
        Fri, 10 Mar 2023 11:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448077;
        bh=dfPE2EdZFFDdbM74APsmQRJbEtxMJDRNyC8df6wttKA=;
        h=Subject:To:Cc:From:Date:From;
        b=NWnnKSfZ3w/xbayYsXFKPJRroLb+BsxgUyedhe2t/U7u2M/8WabicWQyEiabF4ELb
         /bCycf8Br3j4izaEqPyG00EGQ7NY11uTinMrZRz+shgshRokkwKl606YpikRVvMnMH
         4GovJvwBgee5iK1I2mSezxhvlNSRTk5jIyWzqbC4=
Subject: FAILED: patch "[PATCH] drm/display/dp_mst: Correct the kref of port." failed to apply to 6.2-stable tree
To:     Wayne.Lin@amd.com, alexander.deucher@amd.com,
        harry.wentland@amd.com, lyude@redhat.com, odyx@debian.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:34:34 +0100
Message-ID: <1678448074177203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 9b2d019144a00627ed95cc1f664fc681b6fe1c7d
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678448074177203@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

9b2d019144a0 ("drm/display/dp_mst: Correct the kref of port.")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9b2d019144a00627ed95cc1f664fc681b6fe1c7d Mon Sep 17 00:00:00 2001
From: Wayne Lin <Wayne.Lin@amd.com>
Date: Wed, 28 Dec 2022 14:50:43 +0800
Subject: [PATCH] drm/display/dp_mst: Correct the kref of port.

[why & how]
We still need to refer to port while removing payload at commit_tail.
we should keep the kref till then to release.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Acked-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Tested-by: Didier Raboud <odyx@debian.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 51a46689cda7..4ca37261584a 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3372,6 +3372,9 @@ void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
 
 	mgr->payload_count--;
 	mgr->next_start_slot -= payload->time_slots;
+
+	if (payload->delete)
+		drm_dp_mst_put_port_malloc(payload->port);
 }
 EXPORT_SYMBOL(drm_dp_remove_payload);
 
@@ -4327,7 +4330,6 @@ int drm_dp_atomic_release_time_slots(struct drm_atomic_state *state,
 
 	drm_dbg_atomic(mgr->dev, "[MST PORT:%p] TU %d -> 0\n", port, payload->time_slots);
 	if (!payload->delete) {
-		drm_dp_mst_put_port_malloc(port);
 		payload->pbn = 0;
 		payload->delete = true;
 		topology_state->payload_mask &= ~BIT(payload->vcpi - 1);

