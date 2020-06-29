Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE4E20E79B
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgF2Sf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgF2Sf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 755CB24729;
        Mon, 29 Jun 2020 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444049;
        bh=tVsnTm9/h7OmU9e02FNXpZ30dLcpvq334sbkhXiJcuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jO+0ubFfMv5CUYWGJ93BzYQWoYevsyN19d+yqqRVZhj0VfxY0fxyBthgvZUH/10U0
         t/j0e4/8eM3KX2lMNlKs32nibqi7ueKySq8yl00Zz7JnIScL0Vrn4y2Sa8Z0ZIKJ0X
         Fa6EzPFpnzbPtvTTuieIQFav/vybYsyOwt+ZoBnQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 156/265] cxgb4: move PTP lock and unlock to caller in Tx path
Date:   Mon, 29 Jun 2020 11:16:29 -0400
Message-Id: <20200629151818.2493727-157-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 030c98824deaba205787af501a074b3d7f46e32e ]

Check for whether PTP is enabled or not at the caller and perform
locking/unlocking at the caller.

Fixes following sparse warning:
sge.c:1641:26: warning: context imbalance in 'cxgb4_eth_xmit' -
different lock contexts for basic block

Fixes: a456950445a0 ("cxgb4: time stamping interface for PTP")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 6516c45864b35..db8106d9d6edf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1425,12 +1425,10 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	qidx = skb_get_queue_mapping(skb);
 	if (ptp_enabled) {
-		spin_lock(&adap->ptp_lock);
 		if (!(adap->ptp_tx_skb)) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			adap->ptp_tx_skb = skb_get(skb);
 		} else {
-			spin_unlock(&adap->ptp_lock);
 			goto out_free;
 		}
 		q = &adap->sge.ptptxq;
@@ -1444,11 +1442,8 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 #ifdef CONFIG_CHELSIO_T4_FCOE
 	ret = cxgb_fcoe_offload(skb, adap, pi, &cntrl);
-	if (unlikely(ret == -ENOTSUPP)) {
-		if (ptp_enabled)
-			spin_unlock(&adap->ptp_lock);
+	if (unlikely(ret == -EOPNOTSUPP))
 		goto out_free;
-	}
 #endif /* CONFIG_CHELSIO_T4_FCOE */
 
 	chip_ver = CHELSIO_CHIP_VERSION(adap->params.chip);
@@ -1461,8 +1456,6 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 		dev_err(adap->pdev_dev,
 			"%s: Tx ring %u full while queue awake!\n",
 			dev->name, qidx);
-		if (ptp_enabled)
-			spin_unlock(&adap->ptp_lock);
 		return NETDEV_TX_BUSY;
 	}
 
@@ -1481,8 +1474,6 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	    unlikely(cxgb4_map_skb(adap->pdev_dev, skb, sgl_sdesc->addr) < 0)) {
 		memset(sgl_sdesc->addr, 0, sizeof(sgl_sdesc->addr));
 		q->mapping_err++;
-		if (ptp_enabled)
-			spin_unlock(&adap->ptp_lock);
 		goto out_free;
 	}
 
@@ -1630,8 +1621,6 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	txq_advance(&q->q, ndesc);
 
 	cxgb4_ring_tx_db(adap, &q->q, ndesc);
-	if (ptp_enabled)
-		spin_unlock(&adap->ptp_lock);
 	return NETDEV_TX_OK;
 
 out_free:
@@ -2365,6 +2354,16 @@ netdev_tx_t t4_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(qid >= pi->nqsets))
 		return cxgb4_ethofld_xmit(skb, dev);
 
+	if (is_ptp_enabled(skb, dev)) {
+		struct adapter *adap = netdev2adap(dev);
+		netdev_tx_t ret;
+
+		spin_lock(&adap->ptp_lock);
+		ret = cxgb4_eth_xmit(skb, dev);
+		spin_unlock(&adap->ptp_lock);
+		return ret;
+	}
+
 	return cxgb4_eth_xmit(skb, dev);
 }
 
-- 
2.25.1

