Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B9C329139
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242653AbhCAUWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236721AbhCAUNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D66A653CA;
        Mon,  1 Mar 2021 18:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621721;
        bh=pDOYhUyKUrcCscFjzK8MVQMtVIES3RKkJQv1iTVnHWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxZRMKUySRaLjpQMjfJy9lSCiUw5LkbrtgQH5VDUhkBwZP8XKGl7KRqsFAE82oqsS
         Zhqz7y+7GQNQwFo2jTJCc7XgRpuY9o9ectLBVtDoD6SIR/KAfAo7FctUe4ZlfVKrVA
         l3h3obgMBU3J22RIfyKHz5obGkBeYasl4Jkv3+X4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Prike Liang <Prike.Liang@amd.com>
Subject: [PATCH 5.11 619/775] drm/amdgpu: fix shutdown and poweroff process failed with s0ix
Date:   Mon,  1 Mar 2021 17:13:07 +0100
Message-Id: <20210301161231.989782136@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

commit b092b19602cfd47de1eeeb3a1b03822afd86b136 upstream.

In the shutdown and poweroff opt on the s0i3 system we still need
un-gate the gfx clock gating and power gating before destory amdgpu device.

Fixes: 628c36d7b238e2 ("drm/amdgpu: update amdgpu device suspend/resume sequence for s0i3 support")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1499
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |    6 ++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    6 ++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    |    9 ++++++++-
 3 files changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1003,6 +1003,12 @@ struct amdgpu_device {
 	bool                            in_suspend;
 	bool				in_hibernate;
 
+	/*
+	 * The combination flag in_poweroff_reboot_com used to identify the poweroff
+	 * and reboot opt in the s0i3 system-wide suspend.
+	 */
+	bool 				in_poweroff_reboot_com;
+
 	atomic_t 			in_gpu_reset;
 	enum pp_mp1_state               mp1_state;
 	struct rw_semaphore reset_sem;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2666,7 +2666,8 @@ static int amdgpu_device_ip_suspend_phas
 {
 	int i, r;
 
-	if (!amdgpu_acpi_is_s0ix_supported(adev) || amdgpu_in_reset(adev)) {
+	if (adev->in_poweroff_reboot_com ||
+	    !amdgpu_acpi_is_s0ix_supported(adev) || amdgpu_in_reset(adev)) {
 		amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
 		amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
 	}
@@ -3726,7 +3727,8 @@ int amdgpu_device_suspend(struct drm_dev
 
 	amdgpu_fence_driver_suspend(adev);
 
-	if (!amdgpu_acpi_is_s0ix_supported(adev) || amdgpu_in_reset(adev))
+	if (adev->in_poweroff_reboot_com ||
+	    !amdgpu_acpi_is_s0ix_supported(adev) || amdgpu_in_reset(adev))
 		r = amdgpu_device_ip_suspend_phase2(adev);
 	else
 		amdgpu_gfx_state_change_set(adev, sGpuChangeState_D3Entry);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1266,7 +1266,9 @@ amdgpu_pci_shutdown(struct pci_dev *pdev
 	 */
 	if (!amdgpu_passthrough(adev))
 		adev->mp1_state = PP_MP1_STATE_UNLOAD;
+	adev->in_poweroff_reboot_com = true;
 	amdgpu_device_ip_suspend(adev);
+	adev->in_poweroff_reboot_com = false;
 	adev->mp1_state = PP_MP1_STATE_NONE;
 }
 
@@ -1308,8 +1310,13 @@ static int amdgpu_pmops_thaw(struct devi
 static int amdgpu_pmops_poweroff(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
+	struct amdgpu_device *adev = drm_to_adev(drm_dev);
+	int r;
 
-	return amdgpu_device_suspend(drm_dev, true);
+	adev->in_poweroff_reboot_com = true;
+	r =  amdgpu_device_suspend(drm_dev, true);
+	adev->in_poweroff_reboot_com = false;
+	return r;
 }
 
 static int amdgpu_pmops_restore(struct device *dev)


