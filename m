Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CD13CAA5D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242198AbhGOTNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244019AbhGOTKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9FF4613D7;
        Thu, 15 Jul 2021 19:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376052;
        bh=6i81rY4oU0A9X/YDYj2KARlvcWcHTR1SBEgRNN/YNp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqEtPJs/APWT4LD9CQAsITLPyyJV0MyH8DOdimrTDeQlCJVaSyytbHldaZdjB6Nig
         SKyB8qEDEXUhs9kDZ1O38NaS6/eKmLb0/WUtTnS45fq/Yp0BXfp14Nffy0nS7TKp7P
         aq1SPoFsfUtbvgeXBr3WmMEgS2uVMEKn+/iBhssc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Kim <jonathan.kim@amd.com>,
        Felix Kuehling <felix.kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 105/266] drm/amdkfd: fix circular locking on get_wave_state
Date:   Thu, 15 Jul 2021 20:37:40 +0200
Message-Id: <20210715182632.478648054@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



