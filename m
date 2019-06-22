Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3D34F3C2
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 07:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfFVFCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 01:02:16 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:26713 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbfFVFCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 01:02:16 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 21 Jun 2019 22:02:11 -0700
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 07D5C416DE;
        Fri, 21 Jun 2019 22:02:08 -0700 (PDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <aarcange@redhat.com>, <jannh@google.com>, <oleg@redhat.com>,
        <peterx@redhat.com>, <rppt@linux.ibm.com>, <jgg@mellanox.com>,
        <mhocko@suse.com>
CC:     <jglisse@redhat.com>, <akpm@linux-foundation.org>,
        <mike.kravetz@oracle.com>, <viro@zeniv.linux.org.uk>,
        <riandrews@android.com>, <arve@android.com>,
        <yishaih@mellanox.com>, <dledford@redhat.com>,
        <sean.hefty@intel.com>, <hal.rosenstock@gmail.com>,
        <matanb@mellanox.com>, <leonro@mellanox.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@driverdev.osuosl.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <akaher@vmware.com>, <srivatsab@vmware.com>, <amakhalov@vmware.com>
Subject: [PATCH v3 2/2][v4.9.y] coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping
Date:   Sat, 22 Jun 2019 18:32:18 +0530
Message-ID: <1561208539-29682-2-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561208539-29682-1-git-send-email-akaher@vmware.com>
References: <1561208539-29682-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: akaher@vmware.com does not
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
index 8d59a59..7ccf722 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1172,6 +1172,8 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 	 * mlx4_ib_vma_close().
 	 */
 	down_write(&owning_mm->mmap_sem);
+	if (!mmget_still_valid(owning_mm))
+		goto skip_mm;
 	for (i = 0; i < HW_BAR_COUNT; i++) {
 		vma = context->hw_bar_info[i].vma;
 		if (!vma)
@@ -1190,7 +1192,7 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 		/* context going to be destroyed, should not access ops any more */
 		context->hw_bar_info[i].vma->vm_ops = NULL;
 	}
-
+skip_mm:
 	up_write(&owning_mm->mmap_sem);
 	mmput(owning_mm);
 	put_task_struct(owning_process);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b1daf5c..f94df0e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1307,6 +1307,8 @@ static void mlx5_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 	 * mlx5_ib_vma_close.
 	 */
 	down_write(&owning_mm->mmap_sem);
+	if (!mmget_still_valid(owning_mm))
+		goto skip_mm;
 	list_for_each_entry_safe(vma_private, n, &context->vma_private_list,
 				 list) {
 		vma = vma_private->vma;
@@ -1321,6 +1323,7 @@ static void mlx5_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 		list_del(&vma_private->list);
 		kfree(vma_private);
 	}
+skip_mm:
 	up_write(&owning_mm->mmap_sem);
 	mmput(owning_mm);
 	put_task_struct(owning_process);
-- 
2.7.4

