Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEA25830EB
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242942AbiG0Rn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242943AbiG0Rn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:43:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D03F89EBA;
        Wed, 27 Jul 2022 09:52:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FBE1616BD;
        Wed, 27 Jul 2022 16:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CD7C433D6;
        Wed, 27 Jul 2022 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940747;
        bh=09q0fp0UNnv65fb09KZBA3JX8+stgJ9Pdq795VBDTWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgPgVNiNe5SYdWJ2+dg8/mjFnsmw4WAAiXZJtMwOwv9/JO2OIRcAVpMay2CwwXL88
         1RRLXHlZl1SD2Ot8vJ6TBA6aHDgBpZzyLpUPg0PJghGDvDmSnH8p+EXtEO2bQ11DEa
         LAdmexzoJzg886BgNhYBpD+rpkR9TyTktxYCuTQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 102/158] amt: remove unnecessary locks
Date:   Wed, 27 Jul 2022 18:12:46 +0200
Message-Id: <20220727161025.552206594@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 9c343ea6185febe5f6b74f7f7b3757f3dd9c5af6 ]

By the previous patch, amt gateway handlers are changed to worked by
a single thread.
So, most locks for gateway are not needed.
So, it removes.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index f8e8381e266b..615f26a553ae 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -577,8 +577,8 @@ static struct sk_buff *amt_build_igmp_gq(struct amt_dev *amt)
 	return skb;
 }
 
-static void __amt_update_gw_status(struct amt_dev *amt, enum amt_status status,
-				   bool validate)
+static void amt_update_gw_status(struct amt_dev *amt, enum amt_status status,
+				 bool validate)
 {
 	if (validate && amt->status >= status)
 		return;
@@ -600,14 +600,6 @@ static void __amt_update_relay_status(struct amt_tunnel_list *tunnel,
 	tunnel->status = status;
 }
 
-static void amt_update_gw_status(struct amt_dev *amt, enum amt_status status,
-				 bool validate)
-{
-	spin_lock_bh(&amt->lock);
-	__amt_update_gw_status(amt, status, validate);
-	spin_unlock_bh(&amt->lock);
-}
-
 static void amt_update_relay_status(struct amt_tunnel_list *tunnel,
 				    enum amt_status status, bool validate)
 {
@@ -700,9 +692,7 @@ static void amt_send_discovery(struct amt_dev *amt)
 	if (unlikely(net_xmit_eval(err)))
 		amt->dev->stats.tx_errors++;
 
-	spin_lock_bh(&amt->lock);
-	__amt_update_gw_status(amt, AMT_STATUS_SENT_DISCOVERY, true);
-	spin_unlock_bh(&amt->lock);
+	amt_update_gw_status(amt, AMT_STATUS_SENT_DISCOVERY, true);
 out:
 	rcu_read_unlock();
 }
@@ -937,18 +927,14 @@ static void amt_secret_work(struct work_struct *work)
 
 static void amt_event_send_discovery(struct amt_dev *amt)
 {
-	spin_lock_bh(&amt->lock);
 	if (amt->status > AMT_STATUS_SENT_DISCOVERY)
 		goto out;
 	get_random_bytes(&amt->nonce, sizeof(__be32));
-	spin_unlock_bh(&amt->lock);
 
 	amt_send_discovery(amt);
-	spin_lock_bh(&amt->lock);
 out:
 	mod_delayed_work(amt_wq, &amt->discovery_wq,
 			 msecs_to_jiffies(AMT_DISCOVERY_TIMEOUT));
-	spin_unlock_bh(&amt->lock);
 }
 
 static void amt_discovery_work(struct work_struct *work)
@@ -966,7 +952,6 @@ static void amt_event_send_request(struct amt_dev *amt)
 {
 	u32 exp;
 
-	spin_lock_bh(&amt->lock);
 	if (amt->status < AMT_STATUS_RECEIVED_ADVERTISEMENT)
 		goto out;
 
@@ -976,21 +961,18 @@ static void amt_event_send_request(struct amt_dev *amt)
 		amt->ready4 = false;
 		amt->ready6 = false;
 		amt->remote_ip = 0;
-		__amt_update_gw_status(amt, AMT_STATUS_INIT, false);
+		amt_update_gw_status(amt, AMT_STATUS_INIT, false);
 		amt->req_cnt = 0;
 		goto out;
 	}
-	spin_unlock_bh(&amt->lock);
 
 	amt_send_request(amt, false);
 	amt_send_request(amt, true);
-	spin_lock_bh(&amt->lock);
-	__amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
+	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
 	amt->req_cnt++;
 out:
 	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
 	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 1000));
-	spin_unlock_bh(&amt->lock);
 }
 
 static void amt_req_work(struct work_struct *work)
@@ -2386,12 +2368,10 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		ihv3 = skb_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
-		spin_lock_bh(&amt->lock);
 		amt->ready4 = true;
 		amt->mac = amtmq->response_mac;
 		amt->req_cnt = 0;
 		amt->qi = ihv3->qqic;
-		spin_unlock_bh(&amt->lock);
 		skb->protocol = htons(ETH_P_IP);
 		eth->h_proto = htons(ETH_P_IP);
 		ip_eth_mc_map(iph->daddr, eth->h_dest);
@@ -2411,12 +2391,10 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		mld2q = skb_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
-		spin_lock_bh(&amt->lock);
 		amt->ready6 = true;
 		amt->mac = amtmq->response_mac;
 		amt->req_cnt = 0;
 		amt->qi = mld2q->mld2q_qqic;
-		spin_unlock_bh(&amt->lock);
 		skb->protocol = htons(ETH_P_IPV6);
 		eth->h_proto = htons(ETH_P_IPV6);
 		ipv6_eth_mc_map(&ip6h->daddr, eth->h_dest);
-- 
2.35.1



