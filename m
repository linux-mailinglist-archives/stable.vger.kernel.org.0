Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB14F12C6AA
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbfL2RtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:49:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731617AbfL2RtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BD7A20718;
        Sun, 29 Dec 2019 17:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641758;
        bh=aWlCl/ryZkRTK0vYOF2eA9khOn2Ewqb/RCuumN9MEtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZV1oDgnyB57YpdE9CykZzPaAR0ICzw3IfrJiHw7YfW49XjJB7EDXSiAupXtVEWPi
         y43eEVOTCWf0AyFiH2aJ9ld5Lxa88JfQ3B+FDGS1aeAUyIngyC6KwdeODTOhkwib4W
         7QZ9J54IcgrZzWiuS5M3VqWLtHbBO4UqU0fd/MBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/434] RDMA/hns: Fix memory leak on context on error return path
Date:   Sun, 29 Dec 2019 18:24:13 +0100
Message-Id: <20191229172715.113944936@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 994195e1537074f56df216a9309f6e366cb35b67 ]

Currently, the error return path when the call to function
dev->dfx->query_cqc_info fails will leak object 'context'. Fix this by
making the error return path via 'err' return return codes rather than
-EMSGSIZE, set ret appropriately for all error return paths and for the
memory leak now return via 'err' rather than just returning without
freeing context.

Link: https://lore.kernel.org/r/20191024131034.19989-1-colin.king@canonical.com
Addresses-Coverity: ("Resource leak")
Fixes: e1c9a0dc2939 ("RDMA/hns: Dump detailed driver-specific CQ")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_restrack.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_restrack.c b/drivers/infiniband/hw/hns/hns_roce_restrack.c
index 0a31d0a3d657..06871731ac43 100644
--- a/drivers/infiniband/hw/hns/hns_roce_restrack.c
+++ b/drivers/infiniband/hw/hns/hns_roce_restrack.c
@@ -98,11 +98,15 @@ static int hns_roce_fill_res_cq_entry(struct sk_buff *msg,
 		goto err;
 
 	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_DRIVER);
-	if (!table_attr)
+	if (!table_attr) {
+		ret = -EMSGSIZE;
 		goto err;
+	}
 
-	if (hns_roce_fill_cq(msg, context))
+	if (hns_roce_fill_cq(msg, context)) {
+		ret = -EMSGSIZE;
 		goto err_cancel_table;
+	}
 
 	nla_nest_end(msg, table_attr);
 	kfree(context);
@@ -113,7 +117,7 @@ err_cancel_table:
 	nla_nest_cancel(msg, table_attr);
 err:
 	kfree(context);
-	return -EMSGSIZE;
+	return ret;
 }
 
 int hns_roce_fill_res_entry(struct sk_buff *msg,
-- 
2.20.1



