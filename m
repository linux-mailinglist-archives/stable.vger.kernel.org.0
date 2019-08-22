Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7220899A95
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390547AbfHVRIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388965AbfHVRIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:50 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9731C23426;
        Thu, 22 Aug 2019 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493729;
        bh=Qy8p0t2orEtpqAiJVyCKiKQTIy0DM+ggYlbtmfpPT8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVK4qGGW6m3TcEtDSRDFJfyPFnk+F6N7FGTHJDV93/rodUeiOgd5GSf3H289g0khL
         HCikcTUX2oRvGTtP/RyD/0+mlEo+qKDy5VsGVvdNwyMMV2fRDkb0MWAjlApZFV68Ux
         VJMhawNIPFeyB8lcPtc16K7YaIz50istqG13r5Vs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chunming Zhou <david1.zhou@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 065/135] drm/amdgpu: fix error handling in amdgpu_cs_process_fence_dep
Date:   Thu, 22 Aug 2019 13:07:01 -0400
Message-Id: <20190822170811.13303-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 67d0859e2758ef992fd32499747ce4b1038a63c0 ]

We always need to drop the ctx reference and should check
for errors first and then dereference the fence pointer.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Chunming Zhou <david1.zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 2f6239b6be6fe..fe028561dc0e6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1093,29 +1093,27 @@ static int amdgpu_cs_process_fence_dep(struct amdgpu_cs_parser *p,
 			return r;
 		}
 
-		fence = amdgpu_ctx_get_fence(ctx, entity,
-					     deps[i].handle);
+		fence = amdgpu_ctx_get_fence(ctx, entity, deps[i].handle);
+		amdgpu_ctx_put(ctx);
+
+		if (IS_ERR(fence))
+			return PTR_ERR(fence);
+		else if (!fence)
+			continue;
 
 		if (chunk->chunk_id == AMDGPU_CHUNK_ID_SCHEDULED_DEPENDENCIES) {
-			struct drm_sched_fence *s_fence = to_drm_sched_fence(fence);
+			struct drm_sched_fence *s_fence;
 			struct dma_fence *old = fence;
 
+			s_fence = to_drm_sched_fence(fence);
 			fence = dma_fence_get(&s_fence->scheduled);
 			dma_fence_put(old);
 		}
 
-		if (IS_ERR(fence)) {
-			r = PTR_ERR(fence);
-			amdgpu_ctx_put(ctx);
+		r = amdgpu_sync_fence(p->adev, &p->job->sync, fence, true);
+		dma_fence_put(fence);
+		if (r)
 			return r;
-		} else if (fence) {
-			r = amdgpu_sync_fence(p->adev, &p->job->sync, fence,
-					true);
-			dma_fence_put(fence);
-			amdgpu_ctx_put(ctx);
-			if (r)
-				return r;
-		}
 	}
 	return 0;
 }
-- 
2.20.1

