Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8304328BAE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbhCASi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239956AbhCASbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:31:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F18365065;
        Mon,  1 Mar 2021 17:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619422;
        bh=2nOI2ZExrpgPbebxZQ5B72jGMWtLl1wFJBAWaWU2TLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uo7kCJxjyXLkhbEklt0FizuYRUtISjnaeo4kbG/47mMfsTtA1vikeNzp2KvjRm/RM
         fxxLPvzVwXiSXFwvKHcU5kwBXbsiXuYl80IHaYlvcJF0ztTYn6QDFWmmOVZ2Lwe0vT
         0MnBy1u0PvKaCc73abqTZWGaQnSkoz4YgDQ5oRGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Tieman <henry.w.tieman@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 448/663] ice: update the number of available RSS queues
Date:   Mon,  1 Mar 2021 17:11:36 +0100
Message-Id: <20210301161204.062245723@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Tieman <henry.w.tieman@intel.com>

[ Upstream commit 0393e46ac48a6832b1011c233ebcef84f8dbe4f5 ]

It was possible to have Rx queues that were not available for use
by RSS. This would happen when increasing the number of Rx queues
while there was a user defined RSS LUT.

Always update the number of available RSS queues when changing the
number of Rx queues.

Fixes: 87324e747fde ("ice: Implement ethtool ops for channels")
Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 27 ++++++++++++++------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index d27b9cb3e8082..aebebd2102da0 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3328,6 +3328,18 @@ ice_get_channels(struct net_device *dev, struct ethtool_channels *ch)
 	ch->max_other = ch->other_count;
 }
 
+/**
+ * ice_get_valid_rss_size - return valid number of RSS queues
+ * @hw: pointer to the HW structure
+ * @new_size: requested RSS queues
+ */
+static int ice_get_valid_rss_size(struct ice_hw *hw, int new_size)
+{
+	struct ice_hw_common_caps *caps = &hw->func_caps.common_cap;
+
+	return min_t(int, new_size, BIT(caps->rss_table_entry_width));
+}
+
 /**
  * ice_vsi_set_dflt_rss_lut - set default RSS LUT with requested RSS size
  * @vsi: VSI to reconfigure RSS LUT on
@@ -3355,14 +3367,10 @@ static int ice_vsi_set_dflt_rss_lut(struct ice_vsi *vsi, int req_rss_size)
 		return -ENOMEM;
 
 	/* set RSS LUT parameters */
-	if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
+	if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags))
 		vsi->rss_size = 1;
-	} else {
-		struct ice_hw_common_caps *caps = &hw->func_caps.common_cap;
-
-		vsi->rss_size = min_t(int, req_rss_size,
-				      BIT(caps->rss_table_entry_width));
-	}
+	else
+		vsi->rss_size = ice_get_valid_rss_size(hw, req_rss_size);
 
 	/* create/set RSS LUT */
 	ice_fill_rss_lut(lut, vsi->rss_table_size, vsi->rss_size);
@@ -3441,9 +3449,12 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 
 	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
 
-	if (new_rx && !netif_is_rxfh_configured(dev))
+	if (!netif_is_rxfh_configured(dev))
 		return ice_vsi_set_dflt_rss_lut(vsi, new_rx);
 
+	/* Update rss_size due to change in Rx queues */
+	vsi->rss_size = ice_get_valid_rss_size(&pf->hw, new_rx);
+
 	return 0;
 }
 
-- 
2.27.0



