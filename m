Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2A215790C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgBJNMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:12:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729268AbgBJMi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:56 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A455C20733;
        Mon, 10 Feb 2020 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338335;
        bh=M7LcyCdT53OEmZHnKJU14N5QB/KWIFBO6MRcoqq58Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2oWi4lqYRQUDLC7Gf6+hNzHwR9WvqgEvi+7j/WF3yBoJULGLL1VzWTnNQ2Mxaf2O
         TaLvEP55eNgFx3xgzB4Sr9uelDOY9qMSEDXwIAI5F/TcbgjUwiJxiMnEOXfsqZZy98
         EnkC0d99GAi+qW7Sho1KOEUBQ32JKlDJdvhmP8+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mian Yousaf Kaukab <ykaukab@suse.de>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 265/309] dpaa_eth: support all modes with rate adapting PHYs
Date:   Mon, 10 Feb 2020 04:33:41 -0800
Message-Id: <20200210122432.134778055@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>

[ Upstream commit 73a21fa817f0cc8022dc6226250a86bca727a56d ]

Stop removing modes that are not supported on the system interface
when the connected PHY is capable of rate adaptation. This addresses
an issue with the LS1046ARDB board 10G interface no longer working
with an 1G link partner after autonegotiation support was added
for the Aquantia PHY on board in

commit 09c4c57f7bc4 ("net: phy: aquantia: add support for auto-negotiation configuration")

Before this commit the values advertised by the PHY were not
influenced by the dpaa_eth driver removal of system-side unsupported
modes as the aqr_config_aneg() was basically a no-op. After this
commit, the modes removed by the dpaa_eth driver were no longer
advertised thus autonegotiation with 1G link partners failed.

Reported-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2483,6 +2483,9 @@ static void dpaa_adjust_link(struct net_
 	mac_dev->adjust_link(mac_dev);
 }
 
+/* The Aquantia PHYs are capable of performing rate adaptation */
+#define PHY_VEND_AQUANTIA	0x03a1b400
+
 static int dpaa_phy_init(struct net_device *net_dev)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
@@ -2501,9 +2504,14 @@ static int dpaa_phy_init(struct net_devi
 		return -ENODEV;
 	}
 
-	/* Remove any features not supported by the controller */
-	ethtool_convert_legacy_u32_to_link_mode(mask, mac_dev->if_support);
-	linkmode_and(phy_dev->supported, phy_dev->supported, mask);
+	/* Unless the PHY is capable of rate adaptation */
+	if (mac_dev->phy_if != PHY_INTERFACE_MODE_XGMII ||
+	    ((phy_dev->drv->phy_id & GENMASK(31, 10)) != PHY_VEND_AQUANTIA)) {
+		/* remove any features not supported by the controller */
+		ethtool_convert_legacy_u32_to_link_mode(mask,
+							mac_dev->if_support);
+		linkmode_and(phy_dev->supported, phy_dev->supported, mask);
+	}
 
 	phy_support_asym_pause(phy_dev);
 


