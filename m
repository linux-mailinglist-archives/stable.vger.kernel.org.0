Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0293404F61
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbhIIMSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:18:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352802AbhIIMPK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:15:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65FE061A70;
        Thu,  9 Sep 2021 11:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188167;
        bh=0eTw5P6iYqwSw1BrVYj2sjwzk0zF74aJAqhlwHsUrws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npIB8KzdXZQJstgRkrFW/vUerVZc4xoGzJy+/aUIlwdkxIlxMGo8cqVIZR8tc7+Ko
         ZsUIi7diJ1Fyfmw02lM1oaHq5Ik+b+B8H61e1JFUTu6MFpLQlb2wUlChiprvOELdtm
         BdSSBJXKnr3OvfDNGw24Sb9HwbKqr0A7Piaf0OUN6o2dp68jmMFtJM8IBLyTgycxSY
         STvBFy3aR0kqD5E/9V0aeX0O/xLp/Aa9PsjydWVOkAub9c3Q9gI5EWLxzIeiSPqYRw
         kjXki3UZ/8cS8Ph/4DxiOT0FMiQTqfoG/x23lsn+gpKmvV3tHFMDsyKaunZ+02OKhl
         AFF8tDY/lnGtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 132/219] ARM: tegra: acer-a500: Remove bogus USB VBUS regulators
Date:   Thu,  9 Sep 2021 07:45:08 -0400
Message-Id: <20210909114635.143983-132-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 14cd3238355b..2c74993f1a9e 100644
--- a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
+++ b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
@@ -716,7 +716,6 @@ usb-phy@c5000000 {
 		nvidia,xcvr-setup-use-fuses;
 		nvidia,xcvr-lsfslew = <2>;
 		nvidia,xcvr-lsrslew = <2>;
-		vbus-supply = <&vdd_vbus1>;
 	};
 
 	usb@c5008000 {
@@ -728,7 +727,7 @@ usb-phy@c5008000 {
 		nvidia,xcvr-setup-use-fuses;
 		nvidia,xcvr-lsfslew = <2>;
 		nvidia,xcvr-lsrslew = <2>;
-		vbus-supply = <&vdd_vbus3>;
+		vbus-supply = <&vdd_5v0_sys>;
 	};
 
 	brcm_wifi_pwrseq: wifi-pwrseq {
@@ -988,28 +987,6 @@ vdd_pnl: regulator@3 {
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

