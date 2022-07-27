Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060A2582E2C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbiG0RIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiG0RIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:08:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6E76111C;
        Wed, 27 Jul 2022 09:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1D9B60D3B;
        Wed, 27 Jul 2022 16:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E88C433C1;
        Wed, 27 Jul 2022 16:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940029;
        bh=zlHJOWkPsDeDylpjq8ckd+8CGod2vzFec7FDbG9SG6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NC/gwvXybhri5+S9+zi4dyA0iq7HS1g7n5MsKbAYllk7U6R8mLduSNNwVGv8mMm8p
         WEteyeM0tpHELTkEnoly9LgFXxOOBQycv6RIrZhMg3RVU6nkuCvn7La/0VX7wWKn/7
         q+cVVmVkiHfh86WgSK0fFtt5cF0OmLJM00nmnNjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/201] net: ipv4: use kfree_skb_reason() in ip_rcv_core()
Date:   Wed, 27 Jul 2022 18:09:44 +0200
Message-Id: <20220727161030.270068330@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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

From: Menglong Dong <imagedong@tencent.com>

[ Upstream commit 33cba42985c8144eef78d618fc1e51aaa074b169 ]

Replace kfree_skb() with kfree_skb_reason() in ip_rcv_core(). Three new
drop reasons are introduced:

SKB_DROP_REASON_OTHERHOST
SKB_DROP_REASON_IP_CSUM
SKB_DROP_REASON_IP_INHDR

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h     |  9 +++++++++
 include/trace/events/skb.h |  3 +++
 net/ipv4/ip_input.c        | 12 ++++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b63da0d1a4b2..514fb8074f78 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -318,6 +318,15 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
 	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
 	SKB_DROP_REASON_NETFILTER_DROP,	/* dropped by netfilter */
+	SKB_DROP_REASON_OTHERHOST,	/* packet don't belong to current
+					 * host (interface is in promisc
+					 * mode)
+					 */
+	SKB_DROP_REASON_IP_CSUM,	/* IP checksum error */
+	SKB_DROP_REASON_IP_INHDR,	/* there is something wrong with
+					 * IP header (see
+					 * IPSTATS_MIB_INHDRERRORS)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 3d89f7b09a43..f2b1778485f0 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -17,6 +17,9 @@
 	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
 	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
+	EM(SKB_DROP_REASON_OTHERHOST, OTHERHOST)		\
+	EM(SKB_DROP_REASON_IP_CSUM, IP_CSUM)			\
+	EM(SKB_DROP_REASON_IP_INHDR, IP_INHDR)			\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..7be18de32e16 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -436,13 +436,16 @@ static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 {
 	const struct iphdr *iph;
+	int drop_reason;
 	u32 len;
 
 	/* When the interface is in promisc. mode, drop all the crap
 	 * that it receives, do not try to analyse it.
 	 */
-	if (skb->pkt_type == PACKET_OTHERHOST)
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		drop_reason = SKB_DROP_REASON_OTHERHOST;
 		goto drop;
+	}
 
 	__IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
 
@@ -452,6 +455,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 		goto out;
 	}
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 		goto inhdr_error;
 
@@ -488,6 +492,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 
 	len = ntohs(iph->tot_len);
 	if (skb->len < len) {
+		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
 	} else if (len < (iph->ihl*4))
@@ -516,11 +521,14 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	return skb;
 
 csum_error:
+	drop_reason = SKB_DROP_REASON_IP_CSUM;
 	__IP_INC_STATS(net, IPSTATS_MIB_CSUMERRORS);
 inhdr_error:
+	if (drop_reason == SKB_DROP_REASON_NOT_SPECIFIED)
+		drop_reason = SKB_DROP_REASON_IP_INHDR;
 	__IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 out:
 	return NULL;
 }
-- 
2.35.1



