Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01CAC1576A9
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgBJMyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:54:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730132AbgBJMmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:03 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCE3021569;
        Mon, 10 Feb 2020 12:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338521;
        bh=Yen33XZj5jzRF7T5ghNTODxCPnPv6ubE0UKa8No/Edc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DP8H5OmEDgnBYs3LaIMZwWLhBZcMTfCwuKcgTD/ilOjP5ajVadlsnctUBK0MPr2wN
         SAq0amdR1HQXgfIdnMs7AMXChp9KUlNJ6bJYy8HNBNzqRt2YJ/16BdVekM6gfMwJPc
         rSAYNSeMuw007b3dehxm6F/L779+x8goqTeBCjwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 296/367] IB/core: Fix ODP with IB_ACCESS_HUGETLB handling
Date:   Mon, 10 Feb 2020 04:33:29 -0800
Message-Id: <20200210122451.006693701@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

commit 9ff1b6466a291a33389c4a9c7f3f9b64d62df40a upstream.

As VMAs for a given range might not be available as part of the
registration phase in ODP.

ib_init_umem_odp() considered the expected page shift value that was
previously set and initializes its internals accordingly.

If memory isn't backed by physical contiguous pages aligned to a hugepage
boundary an error will be set as part of the page fault flow and come back
to the user as some failed RDMA operation.

Fixes: 0008b84ea9af ("IB/umem: Add support to huge ODP")
Link: https://lore.kernel.org/r/20191222124649.52300-4-leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/umem_odp.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -241,22 +241,10 @@ struct ib_umem_odp *ib_umem_odp_get(stru
 	umem_odp->umem.owning_mm = mm = current->mm;
 	umem_odp->notifier.ops = ops;
 
-	umem_odp->page_shift = PAGE_SHIFT;
-	if (access & IB_ACCESS_HUGETLB) {
-		struct vm_area_struct *vma;
-		struct hstate *h;
-
-		down_read(&mm->mmap_sem);
-		vma = find_vma(mm, ib_umem_start(umem_odp));
-		if (!vma || !is_vm_hugetlb_page(vma)) {
-			up_read(&mm->mmap_sem);
-			ret = -EINVAL;
-			goto err_free;
-		}
-		h = hstate_vma(vma);
-		umem_odp->page_shift = huge_page_shift(h);
-		up_read(&mm->mmap_sem);
-	}
+	if (access & IB_ACCESS_HUGETLB)
+		umem_odp->page_shift = HPAGE_SHIFT;
+	else
+		umem_odp->page_shift = PAGE_SHIFT;
 
 	umem_odp->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
 	ret = ib_init_umem_odp(umem_odp, ops);
@@ -266,7 +254,6 @@ struct ib_umem_odp *ib_umem_odp_get(stru
 
 err_put_pid:
 	put_pid(umem_odp->tgid);
-err_free:
 	kfree(umem_odp);
 	return ERR_PTR(ret);
 }


