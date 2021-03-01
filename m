Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B236328E15
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbhCATXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:23:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235739AbhCATSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:18:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C79B64F0B;
        Mon,  1 Mar 2021 17:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620963;
        bh=Uu+wM+IxSlmm5kvzOMfD+rK5HK1u72PRHotX9AJEzvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+bCFMgANPOkuLU3cNcMyFEAEJZJd3yZCOg0utManbHllO8dmu3yyVzoEHyb1SwTT
         XP+X7YBWfUVrvtzlNPDdIWPfanIZw3cA/Yx+1fb2DYbvKe9XTy2EQsnEyEmUNyqA4b
         cOj8q2QlpJffhtQD+KfMxOfy9wICToWz7rKoyqB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 344/775] RDMA/rtrs-srv: Fix missing wr_cqe
Date:   Mon,  1 Mar 2021 17:08:32 +0100
Message-Id: <20210301161218.621690507@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit 8537f2de6519945890a2b0f3739b23f32b5c0a89 ]

We had a few places wr_cqe is not set, which could lead to NULL pointer
deref or GPF in error case.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20201217141915.56989-14-jinpu.wang@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 92a216ddd9fd3..f59731c5a96a3 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -267,6 +267,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		WARN_ON_ONCE(rkey != wr->rkey);
 
 	wr->wr.opcode = IB_WR_RDMA_WRITE;
+	wr->wr.wr_cqe   = &io_comp_cqe;
 	wr->wr.ex.imm_data = 0;
 	wr->wr.send_flags  = 0;
 
@@ -294,6 +295,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		inv_wr.sg_list = NULL;
 		inv_wr.num_sge = 0;
 		inv_wr.opcode = IB_WR_SEND_WITH_INV;
+		inv_wr.wr_cqe   = &io_comp_cqe;
 		inv_wr.send_flags = 0;
 		inv_wr.ex.invalidate_rkey = rkey;
 	}
@@ -304,6 +306,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 
 		srv_mr = &sess->mrs[id->msg_id];
 		rwr.wr.opcode = IB_WR_REG_MR;
+		rwr.wr.wr_cqe = &local_reg_cqe;
 		rwr.wr.num_sge = 0;
 		rwr.mr = srv_mr->mr;
 		rwr.wr.send_flags = 0;
@@ -379,6 +382,7 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 
 		if (need_inval) {
 			if (likely(sg_cnt)) {
+				inv_wr.wr_cqe   = &io_comp_cqe;
 				inv_wr.sg_list = NULL;
 				inv_wr.num_sge = 0;
 				inv_wr.opcode = IB_WR_SEND_WITH_INV;
@@ -421,6 +425,7 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 		srv_mr = &sess->mrs[id->msg_id];
 		rwr.wr.next = &imm_wr;
 		rwr.wr.opcode = IB_WR_REG_MR;
+		rwr.wr.wr_cqe = &local_reg_cqe;
 		rwr.wr.num_sge = 0;
 		rwr.wr.send_flags = 0;
 		rwr.mr = srv_mr->mr;
-- 
2.27.0



