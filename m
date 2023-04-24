Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4296ECDA1
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjDXNZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjDXNZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:25:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B718FD8
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:25:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42DA6622A5
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1A1C433EF;
        Mon, 24 Apr 2023 13:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342703;
        bh=0oFKJ221CfKpYv0lS0Quj3gru1DX81Ns8LesJ1eo2zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgzPoPBXx17lENY74Vd+kTCyczH3w13RN5LhbzTv3wCGqy+q1vazepN+V4MSkWtom
         WOGIht6HWRW+vGVN3fZZlRvbESKt/NZSSWvjBJBmPc3FNBMApQkJGUfNL5WasolJDr
         zh6Mlpaa1XqrovcJAa33KyEMauhnsLFCKqEPj0RM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Ido Schimmel <idosch@nvidia.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 26/98] bonding: Fix memory leak when changing bond type to Ethernet
Date:   Mon, 24 Apr 2023 15:16:49 +0200
Message-Id: <20230424131134.911937403@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit c484fcc058bada604d7e4e5228d4affb646ddbc2 ]

When a net device is put administratively up, its 'IFF_UP' flag is set
(if not set already) and a 'NETDEV_UP' notification is emitted, which
causes the 8021q driver to add VLAN ID 0 on the device. The reverse
happens when a net device is put administratively down.

When changing the type of a bond to Ethernet, its 'IFF_UP' flag is
incorrectly cleared, resulting in the kernel skipping the above process
and VLAN ID 0 being leaked [1].

Fix by restoring the flag when changing the type to Ethernet, in a
similar fashion to the restoration of the 'IFF_SLAVE' flag.

The issue can be reproduced using the script in [2], with example out
before and after the fix in [3].

[1]
unreferenced object 0xffff888103479900 (size 256):
  comm "ip", pid 329, jiffies 4294775225 (age 28.561s)
  hex dump (first 32 bytes):
    00 a0 0c 15 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81a6051a>] kmalloc_trace+0x2a/0xe0
    [<ffffffff8406426c>] vlan_vid_add+0x30c/0x790
    [<ffffffff84068e21>] vlan_device_event+0x1491/0x21a0
    [<ffffffff81440c8e>] notifier_call_chain+0xbe/0x1f0
    [<ffffffff8372383a>] call_netdevice_notifiers_info+0xba/0x150
    [<ffffffff837590f2>] __dev_notify_flags+0x132/0x2e0
    [<ffffffff8375ad9f>] dev_change_flags+0x11f/0x180
    [<ffffffff8379af36>] do_setlink+0xb96/0x4060
    [<ffffffff837adf6a>] __rtnl_newlink+0xc0a/0x18a0
    [<ffffffff837aec6c>] rtnl_newlink+0x6c/0xa0
    [<ffffffff837ac64e>] rtnetlink_rcv_msg+0x43e/0xe00
    [<ffffffff839a99e0>] netlink_rcv_skb+0x170/0x440
    [<ffffffff839a738f>] netlink_unicast+0x53f/0x810
    [<ffffffff839a7fcb>] netlink_sendmsg+0x96b/0xe90
    [<ffffffff8369d12f>] ____sys_sendmsg+0x30f/0xa70
    [<ffffffff836a6d7a>] ___sys_sendmsg+0x13a/0x1e0
unreferenced object 0xffff88810f6a83e0 (size 32):
  comm "ip", pid 329, jiffies 4294775225 (age 28.561s)
  hex dump (first 32 bytes):
    a0 99 47 03 81 88 ff ff a0 99 47 03 81 88 ff ff  ..G.......G.....
    81 00 00 00 01 00 00 00 cc cc cc cc cc cc cc cc  ................
  backtrace:
    [<ffffffff81a6051a>] kmalloc_trace+0x2a/0xe0
    [<ffffffff84064369>] vlan_vid_add+0x409/0x790
    [<ffffffff84068e21>] vlan_device_event+0x1491/0x21a0
    [<ffffffff81440c8e>] notifier_call_chain+0xbe/0x1f0
    [<ffffffff8372383a>] call_netdevice_notifiers_info+0xba/0x150
    [<ffffffff837590f2>] __dev_notify_flags+0x132/0x2e0
    [<ffffffff8375ad9f>] dev_change_flags+0x11f/0x180
    [<ffffffff8379af36>] do_setlink+0xb96/0x4060
    [<ffffffff837adf6a>] __rtnl_newlink+0xc0a/0x18a0
    [<ffffffff837aec6c>] rtnl_newlink+0x6c/0xa0
    [<ffffffff837ac64e>] rtnetlink_rcv_msg+0x43e/0xe00
    [<ffffffff839a99e0>] netlink_rcv_skb+0x170/0x440
    [<ffffffff839a738f>] netlink_unicast+0x53f/0x810
    [<ffffffff839a7fcb>] netlink_sendmsg+0x96b/0xe90
    [<ffffffff8369d12f>] ____sys_sendmsg+0x30f/0xa70
    [<ffffffff836a6d7a>] ___sys_sendmsg+0x13a/0x1e0

[2]
ip link add name t-nlmon type nlmon
ip link add name t-dummy type dummy
ip link add name t-bond type bond mode active-backup

ip link set dev t-bond up
ip link set dev t-nlmon master t-bond
ip link set dev t-nlmon nomaster
ip link show dev t-bond
ip link set dev t-dummy master t-bond
ip link show dev t-bond

ip link del dev t-bond
ip link del dev t-dummy
ip link del dev t-nlmon

[3]
Before:

12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/netlink
12: t-bond: <BROADCAST,MULTICAST,MASTER,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 46:57:39:a4:46:a2 brd ff:ff:ff:ff:ff:ff

After:

12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/netlink
12: t-bond: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 66:48:7b:74:b6:8a brd ff:ff:ff:ff:ff:ff

Fixes: e36b9d16c6a6 ("bonding: clean muticast addresses when device changes type")
Fixes: 75c78500ddad ("bonding: remap muticast addresses without using dev_close() and dev_open()")
Fixes: 9ec7eb60dcbc ("bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type change")
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Link: https://lore.kernel.org/netdev/78a8a03b-6070-3e6b-5042-f848dab16fb8@alu.unizg.hr/
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9f6824a6537bc..9f44c86a591dd 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1776,14 +1776,15 @@ void bond_lower_state_changed(struct slave *slave)
 
 /* The bonding driver uses ether_setup() to convert a master bond device
  * to ARPHRD_ETHER, that resets the target netdevice's flags so we always
- * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it was set
+ * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE and IFF_UP
+ * if they were set
  */
 static void bond_ether_setup(struct net_device *bond_dev)
 {
-	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
+	unsigned int flags = bond_dev->flags & (IFF_SLAVE | IFF_UP);
 
 	ether_setup(bond_dev);
-	bond_dev->flags |= IFF_MASTER | slave_flag;
+	bond_dev->flags |= IFF_MASTER | flags;
 	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 }
 
-- 
2.39.2



