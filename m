Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D3929B215
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761034AbgJ0Ohn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:37:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761006AbgJ0Ohm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:37:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA19E20759;
        Tue, 27 Oct 2020 14:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809462;
        bh=ztkl12GQR6cNGhXqfbGMj2z38KOAVYMM4dj/6xgAZKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gu8uyq721T28pJpxv974TOaFpcia73svS0EN1ELjVpYHw6JRLm5+qv4UBfuOB6Top
         4iUup/yK5wKH9lMxdPJDX82oi7Ko0SaaIttyYpWiRbcvvfMTczRdKqPbUFnnUKUQRy
         kTkQKiqqpxgbqFSw2RaStf71XHJ4sPI4mE4uSmB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Cheng <chenglang@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 204/408] RDMA/hns: Add a check for current state before modifying QP
Date:   Tue, 27 Oct 2020 14:52:22 +0100
Message-Id: <20201027135504.564180604@linuxfoundation.org>
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
index 8dd2d666f6875..730e50c87a760 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1181,8 +1181,10 @@ int hns_roce_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
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



