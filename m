Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0ACF7EF9
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfKKSiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:38:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbfKKSiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:38:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A91A204FD;
        Mon, 11 Nov 2019 18:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497500;
        bh=QUaReASXs890eszlf2RDcMU4t1Uxbo43pqCxqttAjG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9Xd3jJGyBcHQnptuI0nrPPMJOCYjKnHmxf2H251cVpARwKB49ie5EjpPHd/02Q8p
         4owkElBJFQPnVvsY/un5J5EVLXHgwf6qZwr7Rqpv1KGBbyO5Vp2pgA/PzNdMJPn8eo
         NtpQswvnHBxSBJWZUGHtNpZep6lje6VJLb1UOrZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ying Xue <ying.xue@windriver.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Hillf Danton <hdanton@sina.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 075/105] net: openvswitch: free vport unless register_netdevice() succeeds
Date:   Mon, 11 Nov 2019 19:28:45 +0100
Message-Id: <20191111181446.148025647@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

[ Upstream commit 9464cc37f3671ee69cb1c00662b5e1f113a96b23 ]

syzbot found the following crash on:

HEAD commit:    1e78030e Merge tag 'mmc-v5.3-rc1' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=148d3d1a600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=30cef20daf3e9977
dashboard link: https://syzkaller.appspot.com/bug?extid=13210896153522fe1ee5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=136aa8c4600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109ba792600000

