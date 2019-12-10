Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D24119677
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfLJV1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:27:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729474AbfLJVZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:25:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B22921556;
        Tue, 10 Dec 2019 21:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013125;
        bh=pfweuhzheRT+MBCmUjZdFceQheS50mACzk1KJkOnWKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fj5PVfx7Brg76qVs9O6h6NNhNwU0N+QFbp4+Cke2SHSs670PE2s9rC5XxSjaLJwmR
         mDa9LoB5Gp+R5viLZPB80/2NniCNiil2Z7H9SeuwWCU3j0cQApS7LM836dhnFV3HRs
         cxgWff7TQXQ3VIujwbaQzAPNFKHsk0Lu2/14wR5Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chunming Zhou <david1.zhou@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 011/292] drm/amdgpu: grab the id mgr lock while accessing passid_mapping
Date:   Tue, 10 Dec 2019 16:20:30 -0500
Message-Id: <20191210212511.11392-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210212511.11392-1-sashal@kernel.org>
References: <20191210212511.11392-1-sashal@kernel.org>
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
index 24c3c05e2fb7d..4a7b2ffd3bfe3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1036,10 +1036,8 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_
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
 
@@ -1049,6 +1047,12 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_
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
@@ -1088,9 +1092,11 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_
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

