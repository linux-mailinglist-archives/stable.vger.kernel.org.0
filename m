Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E620CE676E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbfJ0VU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731806AbfJ0VUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:20:55 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B88C2070B;
        Sun, 27 Oct 2019 21:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211254;
        bh=PoIO/1DhDvLFSiduFsiNLvyY8C1ess2wQO00EFowzMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpLR7r+3nw7ePkN+RPRJJ33ohna6e76QiCjLrCCMtQfOdrm75JfDXhoflFYB/GCF6
         CKQvYPi8Ioj3PoXjFsbGk0RkQ2wZG9Yzl40EIL0Wdi0oC++GToVXTXdIvyY2gUVZ4M
         nYdnovPhdAEcYzTBSkcOy2HiJ2uQsTDW9fPovFQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 084/197] net: aquantia: correctly handle macvlan and multicast coexistence
Date:   Sun, 27 Oct 2019 22:00:02 +0100
Message-Id: <20191027203356.250906373@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit 9f051db566da1e8110659ab4ab188af1c2510bb4 ]

macvlan and multicast handling is now mixed up.
The explicit issue is that macvlan interface gets broken (no traffic)
after clearing MULTICAST flag on the real interface.

We now do separate logic and consider both ALLMULTI and MULTICAST
flags on the device.

Fixes: 11ba961c9161 ("net: aquantia: Fix IFF_ALLMULTI flag functionality")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c          |    4 -
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c           |   32 +++++++-------
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |    7 +--
 3 files changed, 21 insertions(+), 22 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -194,9 +194,7 @@ static void aq_ndev_set_multicast_settin
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 
-	aq_nic_set_packet_filter(aq_nic, ndev->flags);
-
-	aq_nic_set_multicast_list(aq_nic, ndev);
+	(void)aq_nic_set_multicast_list(aq_nic, ndev);
 }
 
 static int aq_ndo_vlan_rx_add_vid(struct net_device *ndev, __be16 proto,
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -631,9 +631,12 @@ err_exit:
 
 int aq_nic_set_multicast_list(struct aq_nic_s *self, struct net_device *ndev)
 {
-	unsigned int packet_filter = self->packet_filter;
+	const struct aq_hw_ops *hw_ops = self->aq_hw_ops;
+	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
+	unsigned int packet_filter = ndev->flags;
 	struct netdev_hw_addr *ha = NULL;
 	unsigned int i = 0U;
+	int err = 0;
 
 	self->mc_list.count = 0;
 	if (netdev_uc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
@@ -641,29 +644,26 @@ int aq_nic_set_multicast_list(struct aq_
 	} else {
 		netdev_for_each_uc_addr(ha, ndev) {
 			ether_addr_copy(self->mc_list.ar[i++], ha->addr);
-
-			if (i >= AQ_HW_MULTICAST_ADDRESS_MAX)
-				break;
 		}
 	}
 
-	if (i + netdev_mc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
-		packet_filter |= IFF_ALLMULTI;
-	} else {
-		netdev_for_each_mc_addr(ha, ndev) {
-			ether_addr_copy(self->mc_list.ar[i++], ha->addr);
-
-			if (i >= AQ_HW_MULTICAST_ADDRESS_MAX)
-				break;
+	cfg->is_mc_list_enabled = !!(packet_filter & IFF_MULTICAST);
+	if (cfg->is_mc_list_enabled) {
+		if (i + netdev_mc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
+			packet_filter |= IFF_ALLMULTI;
+		} else {
+			netdev_for_each_mc_addr(ha, ndev) {
+				ether_addr_copy(self->mc_list.ar[i++],
+						ha->addr);
+			}
 		}
 	}
 
 	if (i > 0 && i <= AQ_HW_MULTICAST_ADDRESS_MAX) {
-		packet_filter |= IFF_MULTICAST;
 		self->mc_list.count = i;
-		self->aq_hw_ops->hw_multicast_list_set(self->aq_hw,
-						       self->mc_list.ar,
-						       self->mc_list.count);
+		err = hw_ops->hw_multicast_list_set(self->aq_hw,
+						    self->mc_list.ar,
+						    self->mc_list.count);
 	}
 	return aq_nic_set_packet_filter(self, packet_filter);
 }
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -818,14 +818,15 @@ static int hw_atl_b0_hw_packet_filter_se
 				     cfg->is_vlan_force_promisc);
 
 	hw_atl_rpfl2multicast_flr_en_set(self,
-					 IS_FILTER_ENABLED(IFF_ALLMULTI), 0);
+					 IS_FILTER_ENABLED(IFF_ALLMULTI) &&
+					 IS_FILTER_ENABLED(IFF_MULTICAST), 0);
 
 	hw_atl_rpfl2_accept_all_mc_packets_set(self,
-					       IS_FILTER_ENABLED(IFF_ALLMULTI));
+					      IS_FILTER_ENABLED(IFF_ALLMULTI) &&
+					      IS_FILTER_ENABLED(IFF_MULTICAST));
 
 	hw_atl_rpfl2broadcast_en_set(self, IS_FILTER_ENABLED(IFF_BROADCAST));
 
-	cfg->is_mc_list_enabled = IS_FILTER_ENABLED(IFF_MULTICAST);
 
 	for (i = HW_ATL_B0_MAC_MIN; i < HW_ATL_B0_MAC_MAX; ++i)
 		hw_atl_rpfl2_uc_flr_en_set(self,