=====================================================================
BUG: memory leak
unreferenced object 0xffff8881207e4100 (size 128):
   comm "syz-executor032", pid 7014, jiffies 4294944027 (age 13.830s)
   hex dump (first 32 bytes):
     00 70 16 18 81 88 ff ff 80 af 8c 22 81 88 ff ff  .p........."....
     00 b6 23 17 81 88 ff ff 00 00 00 00 00 00 00 00  ..#.............
   backtrace:
     [<000000000eb78212>] kmemleak_alloc_recursive  include/linux/kmemleak.h:43 [inline]
     [<000000000eb78212>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000000eb78212>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000eb78212>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000006ea6c6>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000006ea6c6>] kzalloc include/linux/slab.h:748 [inline]
     [<00000000006ea6c6>] ovs_vport_alloc+0x37/0xf0  net/openvswitch/vport.c:130
     [<00000000f9a04a7d>] internal_dev_create+0x24/0x1d0  net/openvswitch/vport-internal_dev.c:164
     [<0000000056ee7c13>] ovs_vport_add+0x81/0x190  net/openvswitch/vport.c:199
     [<000000005434efc7>] new_vport+0x19/0x80 net/openvswitch/datapath.c:194
     [<00000000b7b253f1>] ovs_dp_cmd_new+0x22f/0x410  net/openvswitch/datapath.c:1614
     [<00000000e0988518>] genl_family_rcv_msg+0x2ab/0x5b0  net/netlink/genetlink.c:629
     [<00000000d0cc9347>] genl_rcv_msg+0x54/0x9c net/netlink/genetlink.c:654
     [<000000006694b647>] netlink_rcv_skb+0x61/0x170  net/netlink/af_netlink.c:2477
     [<0000000088381f37>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
     [<00000000dad42a47>] netlink_unicast_kernel  net/netlink/af_netlink.c:1302 [inline]
     [<00000000dad42a47>] netlink_unicast+0x1ec/0x2d0  net/netlink/af_netlink.c:1328
     [<0000000067e6b079>] netlink_sendmsg+0x270/0x480  net/netlink/af_netlink.c:1917
     [<00000000aab08a47>] sock_sendmsg_nosec net/socket.c:637 [inline]
     [<00000000aab08a47>] sock_sendmsg+0x54/0x70 net/socket.c:657
     [<000000004cb7c11d>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2311
     [<00000000c4901c63>] __sys_sendmsg+0x80/0xf0 net/socket.c:2356
     [<00000000c10abb2d>] __do_sys_sendmsg net/socket.c:2365 [inline]
     [<00000000c10abb2d>] __se_sys_sendmsg net/socket.c:2363 [inline]
     [<00000000c10abb2d>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2363

BUG: memory leak
unreferenced object 0xffff88811723b600 (size 64):
   comm "syz-executor032", pid 7014, jiffies 4294944027 (age 13.830s)
   hex dump (first 32 bytes):
     01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 02 00 00 00 05 35 82 c1  .............5..
   backtrace:
     [<00000000352f46d8>] kmemleak_alloc_recursive  include/linux/kmemleak.h:43 [inline]
     [<00000000352f46d8>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000352f46d8>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000352f46d8>] __do_kmalloc mm/slab.c:3653 [inline]
     [<00000000352f46d8>] __kmalloc+0x169/0x300 mm/slab.c:3664
     [<000000008e48f3d1>] kmalloc include/linux/slab.h:557 [inline]
     [<000000008e48f3d1>] ovs_vport_set_upcall_portids+0x54/0xd0  net/openvswitch/vport.c:343
     [<00000000541e4f4a>] ovs_vport_alloc+0x7f/0xf0  net/openvswitch/vport.c:139
     [<00000000f9a04a7d>] internal_dev_create+0x24/0x1d0  net/openvswitch/vport-internal_dev.c:164
     [<0000000056ee7c13>] ovs_vport_add+0x81/0x190  net/openvswitch/vport.c:199
     [<000000005434efc7>] new_vport+0x19/0x80 net/openvswitch/datapath.c:194
     [<00000000b7b253f1>] ovs_dp_cmd_new+0x22f/0x410  net/openvswitch/datapath.c:1614
     [<00000000e0988518>] genl_family_rcv_msg+0x2ab/0x5b0  net/netlink/genetlink.c:629
     [<00000000d0cc9347>] genl_rcv_msg+0x54/0x9c net/netlink/genetlink.c:654
     [<000000006694b647>] netlink_rcv_skb+0x61/0x170  net/netlink/af_netlink.c:2477
     [<0000000088381f37>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
     [<00000000dad42a47>] netlink_unicast_kernel  net/netlink/af_netlink.c:1302 [inline]
     [<00000000dad42a47>] netlink_unicast+0x1ec/0x2d0  net/netlink/af_netlink.c:1328
     [<0000000067e6b079>] netlink_sendmsg+0x270/0x480  net/netlink/af_netlink.c:1917
     [<00000000aab08a47>] sock_sendmsg_nosec net/socket.c:637 [inline]
     [<00000000aab08a47>] sock_sendmsg+0x54/0x70 net/socket.c:657
     [<000000004cb7c11d>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2311
     [<00000000c4901c63>] __sys_sendmsg+0x80/0xf0 net/socket.c:2356

BUG: memory leak
unreferenced object 0xffff8881228ca500 (size 128):
   comm "syz-executor032", pid 7015, jiffies 4294944622 (age 7.880s)
   hex dump (first 32 bytes):
     00 f0 27 18 81 88 ff ff 80 ac 8c 22 81 88 ff ff  ..'........"....
     40 b7 23 17 81 88 ff ff 00 00 00 00 00 00 00 00  @.#.............
   backtrace:
     [<000000000eb78212>] kmemleak_alloc_recursive  include/linux/kmemleak.h:43 [inline]
     [<000000000eb78212>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000000eb78212>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000eb78212>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000006ea6c6>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000006ea6c6>] kzalloc include/linux/slab.h:748 [inline]
     [<00000000006ea6c6>] ovs_vport_alloc+0x37/0xf0  net/openvswitch/vport.c:130
     [<00000000f9a04a7d>] internal_dev_create+0x24/0x1d0  net/openvswitch/vport-internal_dev.c:164
     [<0000000056ee7c13>] ovs_vport_add+0x81/0x190  net/openvswitch/vport.c:199
     [<000000005434efc7>] new_vport+0x19/0x80 net/openvswitch/datapath.c:194
     [<00000000b7b253f1>] ovs_dp_cmd_new+0x22f/0x410  net/openvswitch/datapath.c:1614
     [<00000000e0988518>] genl_family_rcv_msg+0x2ab/0x5b0  net/netlink/genetlink.c:629
     [<00000000d0cc9347>] genl_rcv_msg+0x54/0x9c net/netlink/genetlink.c:654
     [<000000006694b647>] netlink_rcv_skb+0x61/0x170  net/netlink/af_netlink.c:2477
     [<0000000088381f37>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
     [<00000000dad42a47>] netlink_unicast_kernel  net/netlink/af_netlink.c:1302 [inline]
     [<00000000dad42a47>] netlink_unicast+0x1ec/0x2d0  net/netlink/af_netlink.c:1328
     [<0000000067e6b079>] netlink_sendmsg+0x270/0x480  net/netlink/af_netlink.c:1917
     [<00000000aab08a47>] sock_sendmsg_nosec net/socket.c:637 [inline]
     [<00000000aab08a47>] sock_sendmsg+0x54/0x70 net/socket.c:657
     [<000000004cb7c11d>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2311
     [<00000000c4901c63>] __sys_sendmsg+0x80/0xf0 net/socket.c:2356
     [<00000000c10abb2d>] __do_sys_sendmsg net/socket.c:2365 [inline]
     [<00000000c10abb2d>] __se_sys_sendmsg net/socket.c:2363 [inline]
     [<00000000c10abb2d>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2363
=====================================================================

The function in net core, register_netdevice(), may fail with vport's
destruction callback either invoked or not. After commit 309b66970ee2
("net: openvswitch: do not free vport if register_netdevice() is failed."),
the duty to destroy vport is offloaded from the driver OTOH, which ends
up in the memory leak reported.

It is fixed by releasing vport unless device is registered successfully.
To do that, the callback assignment is defered until device is registered.

Reported-by: syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com
Fixes: 309b66970ee2 ("net: openvswitch: do not free vport if register_netdevice() is failed.")
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Greg Rose <gvrose8192@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
[sbrivio: this was sent to dev@openvswitch.org and never made its way
 to netdev -- resending original patch]
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Greg Rose <gvrose8192@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport-internal_dev.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index b9377afeaba45..1c09ad457d2a9 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -156,7 +156,7 @@ static void do_setup(struct net_device *netdev)
 	netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_OPENVSWITCH |
 			      IFF_PHONY_HEADROOM | IFF_NO_QUEUE;
 	netdev->needs_free_netdev = true;
-	netdev->priv_destructor = internal_dev_destructor;
+	netdev->priv_destructor = NULL;
 	netdev->ethtool_ops = &internal_dev_ethtool_ops;
 	netdev->rtnl_link_ops = &internal_dev_link_ops;
 
@@ -178,7 +178,6 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 	struct internal_dev *internal_dev;
 	struct net_device *dev;
 	int err;
-	bool free_vport = true;
 
 	vport = ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
 	if (IS_ERR(vport)) {
@@ -210,10 +209,9 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 
 	rtnl_lock();
 	err = register_netdevice(vport->dev);
-	if (err) {
-		free_vport = false;
+	if (err)
 		goto error_unlock;
-	}
+	vport->dev->priv_destructor = internal_dev_destructor;
 
 	dev_set_promiscuity(vport->dev, 1);
 	rtnl_unlock();
@@ -227,8 +225,7 @@ error_unlock:
 error_free_netdev:
 	free_netdev(dev);
 error_free_vport:
-	if (free_vport)
-		ovs_vport_free(vport);
+	ovs_vport_free(vport);
 error:
 	return ERR_PTR(err);
 }
-- 
2.20.1



