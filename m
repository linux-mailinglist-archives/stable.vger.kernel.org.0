Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4068138A1DA
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhETJfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232445AbhETJdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:33:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3991613F9;
        Thu, 20 May 2021 09:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502938;
        bh=8xMgb47kKdyhTkekxZ0R1r3HhfPW+PyNnzFz9iXQp2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZ5/PWRAIiCVKIAXlYNgpns2UFwVilRJ8z3+BurgKvNcnPQB1ccuSbn9PA9EixecG
         gxsKlhmkkgW2AUraEtIhrbSXSKaHO4aUX+D9QOHIwYoqyA2pz5LuBLDirTlwOu2gK7
         FuN/xwX89cg0F/IRkJF5tb3nxP95q9FlyXPpg4O4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 34/37] ipv6: remove extra dev_hold() for fallback tunnels
Date:   Thu, 20 May 2021 11:22:55 +0200
Message-Id: <20210520092053.397626559@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 0d7a7b2014b1a499a0fe24c9f3063d7856b5aaaf upstream.

My previous commits added a dev_hold() in tunnels ndo_init(),
but forgot to remove it from special functions setting up fallback tunnels.

Fallback tunnels do call their respective ndo_init()

This leads to various reports like :

unregister_netdevice: waiting for ip6gre0 to become free. Usage count = 2

Fixes: 48bb5697269a ("ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods")
Fixes: 6289a98f0817 ("sit: proper dev_{hold|put} in ndo_[un]init methods")
Fixes: 40cb881b5aaa ("ip6_vti: proper dev_{hold|put} in ndo_[un]init methods")
Fixes: 7f700334be9a ("ip6_gre: proper dev_{hold|put} in ndo_[un]init methods")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c    |    3 ---
 net/ipv6/ip6_tunnel.c |    1 -
 net/ipv6/ip6_vti.c    |    1 -
 net/ipv6/sit.c        |    1 -
 4 files changed, 6 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -387,7 +387,6 @@ static struct ip6_tnl *ip6gre_tunnel_loc
 	if (!(nt->parms.o_flags & TUNNEL_SEQ))
 		dev->features |= NETIF_F_LLTX;
 
-	dev_hold(dev);
 	ip6gre_tunnel_link(ign, nt);
 	return nt;
 
@@ -1526,8 +1525,6 @@ static void ip6gre_fb_tunnel_init(struct
 	strcpy(tunnel->parms.name, dev->name);
 
 	tunnel->hlen		= sizeof(struct ipv6hdr) + 4;
-
-	dev_hold(dev);
 }
 
 static struct inet6_protocol ip6gre_protocol __read_mostly = {
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1904,7 +1904,6 @@ static int __net_init ip6_fb_tnl_dev_ini
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 
 	t->parms.proto = IPPROTO_IPV6;
-	dev_hold(dev);
 
 	rcu_assign_pointer(ip6n->tnls_wc[0], t);
 	return 0;
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -952,7 +952,6 @@ static int __net_init vti6_fb_tnl_dev_in
 	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
 
 	t->parms.proto = IPPROTO_IPV6;
-	dev_hold(dev);
 
 	rcu_assign_pointer(ip6n->tnls_wc[0], t);
 	return 0;
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1422,7 +1422,6 @@ static void __net_init ipip6_fb_tunnel_i
 	iph->ihl		= 5;
 	iph->ttl		= 64;
 
-	dev_hold(dev);
 	rcu_assign_pointer(sitn->tunnels_wc[0], tunnel);
 }
 


