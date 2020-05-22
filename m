Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA241DEB1B
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbgEVOuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbgEVOuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:50:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3F8022227;
        Fri, 22 May 2020 14:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159021;
        bh=/5gUvaIeXL5/SvAcmLxJzXgwL0RfqCvuytXsSmHeWtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/bJFEsx/zNRrb8UlPdlo0OXT0y+C1kRBchYO1zMh7P6H3F95ptzUuLYbcX3Z5mNE
         DSfGcKOdQbmi4keNVkX9OOkgVgSF6xFGJmmLjoGoHLf1+r5MiXyvtF+28PF6Ay3CM7
         h/KFQT2vOAnLK1immSxVBP6EQopd+Xg+y8wMEW44=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Sierra <alex.sierra@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 19/41] drm/amdgpu: Use GEM obj reference for KFD BOs
Date:   Fri, 22 May 2020 10:49:36 -0400
Message-Id: <20200522144959.434379-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522144959.434379-1-sashal@kernel.org>
References: <20200522144959.434379-1-sashal@kernel.org>
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
index fa8ac9d19a7a..6326c1792270 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1304,7 +1304,7 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 	}
 
 	/* Free the BO*/
-	amdgpu_bo_unref(&mem->bo);
+	drm_gem_object_put_unlocked(&mem->bo->tbo.base);
 	mutex_destroy(&mem->lock);
 	kfree(mem);
 
@@ -1647,7 +1647,8 @@ int amdgpu_amdkfd_gpuvm_import_dmabuf(struct kgd_dev *kgd,
 		 ALLOC_MEM_FLAGS_VRAM : ALLOC_MEM_FLAGS_GTT) |
 		ALLOC_MEM_FLAGS_WRITABLE | ALLOC_MEM_FLAGS_EXECUTABLE;
 
-	(*mem)->bo = amdgpu_bo_ref(bo);
+	drm_gem_object_get(&bo->tbo.base);
+	(*mem)->bo = bo;
 	(*mem)->va = va;
 	(*mem)->domain = (bo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM) ?
 		AMDGPU_GEM_DOMAIN_VRAM : AMDGPU_GEM_DOMAIN_GTT;
-- 
2.25.1

