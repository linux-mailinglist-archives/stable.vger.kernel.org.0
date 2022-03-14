Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317E04D8260
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbiCNMDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240358AbiCNMCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:02:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F22949266;
        Mon, 14 Mar 2022 05:00:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D4D8B80DC2;
        Mon, 14 Mar 2022 11:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4CAC340E9;
        Mon, 14 Mar 2022 11:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259181;
        bh=dtL/cLxJRtsrOrlvTQoFNZotprBKKBalwSUK3r+2d8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4ehrDeuBF1M6PFKaQX6enVUBpqqKOcAaNVoIzRyFcnvnU75CDWehwPapUZxEINxb
         zRqu3Il3ZfWqGe5RB1sSkE+U86Ht1lnIIjSGoAkqDl/PggMFL/0glTRSveIhTolN+Y
         lTSZX+3eLAamxycyULPIzoNaCABTFaiyzETPoP/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/71] ice: Rename a couple of variables
Date:   Mon, 14 Mar 2022 12:53:13 +0100
Message-Id: <20220314112738.497397150@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

[ Upstream commit 0be39bb4c7c8c358f7baf10296db2426f7cf814c ]

In ice_set_link_ksettings, change 'abilities' to 'phy_caps' and 'p' to
'pi'. This is more consistent with similar usages elsewhere in the
driver.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 50 ++++++++++----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 300fd5d0ff32..0582fca5e07f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2187,12 +2187,12 @@ ice_set_link_ksettings(struct net_device *netdev,
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ethtool_link_ksettings safe_ks, copy_ks;
-	struct ice_aqc_get_phy_caps_data *abilities;
 	u8 autoneg, timeout = TEST_SET_BITS_TIMEOUT;
+	struct ice_aqc_get_phy_caps_data *phy_caps;
 	struct ice_aqc_set_phy_cfg_data config;
 	u16 adv_link_speed, curr_link_speed;
 	struct ice_pf *pf = np->vsi->back;
-	struct ice_port_info *p;
+	struct ice_port_info *pi;
 	u8 autoneg_changed = 0;
 	enum ice_status status;
 	u64 phy_type_high = 0;
@@ -2200,25 +2200,25 @@ ice_set_link_ksettings(struct net_device *netdev,
 	int err = 0;
 	bool linkup;
 
-	p = np->vsi->port_info;
+	pi = np->vsi->port_info;
 
-	if (!p)
+	if (!pi)
 		return -EOPNOTSUPP;
 
-	if (p->phy.media_type != ICE_MEDIA_BASET &&
-	    p->phy.media_type != ICE_MEDIA_FIBER &&
-	    p->phy.media_type != ICE_MEDIA_BACKPLANE &&
-	    p->phy.media_type != ICE_MEDIA_DA &&
-	    p->phy.link_info.link_info & ICE_AQ_LINK_UP)
+	if (pi->phy.media_type != ICE_MEDIA_BASET &&
+	    pi->phy.media_type != ICE_MEDIA_FIBER &&
+	    pi->phy.media_type != ICE_MEDIA_BACKPLANE &&
+	    pi->phy.media_type != ICE_MEDIA_DA &&
+	    pi->phy.link_info.link_info & ICE_AQ_LINK_UP)
 		return -EOPNOTSUPP;
 
-	abilities = kzalloc(sizeof(*abilities), GFP_KERNEL);
-	if (!abilities)
+	phy_caps = kzalloc(sizeof(*phy_caps), GFP_KERNEL);
+	if (!phy_caps)
 		return -ENOMEM;
 
 	/* Get the PHY capabilities based on media */
-	status = ice_aq_get_phy_caps(p, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
-				     abilities, NULL);
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
+				     phy_caps, NULL);
 	if (status) {
 		err = -EAGAIN;
 		goto done;
@@ -2280,26 +2280,26 @@ ice_set_link_ksettings(struct net_device *netdev,
 	 * configuration is initialized during probe from PHY capabilities
 	 * software mode, and updated on set PHY configuration.
 	 */
-	memcpy(&config, &p->phy.curr_user_phy_cfg, sizeof(config));
+	memcpy(&config, &pi->phy.curr_user_phy_cfg, sizeof(config));
 
 	config.caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
 
 	/* Check autoneg */
-	err = ice_setup_autoneg(p, &safe_ks, &config, autoneg, &autoneg_changed,
+	err = ice_setup_autoneg(pi, &safe_ks, &config, autoneg, &autoneg_changed,
 				netdev);
 
 	if (err)
 		goto done;
 
 	/* Call to get the current link speed */
-	p->phy.get_link_info = true;
-	status = ice_get_link_status(p, &linkup);
+	pi->phy.get_link_info = true;
+	status = ice_get_link_status(pi, &linkup);
 	if (status) {
 		err = -EAGAIN;
 		goto done;
 	}
 
-	curr_link_speed = p->phy.link_info.link_speed;
+	curr_link_speed = pi->phy.link_info.link_speed;
 	adv_link_speed = ice_ksettings_find_adv_link_speed(ks);
 
 	/* If speed didn't get set, set it to what it currently is.
@@ -2318,7 +2318,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	}
 
 	/* save the requested speeds */
-	p->phy.link_info.req_speeds = adv_link_speed;
+	pi->phy.link_info.req_speeds = adv_link_speed;
 
 	/* set link and auto negotiation so changes take effect */
 	config.caps |= ICE_AQ_PHY_ENA_LINK;
@@ -2334,9 +2334,9 @@ ice_set_link_ksettings(struct net_device *netdev,
 	 * for set PHY configuration
 	 */
 	config.phy_type_high = cpu_to_le64(phy_type_high) &
-			abilities->phy_type_high;
+			phy_caps->phy_type_high;
 	config.phy_type_low = cpu_to_le64(phy_type_low) &
-			abilities->phy_type_low;
+			phy_caps->phy_type_low;
 
 	if (!(config.phy_type_high || config.phy_type_low)) {
 		/* If there is no intersection and lenient mode is enabled, then
@@ -2356,7 +2356,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	}
 
 	/* If link is up put link down */
-	if (p->phy.link_info.link_info & ICE_AQ_LINK_UP) {
+	if (pi->phy.link_info.link_info & ICE_AQ_LINK_UP) {
 		/* Tell the OS link is going down, the link will go
 		 * back up when fw says it is ready asynchronously
 		 */
@@ -2366,7 +2366,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	}
 
 	/* make the aq call */
-	status = ice_aq_set_phy_cfg(&pf->hw, p, &config, NULL);
+	status = ice_aq_set_phy_cfg(&pf->hw, pi, &config, NULL);
 	if (status) {
 		netdev_info(netdev, "Set phy config failed,\n");
 		err = -EAGAIN;
@@ -2374,9 +2374,9 @@ ice_set_link_ksettings(struct net_device *netdev,
 	}
 
 	/* Save speed request */
-	p->phy.curr_user_speed_req = adv_link_speed;
+	pi->phy.curr_user_speed_req = adv_link_speed;
 done:
-	kfree(abilities);
+	kfree(phy_caps);
 	clear_bit(__ICE_CFG_BUSY, pf->state);
 
 	return err;
-- 
2.34.1



