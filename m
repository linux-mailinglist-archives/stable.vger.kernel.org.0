Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240796AE9C9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjCGR1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbjCGR1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:27:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BE797FD8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:22:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2072B818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F90C433EF;
        Tue,  7 Mar 2023 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209750;
        bh=vUnBYUQj9odB+ptw+kVORsNBFOCSeS5wYxn8Jnchdjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReGTGvzBRqCIELlmzq4DfcvSd1uaQFgAameYJwYh9AyRU5EBIjEqVi21JuirU5hJY
         H82axMQA2aA/gvWqn8HxMwVp7pUKxtB9ZTitEk71Z8BuwNezTQ1JbInDTdbPRhgHxE
         5vVJ9zxKbctHDkVHq4HfJTLzKGsO2N8NgdeTY72Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "D. Wythe" <alibuda@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0318/1001] net/smc: fix application data exception
Date:   Tue,  7 Mar 2023 17:51:30 +0100
Message-Id: <20230307170035.350731577@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit 475f9ff63ee8c296aa46c6e9e9ad9bdd301c6bdf ]

There is a certain probability that following
exceptions will occur in the wrk benchmark test:

Running 10s test @ http://11.213.45.6:80
  8 threads and 64 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     3.72ms   13.94ms 245.33ms   94.17%
    Req/Sec     1.96k   713.67     5.41k    75.16%
  155262 requests in 10.10s, 23.10MB read
Non-2xx or 3xx responses: 3

We will find that the error is HTTP 400 error, which is a serious
exception in our test, which means the application data was
corrupted.

Consider the following scenarios:

CPU0                            CPU1

buf_desc->used = 0;
                                cmpxchg(buf_desc->used, 0, 1)
                                deal_with(buf_desc)

memset(buf_desc->cpu_addr,0);

This will cause the data received by a victim connection to be cleared,
thus triggering an HTTP 400 error in the server.

This patch exchange the order between clear used and memset, add
barrier to ensure memory consistency.

Fixes: 1c5526968e27 ("net/smc: Clear memory when release and reuse buffer")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index c305d8dd23f80..c19d4b7c1f28a 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1120,8 +1120,9 @@ static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
 
 		smc_buf_free(lgr, is_rmb, buf_desc);
 	} else {
-		buf_desc->used = 0;
-		memset(buf_desc->cpu_addr, 0, buf_desc->len);
+		/* memzero_explicit provides potential memory barrier semantics */
+		memzero_explicit(buf_desc->cpu_addr, buf_desc->len);
+		WRITE_ONCE(buf_desc->used, 0);
 	}
 }
 
@@ -1132,19 +1133,17 @@ static void smc_buf_unuse(struct smc_connection *conn,
 		if (!lgr->is_smcd && conn->sndbuf_desc->is_vm) {
 			smcr_buf_unuse(conn->sndbuf_desc, false, lgr);
 		} else {
-			conn->sndbuf_desc->used = 0;
-			memset(conn->sndbuf_desc->cpu_addr, 0,
-			       conn->sndbuf_desc->len);
+			memzero_explicit(conn->sndbuf_desc->cpu_addr, conn->sndbuf_desc->len);
+			WRITE_ONCE(conn->sndbuf_desc->used, 0);
 		}
 	}
 	if (conn->rmb_desc) {
 		if (!lgr->is_smcd) {
 			smcr_buf_unuse(conn->rmb_desc, true, lgr);
 		} else {
-			conn->rmb_desc->used = 0;
-			memset(conn->rmb_desc->cpu_addr, 0,
-			       conn->rmb_desc->len +
-			       sizeof(struct smcd_cdc_msg));
+			memzero_explicit(conn->rmb_desc->cpu_addr,
+					 conn->rmb_desc->len + sizeof(struct smcd_cdc_msg));
+			WRITE_ONCE(conn->rmb_desc->used, 0);
 		}
 	}
 }
-- 
2.39.2



