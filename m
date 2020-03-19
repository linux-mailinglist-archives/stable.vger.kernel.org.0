Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD1118B6E0
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgCSNXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730366AbgCSNXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:23:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F1EB20724;
        Thu, 19 Mar 2020 13:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624221;
        bh=eXhIrVyJerNTUpPKVXh2U3p0Q0MPdGuQo3G1tSmSyoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oj5tQOHB8t7VWR+21QmajOI7xp8KsMpPd1p+KptCYQ9jajVEeHnXOvFyN/ZQZgmEx
         qWoQWpgsszkQz4kQ2x/eqjbFF70S4LJzMYFhud2vfS92m8lOhiVJQmH1AuslhtivK5
         i8LbUrjUkkySnMMCPjG8gEtOe5uKCLHOY+QZFnkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/60] net: rmnet: use upper/lower device infrastructure
Date:   Thu, 19 Mar 2020 14:04:25 +0100
Message-Id: <20200319123934.431619354@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 037f9cdf72fb8a7ff9ec2b5dd05336ec1492bdf1 ]

netdev_upper_dev_link() is useful to manage lower/upper interfaces.
And this function internally validates looping, maximum depth.
All or most virtual interfaces that could have a real interface
(e.g. macsec, macvlan, ipvlan etc.) use lower/upper infrastructure.

Test commands:
    modprobe rmnet
    ip link add dummy0 type dummy
    ip link add rmnet1 link dummy0 type rmnet mux_id 1
    for i in {2..100}
    do
        let A=$i-1
        ip link add rmnet$i link rmnet$A type rmnet mux_id $i
    done
    ip link del dummy0

The purpose of the test commands is to make stack overflow.

Splat looks like:
[   52.411438][ T1395] BUG: KASAN: slab-out-of-bounds in find_busiest_group+0x27e/0x2c00
[   52.413218][ T1395] Write of size 64 at addr ffff8880c774bde0 by task ip/1395
[   52.414841][ T1395]
[   52.430720][ T1395] CPU: 1 PID: 1395 Comm: ip Not tainted 5.6.0-rc1+ #447
[   52.496511][ T1395] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   52.513597][ T1395] Call Trace:
[   52.546516][ T1395]
[   52.558773][ T1395] Allocated by task 3171537984:
[   52.588290][ T1395] BUG: unable to handle page fault for address: ffffffffb999e260
[   52.589311][ T1395] #PF: supervisor read access in kernel mode
[   52.590529][ T1395] #PF: error_code(0x0000) - not-present page
[   52.591374][ T1395] PGD d6818067 P4D d6818067 PUD d6819063 PMD 0
[   52.592288][ T1395] Thread overran stack, or stack corrupted
[   52.604980][ T1395] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[   52.605856][ T1395] CPU: 1 PID: 1395 Comm: ip Not tainted 5.6.0-rc1+ #447
[   52.611764][ T1395] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   52.621520][ T1395] RIP: 0010:stack_depot_fetch+0x10/0x30
[   52.622296][ T1395] Code: ff e9 f9 fe ff ff 48 89 df e8 9c 1d 91 ff e9 ca fe ff ff cc cc cc cc cc cc cc 89 f8 0
[   52.627887][ T1395] RSP: 0018:ffff8880c774bb60 EFLAGS: 00010006
[   52.628735][ T1395] RAX: 00000000001f8880 RBX: ffff8880c774d140 RCX: 0000000000000000
[   52.631773][ T1395] RDX: 000000000000001d RSI: ffff8880c774bb68 RDI: 0000000000003ff0
[   52.649584][ T1395] RBP: ffffea00031dd200 R08: ffffed101b43e403 R09: ffffed101b43e403
[   52.674857][ T1395] R10: 0000000000000001 R11: ffffed101b43e402 R12: ffff8880d900e5c0
[   52.678257][ T1395] R13: ffff8880c774c000 R14: 0000000000000000 R15: dffffc0000000000
[   52.694541][ T1395] FS:  00007fe867f6e0c0(0000) GS:ffff8880da000000(0000) knlGS:0000000000000000
[   52.764039][ T1395] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   52.815008][ T1395] CR2: ffffffffb999e260 CR3: 00000000c26aa005 CR4: 00000000000606e0
[   52.862312][ T1395] Call Trace:
[   52.887133][ T1395] Modules linked in: dummy rmnet veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_dex
[   52.936749][ T1395] CR2: ffffffffb999e260
[   52.965695][ T1395] ---[ end trace 7e32ca99482dbb31 ]---
[   52.966556][ T1395] RIP: 0010:stack_depot_fetch+0x10/0x30
[   52.971083][ T1395] Code: ff e9 f9 fe ff ff 48 89 df e8 9c 1d 91 ff e9 ca fe ff ff cc cc cc cc cc cc cc 89 f8 0
[   53.003650][ T1395] RSP: 0018:ffff8880c774bb60 EFLAGS: 00010006
[   53.043183][ T1395] RAX: 00000000001f8880 RBX: ffff8880c774d140 RCX: 0000000000000000
[   53.076480][ T1395] RDX: 000000000000001d RSI: ffff8880c774bb68 RDI: 0000000000003ff0
[   53.093858][ T1395] RBP: ffffea00031dd200 R08: ffffed101b43e403 R09: ffffed101b43e403
[   53.112795][ T1395] R10: 0000000000000001 R11: ffffed101b43e402 R12: ffff8880d900e5c0
[   53.139837][ T1395] R13: ffff8880c774c000 R14: 0000000000000000 R15: dffffc0000000000
[   53.141500][ T1395] FS:  00007fe867f6e0c0(0000) GS:ffff8880da000000(0000) knlGS:0000000000000000
[   53.143343][ T1395] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   53.152007][ T1395] CR2: ffffffffb999e260 CR3: 00000000c26aa005 CR4: 00000000000606e0
[   53.156459][ T1395] Kernel panic - not syncing: Fatal exception
[   54.213570][ T1395] Shutting down cpus with NMI
[   54.354112][ T1395] Kernel Offset: 0x33000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0x)
[   54.355687][ T1395] Rebooting in 5 seconds..

