Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C1F2F076
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfE3EET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:04:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731273AbfE3DRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:51 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 162BB24730;
        Thu, 30 May 2019 03:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186271;
        bh=Ezwo7I/e4xNoxN3x0aAUXhD15xS/XKBoojy9aRG5H1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKhptSmCArvBKDqcTozCtRfOR18Q3ZuPqiaQPOm8whaRqRaOxG1aXvTaOKh9eq0T2
         zIVACv1RC1olYdfAmIJgP36yXjr+CWRAywz2bHCn/xn8j8KDDJ1uZHc63EdIO6oPwB
         7ujFW2qkvv0UYpgwjhkk7u7AOwsd+5CJvuT5vhts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Gal Pressman <galpress@amazon.com>,
        Lijun Ou <ouliun@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 211/276] RDMA/hns: Fix bad endianess of port_pd variable
Date:   Wed, 29 May 2019 20:06:09 -0700
Message-Id: <20190530030538.338691030@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6734b2973565e36659e97e12ab0d0faf1d9f3fbe ]

port_pd is treated as le32 in declaration and read, fix assignment to be
in le32 too. This change fixes the following compilation warnings.

drivers/infiniband/hw/hns/hns_roce_ah.c:67:24: warning: incorrect type
in assignment (different base types)
drivers/infiniband/hw/hns/hns_roce_ah.c:67:24: expected restricted __le32 [usertype] port_pd
drivers/infiniband/hw/hns/hns_roce_ah.c:67:24: got restricted __be32 [usertype]

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Gal Pressman <galpress@amazon.com>
Reviewed-by: Lijun Ou <ouliun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_ah.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index 0d96c5bb38cdf..d2d4ab9ab071c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -66,7 +66,7 @@ struct ib_ah *hns_roce_create_ah(struct ib_pd *ibpd,
 			     HNS_ROCE_VLAN_SL_BIT_MASK) <<
 			     HNS_ROCE_VLAN_SL_SHIFT;
 
-	ah->av.port_pd = cpu_to_be32(to_hr_pd(ibpd)->pdn |
+	ah->av.port_pd = cpu_to_le32(to_hr_pd(ibpd)->pdn |
 				     (rdma_ah_get_port_num(ah_attr) <<
 				     HNS_ROCE_PORT_NUM_SHIFT));
 	ah->av.gid_index = grh->sgid_index;
-- 
2.20.1



