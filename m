Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A7D2475D2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732064AbgHQT3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729978AbgHQPcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:32:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62C7B20709;
        Mon, 17 Aug 2020 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678341;
        bh=0qMyAw59C0MWjKRZoXdZUm+02FzsbsnESMZtyqFa69k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b08kuQSuQAqlE8MfuhMG3e0Y2pCfEI5Lryr8fg3iyhs3iYBwYVQmLGiuJvYX+Vpp9
         NzeaQNjfvSZ3h5EBZnAoECiinchOctDbRml04eNAzr/5uhBNa4xTuP2HZ7TR81JDmz
         enz54dx/kzS9f0R/MJ0x5F/HN8UWP17qWPW86eyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Li Heng <liheng40@huawei.com>,
        Parav Pandit <parav@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 301/464] RDMA/core: Fix return error value in _ib_modify_qp() to negative
Date:   Mon, 17 Aug 2020 17:14:14 +0200
Message-Id: <20200817143848.227319625@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Heng <liheng40@huawei.com>

[ Upstream commit 47fda651d5af2506deac57d54887cf55ce26e244 ]

The error codes in _ib_modify_qp() are supposed to be negative errno.

Fixes: 7a5c938b9ed0 ("IB/core: Check for rdma_protocol_ib only after validating port_num")
Link: https://lore.kernel.org/r/1595645787-20375-1-git-send-email-liheng40@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Li Heng <liheng40@huawei.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 53d6505c0c7b6..f369f0a19e851 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1712,7 +1712,7 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 		if (!(rdma_protocol_ib(qp->device,
 				       attr->alt_ah_attr.port_num) &&
 		      rdma_protocol_ib(qp->device, port))) {
-			ret = EINVAL;
+			ret = -EINVAL;
 			goto out;
 		}
 	}
-- 
2.25.1



