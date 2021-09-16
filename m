Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD0740E086
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241574AbhIPQVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241743AbhIPQUE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:20:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3958D613DB;
        Thu, 16 Sep 2021 16:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808852;
        bh=SwozLfpYiQLE0tIiO65mXXvojnIJlmmHkdaJkfgdxgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCBHf4DVnypjL5FEAxMV2SOmnd08ApT6WXNlYDVQRXe0IlmlGUIGG9nLClfpRSZTU
         Yb3LHEuxcADeSv5ls6CCWR8rjjrl7Z0I15uPVZ1BixMsTdrgJVVzv+MfHno9Y3fsOs
         Te5pB3ybaZHzwOkDmzaDF93WCDPapbABz0zCirKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/306] ARM: tegra: acer-a500: Remove bogus USB VBUS regulators
Date:   Thu, 16 Sep 2021 17:59:19 +0200
Message-Id: <20210916155801.333549648@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



