Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1E2111DD1
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfLCW5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:57:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbfLCW5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:57:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4678B20803;
        Tue,  3 Dec 2019 22:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413842;
        bh=6l1wOmolfxD+j5KIMvG2dSSOaGeCOOsN1zc9qmVWZzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLTrLfQ71lOQsViVlt+YdEhye4RjsPnqa/R5ox+cNoBDzFkTlyylq1KeonA6Rqnap
         wzQqAXYzDAaqoLySbyTu7sQ+PSHcZVnkWjxHJ/nYMh0zUblOb8CC4fOT1LAc39sHaV
         xW6HGXrA4H7kqzhqkTQXzq3TnGZ9Tuc4qZXEFjac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 256/321] RDMA/hns: Bugfix for the scene without receiver queue
Date:   Tue,  3 Dec 2019 23:35:22 +0100
Message-Id: <20191203223440.452689729@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 4d103905eb1e4f14cb62fcf962c9d35da7005dea ]

In some application scenario, the user could not have receive queue when
run rdma write or read operation.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 54d22868ffba5..af24698ff2262 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -522,7 +522,8 @@ static int hns_roce_qp_has_sq(struct ib_qp_init_attr *attr)
 static int hns_roce_qp_has_rq(struct ib_qp_init_attr *attr)
 {
 	if (attr->qp_type == IB_QPT_XRC_INI ||
-	    attr->qp_type == IB_QPT_XRC_TGT || attr->srq)
+	    attr->qp_type == IB_QPT_XRC_TGT || attr->srq ||
+	    !attr->cap.max_recv_wr)
 		return 0;
 
 	return 1;
-- 
2.20.1



