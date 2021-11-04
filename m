Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143A24450F7
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 10:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhKDJTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 05:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230335AbhKDJTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 05:19:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2EEA61157;
        Thu,  4 Nov 2021 09:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636017396;
        bh=SiALOJAFZAd8EeYiwQOiTRxsBytCXIu2T0HiukD36B8=;
        h=Subject:To:Cc:From:Date:From;
        b=UoulHDp9DlNmbS5kwCzD4aYtV7mbabMvts5d7A0QlC+56QB48uegaSc9h1lP2MH4n
         NIRNd+6H9wcCLPh6aU5bvbgkZhv4ZrDsW9YACou4xhS3MS3eE3sOeWjnf3mp+9nMQb
         LSwFh8lulU3p36PTRV/cPzrZq5HIKguN5Pc4kauQ=
Subject: FAILED: patch "[PATCH] drm/amdgpu: revert "Add autodump debugfs node for gpu reset" failed to apply to 5.10-stable tree
To:     christian.koenig@amd.com, alexander.deucher@amd.com,
        nirmoy.das@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Nov 2021 10:16:33 +0100
Message-ID: <16360173936112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c8365dbda056578eebe164bf110816b1a39b4b7f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Date: Thu, 30 Sep 2021 11:22:51 +0200
Subject: [PATCH] drm/amdgpu: revert "Add autodump debugfs node for gpu reset
 v8"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This reverts commit 728e7e0cd61899208e924472b9e641dbeb0775c4.

Further discussion reveals that this feature is severely broken
and needs to be reverted ASAP.

GPU reset can never be delayed by userspace even for debugging or
otherwise we can run into in kernel deadlocks.

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Nirmoy Das <nirmoy.das@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index f4bceb2624fb..eb1c117e82b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1085,8 +1085,6 @@ struct amdgpu_device {
 	char				product_name[32];
 	char				serial[20];
 
-	struct amdgpu_autodump		autodump;
-
 	atomic_t			throttling_logging_enabled;
 	struct ratelimit_state		throttling_logging_rs;
 	uint32_t                        ras_hw_enabled;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index 31e16a42d4e1..6611b3c7c149 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -27,7 +27,6 @@
 #include <linux/pci.h>
 #include <linux/uaccess.h>
 #include <linux/pm_runtime.h>
-#include <linux/poll.h>
 
 #include "amdgpu.h"
 #include "amdgpu_pm.h"
@@ -38,85 +37,7 @@
 #include "amdgpu_fw_attestation.h"
 #include "amdgpu_umr.h"
 
-int amdgpu_debugfs_wait_dump(struct amdgpu_device *adev)
-{
 #if defined(CONFIG_DEBUG_FS)
-	unsigned long timeout = 600 * HZ;
-	int ret;
-
-	wake_up_interruptible(&adev->autodump.gpu_hang);
-
-	ret = wait_for_completion_interruptible_timeout(&adev->autodump.dumping, timeout);
-	if (ret == 0) {
-		pr_err("autodump: timeout, move on to gpu recovery\n");
-		return -ETIMEDOUT;
-	}
-#endif
-	return 0;
-}
-
-#if defined(CONFIG_DEBUG_FS)
-
-static int amdgpu_debugfs_autodump_open(struct inode *inode, struct file *file)
-{
-	struct amdgpu_device *adev = inode->i_private;
-	int ret;
-
-	file->private_data = adev;
-
-	ret = down_read_killable(&adev->reset_sem);
-	if (ret)
-		return ret;
-
-	if (adev->autodump.dumping.done) {
-		reinit_completion(&adev->autodump.dumping);
-		ret = 0;
-	} else {
-		ret = -EBUSY;
-	}
-
-	up_read(&adev->reset_sem);
-
-	return ret;
-}
-
-static int amdgpu_debugfs_autodump_release(struct inode *inode, struct file *file)
-{
-	struct amdgpu_device *adev = file->private_data;
-
-	complete_all(&adev->autodump.dumping);
-	return 0;
-}
-
-static unsigned int amdgpu_debugfs_autodump_poll(struct file *file, struct poll_table_struct *poll_table)
-{
-	struct amdgpu_device *adev = file->private_data;
-
-	poll_wait(file, &adev->autodump.gpu_hang, poll_table);
-
-	if (amdgpu_in_reset(adev))
-		return POLLIN | POLLRDNORM | POLLWRNORM;
-
-	return 0;
-}
-
-static const struct file_operations autodump_debug_fops = {
-	.owner = THIS_MODULE,
-	.open = amdgpu_debugfs_autodump_open,
-	.poll = amdgpu_debugfs_autodump_poll,
-	.release = amdgpu_debugfs_autodump_release,
-};
-
-static void amdgpu_debugfs_autodump_init(struct amdgpu_device *adev)
-{
-	init_completion(&adev->autodump.dumping);
-	complete_all(&adev->autodump.dumping);
-	init_waitqueue_head(&adev->autodump.gpu_hang);
-
-	debugfs_create_file("amdgpu_autodump", 0600,
-		adev_to_drm(adev)->primary->debugfs_root,
-		adev, &autodump_debug_fops);
-}
 
 /**
  * amdgpu_debugfs_process_reg_op - Handle MMIO register reads/writes
@@ -1738,7 +1659,6 @@ int amdgpu_debugfs_init(struct amdgpu_device *adev)
 	}
 
 	amdgpu_ras_debugfs_create_all(adev);
-	amdgpu_debugfs_autodump_init(adev);
 	amdgpu_rap_debugfs_init(adev);
 	amdgpu_securedisplay_debugfs_init(adev);
 	amdgpu_fw_attestation_debugfs_init(adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.h
index 6d4965b2d01e..371a6f0deb29 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.h
@@ -25,10 +25,6 @@
 /*
  * Debugfs
  */
-struct amdgpu_autodump {
-	struct completion		dumping;
-	struct wait_queue_head		gpu_hang;
-};
 
 int amdgpu_debugfs_regs_init(struct amdgpu_device *adev);
 int amdgpu_debugfs_init(struct amdgpu_device *adev);
@@ -36,4 +32,3 @@ void amdgpu_debugfs_fini(struct amdgpu_device *adev);
 void amdgpu_debugfs_fence_init(struct amdgpu_device *adev);
 void amdgpu_debugfs_firmware_init(struct amdgpu_device *adev);
 void amdgpu_debugfs_gem_init(struct amdgpu_device *adev);
-int amdgpu_debugfs_wait_dump(struct amdgpu_device *adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 221520f375d4..0207b25c2e6e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4440,10 +4440,6 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 	if (reset_context->reset_req_dev == adev)
 		job = reset_context->job;
 
-	/* no need to dump if device is not in good state during probe period */
-	if (!adev->gmc.xgmi.pending_reset)
-		amdgpu_debugfs_wait_dump(adev);
-
 	if (amdgpu_sriov_vf(adev)) {
 		/* stop the data exchange thread */
 		amdgpu_virt_fini_data_exchange(adev);

