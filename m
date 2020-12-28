Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B70E2E3B0D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404790AbgL1NpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:45:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404810AbgL1NpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:45:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 710B32063A;
        Mon, 28 Dec 2020 13:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163072;
        bh=9CtOtGjV/IPQVT9keuS0uQL9Gcj+GKnOiX7JyVT3gcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wbt+1lPO1vDTGhQ7HXE1xnXDl9wcnDUN9eV+EcMWaWIsBrGmzWzHXr59hb17ao3YN
         R2TrmQD40+yOVvol8UqS4boJal5XEhwJvTheDzc1OZHEMYu1ZHuiFBe5Si+2fgEcBn
         ZDQHvfwzU286y1lDSNLp6gbm+VmCPzcus/ervNaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/453] RDMA/cxgb4: Validate the number of CQEs
Date:   Mon, 28 Dec 2020 13:46:35 +0100
Message-Id: <20201228124944.859359180@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 6d8285e604e0221b67bd5db736921b7ddce37d00 ]

Before create CQ, make sure that the requested number of CQEs is in the
supported range.

Fixes: cfdda9d76436 ("RDMA/cxgb4: Add driver for Chelsio T4 RNIC")
Link: https://lore.kernel.org/r/20201108132007.67537-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index b1bb61c65f4f6..16b74591a68db 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -1007,6 +1007,9 @@ int c4iw_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	if (attr->flags)
 		return -EINVAL;
 
+	if (entries < 1 || entries > ibdev->attrs.max_cqe)
+		return -EINVAL;
+
 	if (vector >= rhp->rdev.lldi.nciq)
 		return -EINVAL;
 
-- 
2.27.0



