Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118D733155E
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 18:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCHR6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 12:58:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhCHR6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 12:58:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBE9A652AB;
        Mon,  8 Mar 2021 17:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615226282;
        bh=p/LwAvOuvnmYP3lAw5Vqsc0uYr8yZefIkO8+aJ5d7mg=;
        h=From:To:Cc:Subject:Date:From;
        b=dTFLC+s9w3geKhlAudRwaKTv/6fLFcHl3dHvzhf7Qzx+bDqwOxTIn5vBvkeMlSjth
         SG1IZZjdSKtlsyMGYdupD/cH4SpLm1ySHo2WVDnqJt6LT7Rj7yl5Rlx9TiXFwZGIsz
         XvxRbvRcSEu/25TFVS8Oh/yKnl//VFM+sJv2UFhNgsiVNEmuHDaNh1lVi2W716gPH/
         ciEv0AWJrAqiU/AqSFNaoexNjNVA361DDDxeyZzdaCakryuvVf+VrirWmT8JH1mriL
         YCsUSYzpx4dquGvXXnrgBYsl9kwIjE7WGsc+2hXBpu1Opy4GPklm7U0VEcWfE2BuT4
         eZg6wc/XPIWGQ==
Received: by pali.im (Postfix)
        id BD6D285B; Mon,  8 Mar 2021 18:57:59 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Cc:     Alexander Lobakin <bloodyreaper@yandex.ru>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH] net: dsa: add GRO support via gro_cells
Date:   Mon,  8 Mar 2021 18:57:57 +0100
Message-Id: <20210308175757.8373-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

---
This patch radically increase network performance on DSA setup.

Please include this patch into stable releases.

I have done following tests:

NAT is a tested Espressobin board (ARM64 Marvell Armada 3720 SoC with
Marvell 88E6141 DSA switch) which was configured for IPv4 masquerade.
WAN and LAN are another two static boxes on which was running iperf3.

4.19.179 without e131a5634830047923c694b4ce0c3b31745ff01b

WAN --> NAT --> LAN
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.01  sec   440 MBytes   369 Mbits/sec   12             sender
[  5]   0.00-10.00  sec   437 MBytes   367 Mbits/sec                  receiver

WAN <-- NAT <-- LAN
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   390 MBytes   327 Mbits/sec   90             sender
[  5]   0.00-10.01  sec   388 MBytes   326 Mbits/sec                  receiver

4.19.179 with e131a5634830047923c694b4ce0c3b31745ff01b

WAN --> NAT --> LAN
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.01  sec   616 MBytes   516 Mbits/sec   18             sender
[  5]   0.00-10.00  sec   613 MBytes   515 Mbits/sec                  receiver

WAN <-- NAT <-- LAN
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   573 MBytes   480 Mbits/sec   32             sender
[  5]   0.00-10.01  sec   570 MBytes   478 Mbits/sec                  receiver

5.4.103 without e131a5634830047923c694b4ce0c3b31745ff01b

WAN --> NAT --> LAN
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.01  sec   454 MBytes   380 Mbits/sec   62             sender
[  5]   0.00-10.00  sec   451 MBytes   378 Mbits/sec                  receiver

WAN <-- NAT <-- LAN
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   425 MBytes   356 Mbits/sec  155             sender
[  5]   0.00-10.01  sec   422 MBytes   354 Mbits/sec                  receiver

5.4.103 with e131a5634830047923c694b4ce0c3b31745ff01b

WAN --> NAT --> LAN
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.01  sec   604 MBytes   506 Mbits/sec    8             sender
[  5]   0.00-10.00  sec   601 MBytes   504 Mbits/sec                  receiver

WAN <-- NAT <-- LAN
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   578 MBytes   485 Mbits/sec   79             sender
[  5]   0.00-10.01  sec   575 MBytes   482 Mbits/sec                  receiver
---
 net/dsa/Kconfig    |  1 +
 net/dsa/dsa.c      |  2 +-
 net/dsa/dsa_priv.h |  3 +++
 net/dsa/slave.c    | 10 +++++++++-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 29e2bd5cc5af..7dce11ab2806 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -9,6 +9,7 @@ menuconfig NET_DSA
 	tristate "Distributed Switch Architecture"
 	depends on HAVE_NET_DSA
 	depends on BRIDGE || BRIDGE=n
+	select GRO_CELLS
 	select NET_SWITCHDEV
 	select PHYLINK
 	select NET_DEVLINK
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 43120a3fb06f..ca80f86995e6 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -238,7 +238,7 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (dsa_skb_defer_rx_timestamp(p, skb))
 		return 0;
 
-	netif_receive_skb(skb);
+	gro_cells_receive(&p->gcells, skb);
 
 	return 0;
 }
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index bf9947c577b6..d8e850724d13 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <linux/netpoll.h>
 #include <net/dsa.h>
+#include <net/gro_cells.h>
 
 enum {
 	DSA_NOTIFIER_AGEING_TIME,
@@ -68,6 +69,8 @@ struct dsa_slave_priv {
 
 	struct pcpu_sw_netstats	*stats64;
 
+	struct gro_cells	gcells;
+
 	/* DSA port data, such as switch, port index, etc. */
 	struct dsa_port		*dp;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f734ce0bcb56..06f8874d53ee 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1431,6 +1431,11 @@ int dsa_slave_create(struct dsa_port *port)
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
 	INIT_WORK(&port->xmit_work, dsa_port_xmit_work);
@@ -1443,7 +1448,7 @@ int dsa_slave_create(struct dsa_port *port)
 	ret = dsa_slave_phy_setup(slave_dev);
 	if (ret) {
 		netdev_err(master, "error %d setting up slave phy\n", ret);
-		goto out_free;
+		goto out_gcells;
 	}
 
 	dsa_slave_notify(slave_dev, DSA_PORT_REGISTER);
@@ -1462,6 +1467,8 @@ int dsa_slave_create(struct dsa_port *port)
 	phylink_disconnect_phy(p->dp->pl);
 	rtnl_unlock();
 	phylink_destroy(p->dp->pl);
+out_gcells:
+	gro_cells_destroy(&p->gcells);
 out_free:
 	free_percpu(p->stats64);
 	free_netdev(slave_dev);
@@ -1482,6 +1489,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
 	unregister_netdev(slave_dev);
 	phylink_destroy(dp->pl);
+	gro_cells_destroy(&p->gcells);
 	free_percpu(p->stats64);
 	free_netdev(slave_dev);
 }
-- 
2.20.1

