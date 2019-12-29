Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE8112C995
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbfL2SLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730524AbfL2Rni (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00E9B206DB;
        Sun, 29 Dec 2019 17:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641418;
        bh=b4TYEKpTjj3JK8aLca+P4diJxJLE7+o50evVFx5Jrks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQlnE8Z8F1hTSoldl87EvruoY2DfUkHZtAgNC2k7ddshzyhQ/kOUFujy6XtQZvTmq
         pFdYM3dJTAnDjZxbyQ42snTJgwW/FrUEY5+G3JxQmTTx3jw6LR8HjJo8rxsbm0QW19
         ljydQ5gtO4gWNn+RWnh8nC8hx/XvL5G1nr9IU7OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chunming Zhou <david1.zhou@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/434] drm/amdgpu: grab the id mgr lock while accessing passid_mapping
Date:   Sun, 29 Dec 2019 18:21:49 +0100
Message-Id: <20191229172705.595354845@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5251352f5922..7700c32dd743 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1034,10 +1034,8 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_
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
 
@@ -1047,6 +1045,12 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_
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
@@ -1086,9 +1090,11 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_
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



