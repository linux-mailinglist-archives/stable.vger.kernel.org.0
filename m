Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5B3F7E42
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbfKKSsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730209AbfKKSsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6E2A204FD;
        Mon, 11 Nov 2019 18:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498083;
        bh=Ex4oHg5nWgxmc4RUKJq2fBVsydM59UKF3JY2twpNiB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLAcbrfLrnuOhvLFXAMWJOwx4kiKKeNjO0SJi6lOVjN3/YDTxtQj9G1pW3KlVV/Fo
         TAvnng4hTJsTRPnxLE8VOLZjg0ypOmPwccTzsDXw6AXkkQ5pWGkIVmrqPF3vHReI45
         uDJppqaPb9BFJHAvYfo9kDEw6DjLGXelKZZ/JuKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 018/193] ipv6: fixes rt6_probe() and fib6_nh->last_probe init
Date:   Mon, 11 Nov 2019 19:26:40 +0100
Message-Id: <20191111181501.498935425@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1bef4c223b8588cf50433bdc2c6953d82949b3b3 ]

While looking at a syzbot KCSAN report [1], I found multiple
issues in this code :

1) fib6_nh->last_probe has an initial value of 0.

   While probably okay on 64bit kernels, this causes an issue
   on 32bit kernels since the time_after(jiffies, 0 + interval)
   might be false ~24 days after boot (for HZ=1000)

2) The data-race found by KCSAN
   I could use READ_ONCE() and WRITE_ONCE(), but we also can
   take the opportunity of not piling-up too many rt6_probe_deferred()
   works by using instead cmpxchg() so that only one cpu wins the race.

[1]
BUG: KCSAN: data-race in find_match / find_match

write to 0xffff8880bb7aabe8 of 8 bytes by interrupt on cpu 1:
 rt6_probe net/ipv6/route.c:663 [inline]
 find_match net/ipv6/route.c:757 [inline]
 find_match+0x5bd/0x790 net/ipv6/route.c:733
 __find_rr_leaf+0xe3/0x780 net/ipv6/route.c:831
 find_rr_leaf net/ipv6/route.c:852 [inline]
 rt6_select net/ipv6/route.c:896 [inline]
 fib6_table_lookup+0x383/0x650 net/ipv6/route.c:2164
 ip6_pol_route+0xee/0x5c0 net/ipv6/route.c:2200
 ip6_pol_route_output+0x48/0x60 net/ipv6/route.c:2452
 fib6_rule_lookup+0x3d6/0x470 net/ipv6/fib6_rules.c:117
 ip6_route_output_flags_noref+0x16b/0x230 net/ipv6/route.c:2484
 ip6_route_output_flags+0x50/0x1a0 net/ipv6/route.c:2497
 ip6_dst_lookup_tail+0x25d/0xc30 net/ipv6/ip6_output.c:1049
 ip6_dst_lookup_flow+0x68/0x120 net/ipv6/ip6_output.c:1150
 inet6_csk_route_socket+0x2f7/0x420 net/ipv6/inet6_connection_sock.c:106
 inet6_csk_xmit+0x91/0x1f0 net/ipv6/inet6_connection_sock.c:121
 __tcp_transmit_skb+0xe81/0x1d60 net/ipv4/tcp_output.c:1169
 tcp_transmit_skb net/ipv4/tcp_output.c:1185 [inline]
 tcp_xmit_probe_skb+0x19b/0x1d0 net/ipv4/tcp_output.c:3735

read to 0xffff8880bb7aabe8 of 8 bytes by interrupt on cpu 0:
 rt6_probe net/ipv6/route.c:657 [inline]
 find_match net/ipv6/route.c:757 [inline]
 find_match+0x521/0x790 net/ipv6/route.c:733
 __find_rr_leaf+0xe3/0x780 net/ipv6/route.c:831
 find_rr_leaf net/ipv6/route.c:852 [inline]
 rt6_select net/ipv6/route.c:896 [inline]
 fib6_table_lookup+0x383/0x650 net/ipv6/route.c:2164
 ip6_pol_route+0xee/0x5c0 net/ipv6/route.c:2200
 ip6_pol_route_output+0x48/0x60 net/ipv6/route.c:2452
 fib6_rule_lookup+0x3d6/0x470 net/ipv6/fib6_rules.c:117
 ip6_route_output_flags_noref+0x16b/0x230 net/ipv6/route.c:2484
 ip6_route_output_flags+0x50/0x1a0 net/ipv6/route.c:2497
 ip6_dst_lookup_tail+0x25d/0xc30 net/ipv6/ip6_output.c:1049
 ip6_dst_lookup_flow+0x68/0x120 net/ipv6/ip6_output.c:1150
 inet6_csk_route_socket+0x2f7/0x420 net/ipv6/inet6_connection_sock.c:106
 inet6_csk_xmit+0x91/0x1f0 net/ipv6/inet6_connection_sock.c:121
 __tcp_transmit_skb+0xe81/0x1d60 net/ipv4/tcp_output.c:1169

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 18894 Comm: udevd Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: cc3a86c802f0 ("ipv6: Change rt6_probe to take a fib6_nh")
Fixes: f547fac624be ("ipv6: rate-limit probes for neighbourless routes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -621,6 +621,7 @@ static void rt6_probe(struct fib6_nh *fi
 {
 	struct __rt6_probe_work *work = NULL;
 	const struct in6_addr *nh_gw;
+	unsigned long last_probe;
 	struct neighbour *neigh;
 	struct net_device *dev;
 	struct inet6_dev *idev;
@@ -639,6 +640,7 @@ static void rt6_probe(struct fib6_nh *fi
 	nh_gw = &fib6_nh->fib_nh_gw6;
 	dev = fib6_nh->fib_nh_dev;
 	rcu_read_lock_bh();
+	last_probe = READ_ONCE(fib6_nh->last_probe);
 	idev = __in6_dev_get(dev);
 	neigh = __ipv6_neigh_lookup_noref(dev, nh_gw);
 	if (neigh) {
@@ -654,13 +656,15 @@ static void rt6_probe(struct fib6_nh *fi
 				__neigh_set_probe_once(neigh);
 		}
 		write_unlock(&neigh->lock);
-	} else if (time_after(jiffies, fib6_nh->last_probe +
+	} else if (time_after(jiffies, last_probe +
 				       idev->cnf.rtr_probe_interval)) {
 		work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	}
 
-	if (work) {
-		fib6_nh->last_probe = jiffies;
+	if (!work || cmpxchg(&fib6_nh->last_probe,
+			     last_probe, jiffies) != last_probe) {
+		kfree(work);
+	} else {
 		INIT_WORK(&work->work, rt6_probe_deferred);
 		work->target = *nh_gw;
 		dev_hold(dev);
@@ -3385,6 +3389,9 @@ int fib6_nh_init(struct net *net, struct
 	int err;
 
 	fib6_nh->fib_nh_family = AF_INET6;
+#ifdef CONFIG_IPV6_ROUTER_PREF
+	fib6_nh->last_probe = jiffies;
+#endif
 
 	err = -ENODEV;
 	if (cfg->fc_ifindex) {


