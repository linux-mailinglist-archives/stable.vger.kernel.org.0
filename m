Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9EB15DC42
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbgBNPvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:51:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730852AbgBNPvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:51:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 578F02465D;
        Fri, 14 Feb 2020 15:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695505;
        bh=mEbUikUJPdO2aLyeQBlvtyjvsrmBOXxH5GFU6k+4vuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGqHRBgH3dtHRinDlTUa/2iD1OY39U7gAQYLDmCBNTSy/mz5+GVLLao2AgmzYBe57
         edP9J0e9KRRSrzOADlSFe1RukPwkeaUeghZOP3Vb/LGB6qIYWw7b5e0/SZwEMUWfQG
         n+R96c+9oA4ppSZacNAdqgNEYF8dSyLRZqREweow=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yong Zhao <Yong.Zhao@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 131/542] drm/amdkfd: Fix a bug in SDMA RLC queue counting under HWS mode
Date:   Fri, 14 Feb 2020 10:42:03 -0500
Message-Id: <20200214154854.6746-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Zhao <Yong.Zhao@amd.com>

[ Upstream commit f38abc15d157b7b31fa7f651dc8bf92858c963f8 ]

The sdma_queue_count increment should be done before
execute_queues_cpsch(), which calls pm_calc_rlib_size() where
sdma_queue_count is used to calculate whether over_subscription is
triggered.

With the previous code, when a SDMA queue is created,
compute_queue_count in pm_calc_rlib_size() is one more than the
actual compute queue number, because the queue_count has been
incremented while sdma_queue_count has not. This patch fixes that.

Signed-off-by: Yong Zhao <Yong.Zhao@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 984c2f2b24b60..d128a8bbe19d0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1225,16 +1225,18 @@ static int create_queue_cpsch(struct device_queue_manager *dqm, struct queue *q,
 
 	list_add(&q->list, &qpd->queues_list);
 	qpd->queue_count++;
+
+	if (q->properties.type == KFD_QUEUE_TYPE_SDMA)
+		dqm->sdma_queue_count++;
+	else if (q->properties.type == KFD_QUEUE_TYPE_SDMA_XGMI)
+		dqm->xgmi_sdma_queue_count++;
+
 	if (q->properties.is_active) {
 		dqm->queue_count++;
 		retval = execute_queues_cpsch(dqm,
 				KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
 	}
 
-	if (q->properties.type == KFD_QUEUE_TYPE_SDMA)
-		dqm->sdma_queue_count++;
-	else if (q->properties.type == KFD_QUEUE_TYPE_SDMA_XGMI)
-		dqm->xgmi_sdma_queue_count++;
 	/*
 	 * Unconditionally increment this counter, regardless of the queue's
 	 * type or whether the queue is active.
-- 
2.20.1

