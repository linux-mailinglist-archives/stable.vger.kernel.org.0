Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9BF3C4E73
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244853AbhGLHS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:18:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239386AbhGLHRu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2A7361156;
        Mon, 12 Jul 2021 07:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074101;
        bh=XwsTXt2EKIcX4RE4Z9Yi9LRARpQSUlNJDsnQBz60YlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvablzT/vAq65ib4zYRepFYWaY0yOhgArQnDQcA8LhpXAHLH3HUkvdNz+mPQcuW4L
         Eu6LE6tF2MbANzcKE/rtWQlHko/lwWLTygoH4O4ef10wQu8tyPW2mu2sNyxnGmO+av
         KrmvJR5NdWXhe1BksOdgMvG+N+QwaU3TUhKDx6FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Cheng <chenglang@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 465/700] RDMA/hns: Force rewrite inline flag of WQE
Date:   Mon, 12 Jul 2021 08:09:08 +0200
Message-Id: <20210712061026.066974255@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

[ Upstream commit e13026578b727becf2614f34a4f35e7f0ed21be1 ]

When a non-inline WR reuses a WQE that was used for inline last time, the
remaining inline flag should be cleared.

Fixes: 62490fd5a865 ("RDMA/hns: Avoid unnecessary memset on WQEs in post_send")
Link: https://lore.kernel.org/r/1624011020-16992-2-git-send-email-liweihang@huawei.com
Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 3344b80ecf04..851acc9d050f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -268,8 +268,6 @@ static int set_rc_inl(struct hns_roce_qp *qp, const struct ib_send_wr *wr,
 
 	dseg += sizeof(struct hns_roce_v2_rc_send_wqe);
 
-	roce_set_bit(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_INLINE_S, 1);
-
 	if (msg_len <= HNS_ROCE_V2_MAX_RC_INL_INN_SZ) {
 		roce_set_bit(rc_sq_wqe->byte_20,
 			     V2_RC_SEND_WQE_BYTE_20_INL_TYPE_S, 0);
@@ -314,6 +312,8 @@ static int set_rwqe_data_seg(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 		       V2_RC_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_S,
 		       (*sge_ind) & (qp->sge.sge_cnt - 1));
 
+	roce_set_bit(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_INLINE_S,
+		     !!(wr->send_flags & IB_SEND_INLINE));
 	if (wr->send_flags & IB_SEND_INLINE)
 		return set_rc_inl(qp, wr, rc_sq_wqe, sge_ind);
 
-- 
2.30.2



