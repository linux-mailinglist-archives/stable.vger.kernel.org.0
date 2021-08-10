Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AD33E7E9E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhHJRed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232486AbhHJRd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E607610CB;
        Tue, 10 Aug 2021 17:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616816;
        bh=kTL4LeyD2GBYpvWFwzSRY46yXARtbeB/NXrR0cRdSSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7PGfS7jnhEelGfmGqpCQE2mfsFQ3Lv0NyFNPr08BMi5euEaCTvtTeG3x0fhG47zb
         IE5Z5qhQUDXuaI5PgU5l6R4aOVln+iAMnSPmSJ05z0uSDq/coUvtwQVCG2+H9JMGwI
         6yZnSWYt6OPT8SyCmFpzuuNgdW9K9yXxhYpejRAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Reinhard Speyerer <rspmn@arcor.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 48/54] qmi_wwan: add network device usage statistics for qmimux devices
Date:   Tue, 10 Aug 2021 19:30:42 +0200
Message-Id: <20210810172945.785406713@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinhard Speyerer <rspmn@arcor.de>

commit 44f82312fe9113bab6642f4d0eab6b1b7902b6e1 upstream.

Add proper network device usage statistics for qmimux devices
instead of reporting all-zero values for them.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Cc: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |   76 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 5 deletions(-)

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
@@ -100,19 +102,65 @@ static netdev_tx_t qmimux_start_xmit(str
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
@@ -197,8 +245,19 @@ static int qmimux_rx_fixup(struct usbnet
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
@@ -222,6 +281,12 @@ static int qmimux_register_device(struct
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
@@ -252,6 +317,7 @@ static void qmimux_unregister_device(str
 	struct qmimux_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev = priv->real_dev;
 
+	free_percpu(priv->stats64);
 	netdev_upper_dev_unlink(real_dev, dev);
 	unregister_netdevice_queue(dev, head);
 


