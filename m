Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70596451419
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348987AbhKOUBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344271AbhKOTYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF80A63318;
        Mon, 15 Nov 2021 18:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002492;
        bh=+nzL5jL2Msra/ldR9ANkqWpVG1UVslXzPszADpIIPxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7bDH4fFgxy1/UZ8mj5djwwsPDA9ZgHCaiJ7k0QJRdv9mLTGKXgThkqJkaxsYdBSS
         8QqyUbtGQJmnDssv6+gPJqHw9qjPbP8FLU1VL9zmUqvSoTWud/motkkfm3OvOdKjIC
         Rfhj1UbjMg7gJT5xxbQBlRkgf4ROgXyphz9nYU4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Anand Moon <linux.amoon@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 586/917] arm64: dts: meson-sm1: Fix the pwm regulator supply properties
Date:   Mon, 15 Nov 2021 18:01:21 +0100
Message-Id: <20211115165448.639621620@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit 0b26fa8a02c2834f1fa8a206a285b9f84c4ad764 ]

After enabling CONFIG_REGULATOR_DEBUG=y we observe below debug logs.
Changes help link VDDCPU pwm regulator to 12V regulator supply
instead of dummy regulator.

[   11.602281] pwm-regulator regulator-vddcpu: Looking up pwm-supply property
               in node /regulator-vddcpu failed
[   11.602344] VDDCPU: supplied by regulator-dummy
[   11.602365] regulator-dummy: could not add device link regulator.11: -ENOENT
[   11.602548] VDDCPU: 721 <--> 1022 mV at 1022 mV, enabled

Fixes: 88d537bc92ca ("arm64: dts: meson: convert meson-sm1-odroid-c4 to dtsi")
Fixes: 700ab8d83927 ("arm64: dts: khadas-vim3: add support for the SM1 based VIM3L")
Fixes: 3d9e76483049 ("arm64: dts: meson-sm1-sei610: enable DVFS")
Fixes: 976e920183e4 ("arm64: dts: meson-sm1: add Banana PI BPI-M5 board dts")

Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20210919202918.3556-4-linux.amoon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts  | 2 +-
 arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts | 2 +-
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi      | 2 +-
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts       | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
index effaa138b5f98..212c6aa5a3b86 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
@@ -173,7 +173,7 @@
 		regulator-min-microvolt = <690000>;
 		regulator-max-microvolt = <1050000>;
 
-		vin-supply = <&dc_in>;
+		pwm-supply = <&dc_in>;
 
 		pwms = <&pwm_AO_cd 1 1250 0>;
 		pwm-dutycycle-range = <100 0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts
index f2c0981435944..9c0b544e22098 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts
@@ -24,7 +24,7 @@
 		regulator-min-microvolt = <690000>;
 		regulator-max-microvolt = <1050000>;
 
-		vin-supply = <&vsys_3v3>;
+		pwm-supply = <&vsys_3v3>;
 
 		pwms = <&pwm_AO_cd 1 1250 0>;
 		pwm-dutycycle-range = <100 0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
index 45e7fcb062f96..5779e70caccd3 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
@@ -116,7 +116,7 @@
 		regulator-min-microvolt = <721000>;
 		regulator-max-microvolt = <1022000>;
 
-		vin-supply = <&main_12v>;
+		pwm-supply = <&main_12v>;
 
 		pwms = <&pwm_AO_cd 1 1250 0>;
 		pwm-dutycycle-range = <100 0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
index 2194a778973f1..427475846fc70 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
@@ -185,7 +185,7 @@
 		regulator-min-microvolt = <690000>;
 		regulator-max-microvolt = <1050000>;
 
-		vin-supply = <&dc_in>;
+		pwm-supply = <&dc_in>;
 
 		pwms = <&pwm_AO_cd 1 1500 0>;
 		pwm-dutycycle-range = <100 0>;
-- 
2.33.0



