Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669186B3E05
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCJLhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCJLhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:37:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAFA10AB0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:37:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E22B76137F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6E0C433EF;
        Fri, 10 Mar 2023 11:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448231;
        bh=qFF2V6qIcfRH1ubqNcG/0gtQcYpLahfoluAHSmovooI=;
        h=Subject:To:Cc:From:Date:From;
        b=svjW0owoJkhVacvppdD2vAj/uyH3oRGfWy0eDg6GBwzB7moUK/9jSWUK0fDxTHDIY
         Rj4qHnGBjxnW6QgYKbdgNjdg2ZR9bLp4r10C5vrH6CCnrBEm6co4K1vFRj2jCtf539
         jHtFCdD58LnU6pnfvhVm2JKYWO3SoHqBQQ8uoCOE=
Subject: FAILED: patch "[PATCH] drm/amdgpu/display/mst: update mst_mgr relevant variable when" failed to apply to 6.2-stable tree
To:     Wayne.Lin@amd.com, alexander.deucher@amd.com,
        harry.wentland@amd.com, lyude@redhat.com, odyx@debian.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:37:00 +0100
Message-ID: <1678448220112184@kroah.com>
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


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 2daeb74b7d66362de8e15b983e310e85f01930e5
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678448220112184@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

2daeb74b7d66 ("drm/amdgpu/display/mst: update mst_mgr relevant variable when long HPD")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2daeb74b7d66362de8e15b983e310e85f01930e5 Mon Sep 17 00:00:00 2001
From: Wayne Lin <Wayne.Lin@amd.com>
Date: Mon, 12 Dec 2022 15:41:18 +0800
Subject: [PATCH] drm/amdgpu/display/mst: update mst_mgr relevant variable when
 long HPD

[Why & How]
Now the vc_start_slot is controlled at drm side. When we
service a long HPD, we still need to run
dm_helpers_dp_mst_write_payload_allocation_table() to update
drm mst_mgr's relevant variable. Otherwise, on the next plug-in,
payload will get assigned with a wrong start slot.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Acked-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Tested-by: Didier Raboud <odyx@debian.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index d9e490eca10f..bf5a31e2be8a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -3999,10 +3999,13 @@ static enum dc_status deallocate_mst_payload(struct pipe_ctx *pipe_ctx)
 	struct fixed31_32 avg_time_slots_per_mtp = dc_fixpt_from_int(0);
 	int i;
 	bool mst_mode = (link->type == dc_connection_mst_branch);
+	/* adjust for drm changes*/
+	bool update_drm_mst_state = true;
 	const struct link_hwss *link_hwss = get_link_hwss(link, &pipe_ctx->link_res);
 	const struct dc_link_settings empty_link_settings = {0};
 	DC_LOGGER_INIT(link->ctx->logger);
 
+
 	/* deallocate_mst_payload is called before disable link. When mode or
 	 * disable/enable monitor, new stream is created which is not in link
 	 * stream[] yet. For this, payload is not allocated yet, so de-alloc
@@ -4018,7 +4021,7 @@ static enum dc_status deallocate_mst_payload(struct pipe_ctx *pipe_ctx)
 				&empty_link_settings,
 				avg_time_slots_per_mtp);
 
-	if (mst_mode) {
+	if (mst_mode || update_drm_mst_state) {
 		/* when link is in mst mode, reply on mst manager to remove
 		 * payload
 		 */
@@ -4081,11 +4084,18 @@ static enum dc_status deallocate_mst_payload(struct pipe_ctx *pipe_ctx)
 			stream->ctx,
 			stream);
 
+		if (!update_drm_mst_state)
+			dm_helpers_dp_mst_send_payload_allocation(
+				stream->ctx,
+				stream,
+				false);
+	}
+
+	if (update_drm_mst_state)
 		dm_helpers_dp_mst_send_payload_allocation(
 			stream->ctx,
 			stream,
 			false);
-	}
 
 	return DC_OK;
 }

