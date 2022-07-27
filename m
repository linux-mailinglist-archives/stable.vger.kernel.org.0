Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E1F5830EA
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbiG0Rnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242951AbiG0RnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:43:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1F189E96;
        Wed, 27 Jul 2022 09:52:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 005F5B821C5;
        Wed, 27 Jul 2022 16:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B084C433D6;
        Wed, 27 Jul 2022 16:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940750;
        bh=KyG0K0b3BcFKnfJuykmQL/fQ2eRx4YGZhGc1jZw4O4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9fNykvS5aoUmPGzf7P5yAKsSGd2XNJw+1CsSrUyq+Lhp3JARGkiAVvUMeC9oZPiQ
         5Y37E0NpMz11VcAT5aec5dn/+29u9hoIkwj28dl9EB4zM28Phm1a9J0hirHz5joOw8
         BPUK0BglKV788/1X02DfKA+KnQ7uZgIh/DFvlCkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 103/158] amt: use READ_ONCE() in amt module
Date:   Wed, 27 Jul 2022 18:12:47 +0200
Message-Id: <20220727161025.591054387@linuxfoundation.org>
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

[ Upstream commit 928f353cb8672f0d6078aad75eeec0ed33875b12 ]

There are some data races in the amt module.
amt->ready4, amt->ready6, and amt->status can be accessed concurrently
without locks.
So, it uses READ_ONCE() and WRITE_ONCE().

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 615f26a553ae..ff859d4a4b50 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -584,7 +584,7 @@ static void amt_update_gw_status(struct amt_dev *amt, enum amt_status status,
 		return;
 	netdev_dbg(amt->dev, "Update GW status %s -> %s",
 		   status_str[amt->status], status_str[status]);
-	amt->status = status;
+	WRITE_ONCE(amt->status, status);
 }
 
 static void __amt_update_relay_status(struct amt_tunnel_list *tunnel,
@@ -958,8 +958,8 @@ static void amt_event_send_request(struct amt_dev *amt)
 	if (amt->req_cnt > AMT_MAX_REQ_COUNT) {
 		netdev_dbg(amt->dev, "Gateway is not ready");
 		amt->qi = AMT_INIT_REQ_TIMEOUT;
-		amt->ready4 = false;
-		amt->ready6 = false;
+		WRITE_ONCE(amt->ready4, false);
+		WRITE_ONCE(amt->ready6, false);
 		amt->remote_ip = 0;
 		amt_update_gw_status(amt, AMT_STATUS_INIT, false);
 		amt->req_cnt = 0;
@@ -1239,7 +1239,8 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		/* Gateway only passes IGMP/MLD packets */
 		if (!report)
 			goto free;
-		if ((!v6 && !amt->ready4) || (v6 && !amt->ready6))
+		if ((!v6 && !READ_ONCE(amt->ready4)) ||
+		    (v6 && !READ_ONCE(amt->ready6)))
 			goto free;
 		if (amt_send_membership_update(amt, skb,  v6))
 			goto free;
@@ -2368,7 +2369,7 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		ihv3 = skb_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
-		amt->ready4 = true;
+		WRITE_ONCE(amt->ready4, true);
 		amt->mac = amtmq->response_mac;
 		amt->req_cnt = 0;
 		amt->qi = ihv3->qqic;
@@ -2391,7 +2392,7 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		mld2q = skb_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
-		amt->ready6 = true;
+		WRITE_ONCE(amt->ready6, true);
 		amt->mac = amtmq->response_mac;
 		amt->req_cnt = 0;
 		amt->qi = mld2q->mld2q_qqic;
@@ -2898,7 +2899,7 @@ static int amt_err_lookup(struct sock *sk, struct sk_buff *skb)
 		break;
 	case AMT_MSG_REQUEST:
 	case AMT_MSG_MEMBERSHIP_UPDATE:
-		if (amt->status >= AMT_STATUS_RECEIVED_ADVERTISEMENT)
+		if (READ_ONCE(amt->status) >= AMT_STATUS_RECEIVED_ADVERTISEMENT)
 			mod_delayed_work(amt_wq, &amt->req_wq, 0);
 		break;
 	default:
-- 
2.35.1



