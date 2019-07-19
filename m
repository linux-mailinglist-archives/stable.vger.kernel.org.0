Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA776DF16
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbfGSEc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730520AbfGSEDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:03:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C204F218A6;
        Fri, 19 Jul 2019 04:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509013;
        bh=zw7UF1V+2NrJrVHMkq9oPqcWhcnixRSHIlW1rAR+qKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWa5Qfnyx3hrjflEkEvg8sl7eegqU2FrrL6mpUnuDGN5Gk5AHMWt1TaBQYC1ZPU05
         7dOrgrG010tHH/4SyQhCCWoEHFKTk4+4AE/eOD0KPchf9HgNmgSSc3Mi8eHtV1liCu
         /Kl3Z3y4YunevthVZjJSFSQTxE6gazaNkbgxgxlY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oak Zeng <Oak.Zeng@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 020/141] drm/amdkfd: Fix sdma queue map issue
Date:   Fri, 19 Jul 2019 00:00:45 -0400
Message-Id: <20190719040246.15945-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oak Zeng <Oak.Zeng@amd.com>

[ Upstream commit 065e4bdfa1f3ab2884c110394d8b7e7ebe3b988c ]

Previous codes assumes there are two sdma engines.
This is not true e.g., Raven only has 1 SDMA engine.
Fix the issue by using sdma engine number info in
device_info.

Signed-off-by: Oak Zeng <Oak.Zeng@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index c6c9530e704e..722fa1f5244b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1269,12 +1269,17 @@ int amdkfd_fence_wait_timeout(unsigned int *fence_addr,
 	return 0;
 }
 
-static int unmap_sdma_queues(struct device_queue_manager *dqm,
-				unsigned int sdma_engine)
+static int unmap_sdma_queues(struct device_queue_manager *dqm)
 {
-	return pm_send_unmap_queue(&dqm->packets, KFD_QUEUE_TYPE_SDMA,
-			KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0, false,
-			sdma_engine);
+	int i, retval = 0;
+
+	for (i = 0; i < dqm->dev->device_info->num_sdma_engines; i++) {
+		retval = pm_send_unmap_queue(&dqm->packets, KFD_QUEUE_TYPE_SDMA,
+			KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0, false, i);
+		if (retval)
+			return retval;
+	}
+	return retval;
 }
 
 /* dqm->lock mutex has to be locked before calling this function */
@@ -1313,10 +1318,8 @@ static int unmap_queues_cpsch(struct device_queue_manager *dqm,
 	pr_debug("Before destroying queues, sdma queue count is : %u\n",
 		dqm->sdma_queue_count);
 
-	if (dqm->sdma_queue_count > 0) {
-		unmap_sdma_queues(dqm, 0);
-		unmap_sdma_queues(dqm, 1);
-	}
+	if (dqm->sdma_queue_count > 0)
+		unmap_sdma_queues(dqm);
 
 	retval = pm_send_unmap_queue(&dqm->packets, KFD_QUEUE_TYPE_COMPUTE,
 			filter, filter_param, false, 0);
-- 
2.20.1

