Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4691134D589
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 18:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhC2Qvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 12:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231283AbhC2QvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 12:51:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DADB6196C;
        Mon, 29 Mar 2021 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617036672;
        bh=nMSVlj2k1mdEiLNGbb4nBJsLuXWzn7ocVbiKQ6qSegg=;
        h=From:To:Cc:Subject:Date:From;
        b=qqBs0kfS89HGgbBDVPn8EFmd1eTElcwFNzdRFdLeAXtkbWGr4ixBBbi/LGuyYEaC/
         nBCmu9/hTgbIdV6l8s/8Yn6zzAWYejcrETRwdY1113ZFuNheB/mf6gNHLzfGGlU+WK
         soxnxnU9C9KEfkKp8vEwaxTlu0JKBJk/3NnNHr8DAvAaBGk0hj5QRXWUIvznzTX6HM
         MTXh+WYcbPESTmfIr9FHZ6fgSLkzV8jrfdwGp/Cknr7ecLO5R78oYmLDSCw3rniir3
         A0wypz8ZoCANRunh47pcnSw5ej5loxZqBmoxiXQbMMDVfp6LkmcrpqP3jTo2TsZHNt
         MS6nFIhNstZ/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, kuba@kernel.org
Cc:     Sunyi Shao <sunyishao@fb.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: FAILED: Patch "ipv6: weaken the v4mapped source check" failed to apply to 4.9-stable tree
Date:   Mon, 29 Mar 2021 12:51:10 -0400
Message-Id: <20210329165110.2359475-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From dcc32f4f183ab8479041b23a1525d48233df1d43 Mon Sep 17 00:00:00 2001
From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 17 Mar 2021 09:55:15 -0700
Subject: [PATCH] ipv6: weaken the v4mapped source check

This reverts commit 6af1799aaf3f1bc8defedddfa00df3192445bbf3.

Commit 6af1799aaf3f ("ipv6: drop incoming packets having a v4mapped
source address") introduced an input check against v4mapped addresses.
Use of such addresses on the wire is indeed questionable and not
allowed on public Internet. As the commit pointed out

  https://tools.ietf.org/html/draft-itojun-v6ops-v4mapped-harmful-02

lists potential issues.

Unfortunately there are applications which use v4mapped addresses,
and breaking them is a clear regression. For example v4mapped
addresses (or any semi-valid addresses, really) may be used
for uni-direction event streams or packet export.

Since the issue which sparked the addition of the check was with
TCP and request_socks in particular push the check down to TCPv6
and DCCP. This restores the ability to receive UDPv6 packets with
v4mapped address as the source.

Keep using the IPSTATS_MIB_INHDRERRORS statistic to minimize the
user-visible changes.

Fixes: 6af1799aaf3f ("ipv6: drop incoming packets having a v4mapped source address")
Reported-by: Sunyi Shao <sunyishao@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/dccp/ipv6.c      |  5 +++++
 net/ipv6/ip6_input.c | 10 ----------
 net/ipv6/tcp_ipv6.c  |  5 +++++
 net/mptcp/subflow.c  |  5 +++++
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 1f73603913f5..2be5c69824f9 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -319,6 +319,11 @@ static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (!ipv6_unicast_destination(skb))
 		return 0;	/* discard, don't send a reset here */
 
+	if (ipv6_addr_v4mapped(&ipv6_hdr(skb)->saddr)) {
+		__IP6_INC_STATS(sock_net(sk), NULL, IPSTATS_MIB_INHDRERRORS);
+		return 0;
+	}
+
 	if (dccp_bad_service_code(sk, service)) {
 		dcb->dccpd_reset_code = DCCP_RESET_CODE_BAD_SERVICE_CODE;
 		goto drop;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index e9d2a4a409aa..80256717868e 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -245,16 +245,6 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	if (ipv6_addr_is_multicast(&hdr->saddr))
 		goto err;
 
-	/* While RFC4291 is not explicit about v4mapped addresses
-	 * in IPv6 headers, it seems clear linux dual-stack
-	 * model can not deal properly with these.
-	 * Security models could be fooled by ::ffff:127.0.0.1 for example.
-	 *
-	 * https://tools.ietf.org/html/draft-itojun-v6ops-v4mapped-harmful-02
-	 */
-	if (ipv6_addr_v4mapped(&hdr->saddr))
-		goto err;
-
 	skb->transport_header = skb->network_header + sizeof(*hdr);
 	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index bd44ded7e50c..d0f007741e8e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1175,6 +1175,11 @@ static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (!ipv6_unicast_destination(skb))
 		goto drop;
 
+	if (ipv6_addr_v4mapped(&ipv6_hdr(skb)->saddr)) {
+		__IP6_INC_STATS(sock_net(sk), NULL, IPSTATS_MIB_INHDRERRORS);
+		return 0;
+	}
+
 	return tcp_conn_request(&tcp6_request_sock_ops,
 				&tcp_request_sock_ipv6_ops, sk, skb);
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3d47d670e665..d17d39ccdf34 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -477,6 +477,11 @@ static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (!ipv6_unicast_destination(skb))
 		goto drop;
 
+	if (ipv6_addr_v4mapped(&ipv6_hdr(skb)->saddr)) {
+		__IP6_INC_STATS(sock_net(sk), NULL, IPSTATS_MIB_INHDRERRORS);
+		return 0;
+	}
+
 	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
 				&subflow_request_sock_ipv6_ops, sk, skb);
 
-- 
2.30.1




