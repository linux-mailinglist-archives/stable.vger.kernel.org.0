Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E40259388
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgIAP07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730160AbgIAP05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:26:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38E2D20BED;
        Tue,  1 Sep 2020 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974016;
        bh=ZihNs/9YG8pkJQ6Ms6HZWzOwbifq1mA/2BkkVpkZC9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5Y5rX9RABUjSt9ImtzJ4esJ2C9S3ZTvd3amRD5x1CH2/FUjIWAQYMw8Smevx652A
         6NPPokHwysPhiJrwTmb1cyOmzZ2bg/zpAA9a8orDnQxQfo9XLmhRywxPA48mvy09ra
         JA9GN7k8prMQ7HVHCyS/B5ubBfHl/99m1NUT2L1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mahesh Bandewar <maheshb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 012/214] ipvlan: fix device features
Date:   Tue,  1 Sep 2020 17:08:12 +0200
Message-Id: <20200901150953.556932506@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>

[ Upstream commit d0f5c7076e01fef6fcb86988d9508bf3ce258bd4 ]

Processing NETDEV_FEAT_CHANGE causes IPvlan links to lose
NETIF_F_LLTX feature because of the incorrect handling of
features in ipvlan_fix_features().

--before--
lpaa10:~# ethtool -k ipvl0 | grep tx-lockless
tx-lockless: on [fixed]
lpaa10:~# ethtool -K ipvl0 tso off
Cannot change tcp-segmentation-offload
Actual changes:
vlan-challenged: off [fixed]
tx-lockless: off [fixed]
lpaa10:~# ethtool -k ipvl0 | grep tx-lockless
tx-lockless: off [fixed]
lpaa10:~#

--after--
lpaa10:~# ethtool -k ipvl0 | grep tx-lockless
tx-lockless: on [fixed]
lpaa10:~# ethtool -K ipvl0 tso off
Cannot change tcp-segmentation-offload
Could not change any device features
lpaa10:~# ethtool -k ipvl0 | grep tx-lockless
tx-lockless: on [fixed]
lpaa10:~#

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipvlan/ipvlan_main.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -106,12 +106,21 @@ static void ipvlan_port_destroy(struct n
 	kfree(port);
 }
 
+#define IPVLAN_ALWAYS_ON_OFLOADS \
+	(NETIF_F_SG | NETIF_F_HW_CSUM | \
+	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL)
+
+#define IPVLAN_ALWAYS_ON \
+	(IPVLAN_ALWAYS_ON_OFLOADS | NETIF_F_LLTX | NETIF_F_VLAN_CHALLENGED)
+
 #define IPVLAN_FEATURES \
-	(NETIF_F_SG | NETIF_F_CSUM_MASK | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
+	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
 	 NETIF_F_GSO | NETIF_F_TSO | NETIF_F_GSO_ROBUST | \
 	 NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_GRO | NETIF_F_RXCSUM | \
 	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)
 
+	/* NETIF_F_GSO_ENCAP_ALL NETIF_F_GSO_SOFTWARE Newly added */
+
 #define IPVLAN_STATE_MASK \
 	((1<<__LINK_STATE_NOCARRIER) | (1<<__LINK_STATE_DORMANT))
 
@@ -125,7 +134,9 @@ static int ipvlan_init(struct net_device
 	dev->state = (dev->state & ~IPVLAN_STATE_MASK) |
 		     (phy_dev->state & IPVLAN_STATE_MASK);
 	dev->features = phy_dev->features & IPVLAN_FEATURES;
-	dev->features |= NETIF_F_LLTX | NETIF_F_VLAN_CHALLENGED;
+	dev->features |= IPVLAN_ALWAYS_ON;
+	dev->vlan_features = phy_dev->vlan_features & IPVLAN_FEATURES;
+	dev->vlan_features |= IPVLAN_ALWAYS_ON_OFLOADS;
 	dev->hw_enc_features |= dev->features;
 	dev->gso_max_size = phy_dev->gso_max_size;
 	dev->gso_max_segs = phy_dev->gso_max_segs;
@@ -225,7 +236,14 @@ static netdev_features_t ipvlan_fix_feat
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
 
-	return features & (ipvlan->sfeatures | ~IPVLAN_FEATURES);
+	features |= NETIF_F_ALL_FOR_ALL;
+	features &= (ipvlan->sfeatures | ~IPVLAN_FEATURES);
+	features = netdev_increment_features(ipvlan->phy_dev->features,
+					     features, features);
+	features |= IPVLAN_ALWAYS_ON;
+	features &= (IPVLAN_FEATURES | IPVLAN_ALWAYS_ON);
+
+	return features;
 }
 
 static void ipvlan_change_rx_flags(struct net_device *dev, int change)
@@ -732,10 +750,9 @@ static int ipvlan_device_event(struct no
 
 	case NETDEV_FEAT_CHANGE:
 		list_for_each_entry(ipvlan, &port->ipvlans, pnode) {
-			ipvlan->dev->features = dev->features & IPVLAN_FEATURES;
 			ipvlan->dev->gso_max_size = dev->gso_max_size;
 			ipvlan->dev->gso_max_segs = dev->gso_max_segs;
-			netdev_features_change(ipvlan->dev);
+			netdev_update_features(ipvlan->dev);
 		}
 		break;
 


