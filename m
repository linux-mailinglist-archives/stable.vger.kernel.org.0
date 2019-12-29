Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1726412C69E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731536AbfL2Rsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:48:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730855AbfL2Rsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:48:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F5C0207FD;
        Sun, 29 Dec 2019 17:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641732;
        bh=BMb8aSFa0ymGFpThUa9sw2CQH9f27gnSqqDzguCeN0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbZQbwSGflJCvK38hr9yjeHfArBMX4nhv456WLx3+zGeO7XkZ9Ww7Bh+dAmovXx/T
         nLA1WYQZMk06LXhPTtekC1kr1oYWopL3vqGtVWx26/D6edDLiVIGbvh3ZbPNu71VDV
         m2qJug0866MYucjCovM/OH3dtitPo76OMbt0TIbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Steven Price <steven.price@arm.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 186/434] drm: Dont free jobs in wait_event_interruptible()
Date:   Sun, 29 Dec 2019 18:23:59 +0100
Message-Id: <20191229172714.175026654@linuxfoundation.org>
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

From: Steven Price <steven.price@arm.com>

[ Upstream commit 588b9828f0744ca13555c4a35cd0251ac8ad8ad2 ]

drm_sched_cleanup_jobs() attempts to free finished jobs, however because
it is called as the condition of wait_event_interruptible() it must not
sleep. Unfortunately some free callbacks (notably for Panfrost) do sleep.

Instead let's rename drm_sched_cleanup_jobs() to
drm_sched_get_cleanup_job() and simply return a job for processing if
there is one. The caller can then call the free_job() callback outside
the wait_event_interruptible() where sleeping is possible before
re-checking and returning to sleep if necessary.

Tested-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Fixes: 5918045c4ed4 ("drm/scheduler: rework job destruction")
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/337652/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_main.c | 43 ++++++++++++++------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index f39b97ed4ade..2af64459b3d7 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -632,43 +632,41 @@ static void drm_sched_process_job(struct dma_fence *f, struct dma_fence_cb *cb)
 }
 
 /**
- * drm_sched_cleanup_jobs - destroy finished jobs
+ * drm_sched_get_cleanup_job - fetch the next finished job to be destroyed
  *
  * @sched: scheduler instance
  *
- * Remove all finished jobs from the mirror list and destroy them.
+ * Returns the next finished job from the mirror list (if there is one)
+ * ready for it to be destroyed.
  */
-static void drm_sched_cleanup_jobs(struct drm_gpu_scheduler *sched)
+static struct drm_sched_job *
+drm_sched_get_cleanup_job(struct drm_gpu_scheduler *sched)
 {
+	struct drm_sched_job *job;
 	unsigned long flags;
 
 	/* Don't destroy jobs while the timeout worker is running */
 	if (sched->timeout != MAX_SCHEDULE_TIMEOUT &&
 	    !cancel_delayed_work(&sched->work_tdr))
-		return;
-
+		return NULL;
 
-	while (!list_empty(&sched->ring_mirror_list)) {
-		struct drm_sched_job *job;
+	spin_lock_irqsave(&sched->job_list_lock, flags);
 
-		job = list_first_entry(&sched->ring_mirror_list,
+	job = list_first_entry_or_null(&sched->ring_mirror_list,
 				       struct drm_sched_job, node);
-		if (!dma_fence_is_signaled(&job->s_fence->finished))
-			break;
 
-		spin_lock_irqsave(&sched->job_list_lock, flags);
+	if (job && dma_fence_is_signaled(&job->s_fence->finished)) {
 		/* remove job from ring_mirror_list */
 		list_del_init(&job->node);
-		spin_unlock_irqrestore(&sched->job_list_lock, flags);
-
-		sched->ops->free_job(job);
+	} else {
+		job = NULL;
+		/* queue timeout for next job */
+		drm_sched_start_timeout(sched);
 	}
 
-	/* queue timeout for next job */
-	spin_lock_irqsave(&sched->job_list_lock, flags);
-	drm_sched_start_timeout(sched);
 	spin_unlock_irqrestore(&sched->job_list_lock, flags);
 
+	return job;
 }
 
 /**
@@ -708,12 +706,19 @@ static int drm_sched_main(void *param)
 		struct drm_sched_fence *s_fence;
 		struct drm_sched_job *sched_job;
 		struct dma_fence *fence;
+		struct drm_sched_job *cleanup_job = NULL;
 
 		wait_event_interruptible(sched->wake_up_worker,
-					 (drm_sched_cleanup_jobs(sched),
+					 (cleanup_job = drm_sched_get_cleanup_job(sched)) ||
 					 (!drm_sched_blocked(sched) &&
 					  (entity = drm_sched_select_entity(sched))) ||
-					 kthread_should_stop()));
+					 kthread_should_stop());
+
+		if (cleanup_job) {
+			sched->ops->free_job(cleanup_job);
+			/* queue timeout for next job */
+			drm_sched_start_timeout(sched);
+		}
 
 		if (!entity)
 			continue;
-- 
2.20.1



