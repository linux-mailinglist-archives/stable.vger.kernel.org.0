Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9578545109B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241865AbhKOSvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:51:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242704AbhKOSs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:48:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A40166339A;
        Mon, 15 Nov 2021 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999699;
        bh=YK6nQqicA5Ub6Uf/Z0XiID/LRg17S2wdQFvnrG6WrOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxjTfW/2VQnkZuYIN3suM8p3DsNfQfJsE4nfOaL9BdD6GgHNRWtRQsHDHIWMWeWxq
         8uYgQotLR5VLP2N531Acw9smS16PT91j+TqlooocyXPdpYcl28w14jW2g7W1cq+rYv
         dL+uBFq7p3bSE+CXykZEbP3Sp92gSMmNVo6tBh/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Leslie Shi <Yuliang.Shi@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 358/849] drm/amdgpu: move amdgpu_virt_release_full_gpu to fini_early stage
Date:   Mon, 15 Nov 2021 17:57:21 +0100
Message-Id: <20211115165432.347802162@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 6effad8abe0ba4db3d9c58ed585127858a990f35 ]

adev->rmmio is set to be NULL in amdgpu_device_unmap_mmio to prevent
access after pci_remove, however, in SRIOV case, amdgpu_virt_release_full_gpu
will still use adev->rmmio for access after amdgpu_device_unmap_mmio.
The patch is to move such SRIOV calling earlier to fini_early stage.

Fixes: 07775fc13878 ("drm/amdgpu: Unmap all MMIO mappings")
Cc: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Signed-off-by: Leslie Shi <Yuliang.Shi@amd.com>
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 08e53ff747282..eddf03450f1ce 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2689,6 +2689,11 @@ static int amdgpu_device_ip_fini_early(struct amdgpu_device *adev)
 		adev->ip_blocks[i].status.hw = false;
 	}
 
+	if (amdgpu_sriov_vf(adev)) {
+		if (amdgpu_virt_release_full_gpu(adev, false))
+			DRM_ERROR("failed to release exclusive mode on fini\n");
+	}
+
 	return 0;
 }
 
@@ -2749,10 +2754,6 @@ static int amdgpu_device_ip_fini(struct amdgpu_device *adev)
 
 	amdgpu_ras_fini(adev);
 
-	if (amdgpu_sriov_vf(adev))
-		if (amdgpu_virt_release_full_gpu(adev, false))
-			DRM_ERROR("failed to release exclusive mode on fini\n");
-
 	return 0;
 }
 
-- 
2.33.0