Fixes: b37f78f234bf ("net: qualcomm: rmnet: Fix crash on real dev unregistration")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 35 +++++++++----------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 3c0e6d24d0834..e3fbf2331b965 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -61,9 +61,6 @@ static int rmnet_unregister_real_device(struct net_device *real_dev,
 
 	kfree(port);
 
-	/* release reference on real_dev */
-	dev_put(real_dev);
-
 	netdev_dbg(real_dev, "Removed from rmnet\n");
 	return 0;
 }
@@ -89,9 +86,6 @@ static int rmnet_register_real_device(struct net_device *real_dev)
 		return -EBUSY;
 	}
 
-	/* hold on to real dev for MAP data */
-	dev_hold(real_dev);
-
 	for (entry = 0; entry < RMNET_MAX_LOGICAL_EP; entry++)
 		INIT_HLIST_HEAD(&port->muxed_ep[entry]);
 
@@ -162,6 +156,10 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 	if (err)
 		goto err1;
 
+	err = netdev_upper_dev_link(real_dev, dev, extack);
+	if (err < 0)
+		goto err2;
+
 	port->rmnet_mode = mode;
 
 	hlist_add_head_rcu(&ep->hlnode, &port->muxed_ep[mux_id]);
@@ -178,6 +176,8 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 
 	return 0;
 
+err2:
+	unregister_netdevice(dev);
 err1:
 	rmnet_unregister_real_device(real_dev, port);
 err0:
@@ -209,33 +209,30 @@ static void rmnet_dellink(struct net_device *dev, struct list_head *head)
 		rmnet_vnd_dellink(mux_id, port, ep);
 		kfree(ep);
 	}
+	netdev_upper_dev_unlink(real_dev, dev);
 	rmnet_unregister_real_device(real_dev, port);
 
 	unregister_netdevice_queue(dev, head);
 }
 
-static void rmnet_force_unassociate_device(struct net_device *dev)
+static void rmnet_force_unassociate_device(struct net_device *real_dev)
 {
-	struct net_device *real_dev = dev;
 	struct hlist_node *tmp_ep;
 	struct rmnet_endpoint *ep;
 	struct rmnet_port *port;
 	unsigned long bkt_ep;
 	LIST_HEAD(list);
 
-	if (!rmnet_is_real_dev_registered(real_dev))
-		return;
-
 	ASSERT_RTNL();
 
-	port = rmnet_get_port_rtnl(dev);
+	port = rmnet_get_port_rtnl(real_dev);
 
-	rmnet_unregister_bridge(dev, port);
+	rmnet_unregister_bridge(real_dev, port);
 
 	hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
+		netdev_upper_dev_unlink(real_dev, ep->egress_dev);
 		unregister_netdevice_queue(ep->egress_dev, &list);
 		rmnet_vnd_dellink(ep->mux_id, port, ep);
-
 		hlist_del_init_rcu(&ep->hlnode);
 		kfree(ep);
 	}
@@ -248,15 +245,15 @@ static void rmnet_force_unassociate_device(struct net_device *dev)
 static int rmnet_config_notify_cb(struct notifier_block *nb,
 				  unsigned long event, void *data)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(data);
+	struct net_device *real_dev = netdev_notifier_info_to_dev(data);
 
-	if (!dev)
+	if (!rmnet_is_real_dev_registered(real_dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_UNREGISTER:
-		netdev_dbg(dev, "Kernel unregister\n");
-		rmnet_force_unassociate_device(dev);
+		netdev_dbg(real_dev, "Kernel unregister\n");
+		rmnet_force_unassociate_device(real_dev);
 		break;
 
 	default:
@@ -477,8 +474,8 @@ static int __init rmnet_init(void)
 
 static void __exit rmnet_exit(void)
 {
-	unregister_netdevice_notifier(&rmnet_dev_notifier);
 	rtnl_link_unregister(&rmnet_link_ops);
+	unregister_netdevice_notifier(&rmnet_dev_notifier);
 }
 
 module_init(rmnet_init)
-- 
2.20.1



