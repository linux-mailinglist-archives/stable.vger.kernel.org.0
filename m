Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC622E420D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391695AbgL1PRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437364AbgL1OEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D56520791;
        Mon, 28 Dec 2020 14:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164229;
        bh=jujSAhDbkW8RER5iF0hgAZONUWUzY2e2+fvtafaO9nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kExRY0dwFZ/wSFLu0ATy5/aqaNkx+EEoOe2r03fuqxoH0/VvZ25S2gdjbhGEypSEf
         C1zm/jvkEw+ydzbJFusDvjaFmfJ/SIE/kGemEPn6GcsmQNSOvObU3B9CKFoDOme160
         sx8HzTUMBfey/3yHJFFgHWGy2JQxI4/T3Y8YH0n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/717] drm/amdgpu: fix compute queue priority if num_kcq is less than 4
Date:   Mon, 28 Dec 2020 13:41:43 +0100
Message-Id: <20201228125025.986188789@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

[ Upstream commit 3f66bf401e9fde1c35bb8b02dd7975659c40411d ]

Compute queues are configurable with module param, num_kcq.
amdgpu_gfx_is_high_priority_compute_queue was setting 1st 4 queues to
high priority queue leaving a null drm scheduler in
adev->gpu_sched[hw_ip]["normal_prio"].sched if num_kcq < 5.

This patch tries to fix it by alternating compute queue priority between
normal and high priority.

Fixes: 33abcb1f5a1719b1c (drm/amdgpu: set compute queue priority at mqd_init)
Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 10 +++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h |  2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c  |  6 ++++--
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c   |  6 ++++--
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c   |  7 +++++--
 5 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 8c9bacfdbc300..c485ec86804e5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -193,10 +193,14 @@ static bool amdgpu_gfx_is_multipipe_capable(struct amdgpu_device *adev)
 }
 
 bool amdgpu_gfx_is_high_priority_compute_queue(struct amdgpu_device *adev,
-					       int queue)
+					       int pipe, int queue)
 {
-	/* Policy: make queue 0 of each pipe as high priority compute queue */
-	return (queue == 0);
+	bool multipipe_policy = amdgpu_gfx_is_multipipe_capable(adev);
+	int cond;
+	/* Policy: alternate between normal and high priority */
+	cond = multipipe_policy ? pipe : queue;
+
+	return ((cond % 2) != 0);
 
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
index 258498cbf1eba..f353a5b71804e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
@@ -373,7 +373,7 @@ void amdgpu_queue_mask_bit_to_mec_queue(struct amdgpu_device *adev, int bit,
 bool amdgpu_gfx_is_mec_queue_enabled(struct amdgpu_device *adev, int mec,
 				     int pipe, int queue);
 bool amdgpu_gfx_is_high_priority_compute_queue(struct amdgpu_device *adev,
-					       int queue);
+					       int pipe, int queue);
 int amdgpu_gfx_me_queue_to_bit(struct amdgpu_device *adev, int me,
 			       int pipe, int queue);
 void amdgpu_gfx_bit_to_me_queue(struct amdgpu_device *adev, int bit,
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 55f4b8c3b9338..4ebb43e090999 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4334,7 +4334,8 @@ static int gfx_v10_0_compute_ring_init(struct amdgpu_device *adev, int ring_id,
 	irq_type = AMDGPU_CP_IRQ_COMPUTE_MEC1_PIPE0_EOP
 		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
 		+ ring->pipe;
-	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->queue) ?
+	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
+							    ring->queue) ?
 			AMDGPU_GFX_PIPE_PRIO_HIGH : AMDGPU_GFX_PIPE_PRIO_NORMAL;
 	/* type-2 packets are deprecated on MEC, use type-3 instead */
 	r = amdgpu_ring_init(adev, ring, 1024,
@@ -6360,7 +6361,8 @@ static void gfx_v10_0_compute_mqd_set_priority(struct amdgpu_ring *ring, struct
 	struct amdgpu_device *adev = ring->adev;
 
 	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
-		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring->queue)) {
+		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
+							      ring->queue)) {
 			mqd->cp_hqd_pipe_priority = AMDGPU_GFX_PIPE_PRIO_HIGH;
 			mqd->cp_hqd_queue_priority =
 				AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index 94b7e0531d092..c36258d56b445 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -1915,7 +1915,8 @@ static int gfx_v8_0_compute_ring_init(struct amdgpu_device *adev, int ring_id,
 		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
 		+ ring->pipe;
 
-	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->queue) ?
+	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
+							    ring->queue) ?
 			AMDGPU_GFX_PIPE_PRIO_HIGH : AMDGPU_RING_PRIO_DEFAULT;
 	/* type-2 packets are deprecated on MEC, use type-3 instead */
 	r = amdgpu_ring_init(adev, ring, 1024,
@@ -4433,7 +4434,8 @@ static void gfx_v8_0_mqd_set_priority(struct amdgpu_ring *ring, struct vi_mqd *m
 	struct amdgpu_device *adev = ring->adev;
 
 	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
-		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring->queue)) {
+		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
+							      ring->queue)) {
 			mqd->cp_hqd_pipe_priority = AMDGPU_GFX_PIPE_PRIO_HIGH;
 			mqd->cp_hqd_queue_priority =
 				AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 0d8e203b10efb..957c12b727676 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2228,7 +2228,8 @@ static int gfx_v9_0_compute_ring_init(struct amdgpu_device *adev, int ring_id,
 	irq_type = AMDGPU_CP_IRQ_COMPUTE_MEC1_PIPE0_EOP
 		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
 		+ ring->pipe;
-	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->queue) ?
+	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
+							    ring->queue) ?
 			AMDGPU_GFX_PIPE_PRIO_HIGH : AMDGPU_GFX_PIPE_PRIO_NORMAL;
 	/* type-2 packets are deprecated on MEC, use type-3 instead */
 	return amdgpu_ring_init(adev, ring, 1024,
@@ -3383,7 +3384,9 @@ static void gfx_v9_0_mqd_set_priority(struct amdgpu_ring *ring, struct v9_mqd *m
 	struct amdgpu_device *adev = ring->adev;
 
 	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
-		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring->queue)) {
+		if (amdgpu_gfx_is_high_priority_compute_queue(adev,
+							      ring->pipe,
+							      ring->queue)) {
 			mqd->cp_hqd_pipe_priority = AMDGPU_GFX_PIPE_PRIO_HIGH;
 			mqd->cp_hqd_queue_priority =
 				AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;
-- 
2.27.0



