Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2896A106B48
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfKVKnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729175AbfKVKnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:43:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58BF72071F;
        Fri, 22 Nov 2019 10:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419379;
        bh=V4x9S+RffWZW9SkrU3gO6jgfU04aB9QwG/YsZYVbTL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwoj+03HDVlDPvYRLkQ6mqEUiJrMxT4pPeOOR6fSj0ytu5PrRWwGVLsFIin/DT5K+
         /zI8i9S4QLxZbel0LNTe7ySpw+aVHb0k+0mJAgyvZh+VRi4yOE3GVat6lbw4sm2DoM
         p7bwTsaR+598yMPnyqleeRrxwyUJyBqFl+XRK0Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 092/222] net: broadcom: fix return type of ndo_start_xmit function
Date:   Fri, 22 Nov 2019 11:27:12 +0100
Message-Id: <20191122100910.145920123@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 0c13b8d1aee87c35a2fbc1d85a1f766227cf54b5 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 5 +++--
 drivers/net/ethernet/broadcom/sb1250-mac.c   | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index c4078401b7ded..900f2f706cbc7 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -571,12 +571,13 @@ static irqreturn_t bcm_enet_isr_dma(int irq, void *dev_id)
 /*
  * tx request callback
  */
-static int bcm_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t
+bcm_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bcm_enet_priv *priv;
 	struct bcm_enet_desc *desc;
 	u32 len_stat;
-	int ret;
+	netdev_tx_t ret;
 
 	priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/broadcom/sb1250-mac.c b/drivers/net/ethernet/broadcom/sb1250-mac.c
index f1b81187a2010..dc7953894c351 100644
--- a/drivers/net/ethernet/broadcom/sb1250-mac.c
+++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
@@ -299,7 +299,7 @@ static enum sbmac_state sbmac_set_channel_state(struct sbmac_softc *,
 static void sbmac_promiscuous_mode(struct sbmac_softc *sc, int onoff);
 static uint64_t sbmac_addr2reg(unsigned char *ptr);
 static irqreturn_t sbmac_intr(int irq, void *dev_instance);
-static int sbmac_start_tx(struct sk_buff *skb, struct net_device *dev);
+static netdev_tx_t sbmac_start_tx(struct sk_buff *skb, struct net_device *dev);
 static void sbmac_setmulti(struct sbmac_softc *sc);
 static int sbmac_init(struct platform_device *pldev, long long base);
 static int sbmac_set_speed(struct sbmac_softc *s, enum sbmac_speed speed);
@@ -2032,7 +2032,7 @@ static irqreturn_t sbmac_intr(int irq,void *dev_instance)
  *  Return value:
  *  	   nothing
  ********************************************************************* */
-static int sbmac_start_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t sbmac_start_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct sbmac_softc *sc = netdev_priv(dev);
 	unsigned long flags;
-- 
2.20.1



