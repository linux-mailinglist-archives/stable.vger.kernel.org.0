Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329A0246F21
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731566AbgHQRmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:42:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731105AbgHQQQi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:16:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0E7522BF5;
        Mon, 17 Aug 2020 16:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680964;
        bh=QtmWFyitK/PBp4hqQdNA8r0aw4ynC1+Ayo9n4wsETBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKMOWdkANxB47y3C0F2bhnXCOkDqqxezecnJ7pJBwFTjvuZ6lwhWTN63r4Xql50/M
         OYGBdIl4FZ6u4UfKTDxvElkJxAqGHWoGSNrVG6ke5c+bPJV16aoqhL1R7VwoFHz5FL
         gnqxzQchGGCql81xl92VbWsDuhqu9en1/Mdg8HiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Li Heng <liheng40@huawei.com>,
        Parav Pandit <parav@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/168] RDMA/core: Fix return error value in _ib_modify_qp() to negative
Date:   Mon, 17 Aug 2020 17:17:12 +0200
Message-Id: <20200817143738.761003960@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
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
index 82f309fb3ce52..e8432876cc860 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1617,7 +1617,7 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
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



