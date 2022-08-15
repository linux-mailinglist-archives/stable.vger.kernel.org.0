Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6025593E76
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345342AbiHOUnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347112AbiHOUmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:42:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0898BB1BAB;
        Mon, 15 Aug 2022 12:07:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2967B8107A;
        Mon, 15 Aug 2022 19:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B87C433D6;
        Mon, 15 Aug 2022 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590459;
        bh=2WUnxokAmj9BtEtPVK6uCCp8plAA180/96F5ztbrp40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixthag+vcI57zcsu0zoBbt/F400+dirFFqg0vxTiCQkV0QembcTeDAX0aJUEpZCnm
         OqSwIgZQaamppMK2g6uI14rENY19tU92h7/BifTtg70OZQXiEJYvcvD/2s+QYXc+CP
         kD9mRURCR2C7ceseoi5DANfx0iyDBCe8kF4vlT/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0236/1095] ARM: dts: qcom-msm8974-{"hon","am"}ami: Commonize and modernize the DTs
Date:   Mon, 15 Aug 2022 19:53:55 +0200
Message-Id: <20220815180439.537472543@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 5c554c2d67a8c6c43a1fb542cbc73c33ff04c344 ]

Sony Xperia Z1 and Z1 compact are almost identical, and that shows in
their DTs. Commonize the repeating parts and modernize the DTs to use
labels.

