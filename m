Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D251246A62
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbgHQPfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:35:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730444AbgHQPew (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:34:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA11520888;
        Mon, 17 Aug 2020 15:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678492;
        bh=2iTKKjooyqukB+e6TTCtLKXF4mZFXs2I/Cpu/fnjy7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTDYKMJOXey2fBhVrNw54Ll+hMRnxwDtrGKplXFm7e6d9eKWBHAjskRUTWian2290
         a9jEIgBvrkywS5mCUEdbBuzk0J0wbuoHZynhJPX3ESuAaDgrEi62FQF7o+Iku0xM/b
         yEwd9h6n4Tzn9/LvoE1cL7Re5ukplQg4DLFb+pyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 321/464] RDMA/rtrs: remove WQ_MEM_RECLAIM for rtrs_wq
Date:   Mon, 17 Aug 2020 17:14:34 +0200
Message-Id: <20200817143849.172844464@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit 03ed5a8cda659e3c71d106b0dd4ce6520e4dcd6e ]

lockdep triggers a warning from time to time when running a regression
test:

 rnbd_client L685: </dev/nullb0@bla> Device disconnected.
 rnbd_client L1756: Unloading module

 workqueue: WQ_MEM_RECLAIM rtrs_client_wq:rtrs_clt_reconnect_work [rtrs_client] is flushing !WQ_MEM_RECLAIM ib_addr:process_one_req [ib_core]
 WARNING: CPU: 2 PID: 18824 at kernel/workqueue.c:2517 check_flush_dependency+0xad/0x130

The root cause is workqueue core expect flushing should not be done for a
!WQ_MEM_RECLAIM wq from a WQ_MEM_RECLAIM workqueue.

In above case ib_addr workqueue without WQ_MEM_RECLAIM, but rtrs_wq
WQ_MEM_RECLAIM.

To avoid the warning, remove the WQ_MEM_RECLAIM flag.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20200724111508.15734-4-haris.iqbal@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 2 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 5b31d3b03737c..776e89231c52f 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2982,7 +2982,7 @@ static int __init rtrs_client_init(void)
 		pr_err("Failed to create rtrs-client dev class\n");
 		return PTR_ERR(rtrs_clt_dev_class);
 	}
-	rtrs_wq = alloc_workqueue("rtrs_client_wq", WQ_MEM_RECLAIM, 0);
+	rtrs_wq = alloc_workqueue("rtrs_client_wq", 0, 0);
 	if (!rtrs_wq) {
 		class_destroy(rtrs_clt_dev_class);
 		return -ENOMEM;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 0d9241f5d9e68..a219bd1bdbc26 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -2150,7 +2150,7 @@ static int __init rtrs_server_init(void)
 		err = PTR_ERR(rtrs_dev_class);
 		goto out_chunk_pool;
 	}
-	rtrs_wq = alloc_workqueue("rtrs_server_wq", WQ_MEM_RECLAIM, 0);
+	rtrs_wq = alloc_workqueue("rtrs_server_wq", 0, 0);
 	if (!rtrs_wq) {
 		err = -ENOMEM;
 		goto out_dev_class;
-- 
2.25.1



