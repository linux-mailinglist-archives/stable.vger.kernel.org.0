Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9889855D7D7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbiF0L2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbiF0L1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:27:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9B69FD0;
        Mon, 27 Jun 2022 04:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC786B81120;
        Mon, 27 Jun 2022 11:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048E3C341CD;
        Mon, 27 Jun 2022 11:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329217;
        bh=R2goq4APyY+obc39ACpCyOTB+wLBbJ7BRREkey3Mw8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6kZfMaxrfxVoSt/Cfnh2yzKVYqRYYYj2Sr6edT8jAnY1Grs84C2YKipbrWNWOs4y
         cK9eDiThEuL/Pmz0KVBXKrY0j6jg/QtEc1Q4JzGII5/WD+FaAM4+9QSAwSfodn1tLU
         v72t8DJs8Ay2cZPUkKbKArh8YgAFzrU4KY9N4XE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.10 049/102] ice: ethtool: advertise 1000M speeds properly
Date:   Mon, 27 Jun 2022 13:21:00 +0200
Message-Id: <20220627111934.927199535@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

[ Upstream commit c3d184c83ff4b80167e34edfc3d21df424bf27ff ]

In current implementation ice_update_phy_type enables all link modes
for selected speed. This approach doesn't work for 1000M speeds,
because both copper (1000baseT) and optical (1000baseX) standards
cannot be enabled at once.

Fix this, by adding the function `ice_set_phy_type_from_speed()`
for 1000M speeds.

Fixes: 48cb27f2fd18 ("ice: Implement handlers for ethtool PHY/link operations")
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 39 +++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 421fc707f80a..060897eb9cab 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2174,6 +2174,42 @@ ice_setup_autoneg(struct ice_port_info *p, struct ethtool_link_ksettings *ks,
 	return err;
 }
 
+/**
+ * ice_set_phy_type_from_speed - set phy_types based on speeds
+ * and advertised modes
+ * @ks: ethtool link ksettings struct
+ * @phy_type_low: pointer to the lower part of phy_type
+ * @phy_type_high: pointer to the higher part of phy_type
+ * @adv_link_speed: targeted link speeds bitmap
+ */
+static void
+ice_set_phy_type_from_speed(const struct ethtool_link_ksettings *ks,
+			    u64 *phy_type_low, u64 *phy_type_high,
+			    u16 adv_link_speed)
+{
+	/* Handle 1000M speed in a special way because ice_update_phy_type
+	 * enables all link modes, but having mixed copper and optical
+	 * standards is not supported.
+	 */
+	adv_link_speed &= ~ICE_AQ_LINK_SPEED_1000MB;
+
+	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  1000baseT_Full))
+		*phy_type_low |= ICE_PHY_TYPE_LOW_1000BASE_T |
+				 ICE_PHY_TYPE_LOW_1G_SGMII;
+
+	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  1000baseKX_Full))
+		*phy_type_low |= ICE_PHY_TYPE_LOW_1000BASE_KX;
+
+	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  1000baseX_Full))
+		*phy_type_low |= ICE_PHY_TYPE_LOW_1000BASE_SX |
+				 ICE_PHY_TYPE_LOW_1000BASE_LX;
+
+	ice_update_phy_type(phy_type_low, phy_type_high, adv_link_speed);
+}
+
 /**
  * ice_set_link_ksettings - Set Speed and Duplex
  * @netdev: network interface device structure
@@ -2310,7 +2346,8 @@ ice_set_link_ksettings(struct net_device *netdev,
 		adv_link_speed = curr_link_speed;
 
 	/* Convert the advertise link speeds to their corresponded PHY_TYPE */
-	ice_update_phy_type(&phy_type_low, &phy_type_high, adv_link_speed);
+	ice_set_phy_type_from_speed(ks, &phy_type_low, &phy_type_high,
+				    adv_link_speed);
 
 	if (!autoneg_changed && adv_link_speed == curr_link_speed) {
 		netdev_info(netdev, "Nothing changed, exiting without setting anything.\n");
-- 
2.35.1



