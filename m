Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24042F7D6B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbfKKS4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:56:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbfKKS4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:56:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 840F52184C;
        Mon, 11 Nov 2019 18:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498592;
        bh=fnvCyuzWa8dcVt7gPXXH3w5RLjFVoBejn1wjVcjPlYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pka3xhufDf/DxwtrWcFf5Ng4IUUxywcYTm0bk33XBeZIV8CwzHXPI2mLWWtkHoIWD
         YpqoJxL3MAhqci/LB7TbbwvEaWBB+7kk30NuarmV2ebgN869oidMxjYLTfjod/ZnRl
         B7X7cS50rwsPoQMTzBEwwONe/ozgl/Z9xeqR6Rl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 165/193] drm/sched: Set error to s_fence if HW job submission failed.
Date:   Mon, 11 Nov 2019 19:29:07 +0100
Message-Id: <20191111181513.301498679@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit 167bf96014a095753053595f3224fcdeb49ac3c8 ]

Problem:
When run_job fails and HW fence returned is NULL we still signal
the s_fence to avoid hangs but the user has no way of knowing if
the actual HW job was ran and finished.

Fix:
Allow .run_job implementations to return ERR_PTR in the fence pointer
returned and then set this error for s_fence->finished fence so whoever
wait on this fence can inspect the signaled fence for an error.

Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_main.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index c1058eece16b4..27e6449da24ad 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -478,6 +478,7 @@ void drm_sched_resubmit_jobs(struct drm_gpu_scheduler *sched)
 	struct drm_sched_job *s_job, *tmp;
 	uint64_t guilty_context;
 	bool found_guilty = false;
+	struct dma_fence *fence;
 
 	list_for_each_entry_safe(s_job, tmp, &sched->ring_mirror_list, node) {
 		struct drm_sched_fence *s_fence = s_job->s_fence;
@@ -491,7 +492,16 @@ void drm_sched_resubmit_jobs(struct drm_gpu_scheduler *sched)
 			dma_fence_set_error(&s_fence->finished, -ECANCELED);
 
 		dma_fence_put(s_job->s_fence->parent);
-		s_job->s_fence->parent = sched->ops->run_job(s_job);
+		fence = sched->ops->run_job(s_job);
+
+		if (IS_ERR_OR_NULL(fence)) {
+			s_job->s_fence->parent = NULL;
+			dma_fence_set_error(&s_fence->finished, PTR_ERR(fence));
+		} else {
+			s_job->s_fence->parent = fence;
+		}
+
+
 	}
 }
 EXPORT_SYMBOL(drm_sched_resubmit_jobs);
@@ -719,7 +729,7 @@ static int drm_sched_main(void *param)
 		fence = sched->ops->run_job(sched_job);
 		drm_sched_fence_scheduled(s_fence);
 
-		if (fence) {
+		if (!IS_ERR_OR_NULL(fence)) {
 			s_fence->parent = dma_fence_get(fence);
 			r = dma_fence_add_callback(fence, &sched_job->cb,
 						   drm_sched_process_job);
@@ -729,8 +739,11 @@ static int drm_sched_main(void *param)
 				DRM_ERROR("fence add callback failed (%d)\n",
 					  r);
 			dma_fence_put(fence);
-		} else
+		} else {
+
+			dma_fence_set_error(&s_fence->finished, PTR_ERR(fence));
 			drm_sched_process_job(NULL, &sched_job->cb);
+		}
 
 		wake_up(&sched->job_scheduled);
 	}
-- 
2.20.1



