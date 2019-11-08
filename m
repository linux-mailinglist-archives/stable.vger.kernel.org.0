Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E54F4AF2
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391472AbfKHMMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:12:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732771AbfKHLil (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 655E421D6C;
        Fri,  8 Nov 2019 11:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213121;
        bh=Q4mGNBQr66Q94q9GgnenfCd+MuSvKRlgye09kJ8YuMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlPVRw/hJOxJNi5OclxYXM1GMNU30Y7f6Oq3eXWL8UmxrUv8k4Dbjp9l1KJdO67sW
         jRb++jGVc0wbBx446EMctI3Ea9ktvcMDPYi99Ju5O6rPUO4lpwE7REIWsB3eYKh6Ln
         qiBXi0dCDyL3V3Nqjev+k7V9htNh+3ZWYDrBcTqo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 040/205] ARM: dts: exynos: Use i2c-gpio for HDMI-DDC on Arndale
Date:   Fri,  8 Nov 2019 06:35:07 -0500
Message-Id: <20191108113752.12502-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrzej Hajda <a.hajda@samsung.com>

[ Upstream commit 620375c8fdf2f9f5110ed48d6c407cc4b7554f86 ]

HDMI-DDC for unknown reasons doesn't work with Exynos I2C controllers.
Fortunately i2c-gpio comes to the rescue.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250-arndale.dts  | 28 ++++++++++++++++-------
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi |  6 +++++
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index 7a8a5c55701a8..bb3fcd652b5d7 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -150,7 +150,7 @@
 
 &hdmi {
 	status = "okay";
-	ddc = <&i2c_2>;
+	ddc = <&i2c_ddc>;
 	hpd-gpios = <&gpx3 7 GPIO_ACTIVE_LOW>;
 	vdd_osc-supply = <&ldo10_reg>;
 	vdd_pll-supply = <&ldo8_reg>;
@@ -452,13 +452,6 @@
 	};
 };
 
-&i2c_2 {
-	status = "okay";
-	/* used by HDMI DDC */
-	samsung,i2c-sda-delay = <100>;
-	samsung,i2c-max-bus-freq = <66000>;
-};
-
 &i2c_3 {
 	status = "okay";
 
@@ -547,3 +540,22 @@
 	status = "okay";
 	samsung,exynos-sataphy-i2c-phandle = <&sata_phy_i2c>;
 };
+
+&soc {
+	/*
+	 * For unknown reasons HDMI-DDC does not work with Exynos I2C
+	 * controllers. Lets use software I2C over GPIO pins as a workaround.
+	 */
+	i2c_ddc: i2c-gpio {
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c2_gpio_bus>;
+		status = "okay";
+		compatible = "i2c-gpio";
+		gpios = <&gpa0 6 0 /* sda */
+			 &gpa0 7 0 /* scl */
+			>;
+		i2c-gpio,delay-us = <2>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+};
diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
index 6ff6dea29d449..b25d520393b8b 100644
--- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
@@ -225,6 +225,12 @@
 		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
 	};
 
+	i2c2_gpio_bus: i2c2-gpio-bus {
+		samsung,pins = "gpa0-6", "gpa0-7";
+		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
+		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
+	};
+
 	uart2_data: uart2-data {
 		samsung,pins = "gpa1-0", "gpa1-1";
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
-- 
2.20.1

