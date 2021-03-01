Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB9B3290FB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243088AbhCAUSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242739AbhCAUIG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:08:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB90F6539D;
        Mon,  1 Mar 2021 17:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621573;
        bh=nyr4Eem315W065NlttbVqsORoV2uycVI18g+NiH7aXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKR+3dXSRARsPlfDSDMrCxpXeUEnjrSQ6+ZwypQLywJ8hOHQzSsGcWjBoXt4ilNxF
         Rs+3bZJf4+SPqmug+3OzNSvnf2PxvwQoeyioTTE2kWQlQkVI7iyhdGYZuhq0hcXBWj
         KqpBxHFTBn11FXazY0lXntcEjvdrcNISH+BijNHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 536/775] ice: Fix state bits on LLDP mode switch
Date:   Mon,  1 Mar 2021 17:11:44 +0100
Message-Id: <20210301161227.975518422@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit 0d4907f65dc8fc5e897ad19956fca1acb3b33bc8 ]

DCBX_CAP bits were not being adjusted when switching
between SW and FW controlled LLDP.

Adjust bits to correctly indicate which mode the
LLDP logic is in.

Fixes: b94b013eb626 ("ice: Implement DCBNL support")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h         | 2 --
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c  | 4 ++++
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 7 +++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index fa1e128c24eca..619d93f8b54c4 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -443,9 +443,7 @@ struct ice_pf {
 	struct ice_hw_port_stats stats_prev;
 	struct ice_hw hw;
 	u8 stat_prev_loaded:1; /* has previous stats been loaded */
-#ifdef CONFIG_DCB
 	u16 dcbx_cap;
-#endif /* CONFIG_DCB */
 	u32 tx_timeout_count;
 	unsigned long tx_timeout_last_recovery;
 	u32 tx_timeout_recovery_level;
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index 842d44b63480f..8c133a8be6add 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -160,6 +160,10 @@ static u8 ice_dcbnl_setdcbx(struct net_device *netdev, u8 mode)
 {
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 
+	/* if FW LLDP agent is running, DCBNL not allowed to change mode */
+	if (test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
+		return ICE_DCB_NO_HW_CHG;
+
 	/* No support for LLD_MANAGED modes or CEE+IEEE */
 	if ((mode & DCB_CAP_DCBX_LLD_MANAGED) ||
 	    ((mode & DCB_CAP_DCBX_VER_IEEE) && (mode & DCB_CAP_DCBX_VER_CEE)) ||
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 69c113a4de7e6..d27b9cb3e8082 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -8,6 +8,7 @@
 #include "ice_fltr.h"
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
+#include <net/dcbnl.h>
 
 struct ice_stats {
 	char stat_string[ETH_GSTRING_LEN];
@@ -1238,6 +1239,9 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			status = ice_init_pf_dcb(pf, true);
 			if (status)
 				dev_warn(dev, "Fail to init DCB\n");
+
+			pf->dcbx_cap &= ~DCB_CAP_DCBX_LLD_MANAGED;
+			pf->dcbx_cap |= DCB_CAP_DCBX_HOST;
 		} else {
 			enum ice_status status;
 			bool dcbx_agent_status;
@@ -1280,6 +1284,9 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			if (status)
 				dev_dbg(dev, "Fail to enable MIB change events\n");
 
+			pf->dcbx_cap &= ~DCB_CAP_DCBX_HOST;
+			pf->dcbx_cap |= DCB_CAP_DCBX_LLD_MANAGED;
+
 			ice_nway_reset(netdev);
 		}
 	}
-- 
2.27.0



