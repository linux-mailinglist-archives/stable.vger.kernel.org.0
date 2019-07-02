Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29B95CBCD
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfGBIEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:04:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727613AbfGBIEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:04:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B36642184B;
        Tue,  2 Jul 2019 08:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054649;
        bh=z8sr0kB9c0AdYx050iR5Vyi+E79Yy20zeUse9D/Z8B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HU8TA+s2HsGTyItB2oNtzGbovWPKl1Bh107VZjkMtJsaYVX4DEcz6uL+p3XXZKO6C
         zq1xDlsGJzvJUdhEzmtrd8W6Uq7k5m/E84A0Sge0hYgCA6EwJavY4L0XJyn9FZUf+L
         iyvdPWNam8Ka5zeZ2E6bFgTMo0qpra4Nhzpprc5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 43/55] net: aquantia: fix vlans not working over bridged network
Date:   Tue,  2 Jul 2019 10:01:51 +0200
Message-Id: <20190702080126.340348711@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit 48dd73d08d4dda47ee31cc8611fb16840fc16803 ]

In configuration of vlan over bridge over aquantia device
it was found that vlan tagged traffic is dropped on chip.

The reason is that bridge device enables promisc mode,
but in atlantic chip vlan filters will still apply.
So we have to corellate promisc settings with vlan configuration.

The solution is to track in a separate state variable the
need of vlan forced promisc. And also consider generic
promisc configuration when doing vlan filter config.

Fixes: 7975d2aff5af ("net: aquantia: add support of rx-vlan-filter offload")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c       |   10 +++++--
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c           |    1 
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h           |    1 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |   19 +++++++++-----
 4 files changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -843,9 +843,14 @@ int aq_filters_vlans_update(struct aq_ni
 		return err;
 
 	if (aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		if (hweight < AQ_VLAN_MAX_FILTERS)
-			err = aq_hw_ops->hw_filter_vlan_ctrl(aq_hw, true);
+		if (hweight < AQ_VLAN_MAX_FILTERS && hweight > 0) {
+			err = aq_hw_ops->hw_filter_vlan_ctrl(aq_hw,
+				!(aq_nic->packet_filter & IFF_PROMISC));
+			aq_nic->aq_nic_cfg.is_vlan_force_promisc = false;
+		} else {
 		/* otherwise left in promiscue mode */
+			aq_nic->aq_nic_cfg.is_vlan_force_promisc = true;
+		}
 	}
 
 	return err;
@@ -866,6 +871,7 @@ int aq_filters_vlan_offload_off(struct a
 	if (unlikely(!aq_hw_ops->hw_filter_vlan_ctrl))
 		return -EOPNOTSUPP;
 
+	aq_nic->aq_nic_cfg.is_vlan_force_promisc = true;
 	err = aq_hw_ops->hw_filter_vlan_ctrl(aq_hw, false);
 	if (err)
 		return err;
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -117,6 +117,7 @@ void aq_nic_cfg_start(struct aq_nic_s *s
 
 	cfg->link_speed_msk &= cfg->aq_hw_caps->link_speed_msk;
 	cfg->features = cfg->aq_hw_caps->hw_features;
+	cfg->is_vlan_force_promisc = true;
 }
 
 static int aq_nic_update_link_status(struct aq_nic_s *self)
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -36,6 +36,7 @@ struct aq_nic_cfg_s {
 	u32 flow_control;
 	u32 link_speed_msk;
 	u32 wol;
+	bool is_vlan_force_promisc;
 	u16 is_mc_list_enabled;
 	u16 mc_list_count;
 	bool is_autoneg;
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -771,8 +771,15 @@ static int hw_atl_b0_hw_packet_filter_se
 					  unsigned int packet_filter)
 {
 	unsigned int i = 0U;
+	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
+
+	hw_atl_rpfl2promiscuous_mode_en_set(self,
+					    IS_FILTER_ENABLED(IFF_PROMISC));
+
+	hw_atl_rpf_vlan_prom_mode_en_set(self,
+				     IS_FILTER_ENABLED(IFF_PROMISC) ||
+				     cfg->is_vlan_force_promisc);
 
-	hw_atl_rpfl2promiscuous_mode_en_set(self, IS_FILTER_ENABLED(IFF_PROMISC));
 	hw_atl_rpfl2multicast_flr_en_set(self,
 					 IS_FILTER_ENABLED(IFF_ALLMULTI), 0);
 
@@ -781,13 +788,13 @@ static int hw_atl_b0_hw_packet_filter_se
 
 	hw_atl_rpfl2broadcast_en_set(self, IS_FILTER_ENABLED(IFF_BROADCAST));
 
-	self->aq_nic_cfg->is_mc_list_enabled = IS_FILTER_ENABLED(IFF_MULTICAST);
+	cfg->is_mc_list_enabled = IS_FILTER_ENABLED(IFF_MULTICAST);
 
 	for (i = HW_ATL_B0_MAC_MIN; i < HW_ATL_B0_MAC_MAX; ++i)
 		hw_atl_rpfl2_uc_flr_en_set(self,
-					   (self->aq_nic_cfg->is_mc_list_enabled &&
-				    (i <= self->aq_nic_cfg->mc_list_count)) ?
-				    1U : 0U, i);
+					   (cfg->is_mc_list_enabled &&
+					    (i <= cfg->mc_list_count)) ?
+					   1U : 0U, i);
 
 	return aq_hw_err_from_flags(self);
 }
@@ -1079,7 +1086,7 @@ static int hw_atl_b0_hw_vlan_set(struct
 static int hw_atl_b0_hw_vlan_ctrl(struct aq_hw_s *self, bool enable)
 {
 	/* set promisc in case of disabing the vland filter */
-	hw_atl_rpf_vlan_prom_mode_en_set(self, !!!enable);
+	hw_atl_rpf_vlan_prom_mode_en_set(self, !enable);
 
 	return aq_hw_err_from_flags(self);
 }


