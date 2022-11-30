Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB4263DFAC
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiK3Sth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiK3StW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:49:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0F54908C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:49:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF9AAB81CA9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F24C433D7;
        Wed, 30 Nov 2022 18:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834158;
        bh=VRH9qQ4HfRDv0C47MiC7w8hnigGPNPfjkzEkTSjla2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnhA7HMwdIiWLOVC0FK4VqO+oky/7gEpLR45XTvambYHv/6m7+uTJAoKvZcUqfsgV
         YPg8HJdbPoAjLdXNpz89taRA99pcx5S63IRUdkbYtJ8geMJ37v+GeYZ5Vjs1iCKPgT
         qx7hsXRbDH7gb9ipoW8d+KSBgjw/xGZ31dzjGnPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 151/289] net: enetc: preserve TX ring priority across reconfiguration
Date:   Wed, 30 Nov 2022 19:22:16 +0100
Message-Id: <20221130180547.558763105@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 290b5fe096e7dd0aad730d1af4f7f2d9fea43e11 ]

In the blamed commit, a rudimentary reallocation procedure for RX buffer
descriptors was implemented, for the situation when their format changes
between normal (no PTP) and extended (PTP).

enetc_hwtstamp_set() calls enetc_close() and enetc_open() in a sequence,
and this sequence loses information which was previously configured in
the TX BDR Mode Register, specifically via the enetc_set_bdr_prio() call.
The TX ring priority is configured by tc-mqprio and tc-taprio, and
affects important things for TSN such as the TX time of packets. The
issue manifests itself most visibly by the fact that isochron --txtime
reports premature packet transmissions when PTP is first enabled on an
enetc interface.

Save the TX ring priority in a new field in struct enetc_bdr (occupies a
2 byte hole on arm64) in order to make this survive a ring reconfiguration.

Fixes: 434cebabd3a2 ("enetc: Add dynamic allocation of extended Rx BD rings")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Link: https://lore.kernel.org/r/20221122130936.1704151-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  |  8 ++++---
 drivers/net/ethernet/freescale/enetc/enetc.h  |  1 +
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 21 ++++++++++++-------
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e6dbc78f490c..1d8ec1b120a1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2058,7 +2058,7 @@ static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 	/* enable Tx ints by setting pkt thr to 1 */
 	enetc_txbdr_wr(hw, idx, ENETC_TBICR0, ENETC_TBICR0_ICEN | 0x1);
 
-	tbmr = ENETC_TBMR_EN;
+	tbmr = ENETC_TBMR_EN | ENETC_TBMR_SET_PRIO(tx_ring->prio);
 	if (tx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_TX)
 		tbmr |= ENETC_TBMR_VIH;
 
@@ -2461,7 +2461,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
 			tx_ring = priv->tx_ring[i];
-			enetc_set_bdr_prio(hw, tx_ring->index, 0);
+			tx_ring->prio = 0;
+			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
 		}
 
 		return 0;
@@ -2480,7 +2481,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	 */
 	for (i = 0; i < num_tc; i++) {
 		tx_ring = priv->tx_ring[i];
-		enetc_set_bdr_prio(hw, tx_ring->index, i);
+		tx_ring->prio = i;
+		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
 	}
 
 	/* Reset the number of netdev queues based on the TC count */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 748677b2ce1f..bb1b3b0e40e4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -95,6 +95,7 @@ struct enetc_bdr {
 		void __iomem *rcir;
 	};
 	u16 index;
+	u16 prio;
 	int bd_count; /* # of BDs */
 	int next_to_use;
 	int next_to_clean;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 2e783ef73690..5fcb02b00699 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -134,6 +134,7 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_bdr *tx_ring;
 	int err;
 	int i;
 
@@ -142,16 +143,20 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 		if (priv->tx_ring[i]->tsd_enable)
 			return -EBUSY;
 
-	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_set_bdr_prio(hw, priv->tx_ring[i]->index,
-				   taprio->enable ? i : 0);
+	for (i = 0; i < priv->num_tx_rings; i++) {
+		tx_ring = priv->tx_ring[i];
+		tx_ring->prio = taprio->enable ? i : 0;
+		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+	}
 
 	err = enetc_setup_taprio(ndev, taprio);
-
-	if (err)
-		for (i = 0; i < priv->num_tx_rings; i++)
-			enetc_set_bdr_prio(hw, priv->tx_ring[i]->index,
-					   taprio->enable ? 0 : i);
+	if (err) {
+		for (i = 0; i < priv->num_tx_rings; i++) {
+			tx_ring = priv->tx_ring[i];
+			tx_ring->prio = taprio->enable ? 0 : i;
+			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+		}
+	}
 
 	return err;
 }
-- 
2.35.1



