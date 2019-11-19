Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 544E21013AF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfKSF0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:26:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbfKSF0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:26:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C06AA21823;
        Tue, 19 Nov 2019 05:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141181;
        bh=Q4mGNBQr66Q94q9GgnenfCd+MuSvKRlgye09kJ8YuMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dV/T2qsZarKvrLUKpGXyBAWvujHUJljr3ipsdGSHw//Hq1lngsy5bbOFeMNcV/WH5
         lCtCsClo6Zs0sqdrYDbtjdqV/BkuebvVHlnisrF7qI4fnCWvx3jba8yReaDGS7txdf
         uz5LV2aRMhtYBjDSqdN9bugaWAtLrgDa2SCj1AdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/422] ARM: dts: exynos: Use i2c-gpio for HDMI-DDC on Arndale
Date:   Tue, 19 Nov 2019 06:14:29 +0100
Message-Id: <20191119051404.265698564@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



