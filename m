Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1FC353CD6
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhDEI47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233010AbhDEI47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A1D613D2;
        Mon,  5 Apr 2021 08:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613013;
        bh=hbNJqbz408KrIDvWGUExHiXXFNjykgM4phePrpIcMEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLNiFxZIicF0O+ZUBfepTIJv8T5UnTE9wmGgVuf+n6aAj3egbObojMh09HPrIMnrC
         nqQCvG3j0jZurMRRzW+Zf+6JtjeR+g3okVcAIV/wm+Z/99Xit9HdikpMIzq4ASxDpJ
         aQctoPCJlGJ6yU1Tr876DD4Hk0VNa1Xy+TkklahA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunyi Shao <sunyishao@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/35] ipv6: weaken the v4mapped source check
Date:   Mon,  5 Apr 2021 10:53:37 +0200
Message-Id: <20210405085018.949645642@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit dcc32f4f183ab8479041b23a1525d48233df1d43 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dccp/ipv6.c      |  5 +++++
 net/ipv6/ip6_input.c | 10 ----------
 net/ipv6/tcp_ipv6.c  |  5 +++++
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 9438873fc3c8..ae62c2947278 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -317,6 +317,11 @@ static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
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
index e726a61ae6dc..aacfb4bce153 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -168,16 +168,6 @@ int ipv6_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt
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
index 7b336b7803ff..dfddf2bfa7e1 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -986,6 +986,11 @@ static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (!ipv6_unicast_destination(skb))
 		goto drop;
 
+	if (ipv6_addr_v4mapped(&ipv6_hdr(skb)->saddr)) {
+		__IP6_INC_STATS(sock_net(sk), NULL, IPSTATS_MIB_INHDRERRORS);
+		return 0;
+	}
+
 	return tcp_conn_request(&tcp6_request_sock_ops,
 				&tcp_request_sock_ipv6_ops, sk, skb);
 
-- 
2.30.1



