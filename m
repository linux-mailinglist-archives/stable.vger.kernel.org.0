Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5178A34C8BD
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhC2IYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232909AbhC2IXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:23:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E316261477;
        Mon, 29 Mar 2021 08:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006184;
        bh=g+jsseJwNdizWE4QazAwZbQq0f5xaKk6P45tPD1EX+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdNwqmvgJIG9b0HVo1QQ+/AsgdTgBX2hghISN6DSr5Q4agrscFwxgojfgzIqD/4r9
         HiqEwnaYtDr2KRt4yu/K6w/9w/sSTy/jqBQDDMJFfUdLpJlNL9FcsCaTtzL//nKJcw
         3bd98duqyOoMbZp5d8e4POXSxPSF8tae4/aqtVmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunyi Shao <sunyishao@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/221] ipv6: weaken the v4mapped source check
Date:   Mon, 29 Mar 2021 09:58:00 +0200
Message-Id: <20210329075634.138636069@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
 net/mptcp/subflow.c  |  5 +++++
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 78ee1b5acf1f..49f4034bf126 100644
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
index e96304d8a4a7..06d60662717d 100644
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
index 991dc36f95ff..3f9bb6dd1f98 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1170,6 +1170,11 @@ static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
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
index 16adba172fb9..6317b9bc8681 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -398,6 +398,11 @@ static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
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



