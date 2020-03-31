Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53472199207
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbgCaJFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731075AbgCaJFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:05:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E11E420675;
        Tue, 31 Mar 2020 09:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645552;
        bh=bSQM1Dtvif4FaNcL9hMzSAR+D8lrIbIInjKk3q1hPjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvPb5AEmD/DqgaiKAzeiA61knVoVDmZKStxmVzkY8JMA9K8Pmq28xyQBfgknqOYxk
         NuVgpdlTIVi5/xZ9pkak5LDOo87TnbCXsZwBhFQNxGSKpCj9QOSDeoEmyNwNNkrAI3
         ESMnt3YKlW37+Nmub1Lqa8T1/SfeiOQi6HOK9rWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 088/170] RDMA/odp: Fix leaking the tgid for implicit ODP
Date:   Tue, 31 Mar 2020 10:58:22 +0200
Message-Id: <20200331085433.639637797@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 0f9826f4753f74f935e18c2a640484ecbd941346 upstream.

The tgid used to be part of ib_umem_free_notifier(), when it was reworked
it got moved to release, but it should have been unconditional as all umem
alloc paths get the tgid.

As is, creating an implicit ODP will leak the tgid reference.

Link: https://lore.kernel.org/r/20200304181607.GA22412@ziepe.ca
Cc: stable@kernel.org
Fixes: f25a546e6529 ("RDMA/odp: Use mmu_interval_notifier_insert()")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/umem_odp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -290,8 +290,8 @@ void ib_umem_odp_release(struct ib_umem_
 		mmu_interval_notifier_remove(&umem_odp->notifier);
 		kvfree(umem_odp->dma_list);
 		kvfree(umem_odp->page_list);
-		put_pid(umem_odp->tgid);
 	}
+	put_pid(umem_odp->tgid);
 	kfree(umem_odp);
 }
 EXPORT_SYMBOL(ib_umem_odp_release);


