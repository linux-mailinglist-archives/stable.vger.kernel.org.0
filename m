Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375AD4454B3
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhKDORG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231635AbhKDOQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:16:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E7C611EF;
        Thu,  4 Nov 2021 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035251;
        bh=L1U6z4fVwqaJEeepLFZBZycIrYyaHbbtTJSdFwXDVBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVicYVJmeV3N8JFGG5IJyfD/XEbdats82WZrnPIi+F9rn0z2LHJbPSsVaDN0IgsDZ
         OfpoX5FZNtgV92bHwXEqFRcStm7+at0mZe+rrZCiaJcI4fxj27h8hqRRbASK7IoFmX
         j0nS7PcJpwGqXr2ZGZkz7GqOTcAu+Zqt4kHx5hrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nirmoy Das <nirmoy.das@amd.com>
Subject: [PATCH 5.15 09/12] drm/amdgpu: revert "Add autodump debugfs node for gpu reset v8"
Date:   Thu,  4 Nov 2021 15:12:35 +0100
Message-Id: <20211104141159.855173286@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
References: <20211104141159.551636584@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit c8365dbda056578eebe164bf110816b1a39b4b7f upstream.

This reverts commit 728e7e0cd61899208e924472b9e641dbeb0775c4.

Further discussion reveals that this feature is severely broken
and needs to be reverted ASAP.

GPU reset can never be delayed by userspace even for debugging or
otherwise we can run into in kernel deadlocks.

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Nirmoy Das <nirmoy.das@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h         |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |   80 ----------------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.h |    5 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c  |    4 -
 4 files changed, 91 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1078,8 +1078,6 @@ struct amdgpu_device {
 	char				product_name[32];
 	char				serial[20];
 
-	struct amdgpu_autodump		autodump;
-
 	atomic_t			throttling_logging_enabled;
 	struct ratelimit_state		throttling_logging_rs;
 	uint32_t                        ras_hw_enabled;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -27,7 +27,6 @@
 #include <linux/pci.h>
 #include <linux/uaccess.h>
 #include <linux/pm_runtime.h>
-#include <linux/poll.h>
 
 #include "amdgpu.h"
 #include "amdgpu_pm.h"
@@ -37,86 +36,8 @@
 #include "amdgpu_securedisplay.h"
 #include "amdgpu_fw_attestation.h"
 
-int amdgpu_debugfs_wait_dump(struct amdgpu_device *adev)
-{
-#if defined(CONFIG_DEBUG_FS)
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
 #if defined(CONFIG_DEBUG_FS)
 
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
-
 /**
  * amdgpu_debugfs_process_reg_op - Handle MMIO register reads/writes
  *
@@ -1588,7 +1509,6 @@ int amdgpu_debugfs_init(struct amdgpu_de
 	}
 
 	amdgpu_ras_debugfs_create_all(adev);
-	amdgpu_debugfs_autodump_init(adev);
 	amdgpu_rap_debugfs_init(adev);
 	amdgpu_securedisplay_debugfs_init(adev);
 	amdgpu_fw_attestation_debugfs_init(adev);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.h
@@ -26,10 +26,6 @@
 /*
  * Debugfs
  */
-struct amdgpu_autodump {
-	struct completion		dumping;
-	struct wait_queue_head		gpu_hang;
-};
 
 int amdgpu_debugfs_regs_init(struct amdgpu_device *adev);
 int amdgpu_debugfs_init(struct amdgpu_device *adev);
@@ -37,4 +33,3 @@ void amdgpu_debugfs_fini(struct amdgpu_d
 void amdgpu_debugfs_fence_init(struct amdgpu_device *adev);
 void amdgpu_debugfs_firmware_init(struct amdgpu_device *adev);
 void amdgpu_debugfs_gem_init(struct amdgpu_device *adev);
-int amdgpu_debugfs_wait_dump(struct amdgpu_device *adev);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4462,10 +4462,6 @@ int amdgpu_device_pre_asic_reset(struct
 	if (reset_context->reset_req_dev == adev)
 		job = reset_context->job;
 
-	/* no need to dump if device is not in good state during probe period */
-	if (!adev->gmc.xgmi.pending_reset)
-		amdgpu_debugfs_wait_dump(adev);
-
 	if (amdgpu_sriov_vf(adev)) {
 		/* stop the data exchange thread */
 		amdgpu_virt_fini_data_exchange(adev);


