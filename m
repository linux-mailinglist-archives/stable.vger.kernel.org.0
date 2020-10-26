Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B8929A0CD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408997AbgJZXuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408814AbgJZXty (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:49:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29CA72075B;
        Mon, 26 Oct 2020 23:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756193;
        bh=yWbw1q8U51uzV0UZ4E4biqByuhbsup124KNK/vUj8gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtwP4wnS0AAUuTRROtMnnsisx2lan7+nDUeMaUr3FJgySdD57v0o9lFbnLcPpTsmW
         WYRLrgsmUVCsjrOE1D3lpYVRwMsHeOUNVgtTqEonDoB7AaGX6147s4tTWoD2nCpGoV
         0pvtEl9cbqrtVNCdeRZZdTLMrqkhD973ps2tg50Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luben Tuikov <luben.tuikov@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 037/147] drm/scheduler: Scheduler priority fixes (v2)
Date:   Mon, 26 Oct 2020 19:47:15 -0400
Message-Id: <20201026234905.1022767-37-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit e2d732fdb7a9e421720a644580cd6a9400f97f60 ]

Remove DRM_SCHED_PRIORITY_LOW, as it was used
in only one place.

Rename and separate by a line
DRM_SCHED_PRIORITY_MAX to DRM_SCHED_PRIORITY_COUNT
as it represents a (total) count of said
priorities and it is used as such in loops
throughout the code. (0-based indexing is the
the count number.)

Remove redundant word HIGH in priority names,
and rename *KERNEL* to *HIGH*, as it really
means that, high.

v2: Add back KERNEL and remove SW and HW,
    in lieu of a single HIGH between NORMAL and KERNEL.

Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c   |  4 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c   |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c  |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h  |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c |  6 +++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c   |  2 +-
 drivers/gpu/drm/scheduler/sched_main.c    |  4 ++--
 include/drm/gpu_scheduler.h               | 12 +++++++-----
 8 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
