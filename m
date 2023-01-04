Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F037165D638
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239613AbjADOmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239628AbjADOmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:42:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3774D3D9DF
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:41:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFF3961764
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56B5C433F2;
        Wed,  4 Jan 2023 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843317;
        bh=u75TIyXiFzs8R1hUquj8txFP1T3soUvJR3FFqQJQXEQ=;
        h=Subject:To:Cc:From:Date:From;
        b=UqWlA0H/4cYq0GvO0oNJJItimIe/7qwQDcEQqMQ2Z+xzLeu93ZjVMZuS9eSIGHYTh
         XH0r+AKtCOTNFNh6HHD8mZuZfLa36gHwPXIeMYIc2EKoLq9c06DhabY8BiSyiOrb20
         WA79M9t4OzHOJO4GdfsZWBov4zG10AHXo3uwvMiw=
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix access timeout to DPIA AUX at boot time" failed to apply to 6.0-stable tree
To:     stylon.wang@amd.com, Wayne.Lin@amd.com, alexander.deucher@amd.com,
        chiahsuan.chung@amd.com, daniel.wheeler@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:41:43 +0100
Message-ID: <1672843303116111@kroah.com>
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

1c43a48b44a5 ("drm/amd/display: Fix access timeout to DPIA AUX at boot time")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1c43a48b44a5449ed996215d1488284d5bdb2be0 Mon Sep 17 00:00:00 2001
From: Stylon Wang <stylon.wang@amd.com>
Date: Mon, 24 Oct 2022 15:36:16 +0800
Subject: [PATCH] drm/amd/display: Fix access timeout to DPIA AUX at boot time

[Why]
Since introduction of patch "Query DPIA HPD status.", link detection at
boot could be accessing DPIA AUX, which will not succeed until
DMUB outbox messaging is enabled and results in below dmesg logs:

[  160.840227] [drm:amdgpu_dm_process_dmub_aux_transfer_sync [amdgpu]] *ERROR* wait_for_completion_timeout timeout!

[How]
Enable DMUB outbox messaging before link detection at boot time.

Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 123c235b60bc..2dc75b1b005b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1636,12 +1636,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 		}
 	}
 
-	if (amdgpu_dm_initialize_drm_device(adev)) {
-		DRM_ERROR(
-		"amdgpu: failed to initialize sw for display support.\n");
-		goto error;
-	}
-
 	/* Enable outbox notification only after IRQ handlers are registered and DMUB is alive.
 	 * It is expected that DMUB will resend any pending notifications at this point, for
 	 * example HPD from DPIA.
@@ -1649,6 +1643,12 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	if (dc_is_dmub_outbox_supported(adev->dm.dc))
 		dc_enable_dmub_outbox(adev->dm.dc);
 
+	if (amdgpu_dm_initialize_drm_device(adev)) {
+		DRM_ERROR(
+		"amdgpu: failed to initialize sw for display support.\n");
+		goto error;
+	}
+
 	/* create fake encoders for MST */
 	dm_dp_create_fake_mst_encoders(adev);
 

