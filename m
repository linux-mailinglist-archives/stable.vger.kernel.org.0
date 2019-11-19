Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379DC1017E0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfKSGEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:04:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729447AbfKSFiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:38:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BBD6206EC;
        Tue, 19 Nov 2019 05:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141892;
        bh=ThFLDZe1hOaFdWIq1h+j+kEKwDv0hoNIwX9dEIFPTjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgVUox8mVMlHWPXNtK09LCRrPkeMIMaFy7UAJ9FdZKbS3qJxU5zHNe6xXL0akin6O
         LsZfCkmrjZpTzK3c7HOwJvOuOVA9t5n1dgDY7ZyE96WQ8tmh8oLHcuYLYuPhPayiYP
         qa3qnNQ/sgwIBdAahC5y/WzVkT4PHxeWs07xHHEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 276/422] net: xilinx: fix return type of ndo_start_xmit function
Date:   Tue, 19 Nov 2019 06:17:53 +0100
Message-Id: <20191119051416.872729645@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 81255af8d9d5565004792c295dde49344df450ca ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c       | 3 ++-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 3 ++-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c     | 9 +++++----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 60abc9250f56a..2241f98970926 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -674,7 +674,8 @@ static inline int temac_check_tx_bd_space(struct temac_local *lp, int num_frag)
 	return 0;
 }
 
-static int temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t
+temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 	struct cdmac_bd *cur_p;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 66b30ebd45ee8..28764268a44f8 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -657,7 +657,8 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
  * start the transmission. Additionally if checksum offloading is supported,
  * it populates AXI Stream Control fields with appropriate values.
  */
-static int axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t
+axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	u32 ii;
 	u32 num_frag;
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 42f1f518dad69..c77c81eb7ab3b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1020,9 +1020,10 @@ static int xemaclite_close(struct net_device *dev)
  * deferred and the Tx queue is stopped so that the deferred socket buffer can
  * be transmitted when the Emaclite device is free to transmit data.
  *
- * Return:	0, always.
+ * Return:	NETDEV_TX_OK, always.
  */
-static int xemaclite_send(struct sk_buff *orig_skb, struct net_device *dev)
+static netdev_tx_t
+xemaclite_send(struct sk_buff *orig_skb, struct net_device *dev)
 {
 	struct net_local *lp = netdev_priv(dev);
 	struct sk_buff *new_skb;
@@ -1044,7 +1045,7 @@ static int xemaclite_send(struct sk_buff *orig_skb, struct net_device *dev)
 		/* Take the time stamp now, since we can't do this in an ISR. */
 		skb_tx_timestamp(new_skb);
 		spin_unlock_irqrestore(&lp->reset_lock, flags);
-		return 0;
+		return NETDEV_TX_OK;
 	}
 	spin_unlock_irqrestore(&lp->reset_lock, flags);
 
@@ -1053,7 +1054,7 @@ static int xemaclite_send(struct sk_buff *orig_skb, struct net_device *dev)
 	dev->stats.tx_bytes += len;
 	dev_consume_skb_any(new_skb);
 
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 /**
-- 
2.20.1



