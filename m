Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23333E465B
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 15:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhHINSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 09:18:53 -0400
Received: from smtpout2.vodafonemail.de ([145.253.239.133]:43054 "EHLO
        smtpout2.vodafonemail.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbhHINSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 09:18:53 -0400
Received: from smtp.vodafone.de (smtpa06.fra-mediabeam.com [10.2.0.37])
        by smtpout2.vodafonemail.de (Postfix) with ESMTP id 1D0941229EA;
        Mon,  9 Aug 2021 15:18:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arcor.de;
        s=vfde-smtpout-mb-15sep; t=1628515110;
        bh=K6ZJO7ajV0EkMKeRt7SwrIYWm5fXqiNznX3/4B4/ooU=;
        h=Date:From:To:Cc:Subject;
        b=gRqvPKny5C+WLT7q6EecAhY5c0CtNjR6G63Oq9l68I/fWeWUKtIvlhiseNxheqqp5
         +EyynglnEcZXJeSn5NnLDEEW8gTrQUAheugi0H+wwMjYMLLZ4EWWGgvxhsTg5wKjZV
         rCAzpnvikR0gawXDJSgjPsw+aKaOZ3aYSYRiU5+I=
Received: from arcor.de (p57a23d17.dip0.t-ipconnect.de [87.162.61.23])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 11CC1140179;
        Mon,  9 Aug 2021 13:18:29 +0000 (UTC)
Date:   Mon, 9 Aug 2021 15:18:14 +0200
From:   Reinhard Speyerer <rspmn@arcor.de>
To:     stable@vger.kernel.org
Cc:     Aleksander Morgado <aleksander@aleksander.es>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Daniele Palmas <dnlplm@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14] qmi_wwan: add network device usage statistics for
 qmimux devices
Message-ID: <20210809131813.GA1009@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-purgate-size: 4789
X-purgate-ID: 155817::1628515109-00003C24-9EC98D62/0/0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 44f82312fe91 ("qmi_wwan: add network device usage statistics
for qmimux devices") of the "qmi_wwan: fix QMAP handling" series
https://lore.kernel.org/netdev/cover.1560287477.git.rspmn@arcor.de
was not part of the AUTOSEL 4.14 patches.

This will introduce a regression for users of this longterm kernel when
multiplexing gets enabled in the forthcoming ModemManager 1.18:
https://lists.freedesktop.org/archives/modemmanager-devel/2021-August/008782.html

Avoid this by adding the missing patch from the series.

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
---
 drivers/net/usb/qmi_wwan.c | 76 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 71 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index cd3865f70578..928219ab0912 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -22,6 +22,7 @@
 #include <linux/usb/cdc.h>
 #include <linux/usb/usbnet.h>
 #include <linux/usb/cdc-wdm.h>
+#include <linux/u64_stats_sync.h>
 
 /* This driver supports wwan (3G/LTE/?) devices using a vendor
  * specific management protocol called Qualcomm MSM Interface (QMI) -
@@ -74,6 +75,7 @@ struct qmimux_hdr {
 struct qmimux_priv {
 	struct net_device *real_dev;
 	u8 mux_id;
+	struct pcpu_sw_netstats __percpu *stats64;
 };
 
 static int qmimux_open(struct net_device *dev)
@@ -100,19 +102,65 @@ static netdev_tx_t qmimux_start_xmit(struct sk_buff *skb, struct net_device *dev
 	struct qmimux_priv *priv = netdev_priv(dev);
 	unsigned int len = skb->len;
 	struct qmimux_hdr *hdr;
+	netdev_tx_t ret;
 
 	hdr = skb_push(skb, sizeof(struct qmimux_hdr));
 	hdr->pad = 0;
 	hdr->mux_id = priv->mux_id;
 	hdr->pkt_len = cpu_to_be16(len);
 	skb->dev = priv->real_dev;
-	return dev_queue_xmit(skb);
+	ret = dev_queue_xmit(skb);
+
+	if (likely(ret == NET_XMIT_SUCCESS || ret == NET_XMIT_CN)) {
+		struct pcpu_sw_netstats *stats64 = this_cpu_ptr(priv->stats64);
+
+		u64_stats_update_begin(&stats64->syncp);
+		stats64->tx_packets++;
+		stats64->tx_bytes += len;
+		u64_stats_update_end(&stats64->syncp);
+	} else {
+		dev->stats.tx_dropped++;
+	}
+
+	return ret;
+}
+
+static void qmimux_get_stats64(struct net_device *net,
+			       struct rtnl_link_stats64 *stats)
+{
+	struct qmimux_priv *priv = netdev_priv(net);
+	unsigned int start;
+	int cpu;
+
+	netdev_stats_to_stats64(stats, &net->stats);
+
+	for_each_possible_cpu(cpu) {
+		struct pcpu_sw_netstats *stats64;
+		u64 rx_packets, rx_bytes;
+		u64 tx_packets, tx_bytes;
+
+		stats64 = per_cpu_ptr(priv->stats64, cpu);
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats64->syncp);
+			rx_packets = stats64->rx_packets;
+			rx_bytes = stats64->rx_bytes;
+			tx_packets = stats64->tx_packets;
+			tx_bytes = stats64->tx_bytes;
+		} while (u64_stats_fetch_retry_irq(&stats64->syncp, start));
+
+		stats->rx_packets += rx_packets;
+		stats->rx_bytes += rx_bytes;
+		stats->tx_packets += tx_packets;
+		stats->tx_bytes += tx_bytes;
+	}
 }
 
 static const struct net_device_ops qmimux_netdev_ops = {
-	.ndo_open       = qmimux_open,
-	.ndo_stop       = qmimux_stop,
-	.ndo_start_xmit = qmimux_start_xmit,
+	.ndo_open        = qmimux_open,
+	.ndo_stop        = qmimux_stop,
+	.ndo_start_xmit  = qmimux_start_xmit,
+	.ndo_get_stats64 = qmimux_get_stats64,
 };
 
 static void qmimux_setup(struct net_device *dev)
@@ -197,8 +245,19 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		}
 
 		skb_put_data(skbn, skb->data + offset + qmimux_hdr_sz, pkt_len);
-		if (netif_rx(skbn) != NET_RX_SUCCESS)
+		if (netif_rx(skbn) != NET_RX_SUCCESS) {
+			net->stats.rx_errors++;
 			return 0;
+		} else {
+			struct pcpu_sw_netstats *stats64;
+			struct qmimux_priv *priv = netdev_priv(net);
+
+			stats64 = this_cpu_ptr(priv->stats64);
+			u64_stats_update_begin(&stats64->syncp);
+			stats64->rx_packets++;
+			stats64->rx_bytes += pkt_len;
+			u64_stats_update_end(&stats64->syncp);
+		}
 
 skip:
 		offset += len + qmimux_hdr_sz;
@@ -222,6 +281,12 @@ static int qmimux_register_device(struct net_device *real_dev, u8 mux_id)
 	priv->mux_id = mux_id;
 	priv->real_dev = real_dev;
 
+	priv->stats64 = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!priv->stats64) {
+		err = -ENOBUFS;
+		goto out_free_newdev;
+	}
+
 	err = register_netdevice(new_dev);
 	if (err < 0)
 		goto out_free_newdev;
@@ -252,6 +317,7 @@ static void qmimux_unregister_device(struct net_device *dev,
 	struct qmimux_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev = priv->real_dev;
 
+	free_percpu(priv->stats64);
 	netdev_upper_dev_unlink(real_dev, dev);
 	unregister_netdevice_queue(dev, head);
 
