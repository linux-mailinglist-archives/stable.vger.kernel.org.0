Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C834051D6
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352741AbhIIMi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353756AbhIIMe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:34:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82FD961B5E;
        Thu,  9 Sep 2021 11:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188418;
        bh=SwozLfpYiQLE0tIiO65mXXvojnIJlmmHkdaJkfgdxgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rg3EsMbHeM9R/AWfgkNWjHCdreuWh8C3Lo8oyBIO+wkf1WKphSrvtDcuS18Kt1wFC
         4Y983qKU/jLSYtRBVGnCct8iP2HWoS1KQ3GR2QNdHMJYOcxBleiVU1kbiGfuvW0xyJ
         smOWHGWza+jOhL6aDDnjGa8oBaNRWKjxYjvdb87D+XmrXz1CT8tjDl76sQ3a9zQnSx
         PDQLXCFHJKoQNo+4ICmYW6VudP/9QeT2frF9NtFG8lE5ytNysnittIoFPn+DDqT0ln
         XmwoJJvuhoSzqhUBqkkiN+aua6p7zJAvrZQX9OCNVfeJutYF6GC8VbB45DGB3Z7vsu
         lQrDy0aOZUIuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 108/176] ARM: tegra: acer-a500: Remove bogus USB VBUS regulators
Date:   Thu,  9 Sep 2021 07:50:10 -0400
Message-Id: <20210909115118.146181-108-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 70e740ad55e5f93a19493720f4105555fade4a73 ]

The configuration of USB VBUS regulators was borrowed from downstream
kernel, which is incorrect because the corresponding GPIOs are connected
to PROX_EN (A501 3G model) and LED_EN pins in accordance to the board
schematics. USB works fine with both GPIOs being disabled, so remove the
bogus USB VBUS regulators. The USB VBUS of USB3 is supplied from the fixed
5v system regulator and device-mode USB1 doesn't have VBUS switches.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/tegra20-acer-a500-picasso.dts    | 25 +------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
index 5d0f0fbba1d2..5dbfb83c1b06 100644
--- a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
+++ b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
@@ -704,7 +704,6 @@ usb-phy@c5000000 {
 		nvidia,xcvr-setup-use-fuses;
 		nvidia,xcvr-lsfslew = <2>;
 		nvidia,xcvr-lsrslew = <2>;
-		vbus-supply = <&vdd_vbus1>;
 	};
 
 	usb@c5008000 {
@@ -716,7 +715,7 @@ usb-phy@c5008000 {
 		nvidia,xcvr-setup-use-fuses;
 		nvidia,xcvr-lsfslew = <2>;
 		nvidia,xcvr-lsrslew = <2>;
-		vbus-supply = <&vdd_vbus3>;
+		vbus-supply = <&vdd_5v0_sys>;
 	};
 
 	brcm_wifi_pwrseq: wifi-pwrseq {
@@ -967,28 +966,6 @@ vdd_pnl: regulator@3 {
 		vin-supply = <&vdd_5v0_sys>;
 	};
 
-	vdd_vbus1: regulator@4 {
-		compatible = "regulator-fixed";
-		regulator-name = "vdd_usb1_vbus";
-		regulator-min-microvolt = <5000000>;
-		regulator-max-microvolt = <5000000>;
-		regulator-always-on;
-		gpio = <&gpio TEGRA_GPIO(D, 0) GPIO_ACTIVE_HIGH>;
-		enable-active-high;
-		vin-supply = <&vdd_5v0_sys>;
-	};
-
-	vdd_vbus3: regulator@5 {
-		compatible = "regulator-fixed";
-		regulator-name = "vdd_usb3_vbus";
-		regulator-min-microvolt = <5000000>;
-		regulator-max-microvolt = <5000000>;
-		regulator-always-on;
-		gpio = <&gpio TEGRA_GPIO(D, 3) GPIO_ACTIVE_HIGH>;
-		enable-active-high;
-		vin-supply = <&vdd_5v0_sys>;
-	};
-
 	sound {
 		compatible = "nvidia,tegra-audio-wm8903-picasso",
 			     "nvidia,tegra-audio-wm8903";
-- 
2.30.2

