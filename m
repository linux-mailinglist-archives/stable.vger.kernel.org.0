Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEDC3106A57
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfKVKeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:34:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfKVKd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:33:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 058AC20708;
        Fri, 22 Nov 2019 10:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418838;
        bh=ni71MLyzBp4qGD+CQpM45gvt8cp3Xgd0N9OQp3oizTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQzVPwughiDOgR0Pw9BYT4+n83jVCobpEIq7gdMK6BscIKyyvzNRtyMeP91cBMwSK
         faV5VDR4tiAhwa4eVnY8ZBJIIrphCFOCONn9zFjpqubh5nJvjStAJSQWlH1UNfDcpV
         L61jF1Kve+2dcIJ3E9Xeh2jsAgiDPAS9gt4Rp1T4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 067/159] net: broadcom: fix return type of ndo_start_xmit function
Date:   Fri, 22 Nov 2019 11:27:38 +0100
Message-Id: <20191122100755.326456105@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
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
index ec5834087e4b4..c01ab06863b3d 100644
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
index f557a2aaec231..73a7c8a504702 100644
--- a/drivers/net/ethernet/broadcom/sb1250-mac.c
+++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
@@ -300,7 +300,7 @@ static enum sbmac_state sbmac_set_channel_state(struct sbmac_softc *,
 static void sbmac_promiscuous_mode(struct sbmac_softc *sc, int onoff);
 static uint64_t sbmac_addr2reg(unsigned char *ptr);
 static irqreturn_t sbmac_intr(int irq, void *dev_instance);
-static int sbmac_start_tx(struct sk_buff *skb, struct net_device *dev);
+static netdev_tx_t sbmac_start_tx(struct sk_buff *skb, struct net_device *dev);
 static void sbmac_setmulti(struct sbmac_softc *sc);
 static int sbmac_init(struct platform_device *pldev, long long base);
 static int sbmac_set_speed(struct sbmac_softc *s, enum sbmac_speed speed);
@@ -2033,7 +2033,7 @@ static irqreturn_t sbmac_intr(int irq,void *dev_instance)
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



