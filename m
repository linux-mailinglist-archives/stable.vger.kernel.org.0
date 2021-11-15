Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A77450CAC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbhKORl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237808AbhKORjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:39:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13C3463281;
        Mon, 15 Nov 2021 17:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997187;
        bh=eneIjC0BOS4PB4i9Qdq5CQRunYiYHt3Gtk95k9VDXig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3Flkn0oIniXqu+8sXMXm0DUQ8tMmkFYBOF/H6oWEjFLocvd8Pu4SfE/k0vCks35d
         9KO2FGt1qGG2brGBfswwlJMTAamyedKTLYCoa9viOEz9aQ3nTA1i5mlXrveVDUwM1g
         shEqiA0G0sCtghBEtTPVneiJ2BJacU/RhB15GNuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erik Ekman <erik@kryo.se>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/575] sfc: Export fibre-specific supported link modes
Date:   Mon, 15 Nov 2021 17:56:22 +0100
Message-Id: <20211115165345.614605654@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Ekman <erik@kryo.se>

[ Upstream commit c62041c5baa9ded3bc6fd38d3f724de70683b489 ]

The 1/10GbaseT modes were set up for cards with SFP+ cages in
3497ed8c852a5 ("sfc: report supported link speeds on SFP connections").
10GbaseT was likely used since no 10G fibre mode existed.

The missing fibre modes for 1/10G were added to ethtool.h in 5711a9822144
("net: ethtool: add support for 1000BaseX and missing 10G link modes")
shortly thereafter.

The user guide available at https://support-nic.xilinx.com/wp/drivers
lists support for the following cable and transceiver types in section 2.9:
- QSFP28 100G Direct Attach Cables
- QSFP28 100G SR Optical Transceivers (with SR4 modules listed)
- SFP28 25G Direct Attach Cables
- SFP28 25G SR Optical Transceivers
- QSFP+ 40G Direct Attach Cables
- QSFP+ 40G Active Optical Cables
- QSFP+ 40G SR4 Optical Transceivers
- QSFP+ to SFP+ Breakout Direct Attach Cables
- QSFP+ to SFP+ Breakout Active Optical Cables
- SFP+ 10G Direct Attach Cables
- SFP+ 10G SR Optical Transceivers
- SFP+ 10G LR Optical Transceivers
- SFP 1000BASE‐T Transceivers
- 1G Optical Transceivers
(From user guide issue 28. Issue 16 which also includes older cards like
SFN5xxx/SFN6xxx has matching lists for 1/10/40G transceiver types.)

Regarding SFP+ 10GBASE‐T transceivers the latest guide says:
"Solarflare adapters do not support 10GBASE‐T transceiver modules."

Tested using SFN5122F-R7 (with 2 SFP+ ports). Supported link modes do not change
depending on module used (tested with 1000BASE-T, 1000BASE-BX10, 10GBASE-LR).
Before:

$ ethtool ext
Settings for ext:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseT/Full
	                        10000baseT/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  Not reported
	Advertised pause frame use: No
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  Not reported
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: No
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: FIBRE
	PHYAD: 255
	Transceiver: internal
        Current message level: 0x000020f7 (8439)
                               drv probe link ifdown ifup rx_err tx_err hw
	Link detected: yes

After:

$ ethtool ext
Settings for ext:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseT/Full
	                        1000baseX/Full
	                        10000baseCR/Full
	                        10000baseSR/Full
	                        10000baseLR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  Not reported
	Advertised pause frame use: No
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  Not reported
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: No
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: FIBRE
	PHYAD: 255
	Transceiver: internal
	Supports Wake-on: g
	Wake-on: d
        Current message level: 0x000020f7 (8439)
                               drv probe link ifdown ifup rx_err tx_err hw
	Link detected: yes

Signed-off-by: Erik Ekman <erik@kryo.se>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/mcdi_port_common.c | 37 +++++++++++++++------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 4bd3ef8f3384e..c4fe3c48ac46a 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -132,16 +132,27 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
 	case MC_CMD_MEDIA_SFP_PLUS:
 	case MC_CMD_MEDIA_QSFP_PLUS:
 		SET_BIT(FIBRE);
-		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
+		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN)) {
 			SET_BIT(1000baseT_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
-			SET_BIT(10000baseT_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN))
+			SET_BIT(1000baseX_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN)) {
+			SET_BIT(10000baseCR_Full);
+			SET_BIT(10000baseLR_Full);
+			SET_BIT(10000baseSR_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN)) {
 			SET_BIT(40000baseCR4_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN))
+			SET_BIT(40000baseSR4_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN)) {
 			SET_BIT(100000baseCR4_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN))
+			SET_BIT(100000baseSR4_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN)) {
 			SET_BIT(25000baseCR_Full);
+			SET_BIT(25000baseSR_Full);
+		}
 		if (cap & (1 << MC_CMD_PHY_CAP_50000FDX_LBN))
 			SET_BIT(50000baseCR2_Full);
 		break;
@@ -192,15 +203,19 @@ u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
 		result |= (1 << MC_CMD_PHY_CAP_100FDX_LBN);
 	if (TEST_BIT(1000baseT_Half))
 		result |= (1 << MC_CMD_PHY_CAP_1000HDX_LBN);
-	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full))
+	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full) ||
+			TEST_BIT(1000baseX_Full))
 		result |= (1 << MC_CMD_PHY_CAP_1000FDX_LBN);
-	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full))
+	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full) ||
+			TEST_BIT(10000baseCR_Full) || TEST_BIT(10000baseLR_Full) ||
+			TEST_BIT(10000baseSR_Full))
 		result |= (1 << MC_CMD_PHY_CAP_10000FDX_LBN);
-	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full))
+	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full) ||
+			TEST_BIT(40000baseSR4_Full))
 		result |= (1 << MC_CMD_PHY_CAP_40000FDX_LBN);
-	if (TEST_BIT(100000baseCR4_Full))
+	if (TEST_BIT(100000baseCR4_Full) || TEST_BIT(100000baseSR4_Full))
 		result |= (1 << MC_CMD_PHY_CAP_100000FDX_LBN);
-	if (TEST_BIT(25000baseCR_Full))
+	if (TEST_BIT(25000baseCR_Full) || TEST_BIT(25000baseSR_Full))
 		result |= (1 << MC_CMD_PHY_CAP_25000FDX_LBN);
 	if (TEST_BIT(50000baseCR2_Full))
 		result |= (1 << MC_CMD_PHY_CAP_50000FDX_LBN);
-- 
2.33.0



