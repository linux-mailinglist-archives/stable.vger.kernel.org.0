Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BADE2C9D7E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390740AbgLAJYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:24:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:43184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388593AbgLAJGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:06:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A256A22244;
        Tue,  1 Dec 2020 09:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813538;
        bh=nKu4VDLBDD2CjeBw0ad/pQm8ZFHTCFlZW5bhuK/ie+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMgaKD23NCLRiaeq7u3QOzNEp8qfDmosjzTvLgg/ID06KB2hOV47rzZNvMTF2Sv4m
         F2zBdl2Lnnj6gWCWJHQWrMR2+DULiECwa4djkIutLmFC754w8q2YwGtlRnBNR5x4tT
         KDak92Vjn5eghiHLW5l/diBcUbji0HojSJqUDgC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 74/98] RDMA/hns: Fix retry_cnt and rnr_cnt when querying QP
Date:   Tue,  1 Dec 2020 09:53:51 +0100
Message-Id: <20201201084658.691683546@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit ab6f7248cc446b85fe9e31091670ad7c4293d7fd ]

The maximum number of retransmission should be returned when querying QP,
not the value of retransmission counter.

Fixes: 99fcf82521d9 ("RDMA/hns: Fix the wrong value of rnr_retry when querying qp")
Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Link: https://lore.kernel.org/r/1606382977-21431-1-git-send-email-liweihang@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index bb75328193957..b285920bcd8ab 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4614,11 +4614,11 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 					      V2_QPC_BYTE_28_AT_M,
 					      V2_QPC_BYTE_28_AT_S);
 	qp_attr->retry_cnt = roce_get_field(context.byte_212_lsn,
-					    V2_QPC_BYTE_212_RETRY_CNT_M,
-					    V2_QPC_BYTE_212_RETRY_CNT_S);
+					    V2_QPC_BYTE_212_RETRY_NUM_INIT_M,
+					    V2_QPC_BYTE_212_RETRY_NUM_INIT_S);
 	qp_attr->rnr_retry = roce_get_field(context.byte_244_rnr_rxack,
-					    V2_QPC_BYTE_244_RNR_CNT_M,
-					    V2_QPC_BYTE_244_RNR_CNT_S);
+					    V2_QPC_BYTE_244_RNR_NUM_INIT_M,
+					    V2_QPC_BYTE_244_RNR_NUM_INIT_S);
 
 done:
 	qp_attr->cur_qp_state = qp_attr->qp_state;
-- 
2.27.0



