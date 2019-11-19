Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37081016C2
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732063AbfKSFxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:53:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732058AbfKSFxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:53:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15EC920721;
        Tue, 19 Nov 2019 05:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142826;
        bh=0xP/MOoAKXcaQQTqV9loT+h+o7/1XLjhl0hPNSQytDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzGby+D80CBq9RcZqZqpDSLkn7iEcxc0eMS7TsgSwZB785j1lY4wtYRQ+4EdoO5em
         t84Xl6jhXVXyjvv3QKLf977i5aJ8Fvg+yECGGPHo8wlS1eAu5FLMsTRTSlnf9qEa4+
         EeWm9+LUbN1y82czmefw2vVQSTWRDOCmQ6GRL7co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 173/239] net: micrel: fix return type of ndo_start_xmit function
Date:   Tue, 19 Nov 2019 06:19:33 +0100
Message-Id: <20191119051334.123408377@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 2b49117a5abee8478b0470cba46ac74f93b4a479 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8695net.c  | 2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8695net.c b/drivers/net/ethernet/micrel/ks8695net.c
index bd51e057e9150..b881f5d4a7f9e 100644
--- a/drivers/net/ethernet/micrel/ks8695net.c
+++ b/drivers/net/ethernet/micrel/ks8695net.c
@@ -1164,7 +1164,7 @@ ks8695_timeout(struct net_device *ndev)
  *	sk_buff and adds it to the TX ring. It then kicks the TX DMA
  *	engine to ensure transmission begins.
  */
-static int
+static netdev_tx_t
 ks8695_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct ks8695_priv *ksp = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index f3e9dd47b56f0..adbe0a6fe0db9 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -1020,9 +1020,9 @@ static void ks_write_qmu(struct ks_net *ks, u8 *pdata, u16 len)
  * spin_lock_irqsave is required because tx and rx should be mutual exclusive.
  * So while tx is in-progress, prevent IRQ interrupt from happenning.
  */
-static int ks_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t ks_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
-	int retv = NETDEV_TX_OK;
+	netdev_tx_t retv = NETDEV_TX_OK;
 	struct ks_net *ks = netdev_priv(netdev);
 
 	disable_irq(netdev->irq);
-- 
2.20.1



