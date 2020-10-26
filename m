Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6764329A056
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409544AbgJZXvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409537AbgJZXvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25F6421655;
        Mon, 26 Oct 2020 23:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756308;
        bh=vHmqrWTIMqBzgAYlU6EOeufQRlGj0rQsxtQb2ln9D7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AafIE9dtQG841ubNWuYR4E4lnzut0uLo8WvAuRv0YABsF9iLIA6GQrN4n1jDHPfm6
         SbIxGErfrmy7IfPq464B09IJDesVyfyrPzyZgb5bYcM9wj5sV0IUSTkyw61XY8TDEf
         TBbSVFdZJYiLqtTWSKWjiugKyBBzspXu8uX0Gx2o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 133/147] ARM: dts: s5pv210: Enable audio on Aries boards
Date:   Mon, 26 Oct 2020 19:48:51 -0400
Message-Id: <20201026234905.1022767-133-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bakker <xc-racer2@live.ca>

[ Upstream commit cd972fe90008adf49de0790250c1275480ac5cdc ]

Both the Galaxy S and the Fascinate4G have a WM8994 codec, but they
differ slightly in their jack detection and micbias configuration.

Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210-aries.dtsi      | 10 +++
 arch/arm/boot/dts/s5pv210-fascinate4g.dts | 98 +++++++++++++++++++++++
 arch/arm/boot/dts/s5pv210-galaxys.dts     | 85 ++++++++++++++++++++
 3 files changed, 193 insertions(+)

diff --git a/arch/arm/boot/dts/s5pv210-aries.dtsi b/arch/arm/boot/dts/s5pv210-aries.dtsi
index 822207f63ee0a..a3f83f668ce14 100644
--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -47,6 +47,11 @@ mfc_right: region@51000000 {
 		};
 	};
 
+	bt_codec: bt_sco {
+		compatible = "linux,bt-sco";
+		#sound-dai-cells = <0>;
+	};
+
 	vibrator_pwr: regulator-fixed-0 {
 		compatible = "regulator-fixed";
 		regulator-name = "vibrator-en";
@@ -624,6 +629,11 @@ touchscreen@4a {
 	};
 };
 
+&i2s0 {
+	dmas = <&pdma0 9>, <&pdma0 10>, <&pdma0 11>;
+	status = "okay";
+};
+
 &mfc {
 	memory-region = <&mfc_left>, <&mfc_right>;
 };
diff --git a/arch/arm/boot/dts/s5pv210-fascinate4g.dts b/arch/arm/boot/dts/s5pv210-fascinate4g.dts
index 65eed01cfced1..ca064359dd308 100644
--- a/arch/arm/boot/dts/s5pv210-fascinate4g.dts
+++ b/arch/arm/boot/dts/s5pv210-fascinate4g.dts
@@ -35,6 +35,80 @@ vol-up {
 			linux,code = <KEY_VOLUMEUP>;
 		};
 	};
