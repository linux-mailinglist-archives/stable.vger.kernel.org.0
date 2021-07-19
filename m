Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C6A3CE5E3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbhGSPzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347797AbhGSPsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:48:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E3D1613F7;
        Mon, 19 Jul 2021 16:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712087;
        bh=5wk83Sjp3WuftAL9eBfzYogS71sDOFsek0kSjaa2dFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHb+y0J2EUbWtrmHYCyxCt3jlWKdOjCMcPU4JBr/9aVupuAd1eLMgqZ8uwlXWaxbA
         /HZyCYF+HNLiz8u+ZopGBGOQictRF0oPM/cRARAHrgfKrW/UvWCVqzFsEjvehGUcfk
         fvM81DpR79034XfaU5kpmluosjbsQ5UQtGuWLjrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 245/292] ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM
Date:   Mon, 19 Jul 2021 16:55:07 +0200
Message-Id: <20210719144951.009019565@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 1cebcf9932ab76102e8cfc555879574693ba8956 ]

The Microchip LAN8710Ai PHY requires XTAL1/CLKIN external clock to be
enabled when the nRST is toggled according to datasheet Microchip
LAN8710A/LAN8710Ai DS00002164B page 35 section 3.8.5.1 Hardware Reset:
  "
  A Hardware reset is asserted by driving the nRST input pin low. When
  driven, nRST should be held low for the minimum time detailed in
  Section 5.5.3, "Power-On nRST & Configuration Strap Timing," on page
  59 to ensure a proper transceiver reset. During a Hardware reset, an
  external clock must be supplied to the XTAL1/CLKIN signal.
  "
This is accidentally fulfilled in the current setup, where ETHCK_K is used
to supply both PHY XTAL1/CLKIN and is also fed back through eth_clk_fb to
supply ETHRX clock of the DWMAC. Hence, the DWMAC enables ETHRX clock,
that has ETHCK_K as parent, so ETHCK_K clock are also enabled, and then
the PHY reset toggles.

However, this is not always the case, e.g. in case the PHY XTAL1/CLKIN
clock are supplied by some other clock source than ETHCK_K or in case
ETHRX clock are not supplied by ETHCK_K. In the later case, ETHCK_K would
be kept disabled, while ETHRX clock would be enabled, so the PHY would
not be receiving XTAL1/CLKIN clock and the reset would fail.

Improve the DT by adding the PHY clock phandle into the PHY node, which
then also requires moving the PHY reset GPIO specifier in the same place
and that then also requires correct PHY reset GPIO timing, so add that
too.

A brief note regarding the timing, the datasheet says the reset should
stay asserted for at least 100uS and software should wait at least 200nS
after deassertion. Set both delays to 500uS which should be plenty.

Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Patrick Delaunay <patrick.delaunay@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index 2617815e42a6..30e4d990c5a3 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -119,7 +119,6 @@
 	max-speed = <100>;
 	phy-handle = <&phy0>;
 	st,eth-ref-clk-sel;
-	phy-reset-gpios = <&gpioh 3 GPIO_ACTIVE_LOW>;
 
 	mdio0 {
 		#address-cells = <1>;
@@ -128,6 +127,13 @@
 
 		phy0: ethernet-phy@1 {
 			reg = <1>;
+			/* LAN8710Ai */
+			compatible = "ethernet-phy-id0007.c0f0",
+				     "ethernet-phy-ieee802.3-c22";
+			clocks = <&rcc ETHCK_K>;
+			reset-gpios = <&gpioh 3 GPIO_ACTIVE_LOW>;
+			reset-assert-us = <500>;
+			reset-deassert-us = <500>;
 			interrupt-parent = <&gpioi>;
 			interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
 		};
-- 
2.30.2



