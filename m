Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E9C29B0C4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901425AbgJ0OXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758745AbgJ0OXV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:23:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC6512072D;
        Tue, 27 Oct 2020 14:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808600;
        bh=QAW/jlNSRCVvcA1WLXud2dlUkPshFx36zNfbC/i2nLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h172PI0H2+G8W6VwMOeXeH9a3UFWiq33mn3mmFYB5r+fuSUpZg5fz2rnIDcgrn/JS
         QIWCaUH60OsgoOwYoWCxFM2qYU+hBrD+YKP3T9rA6lINCOtFmxBhKMqNVp987cWc8s
         0YFhw7OtkV4opWVkL378J/nbFq6ZvX/xk4b1Bb/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 154/264] RDMA/hns: Fix missing sq_sig_type when querying QP
Date:   Tue, 27 Oct 2020 14:53:32 +0100
Message-Id: <20201027135437.910438843@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index 417de7ac0d5e2..2a203e08d4c1a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3821,6 +3821,7 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	}
 
 	qp_init_attr->cap = qp_attr->cap;
+	qp_init_attr->sq_sig_type = hr_qp->sq_signal_bits;
 
 out:
 	mutex_unlock(&hr_qp->mutex);
-- 
2.25.1