As a bonus, Z1C gains touchscreen support in this commit, as it was
present on Z1 already.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
[bjorn: Rebased on top of Krzysztof's fixes]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-13-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/qcom-msm8974-sony-xperia-amami.dts    | 432 +---------------
 .../dts/qcom-msm8974-sony-xperia-honami.dts   | 479 +-----------------
 .../dts/qcom-msm8974-sony-xperia-rhine.dtsi   | 449 ++++++++++++++++
 arch/arm/boot/dts/qcom-pm8941.dtsi            |   2 +-
 4 files changed, 456 insertions(+), 906 deletions(-)
 create mode 100644 arch/arm/boot/dts/qcom-msm8974-sony-xperia-rhine.dtsi

diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts
index 6545917dd489..68d5626bf491 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts
@@ -1,435 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
-#include "qcom-msm8974.dtsi"
-#include "qcom-pm8841.dtsi"
-#include "qcom-pm8941.dtsi"
-#include <dt-bindings/gpio/gpio.h>
-#include <dt-bindings/input/input.h>
-#include <dt-bindings/pinctrl/qcom,pmic-gpio.h>
+#include "qcom-msm8974-sony-xperia-rhine.dtsi"
 
 / {
 	model = "Sony Xperia Z1 Compact";
 	compatible = "sony,xperia-amami", "qcom,msm8974";
-
-	aliases {
-		serial0 = &blsp1_uart2;
-	};
-
-	chosen {
-		stdout-path = "serial0:115200n8";
-	};
-
-	gpio-keys {
-		compatible = "gpio-keys";
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&gpio_keys_pin_a>;
-
-		volume-down {
-			label = "volume_down";
-			gpios = <&pm8941_gpios 2 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
-			linux,code = <KEY_VOLUMEDOWN>;
-		};
-
-		camera-snapshot {
-			label = "camera_snapshot";
-			gpios = <&pm8941_gpios 3 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
-			linux,code = <KEY_CAMERA>;
-		};
-
-		camera-focus {
-			label = "camera_focus";
-			gpios = <&pm8941_gpios 4 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
-			linux,code = <KEY_CAMERA_FOCUS>;
-		};
-
-		volume-up {
-			label = "volume_up";
-			gpios = <&pm8941_gpios 5 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
-			linux,code = <KEY_VOLUMEUP>;
-		};
-	};
-
-	memory@0 {
-		reg = <0 0x40000000>, <0x40000000 0x40000000>;
-		device_type = "memory";
-	};
-
-	smd {
-		rpm {
-			rpm-requests {
-				pm8841-regulators {
-					s1 {
-						regulator-min-microvolt = <675000>;
-						regulator-max-microvolt = <1050000>;
-					};
-
-					s2 {
-						regulator-min-microvolt = <500000>;
-						regulator-max-microvolt = <1050000>;
-					};
-
-					s3 {
-						regulator-min-microvolt = <500000>;
-						regulator-max-microvolt = <1050000>;
-					};
-
-					s4 {
-						regulator-min-microvolt = <500000>;
-						regulator-max-microvolt = <1050000>;
-					};
-				};
-
-				pm8941-regulators {
-					vdd_l1_l3-supply = <&pm8941_s1>;
-					vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
-					vdd_l4_l11-supply = <&pm8941_s1>;
-					vdd_l5_l7-supply = <&pm8941_s2>;
-					vdd_l6_l12_l14_l15-supply = <&pm8941_s2>;
-					vdd_l9_l10_l17_l22-supply = <&vreg_boost>;
-					vdd_l13_l20_l23_l24-supply = <&vreg_boost>;
-					vdd_l21-supply = <&vreg_boost>;
-
-					s1 {
-						regulator-min-microvolt = <1300000>;
-						regulator-max-microvolt = <1300000>;
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					s2 {
-						regulator-min-microvolt = <2150000>;
-						regulator-max-microvolt = <2150000>;
-						regulator-boot-on;
-					};
-
-					s3 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					s4 {
-						regulator-min-microvolt = <5000000>;
-						regulator-max-microvolt = <5000000>;
-					};
-
-					l1 {
-						regulator-min-microvolt = <1225000>;
-						regulator-max-microvolt = <1225000>;
-
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					l2 {
-						regulator-min-microvolt = <1200000>;
-						regulator-max-microvolt = <1200000>;
-					};
-
-					l3 {
-						regulator-min-microvolt = <1200000>;
-						regulator-max-microvolt = <1200000>;
-					};
-
-					l4 {
-						regulator-min-microvolt = <1225000>;
-						regulator-max-microvolt = <1225000>;
-					};
-
-					l5 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					l6 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-
-						regulator-boot-on;
-					};
-
-					l7 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-
-						regulator-boot-on;
-					};
-
-					l8 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					l9 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <2950000>;
-					};
-
-					l11 {
-						regulator-min-microvolt = <1300000>;
-						regulator-max-microvolt = <1350000>;
-					};
-
-					l12 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					l13 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-boot-on;
-					};
-
-					l14 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					l15 {
-						regulator-min-microvolt = <2050000>;
-						regulator-max-microvolt = <2050000>;
-					};
-
-					l16 {
-						regulator-min-microvolt = <2700000>;
-						regulator-max-microvolt = <2700000>;
-					};
-
-					l17 {
-						regulator-min-microvolt = <2700000>;
-						regulator-max-microvolt = <2700000>;
-					};
-
-					l18 {
-						regulator-min-microvolt = <2850000>;
-						regulator-max-microvolt = <2850000>;
-					};
-
-					l19 {
-						regulator-min-microvolt = <3300000>;
-						regulator-max-microvolt = <3300000>;
-					};
-
-					l20 {
-						regulator-min-microvolt = <2950000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-allow-set-load;
-						regulator-boot-on;
-						regulator-system-load = <200000>;
-					};
-
-					l21 {
-						regulator-min-microvolt = <2950000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-boot-on;
-					};
-
-					l22 {
-						regulator-min-microvolt = <3000000>;
-						regulator-max-microvolt = <3000000>;
-					};
-
-					l23 {
-						regulator-min-microvolt = <2800000>;
-						regulator-max-microvolt = <2800000>;
-					};
-
-					l24 {
-						regulator-min-microvolt = <3075000>;
-						regulator-max-microvolt = <3075000>;
-
-						regulator-boot-on;
-					};
-				};
-			};
-		};
-	};
 };
 
