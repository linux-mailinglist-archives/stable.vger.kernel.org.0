Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0789F333E98
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhCJN0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233405AbhCJNZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 357AD65029;
        Wed, 10 Mar 2021 13:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382729;
        bh=hjBQvFWWY9r8tBYGhHMTiek1Na8CMbbH8WRxIhNBv5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXlNEpnGHKPRC0VI5PKYyfwsz+Qk9huFyMBJcGdbAvMHaS5zBy/SiubJfnZDus0mK
         Zvma0BXYCeLxrOuhfLY+AhuYEFK/D9nM9LTOkrupZ9FEXwYv1LNo1jf1MejAXzJ0m+
         JZpoMtyBQgHrr7wm6EbcmFhwQJxo6ZBJhaOJ7Yfo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <bloodyreaper@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 4.19 21/39] net: dsa: add GRO support via gro_cells
Date:   Wed, 10 Mar 2021 14:24:29 +0100
Message-Id: <20210310132320.386282583@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Alexander Lobakin <bloodyreaper@yandex.ru>

commit e131a5634830047923c694b4ce0c3b31745ff01b upstream.

gro_cells lib is used by different encapsulating netdevices, such as
geneve, macsec, vxlan etc. to speed up decapsulated traffic processing.
CPU tag is a sort of "encapsulation", and we can use the same mechs to
greatly improve overall DSA performance.
skbs are passed to the GRO layer after removing CPU tags, so we don't
need any new packet offload types as it was firstly proposed by me in
the first GRO-over-DSA variant [1].

The size of struct gro_cells is sizeof(void *), so hot struct
dsa_slave_priv becomes only 4/8 bytes bigger, and all critical fields
remain in one 32-byte cacheline.
The other positive side effect is that drivers for network devices
that can be shipped as CPU ports of DSA-driven switches can now use
napi_gro_frags() to pass skbs to kernel. Packets built that way are
completely non-linear and are likely being dropped without GRO.

This was tested on to-be-mainlined-soon Ethernet driver that uses
napi_gro_frags(), and the overall performance was on par with the
variant from [1], sometimes even better due to minimal overhead.
net.core.gro_normal_batch tuning may help to push it to the limit
on particular setups and platforms.

iperf3 IPoE VLAN NAT TCP forwarding (port1.218 -> port0) setup
on 1.2 GHz MIPS board:

5.7-rc2 baseline:

[ID]  Interval         Transfer     Bitrate        Retr
[ 5]  0.00-120.01 sec  9.00 GBytes  644 Mbits/sec  413  sender
[ 5]  0.00-120.00 sec  8.99 GBytes  644 Mbits/sec       receiver

Iface      RX packets  TX packets
eth0       7097731     7097702
port0      426050      6671829
port1      6671681     425862
port1.218  6671677     425851

With this patch:

[ID]  Interval         Transfer     Bitrate        Retr
[ 5]  0.00-120.01 sec  12.2 GBytes  870 Mbits/sec  122  sender
[ 5]  0.00-120.00 sec  12.2 GBytes  870 Mbits/sec       receiver

Iface      RX packets  TX packets
eth0       9474792     9474777
port0      455200      353288
port1      9019592     455035
port1.218  353144      455024

v2:
 - Add some performance examples in the commit message;
 - No functional changes.

[1] https://lore.kernel.org/netdev/20191230143028.27313-1-alobakin@dlink.ru/

Signed-off-by: Alexander Lobakin <bloodyreaper@yandex.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Pali Rohár <pali@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/Kconfig    |    1 +
 net/dsa/dsa.c      |    2 +-
 net/dsa/dsa_priv.h |    3 +++
 net/dsa/slave.c    |   10 +++++++++-
 4 files changed, 14 insertions(+), 2 deletions(-)

--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -8,6 +8,7 @@ config NET_DSA
 	tristate "Distributed Switch Architecture"
 	depends on HAVE_NET_DSA && MAY_USE_DEVLINK
 	depends on BRIDGE || BRIDGE=n
+	select GRO_CELLS
 	select NET_SWITCHDEV
 	select PHYLINK
 	---help---
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -191,7 +191,7 @@ static int dsa_switch_rcv(struct sk_buff
 	if (dsa_skb_defer_rx_timestamp(p, skb))
 		return 0;
 
-	netif_receive_skb(skb);
+	gro_cells_receive(&p->gcells, skb);
 
 	return 0;
 }
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -15,6 +15,7 @@
 #include <linux/netdevice.h>
 #include <linux/netpoll.h>
 #include <net/dsa.h>
+#include <net/gro_cells.h>
 
 enum {
 	DSA_NOTIFIER_AGEING_TIME,
@@ -72,6 +73,8 @@ struct dsa_slave_priv {
 
 	struct pcpu_sw_netstats	*stats64;
 
+	struct gro_cells	gcells;
+
 	/* DSA port data, such as switch, port index, etc. */
 	struct dsa_port		*dp;
 
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1337,6 +1337,11 @@ int dsa_slave_create(struct dsa_port *po
 		free_netdev(slave_dev);
 		return -ENOMEM;
 	}
+
+	ret = gro_cells_init(&p->gcells, slave_dev);
+	if (ret)
+		goto out_free;
+
 	p->dp = port;
 	INIT_LIST_HEAD(&p->mall_tc_list);
 	p->xmit = cpu_dp->tag_ops->xmit;
@@ -1347,7 +1352,7 @@ int dsa_slave_create(struct dsa_port *po
 	ret = dsa_slave_phy_setup(slave_dev);
 	if (ret) {
 		netdev_err(master, "error %d setting up slave phy\n", ret);
-		goto out_free;
+		goto out_gcells;
 	}
 
 	dsa_slave_notify(slave_dev, DSA_PORT_REGISTER);
@@ -1366,6 +1371,8 @@ out_phy:
 	phylink_disconnect_phy(p->dp->pl);
 	rtnl_unlock();
 	phylink_destroy(p->dp->pl);
+out_gcells:
+	gro_cells_destroy(&p->gcells);
 out_free:
 	free_percpu(p->stats64);
 	free_netdev(slave_dev);
@@ -1386,6 +1393,7 @@ void dsa_slave_destroy(struct net_device
 	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
 	unregister_netdev(slave_dev);
 	phylink_destroy(dp->pl);
+	gro_cells_destroy(&p->gcells);
 	free_percpu(p->stats64);
 	free_netdev(slave_dev);
 }


