Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134DD593E1F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344674AbiHOUhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346014AbiHOUei (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:34:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD2EAB4C9;
        Mon, 15 Aug 2022 12:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC4E9B8107A;
        Mon, 15 Aug 2022 19:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8A8C433D6;
        Mon, 15 Aug 2022 19:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590370;
        bh=wRmXQviFxT6g0FVIEJvYD6FwmG24ifCxQkYvt241vig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GiUGP86VqhaRy26EIO7PtWIgLnQ/Jpyj164KQ4rE5vFCSievM789H99XS18OhIMmF
         rd0ykuXc81wH4CvygzKwH/NoEKW7SghWxHWgDrzw5f/IgspgEaeisdzmDC9/GvNE9N
         5fdrludYwMOFVQdO1FdtteP0ye979faeMFrEV/Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0239/1095] ARM: dts: qcom-msm8974: Sort and clean up nodes
Date:   Mon, 15 Aug 2022 19:53:58 +0200
Message-Id: <20220815180439.671219266@linuxfoundation.org>
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

[ Upstream commit f300826d27be7f7f671c922bf57007c98c683590 ]

- Remove regulators from the SoC DTSI
- cpu_pmu{} -> pmu{}
- move modem/iris regulators out of here; only FP2 used them
- tcsr_mutex is moved out of /soc

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
[bjorn: Rebased on top of Krzysztof's fixes]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-18-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm/boot/dts/qcom-apq8074-dragonboard.dts |    4 +
 .../boot/dts/qcom-msm8974-fairphone-fp2.dts   |   12 +
 .../qcom-msm8974-lge-nexus5-hammerhead.dts    |    7 +
 .../dts/qcom-msm8974-sony-xperia-castor.dts   |    4 +
 .../dts/qcom-msm8974-sony-xperia-rhine.dtsi   |    6 +
 arch/arm/boot/dts/qcom-msm8974.dtsi           | 1414 ++++++++---------
 6 files changed, 709 insertions(+), 738 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
index f114debe4d95..f47020cf7a90 100644
--- a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
@@ -61,6 +61,8 @@ phy@b {
 
 &rpm_requests {
 	pm8841-regulators {
+		compatible = "qcom,rpm-pm8841-regulators";
+
 		pm8841_s1: s1 {
 			regulator-min-microvolt = <675000>;
 			regulator-max-microvolt = <1050000>;
@@ -83,6 +85,8 @@ pm8841_s4: s4 {
 	};
 
 	pm8941-regulators {
+		compatible = "qcom,rpm-pm8941-regulators";
+
 		vdd_l1_l3-supply = <&pm8941_s1>;
 		vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
 		vdd_l4_l11-supply = <&pm8941_s1>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
index 38e48ea021d9..d6799a1b820b 100644
--- a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
@@ -109,10 +109,18 @@ &pronto {
 
 	vddmx-supply = <&pm8841_s1>;
 	vddcx-supply = <&pm8841_s2>;
+	vddpx-supply = <&pm8941_s3>;
 
 	pinctrl-names = "default";
 	pinctrl-0 = <&wcnss_pin_a>;
 
+	iris {
+		vddxo-supply = <&pm8941_l6>;
+		vddrfa-supply = <&pm8941_l11>;
+		vddpa-supply = <&pm8941_l19>;
+		vdddig-supply = <&pm8941_s3>;
+	};
+
 	smd-edge {
 		qcom,remote-pid = <4>;
 		label = "pronto";
@@ -125,6 +133,8 @@ wcnss {
 
 &rpm_requests {
 	pm8841-regulators {
+		compatible = "qcom,rpm-pm8841-regulators";
+
 		pm8841_s1: s1 {
 			regulator-min-microvolt = <675000>;
 			regulator-max-microvolt = <1050000>;
@@ -142,6 +152,8 @@ pm8841_s3: s3 {
 	};
 
 	pm8941-regulators {
+		compatible = "qcom,rpm-pm8941-regulators";
+
 		vdd_l1_l3-supply = <&pm8941_s1>;
 		vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
 		vdd_l4_l11-supply = <&pm8941_s1>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts b/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
index a1cae3d453c2..6537950c30ba 100644
--- a/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
@@ -334,6 +334,8 @@ otg {
 
 &rpm_requests {
 	pm8841-regulators {
+		compatible = "qcom,rpm-pm8841-regulators";
+
 		pm8841_s1: s1 {
 			regulator-min-microvolt = <675000>;
 			regulator-max-microvolt = <1050000>;
@@ -356,6 +358,8 @@ pm8841_s4: s4 {
 	};
 
 	pm8941-regulators {
+		compatible = "qcom,rpm-pm8941-regulators";
+
 		vdd_l1_l3-supply = <&pm8941_s1>;
 		vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
 		vdd_l4_l11-supply = <&pm8941_s1>;
@@ -517,6 +521,9 @@ pm8941_l24: l24 {
 			regulator-max-microvolt = <3075000>;
 			regulator-boot-on;
 		};
+
+		pm8941_lvs1: lvs1 {};
+		pm8941_lvs3: lvs3 {};
 	};
 };
 
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
index 687f6149268c..b8b6447b3217 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
@@ -304,6 +304,8 @@ lcd_dcdc_en_pin_a: lcd-dcdc-en-active {
 
 &rpm_requests {
 	pm8941-regulators {
+		compatible = "qcom,rpm-pm8941-regulators";
+
 		vdd_l1_l3-supply = <&pm8941_s1>;
 		vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
 		vdd_l4_l11-supply = <&pm8941_s1>;
@@ -465,6 +467,8 @@ pm8941_l24: l24 {
 			regulator-max-microvolt = <3075000>;
 			regulator-boot-on;
 		};
+
+		pm8941_lvs3: lvs3 {};
 	};
 };
 
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-rhine.dtsi b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-rhine.dtsi
index 87ec3694add9..870e0aeb4d05 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-rhine.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-rhine.dtsi
@@ -153,6 +153,8 @@ &pm8941_wled {
 
 &rpm_requests {
 	pm8841-regulators {
+		compatible = "qcom,rpm-pm8841-regulators";
+
 		pm8841_s1: s1 {
 			regulator-min-microvolt = <675000>;
 			regulator-max-microvolt = <1050000>;
@@ -175,6 +177,8 @@ pm8841_s4: s4 {
 	};
 
 	pm8941-regulators {
+		compatible = "qcom,rpm-pm8941-regulators";
+
 		vdd_l1_l3-supply = <&pm8941_s1>;
 		vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
 		vdd_l4_l11-supply = <&pm8941_s1>;
@@ -335,6 +339,8 @@ pm8941_l24: l24 {
 			regulator-max-microvolt = <3075000>;
 			regulator-boot-on;
 		};
+
+		pm8941_lvs3: lvs3 {};
 	};
 };
 
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index e6c9782e4670..0091a4c29fff 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -16,57 +16,17 @@ / {
 	compatible = "qcom,msm8974";
 	interrupt-parent = <&intc>;
 
-	reserved-memory {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		mpss_region: mpss@8000000 {
-			reg = <0x08000000 0x5100000>;
-			no-map;
-		};
-
-		mba_region: mba@d100000 {
-			reg = <0x0d100000 0x100000>;
-			no-map;
-		};
-
-		wcnss_region: wcnss@d200000 {
-			reg = <0x0d200000 0xa00000>;
-			no-map;
-		};
-
-		adsp_region: adsp@dc00000 {
-			reg = <0x0dc00000 0x1900000>;
-			no-map;
-		};
-
-		venus@f500000 {
-			reg = <0x0f500000 0x500000>;
-			no-map;
-		};
-
-		smem_region: smem@fa00000 {
-			reg = <0xfa00000 0x200000>;
-			no-map;
-		};
-
-		tz@fc00000 {
-			reg = <0x0fc00000 0x160000>;
-			no-map;
-		};
-
-		rfsa@fd60000 {
-			reg = <0x0fd60000 0x20000>;
-			no-map;
+	clocks {
+		xo_board: xo_board {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <19200000>;
 		};
 
-		rmtfs@fd80000 {
-			compatible = "qcom,rmtfs-mem";
-			reg = <0x0fd80000 0x180000>;
-			no-map;
-
-			qcom,client-id = <1>;
+		sleep_clk: sleep_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <32768>;
 		};
 	};
 
@@ -136,211 +96,78 @@ CPU_SPC: spc {
 		};
 	};
 
+	firmware {
+		scm {
+			compatible = "qcom,scm";
+			clocks = <&gcc GCC_CE1_CLK>, <&gcc GCC_CE1_AXI_CLK>, <&gcc GCC_CE1_AHB_CLK>;
+			clock-names = "core", "bus", "iface";
+		};
+	};
+
 	memory {
 		device_type = "memory";
 		reg = <0x0 0x0>;
 	};
 
-	thermal-zones {
-		cpu0-thermal {
-			polling-delay-passive = <250>;
-			polling-delay = <1000>;
-
-			thermal-sensors = <&tsens 5>;
-
-			trips {
-				cpu_alert0: trip0 {
-					temperature = <75000>;
-					hysteresis = <2000>;
-					type = "passive";
-				};
-				cpu_crit0: trip1 {
-					temperature = <110000>;
-					hysteresis = <2000>;
-					type = "critical";
-				};
-			};
-		};
-
-		cpu1-thermal {
-			polling-delay-passive = <250>;
-			polling-delay = <1000>;
-
-			thermal-sensors = <&tsens 6>;
-
-			trips {
-				cpu_alert1: trip0 {
-					temperature = <75000>;
-					hysteresis = <2000>;
-					type = "passive";
-				};
-				cpu_crit1: trip1 {
-					temperature = <110000>;
-					hysteresis = <2000>;
-					type = "critical";
-				};
-			};
-		};
-
-		cpu2-thermal {
-			polling-delay-passive = <250>;
-			polling-delay = <1000>;
+	pmu {
+		compatible = "qcom,krait-pmu";
+		interrupts = <GIC_PPI 7 0xf04>;
+	};
 
-			thermal-sensors = <&tsens 7>;
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
 
-			trips {
-				cpu_alert2: trip0 {
-					temperature = <75000>;
-					hysteresis = <2000>;
-					type = "passive";
-				};
-				cpu_crit2: trip1 {
-					temperature = <110000>;
-					hysteresis = <2000>;
-					type = "critical";
-				};
-			};
+		mpss_region: mpss@8000000 {
+			reg = <0x08000000 0x5100000>;
+			no-map;
 		};
 
-		cpu3-thermal {
-			polling-delay-passive = <250>;
-			polling-delay = <1000>;
-
-			thermal-sensors = <&tsens 8>;
-
-			trips {
-				cpu_alert3: trip0 {
-					temperature = <75000>;
-					hysteresis = <2000>;
-					type = "passive";
-				};
-				cpu_crit3: trip1 {
-					temperature = <110000>;
-					hysteresis = <2000>;
-					type = "critical";
-				};
-			};
+		mba_region: mba@d100000 {
+			reg = <0x0d100000 0x100000>;
+			no-map;
 		};
 
-		q6-dsp-thermal {
-			polling-delay-passive = <250>;
-			polling-delay = <1000>;
-
-			thermal-sensors = <&tsens 1>;
-
-			trips {
-				q6_dsp_alert0: trip-point0 {
-					temperature = <90000>;
-					hysteresis = <2000>;
-					type = "hot";
-				};
-			};
+		wcnss_region: wcnss@d200000 {
+			reg = <0x0d200000 0xa00000>;
+			no-map;
 		};
 
-		modemtx-thermal {
-			polling-delay-passive = <250>;
-			polling-delay = <1000>;
-
-			thermal-sensors = <&tsens 2>;
-
-			trips {
-				modemtx_alert0: trip-point0 {
-					temperature = <90000>;
-					hysteresis = <2000>;
-					type = "hot";
-				};
-			};
+		adsp_region: adsp@dc00000 {
+			reg = <0x0dc00000 0x1900000>;
+			no-map;
 		};
 
-		video-thermal {
-			polling-delay-passive = <250>;
-			polling-delay = <1000>;
-
-			thermal-sensors = <&tsens 3>;
-
-			trips {
-				video_alert0: trip-point0 {
-					temperature = <95000>;
-					hysteresis = <2000>;
-					type = "hot";
-				};
-			};
+		venus_region: memory@f500000 {
+			reg = <0x0f500000 0x500000>;
+			no-map;
 		};
 
-		wlan-thermal {
-			polling-delay-passive = <250>;
-			polling-delay = <1000>;
-
-			thermal-sensors = <&tsens 4>;
-
-			trips {
-				wlan_alert0: trip-point0 {
-					temperature = <105000>;
-					hysteresis = <2000>;
-					type = "hot";
-				};
-			};
+		smem_region: smem@fa00000 {
+			reg = <0xfa00000 0x200000>;
+			no-map;
 		};
 
-		gpu-top-thermal {
-			polling-delay-passive = <250>;
-			polling-delay = <1000>;
-
-			thermal-sensors = <&tsens 9>;
-
-			trips {
-				gpu1_alert0: trip-point0 {
-					temperature = <90000>;
-					hysteresis = <2000>;
-					type = "hot";
-				};
-			};
+		tz_region: memory@fc00000 {
+			reg = <0x0fc00000 0x160000>;
+			no-map;
 		};
 
-		gpu-bottom-thermal {
-			polling-delay-passive = <250>;
-			polling-delay = <1000>;
-
-			thermal-sensors = <&tsens 10>;
-
-			trips {
-				gpu2_alert0: trip-point0 {
-					temperature = <90000>;
-					hysteresis = <2000>;
-					type = "hot";
-				};
-			};
+		rfsa_mem: memory@fd60000 {
+			reg = <0x0fd60000 0x20000>;
+			no-map;
 		};
-	};
-
-	cpu-pmu {
-		compatible = "qcom,krait-pmu";
-		interrupts = <GIC_PPI 7 0xf04>;
-	};
 
-	clocks {
-		xo_board: xo_board {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <19200000>;
-		};
+		rmtfs@fd80000 {
+			compatible = "qcom,rmtfs-mem";
+			reg = <0x0fd80000 0x180000>;
+			no-map;
 
-		sleep_clk: sleep_clk {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			qcom,client-id = <1>;
 		};
 	};
 
-	timer {
-		compatible = "arm,armv7-timer";
-		interrupts = <GIC_PPI 2 0xf08>,
-			     <GIC_PPI 3 0xf08>,
-			     <GIC_PPI 4 0xf08>,
-			     <GIC_PPI 1 0xf08>;
-		clock-frequency = <19200000>;
-	};
-
 	smem {
 		compatible = "qcom,smem";
 
@@ -467,11 +294,23 @@ wcnss_smsm: wcnss@7 {
 		};
 	};
 
-	firmware {
-		scm {
-			compatible = "qcom,scm";
-			clocks = <&gcc GCC_CE1_CLK>, <&gcc GCC_CE1_AXI_CLK>, <&gcc GCC_CE1_AHB_CLK>;
-			clock-names = "core", "bus", "iface";
+	smd {
+		compatible = "qcom,smd";
+
+		rpm {
+			interrupts = <GIC_SPI 168 IRQ_TYPE_EDGE_RISING>;
+			qcom,ipc = <&apcs 8 0>;
+			qcom,smd-edge = <15>;
+
+			rpm_requests: rpm_requests {
+				compatible = "qcom,rpm-msm8974";
+				qcom,smd-channels = "rpm_requests";
+
+				rpmcc: clock-controller {
+					compatible = "qcom,rpmcc-msm8974", "qcom,rpmcc";
+					#clock-cells = <1>;
+				};
+			};
 		};
 	};
 
@@ -494,31 +333,6 @@ apcs: syscon@f9011000 {
 			reg = <0xf9011000 0x1000>;
 		};
 
-		qfprom: qfprom@fc4bc000 {
-			#address-cells = <1>;
-			#size-cells = <1>;
-			compatible = "qcom,qfprom";
-			reg = <0xfc4bc000 0x1000>;
-			tsens_calib: calib@d0 {
-				reg = <0xd0 0x18>;
-			};
-			tsens_backup: backup@440 {
-				reg = <0x440 0x10>;
-			};
-		};
-
-		tsens: thermal-sensor@fc4a9000 {
-			compatible = "qcom,msm8974-tsens";
-			reg = <0xfc4a9000 0x1000>, /* TM */
-			      <0xfc4a8000 0x1000>; /* SROT */
-			nvmem-cells = <&tsens_calib>, <&tsens_backup>;
-			nvmem-cell-names = "calib", "calib_backup";
-			#qcom,sensors = <11>;
-			interrupts = <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "uplow";
-			#thermal-sensor-cells = <1>;
-		};
-
 		timer@f9020000 {
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -624,94 +438,6 @@ acc3: clock-controller@f90b8000 {
 			reg = <0xf90b8000 0x1000>, <0xf9008000 0x1000>;
 		};
 
-		restart@fc4ab000 {
-			compatible = "qcom,pshold";
-			reg = <0xfc4ab000 0x4>;
-		};
-
-		gcc: clock-controller@fc400000 {
-			compatible = "qcom,gcc-msm8974";
-			#clock-cells = <1>;
-			#reset-cells = <1>;
-			#power-domain-cells = <1>;
-			reg = <0xfc400000 0x4000>;
-		};
-
-		tcsr: syscon@fd4a0000 {
-			compatible = "syscon";
-			reg = <0xfd4a0000 0x10000>;
-		};
-
-		tcsr_mutex_block: syscon@fd484000 {
-			compatible = "syscon";
-			reg = <0xfd484000 0x2000>;
-		};
-
-		mmcc: clock-controller@fd8c0000 {
-			compatible = "qcom,mmcc-msm8974";
-			#clock-cells = <1>;
-			#reset-cells = <1>;
-			#power-domain-cells = <1>;
-			reg = <0xfd8c0000 0x6000>;
-		};
-
-		tcsr_mutex: tcsr-mutex {
-			compatible = "qcom,tcsr-mutex";
-			syscon = <&tcsr_mutex_block 0 0x80>;
-
-			#hwlock-cells = <1>;
-		};
-
-		rpm_msg_ram: memory@fc428000 {
-			compatible = "qcom,rpm-msg-ram";
-			reg = <0xfc428000 0x4000>;
-		};
-
-		blsp1_uart1: serial@f991d000 {
-			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
-			reg = <0xf991d000 0x1000>;
-			interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&gcc GCC_BLSP1_UART1_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
-			clock-names = "core", "iface";
-			status = "disabled";
-		};
-
-		blsp1_uart2: serial@f991e000 {
-			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
-			reg = <0xf991e000 0x1000>;
-			interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
-			clock-names = "core", "iface";
-			status = "disabled";
-		};
-
-		blsp2_uart1: serial@f995d000 {
-			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
-			reg = <0xf995d000 0x1000>;
-			interrupts = <GIC_SPI 113 IRQ_TYPE_NONE>;
-			clocks = <&gcc GCC_BLSP2_UART1_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
-			clock-names = "core", "iface";
-			status = "disabled";
-		};
-
-		blsp2_uart2: serial@f995e000 {
-			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
-			reg = <0xf995e000 0x1000>;
-			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&gcc GCC_BLSP2_UART2_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
-			clock-names = "core", "iface";
-			status = "disabled";
-		};
-
-		blsp2_uart4: serial@f9960000 {
-			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
-			reg = <0xf9960000 0x1000>;
-			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&gcc GCC_BLSP2_UART4_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
-			clock-names = "core", "iface";
-			status = "disabled";
-		};
-
 		sdhc_1: sdhci@f9824900 {
 			compatible = "qcom,msm8974-sdhci", "qcom,sdhci-msm-v4";
 			reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
@@ -758,182 +484,25 @@ sdhc_2: sdhci@f98a4900 {
 			clock-names = "core", "iface", "xo";
 			bus-width = <4>;
 
-			status = "disabled";
-		};
-
-		otg: usb@f9a55000 {
-			compatible = "qcom,ci-hdrc";
-			reg = <0xf9a55000 0x200>,
-			      <0xf9a55200 0x200>;
-			interrupts = <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&gcc GCC_USB_HS_AHB_CLK>,
-				 <&gcc GCC_USB_HS_SYSTEM_CLK>;
-			clock-names = "iface", "core";
-			assigned-clocks = <&gcc GCC_USB_HS_SYSTEM_CLK>;
-			assigned-clock-rates = <75000000>;
-			resets = <&gcc GCC_USB_HS_BCR>;
-			reset-names = "core";
-			phy_type = "ulpi";
-			dr_mode = "otg";
-			ahb-burst-config = <0>;
-			phy-names = "usb-phy";
-			status = "disabled";
-			#reset-cells = <1>;
-
-			ulpi {
-				usb_hs1_phy: phy@a {
-					compatible = "qcom,usb-hs-phy-msm8974",
-						     "qcom,usb-hs-phy";
-					#phy-cells = <0>;
-					clocks = <&xo_board>, <&gcc GCC_USB2A_PHY_SLEEP_CLK>;
-					clock-names = "ref", "sleep";
-					resets = <&gcc GCC_USB2A_PHY_BCR>, <&otg 0>;
-					reset-names = "phy", "por";
-					status = "disabled";
-				};
-
-				usb_hs2_phy: phy@b {
-					compatible = "qcom,usb-hs-phy-msm8974",
-						     "qcom,usb-hs-phy";
-					#phy-cells = <0>;
-					clocks = <&xo_board>, <&gcc GCC_USB2B_PHY_SLEEP_CLK>;
-					clock-names = "ref", "sleep";
-					resets = <&gcc GCC_USB2B_PHY_BCR>, <&otg 1>;
-					reset-names = "phy", "por";
-					status = "disabled";
-				};
-			};
-		};
-
-		rng@f9bff000 {
-			compatible = "qcom,prng";
-			reg = <0xf9bff000 0x200>;
-			clocks = <&gcc GCC_PRNG_AHB_CLK>;
-			clock-names = "core";
-		};
-
-		remoteproc_mss: remoteproc@fc880000 {
-			compatible = "qcom,msm8974-mss-pil";
-			reg = <0xfc880000 0x100>, <0xfc820000 0x020>;
-			reg-names = "qdsp6", "rmb";
-
-			interrupts-extended = <&intc GIC_SPI 24 IRQ_TYPE_EDGE_RISING>,
-					      <&modem_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,
-					      <&modem_smp2p_in 1 IRQ_TYPE_EDGE_RISING>,
-					      <&modem_smp2p_in 2 IRQ_TYPE_EDGE_RISING>,
-					      <&modem_smp2p_in 3 IRQ_TYPE_EDGE_RISING>;
-			interrupt-names = "wdog", "fatal", "ready", "handover", "stop-ack";
-
-			clocks = <&gcc GCC_MSS_Q6_BIMC_AXI_CLK>,
-				 <&gcc GCC_MSS_CFG_AHB_CLK>,
-				 <&gcc GCC_BOOT_ROM_AHB_CLK>,
-				 <&xo_board>;
-			clock-names = "iface", "bus", "mem", "xo";
-
-			resets = <&gcc GCC_MSS_RESTART>;
-			reset-names = "mss_restart";
-
-			cx-supply = <&pm8841_s2>;
-			mss-supply = <&pm8841_s3>;
-			mx-supply = <&pm8841_s1>;
-			pll-supply = <&pm8941_l12>;
-
-			qcom,halt-regs = <&tcsr_mutex_block 0x1180 0x1200 0x1280>;
-
-			qcom,smem-states = <&modem_smp2p_out 0>;
-			qcom,smem-state-names = "stop";
-
-			mba {
-				memory-region = <&mba_region>;
-			};
-
-			mpss {
-				memory-region = <&mpss_region>;
-			};
-
-			smd-edge {
-				interrupts = <GIC_SPI 25 IRQ_TYPE_EDGE_RISING>;
-
-				qcom,ipc = <&apcs 8 12>;
-				qcom,smd-edge = <0>;
-
-				label = "modem";
-			};
-		};
-
-		pronto: remoteproc@fb21b000 {
-			compatible = "qcom,pronto-v2-pil", "qcom,pronto";
-			reg = <0xfb204000 0x2000>, <0xfb202000 0x1000>, <0xfb21b000 0x3000>;
-			reg-names = "ccu", "dxe", "pmu";
-
-			memory-region = <&wcnss_region>;
-
-			interrupts-extended = <&intc GIC_SPI 149 IRQ_TYPE_EDGE_RISING>,
-					      <&wcnss_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,
-					      <&wcnss_smp2p_in 1 IRQ_TYPE_EDGE_RISING>,
-					      <&wcnss_smp2p_in 2 IRQ_TYPE_EDGE_RISING>,
-					      <&wcnss_smp2p_in 3 IRQ_TYPE_EDGE_RISING>;
-			interrupt-names = "wdog", "fatal", "ready", "handover", "stop-ack";
-
-			vddpx-supply = <&pm8941_s3>;
-
-			qcom,smem-states = <&wcnss_smp2p_out 0>;
-			qcom,smem-state-names = "stop";
-
-			status = "disabled";
-
-			iris {
-				compatible = "qcom,wcn3680";
-
-				clocks = <&rpmcc RPM_SMD_CXO_A2>;
-				clock-names = "xo";
-
-				vddxo-supply = <&pm8941_l6>;
-				vddrfa-supply = <&pm8941_l11>;
-				vddpa-supply = <&pm8941_l19>;
-				vdddig-supply = <&pm8941_s3>;
-			};
-
-			smd-edge {
-				interrupts = <GIC_SPI 142 IRQ_TYPE_EDGE_RISING>;
-
-				qcom,ipc = <&apcs 8 17>;
-				qcom,smd-edge = <6>;
-
-				wcnss {
-					compatible = "qcom,wcnss";
-					qcom,smd-channels = "WCNSS_CTRL";
-					status = "disabled";
-
-					qcom,mmio = <&pronto>;
-
-					bt {
-						compatible = "qcom,wcnss-bt";
-					};
-
-					wifi {
-						compatible = "qcom,wcnss-wlan";
-
-						interrupts = <GIC_SPI 145 IRQ_TYPE_EDGE_RISING>,
-							     <GIC_SPI 146 IRQ_TYPE_EDGE_RISING>;
-						interrupt-names = "tx", "rx";
+			status = "disabled";
+		};
 
-						qcom,smem-states = <&apps_smsm 10>, <&apps_smsm 9>;
-						qcom,smem-state-names = "tx-enable", "tx-rings-empty";
-					};
-				};
-			};
+		blsp1_uart1: serial@f991d000 {
+			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
+			reg = <0xf991d000 0x1000>;
+			interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&gcc GCC_BLSP1_UART1_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
+			clock-names = "core", "iface";
+			status = "disabled";
 		};
 
-		tlmm: pinctrl@fd510000 {
-			compatible = "qcom,msm8974-pinctrl";
-			reg = <0xfd510000 0x4000>;
-			gpio-controller;
-			gpio-ranges = <&tlmm 0 0 146>;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupt-cells = <2>;
-			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
+		blsp1_uart2: serial@f991e000 {
+			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
+			reg = <0xf991e000 0x1000>;
+			interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
+			clock-names = "core", "iface";
+			status = "disabled";
 		};
 
 		blsp1_i2c1: i2c@f9923000 {
@@ -980,6 +549,43 @@ blsp1_i2c6: i2c@f9928000 {
 			#size-cells = <0>;
 		};
 
+		blsp2_dma: dma-controller@f9944000 {
+			compatible = "qcom,bam-v1.4.0";
+			reg = <0xf9944000 0x19000>;
+			interrupts = <GIC_SPI 239 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&gcc GCC_BLSP2_AHB_CLK>;
+			clock-names = "bam_clk";
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+		};
+
+		blsp2_uart1: serial@f995d000 {
+			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
+			reg = <0xf995d000 0x1000>;
+			interrupts = <GIC_SPI 113 IRQ_TYPE_NONE>;
+			clocks = <&gcc GCC_BLSP2_UART1_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
+			clock-names = "core", "iface";
+			status = "disabled";
+		};
+
+		blsp2_uart2: serial@f995e000 {
+			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
+			reg = <0xf995e000 0x1000>;
+			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&gcc GCC_BLSP2_UART2_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
+			clock-names = "core", "iface";
+			status = "disabled";
+		};
+
+		blsp2_uart4: serial@f9960000 {
+			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
+			reg = <0xf9960000 0x1000>;
+			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&gcc GCC_BLSP2_UART4_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
+			clock-names = "core", "iface";
+			status = "disabled";
+		};
+
 		blsp2_i2c2: i2c@f9964000 {
 			status = "disabled";
 			compatible = "qcom,i2c-qup-v2.1.1";
@@ -1015,93 +621,110 @@ blsp2_i2c6: i2c@f9968000 {
 			#size-cells = <0>;
 		};
 
-		spmi_bus: spmi@fc4cf000 {
-			compatible = "qcom,spmi-pmic-arb";
-			reg-names = "core", "intr", "cnfg";
-			reg = <0xfc4cf000 0x1000>,
-			      <0xfc4cb000 0x1000>,
-			      <0xfc4ca000 0x1000>;
-			interrupt-names = "periph_irq";
-			interrupts = <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>;
-			qcom,ee = <0>;
-			qcom,channel = <0>;
-			#address-cells = <2>;
-			#size-cells = <0>;
-			interrupt-controller;
-			#interrupt-cells = <4>;
+		otg: usb@f9a55000 {
+			compatible = "qcom,ci-hdrc";
+			reg = <0xf9a55000 0x200>,
+			      <0xf9a55200 0x200>;
+			interrupts = <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&gcc GCC_USB_HS_AHB_CLK>,
+				 <&gcc GCC_USB_HS_SYSTEM_CLK>;
+			clock-names = "iface", "core";
+			assigned-clocks = <&gcc GCC_USB_HS_SYSTEM_CLK>;
+			assigned-clock-rates = <75000000>;
+			resets = <&gcc GCC_USB_HS_BCR>;
+			reset-names = "core";
+			phy_type = "ulpi";
+			dr_mode = "otg";
+			ahb-burst-config = <0>;
+			phy-names = "usb-phy";
+			status = "disabled";
+			#reset-cells = <1>;
+
+			ulpi {
+				usb_hs1_phy: phy@a {
+					compatible = "qcom,usb-hs-phy-msm8974",
+						     "qcom,usb-hs-phy";
+					#phy-cells = <0>;
+					clocks = <&xo_board>, <&gcc GCC_USB2A_PHY_SLEEP_CLK>;
+					clock-names = "ref", "sleep";
+					resets = <&gcc GCC_USB2A_PHY_BCR>, <&otg 0>;
+					reset-names = "phy", "por";
+					status = "disabled";
+				};
+
+				usb_hs2_phy: phy@b {
+					compatible = "qcom,usb-hs-phy-msm8974",
+						     "qcom,usb-hs-phy";
+					#phy-cells = <0>;
+					clocks = <&xo_board>, <&gcc GCC_USB2B_PHY_SLEEP_CLK>;
+					clock-names = "ref", "sleep";
+					resets = <&gcc GCC_USB2B_PHY_BCR>, <&otg 1>;
+					reset-names = "phy", "por";
+					status = "disabled";
+				};
+			};
 		};
 
-		blsp2_dma: dma-controller@f9944000 {
-			compatible = "qcom,bam-v1.4.0";
-			reg = <0xf9944000 0x19000>;
-			interrupts = <GIC_SPI 239 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&gcc GCC_BLSP2_AHB_CLK>;
-			clock-names = "bam_clk";
-			#dma-cells = <1>;
-			qcom,ee = <0>;
+		rng@f9bff000 {
+			compatible = "qcom,prng";
+			reg = <0xf9bff000 0x200>;
+			clocks = <&gcc GCC_PRNG_AHB_CLK>;
+			clock-names = "core";
 		};
 
-		etr@fc322000 {
-			compatible = "arm,coresight-tmc", "arm,primecell";
-			reg = <0xfc322000 0x1000>;
+		pronto: remoteproc@fb21b000 {
+			compatible = "qcom,pronto-v2-pil", "qcom,pronto";
+			reg = <0xfb204000 0x2000>, <0xfb202000 0x1000>, <0xfb21b000 0x3000>;
+			reg-names = "ccu", "dxe", "pmu";
 
-			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
-			clock-names = "apb_pclk", "atclk";
+			memory-region = <&wcnss_region>;
 
-			in-ports {
-				port {
-					etr_in: endpoint {
-						remote-endpoint = <&replicator_out0>;
-					};
-				};
-			};
-		};
+			interrupts-extended = <&intc GIC_SPI 149 IRQ_TYPE_EDGE_RISING>,
+					      <&wcnss_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,
+					      <&wcnss_smp2p_in 1 IRQ_TYPE_EDGE_RISING>,
+					      <&wcnss_smp2p_in 2 IRQ_TYPE_EDGE_RISING>,
+					      <&wcnss_smp2p_in 3 IRQ_TYPE_EDGE_RISING>;
+			interrupt-names = "wdog", "fatal", "ready", "handover", "stop-ack";
 
-		tpiu@fc318000 {
-			compatible = "arm,coresight-tpiu", "arm,primecell";
-			reg = <0xfc318000 0x1000>;
+			qcom,smem-states = <&wcnss_smp2p_out 0>;
+			qcom,smem-state-names = "stop";
 
-			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
-			clock-names = "apb_pclk", "atclk";
+			status = "disabled";
 
-			in-ports {
-				port {
-					tpiu_in: endpoint {
-						remote-endpoint = <&replicator_out1>;
-					};
-				 };
+			iris {
+				compatible = "qcom,wcn3680";
+
+				clocks = <&rpmcc RPM_SMD_CXO_A2>;
+				clock-names = "xo";
 			};
-		};
 
-		replicator@fc31c000 {
-			compatible = "arm,coresight-dynamic-replicator", "arm,primecell";
-			reg = <0xfc31c000 0x1000>;
+			smd-edge {
+				interrupts = <GIC_SPI 142 IRQ_TYPE_EDGE_RISING>;
 
-			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
-			clock-names = "apb_pclk", "atclk";
+				qcom,ipc = <&apcs 8 17>;
+				qcom,smd-edge = <6>;
 
-			out-ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
+				wcnss {
+					compatible = "qcom,wcnss";
+					qcom,smd-channels = "WCNSS_CTRL";
+					status = "disabled";
 
-				port@0 {
-					reg = <0>;
-					replicator_out0: endpoint {
-						remote-endpoint = <&etr_in>;
-					};
-				};
-				port@1 {
-					reg = <1>;
-					replicator_out1: endpoint {
-						remote-endpoint = <&tpiu_in>;
+					qcom,mmio = <&pronto>;
+
+					bt {
+						compatible = "qcom,wcnss-bt";
 					};
-				};
-			};
 
-			in-ports {
-				port {
-					replicator_in: endpoint {
-						remote-endpoint = <&etf_out>;
+					wifi {
+						compatible = "qcom,wcnss-wlan";
+
+						interrupts = <GIC_SPI 145 IRQ_TYPE_EDGE_RISING>,
+							     <GIC_SPI 146 IRQ_TYPE_EDGE_RISING>;
+						interrupt-names = "tx", "rx";
+
+						qcom,smem-states = <&apps_smsm 10>, <&apps_smsm 9>;
+						qcom,smem-state-names = "tx-enable",
+									"tx-rings-empty";
 					};
 				};
 			};
@@ -1131,37 +754,19 @@ etf_in: endpoint {
 			};
 		};
 
-		funnel@fc31b000 {
-			compatible = "arm,coresight-dynamic-funnel", "arm,primecell";
-			reg = <0xfc31b000 0x1000>;
+		tpiu@fc318000 {
+			compatible = "arm,coresight-tpiu", "arm,primecell";
+			reg = <0xfc318000 0x1000>;
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
 
 			in-ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				/*
-				 * Not described input ports:
-				 * 0 - connected trought funnel to Audio, Modem and
-				 *     Resource and Power Manager CPU's
-				 * 2...7 - not-connected
-				 */
-				port@1 {
-					reg = <1>;
-					merger_in1: endpoint {
-						remote-endpoint = <&funnel1_out>;
-					};
-				};
-			};
-
-			out-ports {
 				port {
-					merger_out: endpoint {
-						remote-endpoint = <&etf_in>;
+					tpiu_in: endpoint {
+						remote-endpoint = <&replicator_out1>;
 					};
-				};
+				 };
 			};
 		};
 
@@ -1203,9 +808,9 @@ funnel1_out: endpoint {
 			};
 		};
 
-		funnel@fc345000 { /* KPSS funnel only 4 inputs are used */
+		funnel@fc31b000 {
 			compatible = "arm,coresight-dynamic-funnel", "arm,primecell";
-			reg = <0xfc345000 0x1000>;
+			reg = <0xfc31b000 0x1000>;
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1214,36 +819,74 @@ in-ports {
 				#address-cells = <1>;
 				#size-cells = <0>;
 
+				/*
+				 * Not described input ports:
+				 * 0 - connected trought funnel to Audio, Modem and
+				 *     Resource and Power Manager CPU's
+				 * 2...7 - not-connected
+				 */
+				port@1 {
+					reg = <1>;
+					merger_in1: endpoint {
+						remote-endpoint = <&funnel1_out>;
+					};
+				};
+			};
+
+			out-ports {
+				port {
+					merger_out: endpoint {
+						remote-endpoint = <&etf_in>;
+					};
+				};
+			};
+		};
+
+		replicator@fc31c000 {
+			compatible = "arm,coresight-dynamic-replicator", "arm,primecell";
+			reg = <0xfc31c000 0x1000>;
+
+			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
+			clock-names = "apb_pclk", "atclk";
+
+			out-ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
 				port@0 {
 					reg = <0>;
-					kpss_in0: endpoint {
-						remote-endpoint = <&etm0_out>;
+					replicator_out0: endpoint {
+						remote-endpoint = <&etr_in>;
 					};
 				};
 				port@1 {
 					reg = <1>;
-					kpss_in1: endpoint {
-						remote-endpoint = <&etm1_out>;
-					};
-				};
-				port@2 {
-					reg = <2>;
-					kpss_in2: endpoint {
-						remote-endpoint = <&etm2_out>;
+					replicator_out1: endpoint {
+						remote-endpoint = <&tpiu_in>;
 					};
 				};
-				port@3 {
-					reg = <3>;
-					kpss_in3: endpoint {
-						remote-endpoint = <&etm3_out>;
+			};
+
+			in-ports {
+				port {
+					replicator_in: endpoint {
+						remote-endpoint = <&etf_out>;
 					};
 				};
 			};
+		};
 
-			out-ports {
+		etr@fc322000 {
+			compatible = "arm,coresight-tmc", "arm,primecell";
+			reg = <0xfc322000 0x1000>;
+
+			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
+			clock-names = "apb_pclk", "atclk";
+
+			in-ports {
 				port {
-					kpss_out: endpoint {
-						remote-endpoint = <&funnel1_in5>;
+					etr_in: endpoint {
+						remote-endpoint = <&replicator_out0>;
 					};
 				};
 			};
@@ -1321,25 +964,66 @@ etm3_out: endpoint {
 			};
 		};
 
-		ocmem@fdd00000 {
-			compatible = "qcom,msm8974-ocmem";
-			reg = <0xfdd00000 0x2000>,
-			      <0xfec00000 0x180000>;
-			reg-names = "ctrl",
-			            "mem";
-			clocks = <&rpmcc RPM_SMD_OCMEMGX_CLK>,
-			         <&mmcc OCMEMCX_OCMEMNOC_CLK>;
-			clock-names = "core",
-			              "iface";
+		/* KPSS funnel, only 4 inputs are used */
+		funnel@fc345000 {
+			compatible = "arm,coresight-dynamic-funnel", "arm,primecell";
+			reg = <0xfc345000 0x1000>;
 
-			#address-cells = <1>;
-			#size-cells = <1>;
+			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
+			clock-names = "apb_pclk", "atclk";
 
-			gmu_sram: gmu-sram@0 {
-				reg = <0x0 0x100000>;
+			in-ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@0 {
+					reg = <0>;
+					kpss_in0: endpoint {
+						remote-endpoint = <&etm0_out>;
+					};
+				};
+				port@1 {
+					reg = <1>;
+					kpss_in1: endpoint {
+						remote-endpoint = <&etm1_out>;
+					};
+				};
+				port@2 {
+					reg = <2>;
+					kpss_in2: endpoint {
+						remote-endpoint = <&etm2_out>;
+					};
+				};
+				port@3 {
+					reg = <3>;
+					kpss_in3: endpoint {
+						remote-endpoint = <&etm3_out>;
+					};
+				};
+			};
+
+			out-ports {
+				port {
+					kpss_out: endpoint {
+						remote-endpoint = <&funnel1_in5>;
+					};
+				};
 			};
 		};
 
+		gcc: clock-controller@fc400000 {
+			compatible = "qcom,gcc-msm8974";
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+			#power-domain-cells = <1>;
+			reg = <0xfc400000 0x4000>;
+		};
+
+		rpm_msg_ram: memory@fc428000 {
+			compatible = "qcom,rpm-msg-ram";
+			reg = <0xfc428000 0x4000>;
+		};
+
 		bimc: interconnect@fc380000 {
 			reg = <0xfc380000 0x6a000>;
 			compatible = "qcom,msm8974-bimc";
@@ -1394,47 +1078,123 @@ cnoc: interconnect@fc480000 {
 			         <&rpmcc RPM_SMD_CNOC_A_CLK>;
 		};
 
-		gpu: adreno@fdb00000 {
-			status = "disabled";
+		tsens: thermal-sensor@fc4a9000 {
+			compatible = "qcom,msm8974-tsens";
+			reg = <0xfc4a9000 0x1000>, /* TM */
+			      <0xfc4a8000 0x1000>; /* SROT */
+			nvmem-cells = <&tsens_calib>, <&tsens_backup>;
+			nvmem-cell-names = "calib", "calib_backup";
+			#qcom,sensors = <11>;
+			interrupts = <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "uplow";
+			#thermal-sensor-cells = <1>;
+		};
 
-			compatible = "qcom,adreno-330.1",
-				     "qcom,adreno";
-			reg = <0xfdb00000 0x10000>;
-			reg-names = "kgsl_3d0_reg_memory";
-			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "kgsl_3d0_irq";
-			clock-names = "core",
-				      "iface",
-				      "mem_iface";
-			clocks = <&mmcc OXILI_GFX3D_CLK>,
-				 <&mmcc OXILICX_AHB_CLK>,
-				 <&mmcc OXILICX_AXI_CLK>;
-			sram = <&gmu_sram>;
-			power-domains = <&mmcc OXILICX_GDSC>;
-			operating-points-v2 = <&gpu_opp_table>;
+		restart@fc4ab000 {
+			compatible = "qcom,pshold";
+			reg = <0xfc4ab000 0x4>;
+		};
 
-			interconnects = <&mmssnoc MNOC_MAS_GRAPHICS_3D &bimc BIMC_SLV_EBI_CH0>,
-					<&ocmemnoc OCMEM_VNOC_MAS_GFX3D &ocmemnoc OCMEM_SLV_OCMEM>;
-			interconnect-names = "gfx-mem",
-					     "ocmem";
+		qfprom: qfprom@fc4bc000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "qcom,qfprom";
+			reg = <0xfc4bc000 0x1000>;
+			tsens_calib: calib@d0 {
+				reg = <0xd0 0x18>;
+			};
+			tsens_backup: backup@440 {
+				reg = <0x440 0x10>;
+			};
+		};
 
-			// iommus = <&gpu_iommu 0>;
+		spmi_bus: spmi@fc4cf000 {
+			compatible = "qcom,spmi-pmic-arb";
+			reg-names = "core", "intr", "cnfg";
+			reg = <0xfc4cf000 0x1000>,
+			      <0xfc4cb000 0x1000>,
+			      <0xfc4ca000 0x1000>;
+			interrupt-names = "periph_irq";
+			interrupts = <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>;
+			qcom,ee = <0>;
+			qcom,channel = <0>;
+			#address-cells = <2>;
+			#size-cells = <0>;
+			interrupt-controller;
+			#interrupt-cells = <4>;
+		};
 
-			gpu_opp_table: opp_table {
-				compatible = "operating-points-v2";
+		remoteproc_mss: remoteproc@fc880000 {
+			compatible = "qcom,msm8974-mss-pil";
+			reg = <0xfc880000 0x100>, <0xfc820000 0x020>;
+			reg-names = "qdsp6", "rmb";
 
-				opp-320000000 {
-					opp-hz = /bits/ 64 <320000000>;
-				};
+			interrupts-extended = <&intc GIC_SPI 24 IRQ_TYPE_EDGE_RISING>,
+					      <&modem_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,
+					      <&modem_smp2p_in 1 IRQ_TYPE_EDGE_RISING>,
+					      <&modem_smp2p_in 2 IRQ_TYPE_EDGE_RISING>,
+					      <&modem_smp2p_in 3 IRQ_TYPE_EDGE_RISING>;
+			interrupt-names = "wdog", "fatal", "ready", "handover", "stop-ack";
 
-				opp-200000000 {
-					opp-hz = /bits/ 64 <200000000>;
-				};
+			clocks = <&gcc GCC_MSS_Q6_BIMC_AXI_CLK>,
+				 <&gcc GCC_MSS_CFG_AHB_CLK>,
+				 <&gcc GCC_BOOT_ROM_AHB_CLK>,
+				 <&xo_board>;
+			clock-names = "iface", "bus", "mem", "xo";
+
+			resets = <&gcc GCC_MSS_RESTART>;
+			reset-names = "mss_restart";
+
+			qcom,halt-regs = <&tcsr_mutex_block 0x1180 0x1200 0x1280>;
+
+			qcom,smem-states = <&modem_smp2p_out 0>;
+			qcom,smem-state-names = "stop";
+
+			mba {
+				memory-region = <&mba_region>;
+			};
+
+			mpss {
+				memory-region = <&mpss_region>;
+			};
+
+			smd-edge {
+				interrupts = <GIC_SPI 25 IRQ_TYPE_EDGE_RISING>;
+
+				qcom,ipc = <&apcs 8 12>;
+				qcom,smd-edge = <0>;
+
+				label = "modem";
+			};
+		};
+
+		tcsr_mutex_block: syscon@fd484000 {
+			compatible = "syscon";
+			reg = <0xfd484000 0x2000>;
+		};
+
+		tcsr: syscon@fd4a0000 {
+			compatible = "syscon";
+			reg = <0xfd4a0000 0x10000>;
+		};
+
+		tlmm: pinctrl@fd510000 {
+			compatible = "qcom,msm8974-pinctrl";
+			reg = <0xfd510000 0x4000>;
+			gpio-controller;
+			gpio-ranges = <&tlmm 0 0 146>;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
+		};
 
-				opp-27000000 {
-					opp-hz = /bits/ 64 <27000000>;
-				};
-			};
+		mmcc: clock-controller@fd8c0000 {
+			compatible = "qcom,mmcc-msm8974";
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+			#power-domain-cells = <1>;
+			reg = <0xfd8c0000 0x6000>;
 		};
 
 		mdss: mdss@fd900000 {
@@ -1562,6 +1322,65 @@ dsi0_phy: dsi-phy@fd922a00 {
 			};
 		};
 
+		gpu: adreno@fdb00000 {
+			compatible = "qcom,adreno-330.1", "qcom,adreno";
+			reg = <0xfdb00000 0x10000>;
+			reg-names = "kgsl_3d0_reg_memory";
+
+			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "kgsl_3d0_irq";
+
+			clocks = <&mmcc OXILI_GFX3D_CLK>,
+				 <&mmcc OXILICX_AHB_CLK>,
+				 <&mmcc OXILICX_AXI_CLK>;
+			clock-names = "core", "iface", "mem_iface";
+
+			sram = <&gmu_sram>;
+			power-domains = <&mmcc OXILICX_GDSC>;
+			operating-points-v2 = <&gpu_opp_table>;
+
+			interconnects = <&mmssnoc MNOC_MAS_GRAPHICS_3D &bimc BIMC_SLV_EBI_CH0>,
+					<&ocmemnoc OCMEM_VNOC_MAS_GFX3D &ocmemnoc OCMEM_SLV_OCMEM>;
+			interconnect-names = "gfx-mem", "ocmem";
+
+			// iommus = <&gpu_iommu 0>;
+
+			status = "disabled";
+
+			gpu_opp_table: opp_table {
+				compatible = "operating-points-v2";
+
+				opp-320000000 {
+					opp-hz = /bits/ 64 <320000000>;
+				};
+
+				opp-200000000 {
+					opp-hz = /bits/ 64 <200000000>;
+				};
+
+				opp-27000000 {
+					opp-hz = /bits/ 64 <27000000>;
+				};
+			};
+		};
+
+		ocmem@fdd00000 {
+			compatible = "qcom,msm8974-ocmem";
+			reg = <0xfdd00000 0x2000>,
+			      <0xfec00000 0x180000>;
+			reg-names = "ctrl", "mem";
+			clocks = <&rpmcc RPM_SMD_OCMEMGX_CLK>,
+				 <&mmcc OCMEMCX_OCMEMNOC_CLK>;
+			clock-names = "core", "iface";
+
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			gmu_sram: gmu-sram@0 {
+				reg = <0x0 0x100000>;
+			};
+		};
+
 		remoteproc_adsp: remoteproc@fe200000 {
 			compatible = "qcom,msm8974-adsp-pil";
 			reg = <0xfe200000 0x100>;
@@ -1604,76 +1423,194 @@ reboot-mode {
 		};
 	};
 
-	smd {
-		compatible = "qcom,smd";
+	tcsr_mutex: tcsr-mutex {
+		compatible = "qcom,tcsr-mutex";
+		syscon = <&tcsr_mutex_block 0 0x80>;
 
-		rpm {
-			interrupts = <GIC_SPI 168 IRQ_TYPE_EDGE_RISING>;
-			qcom,ipc = <&apcs 8 0>;
-			qcom,smd-edge = <15>;
+		#hwlock-cells = <1>;
+	};
 
-			rpm_requests: rpm-requests {
-				compatible = "qcom,rpm-msm8974";
-				qcom,smd-channels = "rpm_requests";
+	thermal-zones {
+		cpu0-thermal {
+			polling-delay-passive = <250>;
+			polling-delay = <1000>;
 
-				rpmcc: clock-controller {
-					compatible = "qcom,rpmcc-msm8974", "qcom,rpmcc";
-					#clock-cells = <1>;
+			thermal-sensors = <&tsens 5>;
+
+			trips {
+				cpu_alert0: trip0 {
+					temperature = <75000>;
+					hysteresis = <2000>;
+					type = "passive";
+				};
+				cpu_crit0: trip1 {
+					temperature = <110000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu1-thermal {
+			polling-delay-passive = <250>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&tsens 6>;
+
+			trips {
+				cpu_alert1: trip0 {
+					temperature = <75000>;
+					hysteresis = <2000>;
+					type = "passive";
+				};
+				cpu_crit1: trip1 {
+					temperature = <110000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu2-thermal {
+			polling-delay-passive = <250>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&tsens 7>;
+
+			trips {
+				cpu_alert2: trip0 {
+					temperature = <75000>;
+					hysteresis = <2000>;
+					type = "passive";
+				};
+				cpu_crit2: trip1 {
+					temperature = <110000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu3-thermal {
+			polling-delay-passive = <250>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&tsens 8>;
+
+			trips {
+				cpu_alert3: trip0 {
+					temperature = <75000>;
+					hysteresis = <2000>;
+					type = "passive";
+				};
+				cpu_crit3: trip1 {
+					temperature = <110000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
+		};
+
+		q6-dsp-thermal {
+			polling-delay-passive = <250>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&tsens 1>;
+
+			trips {
+				q6_dsp_alert0: trip-point0 {
+					temperature = <90000>;
+					hysteresis = <2000>;
+					type = "hot";
+				};
+			};
+		};
+
+		modemtx-thermal {
+			polling-delay-passive = <250>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&tsens 2>;
+
+			trips {
+				modemtx_alert0: trip-point0 {
+					temperature = <90000>;
+					hysteresis = <2000>;
+					type = "hot";
+				};
+			};
+		};
+
+		video-thermal {
+			polling-delay-passive = <250>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&tsens 3>;
+
+			trips {
+				video_alert0: trip-point0 {
+					temperature = <95000>;
+					hysteresis = <2000>;
+					type = "hot";
+				};
+			};
+		};
+
+		wlan-thermal {
+			polling-delay-passive = <250>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&tsens 4>;
+
+			trips {
+				wlan_alert0: trip-point0 {
+					temperature = <105000>;
+					hysteresis = <2000>;
+					type = "hot";
 				};
+			};
+		};
+
+		gpu-top-thermal {
+			polling-delay-passive = <250>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&tsens 9>;
 
-				pm8841-regulators {
-					compatible = "qcom,rpm-pm8841-regulators";
-
-					pm8841_s1: s1 {};
-					pm8841_s2: s2 {};
-					pm8841_s3: s3 {};
-					pm8841_s4: s4 {};
-					pm8841_s5: s5 {};
-					pm8841_s6: s6 {};
-					pm8841_s7: s7 {};
-					pm8841_s8: s8 {};
+			trips {
+				gpu1_alert0: trip-point0 {
+					temperature = <90000>;
+					hysteresis = <2000>;
+					type = "hot";
 				};
+			};
+		};
+
+		gpu-bottom-thermal {
+			polling-delay-passive = <250>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&tsens 10>;
 
-				pm8941-regulators {
-					compatible = "qcom,rpm-pm8941-regulators";
-
-					pm8941_s1: s1 {};
-					pm8941_s2: s2 {};
-					pm8941_s3: s3 {};
-
-					pm8941_l1: l1 {};
-					pm8941_l2: l2 {};
-					pm8941_l3: l3 {};
-					pm8941_l4: l4 {};
-					pm8941_l5: l5 {};
-					pm8941_l6: l6 {};
-					pm8941_l7: l7 {};
-					pm8941_l8: l8 {};
-					pm8941_l9: l9 {};
-					pm8941_l10: l10 {};
-					pm8941_l11: l11 {};
-					pm8941_l12: l12 {};
-					pm8941_l13: l13 {};
-					pm8941_l14: l14 {};
-					pm8941_l15: l15 {};
-					pm8941_l16: l16 {};
-					pm8941_l17: l17 {};
-					pm8941_l18: l18 {};
-					pm8941_l19: l19 {};
-					pm8941_l20: l20 {};
-					pm8941_l21: l21 {};
-					pm8941_l22: l22 {};
-					pm8941_l23: l23 {};
-					pm8941_l24: l24 {};
-
-					pm8941_lvs1: lvs1 {};
-					pm8941_lvs2: lvs2 {};
-					pm8941_lvs3: lvs3 {};
+			trips {
+				gpu2_alert0: trip-point0 {
+					temperature = <90000>;
+					hysteresis = <2000>;
+					type = "hot";
 				};
 			};
 		};
 	};
 
+	timer {
+		compatible = "arm,armv7-timer";
+		interrupts = <GIC_PPI 2 0xf08>,
+			     <GIC_PPI 3 0xf08>,
+			     <GIC_PPI 4 0xf08>,
+			     <GIC_PPI 1 0xf08>;
+		clock-frequency = <19200000>;
+	};
+
 	vreg_boost: vreg-boost {
 		compatible = "regulator-fixed";
 
@@ -1690,6 +1627,7 @@ vreg_boost: vreg-boost {
 		pinctrl-names = "default";
 		pinctrl-0 = <&boost_bypass_n_pin>;
 	};
+
 	vreg_vph_pwr: vreg-vph-pwr {
 		compatible = "regulator-fixed";
 		regulator-name = "vph-pwr";
-- 
2.35.1



