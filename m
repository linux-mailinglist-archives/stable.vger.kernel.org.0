Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E273BCFE4
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbhGFLbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235275AbhGFL3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4BCA61DA4;
        Tue,  6 Jul 2021 11:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570450;
        bh=pOJ1w1dBinbT0HX1LaUNE1gDjLBmaqvMRUrFCRootGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5AsPV2XrHdaF9RwuZPu6/5N+G86fXNTY6rj+hR4iIymu83tei9k/TUbkTL6medCH
         yKaFB97UOhGQscCuV9AXkg4rNoOT7qbWfTY7fXS0SedpmGJcP1wHUK0lTQ6DhJKM8X
         1Gsmg9u7CHMbfMW9m13lfLaqlt0vhtQW4OH3DMlaUOLptTcu3uhkN4tPs4ygDABB+u
         W2Q+FtdD3SfVMv142uBSMykKwY9j4eK/lALyPv2ZMHwYLiELcWZHJMTwgyEEl2Hhc2
         Nwe6f5Fia+ALe15EX5AcB8q+mFAZHR0Zi5C4rHgi7aMHpCGr2aGC6qhe96WWOA2GLu
         dnslguFBk42HA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xinhui pan <xinhui.pan@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 108/160] drm/amdkfd: Walk through list with dqm lock hold
Date:   Tue,  6 Jul 2021 07:17:34 -0400
Message-Id: <20210706111827.2060499-108-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

[ Upstream commit 56f221b6389e7ab99c30bbf01c71998ae92fc584 ]

To avoid any list corruption.

Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 3d66565a618f..b2e55917c308 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1712,7 +1712,7 @@ static int process_termination_cpsch(struct device_queue_manager *dqm,
 		struct qcm_process_device *qpd)
 {
 	int retval;
-	struct queue *q, *next;
+	struct queue *q;
 	struct kernel_queue *kq, *kq_next;
 	struct mqd_manager *mqd_mgr;
 	struct device_process_node *cur, *next_dpn;
@@ -1769,24 +1769,26 @@ static int process_termination_cpsch(struct device_queue_manager *dqm,
 		qpd->reset_wavefronts = false;
 	}
 
-	dqm_unlock(dqm);
-
-	/* Outside the DQM lock because under the DQM lock we can't do
-	 * reclaim or take other locks that others hold while reclaiming.
-	 */
-	if (found)
-		kfd_dec_compute_active(dqm->dev);
-
 	/* Lastly, free mqd resources.
 	 * Do free_mqd() after dqm_unlock to avoid circular locking.
 	 */
-	list_for_each_entry_safe(q, next, &qpd->queues_list, list) {
+	while (!list_empty(&qpd->queues_list)) {
+		q = list_first_entry(&qpd->queues_list, struct queue, list);
 		mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 				q->properties.type)];
 		list_del(&q->list);
 		qpd->queue_count--;
+		dqm_unlock(dqm);
 		mqd_mgr->free_mqd(mqd_mgr, q->mqd, q->mqd_mem_obj);
+		dqm_lock(dqm);
 	}
+	dqm_unlock(dqm);
+
+	/* Outside the DQM lock because under the DQM lock we can't do
+	 * reclaim or take other locks that others hold while reclaiming.
+	 */
+	if (found)
+		kfd_dec_compute_active(dqm->dev);
 
 	return retval;
 }
-- 
2.30.2

