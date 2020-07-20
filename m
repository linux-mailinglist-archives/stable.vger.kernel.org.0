Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F57722708B
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGTVhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgGTVht (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:37:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DBED207FC;
        Mon, 20 Jul 2020 21:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281069;
        bh=/r7CpAbdOGh79gtbW0/Th7l8+bvwG0+jXqRwWEGze1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OS13EzL1ms2o5J1vpI9lX2Ostm55AznYoNryBaT+VX2uMoGUjt2rvQEfZbxH3r8cy
         xyJJMYNLcRbgOB/0XmlHza+2yT2xjyiUS+77W8yIrd2aGo1f9+N09o8+eLn2o48NEN
         A+0H41RJ9sSmuGbY8uCjzr1i5nEnUU7qGJCPa/qM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Xiao <Jack.Xiao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 27/40] drm/amdgpu: fix preemption unit test
Date:   Mon, 20 Jul 2020 17:37:02 -0400
Message-Id: <20200720213715.406997-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Xiao <Jack.Xiao@amd.com>

[ Upstream commit d845a2051b6b673fab4229b920ea04c7c4352b51 ]

Remove signaled jobs from job list and ensure the
job was indeed preempted.

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index c0f9a651dc067..92b18c4760e55 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1156,27 +1156,37 @@ static void amdgpu_ib_preempt_job_recovery(struct drm_gpu_scheduler *sched)
 static void amdgpu_ib_preempt_mark_partial_job(struct amdgpu_ring *ring)
 {
 	struct amdgpu_job *job;
-	struct drm_sched_job *s_job;
+	struct drm_sched_job *s_job, *tmp;
 	uint32_t preempt_seq;
 	struct dma_fence *fence, **ptr;
 	struct amdgpu_fence_driver *drv = &ring->fence_drv;
 	struct drm_gpu_scheduler *sched = &ring->sched;
+	bool preempted = true;
 
 	if (ring->funcs->type != AMDGPU_RING_TYPE_GFX)
 		return;
 
 	preempt_seq = le32_to_cpu(*(drv->cpu_addr + 2));
-	if (preempt_seq <= atomic_read(&drv->last_seq))
-		return;
+	if (preempt_seq <= atomic_read(&drv->last_seq)) {
+		preempted = false;
+		goto no_preempt;
+	}
 
 	preempt_seq &= drv->num_fences_mask;
 	ptr = &drv->fences[preempt_seq];
 	fence = rcu_dereference_protected(*ptr, 1);
 
+no_preempt:
 	spin_lock(&sched->job_list_lock);
-	list_for_each_entry(s_job, &sched->ring_mirror_list, node) {
+	list_for_each_entry_safe(s_job, tmp, &sched->ring_mirror_list, node) {
+		if (dma_fence_is_signaled(&s_job->s_fence->finished)) {
+			/* remove job from ring_mirror_list */
+			list_del_init(&s_job->node);
+			sched->ops->free_job(s_job);
+			continue;
+		}
 		job = to_amdgpu_job(s_job);
-		if (job->fence == fence)
+		if (preempted && job->fence == fence)
 			/* mark the job as preempted */
 			job->preemption_status |= AMDGPU_IB_PREEMPTED;
 	}
-- 
2.25.1

