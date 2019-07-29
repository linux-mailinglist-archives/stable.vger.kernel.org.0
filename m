Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09805797B8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388320AbfG2UCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390461AbfG2Ts7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:48:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44A8A2054F;
        Mon, 29 Jul 2019 19:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429738;
        bh=oECJ7UF9WFWlDfQ3kjKWWh6o07C5LWhV8cJjOLM7LJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWZ9I9IiOUz+FYo1yFKGNxZvNb255s9DFIt2HJIxSaYhFjvxpr9zhMA7FsYvf57W2
         UZkRryGFuw7HPc/YYK2mm6M1N5bnq9twhBWN79PK987A7RSW8H/qeqgdXj2yBJ7WYA
         Ip+Ku3L3FdJLpYDDHNWuYsoVk/Rc3gC2jJZgfgY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oak Zeng <Oak.Zeng@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 030/215] drm/amdkfd: Fix sdma queue map issue
Date:   Mon, 29 Jul 2019 21:20:26 +0200
Message-Id: <20190729190745.366931434@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index ae381450601c..afbaf6f5131e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1268,12 +1268,17 @@ int amdkfd_fence_wait_timeout(unsigned int *fence_addr,
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
@@ -1312,10 +1317,8 @@ static int unmap_queues_cpsch(struct device_queue_manager *dqm,
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



