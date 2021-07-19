Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB233CE38E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbhGSPkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349033AbhGSPfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E67FE61283;
        Mon, 19 Jul 2021 16:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711359;
        bh=sYAem16VqUqLD/uB6TbBoCxDXXCGI+F8rq4lvRX6WMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPFXNCuuzH2MCd0eLdctKv1X7b87LmJKV89qkJ9HMmmUZett/77R+pu+JgUtNOhhH
         UIUN99l6ESgAA8flvhdfe81SZVJG0l8VLqjb6MbS7/Q7jjSCQ3EpTArvCPWCrD8mBy
         ZGO6MRb3UI55vUJe1ggSvfwHPm1Go7UJHR90B0pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Marek Vasut <marex@denx.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        kernel@dh-electronics.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 325/351] ARM: dts: imx6q-dhcom: Add gpios pinctrl for i2c bus recovery
Date:   Mon, 19 Jul 2021 16:54:31 +0200
Message-Id: <20210719144955.810362798@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Niedermaier <cniedermaier@dh-electronics.com>

[ Upstream commit ddc873cd3c0af4faad6a00bffda21c3f775126dd ]

The i2c bus can freeze at the end of transaction so the bus can no longer work.
This scenario is improved by adding scl/sda gpios definitions to implement the
i2c bus recovery mechanism.

Fixes: 52c7a088badd ("ARM: dts: imx6q: Add support for the DHCOM iMX6 SoM and PDK2")
Signed-off-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Marek Vasut <marex@denx.de>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: kernel@dh-electronics.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi | 36 +++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
index 6043be73a1a8..e3de2b487cf4 100644
--- a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
@@ -105,22 +105,31 @@
 
 &i2c1 {
 	clock-frequency = <100000>;
-	pinctrl-names = "default";
+	pinctrl-names = "default", "gpio";
 	pinctrl-0 = <&pinctrl_i2c1>;
+	pinctrl-1 = <&pinctrl_i2c1_gpio>;
+	scl-gpios = <&gpio3 21 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+	sda-gpios = <&gpio3 28 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 	status = "okay";
 };
 
 &i2c2 {
 	clock-frequency = <100000>;
-	pinctrl-names = "default";
+	pinctrl-names = "default", "gpio";
 	pinctrl-0 = <&pinctrl_i2c2>;
+	pinctrl-1 = <&pinctrl_i2c2_gpio>;
+	scl-gpios = <&gpio4 12 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+	sda-gpios = <&gpio4 13 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 	status = "okay";
 };
 
 &i2c3 {
 	clock-frequency = <100000>;
-	pinctrl-names = "default";
+	pinctrl-names = "default", "gpio";
 	pinctrl-0 = <&pinctrl_i2c3>;
+	pinctrl-1 = <&pinctrl_i2c3_gpio>;
+	scl-gpios = <&gpio1 3 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+	sda-gpios = <&gpio1 6 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 	status = "okay";
 
 	ltc3676: pmic@3c {
@@ -286,6 +295,13 @@
 		>;
 	};
 
+	pinctrl_i2c1_gpio: i2c1-gpio-grp {
+		fsl,pins = <
+			MX6QDL_PAD_EIM_D21__GPIO3_IO21		0x4001b8b1
+			MX6QDL_PAD_EIM_D28__GPIO3_IO28		0x4001b8b1
+		>;
+	};
+
 	pinctrl_i2c2: i2c2-grp {
 		fsl,pins = <
 			MX6QDL_PAD_KEY_COL3__I2C2_SCL		0x4001b8b1
@@ -293,6 +309,13 @@
 		>;
 	};
 
+	pinctrl_i2c2_gpio: i2c2-gpio-grp {
+		fsl,pins = <
+			MX6QDL_PAD_KEY_COL3__GPIO4_IO12		0x4001b8b1
+			MX6QDL_PAD_KEY_ROW3__GPIO4_IO13		0x4001b8b1
+		>;
+	};
+
 	pinctrl_i2c3: i2c3-grp {
 		fsl,pins = <
 			MX6QDL_PAD_GPIO_3__I2C3_SCL		0x4001b8b1
@@ -300,6 +323,13 @@
 		>;
 	};
 
+	pinctrl_i2c3_gpio: i2c3-gpio-grp {
+		fsl,pins = <
+			MX6QDL_PAD_GPIO_3__GPIO1_IO03		0x4001b8b1
+			MX6QDL_PAD_GPIO_6__GPIO1_IO06		0x4001b8b1
+		>;
+	};
+
 	pinctrl_pmic_hw300: pmic-hw300-grp {
 		fsl,pins = <
 			MX6QDL_PAD_EIM_A25__GPIO5_IO02		0x1B0B0
-- 
2.30.2



