Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D9EE6737
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbfJ0VTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731380AbfJ0VTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:01 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50E9F214E0;
        Sun, 27 Oct 2019 21:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211140;
        bh=OUrNLCHzvRhAG4hsbQCod1QXhYariPy0m16QKFxoLtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ENJRIUFiXX+4Uf+v5QoCk/RTev81E3ohazvbx3gxZtN/TUbSjfs1Uh8NquICjV4r
         QDDgNELMTOhpEPsuRhMwtyVs47Efns9nDl+CrkGEQNxXZ/mp//Bq9Ks30z/g34WHBc
         /sTxBKuQEKbE8R0IHxTJzEptmwBqUiWqCiLF/IQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 039/197] net: stmmac: dwmac4: Always update the MAC Hash Filter
Date:   Sun, 27 Oct 2019 21:59:17 +0100
Message-Id: <20191027203353.828444927@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit f79bfda3756c50a86c0ee65091935c42c5bbe0cb ]

We need to always update the MAC Hash Filter so that previous entries
are invalidated.

Found out while running stmmac selftests.

Fixes: b8ef7020d6e5 ("net: stmmac: add support for hash table size 128/256 in dwmac4")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index fc9954e4a7729..9c73fb759b575 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -407,8 +407,11 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	int numhashregs = (hw->multicast_filter_bins >> 5);
 	int mcbitslog2 = hw->mcast_bits_log2;
 	unsigned int value;
+	u32 mc_filter[8];
 	int i;
 
+	memset(mc_filter, 0, sizeof(mc_filter));
+
 	value = readl(ioaddr + GMAC_PACKET_FILTER);
 	value &= ~GMAC_PACKET_FILTER_HMC;
 	value &= ~GMAC_PACKET_FILTER_HPF;
@@ -422,16 +425,13 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 		/* Pass all multi */
 		value |= GMAC_PACKET_FILTER_PM;
 		/* Set all the bits of the HASH tab */
-		for (i = 0; i < numhashregs; i++)
-			writel(0xffffffff, ioaddr + GMAC_HASH_TAB(i));
+		memset(mc_filter, 0xff, sizeof(mc_filter));
 	} else if (!netdev_mc_empty(dev)) {
 		struct netdev_hw_addr *ha;
-		u32 mc_filter[8];
 
 		/* Hash filter for multicast */
 		value |= GMAC_PACKET_FILTER_HMC;
 
-		memset(mc_filter, 0, sizeof(mc_filter));
 		netdev_for_each_mc_addr(ha, dev) {
 			/* The upper n bits of the calculated CRC are used to
 			 * index the contents of the hash table. The number of
@@ -446,10 +446,11 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 			 */
 			mc_filter[bit_nr >> 5] |= (1 << (bit_nr & 0x1f));
 		}
-		for (i = 0; i < numhashregs; i++)
-			writel(mc_filter[i], ioaddr + GMAC_HASH_TAB(i));
 	}
 
+	for (i = 0; i < numhashregs; i++)
+		writel(mc_filter[i], ioaddr + GMAC_HASH_TAB(i));
+
 	value |= GMAC_PACKET_FILTER_HPF;
 
 	/* Handle multiple unicast addresses */
-- 
2.20.1



