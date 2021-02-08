Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C589331379B
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhBHP2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233835AbhBHPXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:23:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C0D464F0B;
        Mon,  8 Feb 2021 15:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797257;
        bh=gz2PSsCqWuf2hYJt7PX4NrYBeN4Tg5hYqLFc2wVAiBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUhGZKRz5MeT7R+O58iijRjwNXQUywcGoAtOlIhSsfHqvieowZf8aDJ+k5TYIGOmX
         KdDu8lGxAQO/lsWL6B9k2g/f4Y3z15E+HDAP14WVamztdnCOc9+CTT05u2gSYGmsnO
         MVomK0mki/+4A80eSEJfW49Vg1TDlrUxxYGO0DZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/120] r8169: fix WoL on shutdown if CONFIG_DEBUG_SHIRQ is set
Date:   Mon,  8 Feb 2021 16:00:33 +0100
Message-Id: <20210208145820.261784113@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit cc9f07a838c4988ed244d0907cb71d54b85482a5 ]

So far phy_disconnect() is called before free_irq(). If CONFIG_DEBUG_SHIRQ
is set and interrupt is shared, then free_irq() creates an "artificial"
interrupt by calling the interrupt handler. The "link change" flag is set
in the interrupt status register, causing phylib to eventually call
phy_suspend(). Because the net_device is detached from the PHY already,
the PHY driver can't recognize that WoL is configured and powers down the
PHY.

Fixes: f1e911d5d0df ("r8169: add basic phylib support")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/fe732c2c-a473-9088-3974-df83cfbd6efd@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 64b77d415a525..75f774347f6d1 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4753,10 +4753,10 @@ static int rtl8169_close(struct net_device *dev)
 
 	cancel_work_sync(&tp->wk.work);
 
-	phy_disconnect(tp->phydev);
-
 	free_irq(pci_irq_vector(pdev, 0), tp);
 
+	phy_disconnect(tp->phydev);
+
 	dma_free_coherent(&pdev->dev, R8169_RX_RING_BYTES, tp->RxDescArray,
 			  tp->RxPhyAddr);
 	dma_free_coherent(&pdev->dev, R8169_TX_RING_BYTES, tp->TxDescArray,
-- 
2.27.0



