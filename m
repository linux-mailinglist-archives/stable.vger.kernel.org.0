Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE562F411
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbfE3Een (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbfE3DNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:22 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC77B23D14;
        Thu, 30 May 2019 03:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186001;
        bh=VBaBHb8eC3MVMoqFn8qJTCXx3lwPrT6NybJ+ftDwyz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6V0rz/+4b/XSUi5qr2PjLcF9Yu/TyEllQQ89CdPIdRI6KRYweSYNst9j0lTETiN/
         10SaF/IvRmJR00w89EEo4cBnr7LnDP6iG3odHCk6ckEHQL0YtHLTNj8+8Dc9scwl00
         8P1HGJk87dzs1vLfYigAFiTgcYaWqg/1C2vO4iPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 053/346] ice: Separate if conditions for ice_set_features()
Date:   Wed, 29 May 2019 20:02:06 -0700
Message-Id: <20190530030543.622387258@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8f529ff912073f778e3cd74e87fb69a36499fc2f ]

Set features can have multiple features turned on|off in a single
call.  Grouping these all in an if/else means after one condition
is met, other conditions/features will not be evaluated.  Break
the if/else statements by feature to ensure all features will be
handled properly.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8725569d11f0a..d083979acc22c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2490,6 +2490,9 @@ static int ice_set_features(struct net_device *netdev,
 	struct ice_vsi *vsi = np->vsi;
 	int ret = 0;
 
+	/* Multiple features can be changed in one call so keep features in
+	 * separate if/else statements to guarantee each feature is checked
+	 */
 	if (features & NETIF_F_RXHASH && !(netdev->features & NETIF_F_RXHASH))
 		ret = ice_vsi_manage_rss_lut(vsi, true);
 	else if (!(features & NETIF_F_RXHASH) &&
@@ -2502,8 +2505,9 @@ static int ice_set_features(struct net_device *netdev,
 	else if (!(features & NETIF_F_HW_VLAN_CTAG_RX) &&
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_RX))
 		ret = ice_vsi_manage_vlan_stripping(vsi, false);
-	else if ((features & NETIF_F_HW_VLAN_CTAG_TX) &&
-		 !(netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
+
+	if ((features & NETIF_F_HW_VLAN_CTAG_TX) &&
+	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
 		ret = ice_vsi_manage_vlan_insertion(vsi);
 	else if (!(features & NETIF_F_HW_VLAN_CTAG_TX) &&
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
-- 
2.20.1



