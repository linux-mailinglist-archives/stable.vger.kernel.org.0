Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7E329B239
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761373AbgJ0OjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761371AbgJ0OjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49A16207BB;
        Tue, 27 Oct 2020 14:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809551;
        bh=TD40MBMZ2sX+lcUHuoTWd/myMM6oP2GIizb978InVx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2CRSiY1+7CgxgPhPcw/zEgGIJ2kaXvDC6XWQPp6I7L/XaALCB4LX6/IjdtWz+/sE
         ymkLhqM3w7lgAXdpIoKFWhrTg8NrYbHvba95dVdYnc6L/7xfsZqKtIBoK0QebkQzEm
         NdQRpekMfRQAun5KdlHmDsmRfZwFYDpTi8WpXCoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 236/408] RDMA/hns: Fix the wrong value of rnr_retry when querying qp
Date:   Tue, 27 Oct 2020 14:52:54 +0100
Message-Id: <20201027135506.001607909@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit 99fcf82521d91468ee6115a3c253aa032dc63cbc ]

The rnr_retry returned to the user is not correct, it should be got from
another fields in QPC.

Fixes: bfe860351e31 ("RDMA/hns: Fix cast from or to restricted __le32 for driver")
Link: https://lore.kernel.org/r/1600509802-44382-7-git-send-email-liweihang@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 0502c90c83edd..def266626223a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4616,7 +4616,9 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	qp_attr->retry_cnt = roce_get_field(context.byte_212_lsn,
 					    V2_QPC_BYTE_212_RETRY_CNT_M,
 					    V2_QPC_BYTE_212_RETRY_CNT_S);
-	qp_attr->rnr_retry = le32_to_cpu(context.rq_rnr_timer);
+	qp_attr->rnr_retry = roce_get_field(context.byte_244_rnr_rxack,
+					    V2_QPC_BYTE_244_RNR_CNT_M,
+					    V2_QPC_BYTE_244_RNR_CNT_S);
 
 done:
 	qp_attr->cur_qp_state = qp_attr->qp_state;
-- 
2.25.1



