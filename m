Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29AE51A5702
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgDKXNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730568AbgDKXNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B00F120708;
        Sat, 11 Apr 2020 23:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646827;
        bh=S4dRrix0tHD6i0sJuJcIgM8Xsh/eapY+NTsNndzKHII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAP9vVZup5r3rjue1UV+Fmv9tF48rDJvvSa3axU6H3tSUmdE6rY9H/CAvEtRuLNQy
         MQ3pYmHXh13DQSGIvt4oIZSdLF33YdPPvnsac2OBkOjf+DPpYdU4FLfwa8KzDQ0gSq
         OkZI2oC4m13mmzMAMd6T4T1QQAHNYK2FL2Pfao7E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/37] RDMA/rxe: Fix configuration of atomic queue pair attributes
Date:   Sat, 11 Apr 2020 19:13:06 -0400
Message-Id: <20200411231327.26550-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231327.26550-1-sashal@kernel.org>
References: <20200411231327.26550-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index 25055a68a2c07..ef7fd5dfad468 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -593,15 +593,16 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 	struct ib_gid_attr sgid_attr;
 
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
2.20.1

