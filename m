Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C8449918A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379554AbiAXULn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:11:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33698 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348836AbiAXUIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:08:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC24F6131F;
        Mon, 24 Jan 2022 20:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A5AC340E5;
        Mon, 24 Jan 2022 20:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054926;
        bh=QYooLD2Iy4Ex5XNIjipp54FHDkWtZ0Nl+hc6wluX0oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sb7bDZvEOJ/CuWmeXwywSTsTcAmvO0G+NyEISXub9Almwv0Bgsruj8N8shpHo8O7f
         Px8mWQRwTpXcs2hp3FjRvs3ZFElalzGBPjME4CYfGV0CLI0fIl879yifaxT/gPyUPN
         hoAbLCfrbsbgZO/A8P9QObG1jaQSxfeqyKLHhvbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 549/563] net: bonding: fix bond_xmit_broadcast return value error bug
Date:   Mon, 24 Jan 2022 19:45:14 +0100
Message-Id: <20220124184043.423578112@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

commit 4e5bd03ae34652cd932ab4c91c71c511793df75c upstream.

In Linux bonding scenario, one packet is copied to several copies and sent
by all slave device of bond0 in mode 3(broadcast mode). The mode 3 xmit
function bond_xmit_broadcast() only ueses the last slave device's tx result
as the final result. In this case, if the last slave device is down, then
it always return NET_XMIT_DROP, even though the other slave devices xmit
success. It may cause the tx statistics error, and cause the application
(e.g. scp) consider the network is unreachable.

For example, use the following command to configure server A.

echo 3 > /sys/class/net/bond0/bonding/mode
ifconfig bond0 up
ifenslave bond0 eth0 eth1
ifconfig bond0 192.168.1.125
ifconfig eth0 up
ifconfig eth1 down
The slave device eth0 and eth1 are connected to server B(192.168.1.107).
Run the ping 192.168.1.107 -c 3 -i 0.2 command, the following information
is displayed.

PING 192.168.1.107 (192.168.1.107) 56(84) bytes of data.
64 bytes from 192.168.1.107: icmp_seq=1 ttl=64 time=0.077 ms
64 bytes from 192.168.1.107: icmp_seq=2 ttl=64 time=0.056 ms
64 bytes from 192.168.1.107: icmp_seq=3 ttl=64 time=0.051 ms

 192.168.1.107 ping statistics
0 packets transmitted, 3 received

Actually, the slave device eth0 of the bond successfully sends three
ICMP packets, but the result shows that 0 packets are transmitted.

Also if we use scp command to get remote files, the command end with the
following printings.

ssh_exchange_identification: read: Connection timed out

So this patch modifies the bond_xmit_broadcast to return NET_XMIT_SUCCESS
if one slave device in the bond sends packets successfully. If all slave
devices send packets fail, the discarded packets stats is increased. The
skb is released when there is no slave device in the bond or the last slave
device is down.

Fixes: ae46f184bc1f ("bonding: propagate transmit status")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4562,25 +4562,39 @@ static netdev_tx_t bond_xmit_broadcast(s
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave = NULL;
 	struct list_head *iter;
+	bool xmit_suc = false;
+	bool skb_used = false;
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		if (bond_is_last_slave(bond, slave))
-			break;
-		if (bond_slave_is_up(slave) && slave->link == BOND_LINK_UP) {
-			struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
+		struct sk_buff *skb2;
 
+		if (!(bond_slave_is_up(slave) && slave->link == BOND_LINK_UP))
+			continue;
+
+		if (bond_is_last_slave(bond, slave)) {
+			skb2 = skb;
+			skb_used = true;
+		} else {
+			skb2 = skb_clone(skb, GFP_ATOMIC);
 			if (!skb2) {
 				net_err_ratelimited("%s: Error: %s: skb_clone() failed\n",
 						    bond_dev->name, __func__);
 				continue;
 			}
-			bond_dev_queue_xmit(bond, skb2, slave->dev);
 		}
+
+		if (bond_dev_queue_xmit(bond, skb2, slave->dev) == NETDEV_TX_OK)
+			xmit_suc = true;
 	}
-	if (slave && bond_slave_is_up(slave) && slave->link == BOND_LINK_UP)
-		return bond_dev_queue_xmit(bond, skb, slave->dev);
 
-	return bond_tx_drop(bond_dev, skb);
+	if (!skb_used)
+		dev_kfree_skb_any(skb);
+
+	if (xmit_suc)
+		return NETDEV_TX_OK;
+
+	atomic_long_inc(&bond_dev->tx_dropped);
+	return NET_XMIT_DROP;
 }
 
 /*------------------------- Device initialization ---------------------------*/


