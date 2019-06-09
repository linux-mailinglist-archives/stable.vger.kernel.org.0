Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0C13A781
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbfFIQuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731671AbfFIQuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:50:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF2A82070B;
        Sun,  9 Jun 2019 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099013;
        bh=eBArp9OlkdlnU/YwwDnldjPrHVr7342yFoQF/lOt9yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02LKhgKAeSVn8mrdwQuySyQkVT/4Y+5Fpeu5tdaslfYEOCCtDEjHOdsnQed5xITeT
         10kVR/0y7aDE05RnaxxIMBwee2/8jXVnn4LTPUuduJNYHritcgBBgyAi/3rSVfgJJo
         8W4+1qyvWOGwuTAwJ7LKGi1EyWbrVVDPITw7PO8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjun.zhu@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 05/35] net: rds: fix memory leak in rds_ib_flush_mr_pool
Date:   Sun,  9 Jun 2019 18:42:11 +0200
Message-Id: <20190609164125.833421918@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164125.377368385@linuxfoundation.org>
References: <20190609164125.377368385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>

[ Upstream commit 85cb928787eab6a2f4ca9d2a798b6f3bed53ced1 ]

When the following tests last for several hours, the problem will occur.

Server:
    rds-stress -r 1.1.1.16 -D 1M
Client:
    rds-stress -r 1.1.1.14 -s 1.1.1.16 -D 1M -T 30

The following will occur.

"
Starting up....
tsks   tx/s   rx/s  tx+rx K/s    mbi K/s    mbo K/s tx us/c   rtt us cpu
%
  1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
  1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
  1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
  1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
"
>From vmcore, we can find that clean_list is NULL.

>From the source code, rds_mr_flushd calls rds_ib_mr_pool_flush_worker.
Then rds_ib_mr_pool_flush_worker calls
"
 rds_ib_flush_mr_pool(pool, 0, NULL);
"
Then in function
"
int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
                         int free_all, struct rds_ib_mr **ibmr_ret)
"
ibmr_ret is NULL.

In the source code,
"
...
list_to_llist_nodes(pool, &unmap_list, &clean_nodes, &clean_tail);
if (ibmr_ret)
        *ibmr_ret = llist_entry(clean_nodes, struct rds_ib_mr, llnode);

/* more than one entry in llist nodes */
if (clean_nodes->next)
        llist_add_batch(clean_nodes->next, clean_tail, &pool->clean_list);
...
"
When ibmr_ret is NULL, llist_entry is not executed. clean_nodes->next
instead of clean_nodes is added in clean_list.
So clean_nodes is discarded. It can not be used again.
The workqueue is executed periodically. So more and more clean_nodes are
discarded. Finally the clean_list is NULL.
Then this problem will occur.

Fixes: 1bc144b62524 ("net, rds, Replace xlist in net/rds/xlist.h with llist")
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/ib_rdma.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -416,12 +416,14 @@ int rds_ib_flush_mr_pool(struct rds_ib_m
 		wait_clean_list_grace();
 
 		list_to_llist_nodes(pool, &unmap_list, &clean_nodes, &clean_tail);
-		if (ibmr_ret)
+		if (ibmr_ret) {
 			*ibmr_ret = llist_entry(clean_nodes, struct rds_ib_mr, llnode);
-
+			clean_nodes = clean_nodes->next;
+		}
 		/* more than one entry in llist nodes */
-		if (clean_nodes->next)
-			llist_add_batch(clean_nodes->next, clean_tail, &pool->clean_list);
+		if (clean_nodes)
+			llist_add_batch(clean_nodes, clean_tail,
+					&pool->clean_list);
 
 	}
 


