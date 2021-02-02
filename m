Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33B630C05D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhBBN4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:56:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233240AbhBBNyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:54:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C85B64FD0;
        Tue,  2 Feb 2021 13:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273463;
        bh=SOaf2UYdKImNkE1eG9CEv7A7Dlm5pvs+VHYc2PaHKGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJCggKJmPz5T+q8uIddAfC/ZPmEVMfWDoBtqNi0FDHXixzybgv/ZVvFPgc8Maufu/
         mJv4xuJ0dtE4TBEH1t6TycTAupHPtBsB5d8IYKOg35Xp90wRvSPKPHAFL4ksha/R+y
         KG11xMlfsa0GNJb44iJMOCuzVdYO+kL2yPZUKttw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Nunley <nicholas.d.nunley@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/142] ice: update dev_addr in ice_set_mac_address even if HW filter exists
Date:   Tue,  2 Feb 2021 14:37:52 +0100
Message-Id: <20210202133002.208217811@linuxfoundation.org>
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

From: Nick Nunley <nicholas.d.nunley@intel.com>

[ Upstream commit 13ed5e8a9b9ccd140a79e80283f69d724c9bb2be ]

Fix the driver to copy the MAC address configured in ndo_set_mac_address
into dev_addr, even if the MAC filter already exists in HW. In some
situations (e.g. bonding) the netdev's dev_addr could have been modified
outside of the driver, with no change to the HW filter, so the driver
cannot assume that they match.

Fixes: 757976ab16be ("ice: Fix check for removing/adding mac filters")
Signed-off-by: Nick Nunley <nicholas.d.nunley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2dea4d0e9415c..7986c677cab59 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4887,9 +4887,15 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 		goto err_update_filters;
 	}
 
-	/* Add filter for new MAC. If filter exists, just return success */
+	/* Add filter for new MAC. If filter exists, return success */
 	status = ice_fltr_add_mac(vsi, mac, ICE_FWD_TO_VSI);
 	if (status == ICE_ERR_ALREADY_EXISTS) {
+		/* Although this MAC filter is already present in hardware it's
+		 * possible in some cases (e.g. bonding) that dev_addr was
+		 * modified outside of the driver and needs to be restored back
+		 * to this value.
+		 */
+		memcpy(netdev->dev_addr, mac, netdev->addr_len);
 		netdev_dbg(netdev, "filter for MAC %pM already exists\n", mac);
 		return 0;
 	}
-- 
2.27.0



