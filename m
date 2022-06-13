Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC907548A99
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378986AbiFMNqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379610AbiFMNop (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:44:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250DE40A0B;
        Mon, 13 Jun 2022 04:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 905A461037;
        Mon, 13 Jun 2022 11:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A876C34114;
        Mon, 13 Jun 2022 11:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119934;
        bh=E/IU0xHrBMG9vGH0wEumoaAiXmB+YxtkyC8ef4+wQlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDDLENIdDZ1+9RjQsrp89IfLoVvp4GLVvFfAykQ4Y3GSSSGIuw1UdVs3pmENPL+l0
         Dr1qdGeQvk33TNO6ZbtM39KhbmsuOrdzHiDo6ZUxWDevST3ZOYCiUc6T30ZG8Hz94E
         Ageew33i/x3Xm6YZX8+pJaQL/il15FFtR9BDQx6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 191/339] amt: fix wrong usage of pskb_may_pull()
Date:   Mon, 13 Jun 2022 12:10:16 +0200
Message-Id: <20220613094932.464117412@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit f55a07074fdd38cab8c097ac5bd397d68eff733c ]

It adds missing pskb_may_pull() in amt_update_handler() and
amt_multicast_data_handler().
And it fixes wrong parameter of pskb_may_pull() in
amt_advertisement_handler() and amt_membership_query_handler().

Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 55 +++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 22d7da749a24..fbb03562cb95 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2220,8 +2220,7 @@ static bool amt_advertisement_handler(struct amt_dev *amt, struct sk_buff *skb)
 	struct amt_header_advertisement *amta;
 	int hdr_size;
 
-	hdr_size = sizeof(*amta) - sizeof(struct amt_header);
-
+	hdr_size = sizeof(*amta) + sizeof(struct udphdr);
 	if (!pskb_may_pull(skb, hdr_size))
 		return true;
 
@@ -2251,19 +2250,27 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 	struct ethhdr *eth;
 	struct iphdr *iph;
 
+	hdr_size = sizeof(*amtmd) + sizeof(struct udphdr);
+	if (!pskb_may_pull(skb, hdr_size))
+		return true;
+
 	amtmd = (struct amt_header_mcast_data *)(udp_hdr(skb) + 1);
 	if (amtmd->reserved || amtmd->version)
 		return true;
 
-	hdr_size = sizeof(*amtmd) + sizeof(struct udphdr);
 	if (iptunnel_pull_header(skb, hdr_size, htons(ETH_P_IP), false))
 		return true;
+
 	skb_reset_network_header(skb);
 	skb_push(skb, sizeof(*eth));
 	skb_reset_mac_header(skb);
 	skb_pull(skb, sizeof(*eth));
 	eth = eth_hdr(skb);
+
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return true;
 	iph = ip_hdr(skb);
+
 	if (iph->version == 4) {
 		if (!ipv4_is_multicast(iph->daddr))
 			return true;
@@ -2274,6 +2281,9 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 	} else if (iph->version == 6) {
 		struct ipv6hdr *ip6h;
 
+		if (!pskb_may_pull(skb, sizeof(*ip6h)))
+			return true;
+
 		ip6h = ipv6_hdr(skb);
 		if (!ipv6_addr_is_multicast(&ip6h->daddr))
 			return true;
@@ -2306,8 +2316,7 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	struct iphdr *iph;
 	int hdr_size, len;
 
-	hdr_size = sizeof(*amtmq) - sizeof(struct amt_header);
-
+	hdr_size = sizeof(*amtmq) + sizeof(struct udphdr);
 	if (!pskb_may_pull(skb, hdr_size))
 		return true;
 
@@ -2315,22 +2324,27 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	if (amtmq->reserved || amtmq->version)
 		return true;
 
-	hdr_size = sizeof(*amtmq) + sizeof(struct udphdr) - sizeof(*eth);
+	hdr_size -= sizeof(*eth);
 	if (iptunnel_pull_header(skb, hdr_size, htons(ETH_P_TEB), false))
 		return true;
+
 	oeth = eth_hdr(skb);
 	skb_reset_mac_header(skb);
 	skb_pull(skb, sizeof(*eth));
 	skb_reset_network_header(skb);
 	eth = eth_hdr(skb);
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return true;
+
 	iph = ip_hdr(skb);
 	if (iph->version == 4) {
-		if (!ipv4_is_multicast(iph->daddr))
-			return true;
 		if (!pskb_may_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS +
 				   sizeof(*ihv3)))
 			return true;
 
+		if (!ipv4_is_multicast(iph->daddr))
+			return true;
+
 		ihv3 = skb_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
@@ -2345,15 +2359,17 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		ip_eth_mc_map(iph->daddr, eth->h_dest);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (iph->version == 6) {
-		struct ipv6hdr *ip6h = ipv6_hdr(skb);
 		struct mld2_query *mld2q;
+		struct ipv6hdr *ip6h;
 
-		if (!ipv6_addr_is_multicast(&ip6h->daddr))
-			return true;
 		if (!pskb_may_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS +
 				   sizeof(*mld2q)))
 			return true;
 
+		ip6h = ipv6_hdr(skb);
+		if (!ipv6_addr_is_multicast(&ip6h->daddr))
+			return true;
+
 		mld2q = skb_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
@@ -2389,23 +2405,23 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 {
 	struct amt_header_membership_update *amtmu;
 	struct amt_tunnel_list *tunnel;
-	struct udphdr *udph;
 	struct ethhdr *eth;
 	struct iphdr *iph;
-	int len;
+	int len, hdr_size;
 
 	iph = ip_hdr(skb);
-	udph = udp_hdr(skb);
 
-	if (__iptunnel_pull_header(skb, sizeof(*udph), skb->protocol,
-				   false, false))
+	hdr_size = sizeof(*amtmu) + sizeof(struct udphdr);
+	if (!pskb_may_pull(skb, hdr_size))
 		return true;
 
-	amtmu = (struct amt_header_membership_update *)skb->data;
+	amtmu = (struct amt_header_membership_update *)(udp_hdr(skb) + 1);
 	if (amtmu->reserved || amtmu->version)
 		return true;
 
-	skb_pull(skb, sizeof(*amtmu));
+	if (iptunnel_pull_header(skb, hdr_size, skb->protocol, false))
+		return true;
+
 	skb_reset_network_header(skb);
 
 	list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list) {
@@ -2426,6 +2442,9 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 	return true;
 
 report:
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return true;
+
 	iph = ip_hdr(skb);
 	if (iph->version == 4) {
 		if (ip_mc_check_igmp(skb)) {
-- 
2.35.1



