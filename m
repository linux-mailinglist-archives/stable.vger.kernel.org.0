Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E822A51CB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgKCUoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730117AbgKCUoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:44:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81099223FD;
        Tue,  3 Nov 2020 20:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436249;
        bh=mjH/cXvbSDT79mTBGV/PuEHHQiCPFYOAb1ia8t9eVnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZWHzT1Qooqck19skASz+pG2ZOVLwFf0Mwtv9Exn25CkOBTlmkHLDAeiuqOIWNaMW
         ej2gsQJ4WyzU3yHLeQ8Gsr6c1rJc77KAduiy9gIn11j3pJqeiBQG45GdTk3oJsB38E
         Nj8IUgQuQeMDcY8lpu9GSzKiiM3vC7ukNTIb/x9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 167/391] ARM: dts: s5pv210: Enable audio on Aries boards
Date:   Tue,  3 Nov 2020 21:33:38 +0100
Message-Id: <20201103203358.116303810@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -47,6 +47,11 @@
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
@@ -624,6 +629,11 @@
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
@@ -35,6 +35,80 @@
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
@@ -51,6 +125,12 @@
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
@@ -58,6 +138,24 @@
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
@@ -72,6 +72,73 @@
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
@@ -88,6 +155,12 @@
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
@@ -102,6 +175,12 @@
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
@@ -109,6 +188,12 @@
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
2.27.0



