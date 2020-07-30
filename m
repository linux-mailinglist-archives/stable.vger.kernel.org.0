Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D41A232E4A
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbgG3IIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbgG3IIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:08:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 878392083B;
        Thu, 30 Jul 2020 08:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096490;
        bh=P8LzsDBqZ3Fx8Hlz6wYr3MAHfWr7DplBUg0vGJCGgrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfYZnT8SB4zmlEKECixq50uPhTm6SIaFhr1fgdlXpaJrVy11NokCLQr7CFr6/NK3k
         EJ8vw2FdGk7eZUH48V9hGvnYottZnhAJxLZpotRLgIuqHiFyIq68ey4CGofxpLodj3
         56Kca16pN70B76WED3ygFyzwKfXtXY440iZqxAic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 09/14] ip6_gre: fix null-ptr-deref in ip6gre_init_net()
Date:   Thu, 30 Jul 2020 10:04:52 +0200
Message-Id: <20200730074419.359661406@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074418.882736401@linuxfoundation.org>
References: <20200730074418.882736401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 46ef5b89ec0ecf290d74c4aee844f063933c4da4 ]

KASAN report null-ptr-deref error when register_netdev() failed:

KASAN: null-ptr-deref in range [0x00000000000003c0-0x00000000000003c7]
CPU: 2 PID: 422 Comm: ip Not tainted 5.8.0-rc4+ #12
Call Trace:
 ip6gre_init_net+0x4ab/0x580
 ? ip6gre_tunnel_uninit+0x3f0/0x3f0
 ops_init+0xa8/0x3c0
 setup_net+0x2de/0x7e0
 ? rcu_read_lock_bh_held+0xb0/0xb0
 ? ops_init+0x3c0/0x3c0
 ? kasan_unpoison_shadow+0x33/0x40
 ? __kasan_kmalloc.constprop.0+0xc2/0xd0
 copy_net_ns+0x27d/0x530
 create_new_namespaces+0x382/0xa30
 unshare_nsproxy_namespaces+0xa1/0x1d0
 ksys_unshare+0x39c/0x780
 ? walk_process_tree+0x2a0/0x2a0
 ? trace_hardirqs_on+0x4a/0x1b0
 ? _raw_spin_unlock_irq+0x1f/0x30
 ? syscall_trace_enter+0x1a7/0x330
 ? do_syscall_64+0x1c/0xa0
 __x64_sys_unshare+0x2d/0x40
 do_syscall_64+0x56/0xa0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

ip6gre_tunnel_uninit() has set 'ign->fb_tunnel_dev' to NULL, later
access to ign->fb_tunnel_dev cause null-ptr-deref. Fix it by saving
'ign->fb_tunnel_dev' to local variable ndev.

Fixes: dafabb6590cb ("ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1169,15 +1169,16 @@ static void ip6gre_destroy_tunnels(struc
 static int __net_init ip6gre_init_net(struct net *net)
 {
 	struct ip6gre_net *ign = net_generic(net, ip6gre_net_id);
+	struct net_device *ndev;
 	int err;
 
-	ign->fb_tunnel_dev = alloc_netdev(sizeof(struct ip6_tnl), "ip6gre0",
-					  NET_NAME_UNKNOWN,
-					  ip6gre_tunnel_setup);
-	if (!ign->fb_tunnel_dev) {
+	ndev = alloc_netdev(sizeof(struct ip6_tnl), "ip6gre0",
+			    NET_NAME_UNKNOWN, ip6gre_tunnel_setup);
+	if (!ndev) {
 		err = -ENOMEM;
 		goto err_alloc_dev;
 	}
+	ign->fb_tunnel_dev = ndev;
 	dev_net_set(ign->fb_tunnel_dev, net);
 	/* FB netdevice is special: we have one, and only one per netns.
 	 * Allowing to move it to another netns is clearly unsafe.
@@ -1197,7 +1198,7 @@ static int __net_init ip6gre_init_net(st
 	return 0;
 
 err_reg_dev:
-	free_netdev(ign->fb_tunnel_dev);
+	free_netdev(ndev);
 err_alloc_dev:
 	return err;
 }


