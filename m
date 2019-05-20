Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA3C2357D
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391082AbfETMfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403836AbfETMf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:35:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8397A204FD;
        Mon, 20 May 2019 12:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355728;
        bh=oWRqpruyTfVtDUHPIxkYLjTTV3J6ynx0f5y1Btlj9h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m93fsQJAI/SXCqcS5v42A8M3F92ZRHo7oYA+hQTqAkS8y0pkx2cxTcKfjDlsgRKCd
         NMYQhooO6PrGaTq6Fb+O2wUA1cShvS90n3pdAdJGznDa1oHu8nsSZ9YcirthEWE7HU
         lUlKDdFzfdWyjnjXCXjLkm9YtDIi1Vsgrf9zpG8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>, Soeren Moch <smoch@web.de>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Adam Thomson <Adam.Thomson@diasemi.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "George G. Davis" <george_davis@mentor.com>
Subject: [PATCH 5.1 103/128] ARM: dts: imx: Fix the AR803X phy-mode
Date:   Mon, 20 May 2019 14:14:50 +0200
Message-Id: <20190520115256.092178525@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit 0672d22a19244cdb0e5c753125c1a55a120db5d0 upstream.

Commit 6d4cd041f0af ("net: phy: at803x: disable delay only for RGMII mode")
exposed an issue on imx DTS files using AR8031/AR8035 PHYs.

The end result is that the boards can no longer obtain an IP address
via UDHCP, for example.

Quoting Andrew Lunn:

"The problem here is, all the DTs were broken since day 0. However,
because the PHY driver was also broken, nobody noticed and it
worked. Now that the PHY driver has been fixed, all the bugs in the
DTs now become an issue"

To fix this problem, the phy-mode property needs to be "rgmii-id",  which
has the following meaning as per
Documentation/devicetree/bindings/net/ethernet.txt:

"RGMII with internal RX and TX delays provided by the PHY, the MAC should
not add the RX or TX delays in this case)"

Tested on imx6-sabresd, imx6sx-sdb and imx7d-pico boards with
successfully restored networking.

Based on the initial submission from Steve Twiss for the
imx6qdl-sabresd.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Tested-by: Baruch Siach <baruch@tkos.co.il>
Tested-by: Soeren Moch <smoch@web.de>
Tested-by: Steve Twiss <stwiss.opensource@diasemi.com>
Tested-by: Adam Thomson <Adam.Thomson@diasemi.com>
Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Cc: "George G. Davis" <george_davis@mentor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi |    2 +-
 arch/arm/boot/dts/imx6dl-riotboard.dts        |    2 +-
 arch/arm/boot/dts/imx6q-ba16.dtsi             |    2 +-
 arch/arm/boot/dts/imx6q-marsboard.dts         |    2 +-
 arch/arm/boot/dts/imx6q-tbs2910.dts           |    2 +-
 arch/arm/boot/dts/imx6qdl-apf6.dtsi           |    2 +-
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi      |    2 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi        |    2 +-
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi         |    2 +-
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi      |    2 +-
 arch/arm/boot/dts/imx6sx-sabreauto.dts        |    2 +-
 arch/arm/boot/dts/imx6sx-sdb.dtsi             |    2 +-
 arch/arm/boot/dts/imx7d-pico.dtsi             |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

--- a/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi
+++ b/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi
@@ -216,7 +216,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-reset-duration = <10>;
 	phy-reset-gpios = <&gpio1 24 GPIO_ACTIVE_LOW>;
 	phy-supply = <&reg_enet>;
--- a/arch/arm/boot/dts/imx6dl-riotboard.dts
+++ b/arch/arm/boot/dts/imx6dl-riotboard.dts
@@ -92,7 +92,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
--- a/arch/arm/boot/dts/imx6q-ba16.dtsi
+++ b/arch/arm/boot/dts/imx6q-ba16.dtsi
@@ -171,7 +171,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 
--- a/arch/arm/boot/dts/imx6q-marsboard.dts
+++ b/arch/arm/boot/dts/imx6q-marsboard.dts
@@ -110,7 +110,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
--- a/arch/arm/boot/dts/imx6q-tbs2910.dts
+++ b/arch/arm/boot/dts/imx6q-tbs2910.dts
@@ -98,7 +98,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
--- a/arch/arm/boot/dts/imx6qdl-apf6.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-apf6.dtsi
@@ -51,7 +51,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-reset-duration = <10>;
 	phy-reset-gpios = <&gpio1 24 GPIO_ACTIVE_LOW>;
 	status = "okay";
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -292,7 +292,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -202,7 +202,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
--- a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
@@ -53,7 +53,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_microsom_enet_ar8035>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-reset-duration = <2>;
 	phy-reset-gpios = <&gpio4 15 GPIO_ACTIVE_LOW>;
 	status = "okay";
--- a/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
@@ -224,7 +224,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio3 29 GPIO_ACTIVE_LOW>;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
--- a/arch/arm/boot/dts/imx6sx-sabreauto.dts
+++ b/arch/arm/boot/dts/imx6sx-sabreauto.dts
@@ -75,7 +75,7 @@
 &fec1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ethphy1>;
 	fsl,magic-packet;
 	status = "okay";
--- a/arch/arm/boot/dts/imx6sx-sdb.dtsi
+++ b/arch/arm/boot/dts/imx6sx-sdb.dtsi
@@ -191,7 +191,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet1>;
 	phy-supply = <&reg_enet_3v3>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ethphy1>;
 	phy-reset-gpios = <&gpio2 7 GPIO_ACTIVE_LOW>;
 	status = "okay";
--- a/arch/arm/boot/dts/imx7d-pico.dtsi
+++ b/arch/arm/boot/dts/imx7d-pico.dtsi
@@ -92,7 +92,7 @@
 			  <&clks IMX7D_ENET1_TIME_ROOT_CLK>;
 	assigned-clock-parents = <&clks IMX7D_PLL_ENET_MAIN_100M_CLK>;
 	assigned-clock-rates = <0>, <100000000>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ethphy0>;
 	fsl,magic-packet;
 	phy-reset-gpios = <&gpio6 11 GPIO_ACTIVE_LOW>;


