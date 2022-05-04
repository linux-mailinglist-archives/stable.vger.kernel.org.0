Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C3751A998
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345174AbiEDRSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357072AbiEDROq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253F153E3B;
        Wed,  4 May 2022 09:58:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5690F6194D;
        Wed,  4 May 2022 16:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF5AC385A5;
        Wed,  4 May 2022 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683481;
        bh=rCc4o9i7bE4S0MCi29v1l4VnIYdlUNlewa80LumC7kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALmR3Lb0F1HBk3SQ56kxwtoX7SsZDTdLOZ2gAJfTmu+sdD8Wsre69b3oCpYbz9qfD
         s0CTM8oetRYYtb6+Csk6EwyQUjiuOLr93m8ztdKa2Ditok93sOtNmCGxBxSupeb35q
         FuSqP6Yz+N2x4sNe+mTkaIHU+KDWsdXu+c9KKE18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Yat Sin <david.yatsin@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 143/225] drm/amdkfd: Fix GWS queue count
Date:   Wed,  4 May 2022 18:46:21 +0200
Message-Id: <20220504153122.962872195@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Yat Sin <david.yatsin@amd.com>

[ Upstream commit 7c6b6e18c890f30965b0589b0a57645e1dbccfde ]

dqm->gws_queue_count and pdd->qpd.mapped_gws_queue need to be updated
each time the queue gets evicted.

Fixes: b8020b0304c8 ("drm/amdkfd: Enable over-subscription with >1 GWS queue")
Signed-off-by: David Yat Sin <david.yatsin@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c | 83 +++++++++----------
 1 file changed, 37 insertions(+), 46 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 4b6814949aad..8d40b93747e0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -129,19 +129,33 @@ void program_sh_mem_settings(struct device_queue_manager *dqm,
 }
 
 static void increment_queue_count(struct device_queue_manager *dqm,
-			enum kfd_queue_type type)
+				  struct qcm_process_device *qpd,
+				  struct queue *q)
 {
 	dqm->active_queue_count++;
-	if (type == KFD_QUEUE_TYPE_COMPUTE || type == KFD_QUEUE_TYPE_DIQ)
+	if (q->properties.type == KFD_QUEUE_TYPE_COMPUTE ||
+	    q->properties.type == KFD_QUEUE_TYPE_DIQ)
 		dqm->active_cp_queue_count++;
+
+	if (q->properties.is_gws) {
+		dqm->gws_queue_count++;
+		qpd->mapped_gws_queue = true;
+	}
 }
 
 static void decrement_queue_count(struct device_queue_manager *dqm,
-			enum kfd_queue_type type)
+				  struct qcm_process_device *qpd,
+				  struct queue *q)
 {
 	dqm->active_queue_count--;
-	if (type == KFD_QUEUE_TYPE_COMPUTE || type == KFD_QUEUE_TYPE_DIQ)
+	if (q->properties.type == KFD_QUEUE_TYPE_COMPUTE ||
+	    q->properties.type == KFD_QUEUE_TYPE_DIQ)
 		dqm->active_cp_queue_count--;
+
+	if (q->properties.is_gws) {
+		dqm->gws_queue_count--;
+		qpd->mapped_gws_queue = false;
+	}
 }
 
 static int allocate_doorbell(struct qcm_process_device *qpd, struct queue *q)
