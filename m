Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06DD4D824B
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbiCNMCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240227AbiCNMCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:02:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C3B49F8D;
        Mon, 14 Mar 2022 04:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E62FEB80DEE;
        Mon, 14 Mar 2022 11:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0E1C36AE2;
        Mon, 14 Mar 2022 11:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259171;
        bh=VM6X274W0Wr5DIKP2FKOnktiZ+KuYhPqpw5G1T/twVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQ7vQbCxG2htyoZelnCnSiLZqDXKbCojBK35L00jFkvGkmW3dVbx/H6CRL2Z+1gR3
         FWIKt8knGgr3uXa7+ehwvoCEE/KRkru3G8t/qjRGE3vxmiiSuMHbieB+OvpLETdT4D
         HEp9BuQAstQi7odbSDl3U1OFFHhiKLiyxQIR/sNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/71] ice: Remove unnecessary checker loop
Date:   Mon, 14 Mar 2022 12:53:12 +0100
Message-Id: <20220314112738.469709253@linuxfoundation.org>
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

[ Upstream commit fd3dc1655eda6173566d56eaeb54f27ab4c9e33c ]

The loop checking for PF VSI doesn't make any sense. The VSI type
backing the netdev passed to ice_set_link_ksettings will always be
of type ICE_PF_VSI. Remove it.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index be02f8f4d854..300fd5d0ff32 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2189,8 +2189,8 @@ ice_set_link_ksettings(struct net_device *netdev,
 	struct ethtool_link_ksettings safe_ks, copy_ks;
 	struct ice_aqc_get_phy_caps_data *abilities;
 	u8 autoneg, timeout = TEST_SET_BITS_TIMEOUT;
-	u16 adv_link_speed, curr_link_speed, idx;
 	struct ice_aqc_set_phy_cfg_data config;
+	u16 adv_link_speed, curr_link_speed;
 	struct ice_pf *pf = np->vsi->back;
 	struct ice_port_info *p;
 	u8 autoneg_changed = 0;
@@ -2205,14 +2205,6 @@ ice_set_link_ksettings(struct net_device *netdev,
 	if (!p)
 		return -EOPNOTSUPP;
 
-	/* Check if this is LAN VSI */
-	ice_for_each_vsi(pf, idx)
-		if (pf->vsi[idx]->type == ICE_VSI_PF) {
-			if (np->vsi != pf->vsi[idx])
-				return -EOPNOTSUPP;
-			break;
-		}
-
 	if (p->phy.media_type != ICE_MEDIA_BASET &&
 	    p->phy.media_type != ICE_MEDIA_FIBER &&
 	    p->phy.media_type != ICE_MEDIA_BACKPLANE &&
-- 
2.34.1



