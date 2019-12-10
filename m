Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095021196DF
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfLJV3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:29:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728359AbfLJVKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D147524680;
        Tue, 10 Dec 2019 21:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012204;
        bh=bwDrjo4VRhKkKgsT4Y++69KYcmNh0F14L3E37LzRuGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2vCdEKzC67ZGv7kIBY6JAacg3zsM80RXytl1ve80DUaf76DxKBQEPlsLtNoLQtxj
         WPE93vPtLt0ECqt0bAXaF5Z882ai7u5awohN1xxZCs1VM8Yrs5g9ya8kX67eQeoQUX
         FhQpz6q59zUVwg1zpamQXw2auaFJpyKhFnGj7dGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steven Price <steven.price@arm.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 157/350] drm: Don't free jobs in wait_event_interruptible()
Date:   Tue, 10 Dec 2019 16:04:22 -0500
Message-Id: <20191210210735.9077-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index f39b97ed4ade4..2af64459b3d77 100644
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

