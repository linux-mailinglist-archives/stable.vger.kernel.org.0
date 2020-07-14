Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5139C21E600
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 04:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgGNC65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 22:58:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7847 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726432AbgGNC65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 22:58:57 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0CBDBAB945C16D3C876B;
        Tue, 14 Jul 2020 10:58:51 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Tue, 14 Jul 2020
 10:58:50 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
        <dledford@redhat.com>, <jgg@ziepe.ca>
Subject: [PATCH 4.19] IB/umem: fix reference count leak in ib_umem_odp_get()
Date:   Tue, 14 Jul 2020 10:57:48 +0000
Message-ID: <20200714105748.1151138-1-yangyingliang@huawei.com>
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

This problem has already been resolved in mainline by
f27a0d50a4bc ("RDMA/umem: Use umem->owning_mm inside ODP").

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

