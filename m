Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC48921721D
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgGGP3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730209AbgGGPZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:25:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2336D2078D;
        Tue,  7 Jul 2020 15:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135522;
        bh=mSyYat7azZr9ywhMMhHRg/NZhnE/y61z4XHgTjr6SZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jg55alm4NH/oiSUMtXJBmHDAuUQZzWj3tjn5HCluGh4KgnvhyhJYjHxlah9l6u2CC
         hkrZcN3vHwrZL+d49ZCesU/fu+HYmRnoMEKknaN4PkWRCWg/lYub+t3KaOvubf//MU
         +zYyCni1VVg0jtsaFWhETaFxWD3TE5zYa2ZalkBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1d51c8b74efa4c44adeb@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 057/112] hsr: avoid to create proc file after unregister
Date:   Tue,  7 Jul 2020 17:17:02 +0200
Message-Id: <20200707145803.713303833@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit de0083c7ed7dba036d1ed6e012157649d45313c8 ]

When an interface is being deleted, "/proc/net/dev_snmp6/<interface name>"
is deleted.
The function for this is addrconf_ifdown() in the addrconf_notify() and
it is called by notification, which is NETDEV_UNREGISTER.
But, if NETDEV_CHANGEMTU is triggered after NETDEV_UNREGISTER,
this proc file will be created again.
This recreated proc file will be deleted by netdev_wati_allrefs().
Before netdev_wait_allrefs() is called, creating a new HSR interface
routine can be executed and It tries to create a proc file but it will
find an un-deleted proc file.
At this point, it warns about it.

To avoid this situation, it can use ->dellink() instead of
->ndo_uninit() to release resources because ->dellink() is called
before NETDEV_UNREGISTER.
So, a proc file will not be recreated.

Test commands
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link set dummy0 mtu 1300

    #SHELL1
    while :
    do
        ip link add hsr0 type hsr slave1 dummy0 slave2 dummy1
    done

    #SHELL2
    while :
    do
        ip link del hsr0
    done

Splat looks like:
[ 9888.980852][ T2752] proc_dir_entry 'dev_snmp6/hsr0' already registered
[ 9888.981797][    C2] WARNING: CPU: 2 PID: 2752 at fs/proc/generic.c:372 proc_register+0x2d5/0x430
[ 9888.981798][    C2] Modules linked in: hsr dummy veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6x
[ 9888.981814][    C2] CPU: 2 PID: 2752 Comm: ip Tainted: G        W         5.8.0-rc1+ #616
[ 9888.981815][    C2] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[ 9888.981816][    C2] RIP: 0010:proc_register+0x2d5/0x430
[ 9888.981818][    C2] Code: fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 65 01 00 00 49 8b b5 e0 00 00 00 48 89 ea 40
[ 9888.981819][    C2] RSP: 0018:ffff8880628dedf0 EFLAGS: 00010286
[ 9888.981821][    C2] RAX: dffffc0000000008 RBX: ffff888028c69170 RCX: ffffffffaae09a62
[ 9888.981822][    C2] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff88806c9f75ac
[ 9888.981823][    C2] RBP: ffff888028c693f4 R08: ffffed100d9401bd R09: ffffed100d9401bd
[ 9888.981824][    C2] R10: ffffffffaddf406f R11: 0000000000000001 R12: ffff888028c69308
[ 9888.981825][    C2] R13: ffff8880663584c8 R14: dffffc0000000000 R15: ffffed100518d27e
[ 9888.981827][    C2] FS:  00007f3876b3b0c0(0000) GS:ffff88806c800000(0000) knlGS:0000000000000000
[ 9888.981828][    C2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9888.981829][    C2] CR2: 00007f387601a8c0 CR3: 000000004101a002 CR4: 00000000000606e0
[ 9888.981830][    C2] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9888.981831][    C2] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 9888.981832][    C2] Call Trace:
[ 9888.981833][    C2]  ? snmp6_seq_show+0x180/0x180
[ 9888.981834][    C2]  proc_create_single_data+0x7c/0xa0
[ 9888.981835][    C2]  snmp6_register_dev+0xb0/0x130
[ 9888.981836][    C2]  ipv6_add_dev+0x4b7/0xf60
[ 9888.981837][    C2]  addrconf_notify+0x684/0x1ca0
[ 9888.981838][    C2]  ? __mutex_unlock_slowpath+0xd0/0x670
[ 9888.981839][    C2]  ? kasan_unpoison_shadow+0x30/0x40
[ 9888.981840][    C2]  ? wait_for_completion+0x250/0x250
[ 9888.981841][    C2]  ? inet6_ifinfo_notify+0x100/0x100
[ 9888.981842][    C2]  ? dropmon_net_event+0x227/0x410
[ 9888.981843][    C2]  ? notifier_call_chain+0x90/0x160
[ 9888.981844][    C2]  ? inet6_ifinfo_notify+0x100/0x100
[ 9888.981845][    C2]  notifier_call_chain+0x90/0x160
[ 9888.981846][    C2]  register_netdevice+0xbe5/0x1070
[ ... ]

