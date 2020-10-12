Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F78728B7C3
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389731AbgJLNqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:46:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389781AbgJLNqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:46:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65A6D21D7F;
        Mon, 12 Oct 2020 13:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510368;
        bh=f/CWubi3kGhWIato8Ba5Qtot2GtCSQYbLgmsShbRT1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEBf/UIsQyTglROzdLL/RZ5EyMfYIZ+O25UizX5wotv7x+MmYbmo6q4v1gx2bzM0I
         rKMwRJbxkEOYHf5JIKwUSmfE4+RpbraUTLcQMwDgCxHRi7N8UhJM7T9AOR7RIE6SN3
         kYjjX/6ObwJzKx44Wnag2ah590XHi1dicxAe8YRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronak Doshi <doshir@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 069/124] vmxnet3: fix cksum offload issues for non-udp tunnels
Date:   Mon, 12 Oct 2020 15:31:13 +0200
Message-Id: <20201012133150.191887406@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronak Doshi <doshir@vmware.com>

[ Upstream commit 1dac3b1bc66dc68dbb0c9f43adac71a7d0a0331a ]

Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support") added support for encapsulation offload. However, the inner
offload capability is to be restrictued to UDP tunnels.

This patch fixes the issue for non-udp tunnels by adding features
check capability and filtering appropriate features for non-udp tunnels.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c     |  5 ++---
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 28 +++++++++++++++++++++++++++
 drivers/net/vmxnet3/vmxnet3_int.h     |  4 ++++
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 2818015324b8b..336504b7531d9 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1032,7 +1032,6 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 	/* Use temporary descriptor to avoid touching bits multiple times */
 	union Vmxnet3_GenericDesc tempTxDesc;
 #endif
-	struct udphdr *udph;
 
 	count = txd_estimate(skb);
 
@@ -1135,8 +1134,7 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 			gdesc->txd.om = VMXNET3_OM_ENCAP;
 			gdesc->txd.msscof = ctx.mss;
 
-			udph = udp_hdr(skb);
-			if (udph->check)
+			if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM)
 				gdesc->txd.oco = 1;
 		} else {
 			gdesc->txd.hlen = ctx.l4_offset + ctx.l4_hdr_size;
@@ -3371,6 +3369,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		.ndo_change_mtu = vmxnet3_change_mtu,
 		.ndo_fix_features = vmxnet3_fix_features,
 		.ndo_set_features = vmxnet3_set_features,
+		.ndo_features_check = vmxnet3_features_check,
 		.ndo_get_stats64 = vmxnet3_get_stats64,
 		.ndo_tx_timeout = vmxnet3_tx_timeout,
 		.ndo_set_rx_mode = vmxnet3_set_mc,
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index def27afa1c69f..3586677920046 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -267,6 +267,34 @@ netdev_features_t vmxnet3_fix_features(struct net_device *netdev,
 	return features;
 }
 
+netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
+					 struct net_device *netdev,
+					 netdev_features_t features)
+{
+	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+
+	/* Validate if the tunneled packet is being offloaded by the device */
+	if (VMXNET3_VERSION_GE_4(adapter) &&
+	    skb->encapsulation && skb->ip_summed == CHECKSUM_PARTIAL) {
+		u8 l4_proto = 0;
+
+		switch (vlan_get_protocol(skb)) {
+		case htons(ETH_P_IP):
+			l4_proto = ip_hdr(skb)->protocol;
+			break;
+		case htons(ETH_P_IPV6):
+			l4_proto = ipv6_hdr(skb)->nexthdr;
+			break;
+		default:
+			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		}
+
+		if (l4_proto != IPPROTO_UDP)
+			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	}
+	return features;
+}
+
 static void vmxnet3_enable_encap_offloads(struct net_device *netdev)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 5d2b062215a27..d958b92c94299 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -470,6 +470,10 @@ vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
 netdev_features_t
 vmxnet3_fix_features(struct net_device *netdev, netdev_features_t features);
 
+netdev_features_t
+vmxnet3_features_check(struct sk_buff *skb,
+		       struct net_device *netdev, netdev_features_t features);
+
 int
 vmxnet3_set_features(struct net_device *netdev, netdev_features_t features);
 
-- 
2.25.1



