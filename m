Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAFC27CA20
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731934AbgI2MQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730037AbgI2LhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 296F923AC8;
        Tue, 29 Sep 2020 11:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379148;
        bh=GqoM6cRd9EYADEHXrQ0iozMlUKV4gzbkkS4fqV+rltY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMVnKBEEvv25k+EqlYWxRksRGGzN/Fz6a1hg9R5KIoXrlsrVxuEL/AcCHZfDTyuSd
         BNkykFiSQXV3T4y+o/Er0oArG06YwfD9lS7kE/9l+lkFYjlRbg3UvV0x/YXAcSzVqZ
         NEDFNfYL5KY40nVBE/iuC7pEmoJqTnV8y38gFZ/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Usha Ketineni <usha.k.ketineni@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/388] ice: Fix to change Rx/Tx ring descriptor size via ethtool with DCBx
Date:   Tue, 29 Sep 2020 12:56:06 +0200
Message-Id: <20200929110012.192243581@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Usha Ketineni <usha.k.ketineni@intel.com>

[ Upstream commit c0a3665f71a2f086800abea4d9d14d28269089d6 ]

This patch fixes the call trace caused by the kernel when the Rx/Tx
descriptor size change request is initiated via ethtool when DCB is
configured. ice_set_ringparam() should use vsi->num_txq instead of
vsi->alloc_txq as it represents the queues that are enabled in the
driver when DCB is enabled/disabled. Otherwise, queue index being
used can go out of range.

For example, when vsi->alloc_txq has 104 queues and with 3 TCS enabled
via DCB, each TC gets 34 queues, vsi->num_txq will be 102 and only 102
queues will be enabled.

Signed-off-by: Usha Ketineni <usha.k.ketineni@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 62673e27af0e8..fc9ff985a62bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2635,14 +2635,14 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 	netdev_info(netdev, "Changing Tx descriptor count from %d to %d\n",
 		    vsi->tx_rings[0]->count, new_tx_cnt);
 
-	tx_rings = devm_kcalloc(&pf->pdev->dev, vsi->alloc_txq,
+	tx_rings = devm_kcalloc(&pf->pdev->dev, vsi->num_txq,
 				sizeof(*tx_rings), GFP_KERNEL);
 	if (!tx_rings) {
 		err = -ENOMEM;
 		goto done;
 	}
 
-	for (i = 0; i < vsi->alloc_txq; i++) {
+	ice_for_each_txq(vsi, i) {
 		/* clone ring and setup updated count */
 		tx_rings[i] = *vsi->tx_rings[i];
 		tx_rings[i].count = new_tx_cnt;
@@ -2667,14 +2667,14 @@ process_rx:
 	netdev_info(netdev, "Changing Rx descriptor count from %d to %d\n",
 		    vsi->rx_rings[0]->count, new_rx_cnt);
 
-	rx_rings = devm_kcalloc(&pf->pdev->dev, vsi->alloc_rxq,
+	rx_rings = devm_kcalloc(&pf->pdev->dev, vsi->num_rxq,
 				sizeof(*rx_rings), GFP_KERNEL);
 	if (!rx_rings) {
 		err = -ENOMEM;
 		goto done;
 	}
 
-	for (i = 0; i < vsi->alloc_rxq; i++) {
+	ice_for_each_rxq(vsi, i) {
 		/* clone ring and setup updated count */
 		rx_rings[i] = *vsi->rx_rings[i];
 		rx_rings[i].count = new_rx_cnt;
@@ -2712,7 +2712,7 @@ process_link:
 		ice_down(vsi);
 
 		if (tx_rings) {
-			for (i = 0; i < vsi->alloc_txq; i++) {
+			ice_for_each_txq(vsi, i) {
 				ice_free_tx_ring(vsi->tx_rings[i]);
 				*vsi->tx_rings[i] = tx_rings[i];
 			}
@@ -2720,7 +2720,7 @@ process_link:
 		}
 
 		if (rx_rings) {
-			for (i = 0; i < vsi->alloc_rxq; i++) {
+			ice_for_each_rxq(vsi, i) {
 				ice_free_rx_ring(vsi->rx_rings[i]);
 				/* copy the real tail offset */
 				rx_rings[i].tail = vsi->rx_rings[i]->tail;
@@ -2744,7 +2744,7 @@ process_link:
 free_tx:
 	/* error cleanup if the Rx allocations failed after getting Tx */
 	if (tx_rings) {
-		for (i = 0; i < vsi->alloc_txq; i++)
+		ice_for_each_txq(vsi, i)
 			ice_free_tx_ring(&tx_rings[i]);
 		devm_kfree(&pf->pdev->dev, tx_rings);
 	}
-- 
2.25.1



