Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671B1451E4B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354010AbhKPAff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344773AbhKOTZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F61D632BA;
        Mon, 15 Nov 2021 19:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003045;
        bh=pxom9vosKScpUwhdgZI+48w0Pp+NciKsrG3hUVGrJ4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPViswDRGavTPE06Tf7BYQeK0PCYb72ou0xPe9JUZLFcePgyK+6D9xdSABf4BnJrT
         rNRN/YwW6JQaHgAYioUxMNLyBld5sx4Yf141DWt8YL5bG85FQgERxg0rxIEU2mv0Dt
         i7o87V+SEV+VyKU7f16Hi1MEmLYgPLtJBgFt7lpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 773/917] ice: Fix replacing VF hardware MAC to existing MAC filter
Date:   Mon, 15 Nov 2021 18:04:28 +0100
Message-Id: <20211115165455.153844055@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index a827c6b653a38..9f5da506d8f4b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3762,6 +3762,7 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
 	struct device *dev = ice_pf_to_dev(vf->pf);
 	u8 *mac_addr = vc_ether_addr->addr;
 	enum ice_status status;
+	int ret = 0;
 
 	/* device MAC already added */
 	if (ether_addr_equal(mac_addr, vf->dev_lan_addr.addr))
@@ -3774,20 +3775,23 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
 
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
 
 	ice_vfhw_mac_add(vf, vc_ether_addr);
 
-	vf->num_mac++;
-
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.33.0



