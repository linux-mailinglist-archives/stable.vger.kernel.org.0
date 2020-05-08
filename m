Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5CC1CAEC2
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgEHMr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbgEHMr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1752221F7;
        Fri,  8 May 2020 12:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942046;
        bh=YWuyGgbdAjxor5TtHYvnlQ5qaNPnByagaxDiHL2EUV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWrIY5yk76R+PjDe/M1p+jAYrIuXeF2a0Tt9eWCc89S3954/2zqq72v6YRjSzHNjC
         XGwMO71y7OEtbsj+qP87usK5pdJs3eutWXWA7J0zSpzpRrpvz48DUfGnSD01jXhqi7
         XiuCHjwBNz8bM3SERBTsvnGKzdI1GmFgah/E2yh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kodanev <alexey.kodanev@oracle.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.4 235/312] vti6: fix input path
Date:   Fri,  8 May 2020 14:33:46 +0200
Message-Id: <20200508123140.949604399@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 63c43787d35e45562a6b5927e2edc8f4783d95b8 upstream.

Since commit 1625f4529957, vti6 is broken, all input packets are dropped
(LINUX_MIB_XFRMINNOSTATES is incremented).

XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 is set by vti6_rcv() before calling
xfrm6_rcv()/xfrm6_rcv_spi(), thus we cannot set to NULL that value in
xfrm6_rcv_spi().

A new function xfrm6_rcv_tnl() that enables to pass a value to
xfrm6_rcv_spi() is added, so that xfrm6_rcv() is not touched (this function
is used in several handlers).

CC: Alexey Kodanev <alexey.kodanev@oracle.com>
Fixes: 1625f4529957 ("net/xfrm_input: fix possible NULL deref of tunnel.ip6->parms.i_key")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/xfrm.h      |    4 +++-
 net/ipv6/ip6_vti.c      |    4 +---
 net/ipv6/xfrm6_input.c  |   16 +++++++++++-----
 net/ipv6/xfrm6_tunnel.c |    2 +-
 4 files changed, 16 insertions(+), 10 deletions(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1551,8 +1551,10 @@ int xfrm4_tunnel_deregister(struct xfrm_
 void xfrm4_local_error(struct sk_buff *skb, u32 mtu);
 int xfrm6_extract_header(struct sk_buff *skb);
 int xfrm6_extract_input(struct xfrm_state *x, struct sk_buff *skb);
-int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi);
+int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi,
+		  struct ip6_tnl *t);
 int xfrm6_transport_finish(struct sk_buff *skb, int async);
+int xfrm6_rcv_tnl(struct sk_buff *skb, struct ip6_tnl *t);
 int xfrm6_rcv(struct sk_buff *skb);
 int xfrm6_input_addr(struct sk_buff *skb, xfrm_address_t *daddr,
 		     xfrm_address_t *saddr, u8 proto);
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -324,11 +324,9 @@ static int vti6_rcv(struct sk_buff *skb)
 			goto discard;
 		}
 
-		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = t;
-
 		rcu_read_unlock();
 
-		return xfrm6_rcv(skb);
+		return xfrm6_rcv_tnl(skb, t);
 	}
 	rcu_read_unlock();
 	return -EINVAL;
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -21,9 +21,10 @@ int xfrm6_extract_input(struct xfrm_stat
 	return xfrm6_extract_header(skb);
 }
 
-int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi)
+int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi,
+		  struct ip6_tnl *t)
 {
-	XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = NULL;
+	XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = t;
 	XFRM_SPI_SKB_CB(skb)->family = AF_INET6;
 	XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct ipv6hdr, daddr);
 	return xfrm_input(skb, nexthdr, spi, 0);
@@ -49,13 +50,18 @@ int xfrm6_transport_finish(struct sk_buf
 	return -1;
 }
 
-int xfrm6_rcv(struct sk_buff *skb)
+int xfrm6_rcv_tnl(struct sk_buff *skb, struct ip6_tnl *t)
 {
 	return xfrm6_rcv_spi(skb, skb_network_header(skb)[IP6CB(skb)->nhoff],
-			     0);
+			     0, t);
 }
-EXPORT_SYMBOL(xfrm6_rcv);
+EXPORT_SYMBOL(xfrm6_rcv_tnl);
 
+int xfrm6_rcv(struct sk_buff *skb)
+{
+	return xfrm6_rcv_tnl(skb, NULL);
+}
+EXPORT_SYMBOL(xfrm6_rcv);
 int xfrm6_input_addr(struct sk_buff *skb, xfrm_address_t *daddr,
 		     xfrm_address_t *saddr, u8 proto)
 {
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -239,7 +239,7 @@ static int xfrm6_tunnel_rcv(struct sk_bu
 	__be32 spi;
 
 	spi = xfrm6_tunnel_spi_lookup(net, (const xfrm_address_t *)&iph->saddr);
-	return xfrm6_rcv_spi(skb, IPPROTO_IPV6, spi);
+	return xfrm6_rcv_spi(skb, IPPROTO_IPV6, spi, NULL);
 }
 
 static int xfrm6_tunnel_err(struct sk_buff *skb, struct inet6_skb_parm *opt,


