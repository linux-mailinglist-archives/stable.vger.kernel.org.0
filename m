Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6588281290
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 14:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387847AbgJBMZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 08:25:22 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49148 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387862AbgJBMZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Oct 2020 08:25:13 -0400
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id F33DD29B0E8;
        Fri,  2 Oct 2020 13:25:10 +0100 (BST)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] drm/panfrost: Fix job timeout handling
Date:   Fri,  2 Oct 2020 14:25:06 +0200
Message-Id: <20201002122506.1374183-1-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If more than two jobs end up timeout-ing concurrently, only one of them
(the one attached to the scheduler acquiring the lock) is fully handled.
The other one remains in a dangling state where it's no longer part of
the scheduling queue, but still blocks something in scheduler, leading
to repetitive timeouts when new jobs are queued.

Let's make sure all bad jobs are properly handled by the thread
acquiring the lock.

v3:
- Add Steven's R-b
- Don't take the sched_lock when stopping the schedulers

v2:
- Fix the subject prefix
- Stop the scheduler before returning from panfrost_job_timedout()
- Call cancel_delayed_work_sync() after drm_sched_stop() to make sure
  no timeout handlers are in flight when we reset the GPU (Steven Price)
- Make sure we release the reset lock before restarting the
  schedulers (Steven Price)

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 drivers/gpu/drm/panfrost/panfrost_job.c | 62 +++++++++++++++++++++----
 1 file changed, 53 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index 30e7b7196dab..d0469e944143 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -25,7 +25,8 @@
 
 struct panfrost_queue_state {
 	struct drm_gpu_scheduler sched;
-
+	bool stopped;
+	struct mutex lock;
 	u64 fence_context;
 	u64 emit_seqno;
 };
@@ -369,6 +370,24 @@ void panfrost_job_enable_interrupts(struct panfrost_device *pfdev)
 	job_write(pfdev, JOB_INT_MASK, irq_mask);
 }
 
+static bool panfrost_scheduler_stop(struct panfrost_queue_state *queue,
+				    struct drm_sched_job *bad)
+{
+	bool stopped = false;
+
+	mutex_lock(&queue->lock);
+	if (!queue->stopped) {
+		drm_sched_stop(&queue->sched, bad);
+		if (bad)
+			drm_sched_increase_karma(bad);
+		queue->stopped = true;
+		stopped = true;
+	}
+	mutex_unlock(&queue->lock);
+
+	return stopped;
+}
+
 static void panfrost_job_timedout(struct drm_sched_job *sched_job)
 {
 	struct panfrost_job *job = to_panfrost_job(sched_job);
@@ -392,19 +411,39 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
 		job_read(pfdev, JS_TAIL_LO(js)),
 		sched_job);
 
+	/* Scheduler is already stopped, nothing to do. */
+	if (!panfrost_scheduler_stop(&pfdev->js->queue[js], sched_job))
+		return;
+
 	if (!mutex_trylock(&pfdev->reset_lock))
 		return;
 
 	for (i = 0; i < NUM_JOB_SLOTS; i++) {
 		struct drm_gpu_scheduler *sched = &pfdev->js->queue[i].sched;
 
-		drm_sched_stop(sched, sched_job);
-		if (js != i)
-			/* Ensure any timeouts on other slots have finished */
+		/*
+		 * If the queue is still active, make sure we wait for any
+		 * pending timeouts.
+		 */
+		if (!pfdev->js->queue[i].stopped)
 			cancel_delayed_work_sync(&sched->work_tdr);
-	}
 
-	drm_sched_increase_karma(sched_job);
+		/*
+		 * If the scheduler was not already stopped, there's a tiny
+		 * chance a timeout has expired just before we stopped it, and
+		 * drm_sched_stop() does not flush pending works. Let's flush
+		 * them now so the timeout handler doesn't get called in the
+		 * middle of a reset.
+		 */
+		if (panfrost_scheduler_stop(&pfdev->js->queue[i], NULL))
+			cancel_delayed_work_sync(&sched->work_tdr);
+
+		/*
+		 * Now that we cancelled the pending timeouts, we can safely
+		 * reset the stopped state.
+		 */
+		pfdev->js->queue[i].stopped = false;
+	}
 
 	spin_lock_irqsave(&pfdev->js->job_lock, flags);
 	for (i = 0; i < NUM_JOB_SLOTS; i++) {
@@ -421,11 +460,11 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
 	for (i = 0; i < NUM_JOB_SLOTS; i++)
 		drm_sched_resubmit_jobs(&pfdev->js->queue[i].sched);
 
+	mutex_unlock(&pfdev->reset_lock);
+
 	/* restart scheduler after GPU is usable again */
 	for (i = 0; i < NUM_JOB_SLOTS; i++)
 		drm_sched_start(&pfdev->js->queue[i].sched, true);
-
-	mutex_unlock(&pfdev->reset_lock);
 }
 
 static const struct drm_sched_backend_ops panfrost_sched_ops = {
@@ -558,6 +597,7 @@ int panfrost_job_open(struct panfrost_file_priv *panfrost_priv)
 	int ret, i;
 
 	for (i = 0; i < NUM_JOB_SLOTS; i++) {
+		mutex_init(&js->queue[i].lock);
 		sched = &js->queue[i].sched;
 		ret = drm_sched_entity_init(&panfrost_priv->sched_entity[i],
 					    DRM_SCHED_PRIORITY_NORMAL, &sched,
@@ -570,10 +610,14 @@ int panfrost_job_open(struct panfrost_file_priv *panfrost_priv)
 
 void panfrost_job_close(struct panfrost_file_priv *panfrost_priv)
 {
+	struct panfrost_device *pfdev = panfrost_priv->pfdev;
+	struct panfrost_job_slot *js = pfdev->js;
 	int i;
 
-	for (i = 0; i < NUM_JOB_SLOTS; i++)
+	for (i = 0; i < NUM_JOB_SLOTS; i++) {
 		drm_sched_entity_destroy(&panfrost_priv->sched_entity[i]);
+		mutex_destroy(&js->queue[i].lock);
+	}
 }
 
 int panfrost_job_is_idle(struct panfrost_device *pfdev)
-- 
2.26.2

