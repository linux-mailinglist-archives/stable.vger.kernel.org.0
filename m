Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69FD958305D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242549AbiG0RhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242551AbiG0Rgd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:36:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5C485F96;
        Wed, 27 Jul 2022 09:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F885B8200D;
        Wed, 27 Jul 2022 16:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA3AC433D7;
        Wed, 27 Jul 2022 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940590;
        bh=yG0xUPiK8x2rLDphnnDND5z6LPWXqGx5Q78tQ6Iqivs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTp+4AklTU5abllCHKKyBQC9E4mem5r3Hl/jXrW8P9UopRqZLElJFjlxkhZmMXGus
         iBg60bq0VPjGov0OTPubmu4PIVyOfhU6+XAD8vuyxQOLxiZCyJQsxcTYZxuCfcOAeG
         xPtfn9suxCfN6hXUIDd2dLIsYuOHs8EF+ksGPEvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Jun Zhang <xuejun.zhang@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 078/158] iavf: Disallow changing rx/tx-frames and rx/tx-frames-irq
Date:   Wed, 27 Jul 2022 18:12:22 +0200
Message-Id: <20220727161024.642080212@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

[ Upstream commit 4635fd3a9d77581498f34ab9a7e4bcc211bf0a4c ]

Remove from supported_coalesce_params ETHTOOL_COALESCE_MAX_FRAMES
and ETHTOOL_COALESCE_MAX_FRAMES_IRQ. As tx-frames-irq allowed
user to change budget for iavf_clean_tx_irq, remove work_limit
and use define for budget.

Without this patch there would be possibility to change rx/tx-frames
and rx/tx-frames-irq, which for rx/tx-frames did nothing, while for
rx/tx-frames-irq it changed rx/tx-frames and only changed budget
for cleaning NAPI poll.

Fixes: fbb7ddfef253 ("i40evf: core ethtool functionality")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jun Zhang <xuejun.zhang@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h         |  1 -
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 10 ----------
 drivers/net/ethernet/intel/iavf/iavf_main.c    |  1 -
 drivers/net/ethernet/intel/iavf/iavf_txrx.c    |  2 +-
 4 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 86bc61c300a7..2a7b3c085aa9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -64,7 +64,6 @@ struct iavf_vsi {
 	u16 id;
 	DECLARE_BITMAP(state, __IAVF_VSI_STATE_SIZE__);
 	int base_vector;
-	u16 work_limit;
 	u16 qs_handle;
 	void *priv;     /* client driver data reference. */
 };
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 3bb56714beb0..e535d4c3da49 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -692,12 +692,8 @@ static int __iavf_get_coalesce(struct net_device *netdev,
 			       struct ethtool_coalesce *ec, int queue)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
-	struct iavf_vsi *vsi = &adapter->vsi;
 	struct iavf_ring *rx_ring, *tx_ring;
 
-	ec->tx_max_coalesced_frames = vsi->work_limit;
-	ec->rx_max_coalesced_frames = vsi->work_limit;
-
 	/* Rx and Tx usecs per queue value. If user doesn't specify the
 	 * queue, return queue 0's value to represent.
 	 */
@@ -825,12 +821,8 @@ static int __iavf_set_coalesce(struct net_device *netdev,
 			       struct ethtool_coalesce *ec, int queue)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
-	struct iavf_vsi *vsi = &adapter->vsi;
 	int i;
 
-	if (ec->tx_max_coalesced_frames_irq || ec->rx_max_coalesced_frames_irq)
-		vsi->work_limit = ec->tx_max_coalesced_frames_irq;
-
 	if (ec->rx_coalesce_usecs == 0) {
 		if (ec->use_adaptive_rx_coalesce)
 			netif_info(adapter, drv, netdev, "rx-usecs=0, need to disable adaptive-rx for a complete disable\n");
@@ -1969,8 +1961,6 @@ static int iavf_set_rxfh(struct net_device *netdev, const u32 *indir,
 
 static const struct ethtool_ops iavf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
-				     ETHTOOL_COALESCE_MAX_FRAMES |
-				     ETHTOOL_COALESCE_MAX_FRAMES_IRQ |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo		= iavf_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2a8643e66331..2e2c153ce46a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2240,7 +2240,6 @@ int iavf_parse_vf_resource_msg(struct iavf_adapter *adapter)
 
 	adapter->vsi.back = adapter;
 	adapter->vsi.base_vector = 1;
-	adapter->vsi.work_limit = IAVF_DEFAULT_IRQ_WORK;
 	vsi->netdev = adapter->netdev;
 	vsi->qs_handle = adapter->vsi_res->qset_handle;
 	if (adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_RSS_PF) {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 978f651c6b09..7bf8c25dc824 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -194,7 +194,7 @@ static bool iavf_clean_tx_irq(struct iavf_vsi *vsi,
 	struct iavf_tx_buffer *tx_buf;
 	struct iavf_tx_desc *tx_desc;
 	unsigned int total_bytes = 0, total_packets = 0;
-	unsigned int budget = vsi->work_limit;
+	unsigned int budget = IAVF_DEFAULT_IRQ_WORK;
 
 	tx_buf = &tx_ring->tx_bi[i];
 	tx_desc = IAVF_TX_DESC(tx_ring, i);
-- 
2.35.1



