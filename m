Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AA23BCCB0
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhGFLUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhGFLTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 825D961C79;
        Tue,  6 Jul 2021 11:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570198;
        bh=6i81rY4oU0A9X/YDYj2KARlvcWcHTR1SBEgRNN/YNp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0B0RFH/IGuGwwOdg9Ikt1btUBkP5a5OekYguY1333af/poniZrMicytfM1mmjZYX
         IejO1C1iX4m9cD2h3ja5CxWoP4RogDs9+rhdAtUsbSAEjjbx0IJXm/QAOR0nfKklVs
         TwMJmS6KCoTxlNaLrPr+D+B1kdvD/c+dQrO1wyqhDhBwcJJnwTaYv30jtVjqPl5z4k
         WyhbzhxwGB9ATYsM+JDGUsI9VldAvQMTd+zwvIsaIjDApKQPf9oiOFNxjsjqC/AIat
         +hW8fqtawFCjD7uW6luyhM9J33kvOVGTaSIbPJfBSCeW8UChZm6jM0KWYqt4ANWYJh
         n/PX0N4Pf3ZhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Kim <jonathan.kim@amd.com>,
        Felix Kuehling <felix.kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 111/189] drm/amdkfd: fix circular locking on get_wave_state
Date:   Tue,  6 Jul 2021 07:12:51 -0400
Message-Id: <20210706111409.2058071-111-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Kim <jonathan.kim@amd.com>

[ Upstream commit 63f6e01237257e7226efc5087f3f0b525d320f54 ]

get_wave_state acquires the mmap_lock on copy_to_user but so do
mmu_notifiers.  mmu_notifiers allows dqm locking so do get_wave_state
outside the dqm_lock to prevent circular locking.

v2: squash in unused variable removal.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c | 28 +++++++++----------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index d3eaa1549bd7..ccc9d108caff 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1674,29 +1674,27 @@ static int get_wave_state(struct device_queue_manager *dqm,
 			  u32 *save_area_used_size)
 {
 	struct mqd_manager *mqd_mgr;
-	int r;
 
 	dqm_lock(dqm);
 
-	if (q->properties.type != KFD_QUEUE_TYPE_COMPUTE ||
-	    q->properties.is_active || !q->device->cwsr_enabled) {
-		r = -EINVAL;
-		goto dqm_unlock;
-	}
-
 	mqd_mgr = dqm->mqd_mgrs[KFD_MQD_TYPE_CP];
 
-	if (!mqd_mgr->get_wave_state) {
-		r = -EINVAL;
-		goto dqm_unlock;
+	if (q->properties.type != KFD_QUEUE_TYPE_COMPUTE ||
+	    q->properties.is_active || !q->device->cwsr_enabled ||
+	    !mqd_mgr->get_wave_state) {
+		dqm_unlock(dqm);
+		return -EINVAL;
 	}
 
-	r = mqd_mgr->get_wave_state(mqd_mgr, q->mqd, ctl_stack,
-			ctl_stack_used_size, save_area_used_size);
-
-dqm_unlock:
 	dqm_unlock(dqm);
-	return r;
+
+	/*
+	 * get_wave_state is outside the dqm lock to prevent circular locking
+	 * and the queue should be protected against destruction by the process
+	 * lock.
+	 */
+	return mqd_mgr->get_wave_state(mqd_mgr, q->mqd, ctl_stack,
+			ctl_stack_used_size, save_area_used_size);
 }
 
 static int process_termination_cpsch(struct device_queue_manager *dqm,
-- 
2.30.2

