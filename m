Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2511C4FD41F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352727AbiDLHgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351194AbiDLHb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:31:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E169750452;
        Tue, 12 Apr 2022 00:08:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E565616C5;
        Tue, 12 Apr 2022 07:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A50AC385A1;
        Tue, 12 Apr 2022 07:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747314;
        bh=KeggjO9hLyIRfB/b4st72OMc/DjgSW6YL7AfplDtUUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYF+gRpVCpwnha8J0yXS1JBCuPr1c7hSiLN4Dxory3c8jtRy1Oxr1+7I+8QxVl8Ed
         begU3xufJPyTuELkjwEA7tbvvog/HEtvc5lgmGy+T/8GyV570m9NrlyS7LtkIMd5jB
         12R2bK1arW2USuqj/ODQCAPP+S9L6CqH9a3l5ubw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Aleksei Marov <aleksei.marov@ionos.com>,
        Md Haris Iqbal <haris.iqbal@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 035/343] RDMA/rtrs-clt: Do stop and failover outside reconnect work.
Date:   Tue, 12 Apr 2022 08:27:33 +0200
Message-Id: <20220412062952.119446078@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit c1289d5d8502d62e5bc50ff066c9d6daabfc3264 ]

We can't do instant reconnect, not to DDoS server, but we should stop and
failover earlier, so there is less service interruption.

To avoid deadlock, as error_recovery is called from different callback
like rdma event or hb error handler, add a new err recovery_work.

Link: https://lore.kernel.org/r/20220114154753.983568-6-haris.iqbal@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Aleksei Marov <aleksei.marov@ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 40 ++++++++++++++------------
 drivers/infiniband/ulp/rtrs/rtrs-clt.h |  1 +
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 759b85f03331..df4d06d4d183 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -297,6 +297,7 @@ static bool rtrs_clt_change_state_from_to(struct rtrs_clt_path *clt_path,
 	return changed;
 }
 
