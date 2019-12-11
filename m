Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D0C11B04C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbfLKPV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729663AbfLKPVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A69362465B;
        Wed, 11 Dec 2019 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077684;
        bh=e5Qqv5i5bfqv3rMEEajILf48eFNYMkElgLOHDwmN5zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdYl+sDuTyZNhtpr1wmcj/Qa92xRyUsP3fGpQPVlC/Wuj1K8vPRNVb1ub+Y1Zv1vt
         2T5TCGUfE5/Lbx4GdII36Lsijy1BNcWDV5xT/XNfu3UiLN1AIHLq+nJ253c+/ausSi
         UDS0f87OxrK695OTBkxhSsCszmceDAz7EhDHo/tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/243] can: xilinx: fix return type of ndo_start_xmit function
Date:   Wed, 11 Dec 2019 16:04:53 +0100
Message-Id: <20191211150347.972455063@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 81de0cd60fd492575b24d97667f38b8b833fb058 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/xilinx_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 3df23487487f7..b01c6da4dd814 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -612,7 +612,7 @@ static int xcan_start_xmit_mailbox(struct sk_buff *skb, struct net_device *ndev)
  *
  * Return: NETDEV_TX_OK on success and NETDEV_TX_BUSY when the tx queue is full
  */
-static int xcan_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t xcan_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct xcan_priv *priv = netdev_priv(ndev);
 	int ret;
-- 
2.20.1



