Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8829559A0C3
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352401AbiHSQW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352481AbiHSQVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:21:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A33B1F1;
        Fri, 19 Aug 2022 09:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C189B82812;
        Fri, 19 Aug 2022 16:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B66EC433C1;
        Fri, 19 Aug 2022 16:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924947;
        bh=Uyn+X1OwbaITjamq4ta4a4Xbpn8zh6/jOe2ZakygT90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yjnsa7EhYLp2XOEh7xzErOh3xS9DCbKc3lDJiLxDpRbPK/gQRScFrwnnp+53597RJ
         ooIoLYUS3ugoiJsQZMiSRXbnX0o2IZRwCoRYAQgmFgmdYq+YPJ6/IeB5sPu1ClRJjW
         OZXZAu1EaBd1a/cn2mNvP5dYVnYtC2bEQ2ElCRKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/545] RDMA/rtrs: Avoid Wtautological-constant-out-of-range-compare
Date:   Fri, 19 Aug 2022 17:41:43 +0200
Message-Id: <20220819153844.289126654@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 0e8558476faf02ec51256cad9c487c93c346198c ]

drivers/infiniband/ulp/rtrs/rtrs-clt.c:1786:19: warning: result of comparison of
constant 'MAX_SESS_QUEUE_DEPTH' (65536) with expression of type 'u16'
(aka 'unsigned short') is always false [-Wtautological-constant-out-of-range-compare]

To fix it, limit MAX_SESS_QUEUE_DEPTH to u16 max, which is 65535, and
drop the check in rtrs-clt, as it's the type u16 max.

Link: https://lore.kernel.org/r/20210531122835.58329-1-jinpu.wang@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 5 -----
 drivers/infiniband/ulp/rtrs/rtrs-pri.h | 4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 13634eda833d..5c39e4c4bef7 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1728,11 +1728,6 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 	if (con->c.cid == 0) {
 		queue_depth = le16_to_cpu(msg->queue_depth);
 
-		if (queue_depth > MAX_SESS_QUEUE_DEPTH) {
-			rtrs_err(clt, "Invalid RTRS message: queue=%d\n",
-				  queue_depth);
-			return -ECONNRESET;
-		}
 		if (sess->queue_depth > 0 && queue_depth != sess->queue_depth) {
 			rtrs_err(clt, "Error: queue depth changed\n");
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index 333de9d52172..77e98ff9008a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -53,9 +53,9 @@ enum {
 	 * But mempool_create, create_qp and ib_post_send fail with
 	 * "cannot allocate memory" error if sess_queue_depth is too big.
 	 * Therefore the pratical max value of sess_queue_depth is
-	 * somewhere between 1 and 65536 and it depends on the system.
+	 * somewhere between 1 and 65534 and it depends on the system.
 	 */
-	MAX_SESS_QUEUE_DEPTH = 65536,
+	MAX_SESS_QUEUE_DEPTH = 65535,
 	MIN_CHUNK_SIZE = 8192,
 
 	RTRS_HB_INTERVAL_MS = 5000,
-- 
2.35.1



