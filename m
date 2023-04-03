Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF7D6D4A5D
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbjDCOqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbjDCOq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:46:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828AD280FB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6F90B81D51
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B02C433EF;
        Mon,  3 Apr 2023 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533163;
        bh=gelvFvMvURmRLNCZnWXCKgk4dLWxrbXorcbSCtb53hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ugZvOHxywngGzjzOvGfb6Ssj1dBZIBuG7h6cT4KUb0+kTnSM4OedwOlXKS0QASOT
         X6IuTvHLq2+4Qb8RFJWHGMFYo5Suc8V/E3oKvK8IzTnfgXMRDQmzgzIsLrbfij42Nq
         MeiU5YzZSpkhA0VMr3+xLPQzrgKchuQLa/rTYvBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Belanger <david.belanger@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 051/187] drm/amdkfd: Fixed kfd_process cleanup on module exit.
Date:   Mon,  3 Apr 2023 16:08:16 +0200
Message-Id: <20230403140417.668554494@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Belanger <david.belanger@amd.com>

[ Upstream commit 20bc9f76b6a2455c6b54b91ae7634f147f64987f ]

Handle case when module is unloaded (kfd_exit) before a process space
(mm_struct) is released.

v2: Fixed potential race conditions by removing all kfd_process from
the process table first, then working on releasing the resources.

v3: Fixed loop element access / synchronization.  Fixed extra empty lines.

Signed-off-by: David Belanger <david.belanger@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_module.c  |  1 +
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h    |  1 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 67 +++++++++++++++++++++---
 3 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_module.c b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
index 09b966dc37681..aee2212e52f69 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
@@ -77,6 +77,7 @@ static int kfd_init(void)
 
 static void kfd_exit(void)
 {
+	kfd_cleanup_processes();
 	kfd_debugfs_fini();
 	kfd_process_destroy_wq();
 	kfd_procfs_shutdown();
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 552c3ac85a132..7dc55919993c0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -926,6 +926,7 @@ bool kfd_dev_is_large_bar(struct kfd_dev *dev);
 
 int kfd_process_create_wq(void);
 void kfd_process_destroy_wq(void);
+void kfd_cleanup_processes(void);
 struct kfd_process *kfd_create_process(struct file *filep);
 struct kfd_process *kfd_get_process(const struct task_struct *task);
 struct kfd_process *kfd_lookup_process_by_pasid(u32 pasid);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 51b1683ac5c1e..4d9f2d1c49b1d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1167,6 +1167,17 @@ static void kfd_process_free_notifier(struct mmu_notifier *mn)
 	kfd_unref_process(container_of(mn, struct kfd_process, mmu_notifier));
 }
 
+static void kfd_process_notifier_release_internal(struct kfd_process *p)
+{
+	cancel_delayed_work_sync(&p->eviction_work);
+	cancel_delayed_work_sync(&p->restore_work);
+
+	/* Indicate to other users that MM is no longer valid */
+	p->mm = NULL;
+
+	mmu_notifier_put(&p->mmu_notifier);
+}
+
 static void kfd_process_notifier_release(struct mmu_notifier *mn,
 					struct mm_struct *mm)
 {
@@ -1181,17 +1192,22 @@ static void kfd_process_notifier_release(struct mmu_notifier *mn,
 		return;
 
 	mutex_lock(&kfd_processes_mutex);
+	/*
+	 * Do early return if table is empty.
+	 *
+	 * This could potentially happen if this function is called concurrently
+	 * by mmu_notifier and by kfd_cleanup_pocesses.
+	 *
+	 */
+	if (hash_empty(kfd_processes_table)) {
+		mutex_unlock(&kfd_processes_mutex);
+		return;
+	}
 	hash_del_rcu(&p->kfd_processes);
 	mutex_unlock(&kfd_processes_mutex);
 	synchronize_srcu(&kfd_processes_srcu);
 
-	cancel_delayed_work_sync(&p->eviction_work);
-	cancel_delayed_work_sync(&p->restore_work);
-
-	/* Indicate to other users that MM is no longer valid */
-	p->mm = NULL;
-
-	mmu_notifier_put(&p->mmu_notifier);
+	kfd_process_notifier_release_internal(p);
 }
 
 static const struct mmu_notifier_ops kfd_process_mmu_notifier_ops = {
@@ -1200,6 +1216,43 @@ static const struct mmu_notifier_ops kfd_process_mmu_notifier_ops = {
 	.free_notifier = kfd_process_free_notifier,
 };
 
+/*
+ * This code handles the case when driver is being unloaded before all
+ * mm_struct are released.  We need to safely free the kfd_process and
+ * avoid race conditions with mmu_notifier that might try to free them.
+ *
+ */
+void kfd_cleanup_processes(void)
+{
+	struct kfd_process *p;
+	struct hlist_node *p_temp;
+	unsigned int temp;
+	HLIST_HEAD(cleanup_list);
+
+	/*
+	 * Move all remaining kfd_process from the process table to a
+	 * temp list for processing.   Once done, callback from mmu_notifier
+	 * release will not see the kfd_process in the table and do early return,
+	 * avoiding double free issues.
+	 */
+	mutex_lock(&kfd_processes_mutex);
+	hash_for_each_safe(kfd_processes_table, temp, p_temp, p, kfd_processes) {
+		hash_del_rcu(&p->kfd_processes);
+		synchronize_srcu(&kfd_processes_srcu);
+		hlist_add_head(&p->kfd_processes, &cleanup_list);
+	}
+	mutex_unlock(&kfd_processes_mutex);
+
+	hlist_for_each_entry_safe(p, p_temp, &cleanup_list, kfd_processes)
+		kfd_process_notifier_release_internal(p);
+
+	/*
+	 * Ensures that all outstanding free_notifier get called, triggering
+	 * the release of the kfd_process struct.
+	 */
+	mmu_notifier_synchronize();
+}
+
 static int kfd_process_init_cwsr_apu(struct kfd_process *p, struct file *filep)
 {
 	unsigned long  offset;
-- 
2.39.2