+static void rtrs_clt_stop_and_destroy_conns(struct rtrs_clt_path *clt_path);
 static void rtrs_rdma_error_recovery(struct rtrs_clt_con *con)
 {
 	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
@@ -304,16 +305,7 @@ static void rtrs_rdma_error_recovery(struct rtrs_clt_con *con)
 	if (rtrs_clt_change_state_from_to(clt_path,
 					   RTRS_CLT_CONNECTED,
 					   RTRS_CLT_RECONNECTING)) {
-		struct rtrs_clt_sess *clt = clt_path->clt;
-		unsigned int delay_ms;
-
-		/*
-		 * Normal scenario, reconnect if we were successfully connected
-		 */
-		delay_ms = clt->reconnect_delay_sec * 1000;
-		queue_delayed_work(rtrs_wq, &clt_path->reconnect_dwork,
-				   msecs_to_jiffies(delay_ms +
-						    prandom_u32() % RTRS_RECONNECT_SEED));
+		queue_work(rtrs_wq, &clt_path->err_recovery_work);
 	} else {
 		/*
 		 * Error can happen just on establishing new connection,
@@ -1511,6 +1503,22 @@ static void rtrs_clt_init_hb(struct rtrs_clt_path *clt_path)
 static void rtrs_clt_reconnect_work(struct work_struct *work);
 static void rtrs_clt_close_work(struct work_struct *work);
 
+static void rtrs_clt_err_recovery_work(struct work_struct *work)
+{
+	struct rtrs_clt_path *clt_path;
+	struct rtrs_clt_sess *clt;
+	int delay_ms;
+
+	clt_path = container_of(work, struct rtrs_clt_path, err_recovery_work);
+	clt = clt_path->clt;
+	delay_ms = clt->reconnect_delay_sec * 1000;
+	rtrs_clt_stop_and_destroy_conns(clt_path);
+	queue_delayed_work(rtrs_wq, &clt_path->reconnect_dwork,
+			   msecs_to_jiffies(delay_ms +
+					    prandom_u32() %
+					    RTRS_RECONNECT_SEED));
+}
+
 static struct rtrs_clt_path *alloc_path(struct rtrs_clt_sess *clt,
 					const struct rtrs_addr *path,
 					size_t con_num, u32 nr_poll_queues)
@@ -1562,6 +1570,7 @@ static struct rtrs_clt_path *alloc_path(struct rtrs_clt_sess *clt,
 	clt_path->state = RTRS_CLT_CONNECTING;
 	atomic_set(&clt_path->connected_cnt, 0);
 	INIT_WORK(&clt_path->close_work, rtrs_clt_close_work);
+	INIT_WORK(&clt_path->err_recovery_work, rtrs_clt_err_recovery_work);
 	INIT_DELAYED_WORK(&clt_path->reconnect_dwork, rtrs_clt_reconnect_work);
 	rtrs_clt_init_hb(clt_path);
 
@@ -2326,6 +2335,7 @@ static void rtrs_clt_close_work(struct work_struct *work)
 
 	clt_path = container_of(work, struct rtrs_clt_path, close_work);
 
+	cancel_work_sync(&clt_path->err_recovery_work);
 	cancel_delayed_work_sync(&clt_path->reconnect_dwork);
 	rtrs_clt_stop_and_destroy_conns(clt_path);
 	rtrs_clt_change_state_get_old(clt_path, RTRS_CLT_CLOSED, NULL);
@@ -2638,7 +2648,6 @@ static void rtrs_clt_reconnect_work(struct work_struct *work)
 {
 	struct rtrs_clt_path *clt_path;
 	struct rtrs_clt_sess *clt;
-	unsigned int delay_ms;
 	int err;
 
 	clt_path = container_of(to_delayed_work(work), struct rtrs_clt_path,
@@ -2655,8 +2664,6 @@ static void rtrs_clt_reconnect_work(struct work_struct *work)
 	}
 	clt_path->reconnect_attempts++;
 
-	/* Stop everything */
-	rtrs_clt_stop_and_destroy_conns(clt_path);
 	msleep(RTRS_RECONNECT_BACKOFF);
 	if (rtrs_clt_change_state_get_old(clt_path, RTRS_CLT_CONNECTING, NULL)) {
 		err = init_path(clt_path);
@@ -2669,11 +2676,7 @@ static void rtrs_clt_reconnect_work(struct work_struct *work)
 reconnect_again:
 	if (rtrs_clt_change_state_get_old(clt_path, RTRS_CLT_RECONNECTING, NULL)) {
 		clt_path->stats->reconnects.fail_cnt++;
-		delay_ms = clt->reconnect_delay_sec * 1000;
-		queue_delayed_work(rtrs_wq, &clt_path->reconnect_dwork,
-				   msecs_to_jiffies(delay_ms +
-						    prandom_u32() %
-						    RTRS_RECONNECT_SEED));
+		queue_work(rtrs_wq, &clt_path->err_recovery_work);
 	}
 }
 
@@ -2908,6 +2911,7 @@ int rtrs_clt_reconnect_from_sysfs(struct rtrs_clt_path *clt_path)
 						 &old_state);
 	if (changed) {
 		clt_path->reconnect_attempts = 0;
+		rtrs_clt_stop_and_destroy_conns(clt_path);
 		queue_delayed_work(rtrs_wq, &clt_path->reconnect_dwork, 0);
 	}
 	if (changed || old_state == RTRS_CLT_RECONNECTING) {
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.h b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
index d1b18a154ae0..f848c0392d98 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
@@ -134,6 +134,7 @@ struct rtrs_clt_path {
 	struct rtrs_clt_io_req	*reqs;
 	struct delayed_work	reconnect_dwork;
 	struct work_struct	close_work;
+	struct work_struct	err_recovery_work;
 	unsigned int		reconnect_attempts;
 	bool			established;
 	struct rtrs_rbuf	*rbufs;
-- 
2.35.1



