Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819C6137EB2
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbgAKKMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729782AbgAKKMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:12:50 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 126C62077C;
        Sat, 11 Jan 2020 10:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737569;
        bh=UUJlu6B7eFg7yVnaioHjiRE6TTDgjT14RPTA8E2U0QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KkAbAjtdmf8lbNULeqCUc7RsZhGywxyX6T32Y0tlmsvcp4Ru1rs5I1axdTEno2OJ+
         ap7bltjNh6HjGYqqMXy6JdF21JcTdbUvoGfNh+RRit4Zg5fpWPh4kJqOC7+JcqJVZJ
         0tMZD49tEya1atoy/h+qqeUHPJBa4L+kIdySO6Jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 62/62] vlan: fix memory leak in vlan_dev_set_egress_priority
Date:   Sat, 11 Jan 2020 10:50:44 +0100
Message-Id: <20200111094858.289778955@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9bbd917e0bec9aebdbd0c8dbc966caec15eb33e9 ]

There are few cases where the ndo_uninit() handler might be not
called if an error happens while device is initialized.

Since vlan_newlink() calls vlan_changelink() before
trying to register the netdevice, we need to make sure
vlan_dev_uninit() has been called at least once,
or we might leak allocated memory.

BUG: memory leak
unreferenced object 0xffff888122a206c0 (size 32):
  comm "syz-executor511", pid 7124, jiffies 4294950399 (age 32.240s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 61 73 00 00 00 00 00 00 00 00  ......as........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000000eb3bb85>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<000000000eb3bb85>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<000000000eb3bb85>] slab_alloc mm/slab.c:3320 [inline]
    [<000000000eb3bb85>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3549
    [<000000007b99f620>] kmalloc include/linux/slab.h:556 [inline]
    [<000000007b99f620>] vlan_dev_set_egress_priority+0xcc/0x150 net/8021q/vlan_dev.c:194
    [<000000007b0cb745>] vlan_changelink+0xd6/0x140 net/8021q/vlan_netlink.c:126
    [<0000000065aba83a>] vlan_newlink+0x135/0x200 net/8021q/vlan_netlink.c:181
    [<00000000fb5dd7a2>] __rtnl_newlink+0x89a/0xb80 net/core/rtnetlink.c:3305
    [<00000000ae4273a1>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3363
    [<00000000decab39f>] rtnetlink_rcv_msg+0x178/0x4b0 net/core/rtnetlink.c:5424
    [<00000000accba4ee>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
    [<00000000319fe20f>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
    [<00000000d51938dc>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
    [<00000000d51938dc>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
    [<00000000e539ac79>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
    [<000000006250c27e>] sock_sendmsg_nosec net/socket.c:639 [inline]
    [<000000006250c27e>] sock_sendmsg+0x54/0x70 net/socket.c:659
    [<00000000e2a156d1>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
    [<000000008c87466e>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
    [<00000000110e3054>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
    [<00000000d71077c8>] __do_sys_sendmsg net/socket.c:2426 [inline]
    [<00000000d71077c8>] __se_sys_sendmsg net/socket.c:2424 [inline]
    [<00000000d71077c8>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424

Fixe: 07b5b17e157b ("[VLAN]: Use rtnl_link API")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan.h         |    1 +
 net/8021q/vlan_dev.c     |    3 ++-
 net/8021q/vlan_netlink.c |    9 +++++----
 3 files changed, 8 insertions(+), 5 deletions(-)

--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -110,6 +110,7 @@ int vlan_check_real_dev(struct net_devic
 void vlan_setup(struct net_device *dev);
 int register_vlan_dev(struct net_device *dev);
 void unregister_vlan_dev(struct net_device *dev, struct list_head *head);
+void vlan_dev_uninit(struct net_device *dev);
 bool vlan_dev_inherit_address(struct net_device *dev,
 			      struct net_device *real_dev);
 
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -610,7 +610,8 @@ static int vlan_dev_init(struct net_devi
 	return 0;
 }
 
-static void vlan_dev_uninit(struct net_device *dev)
+/* Note: this function might be called multiple times for the same device. */
+void vlan_dev_uninit(struct net_device *dev)
 {
 	struct vlan_priority_tci_mapping *pm;
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -161,10 +161,11 @@ static int vlan_newlink(struct net *src_
 		return -EINVAL;
 
 	err = vlan_changelink(dev, tb, data, extack);
-	if (err < 0)
-		return err;
-
-	return register_vlan_dev(dev);
+	if (!err)
+		err = register_vlan_dev(dev);
+	if (err)
+		vlan_dev_uninit(dev);
+	return err;
 }
 
 static inline size_t vlan_qos_map_size(unsigned int n)


