Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BF244A076
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241711AbhKIBDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:03:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241630AbhKIBD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:03:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB46D6120D;
        Tue,  9 Nov 2021 01:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419644;
        bh=YN6xwZy/paczEow3ObgEpQ6WyRCEARqtGbMo+1NGYVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTdeAr4C/e18PkXscMa8cP0dGtuWKZIamFCh5PiBWexnbZdNIgMv02JgeVmm/WbGQ
         Gs+YM2zJJYE7zpZs7ebokTFIeIfM9wWt9xswDSBAaP2kSIOrR6Fo+9oJ+/8+a/3BMB
         7UQ0Gm7sFDC/u8ziUwhhe/VaBxnwAvcqFqmg7GWTjb/1HfrxV8aLyT0HS2KMCeiJVU
         0Lf5FwAaPfE5KeysJ8WGtaILSmdGd/ypGw4R9/Mggp6izvp+81eUwixAfAmRaGU9KG
         8Xf2XIi0lu2TKmfkOpgOesM18sfhvGpqGAIq7N1ybXF5BAodxiAOQETYS3KkuWspSn
         3ohB8QGjtJ0aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        leo.liu@amd.com, lee.jones@linaro.org, guchun.chen@amd.com,
        satyajit.sahu@amd.com, Oak.Zeng@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 028/146] drm/amdgpu: Fix MMIO access page fault
Date:   Mon,  8 Nov 2021 12:42:55 -0500
Message-Id: <20211108174453.1187052-28-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit c03509cbc01559549700e14c4a6239f2572ab4ba ]

Add more guards to MMIO access post device
unbind/unplug

Bug: https://bugs.archlinux.org/task/72092?project=1&order=dateopened&sort=desc&pagenum=1
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c |  8 ++++++--
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c | 17 +++++++++++------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
index f4686e918e0d1..c405075a572c1 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/firmware.h>
+#include <drm/drm_drv.h>
 
 #include "amdgpu.h"
 #include "amdgpu_vcn.h"
@@ -192,11 +193,14 @@ static int vcn_v2_0_sw_init(void *handle)
  */
 static int vcn_v2_0_sw_fini(void *handle)
 {
-	int r;
+	int r, idx;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	volatile struct amdgpu_fw_shared *fw_shared = adev->vcn.inst->fw_shared_cpu_addr;
 
-	fw_shared->present_flag_0 = 0;
+	if (drm_dev_enter(&adev->ddev, &idx)) {
+		fw_shared->present_flag_0 = 0;
+		drm_dev_exit(idx);
+	}
 
 	amdgpu_virt_free_mm_table(adev);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
index e0c0c3734432e..a0956d8623770 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/firmware.h>
+#include <drm/drm_drv.h>
 
 #include "amdgpu.h"
 #include "amdgpu_vcn.h"
@@ -233,17 +234,21 @@ static int vcn_v2_5_sw_init(void *handle)
  */
 static int vcn_v2_5_sw_fini(void *handle)
 {
-	int i, r;
+	int i, r, idx;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	volatile struct amdgpu_fw_shared *fw_shared;
 
-	for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
-		if (adev->vcn.harvest_config & (1 << i))
-			continue;
-		fw_shared = adev->vcn.inst[i].fw_shared_cpu_addr;
-		fw_shared->present_flag_0 = 0;
+	if (drm_dev_enter(&adev->ddev, &idx)) {
+		for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
+			if (adev->vcn.harvest_config & (1 << i))
+				continue;
+			fw_shared = adev->vcn.inst[i].fw_shared_cpu_addr;
+			fw_shared->present_flag_0 = 0;
+		}
+		drm_dev_exit(idx);
 	}
 
+
 	if (amdgpu_sriov_vf(adev))
 		amdgpu_virt_free_mm_table(adev);
 
-- 
2.33.0

