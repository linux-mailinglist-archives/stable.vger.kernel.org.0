Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129146B3DEB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbjCJLfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjCJLfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:35:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D77E1102BB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:34:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFED861378
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A87C433D2;
        Fri, 10 Mar 2023 11:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448086;
        bh=k0I8FMGx4ItTClRX/d/AA1voLODxuGi8aFCj2jlpVsk=;
        h=Subject:To:Cc:From:Date:From;
        b=MJq5hJmPWQKyynC1F+gnlxZT1XgSt8oFWSJHpMyxA/dB3ZXXLBXIptcPYXz6Qk3G+
         dHVyYmM+/6A7sDo1rFXb//DuWPPQPYRr/oywYSXZknCPxb1kwhmAXV9c/oFAce/sh6
         NjwjjwGWLHssSiZxFmXpBU6Dc81JmVCUQXNMRbI4=
Subject: FAILED: patch "[PATCH] drm/display/dp_mst: Correct the kref of port." failed to apply to 6.1-stable tree
To:     Wayne.Lin@amd.com, alexander.deucher@amd.com,
        harry.wentland@amd.com, lyude@redhat.com, odyx@debian.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:34:35 +0100
Message-ID: <16784480752035@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 9b2d019144a00627ed95cc1f664fc681b6fe1c7d
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16784480752035@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

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

