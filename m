Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542563CA8A1
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243308AbhGOTBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242255AbhGOTBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:01:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E01D613CF;
        Thu, 15 Jul 2021 18:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375477;
        bh=pOJ1w1dBinbT0HX1LaUNE1gDjLBmaqvMRUrFCRootGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfkmTqyZVbYmpnovdgu/s8ELfIxSTvptOJJGoCXYWRR4UaTpTEi8RAOBhG3PXuYww
         nOME00DKSDnW0/jsf+joowoyOjwpTSiU5FfJWC0xEKj/CA4HMqwNViqAI1eQ3ixeGl
         L0d+pLZmuYEbiGbB9ipPrinpbfCySksclLwfLMTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xinhui pan <xinhui.pan@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 103/242] drm/amdkfd: Walk through list with dqm lock hold
Date:   Thu, 15 Jul 2021 20:37:45 +0200
Message-Id: <20210715182611.175415633@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



