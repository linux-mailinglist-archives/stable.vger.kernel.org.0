Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F83C22EF74
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbgG0OQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730909AbgG0OQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:16:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABD512070A;
        Mon, 27 Jul 2020 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859399;
        bh=QSI+nFYT3BU7ERKo1L3AE5VUAt/RWgJY17WCjL8DwpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ngp9lU3U/ouGMnd35UlVKAoP5FUX15A/xnmmGRjWbkD+oWBFqOKF1QyM65Dkad21
         3U1YQv/7nUbf9wQEf5C07TjHjwtOWh5Sdnb3Ck1OwGeHG/EVHfVsxJnlfrtIuGCBWf
         A352IsDvNm6OljcWhd52+i3otz/gpYFtGUNeZnf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Xiao <Jack.Xiao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/138] drm/amdgpu: fix preemption unit test
Date:   Mon, 27 Jul 2020 16:04:47 +0200
Message-Id: <20200727134929.965823747@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1e25ca34d876c..700e26b69abca 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -990,27 +990,37 @@ static void amdgpu_ib_preempt_job_recovery(struct drm_gpu_scheduler *sched)
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



