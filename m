Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3E7323D60
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhBXNI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:08:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235279AbhBXNBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:01:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D19F464F0F;
        Wed, 24 Feb 2021 12:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171192;
        bh=95OhmrsHd187ZEFzLgEb3J9NBS5se0IR+XVuZpxLees=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHEVxm2BAOVmmLtbXbFE8mYt3i9wVhMjoOQ4fKCuDt4yoPSOQKWbCGlrwZeg1h4Bn
         xU1ol5UMeDQ4x3DZ/6oaSjGTDaPxzcWuLKuJGCvjKaljCGQL7OIy2MIRTKFGNoFAbc
         /grFlzXKB4BHMR+PRLEEn/GDMWJUj0dofkkzZSeSs8Sw/Baqf+ZZk0ZNSNOxSbutgZ
         T0rGGSZB8VHz/5Lwe1Z2l9HT2QOPC8MxPJkFJxcHrbGJvjTVL8+wVOMbt9JymHtaIb
         2dRn4578D6Yj6amjFH8uEOr6DyAwUf2Mq48wM4TStDy1DU+xuJbjs5Dsapu4PQI/rV
         x6sthCD0ZpBbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 45/56] drm/amdgpu: enable only one high prio compute queue
Date:   Wed, 24 Feb 2021 07:52:01 -0500
Message-Id: <20210224125212.482485-45-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

[ Upstream commit 8c0225d79273968a65e73a4204fba023ae02714d ]

For high priority compute to work properly we need to enable
wave limiting on gfx pipe. Wave limiting is done through writing
into mmSPI_WCL_PIPE_PERCENT_GFX register. Enable only one high
priority compute queue to avoid race condition between multiple
high priority compute queues writing that register simultaneously.

Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 15 ++++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h |  2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c  |  6 ++----
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c   |  6 ++----
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c   |  7 ++-----
 5 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index c485ec86804e5..034a0f3b4c660 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -193,15 +193,16 @@ static bool amdgpu_gfx_is_multipipe_capable(struct amdgpu_device *adev)
 }
 
 bool amdgpu_gfx_is_high_priority_compute_queue(struct amdgpu_device *adev,
-					       int pipe, int queue)
+					       struct amdgpu_ring *ring)
 {
-	bool multipipe_policy = amdgpu_gfx_is_multipipe_capable(adev);
-	int cond;
-	/* Policy: alternate between normal and high priority */
-	cond = multipipe_policy ? pipe : queue;
-
-	return ((cond % 2) != 0);
+	/* Policy: use 1st queue as high priority compute queue if we
+	 * have more than one compute queue.
+	 */
+	if (adev->gfx.num_compute_rings > 1 &&
+	    ring == &adev->gfx.compute_ring[0])
+		return true;
 
+	return false;
 }
 
 void amdgpu_gfx_compute_queue_acquire(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
index f353a5b71804e..6e0cba6f4bdcd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
@@ -373,7 +373,7 @@ void amdgpu_queue_mask_bit_to_mec_queue(struct amdgpu_device *adev, int bit,
 bool amdgpu_gfx_is_mec_queue_enabled(struct amdgpu_device *adev, int mec,
 				     int pipe, int queue);
 bool amdgpu_gfx_is_high_priority_compute_queue(struct amdgpu_device *adev,
-					       int pipe, int queue);
+					       struct amdgpu_ring *ring);
 int amdgpu_gfx_me_queue_to_bit(struct amdgpu_device *adev, int me,
 			       int pipe, int queue);
 void amdgpu_gfx_bit_to_me_queue(struct amdgpu_device *adev, int bit,
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 4ebb43e090999..4cc83b399b66b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4334,8 +4334,7 @@ static int gfx_v10_0_compute_ring_init(struct amdgpu_device *adev, int ring_id,
 	irq_type = AMDGPU_CP_IRQ_COMPUTE_MEC1_PIPE0_EOP
 		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
 		+ ring->pipe;
-	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
-							    ring->queue) ?
+	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring) ?
 			AMDGPU_GFX_PIPE_PRIO_HIGH : AMDGPU_GFX_PIPE_PRIO_NORMAL;
 	/* type-2 packets are deprecated on MEC, use type-3 instead */
 	r = amdgpu_ring_init(adev, ring, 1024,
@@ -6361,8 +6360,7 @@ static void gfx_v10_0_compute_mqd_set_priority(struct amdgpu_ring *ring, struct
 	struct amdgpu_device *adev = ring->adev;
 
 	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
-		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
-							      ring->queue)) {
+		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring)) {
 			mqd->cp_hqd_pipe_priority = AMDGPU_GFX_PIPE_PRIO_HIGH;
 			mqd->cp_hqd_queue_priority =
 				AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index c36258d56b445..f2f603fa0288d 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -1915,8 +1915,7 @@ static int gfx_v8_0_compute_ring_init(struct amdgpu_device *adev, int ring_id,
 		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
 		+ ring->pipe;
 
-	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
-							    ring->queue) ?
+	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring) ?
 			AMDGPU_GFX_PIPE_PRIO_HIGH : AMDGPU_RING_PRIO_DEFAULT;
 	/* type-2 packets are deprecated on MEC, use type-3 instead */
 	r = amdgpu_ring_init(adev, ring, 1024,
@@ -4434,8 +4433,7 @@ static void gfx_v8_0_mqd_set_priority(struct amdgpu_ring *ring, struct vi_mqd *m
 	struct amdgpu_device *adev = ring->adev;
 
 	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
-		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
-							      ring->queue)) {
+		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring)) {
 			mqd->cp_hqd_pipe_priority = AMDGPU_GFX_PIPE_PRIO_HIGH;
 			mqd->cp_hqd_queue_priority =
 				AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 957c12b727676..fa843bda70ba3 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2228,8 +2228,7 @@ static int gfx_v9_0_compute_ring_init(struct amdgpu_device *adev, int ring_id,
 	irq_type = AMDGPU_CP_IRQ_COMPUTE_MEC1_PIPE0_EOP
 		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
 		+ ring->pipe;
-	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
-							    ring->queue) ?
+	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring) ?
 			AMDGPU_GFX_PIPE_PRIO_HIGH : AMDGPU_GFX_PIPE_PRIO_NORMAL;
 	/* type-2 packets are deprecated on MEC, use type-3 instead */
 	return amdgpu_ring_init(adev, ring, 1024,
@@ -3384,9 +3383,7 @@ static void gfx_v9_0_mqd_set_priority(struct amdgpu_ring *ring, struct v9_mqd *m
 	struct amdgpu_device *adev = ring->adev;
 
 	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
-		if (amdgpu_gfx_is_high_priority_compute_queue(adev,
-							      ring->pipe,
-							      ring->queue)) {
+		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring)) {
 			mqd->cp_hqd_pipe_priority = AMDGPU_GFX_PIPE_PRIO_HIGH;
 			mqd->cp_hqd_queue_priority =
 				AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;
-- 
2.27.0

