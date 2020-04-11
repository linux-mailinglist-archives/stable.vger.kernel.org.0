Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DF21A5155
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgDKMRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728181AbgDKMRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:17:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97EAD20692;
        Sat, 11 Apr 2020 12:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607424;
        bh=43PTV1RJIcy3DrgRfaIJb5QuhUb2LTSBZASiS8wq7uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mK76+ROtvza8wVwADZxvdoXVBZ21fjSFQ1VBugDKlgH0MOFEhR2AWpWlsJ/SkYhk0
         wagh/QOSUqjMAuh25nyzQXXweYGzbOo4Gp2TCbTp2Yk2hkOri2BLLDiRkCtGurykaG
         n/Xul1tNV246l5XDe4K+pmd0Gqx5GPeTeuuJImKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5.4 14/41] r8169: change back SG and TSO to be disabled by default
Date:   Sat, 11 Apr 2020 14:09:23 +0200
Message-Id: <20200411115505.093276503@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 95099c569a9fdbe186a27447dfa8a5a0562d4b7f ]

There has been a number of reports that using SG/TSO on different chip
versions results in tx timeouts. However for a lot of people SG/TSO
works fine. Therefore disable both features by default, but allow users
to enable them. Use at own risk!

Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |   34 ++++++++++++++----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -7167,12 +7167,10 @@ static int rtl_init_one(struct pci_dev *
 
 	netif_napi_add(dev, &tp->napi, rtl8169_poll, NAPI_POLL_WEIGHT);
 
-	dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX;
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX;
+	dev->features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
+			 NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
+			   NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
 	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 		NETIF_F_HIGHDMA;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
@@ -7190,25 +7188,25 @@ static int rtl_init_one(struct pci_dev *
 		dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 
 	if (rtl_chip_supports_csum_v2(tp)) {
-		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
-		dev->features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+		dev->hw_features |= NETIF_F_IPV6_CSUM;
+		dev->features |= NETIF_F_IPV6_CSUM;
+	}
+
+	/* There has been a number of reports that using SG/TSO results in
+	 * tx timeouts. However for a lot of people SG/TSO works fine.
+	 * Therefore disable both features by default, but allow users to
+	 * enable them. Use at own risk!
+	 */
+	if (rtl_chip_supports_csum_v2(tp)) {
+		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6;
 		dev->gso_max_size = RTL_GSO_MAX_SIZE_V2;
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V2;
 	} else {
+		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO;
 		dev->gso_max_size = RTL_GSO_MAX_SIZE_V1;
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V1;
 	}
 
-	/* RTL8168e-vl and one RTL8168c variant are known to have a
-	 * HW issue with TSO.
-	 */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_34 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_22) {
-		dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
-		dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
-		dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
-	}
-
 	dev->hw_features |= NETIF_F_RXALL;
 	dev->hw_features |= NETIF_F_RXFCS;
 


