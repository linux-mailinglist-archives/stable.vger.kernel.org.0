Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E114B3A02E1
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbhFHTLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234024AbhFHTH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3929561417;
        Tue,  8 Jun 2021 18:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178040;
        bh=srhBDEFx0xTqgdnx3K5z7j6GsU6W1qaAeE5pQdYItfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ca0v4l8Z5UMU1QnRSeoH6PjoPyzn8Te1KaIoB4zS/q1k7sLD6q8hwhh6oNkmdIdWS
         GKT6J8nBbdKUWD33sUYZ7plDVe/JvfL43NI+255Ouy57o6ti2FKh9qDtJZ9jhWgEVu
         0amquczV9q4fRkp5VT5oNImYM32V5z2I/4yqVsWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Greenwalt <paul.greenwalt@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 055/161] ice: report supported and advertised autoneg using PHY capabilities
Date:   Tue,  8 Jun 2021 20:26:25 +0200
Message-Id: <20210608175947.330419286@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

[ Upstream commit 5cd349c349d6ec52862e550d3576893d35ab8ac2 ]

Ethtool incorrectly reported supported and advertised auto-negotiation
settings for a backplane PHY image which did not support auto-negotiation.
This can occur when using media or PHY type for reporting ethtool
supported and advertised auto-negotiation settings.

Remove setting supported and advertised auto-negotiation settings based
on PHY type in ice_phy_type_to_ethtool(), and MAC type in
ice_get_link_ksettings().

Ethtool supported and advertised auto-negotiation settings should be
based on the PHY image using the AQ command get PHY capabilities with
media. Add setting supported and advertised auto-negotiation settings
based get PHY capabilities with media in ice_get_link_ksettings().

Fixes: 48cb27f2fd18 ("ice: Implement handlers for ethtool PHY/link operations")
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 51 +++-----------------
 1 file changed, 6 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 32ba71a16165..f80fff97d8dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1797,49 +1797,6 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
 						100000baseKR4_Full);
 	}
-
-	/* Autoneg PHY types */
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100BASE_TX ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_1000BASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_1000BASE_KX ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_2500BASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_2500BASE_KX ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_5GBASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_5GBASE_KR ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_10GBASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_10GBASE_KR_CR1 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_CR ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_CR_S ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_CR1 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_KR ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_KR_S ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_KR1 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_40GBASE_CR4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_40GBASE_KR4) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     Autoneg);
-	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_CR2 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_KR2 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_CP ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_KR_PAM4) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     Autoneg);
-	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_CR4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_KR4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_KR_PAM4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_CP2) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     Autoneg);
-	}
 }
 
 #define TEST_SET_BITS_TIMEOUT	50
@@ -1996,9 +1953,7 @@ ice_get_link_ksettings(struct net_device *netdev,
 		ks->base.port = PORT_TP;
 		break;
 	case ICE_MEDIA_BACKPLANE:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
 		ethtool_link_ksettings_add_link_mode(ks, supported, Backplane);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     Backplane);
 		ks->base.port = PORT_NONE;
@@ -2073,6 +2028,12 @@ ice_get_link_ksettings(struct net_device *netdev,
 	if (caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN)
 		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
 
+	/* Set supported and advertised autoneg */
+	if (ice_is_phy_caps_an_enabled(caps)) {
+		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
+		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
+	}
+
 done:
 	kfree(caps);
 	return err;
-- 
2.30.2



