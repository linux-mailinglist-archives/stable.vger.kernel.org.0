Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5DAC3B53E
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 14:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389439AbfFJMwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 08:52:07 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:26243 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388373AbfFJMwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 08:52:07 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 10 Jun 2019 05:51:59 -0700
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 6C6AE40E0B;
        Mon, 10 Jun 2019 05:52:01 -0700 (PDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <aarcange@redhat.com>, <jannh@google.com>, <oleg@redhat.com>,
        <peterx@redhat.com>, <rppt@linux.ibm.com>, <jgg@mellanox.com>,
        <mhocko@suse.com>
CC:     <yishaih@mellanox.com>, <dledford@redhat.com>,
        <sean.hefty@intel.com>, <hal.rosenstock@gmail.com>,
        <matanb@mellanox.com>, <leonro@mellanox.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <akaher@vmware.com>,
        <srivatsab@vmware.com>, <amakhalov@vmware.com>
Subject: [PATCH] [v4.14.y] infiniband: fix race condition between infiniband mlx4, mlx5  driver and core dumping
Date:   Tue, 11 Jun 2019 02:22:17 +0530
Message-ID: <1560199937-23476-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch is the extension of following upstream commit to fix
the race condition between get_task_mm() and core dumping
for IB->mlx4 and IB->mlx5 drivers:

commit 04f5866e41fb ("coredump: fix race condition between
mmget_not_zero()/get_task_mm() and core dumping")'

Thanks to Jason for pointing this.

Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 drivers/infiniband/hw/mlx4/main.c | 4 +++-
 drivers/infiniband/hw/mlx5/main.c | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index e2beb18..0299c06 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1197,6 +1197,8 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 	 * mlx4_ib_vma_close().
 	 */
 	down_write(&owning_mm->mmap_sem);
+	if (!mmget_still_valid(owning_mm))
+		goto skip_mm;
 	for (i = 0; i < HW_BAR_COUNT; i++) {
 		vma = context->hw_bar_info[i].vma;
 		if (!vma)
@@ -1215,7 +1217,7 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 		/* context going to be destroyed, should not access ops any more */
 		context->hw_bar_info[i].vma->vm_ops = NULL;
 	}
-
+skip_mm:
 	up_write(&owning_mm->mmap_sem);
 	mmput(owning_mm);
 	put_task_struct(owning_process);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 13a9206..3fbe396 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1646,6 +1646,8 @@ static void mlx5_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 	 * mlx5_ib_vma_close.
 	 */
 	down_write(&owning_mm->mmap_sem);
+	if (!mmget_still_valid(owning_mm))
+		goto skip_mm;
 	mutex_lock(&context->vma_private_list_mutex);
 	list_for_each_entry_safe(vma_private, n, &context->vma_private_list,
 				 list) {
@@ -1662,6 +1664,7 @@ static void mlx5_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 		kfree(vma_private);
 	}
 	mutex_unlock(&context->vma_private_list_mutex);
+skip_mm:
 	up_write(&owning_mm->mmap_sem);
 	mmput(owning_mm);
 	put_task_struct(owning_process);
-- 
2.7.4

