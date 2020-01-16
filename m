Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E2A13E2C5
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbgAPQ6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:58:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387557AbgAPQ5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4388D24684;
        Thu, 16 Jan 2020 16:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193869;
        bh=iQaqarOnsYefb85HkAU/PcRkM1Wu80tYmegtL2PbKtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfhSDU4EjfERfQMG5HVKvxb+ZlDoG+Pi/zFoEr439Hg/9WBd+1bWD6rg038K9V22a
         crcuOk49yjF5/Ysk1ksXn1WXeM8ghKxrFVr80MkRVZCfSYgUtX4AEgeuIG6wsZUcLD
         QkUlrFI2S/XVIFVtZ2rzSoocpof5V49F08aOgETk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raju Rangoju <rajur@chelsio.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 114/671] RDMA/iw_cxgb4: Fix the unchecked ep dereference
Date:   Thu, 16 Jan 2020 11:45:45 -0500
Message-Id: <20200116165502.8838-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>

[ Upstream commit 3352976c892301fd576a2e9ff0ac7337b2e2ca48 ]

The patch 944661dd97f4: "RDMA/iw_cxgb4: atomically lookup ep and get a
reference" from May 6, 2016, leads to the following Smatch complaint:

    drivers/infiniband/hw/cxgb4/cm.c:2953 terminate()
    error: we previously assumed 'ep' could be null (see line 2945)

Fixes: 944661dd97f4 ("RDMA/iw_cxgb4: atomically lookup ep and get a reference")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 4dcc92d11609..1b3d014fa1d6 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2947,15 +2947,18 @@ static int terminate(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	ep = get_ep_from_tid(dev, tid);
 
-	if (ep && ep->com.qp) {
-		pr_warn("TERM received tid %u qpid %u\n",
-			tid, ep->com.qp->wq.sq.qid);
-		attrs.next_state = C4IW_QP_STATE_TERMINATE;
-		c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
-			       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
+	if (ep) {
+		if (ep->com.qp) {
+			pr_warn("TERM received tid %u qpid %u\n", tid,
+				ep->com.qp->wq.sq.qid);
+			attrs.next_state = C4IW_QP_STATE_TERMINATE;
+			c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
+				       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
+		}
+
+		c4iw_put_ep(&ep->com);
 	} else
 		pr_warn("TERM received tid %u no ep/qp\n", tid);
-	c4iw_put_ep(&ep->com);
 
 	return 0;
 }
-- 
2.20.1