index 8842c55d4490b..fc695126b6e75 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -46,7 +46,7 @@ const unsigned int amdgpu_ctx_num_entities[AMDGPU_HW_IP_NUM] = {
 static int amdgpu_ctx_priority_permit(struct drm_file *filp,
 				      enum drm_sched_priority priority)
 {
-	if (priority < 0 || priority >= DRM_SCHED_PRIORITY_MAX)
+	if (priority < 0 || priority >= DRM_SCHED_PRIORITY_COUNT)
 		return -EINVAL;
 
 	/* NORMAL and below are accessible by everyone */
@@ -65,7 +65,7 @@ static int amdgpu_ctx_priority_permit(struct drm_file *filp,
 static enum gfx_pipe_priority amdgpu_ctx_sched_prio_to_compute_prio(enum drm_sched_priority prio)
 {
 	switch (prio) {
-	case DRM_SCHED_PRIORITY_HIGH_HW:
+	case DRM_SCHED_PRIORITY_HIGH:
 	case DRM_SCHED_PRIORITY_KERNEL:
 		return AMDGPU_GFX_PIPE_PRIO_HIGH;
 	default:
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index 937029ad5271a..dcfe8a3b03ffb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -251,7 +251,7 @@ void amdgpu_job_stop_all_jobs_on_sched(struct drm_gpu_scheduler *sched)
 	int i;
 
 	/* Signal all jobs not yet scheduled */
-	for (i = DRM_SCHED_PRIORITY_MAX - 1; i >= DRM_SCHED_PRIORITY_MIN; i--) {
+	for (i = DRM_SCHED_PRIORITY_COUNT - 1; i >= DRM_SCHED_PRIORITY_MIN; i--) {
 		struct drm_sched_rq *rq = &sched->sched_rq[i];
 
 		if (!rq)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index 13ea8ebc421c6..6d4fc79bf84aa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -267,7 +267,7 @@ int amdgpu_ring_init(struct amdgpu_device *adev, struct amdgpu_ring *ring,
 			&ring->sched;
 	}
 
-	for (i = 0; i < DRM_SCHED_PRIORITY_MAX; ++i)
+	for (i = DRM_SCHED_PRIORITY_MIN; i < DRM_SCHED_PRIORITY_COUNT; ++i)
 		atomic_set(&ring->num_jobs[i], 0);
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
index da871d84b7424..7112137689db0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
@@ -243,7 +243,7 @@ struct amdgpu_ring {
 	bool			has_compute_vm_bug;
 	bool			no_scheduler;
 
-	atomic_t		num_jobs[DRM_SCHED_PRIORITY_MAX];
+	atomic_t		num_jobs[DRM_SCHED_PRIORITY_COUNT];
 	struct mutex		priority_mutex;
 	/* protected by priority_mutex */
 	int			priority;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
index c799691dfa848..17661ede94885 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
@@ -36,14 +36,14 @@ enum drm_sched_priority amdgpu_to_sched_priority(int amdgpu_priority)
 {
 	switch (amdgpu_priority) {
 	case AMDGPU_CTX_PRIORITY_VERY_HIGH:
-		return DRM_SCHED_PRIORITY_HIGH_HW;
+		return DRM_SCHED_PRIORITY_HIGH;
 	case AMDGPU_CTX_PRIORITY_HIGH:
-		return DRM_SCHED_PRIORITY_HIGH_SW;
+		return DRM_SCHED_PRIORITY_HIGH;
 	case AMDGPU_CTX_PRIORITY_NORMAL:
 		return DRM_SCHED_PRIORITY_NORMAL;
 	case AMDGPU_CTX_PRIORITY_LOW:
 	case AMDGPU_CTX_PRIORITY_VERY_LOW:
-		return DRM_SCHED_PRIORITY_LOW;
+		return DRM_SCHED_PRIORITY_MIN;
 	case AMDGPU_CTX_PRIORITY_UNSET:
 		return DRM_SCHED_PRIORITY_UNSET;
 	default:
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 978bae7313980..b7fd0cdffce0e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -2101,7 +2101,7 @@ void amdgpu_ttm_set_buffer_funcs_status(struct amdgpu_device *adev, bool enable)
 		ring = adev->mman.buffer_funcs_ring;
 		sched = &ring->sched;
 		r = drm_sched_entity_init(&adev->mman.entity,
-				          DRM_SCHED_PRIORITY_KERNEL, &sched,
+					  DRM_SCHED_PRIORITY_KERNEL, &sched,
 					  1, NULL);
 		if (r) {
 			DRM_ERROR("Failed setting up TTM BO move entity (%d)\n",
diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 96f763d888af5..9a0d77a680180 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -625,7 +625,7 @@ drm_sched_select_entity(struct drm_gpu_scheduler *sched)
 		return NULL;
 
 	/* Kernel run queue has higher priority than normal run queue*/
-	for (i = DRM_SCHED_PRIORITY_MAX - 1; i >= DRM_SCHED_PRIORITY_MIN; i--) {
+	for (i = DRM_SCHED_PRIORITY_COUNT - 1; i >= DRM_SCHED_PRIORITY_MIN; i--) {
 		entity = drm_sched_rq_select_entity(&sched->sched_rq[i]);
 		if (entity)
 			break;
@@ -852,7 +852,7 @@ int drm_sched_init(struct drm_gpu_scheduler *sched,
 	sched->name = name;
 	sched->timeout = timeout;
 	sched->hang_limit = hang_limit;
-	for (i = DRM_SCHED_PRIORITY_MIN; i < DRM_SCHED_PRIORITY_MAX; i++)
+	for (i = DRM_SCHED_PRIORITY_MIN; i < DRM_SCHED_PRIORITY_COUNT; i++)
 		drm_sched_rq_init(sched, &sched->sched_rq[i]);
 
 	init_waitqueue_head(&sched->wake_up_worker);
diff --git a/include/drm/gpu_scheduler.h b/include/drm/gpu_scheduler.h
index b9780ae9dd26c..72dc3a95fbaad 100644
--- a/include/drm/gpu_scheduler.h
+++ b/include/drm/gpu_scheduler.h
@@ -33,14 +33,16 @@
 struct drm_gpu_scheduler;
 struct drm_sched_rq;
 
+/* These are often used as an (initial) index
+ * to an array, and as such should start at 0.
+ */
 enum drm_sched_priority {
 	DRM_SCHED_PRIORITY_MIN,
-	DRM_SCHED_PRIORITY_LOW = DRM_SCHED_PRIORITY_MIN,
 	DRM_SCHED_PRIORITY_NORMAL,
-	DRM_SCHED_PRIORITY_HIGH_SW,
-	DRM_SCHED_PRIORITY_HIGH_HW,
+	DRM_SCHED_PRIORITY_HIGH,
 	DRM_SCHED_PRIORITY_KERNEL,
-	DRM_SCHED_PRIORITY_MAX,
+
+	DRM_SCHED_PRIORITY_COUNT,
 	DRM_SCHED_PRIORITY_INVALID = -1,
 	DRM_SCHED_PRIORITY_UNSET = -2
 };
@@ -274,7 +276,7 @@ struct drm_gpu_scheduler {
 	uint32_t			hw_submission_limit;
 	long				timeout;
 	const char			*name;
-	struct drm_sched_rq		sched_rq[DRM_SCHED_PRIORITY_MAX];
+	struct drm_sched_rq		sched_rq[DRM_SCHED_PRIORITY_COUNT];
 	wait_queue_head_t		wake_up_worker;
 	wait_queue_head_t		job_scheduled;
 	atomic_t			hw_rq_count;
-- 
2.25.1

