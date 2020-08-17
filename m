Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E42424757A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390444AbgHQTX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730442AbgHQPeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:34:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD22E22BEF;
        Mon, 17 Aug 2020 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678489;
        bh=0ay/RrJGtz7p5JCeEL2riGtfbb08ca11TFjXDHxvjic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHNZ9JgpD1HlX+aDCDbhgyjQdHYT19n04f2F8OnCZPohWY7y6vA9gQ3HQP3yJ7GbG
         F6rMG7QDa4A5X9m0COBIM3oBQhoeLx3OobZ0vlj1YGIiexAKrgT4FB/nueiO22FFX8
         Z+lRXgFflluE5MMHSWH7eH9AmNUgZRENo6K2/di8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 320/464] RDMA/rtrs-clt: add an additional random 8 seconds before reconnecting
Date:   Mon, 17 Aug 2020 17:14:33 +0200
Message-Id: <20200817143849.125018827@linuxfoundation.org>
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

From: Danil Kipnis <danil.kipnis@cloud.ionos.com>

[ Upstream commit 09e0dbbeed82e35ce2cd21e086a6fac934163e2a ]

In order to avoid all the clients to start reconnecting at the same time
schedule the reconnect dwork with a random jitter of +[0,8] seconds.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20200724111508.15734-2-haris.iqbal@cloud.ionos.com
Signed-off-by: Danil Kipnis <danil.kipnis@cloud.ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 564388a85603f..5b31d3b03737c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/rculist.h>
+#include <linux/random.h>
 
 #include "rtrs-clt.h"
 #include "rtrs-log.h"
@@ -23,6 +24,12 @@
  * leads to "false positives" failed reconnect attempts
  */
 #define RTRS_RECONNECT_BACKOFF 1000
+/*
+ * Wait for additional random time between 0 and 8 seconds
+ * before starting to reconnect to avoid clients reconnecting
+ * all at once in case of a major network outage
+ */
+#define RTRS_RECONNECT_SEED 8
 
 MODULE_DESCRIPTION("RDMA Transport Client");
 MODULE_LICENSE("GPL");
@@ -306,7 +313,8 @@ static void rtrs_rdma_error_recovery(struct rtrs_clt_con *con)
 		 */
 		delay_ms = clt->reconnect_delay_sec * 1000;
 		queue_delayed_work(rtrs_wq, &sess->reconnect_dwork,
-				   msecs_to_jiffies(delay_ms));
+				   msecs_to_jiffies(delay_ms +
+						    prandom_u32() % RTRS_RECONNECT_SEED));
 	} else {
 		/*
 		 * Error can happen just on establishing new connection,
@@ -2503,7 +2511,9 @@ static void rtrs_clt_reconnect_work(struct work_struct *work)
 		sess->stats->reconnects.fail_cnt++;
 		delay_ms = clt->reconnect_delay_sec * 1000;
 		queue_delayed_work(rtrs_wq, &sess->reconnect_dwork,
-				   msecs_to_jiffies(delay_ms));
+				   msecs_to_jiffies(delay_ms +
+						    prandom_u32() %
+						    RTRS_RECONNECT_SEED));
 	}
 }
 
-- 
2.25.1