@@ -380,7 +394,7 @@ static int create_queue_nocpsch(struct device_queue_manager *dqm,
 	list_add(&q->list, &qpd->queues_list);
 	qpd->queue_count++;
 	if (q->properties.is_active)
-		increment_queue_count(dqm, q->properties.type);
+		increment_queue_count(dqm, qpd, q);
 
 	/*
 	 * Unconditionally increment this counter, regardless of the queue's
@@ -505,13 +519,8 @@ static int destroy_queue_nocpsch_locked(struct device_queue_manager *dqm,
 		deallocate_vmid(dqm, qpd, q);
 	}
 	qpd->queue_count--;
-	if (q->properties.is_active) {
-		decrement_queue_count(dqm, q->properties.type);
-		if (q->properties.is_gws) {
-			dqm->gws_queue_count--;
-			qpd->mapped_gws_queue = false;
-		}
-	}
+	if (q->properties.is_active)
+		decrement_queue_count(dqm, qpd, q);
 
 	return retval;
 }
@@ -604,12 +613,11 @@ static int update_queue(struct device_queue_manager *dqm, struct queue *q,
 	 * dqm->active_queue_count to determine whether a new runlist must be
 	 * uploaded.
 	 */
-	if (q->properties.is_active && !prev_active)
-		increment_queue_count(dqm, q->properties.type);
-	else if (!q->properties.is_active && prev_active)
-		decrement_queue_count(dqm, q->properties.type);
-
-	if (q->gws && !q->properties.is_gws) {
+	if (q->properties.is_active && !prev_active) {
+		increment_queue_count(dqm, &pdd->qpd, q);
+	} else if (!q->properties.is_active && prev_active) {
+		decrement_queue_count(dqm, &pdd->qpd, q);
+	} else if (q->gws && !q->properties.is_gws) {
 		if (q->properties.is_active) {
 			dqm->gws_queue_count++;
 			pdd->qpd.mapped_gws_queue = true;
@@ -671,11 +679,7 @@ static int evict_process_queues_nocpsch(struct device_queue_manager *dqm,
 		mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 				q->properties.type)];
 		q->properties.is_active = false;
-		decrement_queue_count(dqm, q->properties.type);
-		if (q->properties.is_gws) {
-			dqm->gws_queue_count--;
-			qpd->mapped_gws_queue = false;
-		}
+		decrement_queue_count(dqm, qpd, q);
 
 		if (WARN_ONCE(!dqm->sched_running, "Evict when stopped\n"))
 			continue;
@@ -721,7 +725,7 @@ static int evict_process_queues_cpsch(struct device_queue_manager *dqm,
 			continue;
 
 		q->properties.is_active = false;
-		decrement_queue_count(dqm, q->properties.type);
+		decrement_queue_count(dqm, qpd, q);
 	}
 	pdd->last_evict_timestamp = get_jiffies_64();
 	retval = execute_queues_cpsch(dqm,
@@ -792,11 +796,7 @@ static int restore_process_queues_nocpsch(struct device_queue_manager *dqm,
 		mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 				q->properties.type)];
 		q->properties.is_active = true;
-		increment_queue_count(dqm, q->properties.type);
-		if (q->properties.is_gws) {
-			dqm->gws_queue_count++;
-			qpd->mapped_gws_queue = true;
-		}
+		increment_queue_count(dqm, qpd, q);
 
 		if (WARN_ONCE(!dqm->sched_running, "Restore when stopped\n"))
 			continue;
@@ -854,7 +854,7 @@ static int restore_process_queues_cpsch(struct device_queue_manager *dqm,
 			continue;
 
 		q->properties.is_active = true;
-		increment_queue_count(dqm, q->properties.type);
+		increment_queue_count(dqm, &pdd->qpd, q);
 	}
 	retval = execute_queues_cpsch(dqm,
 				KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
@@ -1260,7 +1260,7 @@ static int create_kernel_queue_cpsch(struct device_queue_manager *dqm,
 			dqm->total_queue_count);
 
 	list_add(&kq->list, &qpd->priv_queue_list);
-	increment_queue_count(dqm, kq->queue->properties.type);
+	increment_queue_count(dqm, qpd, kq->queue);
 	qpd->is_debug = true;
 	execute_queues_cpsch(dqm, KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
 	dqm_unlock(dqm);
@@ -1274,7 +1274,7 @@ static void destroy_kernel_queue_cpsch(struct device_queue_manager *dqm,
 {
 	dqm_lock(dqm);
 	list_del(&kq->list);
-	decrement_queue_count(dqm, kq->queue->properties.type);
+	decrement_queue_count(dqm, qpd, kq->queue);
 	qpd->is_debug = false;
 	execute_queues_cpsch(dqm, KFD_UNMAP_QUEUES_FILTER_ALL_QUEUES, 0);
 	/*
@@ -1341,7 +1341,7 @@ static int create_queue_cpsch(struct device_queue_manager *dqm, struct queue *q,
 	qpd->queue_count++;
 
 	if (q->properties.is_active) {
-		increment_queue_count(dqm, q->properties.type);
+		increment_queue_count(dqm, qpd, q);
 
 		execute_queues_cpsch(dqm,
 				KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
@@ -1558,15 +1558,11 @@ static int destroy_queue_cpsch(struct device_queue_manager *dqm,
 	list_del(&q->list);
 	qpd->queue_count--;
 	if (q->properties.is_active) {
-		decrement_queue_count(dqm, q->properties.type);
+		decrement_queue_count(dqm, qpd, q);
 		retval = execute_queues_cpsch(dqm,
 				KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
 		if (retval == -ETIME)
 			qpd->reset_wavefronts = true;
-		if (q->properties.is_gws) {
-			dqm->gws_queue_count--;
-			qpd->mapped_gws_queue = false;
-		}
 	}
 
 	/*
@@ -1757,7 +1753,7 @@ static int process_termination_cpsch(struct device_queue_manager *dqm,
 	/* Clean all kernel queues */
 	list_for_each_entry_safe(kq, kq_next, &qpd->priv_queue_list, list) {
 		list_del(&kq->list);
-		decrement_queue_count(dqm, kq->queue->properties.type);
+		decrement_queue_count(dqm, qpd, kq->queue);
 		qpd->is_debug = false;
 		dqm->total_queue_count--;
 		filter = KFD_UNMAP_QUEUES_FILTER_ALL_QUEUES;
@@ -1770,13 +1766,8 @@ static int process_termination_cpsch(struct device_queue_manager *dqm,
 		else if (q->properties.type == KFD_QUEUE_TYPE_SDMA_XGMI)
 			deallocate_sdma_queue(dqm, q);
 
-		if (q->properties.is_active) {
-			decrement_queue_count(dqm, q->properties.type);
-			if (q->properties.is_gws) {
-				dqm->gws_queue_count--;
-				qpd->mapped_gws_queue = false;
-			}
-		}
+		if (q->properties.is_active)
+			decrement_queue_count(dqm, qpd, q);
 
 		dqm->total_queue_count--;
 	}
-- 
2.35.1



