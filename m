Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04928147FFA
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389250AbgAXLGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:06:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:41590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732370AbgAXLGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:06:43 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE1592071A;
        Fri, 24 Jan 2020 11:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864002;
        bh=jID49L8InJ28kTz05BGQPzexky28y8yVhY3M59TdTFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELPOogcg0tcJ0wnrE5eKXa80Dv1CPoU0MdVf/0MA1u0XM9qp5C1RTUM6xcJhnCsBJ
         gdKi2t1UIjopLxMrdTmlfeU7wvcbxHAqnjukUxAA8Uzc3NkSFFrCqHJVwhOCghahlQ
         4Sa+ekPvOT64drVGcaSntUGO1Y/vS0lBqKIq+OAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/639] RDMA/iw_cxgb4: Fix the unchecked ep dereference
Date:   Fri, 24 Jan 2020 10:25:00 +0100
Message-Id: <20200124093103.576206377@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4dcc92d116097..1b3d014fa1d6e 100644
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



