Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAAA6C0E98
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCTKU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjCTKUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:20:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DE012849
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 03:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D2CAB80DDF
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14487C433EF;
        Mon, 20 Mar 2023 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679307617;
        bh=B3gwhFCQ3ypXl4iPSDE+RK5ApyA6bXM4kdRwFSS5BLY=;
        h=Subject:To:Cc:From:Date:From;
        b=HkbANtZCphMXm3THWVoq53bl1Sy3g+66sU+uXDuqPySz2Bs86NdykFz5XQkDemMWK
         Alp/cRu508iyVRBoCtax3gkMelSptuz4bLKJeapSNMf1dJy5xAZ38rr03Pcdv+o6cg
         rL4hn5cy9pdeZBNAYC8OWYRsB/Hq3UUbe0I1TTH0=
Subject: FAILED: patch "[PATCH] drm/amdgpu: move poll enabled/disable into non DC path" failed to apply to 6.2-stable tree
To:     guchun.chen@amd.com, alexander.deucher@amd.com,
        dmitry.baryshkov@linaro.org, spasswolf@web.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 11:20:14 +0100
Message-ID: <1679307614196155@kroah.com>
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


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 3fadda5de8073e2cb65744803a6941736411d55b
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679307614196155@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

3fadda5de807 ("drm/amdgpu: move poll enabled/disable into non DC path")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3fadda5de8073e2cb65744803a6941736411d55b Mon Sep 17 00:00:00 2001
From: Guchun Chen <guchun.chen@amd.com>
Date: Thu, 9 Mar 2023 10:02:45 +0800
Subject: [PATCH] drm/amdgpu: move poll enabled/disable into non DC path

Some amd asics having reliable hotplug support don't call
drm_kms_helper_poll_init in driver init sequence. However,
due to the unified suspend/resume path for all asics, because
the output_poll_work->func is not set for these asics, a warning
arrives when suspending.

[   90.656049]  <TASK>
[   90.656050]  ? console_unlock+0x4d/0x100
[   90.656053]  ? __irq_work_queue_local+0x27/0x60
[   90.656056]  ? irq_work_queue+0x2b/0x50
[   90.656057]  ? __wake_up_klogd+0x40/0x60
[   90.656059]  __cancel_work_timer+0xed/0x180
[   90.656061]  drm_kms_helper_poll_disable.cold+0x1f/0x2c [drm_kms_helper]
[   90.656072]  amdgpu_device_suspend+0x81/0x170 [amdgpu]
[   90.656180]  amdgpu_pmops_runtime_suspend+0xb5/0x1b0 [amdgpu]
[   90.656269]  pci_pm_runtime_suspend+0x61/0x1b0

drm_kms_helper_poll_enable/disable is valid when poll_init is called in
amdgpu code, which is only used in non DC path. So move such codes into
non-DC path code to get rid of such warnings.

v1: introduce use_kms_poll flag in amdgpu as the poll stuff check
v2: use dc_enabled as the flag to simply code
v3: move code into non DC path instead of relying on any flag

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2411
Fixes: a4e771729a51 ("drm/probe_helper: sort out poll_running vs poll_enabled")
Reported-by: Bert Karwatzki <spasswolf@web.de>
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c4a4e2fe6681..da5b0258a237 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4145,8 +4145,6 @@ int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 	if (amdgpu_acpi_smart_shift_update(dev, AMDGPU_SS_DEV_D3))
 		DRM_WARN("smart shift update failed\n");
 
-	drm_kms_helper_poll_disable(dev);
-
 	if (fbcon)
 		drm_fb_helper_set_suspend_unlocked(adev_to_drm(adev)->fb_helper, true);
 
@@ -4243,8 +4241,6 @@ int amdgpu_device_resume(struct drm_device *dev, bool fbcon)
 	if (fbcon)
 		drm_fb_helper_set_suspend_unlocked(adev_to_drm(adev)->fb_helper, false);
 
-	drm_kms_helper_poll_enable(dev);
-
 	amdgpu_ras_resume(adev);
 
 	if (adev->mode_info.num_crtc) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 503f89a766c3..d60fe7eb5579 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -1618,6 +1618,8 @@ int amdgpu_display_suspend_helper(struct amdgpu_device *adev)
 	struct drm_connector_list_iter iter;
 	int r;
 
+	drm_kms_helper_poll_disable(dev);
+
 	/* turn off display hw */
 	drm_modeset_lock_all(dev);
 	drm_connector_list_iter_begin(dev, &iter);
@@ -1694,6 +1696,8 @@ int amdgpu_display_resume_helper(struct amdgpu_device *adev)
 
 	drm_modeset_unlock_all(dev);
 
+	drm_kms_helper_poll_enable(dev);
+
 	return 0;
 }
 

