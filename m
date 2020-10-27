Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A6729C1ED
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762198AbgJ0Ol0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761372AbgJ0OjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30E77206B2;
        Tue, 27 Oct 2020 14:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809554;
        bh=WvaZZsQ6AHJAROazEoz53LMspT6PT8dbz8rpt9JsBEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIvIYmCkpJA4ulp2isxrN1c6ucE2YkZGHWY99BMX7mK8K/2g8kiIDuyOdVDmwxd7n
         LLzgwP21T+AJdtJRyDztv9KKjPxX1gWwtFlh/r45e5mPNoil8CWMy6UhF2AcLy9g3F
         s/2LrcBH8259EWkDTYr45FjTRQeIQKi9/VyhOQmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 237/408] RDMA/hns: Fix missing sq_sig_type when querying QP
Date:   Tue, 27 Oct 2020 14:52:55 +0100
Message-Id: <20201027135506.049243924@linuxfoundation.org>
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

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit 05df49279f8926178ecb3ce88e61b63104cd6293 ]

The sq_sig_type field should be filled when querying QP, or the users may
get a wrong value.

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Link: https://lore.kernel.org/r/1600509802-44382-9-git-send-email-liweihang@huawei.com
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index def266626223a..bb75328193957 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4634,6 +4634,7 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	}
 
 	qp_init_attr->cap = qp_attr->cap;
+	qp_init_attr->sq_sig_type = hr_qp->sq_signal_bits;
 
 out:
 	mutex_unlock(&hr_qp->mutex);
-- 
2.25.1



