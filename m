Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B171196A9
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfLJVKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbfLJVKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 991C6246A2;
        Tue, 10 Dec 2019 21:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012222;
        bh=aAj3r6xUGwA2FINnoCCGc93gGYj8y6FveUN6IWYk78I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egTTdvliojQlTfDrefP9oJ66IBji/6VZmMcKtVY5ycI0P4qhEs945tjx6+5GVGGWo
         bHDNZH52k/MCOUrV/Pxg6kEj0pwiYxTXadRuhmQqup1oDoEZOpHg1ltJpBGS/296x7
         5LEYXztLhRjIyNcfoU9uPPUsNkvIW6t4L3ALb0DM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 172/350] RDMA/hns: Fix memory leak on 'context' on error return path
Date:   Tue, 10 Dec 2019 16:04:37 -0500
Message-Id: <20191210210735.9077-133-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0a31d0a3d657c..06871731ac43a 100644
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
@@ -113,7 +117,7 @@ static int hns_roce_fill_res_cq_entry(struct sk_buff *msg,
 	nla_nest_cancel(msg, table_attr);
 err:
 	kfree(context);
-	return -EMSGSIZE;
+	return ret;
 }
 
 int hns_roce_fill_res_entry(struct sk_buff *msg,
-- 
2.20.1

