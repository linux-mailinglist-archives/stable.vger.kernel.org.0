Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE34D4FDA79
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbiDLHgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356022AbiDLHaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF044FC6F;
        Tue, 12 Apr 2022 00:08:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0084616A9;
        Tue, 12 Apr 2022 07:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE465C385A8;
        Tue, 12 Apr 2022 07:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747306;
        bh=e4Q/swAJT5i/cd9ObonPjAQOyqAx6WFs2Yug5hfJQ+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ChTcI1CP8hoS45uUu5p9SQrEScY/4dfCRglilhYp0g4u5gkqdteAEyxniQvxeOWIq
         p+ML6z0Up3MeUqxZXRROz4AMX0Rg1sSjrSPYSEitlvF0Jl1Sgc1NIstLAZEeu9D6WQ
         EP6aXu/nvpx9VDnIyahDEnynAnCEcJ8anM/0vXQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Ruili Ji <ruili.ji@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 032/343] drm/amdkfd: svm range restore work deadlock when process exit
Date:   Tue, 12 Apr 2022 08:27:30 +0200
Message-Id: <20220412062952.033715124@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

[ Upstream commit 6225bb3a88d22594aacea2485dc28ca12d596721 ]

kfd_process_notifier_release flush svm_range_restore_work
which calls svm_range_list_lock_and_flush_work to flush deferred_list
work, but if deferred_list work mmput release the last user, it will
call exit_mmap -> notifier_release, it is deadlock with below backtrace.

Move flush svm_range_restore_work to kfd_process_wq_release to avoid
deadlock. Then svm_range_restore_work take task->mm ref to avoid mm is
gone while validating and mapping ranges to GPU.

Workqueue: events svm_range_deferred_list_work [amdgpu]
Call Trace:
 wait_for_completion+0x94/0x100
 __flush_work+0x12a/0x1e0
 __cancel_work_timer+0x10e/0x190
 cancel_delayed_work_sync+0x13/0x20
 kfd_process_notifier_release+0x98/0x2a0 [amdgpu]
 __mmu_notifier_release+0x74/0x1f0
 exit_mmap+0x170/0x200
 mmput+0x5d/0x130
 svm_range_deferred_list_work+0x104/0x230 [amdgpu]
 process_one_work+0x220/0x3c0

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reported-by: Ruili Ji <ruili.ji@amd.com>
Tested-by: Ruili Ji <ruili.ji@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c |  1 -
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c     | 15 +++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index d1145da5348f..74f162887d3b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1150,7 +1150,6 @@ static void kfd_process_notifier_release(struct mmu_notifier *mn,
 
 	cancel_delayed_work_sync(&p->eviction_work);
 	cancel_delayed_work_sync(&p->restore_work);
-	cancel_delayed_work_sync(&p->svms.restore_work);
 
 	mutex_lock(&p->mutex);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 225affcddbc1..1cf9041c9727 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1643,13 +1643,14 @@ static void svm_range_restore_work(struct work_struct *work)
 
 	pr_debug("restore svm ranges\n");
 
-	/* kfd_process_notifier_release destroys this worker thread. So during
-	 * the lifetime of this thread, kfd_process and mm will be valid.
-	 */
 	p = container_of(svms, struct kfd_process, svms);
-	mm = p->mm;
-	if (!mm)
+
+	/* Keep mm reference when svm_range_validate_and_map ranges */
+	mm = get_task_mm(p->lead_thread);
+	if (!mm) {
+		pr_debug("svms 0x%p process mm gone\n", svms);
 		return;
+	}
 
 	svm_range_list_lock_and_flush_work(svms, mm);
 	mutex_lock(&svms->lock);
@@ -1703,6 +1704,7 @@ static void svm_range_restore_work(struct work_struct *work)
 out_reschedule:
 	mutex_unlock(&svms->lock);
 	mmap_write_unlock(mm);
+	mmput(mm);
 
 	/* If validation failed, reschedule another attempt */
 	if (evicted_ranges) {
@@ -2840,6 +2842,8 @@ void svm_range_list_fini(struct kfd_process *p)
 
 	pr_debug("pasid 0x%x svms 0x%p\n", p->pasid, &p->svms);
 
+	cancel_delayed_work_sync(&p->svms.restore_work);
+
 	/* Ensure list work is finished before process is destroyed */
 	flush_work(&p->svms.deferred_list_work);
 
@@ -2850,7 +2854,6 @@ void svm_range_list_fini(struct kfd_process *p)
 	atomic_inc(&p->svms.drain_pagefaults);
 	svm_range_drain_retry_fault(&p->svms);
 
-
 	list_for_each_entry_safe(prange, next, &p->svms.list, list) {
 		svm_range_unlink(prange);
 		svm_range_remove_notifier(prange);
-- 
2.35.1



