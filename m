Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D17EFF64F9
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfKJDDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728279AbfKJCrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:47:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9866321924;
        Sun, 10 Nov 2019 02:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354035;
        bh=gSm9oRdRrYfITQXHwTWIL/rl9M+mtIAsSkvM8yEWsCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+9xt3jivdyOCthtOZUbw38c+NCtZthnN9YhQeR2Aicv4+x+aiooCPQpGH/4jH3cs
         WD01cVPhck84Pt4ZZKQoce8XlmMHfNSc7LvWvWWdWDMHefKbKP7uA3AFVkkiGyVtYk
         kRItv0Q1lox4FJlO35GI7NBBuN9EJ24/hI1Tp1G8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vicente Bergas <vicencb@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 049/109] arm64: dts: rockchip: Fix microSD in rk3399 sapphire board
Date:   Sat,  9 Nov 2019 21:44:41 -0500
Message-Id: <20191110024541.31567-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vicente Bergas <vicencb@gmail.com>

[ Upstream commit 88a20edf76091ee7f1bb459b89d714d53f0f8940 ]

The microSD card slot in the Sapphire board is not working because of
several issues:
 1.- The vmmc power supply is missing in the DTS. It is capable of 3.0V
 and has a GPIO-based enable control.
 2.- The vqmmc power supply can provide up to 3.3V, but it is capped in
 the DTS to just 3.0V because of the vmmc capability. This results in a
 conflict from the mmc driver requesting an unsupportable voltage range
 from 3.3V to 3.0V (min > max) as reported in dmesg. So, extend the
 range up to 3.3V. The hw should be able to stand this 0.3V tolerance.
 See mmc_regulator_set_vqmmc in drivers/mmc/core/core.c.
 3.- The card detect signal is non-working. There is a known conflict
 with jtag, but the workaround in drivers/soc/rockchip/grf.c does not
 work. Adding the broken-cd attribute to the DTS fixes the issue.

Signed-off-by: Vicente Bergas <vicencb@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3399-sapphire.dtsi    | 24 ++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
index ce592a4c0c4cd..6e40133372a80 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
@@ -113,6 +113,19 @@
 		vin-supply = <&vcc_1v8>;
 	};
 
+	vcc3v0_sd: vcc3v0-sd {
+		compatible = "regulator-fixed";
+		enable-active-high;
+		gpio = <&gpio0 RK_PA1 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&sdmmc0_pwr_h>;
+		regulator-always-on;
+		regulator-max-microvolt = <3000000>;
+		regulator-min-microvolt = <3000000>;
+		regulator-name = "vcc3v0_sd";
+		vin-supply = <&vcc3v3_sys>;
+	};
+
 	vcc3v3_sys: vcc3v3-sys {
 		compatible = "regulator-fixed";
 		regulator-name = "vcc3v3_sys";
@@ -315,7 +328,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-min-microvolt = <1800000>;
-				regulator-max-microvolt = <3000000>;
+				regulator-max-microvolt = <3300000>;
 				regulator-state-mem {
 					regulator-on-in-suspend;
 					regulator-suspend-microvolt = <3000000>;
@@ -490,6 +503,13 @@
 		};
 	};
 
+	sd {
+		sdmmc0_pwr_h: sdmmc0-pwr-h {
+			rockchip,pins =
+				<RK_GPIO0 RK_PA1 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	usb2 {
 		vcc5v0_host_en: vcc5v0-host-en {
 			rockchip,pins =
@@ -537,6 +557,7 @@
 };
 
 &sdmmc {
+	broken-cd;
 	bus-width = <4>;
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
@@ -545,6 +566,7 @@
 	max-frequency = <150000000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc_clk &sdmmc_cmd &sdmmc_cd &sdmmc_bus4>;
+	vmmc-supply = <&vcc3v0_sd>;
 	vqmmc-supply = <&vcc_sdio>;
 	status = "okay";
 };
-- 
2.20.1

