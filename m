Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC31D259CEA
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732616AbgIARVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728678AbgIAPMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:12:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 820FE206FA;
        Tue,  1 Sep 2020 15:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973138;
        bh=lPuRvbuP4YWG81d4Jjr40/ThGhB4llkkUYjH6HigtVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4Ra2b68/AwMgmVaNvHNF7krniSDU6hWOhUIHYJnm3d/y1P8qaJazw/JnRfSgbJF4
         Gpw2gi/z5/gKF/4AzWFFkanvdzDEGw4TP5YXqkfm3BTfgt+z9mDBukRXkqZZbbnNiR
         FM9jQ6IC3xRHRrco+Tal8i0ZHTCkuO0YyeRRB+uQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mahesh Bandewar <maheshb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 03/62] ipvlan: fix device features
Date:   Tue,  1 Sep 2020 17:09:46 +0200
Message-Id: <20200901150920.884790983@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
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
 drivers/net/ipvlan/ipvlan_main.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -87,12 +87,21 @@ static void ipvlan_port_destroy(struct n
 static struct lock_class_key ipvlan_netdev_xmit_lock_key;
 static struct lock_class_key ipvlan_netdev_addr_lock_key;
 
+#define IPVLAN_ALWAYS_ON_OFLOADS \
+	(NETIF_F_SG | NETIF_F_HW_CSUM | \
+	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL)
+
+#define IPVLAN_ALWAYS_ON \
+	(IPVLAN_ALWAYS_ON_OFLOADS | NETIF_F_LLTX | NETIF_F_VLAN_CHALLENGED)
+
 #define IPVLAN_FEATURES \
 	(NETIF_F_SG | NETIF_F_ALL_CSUM | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
 	 NETIF_F_GSO | NETIF_F_TSO | NETIF_F_UFO | NETIF_F_GSO_ROBUST | \
 	 NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_GRO | NETIF_F_RXCSUM | \
 	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)
 
+	/* NETIF_F_GSO_ENCAP_ALL NETIF_F_GSO_SOFTWARE Newly added */
+
 #define IPVLAN_STATE_MASK \
 	((1<<__LINK_STATE_NOCARRIER) | (1<<__LINK_STATE_DORMANT))
 
@@ -117,7 +126,9 @@ static int ipvlan_init(struct net_device
 	dev->state = (dev->state & ~IPVLAN_STATE_MASK) |
 		     (phy_dev->state & IPVLAN_STATE_MASK);
 	dev->features = phy_dev->features & IPVLAN_FEATURES;
-	dev->features |= NETIF_F_LLTX;
+	dev->features |= IPVLAN_ALWAYS_ON;
+	dev->vlan_features = phy_dev->vlan_features & IPVLAN_FEATURES;
+	dev->vlan_features |= IPVLAN_ALWAYS_ON_OFLOADS;
 	dev->gso_max_size = phy_dev->gso_max_size;
 	dev->hard_header_len = phy_dev->hard_header_len;
 
@@ -201,7 +212,14 @@ static netdev_features_t ipvlan_fix_feat
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
@@ -590,9 +608,8 @@ static int ipvlan_device_event(struct no
 
 	case NETDEV_FEAT_CHANGE:
 		list_for_each_entry(ipvlan, &port->ipvlans, pnode) {
-			ipvlan->dev->features = dev->features & IPVLAN_FEATURES;
 			ipvlan->dev->gso_max_size = dev->gso_max_size;
-			netdev_features_change(ipvlan->dev);
+			netdev_update_features(ipvlan->dev);
 		}
 		break;
 


