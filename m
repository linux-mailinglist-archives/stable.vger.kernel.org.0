Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B356334C80C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhC2IT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231419AbhC2ISq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:18:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B46BE61554;
        Mon, 29 Mar 2021 08:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005926;
        bh=hK655A0tpeBXhMhWiefnKl+u8tNN8/aWvVqT1UDwpQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMPO/SblhtqzOoou0oDk5ULPE+GeLYpPWfejFoQS8p9jz+w2LZH/WC4R3A2CoOgb1
         9LXaL+NkmqjxjM+mYFn2g+aMrlNB7O5Mcb04xbj2Af9VqS2za2E1GykssSU+luOrV+
         sMXIaQZEqSPcdpG8YDoyjXztafyAW1Ln0L++E1f4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jason Liu <jason.hui.liu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/221] net: enetc: set MAC RX FIFO to recommended value
Date:   Mon, 29 Mar 2021 09:55:58 +0200
Message-Id: <20210329075630.083747050@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

[ Upstream commit 1b2395dfff5bb40228a187f21f577cd90673d344 ]

On LS1028A, the MAC RX FIFO defaults to the value 2, which is too high
and may lead to RX lock-up under traffic at a rate higher than 6 Gbps.
Set it to 1 instead, as recommended by the hardware design team and by
later versions of the ENETC block guide.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Jason Liu <jason.hui.liu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 2 ++
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 21a6ce415cb2..2b90a345507b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -234,6 +234,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_MAXFRM	0x8014
 #define ENETC_SET_TX_MTU(val)	((val) << 16)
 #define ENETC_SET_MAXFRM(val)	((val) & 0xffff)
+#define ENETC_PM0_RX_FIFO	0x801c
+#define ENETC_PM0_RX_FIFO_VAL	1
 
 #define ENETC_PM_IMDIO_BASE	0x8030
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 83187cd59fdd..68133563a40c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -490,6 +490,12 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
 
 	enetc_port_wr(hw, ENETC_PM1_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
+
+	/* On LS1028A, the MAC RX FIFO defaults to 2, which is too high
+	 * and may lead to RX lock-up under traffic. Set it to 1 instead,
+	 * as recommended by the hardware team.
+	 */
+	enetc_port_wr(hw, ENETC_PM0_RX_FIFO, ENETC_PM0_RX_FIFO_VAL);
 }
 
 static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
-- 
2.30.1



