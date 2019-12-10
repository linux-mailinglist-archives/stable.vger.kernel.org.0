Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5E411999B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfLJVrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbfLJVc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:32:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA08A21556;
        Tue, 10 Dec 2019 21:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013548;
        bh=rnAF06ciDbzbqruYIqLqTiLgbm5Tt/iFKd+qYBb1bHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEOY8vLbeXgtzELfETrcZzO6FzgqXaoL8rF6yS2bbvupOPC2CQRwlr27EFrVJqmz+
         TjGD1KY+UNb9o58Y777yFNqrnhJlL+kOCLR4sZU3iBly1TuLkPcNlP4QGUg45mkuQv
         5e5ozPgyR7RMqyKm/La/qVdStd/U0X2PfAm4108c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chunming Zhou <david1.zhou@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 005/177] drm/amdgpu: grab the id mgr lock while accessing passid_mapping
Date:   Tue, 10 Dec 2019 16:29:29 -0500
Message-Id: <20191210213221.11921-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 6817bf283b2b851095825ec7f0e9f10398e09125 ]

Need to make sure that we actually dropping the right fence.
Could be done with RCU as well, but to complicated for a fix.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Chunming Zhou <david1.zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 49fe5084c53dd..69fb90d9c4855 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -700,10 +700,8 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_
 		id->oa_base != job->oa_base ||
 		id->oa_size != job->oa_size);
 	bool vm_flush_needed = job->vm_needs_flush;
-	bool pasid_mapping_needed = id->pasid != job->pasid ||
-		!id->pasid_mapping ||
-		!dma_fence_is_signaled(id->pasid_mapping);
 	struct dma_fence *fence = NULL;
+	bool pasid_mapping_needed;
 	unsigned patch_offset = 0;
 	int r;
 
@@ -713,6 +711,12 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_
 		pasid_mapping_needed = true;
 	}
 
+	mutex_lock(&id_mgr->lock);
+	if (id->pasid != job->pasid || !id->pasid_mapping ||
+	    !dma_fence_is_signaled(id->pasid_mapping))
+		pasid_mapping_needed = true;
+	mutex_unlock(&id_mgr->lock);
+
 	gds_switch_needed &= !!ring->funcs->emit_gds_switch;
 	vm_flush_needed &= !!ring->funcs->emit_vm_flush  &&
 			job->vm_pd_addr != AMDGPU_BO_INVALID_OFFSET;
@@ -752,9 +756,11 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_
 	}
 
 	if (pasid_mapping_needed) {
+		mutex_lock(&id_mgr->lock);
 		id->pasid = job->pasid;
 		dma_fence_put(id->pasid_mapping);
 		id->pasid_mapping = dma_fence_get(fence);
+		mutex_unlock(&id_mgr->lock);
 	}
 	dma_fence_put(fence);
 
-- 
2.20.1

