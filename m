Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683E82EB5A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfE3DME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728807AbfE3DME (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:04 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A229F24519;
        Thu, 30 May 2019 03:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185922;
        bh=SUFJuD+RDYPxBfqqjk3NPnFPFwKFjx2pBoPwu0iY4Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sR+5ylZeZmDO2LZtdqnlTlsPPDUOaBXc5AxGHKO5emnY8PT3JzTc9IcTRZ0YNG+tv
         Q4TOeTJgz28Kjzmc5y0PRddigmXGnARHv0Y9EOtUPwC6gq/iC0s+xOgnxWK7Bim0Md
         vVkXQcNPEQ2emeFEPt4EQkZ18zTUXOEqLmfkbtOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Zhu Yanjun <yanjun.zhu@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 311/405] RDMA/rxe: Fix slab-out-bounds access which lead to kernel crash later
Date:   Wed, 29 May 2019 20:05:09 -0700
Message-Id: <20190530030556.534697522@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a4b7013db23e93824ac53083eeb3e4efdef4b5b0 ]

BUG: KASAN: slab-out-of-bounds in rxe_mem_init_user+0x6c1/0x740 [rdma_rxe]
Read of size 8 at addr ffff88805c01a608 by task ib_send_bw/573

CPU: 24 PID: 573 Comm: ib_send_bw Not tainted 5.0.0-rc5+ #189
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
Call Trace:
 rxe_mem_init_user+0x6c1/0x740 [rdma_rxe]
 rxe_reg_user_mr+0x9b/0x110 [rdma_rxe]
 ib_uverbs_reg_mr+0x428/0x9c0 [ib_uverbs]
 ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x2b0/0x410 [ib_uverbs]
 ib_uverbs_run_method+0x79c/0x1da0 [ib_uverbs]
 rxe_mem_init_user+0x6c1/0x740 [rdma_rxe]
 rxe_reg_user_mr+0x9b/0x110 [rdma_rxe]
 ib_uverbs_reg_mr+0x428/0x9c0 [ib_uverbs]
 ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x2b0/0x410 [ib_uverbs]
 ib_uverbs_run_method+0x79c/0x1da0 [ib_uverbs]
 ib_uverbs_cmd_verbs+0x5f2/0xf20 [ib_uverbs]
 ib_uverbs_ioctl+0x202/0x310 [ib_uverbs]
 do_vfs_ioctl+0x193/0x1440
 ksys_ioctl+0x3a/0x70
 __x64_sys_ioctl+0x6f/0xb0
 do_syscall_64+0x13f/0x570
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Allocated by task 573:
 __kasan_kmalloc.constprop.5+0xc1/0xd0
 __kmalloc+0x161/0x310
 rxe_mem_alloc+0x52/0x470 [rdma_rxe]
 rxe_mem_init_user+0x113/0x740 [rdma_rxe]
 rxe_reg_user_mr+0x9b/0x110 [rdma_rxe]
 ib_uverbs_reg_mr+0x428/0x9c0 [ib_uverbs]
 ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x2b0/0x410 [ib_uverbs]
 ib_uverbs_run_method+0x79c/0x1da0 [ib_uverbs]
 ib_uverbs_cmd_verbs+0x5f2/0xf20 [ib_uverbs]
 ib_uverbs_ioctl+0x202/0x310 [ib_uverbs]
 do_vfs_ioctl+0x193/0x1440
 ksys_ioctl+0x3a/0x70
 __x64_sys_ioctl+0x6f/0xb0
 do_syscall_64+0x13f/0x570
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 0:
 __kasan_slab_free+0x12e/0x180
 kfree+0x10a/0x2c0
 rcu_process_callbacks+0xa77/0x1260
 __do_softirq+0x2ad/0xacb

Test scenario:
 ib_send_bw -x 1 -d rxe0 -a &
 ib_send_bw -x 1 -d rxe0 -a localhost

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Reported-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 42f0f25e396c3..ec89fbd06c53c 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -199,6 +199,12 @@ int rxe_mem_init_user(struct rxe_pd *pd, u64 start,
 		buf = map[0]->buf;
 
 		for_each_sg_page(umem->sg_head.sgl, &sg_iter, umem->nmap, 0) {
+			if (num_buf >= RXE_BUF_PER_MAP) {
+				map++;
+				buf = map[0]->buf;
+				num_buf = 0;
+			}
+
 			vaddr = page_address(sg_page_iter_page(&sg_iter));
 			if (!vaddr) {
 				pr_warn("null vaddr\n");
@@ -211,11 +217,6 @@ int rxe_mem_init_user(struct rxe_pd *pd, u64 start,
 			num_buf++;
 			buf++;
 
-			if (num_buf >= RXE_BUF_PER_MAP) {
-				map++;
-				buf = map[0]->buf;
-				num_buf = 0;
-			}
 		}
 	}
 
-- 
2.20.1



