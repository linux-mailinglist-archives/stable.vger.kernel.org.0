Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098136948EB
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjBMOyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjBMOyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55280975D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 042C3B81256
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFFDC433D2;
        Mon, 13 Feb 2023 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300054;
        bh=YMdjiCKXA7jQ+03kpyorUGNRsayhU0mtEzX6DYhxBlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbaiZxEl8UlpWoBts2IiLCjt9N7UkmtW6OUBdumHS47n7jbkzrVDeTUHXD2qrSSf9
         yZ1K60BBFO2Cy58Q3B3UkvDI78h8Mr56YLidIRGTyDgh6OvQ2hc0QSRoJaSDG//swH
         c1dzl19olmmBRjspAkfW1ISVqQR4vkq2U85eaU1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brett Creeley <brett.creeley@intel.com>,
        Karen Ostrowska <karen.ostrowska@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/114] ice: Fix disabling Rx VLAN filtering with port VLAN enabled
Date:   Mon, 13 Feb 2023 15:47:56 +0100
Message-Id: <20230213144744.265382447@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit c793f8ea15e312789b5b6b4a5e7b0b92315be5cb ]

If the user turns on the vf-true-promiscuous-support flag, then Rx VLAN
filtering will be disabled if the VF requests to enable promiscuous
mode. When the VF is in a port VLAN, this is the incorrect behavior
because it will allow the VF to receive traffic outside of its port VLAN
domain. Fortunately this only resulted in the VF(s) receiving broadcast
traffic outside of the VLAN domain because all of the VLAN promiscuous
rules are based on the port VLAN ID. Fix this by setting the
.disable_rx_filtering VLAN op to a no-op when a port VLAN is enabled on
the VF.

Also, make sure to make this fix for both Single VLAN Mode and Double
VLAN Mode enabled devices.

Fixes: c31af68a1b94 ("ice: Add outer_vlan_ops and VSI specific VLAN ops implementations")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Karen Ostrowska <karen.ostrowska@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
index 5ecc0ee9a78e0..b1ffb81893d48 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
@@ -44,13 +44,17 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 
 		/* outer VLAN ops regardless of port VLAN config */
 		vlan_ops->add_vlan = ice_vsi_add_vlan;
-		vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
 		vlan_ops->ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
 		vlan_ops->dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
 
 		if (ice_vf_is_port_vlan_ena(vf)) {
 			/* setup outer VLAN ops */
 			vlan_ops->set_port_vlan = ice_vsi_set_outer_port_vlan;
+			/* all Rx traffic should be in the domain of the
+			 * assigned port VLAN, so prevent disabling Rx VLAN
+			 * filtering
+			 */
+			vlan_ops->dis_rx_filtering = noop_vlan;
 			vlan_ops->ena_rx_filtering =
 				ice_vsi_ena_rx_vlan_filtering;
 
@@ -63,6 +67,9 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 			vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
 			vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
 		} else {
+			vlan_ops->dis_rx_filtering =
+				ice_vsi_dis_rx_vlan_filtering;
+
 			if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
 				vlan_ops->ena_rx_filtering = noop_vlan;
 			else
@@ -96,7 +103,14 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 			vlan_ops->set_port_vlan = ice_vsi_set_inner_port_vlan;
 			vlan_ops->ena_rx_filtering =
 				ice_vsi_ena_rx_vlan_filtering;
+			/* all Rx traffic should be in the domain of the
+			 * assigned port VLAN, so prevent disabling Rx VLAN
+			 * filtering
+			 */
+			vlan_ops->dis_rx_filtering = noop_vlan;
 		} else {
+			vlan_ops->dis_rx_filtering =
+				ice_vsi_dis_rx_vlan_filtering;
 			if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
 				vlan_ops->ena_rx_filtering = noop_vlan;
 			else
-- 
2.39.0



