Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9533622EE48
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgG0OGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbgG0OGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:06:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3545120775;
        Mon, 27 Jul 2020 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858793;
        bh=isoaCogdPNR5CXhwqYXPPHVMPf/1j0W8wLT4k2MdSak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6NwQeGjEJH9Rjd9kM2YzlGzjPlL1O2ZzDUD2wnKebbF9raJdZ2nH/wiVUrz5NzuB
         TKWcoiKCGBGcB3aEDziw0exI9INUTyIBOGjZZnFHO+h1gxgnq4M/mX/P3Mfga6P7FD
         6RnYyTc9Z0OGOczJFo+mXUlA+ehmNVNZKs+emT8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 4.14 14/64] IB/umem: fix reference count leak in ib_umem_odp_get()
Date:   Mon, 27 Jul 2020 16:03:53 +0200
Message-Id: <20200727134911.739574662@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134911.020675249@linuxfoundation.org>
References: <20200727134911.020675249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

Add missing mmput() on error path to avoid ref-count leak.

This problem is introduced by 79bb5b7ee177 ("RDMA/umem: Fix missing mmap_sem in get umem ODP call")
and resolved by f27a0d50a4bc ("RDMA/umem: Use umem->owning_mm inside ODP").
So, it's only needed in stable-4.14 and stable-4.19.

Fixes: 79bb5b7ee177 ("RDMA/umem: Fix missing mmap_sem in get umem ODP call")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/umem_odp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -306,7 +306,8 @@ int ib_umem_odp_get(struct ib_ucontext *
 		vma = find_vma(mm, ib_umem_start(umem));
 		if (!vma || !is_vm_hugetlb_page(vma)) {
 			up_read(&mm->mmap_sem);
-			return -EINVAL;
+			ret_val = -EINVAL;
+			goto out_mm;
 		}
 		h = hstate_vma(vma);
 		umem->page_shift = huge_page_shift(h);


