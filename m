Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830EC508C7
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbfFXKVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfFXKVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:21:32 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC4E220645;
        Mon, 24 Jun 2019 10:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371691;
        bh=SZxykeU4Vsmcs7B5/PXtHkSQeFdz7khlY6jwLUstk3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3TsJj/oKOZ/t+4JONCE+uX8mrWvpWh/IKI+7avhFmKds3x+9qvGjXh0kraQB2QPO
         cusoAQC5FNYSNbN8W65LdsuTU04UvL97xZxMw+4WutVdGFVbW1m/xtCGWUOYwpymV/
         xfB3AjBhXhGdW6VxRSghx4AN1O2AdWYOTMUGLjbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 076/121] net: phylink: avoid reducing support mask
Date:   Mon, 24 Jun 2019 17:56:48 +0800
Message-Id: <20190624092324.772292576@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 77316763321ee4050f0576ffd472183aa90dcb30 ]

Avoid reducing the support mask as a result of the interface type
selected for SFP modules, or when setting the link settings through
ethtool - this should only change when the supported link modes of
the hardware combination change.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index efa31fcda505..611dfc3d89a0 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1080,6 +1080,7 @@ EXPORT_SYMBOL_GPL(phylink_ethtool_ksettings_get);
 int phylink_ethtool_ksettings_set(struct phylink *pl,
 				  const struct ethtool_link_ksettings *kset)
 {
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);
 	struct ethtool_link_ksettings our_kset;
 	struct phylink_link_state config;
 	int ret;
@@ -1090,11 +1091,12 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	    kset->base.autoneg != AUTONEG_ENABLE)
 		return -EINVAL;
 
+	linkmode_copy(support, pl->supported);
 	config = pl->link_config;
 
 	/* Mask out unsupported advertisements */
 	linkmode_and(config.advertising, kset->link_modes.advertising,
-		     pl->supported);
+		     support);
 
 	/* FIXME: should we reject autoneg if phy/mac does not support it? */
 	if (kset->base.autoneg == AUTONEG_DISABLE) {
@@ -1104,7 +1106,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		 * duplex.
 		 */
 		s = phy_lookup_setting(kset->base.speed, kset->base.duplex,
-				       pl->supported, false);
+				       support, false);
 		if (!s)
 			return -EINVAL;
 
@@ -1133,7 +1135,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		__set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising);
 	}
 
-	if (phylink_validate(pl, pl->supported, &config))
+	if (phylink_validate(pl, support, &config))
 		return -EINVAL;
 
 	/* If autonegotiation is enabled, we must have an advertisement */
@@ -1583,6 +1585,7 @@ static int phylink_sfp_module_insert(void *upstream,
 {
 	struct phylink *pl = upstream;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(support1);
 	struct phylink_link_state config;
 	phy_interface_t iface;
 	int ret = 0;
@@ -1610,6 +1613,8 @@ static int phylink_sfp_module_insert(void *upstream,
 		return ret;
 	}
 
+	linkmode_copy(support1, support);
+
 	iface = sfp_select_interface(pl->sfp_bus, id, config.advertising);
 	if (iface == PHY_INTERFACE_MODE_NA) {
 		netdev_err(pl->netdev,
@@ -1619,7 +1624,7 @@ static int phylink_sfp_module_insert(void *upstream,
 	}
 
 	config.interface = iface;
-	ret = phylink_validate(pl, support, &config);
+	ret = phylink_validate(pl, support1, &config);
 	if (ret) {
 		netdev_err(pl->netdev, "validation of %s/%s with support %*pb failed: %d\n",
 			   phylink_an_mode_str(MLO_AN_INBAND),
-- 
2.20.1



