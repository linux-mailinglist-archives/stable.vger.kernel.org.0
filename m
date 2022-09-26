Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FF85EA4FA
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbiIZL4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239355AbiIZLzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:55:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272B7792CF;
        Mon, 26 Sep 2022 03:50:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D4D360C09;
        Mon, 26 Sep 2022 10:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AF9C433D6;
        Mon, 26 Sep 2022 10:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189375;
        bh=5S56Dw+R7IJ9FhFrxtaBdZdRBb0t4edjr+D8FgpjfQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmmPnQ95IgLSrrAFNIaRRn/i6qPqz4NfIvewyq0J93xxzhjDuh0jMOxHFYVnHxUoG
         DOzz5FuW0uiHNKeyL369H/08w13CjY0Hua0qI1gKdGusc2s4tvdaFT6q8LWCfrgzsn
         vj+WM33K9MNb2vU7nO7yBlIQn35r8N5Fdx/NAhJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Petr Oros <poros@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.19 136/207] ice: Fix interface being down after reset with link-down-on-close flag on
Date:   Mon, 26 Sep 2022 12:12:05 +0200
Message-Id: <20220926100812.611517103@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

[ Upstream commit 8ac7132704f3fbd2095abb9459e5303ce8c9e559 ]

When performing a reset on ice driver with link-down-on-close flag on
interface would always stay down. Fix this by moving a check of this
flag to ice_stop() that is called only when user wants to bring
interface down.

Fixes: ab4ab73fc1ec ("ice: Add ethtool private flag to make forcing link down optional")
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Petr Oros <poros@redhat.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f963036571e0..48befe1e2872 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6627,7 +6627,7 @@ static void ice_napi_disable_all(struct ice_vsi *vsi)
  */
 int ice_down(struct ice_vsi *vsi)
 {
-	int i, tx_err, rx_err, link_err = 0, vlan_err = 0;
+	int i, tx_err, rx_err, vlan_err = 0;
 
 	WARN_ON(!test_bit(ICE_VSI_DOWN, vsi->state));
 
@@ -6661,20 +6661,13 @@ int ice_down(struct ice_vsi *vsi)
 
 	ice_napi_disable_all(vsi);
 
-	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, vsi->back->flags)) {
-		link_err = ice_force_phys_link_state(vsi, false);
-		if (link_err)
-			netdev_err(vsi->netdev, "Failed to set physical link down, VSI %d error %d\n",
-				   vsi->vsi_num, link_err);
-	}
-
 	ice_for_each_txq(vsi, i)
 		ice_clean_tx_ring(vsi->tx_rings[i]);
 
 	ice_for_each_rxq(vsi, i)
 		ice_clean_rx_ring(vsi->rx_rings[i]);
 
-	if (tx_err || rx_err || link_err || vlan_err) {
+	if (tx_err || rx_err || vlan_err) {
 		netdev_err(vsi->netdev, "Failed to close VSI 0x%04X on switch 0x%04X\n",
 			   vsi->vsi_num, vsi->vsw->sw_id);
 		return -EIO;
@@ -8876,6 +8869,16 @@ int ice_stop(struct net_device *netdev)
 		return -EBUSY;
 	}
 
+	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, vsi->back->flags)) {
+		int link_err = ice_force_phys_link_state(vsi, false);
+
+		if (link_err) {
+			netdev_err(vsi->netdev, "Failed to set physical link down, VSI %d error %d\n",
+				   vsi->vsi_num, link_err);
+			return -EIO;
+		}
+	}
+
 	ice_vsi_close(vsi);
 
 	return 0;
-- 
2.35.1



