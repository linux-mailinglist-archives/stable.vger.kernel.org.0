Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E38A30CBB9
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhBBTdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:33:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhBBN5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:57:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A899264FE7;
        Tue,  2 Feb 2021 13:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273541;
        bh=CGjqQu1nAq5BP/GMotpZSO4w6Zbgf4Zz1tLHJmwVTlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDsc2R0LWXHavOcYNlUl0aMrLogZbAXhK52zMJmCwM4XZpdGTbjIe68wLz2tAdgqw
         lSBTfcoTtit7WyVW05hDABNU6j3AdknaFNBdB/mKcytEpiYdJmKArL5wjr0mYMpjfC
         PHNZPycbG9zQ+FCQIOLAJ/NG+heAl+6E+KkhrEYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corinna Vinschen <vinschen@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/142] igc: fix link speed advertising
Date:   Tue,  2 Feb 2021 14:37:56 +0100
Message-Id: <20210202133002.370719228@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corinna Vinschen <vinschen@redhat.com>

[ Upstream commit 329a3678ec69962aa67c91397efbd46d36635f91 ]

Link speed advertising in igc has two problems:

- When setting the advertisement via ethtool, the link speed is converted
  to the legacy 32 bit representation for the intel PHY code.
  This inadvertently drops ETHTOOL_LINK_MODE_2500baseT_Full_BIT (being
  beyond bit 31).  As a result, any call to `ethtool -s ...' drops the
  2500Mbit/s link speed from the PHY settings.  Only reloading the driver
  alleviates that problem.

  Fix this by converting the ETHTOOL_LINK_MODE_2500baseT_Full_BIT to the
  Intel PHY ADVERTISE_2500_FULL bit explicitly.

- Rather than checking the actual PHY setting, the .get_link_ksettings
  function always fills link_modes.advertising with all link speeds
  the device is capable of.

  Fix this by checking the PHY autoneg_advertised settings and report
  only the actually advertised speeds up to ethtool.

Fixes: 8c5ad0dae93c ("igc: Add ethtool support")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 24 +++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 61d331ce38cdd..831f2f09de5fb 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1675,12 +1675,18 @@ static int igc_ethtool_get_link_ksettings(struct net_device *netdev,
 	cmd->base.phy_address = hw->phy.addr;
 
 	/* advertising link modes */
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Half);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Full);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Half);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Full);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 1000baseT_Full);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 2500baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_10_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Half);
+	if (hw->phy.autoneg_advertised & ADVERTISE_10_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_100_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Half);
+	if (hw->phy.autoneg_advertised & ADVERTISE_100_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_1000_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 1000baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_2500_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 2500baseT_Full);
 
 	/* set autoneg settings */
 	if (hw->mac.autoneg == 1) {
@@ -1792,6 +1798,12 @@ igc_ethtool_set_link_ksettings(struct net_device *netdev,
 
 	ethtool_convert_link_mode_to_legacy_u32(&advertising,
 						cmd->link_modes.advertising);
+	/* Converting to legacy u32 drops ETHTOOL_LINK_MODE_2500baseT_Full_BIT.
+	 * We have to check this and convert it to ADVERTISE_2500_FULL
+	 * (aka ETHTOOL_LINK_MODE_2500baseX_Full_BIT) explicitly.
+	 */
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising, 2500baseT_Full))
+		advertising |= ADVERTISE_2500_FULL;
 
 	if (cmd->base.autoneg == AUTONEG_ENABLE) {
 		hw->mac.autoneg = 1;
-- 
2.27.0



