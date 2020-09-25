Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BFA2787CB
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgIYMu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729058AbgIYMuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBEE221D7A;
        Fri, 25 Sep 2020 12:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038223;
        bh=ENMKtD9NocbZHCQdQE+6BWWZOk5yUzHe9r73Acai9kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuzDsfK8uBmWzKI2QKqpNdl2YiifmELQWo5Xok3EBouCgGjyBP8i/hGbBrrQ9swLG
         nQt0aCPCWv61mpp1Ggt+AB3/Cu9d7IyFU+dVtFGrK4gzIcHdXAqf9nDyU5j5gqkFEC
         fwU+2oWdQ5pEnPvCFwqOclnXqxyOxt6AjJoscXYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo bin <luobin9@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 48/56] hinic: fix rewaking txq after netif_tx_disable
Date:   Fri, 25 Sep 2020 14:48:38 +0200
Message-Id: <20200925124735.028887932@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit a1b80e0143a1b878f8e21d82fd55f3f46f0014be ]

When calling hinic_close in hinic_set_channels, all queues are
stopped after netif_tx_disable, but some queue may be rewaken in
free_tx_poll by mistake while drv is handling tx irq. If one queue
is rewaken core may call hinic_xmit_frame to send pkt after
netif_tx_disable within a short time which may results in accessing
memory that has been already freed in hinic_close. So we call
napi_disable before netif_tx_disable in hinic_close to fix this bug.

Fixes: 2eed5a8b614b ("hinic: add set_channels ethtool_ops support")
Signed-off-by: Luo bin <luobin9@huawei.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c |   24 ++++++++++++++++++++++++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c   |   18 +++---------------
 2 files changed, 27 insertions(+), 15 deletions(-)

--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -168,6 +168,24 @@ err_init_txq:
 	return err;
 }
 
+static void enable_txqs_napi(struct hinic_dev *nic_dev)
+{
+	int num_txqs = hinic_hwdev_num_qps(nic_dev->hwdev);
+	int i;
+
+	for (i = 0; i < num_txqs; i++)
+		napi_enable(&nic_dev->txqs[i].napi);
+}
+
+static void disable_txqs_napi(struct hinic_dev *nic_dev)
+{
+	int num_txqs = hinic_hwdev_num_qps(nic_dev->hwdev);
+	int i;
+
+	for (i = 0; i < num_txqs; i++)
+		napi_disable(&nic_dev->txqs[i].napi);
+}
+
 /**
  * free_txqs - Free the Logical Tx Queues of specific NIC device
  * @nic_dev: the specific NIC device
@@ -394,6 +412,8 @@ int hinic_open(struct net_device *netdev
 		goto err_create_txqs;
 	}
 
+	enable_txqs_napi(nic_dev);
+
 	err = create_rxqs(nic_dev);
 	if (err) {
 		netif_err(nic_dev, drv, netdev,
@@ -475,6 +495,7 @@ err_port_state:
 	}
 
 err_create_rxqs:
+	disable_txqs_napi(nic_dev);
 	free_txqs(nic_dev);
 
 err_create_txqs:
@@ -488,6 +509,9 @@ int hinic_close(struct net_device *netde
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	unsigned int flags;
 
+	/* Disable txq napi firstly to aviod rewaking txq in free_tx_poll */
+	disable_txqs_napi(nic_dev);
+
 	down(&nic_dev->mgmt_lock);
 
 	flags = nic_dev->flags;
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -684,18 +684,6 @@ static int free_tx_poll(struct napi_stru
 	return budget;
 }
 
-static void tx_napi_add(struct hinic_txq *txq, int weight)
-{
-	netif_napi_add(txq->netdev, &txq->napi, free_tx_poll, weight);
-	napi_enable(&txq->napi);
-}
-
-static void tx_napi_del(struct hinic_txq *txq)
-{
-	napi_disable(&txq->napi);
-	netif_napi_del(&txq->napi);
-}
-
 static irqreturn_t tx_irq(int irq, void *data)
 {
 	struct hinic_txq *txq = data;
@@ -724,7 +712,7 @@ static int tx_request_irq(struct hinic_t
 	struct hinic_sq *sq = txq->sq;
 	int err;
 
-	tx_napi_add(txq, nic_dev->tx_weight);
+	netif_napi_add(txq->netdev, &txq->napi, free_tx_poll, nic_dev->tx_weight);
 
 	hinic_hwdev_msix_set(nic_dev->hwdev, sq->msix_entry,
 			     TX_IRQ_NO_PENDING, TX_IRQ_NO_COALESC,
@@ -734,7 +722,7 @@ static int tx_request_irq(struct hinic_t
 	err = request_irq(sq->irq, tx_irq, 0, txq->irq_name, txq);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to request Tx irq\n");
-		tx_napi_del(txq);
+		netif_napi_del(&txq->napi);
 		return err;
 	}
 
@@ -746,7 +734,7 @@ static void tx_free_irq(struct hinic_txq
 	struct hinic_sq *sq = txq->sq;
 
 	free_irq(sq->irq, txq);
-	tx_napi_del(txq);
+	netif_napi_del(&txq->napi);
 }
 
 /**


