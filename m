Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC60111C56
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbfLCWm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:42:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728738AbfLCWm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:42:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAAD320803;
        Tue,  3 Dec 2019 22:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412978;
        bh=b/K4573lT1m1rjcTQI/G5X4LvK07LO0gE+dvSXDdXEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6xNcl3T160D2BNZfqPGpVPadswKThqmFa6VRUZC6ddpliaEj5+0JE/rfMSzfFS3O
         i9BXRIKGE65qOW7+afTYFnST0MVbiFVlV+Y3rr80cVk/4cODxXeYfzTMajQHAMfCoD
         Hm2I64J7nmo0/I5zPAEBkuu/plg7H4HZl7a17SVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 082/135] drm/amdgpu: register gpu instance before fan boost feature enablment
Date:   Tue,  3 Dec 2019 23:35:22 +0100
Message-Id: <20191203213031.952845802@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 6a299d7aaa97dfde5988d8f9e2fa2c046b5793ff ]

Otherwise, the feature enablement will be skipped due to wrong count.

Fixes: beff74bc6e0fa91 ("drm/amdgpu: fix a race in GPU reset with IB test (v2)")
Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 7 +++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c    | 1 -
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 5a7f893cf7244..2877ce84aef2b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2788,6 +2788,13 @@ fence_driver_init:
 			DRM_INFO("amdgpu: acceleration disabled, skipping benchmarks\n");
 	}
 
+	/*
+	 * Register gpu instance before amdgpu_device_enable_mgpu_fan_boost.
+	 * Otherwise the mgpu fan boost feature will be skipped due to the
+	 * gpu instance is counted less.
+	 */
+	amdgpu_register_gpu_instance(adev);
+
 	/* enable clockgating, etc. after ib tests, etc. since some blocks require
 	 * explicit gating rather than handling it automatically.
 	 */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 65f6619f0c0c4..e531ba9195a0f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -190,7 +190,6 @@ int amdgpu_driver_load_kms(struct drm_device *dev, unsigned long flags)
 		pm_runtime_put_autosuspend(dev->dev);
 	}
 
-	amdgpu_register_gpu_instance(adev);
 out:
 	if (r) {
 		/* balance pm_runtime_get_sync in amdgpu_driver_unload_kms */
-- 
2.20.1



