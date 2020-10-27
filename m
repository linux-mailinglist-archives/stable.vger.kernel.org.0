Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C159B29B560
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794365AbgJ0PL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794361AbgJ0PL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:11:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E916421D24;
        Tue, 27 Oct 2020 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811487;
        bh=NY6zUWyp4Q9m1nxkUjRJHZSZytY4h0qUVzUefWcCByo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4uhN1K2g9x0JyRc7yODcE/0VXg3/FRl99xAyDJHmqkFZwMtBT72p2My0iFZzAcGn
         qQGJf7QSiEMtOHLdNzkpvq3tYShgEX+5mVliNtF9yhwrHlYDDhWGM59hlNG/B7slXr
         T8ii7pob+rnwzNWLVbdvYEFT8QGdUNF92Qj1EGtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 509/633] ARM: dts: stm32: Move ethernet PHY into DH SoM DT
Date:   Tue, 27 Oct 2020 14:54:12 +0100
Message-Id: <20201027135546.613545750@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit b0a07f609600b6fa4c30f783db50c38456804485 ]

The PHY and the VIO regulator is populated on the SoM, move it
into the SoM DT.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Patrick Delaunay <patrick.delaunay@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi | 33 -----------------
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi  | 36 +++++++++++++++++++
 2 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index 7c4bd615b3115..9cf6d90fbf69f 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -11,7 +11,6 @@ aliases {
 		serial0 = &uart4;
 		serial1 = &usart3;
 		serial2 = &uart8;
-		ethernet0 = &ethernet0;
 	};
 
 	chosen {
@@ -33,16 +32,6 @@ display_bl: display-bl {
 		status = "okay";
 	};
 
-	ethernet_vio: vioregulator {
-		compatible = "regulator-fixed";
-		regulator-name = "vio";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-		gpio = <&gpiog 3 GPIO_ACTIVE_LOW>;
-		regulator-always-on;
-		regulator-boot-on;
-	};
-
 	gpio-keys-polled {
 		compatible = "gpio-keys-polled";
 		#size-cells = <0>;
@@ -141,28 +130,6 @@ &cec {
 	status = "okay";
 };
 
-&ethernet0 {
-	status = "okay";
-	pinctrl-0 = <&ethernet0_rmii_pins_a>;
-	pinctrl-1 = <&ethernet0_rmii_sleep_pins_a>;
-	pinctrl-names = "default", "sleep";
-	phy-mode = "rmii";
-	max-speed = <100>;
-	phy-handle = <&phy0>;
-	st,eth-ref-clk-sel;
-	phy-reset-gpios = <&gpioh 15 GPIO_ACTIVE_LOW>;
-
-	mdio0 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "snps,dwmac-mdio";
-
-		phy0: ethernet-phy@1 {
-			reg = <1>;
-		};
-	};
-};
-
 &i2c2 {	/* Header X22 */
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c2_pins_a>;
diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index ba905196fb549..d30a3c60da9b0 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -9,6 +9,10 @@
 #include <dt-bindings/mfd/st,stpmic1.h>
 
 / {
+	aliases {
+		ethernet0 = &ethernet0;
+	};
+
 	memory@c0000000 {
 		device_type = "memory";
 		reg = <0xC0000000 0x40000000>;
@@ -55,6 +59,16 @@ retram: retram@38000000 {
 			no-map;
 		};
 	};
+
+	ethernet_vio: vioregulator {
+		compatible = "regulator-fixed";
+		regulator-name = "vio";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpiog 3 GPIO_ACTIVE_LOW>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
 };
 
 &adc {
@@ -94,6 +108,28 @@ &dts {
 	status = "okay";
 };
 
+&ethernet0 {
+	status = "okay";
+	pinctrl-0 = <&ethernet0_rmii_pins_a>;
+	pinctrl-1 = <&ethernet0_rmii_sleep_pins_a>;
+	pinctrl-names = "default", "sleep";
+	phy-mode = "rmii";
+	max-speed = <100>;
+	phy-handle = <&phy0>;
+	st,eth-ref-clk-sel;
+	phy-reset-gpios = <&gpioh 15 GPIO_ACTIVE_LOW>;
+
+	mdio0 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "snps,dwmac-mdio";
+
+		phy0: ethernet-phy@1 {
+			reg = <1>;
+		};
+	};
+};
+
 &i2c4 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c4_pins_a>;
-- 
2.25.1



