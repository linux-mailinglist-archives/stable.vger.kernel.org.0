Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2314EF1AC
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiDAOlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244516AbiDAOkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:40:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A1D1EF5F8;
        Fri,  1 Apr 2022 07:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2F58B8250B;
        Fri,  1 Apr 2022 14:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE36C36AF4;
        Fri,  1 Apr 2022 14:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823625;
        bh=79kk4rKKKH4bZf4gLkl04KEgB6jhlh5M0cMe1/rnz3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnU3rnFKXD1l53OJINmkHieM8MxTxi115gaaopO/d71C8IwEY+w1xnGF1z7ECIgK/
         6ex53qV9l9nEPHxW8Mr/oyllTYSxfYaATr+523hLHvHfW3m7/bicpVHdV//aRUdenI
         sCQ8Tl2rlN1bSZ9b+Fplnx46xdRnGEMvkq18AfCJB1rJJ3yIXwS5BRUPj+7JfAZray
         ewDrc2SH2fvD+iGcLvqm6yhZ4y6yUoaGq6pCoiJukwnVeagADtHFUviHE8OIRupdYj
         GnANWFRIOcFNYaStfDIunc7891CQ+FjeeLBtCJmI00QHFh73I41re0a1XXDIdKSn/o
         7ESfdFSAVwZDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>, Ruili Ji <ruili.ji@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 016/109] drm/amdkfd: Ensure mm remain valid in svm deferred_list work
Date:   Fri,  1 Apr 2022 10:31:23 -0400
Message-Id: <20220401143256.1950537-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.34.1

