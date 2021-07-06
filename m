Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ECC3BCFD9
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhGFLbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235068AbhGFL3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1329B61D6F;
        Tue,  6 Jul 2021 11:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570434;
        bh=DdM/QtZXD7pf1Ou7w+R2eAax2FtnYf4YG/2ZosDBU5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGYx6F0XNQz0xy+024tA8BtMteFrOiJGs4be3fKWNHiPbEuKFQ4qXIECHbxg0izyd
         g1thPgDB8KWIpVcV9stBRqXsf74CP/fAB++bNVR8GBo+FzqLdN5yhH/g8pBUmXNYC1
         A/76r/IrYm9PJW3+Lpdw+sLoKzWJoL9cyDLYbvJkGJyFjWn2/wLfKghOLbaRXduYSX
         Cr41PAMum8W4CwJOpH8ok0SWHToxkfoBjx3A2AzIuTaRtjBGuovWq7bgYLer72EPst
         Bwh7Pk1S4nr26zHRIYhP8Nv/TTChSGhnAAc1Tsv99FI4ayNpSsaGdfzU1NE+PLQsyJ
         VsHi9NwmkNPsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amber Lin <Amber.Lin@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 096/160] drm/amdkfd: Fix circular lock in nocpsch path
Date:   Tue,  6 Jul 2021 07:17:22 -0400
Message-Id: <20210706111827.2060499-96-sashal@kernel.org>
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

From: Amber Lin <Amber.Lin@amd.com>

[ Upstream commit a7b2451d31cfa2e8aeccf3b35612ce33f02371fc ]

Calling free_mqd inside of destroy_queue_nocpsch_locked can cause a
circular lock. destroy_queue_nocpsch_locked is called under a DQM lock,
which is taken in MMU notifiers, potentially in FS reclaim context.
Taking another lock, which is BO reservation lock from free_mqd, while
causing an FS reclaim inside the DQM lock creates a problematic circular
lock dependency. Therefore move free_mqd out of
destroy_queue_nocpsch_locked and call it after unlocking DQM.

Signed-off-by: Amber Lin <Amber.Lin@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c  | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index df05eca73275..3d66565a618f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -486,9 +486,6 @@ static int destroy_queue_nocpsch_locked(struct device_queue_manager *dqm,
 	if (retval == -ETIME)
 		qpd->reset_wavefronts = true;
 
-
-	mqd_mgr->free_mqd(mqd_mgr, q->mqd, q->mqd_mem_obj);
-
 	list_del(&q->list);
 	if (list_empty(&qpd->queues_list)) {
 		if (qpd->reset_wavefronts) {
@@ -523,6 +520,8 @@ static int destroy_queue_nocpsch(struct device_queue_manager *dqm,
 	int retval;
 	uint64_t sdma_val = 0;
 	struct kfd_process_device *pdd = qpd_to_pdd(qpd);
+	struct mqd_manager *mqd_mgr =
+		dqm->mqd_mgrs[get_mqd_type_from_queue_type(q->properties.type)];
 
 	/* Get the SDMA queue stats */
 	if ((q->properties.type == KFD_QUEUE_TYPE_SDMA) ||
@@ -540,6 +539,8 @@ static int destroy_queue_nocpsch(struct device_queue_manager *dqm,
 		pdd->sdma_past_activity_counter += sdma_val;
 	dqm_unlock(dqm);
 
+	mqd_mgr->free_mqd(mqd_mgr, q->mqd, q->mqd_mem_obj);
+
 	return retval;
 }
 
@@ -1632,7 +1633,7 @@ static int set_trap_handler(struct device_queue_manager *dqm,
 static int process_termination_nocpsch(struct device_queue_manager *dqm,
 		struct qcm_process_device *qpd)
 {
-	struct queue *q, *next;
+	struct queue *q;
 	struct device_process_node *cur, *next_dpn;
 	int retval = 0;
 	bool found = false;
@@ -1640,12 +1641,19 @@ static int process_termination_nocpsch(struct device_queue_manager *dqm,
 	dqm_lock(dqm);
 
 	/* Clear all user mode queues */
-	list_for_each_entry_safe(q, next, &qpd->queues_list, list) {
+	while (!list_empty(&qpd->queues_list)) {
+		struct mqd_manager *mqd_mgr;
 		int ret;
 
+		q = list_first_entry(&qpd->queues_list, struct queue, list);
+		mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
+				q->properties.type)];
 		ret = destroy_queue_nocpsch_locked(dqm, qpd, q);
 		if (ret)
 			retval = ret;
+		dqm_unlock(dqm);
+		mqd_mgr->free_mqd(mqd_mgr, q->mqd, q->mqd_mem_obj);
+		dqm_lock(dqm);
 	}
 
 	/* Unregister process */
-- 
2.30.2

