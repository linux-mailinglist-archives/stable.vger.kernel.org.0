Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD0F3BCED7
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbhGFL1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234617AbhGFLYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FA1C61D09;
        Tue,  6 Jul 2021 11:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570324;
        bh=LmPYPspyED4WBFtx+BnP0s9Gg5Ua+lcvDotTG9WIFAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOuhUcqF3cWAmPfTlmKNa74aEdfKLF/l40Ad9tJ27vKNK4r1Jf7PqH2mYyibcUivN
         /BAOmKzPF1hIRTI05mi4dI38W2nGY1G7zz/fVUgczoXYWqoF8HpwuSUoE6VqWU9O3l
         hsgcn5ZphCboPQRxUBy0d6MFyfi87nxIGobhNh/CuvBJ/9gqOfdGA6Wyxs31UhPyrj
         PYkJgPp1hhgJvq7iTkNt31dwZjaSg7sY12VMhCw/mo+QDGJEn7OoJTu7+Egvi8IBOW
         mg1/IVTUGSET+JbJH0IPC1iVlKWNutaQ8WJLANDHZeObG5yhbSwTXCaZn5Y/ICu9Vr
         9pwHBRIOphRjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 012/160] drm/amdgpu: change the default timeout for kernel compute queues
Date:   Tue,  6 Jul 2021 07:15:58 -0400
Message-Id: <20210706111827.2060499-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

