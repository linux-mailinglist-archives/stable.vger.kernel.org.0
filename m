Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0852F4FD830
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351526AbiDLHWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352587AbiDLHOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:14:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E9F2E0BE;
        Mon, 11 Apr 2022 23:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FF26B81B47;
        Tue, 12 Apr 2022 06:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5941BC385A6;
        Tue, 12 Apr 2022 06:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746488;
        bh=IXY3m/Vsk0pN/xR56n8JlJlq6WlGZzaF811G+aG5+RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0b0A/pXwAQY2WfbY4ynkzrcAlRPDa2DemqRs44/vuVCJmDR0d1KtryHnPYdbWjx8
         z9F5oERsABi3huXACvrqW0idntRO8abByoxC/S6i0zH9YZCJpEq5QtdqsXRmYDz02k
         gF6NX8C55afZkCIodFqOPhGE8SHt1x5ZsXA/MQi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Ruili Ji <ruili.ji@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 023/285] drm/amdkfd: Ensure mm remain valid in svm deferred_list work
Date:   Tue, 12 Apr 2022 08:28:00 +0200
Message-Id: <20220412062944.348720367@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 367c9b0f1b8750a704070e7ae85234d591290434 ]

svm_deferred_list work should continue to handle deferred_range_list
which maybe split to child range to avoid child range leak, and remove
ranges mmu interval notifier to avoid mm mm_count leak. So taking mm
reference when adding range to deferred list, to ensure mm is valid in
the scheduled deferred_list_work, and drop the mm referrence after range
is handled.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reported-by: Ruili Ji <ruili.ji@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 62 ++++++++++++++++------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index c0b8f4ff80b8..ea1c5aaf659a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1926,10 +1926,9 @@ svm_range_update_notifier_and_interval_tree(struct mm_struct *mm,
 }
 
 static void
-svm_range_handle_list_op(struct svm_range_list *svms, struct svm_range *prange)
+svm_range_handle_list_op(struct svm_range_list *svms, struct svm_range *prange,
+			 struct mm_struct *mm)
 {
-	struct mm_struct *mm = prange->work_item.mm;
-
 	switch (prange->work_item.op) {
 	case SVM_OP_NULL:
 		pr_debug("NULL OP 0x%p prange 0x%p [0x%lx 0x%lx]\n",
@@ -2013,34 +2012,41 @@ static void svm_range_deferred_list_work(struct work_struct *work)
 	pr_debug("enter svms 0x%p\n", svms);
 
 	p = container_of(svms, struct kfd_process, svms);
-	/* Avoid mm is gone when inserting mmu notifier */
-	mm = get_task_mm(p->lead_thread);
-	if (!mm) {
-		pr_debug("svms 0x%p process mm gone\n", svms);
-		return;
-	}
-retry:
-	mmap_write_lock(mm);
-
-	/* Checking for the need to drain retry faults must be inside
-	 * mmap write lock to serialize with munmap notifiers.
-	 */
-	if (unlikely(atomic_read(&svms->drain_pagefaults))) {
-		mmap_write_unlock(mm);
-		svm_range_drain_retry_fault(svms);
-		goto retry;
-	}
 
 	spin_lock(&svms->deferred_list_lock);
 	while (!list_empty(&svms->deferred_range_list)) {
 		prange = list_first_entry(&svms->deferred_range_list,
 					  struct svm_range, deferred_list);
-		list_del_init(&prange->deferred_list);
 		spin_unlock(&svms->deferred_list_lock);
 
 		pr_debug("prange 0x%p [0x%lx 0x%lx] op %d\n", prange,
 			 prange->start, prange->last, prange->work_item.op);
 
+		mm = prange->work_item.mm;
+retry:
+		mmap_write_lock(mm);
+
+		/* Checking for the need to drain retry faults must be inside
+		 * mmap write lock to serialize with munmap notifiers.
+		 */
+		if (unlikely(atomic_read(&svms->drain_pagefaults))) {
+			mmap_write_unlock(mm);
+			svm_range_drain_retry_fault(svms);
+			goto retry;
+		}
+
+		/* Remove from deferred_list must be inside mmap write lock, for
+		 * two race cases:
+		 * 1. unmap_from_cpu may change work_item.op and add the range
+		 *    to deferred_list again, cause use after free bug.
+		 * 2. svm_range_list_lock_and_flush_work may hold mmap write
+		 *    lock and continue because deferred_list is empty, but
+		 *    deferred_list work is actually waiting for mmap lock.
+		 */
+		spin_lock(&svms->deferred_list_lock);
+		list_del_init(&prange->deferred_list);
+		spin_unlock(&svms->deferred_list_lock);
+
 		mutex_lock(&svms->lock);
 		mutex_lock(&prange->migrate_mutex);
 		while (!list_empty(&prange->child_list)) {
@@ -2051,19 +2057,20 @@ static void svm_range_deferred_list_work(struct work_struct *work)
 			pr_debug("child prange 0x%p op %d\n", pchild,
 				 pchild->work_item.op);
 			list_del_init(&pchild->child_list);
-			svm_range_handle_list_op(svms, pchild);
+			svm_range_handle_list_op(svms, pchild, mm);
 		}
 		mutex_unlock(&prange->migrate_mutex);
 
-		svm_range_handle_list_op(svms, prange);
+		svm_range_handle_list_op(svms, prange, mm);
 		mutex_unlock(&svms->lock);
+		mmap_write_unlock(mm);
+
+		/* Pairs with mmget in svm_range_add_list_work */
+		mmput(mm);
 
 		spin_lock(&svms->deferred_list_lock);
 	}
 	spin_unlock(&svms->deferred_list_lock);
-
-	mmap_write_unlock(mm);
-	mmput(mm);
 	pr_debug("exit svms 0x%p\n", svms);
 }
 
@@ -2081,6 +2088,9 @@ svm_range_add_list_work(struct svm_range_list *svms, struct svm_range *prange,
 			prange->work_item.op = op;
 	} else {
 		prange->work_item.op = op;
+
+		/* Pairs with mmput in deferred_list_work */
+		mmget(mm);
 		prange->work_item.mm = mm;
 		list_add_tail(&prange->deferred_list,
 			      &prange->svms->deferred_range_list);
-- 
2.35.1



