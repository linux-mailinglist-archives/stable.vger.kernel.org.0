Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8642170FA
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729928AbgGGPW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbgGGPW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AE37206F6;
        Tue,  7 Jul 2020 15:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135377;
        bh=eHe6y0CVgk2X4XbqPeMFpPp2xFnQjmkyetTp9z/A3j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEHB1opDPipUrn2jRe1nnLMVuCHXEARISVdXPG+Q7cLK5EskEbncGdWY/pzcJZ5iL
         BSCTW4GRKXRmHXb0LY4LY3tvWlX2zeuw5Ph3EuSZgshDhCLJrP02K96J2BWYL576XA
         CUZWBPQ49npNulFvK8tXCUV7nQjNL3NLnnXHzrSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hawking Zhang <Hawking.Zhang@amd.com>,
        John Clements <john.clements@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 017/112] drm/amdgpu: disable ras query and iject during gpu reset
Date:   Tue,  7 Jul 2020 17:16:22 +0200
Message-Id: <20200707145801.815558286@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Clements <john.clements@amd.com>

[ Upstream commit 61380faa4b4cc577df8a7ff5db5859bac6b351f7 ]

added flag to ras context to indicate if ras query functionality is ready

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: John Clements <john.clements@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  3 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c    | 24 +++++++++++++++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h    |  4 ++++
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index affde2de2a0db..59288653412db 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4091,6 +4091,8 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	need_full_reset = job_signaled = false;
 	INIT_LIST_HEAD(&device_list);
 
+	amdgpu_ras_set_error_query_ready(adev, false);
+
 	dev_info(adev->dev, "GPU %s begin!\n",
 		(in_ras_intr && !use_baco) ? "jobs stop":"reset");
 
@@ -4147,6 +4149,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	/* block all schedulers and reset given job's ring */
 	list_for_each_entry(tmp_adev, device_list_handle, gmc.xgmi.head) {
 		if (tmp_adev != adev) {
+			amdgpu_ras_set_error_query_ready(tmp_adev, false);
 			amdgpu_device_lock_adev(tmp_adev, false);
 			if (!amdgpu_sriov_vf(tmp_adev))
 			                amdgpu_amdkfd_pre_reset(tmp_adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index ab379b44679cc..aa6148d12d5a4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -80,6 +80,20 @@ atomic_t amdgpu_ras_in_intr = ATOMIC_INIT(0);
 static bool amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
 				uint64_t addr);
 
+void amdgpu_ras_set_error_query_ready(struct amdgpu_device *adev, bool ready)
+{
+	if (adev)
+		amdgpu_ras_get_context(adev)->error_query_ready = ready;
+}
+
+bool amdgpu_ras_get_error_query_ready(struct amdgpu_device *adev)
+{
+	if (adev)
+		return amdgpu_ras_get_context(adev)->error_query_ready;
+
+	return false;
+}
+
 static ssize_t amdgpu_ras_debugfs_read(struct file *f, char __user *buf,
 					size_t size, loff_t *pos)
 {
@@ -281,7 +295,7 @@ static ssize_t amdgpu_ras_debugfs_ctrl_write(struct file *f, const char __user *
 	struct ras_debug_if data;
 	int ret = 0;
 
-	if (amdgpu_ras_intr_triggered()) {
+	if (!amdgpu_ras_get_error_query_ready(adev)) {
 		DRM_WARN("RAS WARN: error injection currently inaccessible\n");
 		return size;
 	}
@@ -399,7 +413,7 @@ static ssize_t amdgpu_ras_sysfs_read(struct device *dev,
 		.head = obj->head,
 	};
 
-	if (amdgpu_ras_intr_triggered())
+	if (!amdgpu_ras_get_error_query_ready(obj->adev))
 		return snprintf(buf, PAGE_SIZE,
 				"Query currently inaccessible\n");
 
@@ -1896,8 +1910,10 @@ int amdgpu_ras_late_init(struct amdgpu_device *adev,
 	}
 
 	/* in resume phase, no need to create ras fs node */
-	if (adev->in_suspend || adev->in_gpu_reset)
+	if (adev->in_suspend || adev->in_gpu_reset) {
+		amdgpu_ras_set_error_query_ready(adev, true);
 		return 0;
+	}
 
 	if (ih_info->cb) {
 		r = amdgpu_ras_interrupt_add_handler(adev, ih_info);
@@ -1909,6 +1925,8 @@ int amdgpu_ras_late_init(struct amdgpu_device *adev,
 	if (r)
 		goto sysfs;
 
+	amdgpu_ras_set_error_query_ready(adev, true);
+
 	return 0;
 cleanup:
 	amdgpu_ras_sysfs_remove(adev, ras_block);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
index 55c3eceb390d4..e7df5d8429f82 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
@@ -334,6 +334,8 @@ struct amdgpu_ras {
 	uint32_t flags;
 	bool reboot;
 	struct amdgpu_ras_eeprom_control eeprom_control;
+
+	bool error_query_ready;
 };
 
 struct ras_fs_data {
@@ -629,4 +631,6 @@ static inline void amdgpu_ras_intr_cleared(void)
 
 void amdgpu_ras_global_ras_isr(struct amdgpu_device *adev);
 
+void amdgpu_ras_set_error_query_ready(struct amdgpu_device *adev, bool ready);
+
 #endif
-- 
2.25.1



