Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6564321E8AD
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 08:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgGNG4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 02:56:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44482 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726472AbgGNG4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 02:56:04 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 56F551B72338A2EF7613;
        Tue, 14 Jul 2020 14:55:58 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 14 Jul 2020
 14:55:55 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <stable@vger.kernel.org>, <linux-rdma@vger.kernel.org>
CC:     <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <hal.rosenstock@gmail.com>
Subject: [PATCH stable-4.19] IB/umem: fix reference count leak in ib_umem_odp_get()
Date:   Tue, 14 Jul 2020 14:54:56 +0000
Message-ID: <20200714145456.1380987-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add missing mmput() on error path to avoid ref-count leak.

This problem is introduced by 79bb5b7ee177 ("RDMA/umem: Fix missing mmap_sem in get umem ODP call")
and resolved by f27a0d50a4bc ("RDMA/umem: Use umem->owning_mm inside ODP").
So, it's only needed in stable-4.14 and stable-4.19.

Fixes: 79bb5b7ee177 ("RDMA/umem: Fix missing mmap_sem in get umem ODP call")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/infiniband/core/umem_odp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index eeafdc0beec7..08ef654ea9b8 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -347,7 +347,8 @@ int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem,
 		vma = find_vma(mm, ib_umem_start(umem));
 		if (!vma || !is_vm_hugetlb_page(vma)) {
 			up_read(&mm->mmap_sem);
-			return -EINVAL;
+			ret_val = -EINVAL;
+			goto out_mm;
 		}
 		h = hstate_vma(vma);
 		umem->page_shift = huge_page_shift(h);
-- 
2.25.1

