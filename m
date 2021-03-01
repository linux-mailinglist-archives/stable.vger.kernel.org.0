Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E9F32905F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbhCAUHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242625AbhCATyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0D7965371;
        Mon,  1 Mar 2021 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621294;
        bh=6gfXndnWt0cn4uwYu5UU1SMcPlnMrcM578dY4LtYkPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1p22zctONEk/B2oIW6Cqyb3xXOguNXvKVh6qTna43uax1J4Osnzf7PoUNtWH2rBuk
         HOzgIVOBOZ660b7Xm/tFdZ0WqHePGET2P/TtW2M7M7eEvN0xpoPiG3X4jMpHamhzcS
         RpN8LDLiGJ3aoDzm/O0b7lb5aYH48chmb6H36BZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 433/775] RDMA/hns: Force srq_limit to 0 when creating SRQ
Date:   Mon,  1 Mar 2021 17:10:01 +0100
Message-Id: <20210301161222.967008235@linuxfoundation.org>
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

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit b5df9b7a2f965b7903850d8f89846ffe0080b84b ]

According to the IB Specification, srq_limit shouldn't be configured
during SRQ creation. If a user set srq_limit at this time, the driver
should forced it to zero, or the result of creating SRQ will conflict with
the result of querying SRQ.

Fixes: c7bcb13442e1 ("RDMA/hns: Add SRQ support for hip08 kernel mode")
Link: https://lore.kernel.org/r/1611997090-48820-4-git-send-email-liweihang@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_srq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 9f60a0a745e11..ecc42c59e3cfc 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -338,6 +338,7 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 		roundup_pow_of_two(init_attr->attr.max_sge + srq->rsv_sge);
 	init_attr->attr.max_wr = srq->wqe_cnt;
 	init_attr->attr.max_sge = srq->max_gs;
+	init_attr->attr.srq_limit = 0;
 
 	if (udata) {
 		ret = ib_copy_from_udata(&ucmd, udata,
-- 
2.27.0



