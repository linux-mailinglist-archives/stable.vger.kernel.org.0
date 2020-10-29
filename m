Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E55729E96E
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 11:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgJ2Krk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 06:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgJ2Krj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 06:47:39 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D3CC0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 03:47:39 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 82CF01F45954;
        Thu, 29 Oct 2020 10:47:37 +0000 (GMT)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] drm/panfrost: Fix a race in the job timeout handling (again)
Date:   Thu, 29 Oct 2020 11:47:32 +0100
Message-Id: <20201029104732.293437-1-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In our last attempt to fix races in the panfrost_job_timedout() path we
overlooked the case where a re-submitted job immediately triggers a
fault. This lead to a situation where we try to stop a scheduler that's
not resumed yet and lose the 'timedout' event without restarting the
timeout, thus blocking the whole queue.

Let's fix that by tracking timeouts occurring between the
drm_sched_resubmit_jobs() and drm_sched_start() calls.

v2:
- Fix another race (reported by Steven)

Fixes: 1a11a88cfd9a ("drm/panfrost: Fix job timeout handling")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_job.c | 61 +++++++++++++++++--------
 1 file changed, 43 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index d0469e944143..0f9a34f5c6d0 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -26,6 +26,7 @@
 struct panfrost_queue_state {
 	struct drm_gpu_scheduler sched;
 	bool stopped;
+	bool timedout;
 	struct mutex lock;
 	u64 fence_context;
 	u64 emit_seqno;
@@ -383,11 +384,33 @@ static bool panfrost_scheduler_stop(struct panfrost_queue_state *queue,
 		queue->stopped = true;
 		stopped = true;
 	}
+	queue->timedout = true;
 	mutex_unlock(&queue->lock);
 
 	return stopped;
 }
 
+static void panfrost_scheduler_start(struct panfrost_queue_state *queue)
+{
+	if (WARN_ON(!queue->stopped))
+		return;
+
+	mutex_lock(&queue->lock);
+	drm_sched_start(&queue->sched, true);
+
+	/*
+	 * We might have missed fault-timeouts (AKA immediate timeouts) while
+	 * the scheduler was stopped. Let's fake a new fault to trigger an
+	 * immediate reset.
+	 */
+	if (queue->timedout)
+		drm_sched_fault(&queue->sched);
+
+	queue->timedout = false;
+	queue->stopped = false;
+	mutex_unlock(&queue->lock);
+}
+
 static void panfrost_job_timedout(struct drm_sched_job *sched_job)
 {
 	struct panfrost_job *job = to_panfrost_job(sched_job);
@@ -422,27 +445,20 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
 		struct drm_gpu_scheduler *sched = &pfdev->js->queue[i].sched;
 
 		/*
-		 * If the queue is still active, make sure we wait for any
-		 * pending timeouts.
+		 * Stop the scheduler and wait for any pending timeout handler
+		 * to return.
 		 */
-		if (!pfdev->js->queue[i].stopped)
+		panfrost_scheduler_stop(&pfdev->js->queue[i], NULL);
+		if (i != js)
 			cancel_delayed_work_sync(&sched->work_tdr);
 
 		/*
-		 * If the scheduler was not already stopped, there's a tiny
-		 * chance a timeout has expired just before we stopped it, and
-		 * drm_sched_stop() does not flush pending works. Let's flush
-		 * them now so the timeout handler doesn't get called in the
-		 * middle of a reset.
+		 * We do another stop after cancel_delayed_work_sync() to make
+		 * sure we don't race against another thread finishing its
+		 * reset (the restart queue steps are not protected by the
+		 * reset lock).
 		 */
-		if (panfrost_scheduler_stop(&pfdev->js->queue[i], NULL))
-			cancel_delayed_work_sync(&sched->work_tdr);
-
-		/*
-		 * Now that we cancelled the pending timeouts, we can safely
-		 * reset the stopped state.
-		 */
-		pfdev->js->queue[i].stopped = false;
+		panfrost_scheduler_stop(&pfdev->js->queue[i], NULL);
 	}
 
 	spin_lock_irqsave(&pfdev->js->job_lock, flags);
@@ -457,14 +473,23 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
 
 	panfrost_device_reset(pfdev);
 
-	for (i = 0; i < NUM_JOB_SLOTS; i++)
+	for (i = 0; i < NUM_JOB_SLOTS; i++) {
+		/*
+		 * The GPU is idle, and the scheduler is stopped, we can safely
+		 * reset the ->timedout state without taking any lock. We need
+		 * to do that before calling drm_sched_resubmit_jobs() though,
+		 * because the resubmission might trigger immediate faults
+		 * which we want to catch.
+		 */
+		pfdev->js->queue[i].timedout = false;
 		drm_sched_resubmit_jobs(&pfdev->js->queue[i].sched);
+	}
 
 	mutex_unlock(&pfdev->reset_lock);
 
 	/* restart scheduler after GPU is usable again */
 	for (i = 0; i < NUM_JOB_SLOTS; i++)
-		drm_sched_start(&pfdev->js->queue[i].sched, true);
+		panfrost_scheduler_start(&pfdev->js->queue[i]);
 }
 
 static const struct drm_sched_backend_ops panfrost_sched_ops = {
-- 
2.26.2

