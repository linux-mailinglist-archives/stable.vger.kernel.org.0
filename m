Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E458C3BD147
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbhGFLi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236733AbhGFLfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D82361E32;
        Tue,  6 Jul 2021 11:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570648;
        bh=ywqNzcJWC1iCcLtLuxp5/Cii7zk7uyXau/bWP/zwWdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGnbFEpPClTebDZ0ltgXwnEg+IcMEgMr7YpAmYuJtUYYlR5xZGWn3/V53M8ol2EV9
         1wT8DVsukaHiO4FHEBrxuzhW12a0yfdK/z184rbsth68McSBj01sQR/FQmUC8d3z2c
         q+fvz1nwDB/Z4Eu7Rcpnmla3dpj4nE4REkR04ELoHpzn0aGfpwCMYfAm+GcRLSeXVQ
         LjHEoemqRmL5g/jAW3Bzy0Md4NVqK3j7FaYJB3IloCKD6n2OkLNBkUccbKzrIF86Fl
         SbVtScmUbgDrh93di+uI2rn1cPmWtCK545wk3dZY4kLzVui4/R7oL2xSP6uUQoCYTZ
         +dbaoj0AZWxKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xinhui pan <xinhui.pan@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 096/137] drm/amdkfd: Walk through list with dqm lock hold
Date:   Tue,  6 Jul 2021 07:21:22 -0400
Message-Id: <20210706112203.2062605-96-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index ffb3d37881a8..352a32dc609b 100644
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

