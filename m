Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E46440E248
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243541AbhIPQgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243153AbhIPQeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0171B6187F;
        Thu, 16 Sep 2021 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809249;
        bh=SvThv6Ic1kBDhHSW5deA6QNCHFG6QM5UYjmEz9UfrY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4hpkMjGfjfxigseLCER1FH8N2jPD6QsTW7gqjo6Fbq6VMTyMa5bGA2Ezr58cfHSx
         RX+mJWPe3PpLZMU231CXJx+CtdneCdKzyF7a6EpowJgsR2QbRS7W2/hZAcfFCM7Ce6
         AddsVV+xegfCdAQXXSwOxORpnae2nwaMVMcqStdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 086/380] RDMA/hns: Dont overwrite supplied QP attributes
Date:   Thu, 16 Sep 2021 17:57:23 +0200
Message-Id: <20210916155806.974254908@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
index 230a909ba9bc..80661d368860 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1158,14 +1158,8 @@ struct ib_qp *hns_roce_create_qp(struct ib_pd *pd,
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



