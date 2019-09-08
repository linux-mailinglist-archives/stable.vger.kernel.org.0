Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42157ACD81
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731998AbfIHMuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732032AbfIHMuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:50:14 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA27C21920;
        Sun,  8 Sep 2019 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947014;
        bh=EHlZxpeB92ud3i+I2/8Og07f0T7koJfDGbJ2zG0so2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X35Wbk/gX/SM1bhdFLv7MHyxebH8PlazmKRPU9FTVa4QjWsomduMYjR+OaIuGwRc9
         dmwaLAPd5FxBwWLg6gapus+trmuHkxXMWGqwaRqEwyEIIzOxnDRWB3j7F7XhsUUOSN
         DLzMMAMVegmog3LpWAOqQ2KYB+NOFBkMx9sMGnEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fuqian Huang <huangfq.daxian@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 28/94] net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq in IRQ context
Date:   Sun,  8 Sep 2019 13:41:24 +0100
Message-Id: <20190908121151.246734889@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8c25d0887a8bd0e1ca2074ac0c6dff173787a83b ]

As spin_unlock_irq will enable interrupts.
Function tsi108_stat_carry is called from interrupt handler tsi108_irq.
Interrupts are enabled in interrupt handler.
Use spin_lock_irqsave/spin_unlock_irqrestore instead of spin_(un)lock_irq
in IRQ context to avoid this.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/tundra/tsi108_eth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 78a7de3fb622f..c62f474b6d08e 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -371,9 +371,10 @@ tsi108_stat_carry_one(int carry, int carry_bit, int carry_shift,
 static void tsi108_stat_carry(struct net_device *dev)
 {
 	struct tsi108_prv_data *data = netdev_priv(dev);
+	unsigned long flags;
 	u32 carry1, carry2;
 
-	spin_lock_irq(&data->misclock);
+	spin_lock_irqsave(&data->misclock, flags);
 
 	carry1 = TSI_READ(TSI108_STAT_CARRY1);
 	carry2 = TSI_READ(TSI108_STAT_CARRY2);
@@ -441,7 +442,7 @@ static void tsi108_stat_carry(struct net_device *dev)
 			      TSI108_STAT_TXPAUSEDROP_CARRY,
 			      &data->tx_pause_drop);
 
-	spin_unlock_irq(&data->misclock);
+	spin_unlock_irqrestore(&data->misclock, flags);
 }
 
 /* Read a stat counter atomically with respect to carries.
-- 
2.20.1



