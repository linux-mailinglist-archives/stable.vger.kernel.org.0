Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6039840E61D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346386AbhIPRSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243966AbhIPRP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:15:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FC9361BA6;
        Thu, 16 Sep 2021 16:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810403;
        bh=DerjmtjVPV3EHwZB5MvO89BhWKQ7W0uW/gnQ1822Ago=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJKLaMi1it00GJ0PVJ8MJ4o6ty5STPwmOOJUSCJ6J6CgbxR1zU4lCoJkLCNDd8BhQ
         RQ8VBuhxlZfyabJ+lcPNfmjkXjnEZNzr+tTCqzPE9BwiEpic+wMU6v3NMHq/q/QPc+
         XcUGb/skqLMhbEyaA5GQHj2NsLk8NIbt21uZvKas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 096/432] RDMA/hns: Dont overwrite supplied QP attributes
Date:   Thu, 16 Sep 2021 17:57:25 +0200
Message-Id: <20210916155814.031972734@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e66e49592b690d6abd537cc207b07a3db2f413d0 ]

QP attributes that were supplied by IB/core already have all parameters
set when they are passed to the driver. The drivers are not supposed to
change anything in struct ib_qp_init_attr.

Fixes: 66d86e529dd5 ("RDMA/hns: Add UD support for HIP09")
Link: https://lore.kernel.org/r/5987138875e8ade9aa339d4db6e1bd9694ed4591.1627040189.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index b101b7e578f2..c3e2fee16c0e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1171,14 +1171,8 @@ struct ib_qp *hns_roce_create_qp(struct ib_pd *pd,
 	if (!hr_qp)
 		return ERR_PTR(-ENOMEM);
 
-	if (init_attr->qp_type == IB_QPT_XRC_INI)
-		init_attr->recv_cq = NULL;
-
-	if (init_attr->qp_type == IB_QPT_XRC_TGT) {
+	if (init_attr->qp_type == IB_QPT_XRC_TGT)
 		hr_qp->xrcdn = to_hr_xrcd(init_attr->xrcd)->xrcdn;
-		init_attr->recv_cq = NULL;
-		init_attr->send_cq = NULL;
-	}
 
 	if (init_attr->qp_type == IB_QPT_GSI) {
 		hr_qp->port = init_attr->port_num - 1;
-- 
2.30.2



