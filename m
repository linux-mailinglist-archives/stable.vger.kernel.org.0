Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD89450E67
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbhKOSOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:14:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240232AbhKOSH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CCA363398;
        Mon, 15 Nov 2021 17:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998217;
        bh=1CdcMoD7T6sL+FA2oBmbmtdO2KvatlXTNgWgcvXBMxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iU83h8UAuLYb4F9YlEUFOfhBDXA4AngUh7k75R9MR38Ij2jXt60g3QOxD0zaPzrWZ
         tbgZWefwZcm3obH6MZRsP4YwRU9hajAZajW8dRyo9QaIkDtTdZKkoJjbPb55XhluRt
         w5qL3W6lzuFp3KYOuBSU0iLm47HmhWtcyXmW07qU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Anand Moon <linux.amoon@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 398/575] arm64: dts: meson-g12b: Fix the pwm regulator supply properties
Date:   Mon, 15 Nov 2021 18:02:03 +0100
Message-Id: <20211115165357.538231932@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit 62183863f708c2464769e0d477c8ce9f3d326feb ]

After enabling CONFIG_REGULATOR_DEBUG=y we observer below debug logs.
Changes help link VDDCP_A and VDDCPU_B pwm regulator to 12V regulator
supply instead of dummy regulator.

[    4.147196] VDDCPU_A: will resolve supply early: pwm
[    4.147216] pwm-regulator regulator-vddcpu-a: Looking up pwm-supply from device tree
[    4.147227] pwm-regulator regulator-vddcpu-a: Looking up pwm-supply property in node /regulator-vddcpu-a failed
[    4.147258] VDDCPU_A: supplied by regulator-dummy
[    4.147288] regulator-dummy: could not add device link regulator.12: -ENOENT
[    4.147353] VDDCPU_A: 721 <--> 1022 mV at 871 mV, enabled
[    4.152014] VDDCPU_B: will resolve supply early: pwm
[    4.152035] pwm-regulator regulator-vddcpu-b: Looking up pwm-supply from device tree
[    4.152047] pwm-regulator regulator-vddcpu-b: Looking up pwm-supply property in node /regulator-vddcpu-b failed
[    4.152079] VDDCPU_B: supplied by regulator-dummy
[    4.152108] regulator-dummy: could not add device link regulator.13: -ENOENT

Fixes: c6d29c66e582 ("arm64: dts: meson-g12b-khadas-vim3: add initial device-tree")
Fixes: d14734a04a8a ("arm64: dts: meson-g12b-odroid-n2: enable DVFS")
Fixes: 3cb74db9b256 ("arm64: dts: meson: convert ugoos-am6 to common w400 dtsi")

Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20210919202918.3556-3-linux.amoon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi | 4 ++--
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi   | 4 ++--
 arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi        | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi
index f42cf4b8af2d4..16dd409051b40 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi
@@ -18,7 +18,7 @@
 		regulator-min-microvolt = <690000>;
 		regulator-max-microvolt = <1050000>;
 
-		vin-supply = <&dc_in>;
+		pwm-supply = <&dc_in>;
 
 		pwms = <&pwm_ab 0 1250 0>;
 		pwm-dutycycle-range = <100 0>;
@@ -37,7 +37,7 @@
 		regulator-min-microvolt = <690000>;
 		regulator-max-microvolt = <1050000>;
 
-		vin-supply = <&vsys_3v3>;
+		pwm-supply = <&vsys_3v3>;
 
 		pwms = <&pwm_AO_cd 1 1250 0>;
 		pwm-dutycycle-range = <100 0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
index 39a09661c5f62..59b5f39088757 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
@@ -128,7 +128,7 @@
 		regulator-min-microvolt = <721000>;
 		regulator-max-microvolt = <1022000>;
 
-		vin-supply = <&main_12v>;
+		pwm-supply = <&main_12v>;
 
 		pwms = <&pwm_ab 0 1250 0>;
 		pwm-dutycycle-range = <100 0>;
@@ -147,7 +147,7 @@
 		regulator-min-microvolt = <721000>;
 		regulator-max-microvolt = <1022000>;
 
-		vin-supply = <&main_12v>;
+		pwm-supply = <&main_12v>;
 
 		pwms = <&pwm_AO_cd 1 1250 0>;
 		pwm-dutycycle-range = <100 0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi
index feb0885047400..b40d2c1002c92 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi
@@ -96,7 +96,7 @@
 		regulator-min-microvolt = <721000>;
 		regulator-max-microvolt = <1022000>;
 
-		vin-supply = <&main_12v>;
+		pwm-supply = <&main_12v>;
 
 		pwms = <&pwm_ab 0 1250 0>;
 		pwm-dutycycle-range = <100 0>;
@@ -115,7 +115,7 @@
 		regulator-min-microvolt = <721000>;
 		regulator-max-microvolt = <1022000>;
 
-		vin-supply = <&main_12v>;
+		pwm-supply = <&main_12v>;
 
 		pwms = <&pwm_AO_cd 1 1250 0>;
 		pwm-dutycycle-range = <100 0>;
-- 
2.33.0



