Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEAC1DE9D2
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730873AbgEVOvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730881AbgEVOvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:51:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A62022254;
        Fri, 22 May 2020 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159062;
        bh=iGPnBlo8kyfDPRdtZjoXDIN1J6IGdWFa/3J4cMiOiuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXu952wxgGcvxLtO1xvp1GziSDCDaIKTp+u0guNOyHs2b8t7AQ99rqq7M4yPTNEpG
         dmWuvFay4563ZVYU4IlLIOjE0WNgHQI2J1z83i7cytlNdekWZgaEaNCNqXqa1juOnY
         dqF/KXjjmQom2RS416/+a7Zo2I8L5lMKGLV9AMGA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Sierra <alex.sierra@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 15/32] drm/amdgpu: Use GEM obj reference for KFD BOs
Date:   Fri, 22 May 2020 10:50:27 -0400
Message-Id: <20200522145044.434677-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145044.434677-1-sashal@kernel.org>
References: <20200522145044.434677-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit 39b3128d7ffd44e400e581e6f49e88cb42bef9a1 ]

Releasing the AMDGPU BO ref directly leads to problems when BOs were
exported as DMA bufs. Releasing the GEM reference makes sure that the
AMDGPU/TTM BO is not freed too early.

Also take a GEM reference when importing BOs from DMABufs to keep
references to imported BOs balances properly.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 6d021ecc8d59..edb561baf8b9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1288,7 +1288,7 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 	}
 
 	/* Free the BO*/
-	amdgpu_bo_unref(&mem->bo);
+	drm_gem_object_put_unlocked(&mem->bo->tbo.base);
 	mutex_destroy(&mem->lock);
 	kfree(mem);
 
@@ -1630,7 +1630,8 @@ int amdgpu_amdkfd_gpuvm_import_dmabuf(struct kgd_dev *kgd,
 		AMDGPU_VM_PAGE_READABLE | AMDGPU_VM_PAGE_WRITEABLE |
 		AMDGPU_VM_PAGE_EXECUTABLE | AMDGPU_VM_MTYPE_NC;
 
-	(*mem)->bo = amdgpu_bo_ref(bo);
+	drm_gem_object_get(&bo->tbo.base);
+	(*mem)->bo = bo;
 	(*mem)->va = va;
 	(*mem)->domain = (bo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM) ?
 		AMDGPU_GEM_DOMAIN_VRAM : AMDGPU_GEM_DOMAIN_GTT;
-- 
2.25.1

