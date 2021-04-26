Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C2836B196
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 12:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhDZKYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 06:24:46 -0400
Received: from phobos.denx.de ([85.214.62.61]:57968 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232194AbhDZKYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 06:24:44 -0400
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 8D75982B7B;
        Mon, 26 Apr 2021 12:23:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1619432637;
        bh=vuM14kVXZV2c9XMcAxdH+Kc8AouVFhI9Fu1ObWGMx/s=;
        h=From:To:Cc:Subject:Date:From;
        b=AjPp77GelPy04ugq+6bojpDDZEWj00agca0Mq75P3JKC84klS23HTTBkbzfeS5rR6
         RlBR+2US1M81CoskboGZHT5aBPcRhvGmSrPsTOWQhvQWecxnf8zXFwDU0JRTYfGBsB
         uHgvvFmFKEfiSmRJ/ycSB4hBSmMmjx8puXLErHP6YD2xBEmGSVPSFVp1I9ube971Di
         2uRykykwFKqgYSr1PV1Hd1bQQI6ZD6rLrCqcmiq70Hoorkm3R9XKk9x9tZ+4C9L1fE
         kN6+lNhdrvfknQ55F7As6Ps1XngP2/byEKUp+6eZ4isRTvhnscWKCOel8/0oOXD3sV
         3UFXKZLptb7uw==
From:   Marek Vasut <marex@denx.de>
To:     linux-arm-kernel@lists.infradead.org
Cc:     arnd@arndb.de, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@gmail.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, stable@vger.kernel.org
Subject: [PATCH V3] ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators
Date:   Mon, 26 Apr 2021 12:23:21 +0200
Message-Id: <20210426102321.5039-1-marex@denx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.4 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Per schematic, both PU and SOC regulator are supplied from LTC3676 SW1
via VDDSOC_IN rail, add the PU input. Both VDD1P1, VDD2P5 are supplied
from LTC3676 SW2 via VDDHIGH_IN rail, add both inputs.

While no instability or problems are currently observed, the regulators
should be fully described in DT and that description should fully match
the hardware, else this might lead to unforseen issues later. Fix this.

Fixes: 52c7a088badd ("ARM: dts: imx6q: Add support for the DHCOM iMX6 SoM and PDK2")
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Ludwig Zenz <lzenz@dh-electronics.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: stable@vger.kernel.org
---
V2: Amend commit message
V3: Reinstate the missing SoB line, add RB
---
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
index 236fc205c389..d0768ae429fa 100644
--- a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
@@ -406,6 +406,18 @@ &reg_soc {
 	vin-supply = <&sw1_reg>;
 };
 
+&reg_pu {
+	vin-supply = <&sw1_reg>;
+};
+
+&reg_vdd1p1 {
+	vin-supply = <&sw2_reg>;
+};
+
+&reg_vdd2p5 {
+	vin-supply = <&sw2_reg>;
+};
+
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1>;
-- 
2.30.2

