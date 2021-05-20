Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F7F38A7FB
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbhETKpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236113AbhETKn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:43:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 905DB61429;
        Thu, 20 May 2021 09:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504607;
        bh=BFRnI6vzCgVT3DYw8YAxwW+Dxt1m4o+N2XErRg2k3l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+MwwIT6nE8Vf+cjroFZVviIYe2u0vqu1k44XvqnRUworAsas8a1yIZ7uJ43CGPY0
         gj+jVjmxOdJyPcoW7n/9u8IXBrmONOSHzpWeMEoAZ4SHQI/QGhcGjVxKv7Cbxl9i8M
         bk7NJIzvD15X5gUj7zt13qR2VooPp+E/ZrtVhNh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 323/323] ipv6: remove extra dev_hold() for fallback tunnels
Date:   Thu, 20 May 2021 11:23:35 +0200
Message-Id: <20210520092131.317480667@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
@@ -350,7 +350,6 @@ static struct ip6_tnl *ip6gre_tunnel_loc
 	if (!(nt->parms.o_flags & TUNNEL_SEQ))
 		dev->features |= NETIF_F_LLTX;
 
-	dev_hold(dev);
 	ip6gre_tunnel_link(ign, nt);
 	return nt;
 
@@ -1124,8 +1123,6 @@ static void ip6gre_fb_tunnel_init(struct
 	strcpy(tunnel->parms.name, dev->name);
 
 	tunnel->hlen		= sizeof(struct ipv6hdr) + 4;
-
-	dev_hold(dev);
 }
 
 
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1905,7 +1905,6 @@ static int __net_init ip6_fb_tnl_dev_ini
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 
 	t->parms.proto = IPPROTO_IPV6;
-	dev_hold(dev);
 
 	rcu_assign_pointer(ip6n->tnls_wc[0], t);
 	return 0;
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -934,7 +934,6 @@ static int __net_init vti6_fb_tnl_dev_in
 	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
 
 	t->parms.proto = IPPROTO_IPV6;
-	dev_hold(dev);
 
 	rcu_assign_pointer(ip6n->tnls_wc[0], t);
 	return 0;
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1407,7 +1407,6 @@ static void __net_init ipip6_fb_tunnel_i
 	iph->ihl		= 5;
 	iph->ttl		= 64;
 
-	dev_hold(dev);
 	rcu_assign_pointer(sitn->tunnels_wc[0], tunnel);
 }
 


