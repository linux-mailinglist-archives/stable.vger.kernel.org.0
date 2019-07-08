Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89DE362201
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387530AbfGHPVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387516AbfGHPVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:21:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A95A22171F;
        Mon,  8 Jul 2019 15:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599281;
        bh=nifUm/JXR3cyL28TKqQxvKrN3mKnp2p+nSmRs25XYtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YB8fYPFthMLAJZx8Zt+Xn3S1LPu2Nk1aCzQGUw126ROw/U+itBBgPPdeSgD3XbVjk
         pT7AUey7EfkDxPEeB2cqay2VQGSbtpkAF4uXp5/U4tPVvAlnHcaI0vfrSG7+adokae
         MbFQ/IlD5t+4dOM1W27UKhJOW3tfLYwaQ+OB8GL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9d4c12bfd45a58738d0a@syzkaller.appspotmail.com,
        syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com,
        syzbot+c4c4b2bb358bb936ad7e@syzkaller.appspotmail.com,
        syzbot+0290d2290a607e035ba1@syzkaller.appspotmail.com,
        syzbot+a43d8d4e7e8a7a9e149e@syzkaller.appspotmail.com,
        syzbot+a47c5f4c6c00fc1ed16e@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 064/102] tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb
Date:   Mon,  8 Jul 2019 17:12:57 +0200
Message-Id: <20190708150529.767536852@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit c3bcde026684c62d7a2b6f626dc7cf763833875c upstream.

udp_tunnel(6)_xmit_skb() called by tipc_udp_xmit() expects a tunnel device
to count packets on dev->tstats, a perpcu variable. However, TIPC is using
udp tunnel with no tunnel device, and pass the lower dev, like veth device
that only initializes dev->lstats(a perpcu variable) when creating it.

Later iptunnel_xmit_stats() called by ip(6)tunnel_xmit() thinks the dev as
a tunnel device, and uses dev->tstats instead of dev->lstats. tstats' each
pointer points to a bigger struct than lstats, so when tstats->tx_bytes is
increased, other percpu variable's members could be overwritten.

syzbot has reported quite a few crashes due to fib_nh_common percpu member
'nhc_pcpu_rth_output' overwritten, call traces are like:

  BUG: KASAN: slab-out-of-bounds in rt_cache_valid+0x158/0x190
  net/ipv4/route.c:1556
    rt_cache_valid+0x158/0x190 net/ipv4/route.c:1556
    __mkroute_output net/ipv4/route.c:2332 [inline]
    ip_route_output_key_hash_rcu+0x819/0x2d50 net/ipv4/route.c:2564
    ip_route_output_key_hash+0x1ef/0x360 net/ipv4/route.c:2393
    __ip_route_output_key include/net/route.h:125 [inline]
    ip_route_output_flow+0x28/0xc0 net/ipv4/route.c:2651
    ip_route_output_key include/net/route.h:135 [inline]
  ...

or:

  kasan: GPF could be caused by NULL-ptr deref or user memory access
  RIP: 0010:dst_dev_put+0x24/0x290 net/core/dst.c:168
    <IRQ>
    rt_fibinfo_free_cpus net/ipv4/fib_semantics.c:200 [inline]
    free_fib_info_rcu+0x2e1/0x490 net/ipv4/fib_semantics.c:217
    __rcu_reclaim kernel/rcu/rcu.h:240 [inline]
    rcu_do_batch kernel/rcu/tree.c:2437 [inline]
    invoke_rcu_callbacks kernel/rcu/tree.c:2716 [inline]
    rcu_process_callbacks+0x100a/0x1ac0 kernel/rcu/tree.c:2697
  ...

The issue exists since tunnel stats update is moved to iptunnel_xmit by
Commit 039f50629b7f ("ip_tunnel: Move stats update to iptunnel_xmit()"),
and here to fix it by passing a NULL tunnel dev to udp_tunnel(6)_xmit_skb
so that the packets counting won't happen on dev->tstats.

Reported-by: syzbot+9d4c12bfd45a58738d0a@syzkaller.appspotmail.com
Reported-by: syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com
Reported-by: syzbot+c4c4b2bb358bb936ad7e@syzkaller.appspotmail.com
Reported-by: syzbot+0290d2290a607e035ba1@syzkaller.appspotmail.com
Reported-by: syzbot+a43d8d4e7e8a7a9e149e@syzkaller.appspotmail.com
Reported-by: syzbot+a47c5f4c6c00fc1ed16e@syzkaller.appspotmail.com
Fixes: 039f50629b7f ("ip_tunnel: Move stats update to iptunnel_xmit()")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/udp_media.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -174,7 +174,6 @@ static int tipc_udp_xmit(struct net *net
 			goto tx_error;
 		}
 
-		skb->dev = rt->dst.dev;
 		ttl = ip4_dst_hoplimit(&rt->dst);
 		udp_tunnel_xmit_skb(rt, ub->ubsock->sk, skb, src->ipv4.s_addr,
 				    dst->ipv4.s_addr, 0, ttl, 0, src->port,
@@ -193,10 +192,9 @@ static int tipc_udp_xmit(struct net *net
 		if (err)
 			goto tx_error;
 		ttl = ip6_dst_hoplimit(ndst);
-		err = udp_tunnel6_xmit_skb(ndst, ub->ubsock->sk, skb,
-					   ndst->dev, &src->ipv6,
-					   &dst->ipv6, 0, ttl, 0, src->port,
-					   dst->port, false);
+		err = udp_tunnel6_xmit_skb(ndst, ub->ubsock->sk, skb, NULL,
+					   &src->ipv6, &dst->ipv6, 0, ttl, 0,
+					   src->port, dst->port, false);
 #endif
 	}
 	return err;


