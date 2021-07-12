Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06773C5440
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344059AbhGLH5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347681AbhGLHxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AE7C613D2;
        Mon, 12 Jul 2021 07:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076253;
        bh=ln+t5VxhROXKBz66MmlU7JLtuWd1efLc+sppj0XjlUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ec58xoK7DPVZ1yGrqOgiWfs/BcBCB+Akbd4GyEn53toIpizaP0VsGrZLnArp+TAR5
         lIYjmXmIuy0KK93moTVP67d05NNgmRciBxEXySZOp7C88t3iLSoJFhTJ/T+rILiA78
         UZkqVXzRmuPwevC1dti/tKebR5BbflDr2Y2Y+H7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 562/800] Revert "ibmvnic: simplify reset_long_term_buff function"
Date:   Mon, 12 Jul 2021 08:09:45 +0200
Message-Id: <20210712061027.223197681@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 0ec13aff058a82426c8d44b688c804cc4a5a0a3d ]

This reverts commit 1c7d45e7b2c29080bf6c8cd0e213cc3cbb62a054.

We tried to optimize the number of hcalls we send and skipped sending
the REQUEST_MAP calls for some maps. However during resets, we need to
resend all the maps to the VIOS since the VIOS does not remember the
old values. In fact we may have failed over to a new VIOS which will
not have any of the mappings.

When we send packets with map ids the VIOS does not know about, it
triggers a FATAL reset. While the client does recover from the FATAL
error reset, we are seeing a large number of such resets. Handling
FATAL resets is lot more unnecessary work than issuing a few more
hcalls so revert the commit and resend the maps to the VIOS.

Fixes: 1c7d45e7b2c ("ibmvnic: simplify reset_long_term_buff function")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 46 ++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5788bb956d73..4b4eccc496a8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -257,12 +257,40 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
 }
 
-static int reset_long_term_buff(struct ibmvnic_long_term_buff *ltb)
+static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
+				struct ibmvnic_long_term_buff *ltb)
 {
-	if (!ltb->buff)
-		return -EINVAL;
+	struct device *dev = &adapter->vdev->dev;
+	int rc;
 
 	memset(ltb->buff, 0, ltb->size);
+
+	mutex_lock(&adapter->fw_lock);
+	adapter->fw_done_rc = 0;
+
+	reinit_completion(&adapter->fw_done);
+	rc = send_request_map(adapter, ltb->addr, ltb->size, ltb->map_id);
+	if (rc) {
+		mutex_unlock(&adapter->fw_lock);
+		return rc;
+	}
+
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
+	if (rc) {
+		dev_info(dev,
+			 "Reset failed, long term map request timed out or aborted\n");
+		mutex_unlock(&adapter->fw_lock);
+		return rc;
+	}
+
+	if (adapter->fw_done_rc) {
+		dev_info(dev,
+			 "Reset failed, attempting to free and reallocate buffer\n");
+		free_long_term_buff(adapter, ltb);
+		mutex_unlock(&adapter->fw_lock);
+		return alloc_long_term_buff(adapter, ltb, ltb->size);
+	}
+	mutex_unlock(&adapter->fw_lock);
 	return 0;
 }
 
@@ -484,7 +512,8 @@ static int reset_rx_pools(struct ibmvnic_adapter *adapter)
 						  rx_pool->size *
 						  rx_pool->buff_size);
 		} else {
-			rc = reset_long_term_buff(&rx_pool->long_term_buff);
+			rc = reset_long_term_buff(adapter,
+						  &rx_pool->long_term_buff);
 		}
 
 		if (rc)
@@ -607,11 +636,12 @@ static int init_rx_pools(struct net_device *netdev)
 	return 0;
 }
 
-static int reset_one_tx_pool(struct ibmvnic_tx_pool *tx_pool)
+static int reset_one_tx_pool(struct ibmvnic_adapter *adapter,
+			     struct ibmvnic_tx_pool *tx_pool)
 {
 	int rc, i;
 
-	rc = reset_long_term_buff(&tx_pool->long_term_buff);
+	rc = reset_long_term_buff(adapter, &tx_pool->long_term_buff);
 	if (rc)
 		return rc;
 
@@ -638,10 +668,10 @@ static int reset_tx_pools(struct ibmvnic_adapter *adapter)
 
 	tx_scrqs = adapter->num_active_tx_pools;
 	for (i = 0; i < tx_scrqs; i++) {
-		rc = reset_one_tx_pool(&adapter->tso_pool[i]);
+		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
 		if (rc)
 			return rc;
-		rc = reset_one_tx_pool(&adapter->tx_pool[i]);
+		rc = reset_one_tx_pool(adapter, &adapter->tx_pool[i]);
 		if (rc)
 			return rc;
 	}
-- 
2.30.2



