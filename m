Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85AF7582907
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 16:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbiG0Ow0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 10:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbiG0OwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 10:52:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE4F3E758
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 07:52:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D23561879
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 14:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EC8C433C1;
        Wed, 27 Jul 2022 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658933543;
        bh=jpM3h6DnlQDS6ej75yNn7u1kcscIQvweW2yz0VdOyYw=;
        h=Subject:To:Cc:From:Date:From;
        b=q3TYuD0yfFRz5DkQe6+kPK7U4NALizquHEqBQXdTYBfWYBBeM6qHOye2CY46v4d7H
         wToQYBt6X9uJ6I7OUBnw4lViF4xnNG9qjAhg1UZStOo8KdyZnnGIkXaiE3zJGoss4o
         sxYLDNXPUQTmmhuGoi7czsDTkjiI2qTichXUuwso=
Subject: FAILED: patch "[PATCH] drm/amd/display: Add callbacks for DMUB HPD IRQ notifications" failed to apply to 5.15-stable tree
To:     nicholas.kazlauskas@amd.com, Anson.Jacob@amd.com,
        Wayne.Lin@amd.com, alexander.deucher@amd.com,
        daniel.wheeler@amd.com, shenshih@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 27 Jul 2022 16:52:21 +0200
Message-ID: <1658933541151130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c40a09e56fa3d17a3d06cec9a24b04364bb18c8f Mon Sep 17 00:00:00 2001
From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Date: Thu, 4 Nov 2021 16:52:07 -0400
Subject: [PATCH] drm/amd/display: Add callbacks for DMUB HPD IRQ notifications

[Why]
We need HPD IRQ notifications (RX, short pulse) to properly handle
DP MST for DPIA connections.

[How]
A null pointer exception currently occurs when these are received
so add a check to validate that we have a handler installed for
the notification.

Extend the HPD handler to also handle HPD IRQ (RX) since the logic is
the same.

Fixes: e27c41d5b068 ("drm/amd/display: Support for DMUB HPD interrupt handling")

Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Reviewed-by: Jude Shih <shenshih@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6aafcc14b479..a7cf7df4d2f2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -217,6 +217,7 @@ static const struct drm_format_info *
 amd_get_format_info(const struct drm_mode_fb_cmd2 *cmd);
 
 static void handle_hpd_irq_helper(struct amdgpu_dm_connector *aconnector);
+static void handle_hpd_rx_irq(void *param);
 
 static bool
 is_timing_unchanged_for_freesync(struct drm_crtc_state *old_crtc_state,
@@ -683,8 +684,12 @@ void dmub_hpd_callback(struct amdgpu_device *adev, struct dmub_notification *not
 	}
 	drm_connector_list_iter_end(&iter);
 
-	if (hpd_aconnector)
-		handle_hpd_irq_helper(hpd_aconnector);
+	if (hpd_aconnector) {
+		if (notify->type == DMUB_NOTIFICATION_HPD)
+			handle_hpd_irq_helper(hpd_aconnector);
+		else if (notify->type == DMUB_NOTIFICATION_HPD_IRQ)
+			handle_hpd_rx_irq(hpd_aconnector);
+	}
 }
 
 /**
@@ -760,6 +765,10 @@ static void dm_dmub_outbox1_low_irq(void *interrupt_params)
 				DRM_ERROR("DM: notify type %d invalid!", notify.type);
 				continue;
 			}
+			if (!dm->dmub_callback[notify.type]) {
+				DRM_DEBUG_DRIVER("DMUB notification skipped, no handler: type=%d\n", notify.type);
+				continue;
+			}
 			if (dm->dmub_thread_offload[notify.type] == true) {
 				dmub_hpd_wrk = kzalloc(sizeof(*dmub_hpd_wrk), GFP_ATOMIC);
 				if (!dmub_hpd_wrk) {
@@ -1560,6 +1569,10 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 			DRM_ERROR("amdgpu: fail to register dmub hpd callback");
 			goto error;
 		}
+		if (!register_dmub_notify_callback(adev, DMUB_NOTIFICATION_HPD_IRQ, dmub_hpd_callback, true)) {
+			DRM_ERROR("amdgpu: fail to register dmub hpd callback");
+			goto error;
+		}
 #endif /* CONFIG_DRM_AMD_DC_DCN */
 	}
 

