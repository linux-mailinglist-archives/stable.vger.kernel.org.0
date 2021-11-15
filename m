Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C454525D9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240368AbhKPB7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:59:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240542AbhKOSKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:10:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 489C4633BB;
        Mon, 15 Nov 2021 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998434;
        bh=eLp/7aEo48UkeCzA6HrLbBAkSv9PkYLmMGl6VmrWvE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtYN0+3/wUbv+Eo0M2xzCplqTEjhxtAmVdJ7FiwQhJYt5iGug+MiL0JHn8fjtf9e/
         0x4hjtCuV9+DRa2veV0OjAGPjMvg5pX6J0wEuaNmKfdyDMme+U2vYfXT9e3PLbyT4b
         7fO1Dvs2RmgXu+cRYNEet5J3+Mzr0nThq5iEsPRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 509/575] ice: Fix replacing VF hardware MAC to existing MAC filter
Date:   Mon, 15 Nov 2021 18:03:54 +0100
Message-Id: <20211115165401.292239833@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

[ Upstream commit ce572a5b88d5ca6737b5e23da9892792fd708ad3 ]

VF was not able to change its hardware MAC address in case
the new address was already present in the MAC filter list.
Change the handling of VF add mac request to not return
if requested MAC address is already present on the list
and check if its hardware MAC needs to be updated in this case.

Fixes: ed4c068d46f6 ("ice: Enable ip link show on the PF to display VF unicast MAC(s)")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index c9f82fd3cf48d..22e23199c92c1 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3068,6 +3068,7 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi, u8 *mac_addr)
 {
 	struct device *dev = ice_pf_to_dev(vf->pf);
 	enum ice_status status;
+	int ret = 0;
 
 	/* default unicast MAC already added */
 	if (ether_addr_equal(mac_addr, vf->dflt_lan_addr.addr))
@@ -3080,13 +3081,18 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi, u8 *mac_addr)
 
 	status = ice_fltr_add_mac(vsi, mac_addr, ICE_FWD_TO_VSI);
 	if (status == ICE_ERR_ALREADY_EXISTS) {
-		dev_err(dev, "MAC %pM already exists for VF %d\n", mac_addr,
+		dev_dbg(dev, "MAC %pM already exists for VF %d\n", mac_addr,
 			vf->vf_id);
-		return -EEXIST;
+		/* don't return since we might need to update
+		 * the primary MAC in ice_vfhw_mac_add() below
+		 */
+		ret = -EEXIST;
 	} else if (status) {
 		dev_err(dev, "Failed to add MAC %pM for VF %d\n, error %s\n",
 			mac_addr, vf->vf_id, ice_stat_str(status));
 		return -EIO;
+	} else {
+		vf->num_mac++;
 	}
 
 	/* Set the default LAN address to the latest unicast MAC address added
@@ -3096,9 +3102,7 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi, u8 *mac_addr)
 	if (is_unicast_ether_addr(mac_addr))
 		ether_addr_copy(vf->dflt_lan_addr.addr, mac_addr);
 
-	vf->num_mac++;
-
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.33.0



