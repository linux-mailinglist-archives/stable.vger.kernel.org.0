Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133C017FA6E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgCJNEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729481AbgCJNE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:04:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32AE320409;
        Tue, 10 Mar 2020 13:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845467;
        bh=ZqlUwVB66ydp/iIJwLEGmXhZSRl3CEmNjcB+VKOctZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NgqBMAkH7EaBKY1zU+gmUECYatcIgFz+IhBK6pX9d6HbJUVvi/s/sQbUNjvwT01mm
         nzj9hrqjMGn3yShMZZ2vQ+cHGgPNuzoI/mSrUqEo53hmSoP6n+RGvFpalCExW6rmVJ
         inrPQccTczGlmznADOLkcrqa3HnTetwOp52f4TGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 161/189] RDMA/odp: Ensure the mm is still alive before creating an implicit child
Date:   Tue, 10 Mar 2020 13:39:58 +0100
Message-Id: <20200310123656.312772237@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit a4e63bce1414df7ab6eb82ca9feb8494ce13e554 upstream.

Registration of a mmu_notifier requires the caller to hold a mmget() on
the mm as registration is not permitted to race with exit_mmap(). There is
a BUG_ON inside the mmu_notifier to guard against this.

Normally creating a umem is done against current which implicitly holds
the mmget(), however an implicit ODP child is created from a pagefault
work queue and is not guaranteed to have a mmget().

Call mmget() around this registration and abort faulting if the MM has
gone to exit_mmap().

Before the patch below the notifier was registered when the implicit ODP
parent was created, so there was no chance to register a notifier outside
of current.

Fixes: c571feca2dc9 ("RDMA/odp: use mmu_notifier_get/put for 'struct ib_ucontext_per_mm'")
Link: https://lore.kernel.org/r/20200227114118.94736-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/umem_odp.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -187,14 +187,28 @@ ib_umem_odp_alloc_child(struct ib_umem_o
 	odp_data->page_shift = PAGE_SHIFT;
 	odp_data->notifier.ops = ops;
 
+	/*
+	 * A mmget must be held when registering a notifier, the owming_mm only
+	 * has a mm_grab at this point.
+	 */
+	if (!mmget_not_zero(umem->owning_mm)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+
 	odp_data->tgid = get_pid(root->tgid);
 	ret = ib_init_umem_odp(odp_data, ops);
-	if (ret) {
-		put_pid(odp_data->tgid);
-		kfree(odp_data);
-		return ERR_PTR(ret);
-	}
+	if (ret)
+		goto out_tgid;
+	mmput(umem->owning_mm);
 	return odp_data;
+
+out_tgid:
+	put_pid(odp_data->tgid);
+	mmput(umem->owning_mm);
+out_free:
+	kfree(odp_data);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(ib_umem_odp_alloc_child);
 


