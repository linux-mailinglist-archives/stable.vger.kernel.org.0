Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF283290D0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242701AbhCAUPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:15:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234647AbhCAUFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:05:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4298A64F4A;
        Mon,  1 Mar 2021 17:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621507;
        bh=+9s6zb2QNj25T+9nwWg8lx+UdXOBgTU6A/lIONQOtgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAxp9gw4IkbPnJtkGHp2C1McYT6qnunRfwcIt/BHNknVdX9LRlHwH5TNhJ0XhIEtk
         lovxevl61dp4N5G7FZM/SE376iVWc949r9uunX5eq35FeKCWneVhNiNzWSz7hZ7mON
         +k9va4jp5+wA6FQXzSBYWvzwLYPnp7WQkUAWnFNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 542/775] vxlan: move debug check after netdev unregister
Date:   Mon,  1 Mar 2021 17:11:50 +0100
Message-Id: <20210301161228.269433502@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 92584ddf550ae72d492858c19d1f9025e07a9350 ]

The debug check must be done after unregister_netdevice_many() call --
the hlist_del_rcu() for this is done inside .ndo_stop.

This is the same with commit 0fda7600c2e1 ("geneve: move debug check after
netdev unregister")

Test commands:
    ip netns del A
    ip netns add A
    ip netns add B

    ip netns exec B ip link add vxlan0 type vxlan vni 100 local 10.0.0.1 \
	    remote 10.0.0.2 dstport 4789 srcport 4789 4789
    ip netns exec B ip link set vxlan0 netns A
    ip netns exec A ip link set vxlan0 up
    ip netns del B

Splat looks like:
[   73.176249][    T7] ------------[ cut here ]------------
[   73.178662][    T7] WARNING: CPU: 4 PID: 7 at drivers/net/vxlan.c:4743 vxlan_exit_batch_net+0x52e/0x720 [vxlan]
[   73.182597][    T7] Modules linked in: vxlan openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 mlx5_core nfp mlxfw ixgbevf tls sch_fq_codel nf_tables nfnetlink ip_tables x_tables unix
[   73.190113][    T7] CPU: 4 PID: 7 Comm: kworker/u16:0 Not tainted 5.11.0-rc7+ #838
[   73.193037][    T7] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   73.196986][    T7] Workqueue: netns cleanup_net
[   73.198946][    T7] RIP: 0010:vxlan_exit_batch_net+0x52e/0x720 [vxlan]
[   73.201509][    T7] Code: 00 01 00 00 0f 84 39 fd ff ff 48 89 ca 48 c1 ea 03 80 3c 1a 00 0f 85 a6 00 00 00 89 c2 48 83 c2 02 49 8b 14 d4 48 85 d2 74 ce <0f> 0b eb ca e8 b9 51 db dd 84 c0 0f 85 4a fe ff ff 48 c7 c2 80 bc
[   73.208813][    T7] RSP: 0018:ffff888100907c10 EFLAGS: 00010286
[   73.211027][    T7] RAX: 000000000000003c RBX: dffffc0000000000 RCX: ffff88800ec411f0
[   73.213702][    T7] RDX: ffff88800a278000 RSI: ffff88800fc78c70 RDI: ffff88800fc78070
[   73.216169][    T7] RBP: ffff88800b5cbdc0 R08: fffffbfff424de61 R09: fffffbfff424de61
[   73.218463][    T7] R10: ffffffffa126f307 R11: fffffbfff424de60 R12: ffff88800ec41000
[   73.220794][    T7] R13: ffff888100907d08 R14: ffff888100907c50 R15: ffff88800fc78c40
[   73.223337][    T7] FS:  0000000000000000(0000) GS:ffff888114800000(0000) knlGS:0000000000000000
[   73.225814][    T7] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   73.227616][    T7] CR2: 0000562b5cb4f4d0 CR3: 0000000105fbe001 CR4: 00000000003706e0
[   73.229700][    T7] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   73.231820][    T7] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   73.233844][    T7] Call Trace:
[   73.234698][    T7]  ? vxlan_err_lookup+0x3c0/0x3c0 [vxlan]
[   73.235962][    T7]  ? ops_exit_list.isra.11+0x93/0x140
[   73.237134][    T7]  cleanup_net+0x45e/0x8a0
[ ... ]

Fixes: 57b61127ab7d ("vxlan: speedup vxlan tunnels dismantle")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://lore.kernel.org/r/20210221154552.11749-1-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a8ad710629e69..0842371eca3d6 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4725,7 +4725,6 @@ static void vxlan_destroy_tunnels(struct net *net, struct list_head *head)
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
 	struct vxlan_dev *vxlan, *next;
 	struct net_device *dev, *aux;
-	unsigned int h;
 
 	for_each_netdev_safe(net, dev, aux)
 		if (dev->rtnl_link_ops == &vxlan_link_ops)
@@ -4739,14 +4738,13 @@ static void vxlan_destroy_tunnels(struct net *net, struct list_head *head)
 			unregister_netdevice_queue(vxlan->dev, head);
 	}
 
-	for (h = 0; h < PORT_HASH_SIZE; ++h)
-		WARN_ON_ONCE(!hlist_empty(&vn->sock_list[h]));
 }
 
 static void __net_exit vxlan_exit_batch_net(struct list_head *net_list)
 {
 	struct net *net;
 	LIST_HEAD(list);
+	unsigned int h;
 
 	rtnl_lock();
 	list_for_each_entry(net, net_list, exit_list) {
@@ -4759,6 +4757,13 @@ static void __net_exit vxlan_exit_batch_net(struct list_head *net_list)
 
 	unregister_netdevice_many(&list);
 	rtnl_unlock();
+
+	list_for_each_entry(net, net_list, exit_list) {
+		struct vxlan_net *vn = net_generic(net, vxlan_net_id);
+
+		for (h = 0; h < PORT_HASH_SIZE; ++h)
+			WARN_ON_ONCE(!hlist_empty(&vn->sock_list[h]));
+	}
 }
 
 static struct pernet_operations vxlan_net_ops = {
-- 
2.27.0