-&soc {
-	sdhci@f9824900 {
-		status = "okay";
-
-		vmmc-supply = <&pm8941_l20>;
-		vqmmc-supply = <&pm8941_s3>;
-
-		bus-width = <8>;
-		non-removable;
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc1_pin_a>;
-	};
-
-	sdhci@f98a4900 {
-		status = "okay";
-
-		bus-width = <4>;
-
-		vmmc-supply = <&pm8941_l21>;
-		vqmmc-supply = <&pm8941_l13>;
-
-		cd-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>;
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc2_pin_a>, <&sdhc2_cd_pin_a>;
-	};
-
-	serial@f991e000 {
-		status = "okay";
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&blsp1_uart2_pin_a>;
-	};
-
-
-	pinctrl@fd510000 {
-		blsp1_uart2_pin_a: blsp1-uart2-pin-active {
-			rx {
-				pins = "gpio5";
-				function = "blsp_uart2";
-
-				drive-strength = <2>;
-				bias-pull-up;
-			};
-
-			tx {
-				pins = "gpio4";
-				function = "blsp_uart2";
-
-				drive-strength = <4>;
-				bias-disable;
-			};
-		};
-
-		i2c2_pins: i2c2 {
-			mux {
-				pins = "gpio6", "gpio7";
-				function = "blsp_i2c2";
-
-				drive-strength = <2>;
-				bias-disable;
-			};
-		};
-
-		sdhc1_pin_a: sdhc1-pin-active {
-			clk {
-				pins = "sdc1_clk";
-				drive-strength = <16>;
-				bias-disable;
-			};
-
-			cmd-data {
-				pins = "sdc1_cmd", "sdc1_data";
-				drive-strength = <10>;
-				bias-pull-up;
-			};
-		};
-
-		sdhc2_cd_pin_a: sdhc2-cd-pin-active {
-			pins = "gpio62";
-			function = "gpio";
-
-			drive-strength = <2>;
-			bias-disable;
-		 };
-
-		sdhc2_pin_a: sdhc2-pin-active {
-			clk {
-				pins = "sdc2_clk";
-				drive-strength = <10>;
-				bias-disable;
-			};
-
-			cmd-data {
-				pins = "sdc2_cmd", "sdc2_data";
-				drive-strength = <6>;
-				bias-pull-up;
-			};
-		};
-	};
-
-	dma-controller@f9944000 {
-		qcom,controlled-remotely;
-	};
-
-	usb@f9a55000 {
-		status = "okay";
-
-		phys = <&usb_hs1_phy>;
-		phy-select = <&tcsr 0xb000 0>;
-		extcon = <&smbb>, <&usb_id>;
-		vbus-supply = <&chg_otg>;
-
-		hnp-disable;
-		srp-disable;
-		adp-disable;
-
-		ulpi {
-			phy@a {
-				status = "okay";
-
-				v1p8-supply = <&pm8941_l6>;
-				v3p3-supply = <&pm8941_l24>;
-
-				extcon = <&smbb>;
-				qcom,init-seq = /bits/ 8 <0x1 0x64>;
-			};
-		};
-	};
-};
-
-&spmi_bus {
-	pm8941@0 {
-		charger@1000 {
-			qcom,fast-charge-safe-current = <1300000>;
-			qcom,fast-charge-current-limit = <1300000>;
-			qcom,dc-current-limit = <1300000>;
-			qcom,fast-charge-safe-voltage = <4400000>;
-			qcom,fast-charge-high-threshold-voltage = <4350000>;
-			qcom,fast-charge-low-threshold-voltage = <3400000>;
-			qcom,auto-recharge-threshold-voltage = <4200000>;
-			qcom,minimum-input-voltage = <4300000>;
-		};
-
-		gpios@c000 {
-			gpio_keys_pin_a: gpio-keys-active {
-				pins = "gpio2", "gpio3", "gpio4", "gpio5";
-				function = "normal";
-
-				bias-pull-up;
-				power-source = <PM8941_GPIO_S3>;
-			};
-		};
-
-		coincell@2800 {
-			status = "okay";
-			qcom,rset-ohms = <2100>;
-			qcom,vset-millivolts = <3000>;
-		};
-	};
-
-	pm8941@1 {
-		wled@d800 {
-			status = "okay";
-
-			qcom,cs-out;
-			qcom,current-limit = <20>;
-			qcom,current-boost-limit = <805>;
-			qcom,switching-freq = <1600>;
-			qcom,ovp = <29>;
-			qcom,num-strings = <2>;
-		};
-	};
+&smbb {
+	qcom,fast-charge-safe-current = <1300000>;
+	qcom,fast-charge-current-limit = <1300000>;
+	qcom,dc-current-limit = <1300000>;
 };
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
index 313c755f590f..ea6a941d8f8c 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
@@ -1,484 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
-#include "qcom-msm8974.dtsi"
-#include "qcom-pm8841.dtsi"
-#include "qcom-pm8941.dtsi"
-#include <dt-bindings/gpio/gpio.h>
-#include <dt-bindings/input/input.h>
-#include <dt-bindings/pinctrl/qcom,pmic-gpio.h>
+#include "qcom-msm8974-sony-xperia-rhine.dtsi"
 
 / {
 	model = "Sony Xperia Z1";
 	compatible = "sony,xperia-honami", "qcom,msm8974";
-
-	aliases {
-		serial0 = &blsp1_uart2;
-	};
-
-	chosen {
-		stdout-path = "serial0:115200n8";
-	};
-
-	gpio-keys {
-		compatible = "gpio-keys";
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&gpio_keys_pin_a>;
-
-		volume-down {
-			label = "volume_down";
-			gpios = <&pm8941_gpios 2 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
-			linux,code = <KEY_VOLUMEDOWN>;
-		};
-
-		camera-snapshot {
-			label = "camera_snapshot";
-			gpios = <&pm8941_gpios 3 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
-			linux,code = <KEY_CAMERA>;
-		};
-
-		camera-focus {
-			label = "camera_focus";
-			gpios = <&pm8941_gpios 4 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
-			linux,code = <KEY_CAMERA_FOCUS>;
-		};
-
-		volume-up {
-			label = "volume_up";
-			gpios = <&pm8941_gpios 5 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
-			linux,code = <KEY_VOLUMEUP>;
-		};
-	};
-
-	memory@0 {
-		reg = <0 0x40000000>, <0x40000000 0x40000000>;
-		device_type = "memory";
-	};
-
-	smd {
-		rpm {
-			rpm-requests {
-				pm8841-regulators {
-					s1 {
-						regulator-min-microvolt = <675000>;
-						regulator-max-microvolt = <1050000>;
-					};
-
-					s2 {
-						regulator-min-microvolt = <500000>;
-						regulator-max-microvolt = <1050000>;
-					};
-
-					s3 {
-						regulator-min-microvolt = <500000>;
-						regulator-max-microvolt = <1050000>;
-					};
-
-					s4 {
-						regulator-min-microvolt = <500000>;
-						regulator-max-microvolt = <1050000>;
-					};
-				};
-
-				pm8941-regulators {
-					vdd_l1_l3-supply = <&pm8941_s1>;
-					vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
-					vdd_l4_l11-supply = <&pm8941_s1>;
-					vdd_l5_l7-supply = <&pm8941_s2>;
-					vdd_l6_l12_l14_l15-supply = <&pm8941_s2>;
-					vdd_l9_l10_l17_l22-supply = <&vreg_boost>;
-					vdd_l13_l20_l23_l24-supply = <&vreg_boost>;
-					vdd_l21-supply = <&vreg_boost>;
-
-					s1 {
-						regulator-min-microvolt = <1300000>;
-						regulator-max-microvolt = <1300000>;
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					s2 {
-						regulator-min-microvolt = <2150000>;
-						regulator-max-microvolt = <2150000>;
-						regulator-boot-on;
-					};
-
-					s3 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					s4 {
-						regulator-min-microvolt = <5000000>;
-						regulator-max-microvolt = <5000000>;
-					};
-
-					l1 {
-						regulator-min-microvolt = <1225000>;
-						regulator-max-microvolt = <1225000>;
-
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					l2 {
-						regulator-min-microvolt = <1200000>;
-						regulator-max-microvolt = <1200000>;
-					};
-
-					l3 {
-						regulator-min-microvolt = <1200000>;
-						regulator-max-microvolt = <1200000>;
-					};
-
-					l4 {
-						regulator-min-microvolt = <1225000>;
-						regulator-max-microvolt = <1225000>;
-					};
-
-					l5 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					l6 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-
-						regulator-boot-on;
-					};
-
-					l7 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-
-						regulator-boot-on;
-					};
-
-					l8 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					l9 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <2950000>;
-					};
-
-					l11 {
-						regulator-min-microvolt = <1300000>;
-						regulator-max-microvolt = <1350000>;
-					};
-
-					l12 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					l13 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-boot-on;
-					};
-
-					l14 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					l15 {
-						regulator-min-microvolt = <2050000>;
-						regulator-max-microvolt = <2050000>;
-					};
-
-					l16 {
-						regulator-min-microvolt = <2700000>;
-						regulator-max-microvolt = <2700000>;
-					};
-
-					l17 {
-						regulator-min-microvolt = <2700000>;
-						regulator-max-microvolt = <2700000>;
-					};
-
-					l18 {
-						regulator-min-microvolt = <2850000>;
-						regulator-max-microvolt = <2850000>;
-					};
-
-					l19 {
-						regulator-min-microvolt = <3300000>;
-						regulator-max-microvolt = <3300000>;
-					};
-
-					l20 {
-						regulator-min-microvolt = <2950000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-allow-set-load;
-						regulator-boot-on;
-						regulator-system-load = <200000>;
-					};
-
-					l21 {
-						regulator-min-microvolt = <2950000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-boot-on;
-					};
-
-					l22 {
-						regulator-min-microvolt = <3000000>;
-						regulator-max-microvolt = <3000000>;
-					};
-
-					l23 {
-						regulator-min-microvolt = <2800000>;
-						regulator-max-microvolt = <2800000>;
-					};
-
-					l24 {
-						regulator-min-microvolt = <3075000>;
-						regulator-max-microvolt = <3075000>;
-
-						regulator-boot-on;
-					};
-				};
-			};
-		};
-	};
-};
-
-&soc {
-	usb@f9a55000 {
-		status = "okay";
-
-		phys = <&usb_hs1_phy>;
-		phy-select = <&tcsr 0xb000 0>;
-		extcon = <&smbb>, <&usb_id>;
-		vbus-supply = <&chg_otg>;
-
-		hnp-disable;
-		srp-disable;
-		adp-disable;
-
-		ulpi {
-			phy@a {
-				status = "okay";
-
-				v1p8-supply = <&pm8941_l6>;
-				v3p3-supply = <&pm8941_l24>;
-
-				extcon = <&smbb>;
-				qcom,init-seq = /bits/ 8 <0x1 0x64>;
-			};
-		};
-	};
-
-	sdhci@f9824900 {
-		status = "okay";
-
-		vmmc-supply = <&pm8941_l20>;
-		vqmmc-supply = <&pm8941_s3>;
-
-		bus-width = <8>;
-		non-removable;
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc1_pin_a>;
-	};
-
-	sdhci@f98a4900 {
-		status = "okay";
-
-		bus-width = <4>;
-
-		vmmc-supply = <&pm8941_l21>;
-		vqmmc-supply = <&pm8941_l13>;
-
-		cd-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>;
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc2_pin_a>, <&sdhc2_cd_pin_a>;
-	};
-
-	serial@f991e000 {
-		status = "okay";
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&blsp1_uart2_pin_a>;
-	};
-
-	i2c@f9924000 {
-		status = "okay";
-
-		clock-frequency = <355000>;
-		qcom,src-freq = <50000000>;
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&i2c2_pins>;
-
-		synaptics@2c {
-			compatible = "syna,rmi4-i2c";
-			reg = <0x2c>;
-
-			interrupts-extended = <&tlmm 61 IRQ_TYPE_EDGE_FALLING>;
-
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			vdd-supply = <&pm8941_l22>;
-			vio-supply = <&pm8941_lvs3>;
-
-			pinctrl-names = "default";
-			pinctrl-0 = <&ts_int_pin>;
-
-			syna,startup-delay-ms = <10>;
-
-			rmi4-f01@1 {
-				reg = <0x1>;
-				syna,nosleep-mode = <1>;
-			};
-
-			rmi4-f11@11 {
-				reg = <0x11>;
-				touchscreen-inverted-x;
-				syna,sensor-type = <1>;
-			};
-		};
-	};
-
-	pinctrl@fd510000 {
-		blsp1_uart2_pin_a: blsp1-uart2-pin-active {
-			rx {
-				pins = "gpio5";
-				function = "blsp_uart2";
-
-				drive-strength = <2>;
-				bias-pull-up;
-			};
-
-			tx {
-				pins = "gpio4";
-				function = "blsp_uart2";
-
-				drive-strength = <4>;
-				bias-disable;
-			};
-		};
-
-		i2c2_pins: i2c2 {
-			mux {
-				pins = "gpio6", "gpio7";
-				function = "blsp_i2c2";
-
-				drive-strength = <2>;
-				bias-disable;
-			};
-		};
-
-		sdhc1_pin_a: sdhc1-pin-active {
-			clk {
-				pins = "sdc1_clk";
-				drive-strength = <16>;
-				bias-disable;
-			};
-
-			cmd-data {
-				pins = "sdc1_cmd", "sdc1_data";
-				drive-strength = <10>;
-				bias-pull-up;
-			};
-		};
-
-		sdhc2_cd_pin_a: sdhc2-cd-pin-active {
-			pins = "gpio62";
-			function = "gpio";
-
-			drive-strength = <2>;
-			bias-disable;
-		 };
-
-		sdhc2_pin_a: sdhc2-pin-active {
-			clk {
-				pins = "sdc2_clk";
-				drive-strength = <10>;
-				bias-disable;
-			};
-
-			cmd-data {
-				pins = "sdc2_cmd", "sdc2_data";
-				drive-strength = <6>;
-				bias-pull-up;
-			};
-		};
-
-		ts_int_pin: touch-int {
-			pin {
-				pins = "gpio61";
-				function = "gpio";
-
-				drive-strength = <2>;
-				bias-disable;
-				input-enable;
-			};
-		};
-	};
-
-	dma-controller@f9944000 {
-		qcom,controlled-remotely;
-	};
-};
-
-&spmi_bus {
-	pm8941@0 {
-		charger@1000 {
-			qcom,fast-charge-safe-current = <1500000>;
-			qcom,fast-charge-current-limit = <1500000>;
-			qcom,dc-current-limit = <1800000>;
-			qcom,fast-charge-safe-voltage = <4400000>;
-			qcom,fast-charge-high-threshold-voltage = <4350000>;
-			qcom,fast-charge-low-threshold-voltage = <3400000>;
-			qcom,auto-recharge-threshold-voltage = <4200000>;
-			qcom,minimum-input-voltage = <4300000>;
-		};
-
-		gpios@c000 {
-			gpio_keys_pin_a: gpio-keys-active {
-				pins = "gpio2", "gpio3", "gpio4", "gpio5";
-				function = "normal";
-
-				bias-pull-up;
-				power-source = <PM8941_GPIO_S3>;
-			};
-		};
-
-		coincell@2800 {
-			status = "okay";
-			qcom,rset-ohms = <2100>;
-			qcom,vset-millivolts = <3000>;
-		};
-	};
-
-	pm8941@1 {
-		wled@d800 {
-			status = "okay";
-
-			qcom,cs-out;
-			qcom,current-limit = <20>;
-			qcom,current-boost-limit = <805>;
-			qcom,switching-freq = <1600>;
-			qcom,ovp = <29>;
-			qcom,num-strings = <2>;
-		};
-	};
 };
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-rhine.dtsi b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-rhine.dtsi
new file mode 100644
index 000000000000..87ec3694add9
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-rhine.dtsi
@@ -0,0 +1,449 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "qcom-msm8974.dtsi"
+#include "qcom-pm8841.dtsi"
+#include "qcom-pm8941.dtsi"
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/input/input.h>
+#include <dt-bindings/pinctrl/qcom,pmic-gpio.h>
+
+/ {
+	aliases {
+		serial0 = &blsp1_uart2;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&gpio_keys_pin_a>;
+
+		volume-down {
+			label = "volume_down";
+			gpios = <&pm8941_gpios 2 GPIO_ACTIVE_LOW>;
+			linux,input-type = <1>;
+			linux,code = <KEY_VOLUMEDOWN>;
+		};
+
+		camera-snapshot {
+			label = "camera_snapshot";
+			gpios = <&pm8941_gpios 3 GPIO_ACTIVE_LOW>;
+			linux,input-type = <1>;
+			linux,code = <KEY_CAMERA>;
+		};
+
+		camera-focus {
+			label = "camera_focus";
+			gpios = <&pm8941_gpios 4 GPIO_ACTIVE_LOW>;
+			linux,input-type = <1>;
+			linux,code = <KEY_CAMERA_FOCUS>;
+		};
+
+		volume-up {
+			label = "volume_up";
+			gpios = <&pm8941_gpios 5 GPIO_ACTIVE_LOW>;
+			linux,input-type = <1>;
+			linux,code = <KEY_VOLUMEUP>;
+		};
+	};
+};
+
+&blsp1_i2c2 {
+	status = "okay";
+	clock-frequency = <355000>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c2_pins>;
+
+	synaptics@2c {
+		compatible = "syna,rmi4-i2c";
+		reg = <0x2c>;
+
+		interrupts-extended = <&tlmm 61 IRQ_TYPE_EDGE_FALLING>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vdd-supply = <&pm8941_l22>;
+		vio-supply = <&pm8941_lvs3>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&ts_int_pin>;
+
+		syna,startup-delay-ms = <10>;
+
+		rmi4-f01@1 {
+			reg = <0x1>;
+			syna,nosleep-mode = <1>;
+		};
+
+		rmi4-f11@11 {
+			reg = <0x11>;
+			touchscreen-inverted-x;
+			syna,sensor-type = <1>;
+		};
+	};
+};
+
+&blsp1_uart2 {
+	status = "okay";
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&blsp1_uart2_pin_a>;
+};
+
+&blsp2_dma {
+	qcom,controlled-remotely;
+};
+
+&otg {
+	status = "okay";
+
+	phys = <&usb_hs1_phy>;
+	phy-select = <&tcsr 0xb000 0>;
+	extcon = <&smbb>, <&usb_id>;
+	vbus-supply = <&chg_otg>;
+
+	hnp-disable;
+	srp-disable;
+	adp-disable;
+
+	ulpi {
+		phy@a {
+			status = "okay";
+
+			v1p8-supply = <&pm8941_l6>;
+			v3p3-supply = <&pm8941_l24>;
+
+			extcon = <&smbb>;
+			qcom,init-seq = /bits/ 8 <0x1 0x64>;
+		};
+	};
+};
+
+&pm8941_coincell {
+	status = "okay";
+	qcom,rset-ohms = <2100>;
+	qcom,vset-millivolts = <3000>;
+};
+
+&pm8941_gpios {
+	gpio_keys_pin_a: gpio-keys-active {
+		pins = "gpio2", "gpio3", "gpio4", "gpio5";
+		function = "normal";
+
+		bias-pull-up;
+		power-source = <PM8941_GPIO_S3>;
+	};
+};
+
+&pm8941_wled {
+	status = "okay";
+
+	qcom,cs-out;
+	qcom,current-limit = <20>;
+	qcom,current-boost-limit = <805>;
+	qcom,switching-freq = <1600>;
+	qcom,ovp = <29>;
+	qcom,num-strings = <2>;
+};
+
+&rpm_requests {
+	pm8841-regulators {
+		pm8841_s1: s1 {
+			regulator-min-microvolt = <675000>;
+			regulator-max-microvolt = <1050000>;
+		};
+
+		pm8841_s2: s2 {
+			regulator-min-microvolt = <500000>;
+			regulator-max-microvolt = <1050000>;
+		};
+
+		pm8841_s3: s3 {
+			regulator-min-microvolt = <500000>;
+			regulator-max-microvolt = <1050000>;
+		};
+
+		pm8841_s4: s4 {
+			regulator-min-microvolt = <500000>;
+			regulator-max-microvolt = <1050000>;
+		};
+	};
+
+	pm8941-regulators {
+		vdd_l1_l3-supply = <&pm8941_s1>;
+		vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
+		vdd_l4_l11-supply = <&pm8941_s1>;
+		vdd_l5_l7-supply = <&pm8941_s2>;
+		vdd_l6_l12_l14_l15-supply = <&pm8941_s2>;
+		vdd_l9_l10_l17_l22-supply = <&vreg_boost>;
+		vdd_l13_l20_l23_l24-supply = <&vreg_boost>;
+		vdd_l21-supply = <&vreg_boost>;
+
+		pm8941_s1: s1 {
+			regulator-min-microvolt = <1300000>;
+			regulator-max-microvolt = <1300000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
+
+		pm8941_s2: s2 {
+			regulator-min-microvolt = <2150000>;
+			regulator-max-microvolt = <2150000>;
+			regulator-boot-on;
+		};
+
+		pm8941_s3: s3 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
+
+		pm8941_s4: s4 {
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+		};
+
+		pm8941_l1: l1 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
+
+		pm8941_l2: l2 {
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1200000>;
+		};
+
+		pm8941_l3: l3 {
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1200000>;
+		};
+
+		pm8941_l4: l4 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+		};
+
+		pm8941_l5: l5 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		pm8941_l6: l6 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-boot-on;
+		};
+
+		pm8941_l7: l7 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-boot-on;
+		};
+
+		pm8941_l8: l8 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		pm8941_l9: l9 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2950000>;
+		};
+
+		pm8941_l11: l11 {
+			regulator-min-microvolt = <1300000>;
+			regulator-max-microvolt = <1350000>;
+		};
+
+		pm8941_l12: l12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
+
+		pm8941_l13: l13 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2950000>;
+			regulator-boot-on;
+		};
+
+		pm8941_l14: l14 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		pm8941_l15: l15 {
+			regulator-min-microvolt = <2050000>;
+			regulator-max-microvolt = <2050000>;
+		};
+
+		pm8941_l16: l16 {
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <2700000>;
+		};
+
+		pm8941_l17: l17 {
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <2700000>;
+		};
+
+		pm8941_l18: l18 {
+			regulator-min-microvolt = <2850000>;
+			regulator-max-microvolt = <2850000>;
+		};
+
+		pm8941_l19: l19 {
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+		};
+
+		pm8941_l20: l20 {
+			regulator-min-microvolt = <2950000>;
+			regulator-max-microvolt = <2950000>;
+			regulator-system-load = <200000>;
+			regulator-allow-set-load;
+			regulator-boot-on;
+		};
+
+		pm8941_l21: l21 {
+			regulator-min-microvolt = <2950000>;
+			regulator-max-microvolt = <2950000>;
+			regulator-boot-on;
+		};
+
+		pm8941_l22: l22 {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <3000000>;
+		};
+
+		pm8941_l23: l23 {
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+		};
+
+		pm8941_l24: l24 {
+			regulator-min-microvolt = <3075000>;
+			regulator-max-microvolt = <3075000>;
+			regulator-boot-on;
+		};
+	};
+};
+
+&sdhc_1 {
+	status = "okay";
+
+	vmmc-supply = <&pm8941_l20>;
+	vqmmc-supply = <&pm8941_s3>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhc1_pin_a>;
+};
+
+&sdhc_2 {
+	status = "okay";
+
+	vmmc-supply = <&pm8941_l21>;
+	vqmmc-supply = <&pm8941_l13>;
+
+	cd-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhc2_pin_a>, <&sdhc2_cd_pin_a>;
+};
+
+&smbb {
+	qcom,fast-charge-safe-current = <1500000>;
+	qcom,fast-charge-current-limit = <1500000>;
+	qcom,dc-current-limit = <1800000>;
+	qcom,fast-charge-safe-voltage = <4400000>;
+	qcom,fast-charge-high-threshold-voltage = <4350000>;
+	qcom,fast-charge-low-threshold-voltage = <3400000>;
+	qcom,auto-recharge-threshold-voltage = <4200000>;
+	qcom,minimum-input-voltage = <4300000>;
+};
+
+&tlmm {
+	ts_int_pin: touch-int {
+		pin {
+			pins = "gpio61";
+			function = "gpio";
+
+			drive-strength = <2>;
+			bias-disable;
+			input-enable;
+		};
+	};
+
+	blsp1_uart2_pin_a: blsp1-uart2-pin-active {
+		rx {
+			pins = "gpio5";
+			function = "blsp_uart2";
+
+			drive-strength = <2>;
+			bias-pull-up;
+		};
+
+		tx {
+			pins = "gpio4";
+			function = "blsp_uart2";
+
+			drive-strength = <4>;
+			bias-disable;
+		};
+	};
+
+	i2c2_pins: i2c2 {
+		mux {
+			pins = "gpio6", "gpio7";
+			function = "blsp_i2c2";
+
+			drive-strength = <2>;
+			bias-disable;
+		};
+	};
+
+	sdhc1_pin_a: sdhc1-pin-active {
+		clk {
+			pins = "sdc1_clk";
+			drive-strength = <16>;
+			bias-disable;
+		};
+
+		cmd-data {
+			pins = "sdc1_cmd", "sdc1_data";
+			drive-strength = <10>;
+			bias-pull-up;
+		};
+	};
+
+	sdhc2_cd_pin_a: sdhc2-cd-pin-active {
+		pins = "gpio62";
+		function = "gpio";
+
+		drive-strength = <2>;
+		bias-disable;
+		};
+
+	sdhc2_pin_a: sdhc2-pin-active {
+		clk {
+			pins = "sdc2_clk";
+			drive-strength = <10>;
+			bias-disable;
+		};
+
+		cmd-data {
+			pins = "sdc2_cmd", "sdc2_data";
+			drive-strength = <6>;
+			bias-pull-up;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/qcom-pm8941.dtsi b/arch/arm/boot/dts/qcom-pm8941.dtsi
index da00b8f5eecd..cdd2bdb77b32 100644
--- a/arch/arm/boot/dts/qcom-pm8941.dtsi
+++ b/arch/arm/boot/dts/qcom-pm8941.dtsi
@@ -131,7 +131,7 @@ pm8941_iadc: iadc@3600 {
 			qcom,external-resistor-micro-ohms = <10000>;
 		};
 
-		coincell@2800 {
+		pm8941_coincell: coincell@2800 {
 			compatible = "qcom,pm8941-coincell";
 			reg = <0x2800>;
 			status = "disabled";
-- 
2.35.1



