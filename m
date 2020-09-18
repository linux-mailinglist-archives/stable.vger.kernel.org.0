Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C4826F0E6
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbgIRCrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728340AbgIRCJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:09:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F0F62389E;
        Fri, 18 Sep 2020 02:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394982;
        bh=kUoIlouW6SKw2gS7BsXFjVlYtxVNukMaJzqaczJ7lRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqSKI6ErovhMaJdniGbgMsUQLsGVKzjARw/bLy6uHJY8m15GAr65s7TMRMWsqReWo
         VleL4xp+M7r59hE60X1vR8ZRsGhJ20rHxNEtCHISCQDvKN+mt34iIehZc80RGyOh3k
         2rzpZE/ExYB7xNSCXVQxjHlOgaxCnRvntZF21EZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 082/206] RDMA/rxe: Fix configuration of atomic queue pair attributes
Date:   Thu, 17 Sep 2020 22:05:58 -0400
Message-Id: <20200918020802.2065198-82-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit fb3063d31995cc4cf1d47a406bb61d6fb1b1d58d ]

From the comment above the definition of the roundup_pow_of_two() macro:

     The result is undefined when n == 0.

Hence only pass positive values to roundup_pow_of_two(). This patch fixes
the following UBSAN complaint:

  UBSAN: Undefined behaviour in ./include/linux/log2.h:57:13
  shift exponent 64 is too large for 64-bit type 'long unsigned int'
  Call Trace:
   dump_stack+0xa5/0xe6
   ubsan_epilogue+0x9/0x26
   __ubsan_handle_shift_out_of_bounds.cold+0x4c/0xf9
   rxe_qp_from_attr.cold+0x37/0x5d [rdma_rxe]
   rxe_modify_qp+0x59/0x70 [rdma_rxe]
   _ib_modify_qp+0x5aa/0x7c0 [ib_core]
   ib_modify_qp+0x3b/0x50 [ib_core]
   cma_modify_qp_rtr+0x234/0x260 [rdma_cm]
   __rdma_accept+0x1a7/0x650 [rdma_cm]
   nvmet_rdma_cm_handler+0x1286/0x14cd [nvmet_rdma]
   cma_cm_event_handler+0x6b/0x330 [rdma_cm]
   cma_ib_req_handler+0xe60/0x22d0 [rdma_cm]
   cm_process_work+0x30/0x140 [ib_cm]
   cm_req_handler+0x11f4/0x1cd0 [ib_cm]
   cm_work_handler+0xb8/0x344e [ib_cm]
   process_one_work+0x569/0xb60
   worker_thread+0x7a/0x5d0
   kthread+0x1e6/0x210
   ret_from_fork+0x24/0x30

Link: https://lore.kernel.org/r/20200217205714.26937-1-bvanassche@acm.org
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 230697fa31fe3..8a22ab8b29e9b 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -583,15 +583,16 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 	int err;
 
 	if (mask & IB_QP_MAX_QP_RD_ATOMIC) {
-		int max_rd_atomic = __roundup_pow_of_two(attr->max_rd_atomic);
+		int max_rd_atomic = attr->max_rd_atomic ?
+			roundup_pow_of_two(attr->max_rd_atomic) : 0;
 
 		qp->attr.max_rd_atomic = max_rd_atomic;
 		atomic_set(&qp->req.rd_atomic, max_rd_atomic);
 	}
 
 	if (mask & IB_QP_MAX_DEST_RD_ATOMIC) {
-		int max_dest_rd_atomic =
-			__roundup_pow_of_two(attr->max_dest_rd_atomic);
+		int max_dest_rd_atomic = attr->max_dest_rd_atomic ?
+			roundup_pow_of_two(attr->max_dest_rd_atomic) : 0;
 
 		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
 
-- 
2.25.1