+
+	headset_micbias_reg: regulator-fixed-3 {
+		compatible = "regulator-fixed";
+		regulator-name = "Headset_Micbias";
+		gpio = <&gpj2 5 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&headset_micbias_ena>;
+	};
+
+	main_micbias_reg: regulator-fixed-4 {
+		compatible = "regulator-fixed";
+		regulator-name = "Main_Micbias";
+		gpio = <&gpj4 2 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&main_micbias_ena>;
+	};
+
+	sound {
+		compatible = "samsung,fascinate4g-wm8994";
+
+		model = "Fascinate4G";
+
+		extcon = <&fsa9480>;
+
+		main-micbias-supply = <&main_micbias_reg>;
+		headset-micbias-supply = <&headset_micbias_reg>;
+
+		earpath-sel-gpios = <&gpj2 6 GPIO_ACTIVE_HIGH>;
+
+		io-channels = <&adc 3>;
+		io-channel-names = "headset-detect";
+		headset-detect-gpios = <&gph0 6 GPIO_ACTIVE_HIGH>;
+		headset-key-gpios = <&gph3 6 GPIO_ACTIVE_HIGH>;
+
+		samsung,audio-routing =
+			"HP", "HPOUT1L",
+			"HP", "HPOUT1R",
+
+			"SPK", "SPKOUTLN",
+			"SPK", "SPKOUTLP",
+
+			"RCV", "HPOUT2N",
+			"RCV", "HPOUT2P",
+
+			"LINE", "LINEOUT2N",
+			"LINE", "LINEOUT2P",
+
+			"IN1LP", "Main Mic",
+			"IN1LN", "Main Mic",
+
+			"IN1RP", "Headset Mic",
+			"IN1RN", "Headset Mic",
+
+			"Modem Out", "Modem TX",
+			"Modem RX", "Modem In",
+
+			"Bluetooth SPK", "TX",
+			"RX", "Bluetooth Mic";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&headset_det &earpath_sel>;
+
+		cpu {
+			sound-dai = <&i2s0>, <&bt_codec>;
+		};
+
+		codec {
+			sound-dai = <&wm8994>;
+		};
+	};
 };
 
 &fg {
@@ -51,6 +125,12 @@ &pinctrl0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sleep_cfg>;
 
+	headset_det: headset-det {
+		samsung,pins = "gph0-6", "gph3-6";
+		samsung,pin-function = <EXYNOS_PIN_FUNC_F>;
+		samsung,pin-pud = <S3C64XX_PIN_PULL_NONE>;
+	};
+
 	fg_irq: fg-irq {
 		samsung,pins = "gph3-3";
 		samsung,pin-function = <EXYNOS_PIN_FUNC_F>;
@@ -58,6 +138,24 @@ fg_irq: fg-irq {
 		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
 	};
 
+	headset_micbias_ena: headset-micbias-ena {
+		samsung,pins = "gpj2-5";
+		samsung,pin-pud = <S3C64XX_PIN_PULL_NONE>;
+		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
+	};
+
+	earpath_sel: earpath-sel {
+		samsung,pins = "gpj2-6";
+		samsung,pin-pud = <S3C64XX_PIN_PULL_NONE>;
+		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
+	};
+
+	main_micbias_ena: main-micbias-ena {
+		samsung,pins = "gpj4-2";
+		samsung,pin-pud = <S3C64XX_PIN_PULL_NONE>;
+		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
+	};
+
 	/* Based on vendor kernel v2.6.35.7 */
 	sleep_cfg: sleep-cfg {
 		PIN_SLP(gpa0-0, PREV, NONE);
diff --git a/arch/arm/boot/dts/s5pv210-galaxys.dts b/arch/arm/boot/dts/s5pv210-galaxys.dts
index 5d10dd67eacc5..560f830b6f6be 100644
--- a/arch/arm/boot/dts/s5pv210-galaxys.dts
+++ b/arch/arm/boot/dts/s5pv210-galaxys.dts
@@ -72,6 +72,73 @@ fmradio@10 {
 			pinctrl-0 = <&fm_irq &fm_rst>;
 		};
 	};
+
+	micbias_reg: regulator-fixed-3 {
+		compatible = "regulator-fixed";
+		regulator-name = "MICBIAS";
+		gpio = <&gpj4 2 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&micbias_reg_ena>;
+	};
+
+	sound {
+		compatible = "samsung,aries-wm8994";
+
+		model = "Aries";
+
+		extcon = <&fsa9480>;
+
+		main-micbias-supply = <&micbias_reg>;
+		headset-micbias-supply = <&micbias_reg>;
+
+		earpath-sel-gpios = <&gpj2 6 GPIO_ACTIVE_HIGH>;
+
+		io-channels = <&adc 3>;
+		io-channel-names = "headset-detect";
+		headset-detect-gpios = <&gph0 6 GPIO_ACTIVE_LOW>;
+		headset-key-gpios = <&gph3 6 GPIO_ACTIVE_HIGH>;
+
+		samsung,audio-routing =
+			"HP", "HPOUT1L",
+			"HP", "HPOUT1R",
+
+			"SPK", "SPKOUTLN",
+			"SPK", "SPKOUTLP",
+
+			"RCV", "HPOUT2N",
+			"RCV", "HPOUT2P",
+
+			"LINE", "LINEOUT2N",
+			"LINE", "LINEOUT2P",
+
+			"IN1LP", "Main Mic",
+			"IN1LN", "Main Mic",
+
+			"IN1RP", "Headset Mic",
+			"IN1RN", "Headset Mic",
+
+			"IN2LN", "FM In",
+			"IN2RN", "FM In",
+
+			"Modem Out", "Modem TX",
+			"Modem RX", "Modem In",
+
+			"Bluetooth SPK", "TX",
+			"RX", "Bluetooth Mic";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&headset_det &earpath_sel>;
+
+		cpu {
+			sound-dai = <&i2s0>, <&bt_codec>;
+		};
+
+		codec {
+			sound-dai = <&wm8994>;
+		};
+	};
 };
 
 &aliases {
@@ -88,6 +155,12 @@ fm_i2c_pins: fm-i2c-pins {
 		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
 	};
 
+	headset_det: headset-det {
+		samsung,pins = "gph0-6", "gph3-6";
+		samsung,pin-function = <EXYNOS_PIN_FUNC_F>;
+		samsung,pin-pud = <S3C64XX_PIN_PULL_NONE>;
+	};
+
 	fm_irq: fm-irq {
 		samsung,pins = "gpj2-4";
 		samsung,pin-function = <EXYNOS_PIN_FUNC_INPUT>;
@@ -102,6 +175,12 @@ fm_rst: fm-rst {
 		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
 	};
 
+	earpath_sel: earpath-sel {
+		samsung,pins = "gpj2-6";
+		samsung,pin-pud = <S3C64XX_PIN_PULL_NONE>;
+		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
+	};
+
 	massmemory_en: massmemory-en {
 		samsung,pins = "gpj2-7";
 		samsung,pin-function = <EXYNOS_PIN_FUNC_OUTPUT>;
@@ -109,6 +188,12 @@ massmemory_en: massmemory-en {
 		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
 	};
 
+	micbias_reg_ena: micbias-reg-ena {
+		samsung,pins = "gpj4-2";
+		samsung,pin-pud = <S3C64XX_PIN_PULL_NONE>;
+		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
+	};
+
 	/* Based on CyanogenMod 3.0.101 kernel */
 	sleep_cfg: sleep-cfg {
 		PIN_SLP(gpa0-0, PREV, NONE);
-- 
2.25.1