Reported-by: syzbot+1d51c8b74efa4c44adeb@syzkaller.appspotmail.com
Fixes: e0a4b99773d3 ("hsr: use upper/lower device infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c  | 21 +--------------------
 net/hsr/hsr_device.h  |  2 +-
 net/hsr/hsr_main.c    |  9 ++++++---
 net/hsr/hsr_netlink.c | 17 +++++++++++++++++
 4 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index fc7027314ad80..ef100cfd2ac1b 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -341,7 +341,7 @@ static void hsr_announce(struct timer_list *t)
 	rcu_read_unlock();
 }
 
-static void hsr_del_ports(struct hsr_priv *hsr)
+void hsr_del_ports(struct hsr_priv *hsr)
 {
 	struct hsr_port *port;
 
@@ -358,31 +358,12 @@ static void hsr_del_ports(struct hsr_priv *hsr)
 		hsr_del_port(port);
 }
 
-/* This has to be called after all the readers are gone.
- * Otherwise we would have to check the return value of
- * hsr_port_get_hsr().
- */
-static void hsr_dev_destroy(struct net_device *hsr_dev)
-{
-	struct hsr_priv *hsr = netdev_priv(hsr_dev);
-
-	hsr_debugfs_term(hsr);
-	hsr_del_ports(hsr);
-
-	del_timer_sync(&hsr->prune_timer);
-	del_timer_sync(&hsr->announce_timer);
-
-	hsr_del_self_node(hsr);
-	hsr_del_nodes(&hsr->node_db);
-}
-
 static const struct net_device_ops hsr_device_ops = {
 	.ndo_change_mtu = hsr_dev_change_mtu,
 	.ndo_open = hsr_dev_open,
 	.ndo_stop = hsr_dev_close,
 	.ndo_start_xmit = hsr_dev_xmit,
 	.ndo_fix_features = hsr_fix_features,
-	.ndo_uninit = hsr_dev_destroy,
 };
 
 static struct device_type hsr_type = {
diff --git a/net/hsr/hsr_device.h b/net/hsr/hsr_device.h
index a099d7de7e790..b8f9262ed101a 100644
--- a/net/hsr/hsr_device.h
+++ b/net/hsr/hsr_device.h
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include "hsr_main.h"
 
+void hsr_del_ports(struct hsr_priv *hsr);
 void hsr_dev_setup(struct net_device *dev);
 int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 		     unsigned char multicast_spec, u8 protocol_version,
@@ -18,5 +19,4 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 void hsr_check_carrier_and_operstate(struct hsr_priv *hsr);
 bool is_hsr_master(struct net_device *dev);
 int hsr_get_max_mtu(struct hsr_priv *hsr);
-
 #endif /* __HSR_DEVICE_H */
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index e2564de676038..144da15f0a817 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/netdevice.h>
+#include <net/rtnetlink.h>
 #include <linux/rculist.h>
 #include <linux/timer.h>
 #include <linux/etherdevice.h>
@@ -100,8 +101,10 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 			master = hsr_port_get_hsr(port->hsr, HSR_PT_MASTER);
 			hsr_del_port(port);
 			if (hsr_slave_empty(master->hsr)) {
-				unregister_netdevice_queue(master->dev,
-							   &list_kill);
+				const struct rtnl_link_ops *ops;
+
+				ops = master->dev->rtnl_link_ops;
+				ops->dellink(master->dev, &list_kill);
 				unregister_netdevice_many(&list_kill);
 			}
 		}
@@ -144,9 +147,9 @@ static int __init hsr_init(void)
 
 static void __exit hsr_exit(void)
 {
-	unregister_netdevice_notifier(&hsr_nb);
 	hsr_netlink_exit();
 	hsr_debugfs_remove_root();
+	unregister_netdevice_notifier(&hsr_nb);
 }
 
 module_init(hsr_init);
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 1decb25f6764a..6e14b7d226399 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -83,6 +83,22 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 	return hsr_dev_finalize(dev, link, multicast_spec, hsr_version, extack);
 }
 
+static void hsr_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct hsr_priv *hsr = netdev_priv(dev);
+
+	del_timer_sync(&hsr->prune_timer);
+	del_timer_sync(&hsr->announce_timer);
+
+	hsr_debugfs_term(hsr);
+	hsr_del_ports(hsr);
+
+	hsr_del_self_node(hsr);
+	hsr_del_nodes(&hsr->node_db);
+
+	unregister_netdevice_queue(dev, head);
+}
+
 static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct hsr_priv *hsr = netdev_priv(dev);
@@ -118,6 +134,7 @@ static struct rtnl_link_ops hsr_link_ops __read_mostly = {
 	.priv_size	= sizeof(struct hsr_priv),
 	.setup		= hsr_dev_setup,
 	.newlink	= hsr_newlink,
+	.dellink	= hsr_dellink,
 	.fill_info	= hsr_fill_info,
 };
 
-- 
2.25.1



