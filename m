Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E50E417406
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344178AbhIXNBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345872AbhIXM7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CD4961368;
        Fri, 24 Sep 2021 12:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488010;
        bh=6uEYMvBcTQpGEgi0kVNY9QyC9rcgAmCxvljDyn4gBM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXHQlFmezsMm6TWk+mv7KFynKheGPAPWtvzo3eBkLbGXnOXJOudSSj5b8laHLkysh
         dcyqoQVm044N0jn6LaO2brWOoUTVQdI4uCzXgvOpMiwDF9OpnBP2T64/JcyZM655Qt
         0I4F1PBgKsy6v5bfdTzKugEfpOcCKr7yC6aIrVGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 5.14 049/100] iommu/vt-d: Fix a deadlock in intel_svm_drain_prq()
Date:   Fri, 24 Sep 2021 14:43:58 +0200
Message-Id: <20210924124343.085911292@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit 6ef0505158f7ca1b32763a3b038b5d11296b642b ]

pasid_mutex and dev->iommu->param->lock are held while unbinding mm is
flushing IO page fault workqueue and waiting for all page fault works to
finish. But an in-flight page fault work also need to hold the two locks
while unbinding mm are holding them and waiting for the work to finish.
This may cause an ABBA deadlock issue as shown below:

	idxd 0000:00:0a.0: unbind PASID 2
	======================================================
	WARNING: possible circular locking dependency detected
	5.14.0-rc7+ #549 Not tainted [  186.615245] ----------
	dsa_test/898 is trying to acquire lock:
	ffff888100d854e8 (&param->lock){+.+.}-{3:3}, at:
	iopf_queue_flush_dev+0x29/0x60
	but task is already holding lock:
	ffffffff82b2f7c8 (pasid_mutex){+.+.}-{3:3}, at:
	intel_svm_unbind+0x34/0x1e0
	which lock already depends on the new lock.

	the existing dependency chain (in reverse order) is:

	-> #2 (pasid_mutex){+.+.}-{3:3}:
	       __mutex_lock+0x75/0x730
	       mutex_lock_nested+0x1b/0x20
	       intel_svm_page_response+0x8e/0x260
	       iommu_page_response+0x122/0x200
	       iopf_handle_group+0x1c2/0x240
	       process_one_work+0x2a5/0x5a0
	       worker_thread+0x55/0x400
	       kthread+0x13b/0x160
	       ret_from_fork+0x22/0x30

	-> #1 (&param->fault_param->lock){+.+.}-{3:3}:
	       __mutex_lock+0x75/0x730
	       mutex_lock_nested+0x1b/0x20
	       iommu_report_device_fault+0xc2/0x170
	       prq_event_thread+0x28a/0x580
	       irq_thread_fn+0x28/0x60
	       irq_thread+0xcf/0x180
	       kthread+0x13b/0x160
	       ret_from_fork+0x22/0x30

	-> #0 (&param->lock){+.+.}-{3:3}:
	       __lock_acquire+0x1134/0x1d60
	       lock_acquire+0xc6/0x2e0
	       __mutex_lock+0x75/0x730
	       mutex_lock_nested+0x1b/0x20
	       iopf_queue_flush_dev+0x29/0x60
	       intel_svm_drain_prq+0x127/0x210
	       intel_svm_unbind+0xc5/0x1e0
	       iommu_sva_unbind_device+0x62/0x80
	       idxd_cdev_release+0x15a/0x200 [idxd]
	       __fput+0x9c/0x250
	       ____fput+0xe/0x10
	       task_work_run+0x64/0xa0
	       exit_to_user_mode_prepare+0x227/0x230
	       syscall_exit_to_user_mode+0x2c/0x60
	       do_syscall_64+0x48/0x90
	       entry_SYSCALL_64_after_hwframe+0x44/0xae

	other info that might help us debug this:

	Chain exists of:
	  &param->lock --> &param->fault_param->lock --> pasid_mutex

	 Possible unsafe locking scenario:

	       CPU0                    CPU1
	       ----                    ----
	  lock(pasid_mutex);
				       lock(&param->fault_param->lock);
				       lock(pasid_mutex);
	  lock(&param->lock);

	 *** DEADLOCK ***

	2 locks held by dsa_test/898:
	 #0: ffff888100cc1cc0 (&group->mutex){+.+.}-{3:3}, at:
	 iommu_sva_unbind_device+0x53/0x80
	 #1: ffffffff82b2f7c8 (pasid_mutex){+.+.}-{3:3}, at:
	 intel_svm_unbind+0x34/0x1e0

	stack backtrace:
	CPU: 2 PID: 898 Comm: dsa_test Not tainted 5.14.0-rc7+ #549
	Hardware name: Intel Corporation Kabylake Client platform/KBL S
	DDR4 UD IMM CRB, BIOS KBLSE2R1.R00.X050.P01.1608011715 08/01/2016
	Call Trace:
	 dump_stack_lvl+0x5b/0x74
	 dump_stack+0x10/0x12
	 print_circular_bug.cold+0x13d/0x142
	 check_noncircular+0xf1/0x110
	 __lock_acquire+0x1134/0x1d60
	 lock_acquire+0xc6/0x2e0
	 ? iopf_queue_flush_dev+0x29/0x60
	 ? pci_mmcfg_read+0xde/0x240
	 __mutex_lock+0x75/0x730
	 ? iopf_queue_flush_dev+0x29/0x60
	 ? pci_mmcfg_read+0xfd/0x240
	 ? iopf_queue_flush_dev+0x29/0x60
	 mutex_lock_nested+0x1b/0x20
	 iopf_queue_flush_dev+0x29/0x60
	 intel_svm_drain_prq+0x127/0x210
	 ? intel_pasid_tear_down_entry+0x22e/0x240
	 intel_svm_unbind+0xc5/0x1e0
	 iommu_sva_unbind_device+0x62/0x80
	 idxd_cdev_release+0x15a/0x200

pasid_mutex protects pasid and svm data mapping data. It's unnecessary
to hold pasid_mutex while flushing the workqueue. To fix the deadlock
issue, unlock pasid_pasid during flushing the workqueue to allow the works
to be handled.

Fixes: d5b9e4bfe0d8 ("iommu/vt-d: Report prq to io-pgfault framework")
Reported-and-tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20210826215918.4073446-1-fenghua.yu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210828070622.2437559-3-baolu.lu@linux.intel.com
[joro: Removed timing information from kernel log messages]
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/svm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index ceeca633a5f9..d575082567ca 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -793,7 +793,19 @@ prq_retry:
 		goto prq_retry;
 	}
 
+	/*
+	 * A work in IO page fault workqueue may try to lock pasid_mutex now.
+	 * Holding pasid_mutex while waiting in iopf_queue_flush_dev() for
+	 * all works in the workqueue to finish may cause deadlock.
+	 *
+	 * It's unnecessary to hold pasid_mutex in iopf_queue_flush_dev().
+	 * Unlock it to allow the works to be handled while waiting for
+	 * them to finish.
+	 */
+	lockdep_assert_held(&pasid_mutex);
+	mutex_unlock(&pasid_mutex);
 	iopf_queue_flush_dev(dev);
+	mutex_lock(&pasid_mutex);
 
 	/*
 	 * Perform steps described in VT-d spec CH7.10 to drain page
-- 
2.33.0



