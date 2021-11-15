Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD82745139B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348509AbhKOTxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343681AbhKOTVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1F70635C8;
        Mon, 15 Nov 2021 18:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001865;
        bh=762W2ySzXJ8AkGqqsv/M3SRRFaBMmh8Q8wG0iq/f+Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E63bP37nvSgwuPC6DTctNErhsCOoBMKbsapeHYQhvwCjJdxHAE6gWZ/jb1nELrG7w
         jACgeQGx838pWRBjYGby23Cm79yxPHRGuAGcrZk3M7+a0JCa489c1hQWstkTMu6gQp
         zutit+p2hDFvyb3iai8aIJPUq9kRravUlW7k5hv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Leslie Shi <Yuliang.Shi@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 351/917] drm/amdgpu: move amdgpu_virt_release_full_gpu to fini_early stage
Date:   Mon, 15 Nov 2021 17:57:26 +0100
Message-Id: <20211115165440.653827282@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 5b88c873c8a89..f7a98e9e68d88 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2745,6 +2745,11 @@ static int amdgpu_device_ip_fini_early(struct amdgpu_device *adev)
 		adev->ip_blocks[i].status.hw = false;
 	}
 
+	if (amdgpu_sriov_vf(adev)) {
+		if (amdgpu_virt_release_full_gpu(adev, false))
+			DRM_ERROR("failed to release exclusive mode on fini\n");
+	}
+
 	return 0;
 }
 
@@ -2805,10 +2810,6 @@ static int amdgpu_device_ip_fini(struct amdgpu_device *adev)
 
 	amdgpu_ras_fini(adev);
 
-	if (amdgpu_sriov_vf(adev))
-		if (amdgpu_virt_release_full_gpu(adev, false))
-			DRM_ERROR("failed to release exclusive mode on fini\n");
-
 	return 0;
 }
 
-- 
2.33.0



