Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB4D3BD18F
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbhGFLjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:39:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237202AbhGFLgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B21B761ECC;
        Tue,  6 Jul 2021 11:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570767;
        bh=1W/bstbucNPe+USJhNe3o8RBL+LRH+w9EP++FNRD0ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skXSGFhShE0s8jPFpcjFzBxFZXWEMICkiEmtg/EMUCDa0zF/+oVAMn3/jKx3wuage
         wcBWDWXUohZkGTC48fBtnriegkL0UHHcbtMbgrDoG6YSEL0xUADKaucvd9VIRALuGi
         mkBu03VKvtftZywxrumPDCQTw/RJGwUYSkXqFsukqmqFEDLYTxjbz20kHmW1ibGikr
         pFrG41bqcBmyeaab4uayXJ657ISus/LYvlTDWbq23ojr6SSbD4Bd5fNoYeZ9EQMCKF
         mHhQwJiVRD6dFIMrQF1+6wC/zrrqi4O0XfeFkQw/fbN6RixPY+PEbt35zKBFSrs2Ue
         WdfqhOpiXMgcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xinhui pan <xinhui.pan@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 51/74] drm/amdkfd: Walk through list with dqm lock hold
Date:   Tue,  6 Jul 2021 07:24:39 -0400
Message-Id: <20210706112502.2064236-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index ab69898c9cb7..723ec6c2830d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1584,7 +1584,7 @@ static int process_termination_cpsch(struct device_queue_manager *dqm,
 		struct qcm_process_device *qpd)
 {
 	int retval;
-	struct queue *q, *next;
+	struct queue *q;
 	struct kernel_queue *kq, *kq_next;
 	struct mqd_manager *mqd_mgr;
 	struct device_process_node *cur, *next_dpn;
@@ -1639,24 +1639,26 @@ static int process_termination_cpsch(struct device_queue_manager *dqm,
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

