Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6C29E1D1
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbfH0H42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbfH0H41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:56:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F198206BA;
        Tue, 27 Aug 2019 07:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892587;
        bh=4K/hEkkHciDKVKUWejVq+KiKrvvvlnJGrL9V3ZOtjw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yS3/38wawfEu7wRSg6flBYOMJV0SQiFTBAiikCEgz0AGVWcoWWYBQQzYNBdboKbYQ
         e8U+bADfO2n4jo8VMmpBp4jSfbrcmHadyZCHtRHi7PvDDQwGvViSuxPOeUevF8QhGa
         ZN0E4QtD5rkqFkTvwkP8DhzNCs/cfW5B88esvT+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/98] net: stmmac: Fix issues when number of Queues >= 4
Date:   Tue, 27 Aug 2019 09:50:22 +0200
Message-Id: <20190827072720.479152287@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e8df7e8c233a18d2704e37ecff47583b494789d3 ]

When queues >= 4 we use different registers but we were not subtracting
the offset of 4. Fix this.

Found out by Coverity.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c   | 4 ++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index d0e6e1503581f..48cf5e2b24417 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -88,6 +88,8 @@ static void dwmac4_rx_queue_priority(struct mac_device_info *hw,
 	u32 value;
 
 	base_register = (queue < 4) ? GMAC_RXQ_CTRL2 : GMAC_RXQ_CTRL3;
+	if (queue >= 4)
+		queue -= 4;
 
 	value = readl(ioaddr + base_register);
 
@@ -105,6 +107,8 @@ static void dwmac4_tx_queue_priority(struct mac_device_info *hw,
 	u32 value;
 
 	base_register = (queue < 4) ? GMAC_TXQ_PRTY_MAP0 : GMAC_TXQ_PRTY_MAP1;
+	if (queue >= 4)
+		queue -= 4;
 
 	value = readl(ioaddr + base_register);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index d182f82f7b586..870302a7177e2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -106,6 +106,8 @@ static void dwxgmac2_rx_queue_prio(struct mac_device_info *hw, u32 prio,
 	u32 value, reg;
 
 	reg = (queue < 4) ? XGMAC_RXQ_CTRL2 : XGMAC_RXQ_CTRL3;
+	if (queue >= 4)
+		queue -= 4;
 
 	value = readl(ioaddr + reg);
 	value &= ~XGMAC_PSRQ(queue);
@@ -169,6 +171,8 @@ static void dwxgmac2_map_mtl_to_dma(struct mac_device_info *hw, u32 queue,
 	u32 value, reg;
 
 	reg = (queue < 4) ? XGMAC_MTL_RXQ_DMA_MAP0 : XGMAC_MTL_RXQ_DMA_MAP1;
+	if (queue >= 4)
+		queue -= 4;
 
 	value = readl(ioaddr + reg);
 	value &= ~XGMAC_QxMDMACH(queue);
-- 
2.20.1



