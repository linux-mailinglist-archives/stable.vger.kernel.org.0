Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1292E491404
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244365AbiARCT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:19:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34772 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244369AbiARCTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:19:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46D53B81233;
        Tue, 18 Jan 2022 02:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9CBC36AEB;
        Tue, 18 Jan 2022 02:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472392;
        bh=hMvz0BBLDKfp6xLtKBumqNeTre1P81r1tH1l9Baj+sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iupY2IH4QyeSL3lvMo+MczM455jSnNPOoGDuXNnDzqDsNHdqhGjGP2Fyd26hEtHAr
         kVlwKE+cNxs9XIQ6TNQY98dFaOwAuBfdFN/ZRo4J7u8nGePv5AUaocIRUTKlou/2rc
         +Gv1wrkqXIEfflR/hEgRauiEpV1oXoGcbgMDyQppkpOlRB7s/qAcWWNlO1t3LMfgPB
         /GsEqXpbrde4McBFNnpQuIVixgjRrcIe4QqMmd3vNqtR2csrMGM23zpsJnIA6+Nxqz
         mzbtOZ8wS5K6gCoff31v1JeHkUC6nmdB37ldoVsJWxCmjYqoPa6LAMjjQJJFlio2LE
         h1YZTIYvyw28Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 006/217] drm/sched: Avoid lockdep spalt on killing a processes
Date:   Mon, 17 Jan 2022 21:16:09 -0500
Message-Id: <20220118021940.1942199-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit 542cff7893a37445f98ece26aeb3c9c1055e9ea4 ]

Probelm:
Singlaning one sched fence from within another's sched
fence singal callback generates lockdep splat because
the both have same lockdep class of their fence->lock

Fix:
Fix bellow stack by rescheduling to irq work of
signaling and killing of jobs that left when entity is killed.

[11176.741181]  dump_stack+0x10/0x12
[11176.741186] __lock_acquire.cold+0x208/0x2df
[11176.741197]  lock_acquire+0xc6/0x2d0
[11176.741204]  ? dma_fence_signal+0x28/0x80
[11176.741212] _raw_spin_lock_irqsave+0x4d/0x70
[11176.741219]  ? dma_fence_signal+0x28/0x80
[11176.741225]  dma_fence_signal+0x28/0x80
[11176.741230] drm_sched_fence_finished+0x12/0x20 [gpu_sched]
[11176.741240] drm_sched_entity_kill_jobs_cb+0x1c/0x50 [gpu_sched]
[11176.741248] dma_fence_signal_timestamp_locked+0xac/0x1a0
[11176.741254]  dma_fence_signal+0x3b/0x80
[11176.741260] drm_sched_fence_finished+0x12/0x20 [gpu_sched]
[11176.741268] drm_sched_job_done.isra.0+0x7f/0x1a0 [gpu_sched]
[11176.741277] drm_sched_job_done_cb+0x12/0x20 [gpu_sched]
[11176.741284] dma_fence_signal_timestamp_locked+0xac/0x1a0
[11176.741290]  dma_fence_signal+0x3b/0x80
[11176.741296] amdgpu_fence_process+0xd1/0x140 [amdgpu]
[11176.741504] sdma_v4_0_process_trap_irq+0x8c/0xb0 [amdgpu]
[11176.741731]  amdgpu_irq_dispatch+0xce/0x250 [amdgpu]
[11176.741954]  amdgpu_ih_process+0x81/0x100 [amdgpu]
[11176.742174]  amdgpu_irq_handler+0x26/0xa0 [amdgpu]
[11176.742393] __handle_irq_event_percpu+0x4f/0x2c0
[11176.742402] handle_irq_event_percpu+0x33/0x80
[11176.742408]  handle_irq_event+0x39/0x60
[11176.742414]  handle_edge_irq+0x93/0x1d0
[11176.742419]  __common_interrupt+0x50/0xe0
[11176.742426]  common_interrupt+0x80/0x90

Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Suggested-by: Daniel Vetter  <daniel.vetter@ffwll.ch>
Suggested-by: Christian König <christian.koenig@amd.com>
Tested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://www.spinics.net/lists/dri-devel/msg321250.html
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c | 15 ++++++++++++---
 include/drm/gpu_scheduler.h              | 12 +++++++++++-
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 27e1573af96e2..191c56064f196 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -190,6 +190,16 @@ long drm_sched_entity_flush(struct drm_sched_entity *entity, long timeout)
 }
 EXPORT_SYMBOL(drm_sched_entity_flush);
 
+static void drm_sched_entity_kill_jobs_irq_work(struct irq_work *wrk)
+{
+	struct drm_sched_job *job = container_of(wrk, typeof(*job), work);
+
+	drm_sched_fence_finished(job->s_fence);
+	WARN_ON(job->s_fence->parent);
+	job->sched->ops->free_job(job);
+}
+
+
 /* Signal the scheduler finished fence when the entity in question is killed. */
 static void drm_sched_entity_kill_jobs_cb(struct dma_fence *f,
 					  struct dma_fence_cb *cb)
@@ -197,9 +207,8 @@ static void drm_sched_entity_kill_jobs_cb(struct dma_fence *f,
 	struct drm_sched_job *job = container_of(cb, struct drm_sched_job,
 						 finish_cb);
 
-	drm_sched_fence_finished(job->s_fence);
-	WARN_ON(job->s_fence->parent);
-	job->sched->ops->free_job(job);
+	init_irq_work(&job->work, drm_sched_entity_kill_jobs_irq_work);
+	irq_work_queue(&job->work);
 }
 
 static struct dma_fence *
diff --git a/include/drm/gpu_scheduler.h b/include/drm/gpu_scheduler.h
index f011e4c407f2e..bbc22fad8d802 100644
--- a/include/drm/gpu_scheduler.h
+++ b/include/drm/gpu_scheduler.h
@@ -28,6 +28,7 @@
 #include <linux/dma-fence.h>
 #include <linux/completion.h>
 #include <linux/xarray.h>
+#include <linux/irq_work.h>
 
 #define MAX_WAIT_SCHED_ENTITY_Q_EMPTY msecs_to_jiffies(1000)
 
@@ -286,7 +287,16 @@ struct drm_sched_job {
 	struct list_head		list;
 	struct drm_gpu_scheduler	*sched;
 	struct drm_sched_fence		*s_fence;
-	struct dma_fence_cb		finish_cb;
+
+	/*
+	 * work is used only after finish_cb has been used and will not be
+	 * accessed anymore.
+	 */
+	union {
+		struct dma_fence_cb		finish_cb;
+		struct irq_work 		work;
+	};
+
 	uint64_t			id;
 	atomic_t			karma;
 	enum drm_sched_priority		s_priority;
-- 
2.34.1

