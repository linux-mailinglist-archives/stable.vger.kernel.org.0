Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 832D873FC6
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbfGXT0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbfGXT0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:26:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B144229F3;
        Wed, 24 Jul 2019 19:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996361;
        bh=q0uB/D5K0VxAqGrDu4XSQgjDRVhKt8SyVmUwyJA89Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hL6moMq51o+GFHfIARiVt31sAl8o5MPf7W0zpG9y3hAyQs78Tj4kU6tf9U8KWta/M
         t4bAwPbW9rVX+nLw+lnS2GzGHpiIobUqSyblZ4hqzpDRPlfyyE9YLT76y1dKrvoSeX
         XQMNy4ce0MRJNdpeyS1mrgIXEBn3s04IAF91lpRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biao Huang <biao.huang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 069/413] net: stmmac: dwmac4: fix flow control issue
Date:   Wed, 24 Jul 2019 21:16:00 +0200
Message-Id: <20190724191740.072271007@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ee326fd01e79dfa42014d55931260b68b9fa3273 ]

Current dwmac4_flow_ctrl will not clear
GMAC_RX_FLOW_CTRL_RFE/GMAC_RX_FLOW_CTRL_RFE bits,
so MAC hw will keep flow control on although expecting
flow control off by ethtool. Add codes to fix it.

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 206170d0bf81..e3850938cf2f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -474,8 +474,9 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
 	if (fc & FLOW_RX) {
 		pr_debug("\tReceive Flow-Control ON\n");
 		flow |= GMAC_RX_FLOW_CTRL_RFE;
-		writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);
 	}
+	writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);
+
 	if (fc & FLOW_TX) {
 		pr_debug("\tTransmit Flow-Control ON\n");
 
@@ -483,7 +484,7 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
 			pr_debug("\tduplex mode: PAUSE %d\n", pause_time);
 
 		for (queue = 0; queue < tx_cnt; queue++) {
-			flow |= GMAC_TX_FLOW_CTRL_TFE;
+			flow = GMAC_TX_FLOW_CTRL_TFE;
 
 			if (duplex)
 				flow |=
@@ -491,6 +492,9 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
 
 			writel(flow, ioaddr + GMAC_QX_TX_FLOW_CTRL(queue));
 		}
+	} else {
+		for (queue = 0; queue < tx_cnt; queue++)
+			writel(0, ioaddr + GMAC_QX_TX_FLOW_CTRL(queue));
 	}
 }
 
-- 
2.20.1



