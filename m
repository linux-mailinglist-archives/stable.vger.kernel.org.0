Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0D33CA825
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241122AbhGOS6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241637AbhGOS5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4394C613D8;
        Thu, 15 Jul 2021 18:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375296;
        bh=LmPYPspyED4WBFtx+BnP0s9Gg5Ua+lcvDotTG9WIFAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RR0PMtZ2CfxOfgJQRmvP/zdIDip+jnXy561eprek49Ant/tsgprG3pi0KSabqtX+A
         yKOpSWdKpBUdxbc6mdCgWMuCS3aFim/ZX3wt4bVhBsnTKv4AhBfRYVkVyhUsGdSnEh
         B0ZYa7JpYdFcqgokGSCxXoasWyROVRkzJTOT9C40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 009/242] drm/amdgpu: change the default timeout for kernel compute queues
Date:   Thu, 15 Jul 2021 20:36:11 +0200
Message-Id: <20210715182553.434744203@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 67387dfe0f6630f2d4f412ce77debec23a49db7a ]

Change to 60s.  This matches what we already do in virtualization.
Infinite timeout can lead to deadlocks in the kernel.

Reviewed-by: Christian König <christian.koenig@amd.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 8 +++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    | 4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index a32b41e4c24e..1b69aa74056d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3141,8 +3141,8 @@ static int amdgpu_device_get_job_timeout_settings(struct amdgpu_device *adev)
 	int ret = 0;
 
 	/*
-	 * By default timeout for non compute jobs is 10000.
-	 * And there is no timeout enforced on compute jobs.
+	 * By default timeout for non compute jobs is 10000
+	 * and 60000 for compute jobs.
 	 * In SR-IOV or passthrough mode, timeout for compute
 	 * jobs are 60000 by default.
 	 */
@@ -3151,10 +3151,8 @@ static int amdgpu_device_get_job_timeout_settings(struct amdgpu_device *adev)
 	if (amdgpu_sriov_vf(adev))
 		adev->compute_timeout = amdgpu_sriov_is_pp_one_vf(adev) ?
 					msecs_to_jiffies(60000) : msecs_to_jiffies(10000);
-	else if (amdgpu_passthrough(adev))
-		adev->compute_timeout =  msecs_to_jiffies(60000);
 	else
-		adev->compute_timeout = MAX_SCHEDULE_TIMEOUT;
+		adev->compute_timeout =  msecs_to_jiffies(60000);
 
 	if (strnlen(input, AMDGPU_MAX_TIMEOUT_PARAM_LENGTH)) {
 		while ((timeout_setting = strsep(&input, ",")) &&
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index e92e7dea71da..f9728ee10298 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -272,9 +272,9 @@ module_param_named(msi, amdgpu_msi, int, 0444);
  *   for SDMA and Video.
  *
  * By default(with no lockup_timeout settings), the timeout for all non-compute(GFX, SDMA and Video)
- * jobs is 10000. And there is no timeout enforced on compute jobs.
+ * jobs is 10000. The timeout for compute is 60000.
  */
-MODULE_PARM_DESC(lockup_timeout, "GPU lockup timeout in ms (default: for bare metal 10000 for non-compute jobs and infinity timeout for compute jobs; "
+MODULE_PARM_DESC(lockup_timeout, "GPU lockup timeout in ms (default: for bare metal 10000 for non-compute jobs and 60000 for compute jobs; "
 		"for passthrough or sriov, 10000 for all jobs."
 		" 0: keep default value. negative: infinity timeout), "
 		"format: for bare metal [Non-Compute] or [GFX,Compute,SDMA,Video]; "
-- 
2.30.2



