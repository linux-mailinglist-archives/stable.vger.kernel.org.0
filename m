Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF4429B4F5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793617AbgJ0PH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789824AbgJ0PDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:03:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C73206E5;
        Tue, 27 Oct 2020 15:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810984;
        bh=9eyIh/eEivJFYg7sKk/aeU7uy2yB9dzcxGoK1RgxLgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUPGkdOl6NZy7ZqScSfxN95/5qgQ5L/btGeFUMqnW3SKFzhSDGcGiC+yyYlSKXwAh
         EsEC+hsdIv6Qr0PpPvZoiJoddBZb8Yh6F5OndgdN0DIoJ1bINozED7drgyzEeaFHqU
         OhfyJd4DkZtb0/jwJjSR7HoQ9TmaFXmwHA2m3IHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Cheng <chenglang@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 332/633] RDMA/hns: Add a check for current state before modifying QP
Date:   Tue, 27 Oct 2020 14:51:15 +0100
Message-Id: <20201027135538.257132440@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

[ Upstream commit e0ef0f68c4c0d85b1eb63f38d5d10324361280e8 ]

It should be considered an illegal operation if the ULP attempts to modify
a QP from another state to the current hardware state. Otherwise, the ULP
can modify some fields of QPC at any time. For example, for a QP in state
of RTS, modify it from RTR to RTS can change the PSN, which is always not
as expected.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Link: https://lore.kernel.org/r/1598353674-24270-1-git-send-email-liweihang@huawei.com
Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 4edea397b6b80..4486c9b7c3e43 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1171,8 +1171,10 @@ int hns_roce_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	mutex_lock(&hr_qp->mutex);
 
-	cur_state = attr_mask & IB_QP_CUR_STATE ?
-		    attr->cur_qp_state : (enum ib_qp_state)hr_qp->state;
+	if (attr_mask & IB_QP_CUR_STATE && attr->cur_qp_state != hr_qp->state)
+		goto out;
+
+	cur_state = hr_qp->state;
 	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
 
 	if (ibqp->uobject &&
-- 
2.25.1



