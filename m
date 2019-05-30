Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36ABA2EEDF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbfE3DTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732024AbfE3DTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:48 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CD9F24849;
        Thu, 30 May 2019 03:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186387;
        bh=R3+18SrnbkXmtV7km6lH+5wCO1acv+pLtnh84LYcPA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKgQ6ODtHVRaO1TRqBxyXo2Q2lMZvD1M139inhY0nr7sLkMcduLrIe+u+lRlF1gAc
         i/EHZlfLEboq3AT2LYglHMBlNpQCKRqau4xMKkn+ZIkarxQRwEdcWGNXhw3/3NHCyZ
         1l5M4ZJoVn4NiY0dQJFe/Hz0byLuMYKV6fmGgCGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Gal Pressman <galpress@amazon.com>,
        Lijun Ou <ouliun@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 156/193] RDMA/hns: Fix bad endianess of port_pd variable
Date:   Wed, 29 May 2019 20:06:50 -0700
Message-Id: <20190530030509.899180539@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
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
index d545302b8ef8c..0cdd4492811bb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -91,7 +91,7 @@ struct ib_ah *hns_roce_create_ah(struct ib_pd *ibpd,
 			     HNS_ROCE_VLAN_SL_BIT_MASK) <<
 			     HNS_ROCE_VLAN_SL_SHIFT;
 
-	ah->av.port_pd = cpu_to_be32(to_hr_pd(ibpd)->pdn |
+	ah->av.port_pd = cpu_to_le32(to_hr_pd(ibpd)->pdn |
 				     (rdma_ah_get_port_num(ah_attr) <<
 				     HNS_ROCE_PORT_NUM_SHIFT));
 	ah->av.gid_index = grh->sgid_index;
-- 
2.20.1



