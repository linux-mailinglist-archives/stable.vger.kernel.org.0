Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C64AF74A
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbfD3Lrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbfD3Lrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:47:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B1A2054F;
        Tue, 30 Apr 2019 11:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624860;
        bh=S+Iykvg4Xa0Snio24a4EY6114LsbjfA2HXGzUv8Pbh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoVnRNmPaWkii7optjY1UN2huBdwa4HurahCRNAH0kTLSTkzlyDMZ+LkLGDuvvjXo
         aQA5UK0rp8+9bwDYP4qLIWjV8s72a8MnGSPhey33rHQC/JWxOexz2nAJ7l9S7vCc2u
         YHBEkqZeu/bO1Lak599lQvHhGuce4q0o+6rtGsLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjun.zhu@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 088/100] net: rds: exchange of 8K and 1M pool
Date:   Tue, 30 Apr 2019 13:38:57 +0200
Message-Id: <20190430113612.954739931@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>

[ Upstream commit 4b9fc7146249a6e0e3175d0acc033fdcd2bfcb17 ]

Before the commit 490ea5967b0d ("RDS: IB: move FMR code to its own file"),
when the dirty_count is greater than 9/10 of max_items of 8K pool,
1M pool is used, Vice versa. After the commit 490ea5967b0d ("RDS: IB: move
FMR code to its own file"), the above is removed. When we make the
following tests.

Server:
  rds-stress -r 1.1.1.16 -D 1M

Client:
  rds-stress -r 1.1.1.14 -s 1.1.1.16 -D 1M

The following will appear.
"
connecting to 1.1.1.16:4000
negotiated options, tasks will start in 2 seconds
Starting up..header from 1.1.1.166:4001 to id 4001 bogus
..
tsks  tx/s  rx/s tx+rx K/s  mbi K/s  mbo K/s tx us/c  rtt us
cpu %
   1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
   1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
   1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
   1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
   1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
...
"
So this exchange between 8K and 1M pool is added back.

Fixes: commit 490ea5967b0d ("RDS: IB: move FMR code to its own file")
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/ib_fmr.c  |   11 +++++++++++
 net/rds/ib_rdma.c |    3 ---
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/net/rds/ib_fmr.c
+++ b/net/rds/ib_fmr.c
@@ -44,6 +44,17 @@ struct rds_ib_mr *rds_ib_alloc_fmr(struc
 	else
 		pool = rds_ibdev->mr_1m_pool;
 
+	if (atomic_read(&pool->dirty_count) >= pool->max_items / 10)
+		queue_delayed_work(rds_ib_mr_wq, &pool->flush_worker, 10);
+
+	/* Switch pools if one of the pool is reaching upper limit */
+	if (atomic_read(&pool->dirty_count) >=  pool->max_items * 9 / 10) {
+		if (pool->pool_type == RDS_IB_MR_8K_POOL)
+			pool = rds_ibdev->mr_1m_pool;
+		else
+			pool = rds_ibdev->mr_8k_pool;
+	}
+
 	ibmr = rds_ib_try_reuse_ibmr(pool);
 	if (ibmr)
 		return ibmr;
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -454,9 +454,6 @@ struct rds_ib_mr *rds_ib_try_reuse_ibmr(
 	struct rds_ib_mr *ibmr = NULL;
 	int iter = 0;
 
-	if (atomic_read(&pool->dirty_count) >= pool->max_items_soft / 10)
-		queue_delayed_work(rds_ib_mr_wq, &pool->flush_worker, 10);
-
 	while (1) {
 		ibmr = rds_ib_reuse_mr(pool);
 		if (ibmr)


