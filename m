Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FFC3C8C51
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhGNTlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233582AbhGNTlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E347613D9;
        Wed, 14 Jul 2021 19:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291524;
        bh=Qvj33VIWp7WrGcxJXUht7O4+SVF+0t/IgEqeLtpRUjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUEOFfBrAnsYch+BM4p8GGlH0NWqWa5jo65Lz46MjMWUo8ajyRXZDmezcgqyxklHZ
         6rfXzkYn5dusQYqPvUZBxnLd92wDkCdGi4RbMjcKraXZhpj6eEFKr9nRAvrfS2EKCV
         zwkyP3YGQ5siDqmdrCDp/L5eUB+l4MpxltG+L3KNXniwiOrNGqyYh0lY/uH+yZs3bi
         kmvQUyz015mgBbkWzMjMLumjeTpScGmlUj0E7gOyO50zmodJPI4d7eVoa5UfqxWKK1
         E/apATq8ZYFRtOtVRSq5dYA6eLEg5yGAWT4XOvXkMGFTRBpqSpt3SOlEOH0wQ/XlWz
         FfSwyBGnvxA6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 029/108] arm64: dts: rockchip: fix regulator-gpio states array
Date:   Wed, 14 Jul 2021 15:36:41 -0400
Message-Id: <20210714193800.52097-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit b82f8e2992534aab0fa762a37376be30df263701 ]

A test with the command below gives this error:

/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dt.yaml:
sdmmcio-regulator: states:0:
[1800000, 1, 3300000, 0] is too long

dtbs_check expects regulator-gpio states in a format
of 2 per item, so fix them all.

make ARCH=arm64 dtbs_check
DT_SCHEMA_FILES=Documentation/devicetree/bindings/
regulator/gpio-regulator.yaml

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210510215840.16270-1-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts       | 4 ++--
 arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts   | 4 ++--
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts       | 4 ++--
 arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi | 2 +-
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi         | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
index 3dddd4742c3a..665b2e69455d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
@@ -84,8 +84,8 @@ vcc_sdmmc: vcc-sdmmc {
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <3300000>;
 		gpios = <&gpio0 RK_PA7 GPIO_ACTIVE_HIGH>;
-		states = <1800000 0x0
-			  3300000 0x1>;
+		states = <1800000 0x0>,
+			 <3300000 0x1>;
 		vin-supply = <&vcc5v0_sys>;
 	};
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
index f807bc066ccb..d5001d13e374 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
@@ -76,8 +76,8 @@ vcc_io_sdio: sdmmcio-regulator {
 		regulator-settling-time-us = <5000>;
 		regulator-type = "voltage";
 		startup-delay-us = <2000>;
-		states = <1800000 0x1
-			  3300000 0x0>;
+		states = <1800000 0x1>,
+			 <3300000 0x0>;
 		vin-supply = <&vcc_io_33>;
 	};
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
index a05732b59f38..a99979afd373 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
@@ -50,8 +50,8 @@ vcc_sd: sdmmc-regulator {
 	vcc_sdio: sdmmcio-regulator {
 		compatible = "regulator-gpio";
 		gpios = <&grf_gpio 0 GPIO_ACTIVE_HIGH>;
-		states = <1800000 0x1
-			  3300000 0x0>;
+		states = <1800000 0x1>,
+			 <3300000 0x0>;
 		regulator-name = "vcc_sdio";
 		regulator-type = "voltage";
 		regulator-min-microvolt = <1800000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
index beee5fbb3443..5d7a9d96d163 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
@@ -245,7 +245,7 @@ &ppvar_gpu_pwm {
 };
 
 &ppvar_sd_card_io {
-	states = <1800000 0x0 3300000 0x1>;
+	states = <1800000 0x0>, <3300000 0x1>;
 	regulator-max-microvolt = <3300000>;
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
index 4002742fed4c..c1bcc8ca3769 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
@@ -252,8 +252,8 @@ ppvar_sd_card_io: ppvar-sd-card-io {
 		enable-active-high;
 		enable-gpio = <&gpio2 2 GPIO_ACTIVE_HIGH>;
 		gpios = <&gpio2 28 GPIO_ACTIVE_HIGH>;
-		states = <1800000 0x1
-			  3000000 0x0>;
+		states = <1800000 0x1>,
+			 <3000000 0x0>;
 
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <3000000>;
-- 
2.30.2

