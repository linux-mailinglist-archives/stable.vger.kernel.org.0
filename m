Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC1743F78
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfFMP5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731503AbfFMIuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F21420851;
        Thu, 13 Jun 2019 08:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415831;
        bh=Va7FBuaInC3NNkPQUrZrlKT+gZoeMrngN8RqkKo+ovk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fv8lUrdsOgJVd90pBx2DCQDrpb24OdUqa0hlx/jD60K1wLZrkxRMD1Q/JJvv5mNrk
         YFmtJLFSYtn5UGe8tuTAy/+gjynPc34YimBklDPcW4mfoatv8sJdNqjhlP/gISXMEI
         K5t9nSIUlHKBI9r/S5XeUPs7uar2Lti6OkLm1SG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yashaswini Raghuram Prathivadi Bhayankaram 
        <yashaswini.raghuram.prathivadi.bhayankaram@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 139/155] ice: Enable LAN_EN for the right recipes
Date:   Thu, 13 Jun 2019 10:34:11 +0200
Message-Id: <20190613075700.466999217@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 277b3a4547b8afbbecdfc52fe7217f018de26c21 ]

In VEB mode, enable LAN_EN bit in the action fields for filter rules
corresponding to the right recipes.

Signed-off-by: Yashaswini Raghuram Prathivadi Bhayankaram <yashaswini.raghuram.prathivadi.bhayankaram@intel.com>
Reviewed-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 29 ++++++++++++++-------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 09d1c314b68f..e40d5f34d59d 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -644,20 +644,31 @@ static void ice_fill_sw_info(struct ice_hw *hw, struct ice_fltr_info *fi)
 	     fi->fltr_act == ICE_FWD_TO_Q ||
 	     fi->fltr_act == ICE_FWD_TO_QGRP)) {
 		fi->lb_en = true;
-		/* Do not set lan_en to TRUE if
+		/* Set lan_en to TRUE if
 		 * 1. The switch is a VEB AND
 		 * 2
-		 * 2.1 The lookup is MAC with unicast addr for MAC, OR
-		 * 2.2 The lookup is MAC_VLAN with unicast addr for MAC
+		 * 2.1 The lookup is VLAN, OR
+		 * 2.2 The lookup is default port mode, OR
+		 * 2.3 The lookup is MAC with mcast or bcast addr for MAC, OR
+		 * 2.4 The lookup is MAC_VLAN with mcast or bcast addr for MAC.
 		 *
-		 * In all other cases, the LAN enable has to be set to true.
+		 * OR
+		 *
+		 * The switch is a VEPA.
+		 *
+		 * In all other cases, the LAN enable has to be set to false.
 		 */
-		if (!(hw->evb_veb &&
-		      ((fi->lkup_type == ICE_SW_LKUP_MAC &&
-			is_unicast_ether_addr(fi->l_data.mac.mac_addr)) ||
-		       (fi->lkup_type == ICE_SW_LKUP_MAC_VLAN &&
-			is_unicast_ether_addr(fi->l_data.mac_vlan.mac_addr)))))
+		if (hw->evb_veb) {
+			if (fi->lkup_type == ICE_SW_LKUP_VLAN ||
+			    fi->lkup_type == ICE_SW_LKUP_DFLT ||
+			    (fi->lkup_type == ICE_SW_LKUP_MAC &&
+			     !is_unicast_ether_addr(fi->l_data.mac.mac_addr)) ||
+			    (fi->lkup_type == ICE_SW_LKUP_MAC_VLAN &&
+			     !is_unicast_ether_addr(fi->l_data.mac.mac_addr)))
+				fi->lan_en = true;
+		} else {
 			fi->lan_en = true;
+		}
 	}
 }
 
-- 
2.20.1



