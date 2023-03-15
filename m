Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CCC6BB046
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjCOMQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjCOMQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:16:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD75D7F017
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 58527CE19B9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F82C433D2;
        Wed, 15 Mar 2023 12:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882590;
        bh=iJxHAqJ91hOpuX9il+/7B1nqGcOMDfkEOWMwyWywolk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stQCujucbgwJt8CxoReFSMZiG/V0n3bhNuOKc4LmupDiRYJi4W8xduP8JwsOWaGHu
         0ipeK6+QTSPiiNQefL7qdpPQ0CN/ONFrti8MqUI/RH5OCek8/QJMEK4Fp3yo3zMCDb
         2zFhRPix5L8lgOV8NfinaeMEMtd+skoFtqXEd3Ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/39] ARM: dts: exynos: Move pmu and timer nodes out of soc
Date:   Wed, 15 Mar 2023 13:12:32 +0100
Message-Id: <20230315115721.903393165@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit be00300147ae3c0b2fa4dbc5f00d4332a8d00fac ]

The ARM PMU and ARM architected timer nodes are part of ARM CPU design
therefore they should not be inside the soc node.  This also fixes DTC
W=1 warnings like:

    arch/arm/boot/dts/exynos3250.dtsi:106.21-135.5:
        Warning (simple_bus_reg): /soc/fixed-rate-clocks: missing or empty reg/ranges property
    arch/arm/boot/dts/exynos3250.dtsi:676.7-680.5:
        Warning (simple_bus_reg): /soc/pmu: missing or empty reg/ranges property

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Stable-dep-of: 33e2c595e2e4 ("ARM: dts: exynos: correct TMU phandle in Exynos5250")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250.dtsi | 12 +++++-----
 arch/arm/boot/dts/exynos4.dtsi    | 12 +++++-----
 arch/arm/boot/dts/exynos5250.dtsi | 40 +++++++++++++++----------------
 arch/arm/boot/dts/exynos54xx.dtsi | 38 ++++++++++++++---------------
 4 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 5892a9f7622fa..af54b306204b8 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -97,6 +97,12 @@
 		};
 	};
 
+	pmu {
+		compatible = "arm,cortex-a7-pmu";
+		interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
 	soc: soc {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -673,12 +679,6 @@
 			status = "disabled";
 		};
 
-		pmu {
-			compatible = "arm,cortex-a7-pmu";
-			interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
-		};
-
 		ppmu_dmc0: ppmu_dmc0@106a0000 {
 			compatible = "samsung,exynos-ppmu";
 			reg = <0x106a0000 0x2000>;
diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 3f7488833745d..33eb2810cdaa2 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -51,6 +51,12 @@
 		serial3 = &serial_3;
 	};
 
+	pmu: pmu {
+		compatible = "arm,cortex-a9-pmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 2>, <3 2>;
+	};
+
 	soc: soc {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -169,12 +175,6 @@
 			reg = <0x10440000 0x1000>;
 		};
 
-		pmu: pmu {
-			compatible = "arm,cortex-a9-pmu";
-			interrupt-parent = <&combiner>;
-			interrupts = <2 2>, <3 2>;
-		};
-
 		sys_reg: syscon@10010000 {
 			compatible = "samsung,exynos4-sysreg", "syscon";
 			reg = <0x10010000 0x400>;
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index e6b1a8a9b832c..59e5f0016b862 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -157,6 +157,12 @@
 		};
 	};
 
+	pmu {
+		compatible = "arm,cortex-a15-pmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <1 2>, <22 4>;
+	};
+
 	soc: soc {
 		sysram@2020000 {
 			compatible = "mmio-sram";
@@ -227,20 +233,6 @@
 			power-domains = <&pd_mau>;
 		};
 
-		timer {
-			compatible = "arm,armv7-timer";
-			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
-				     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
-				     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
-				     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
-			/*
-			 * Unfortunately we need this since some versions
-			 * of U-Boot on Exynos don't set the CNTFRQ register,
-			 * so we need the value from DT.
-			 */
-			clock-frequency = <24000000>;
-		};
-
 		mct@101c0000 {
 			compatible = "samsung,exynos4210-mct";
 			reg = <0x101C0000 0x800>;
@@ -265,12 +257,6 @@
 			};
 		};
 
-		pmu {
-			compatible = "arm,cortex-a15-pmu";
-			interrupt-parent = <&combiner>;
-			interrupts = <1 2>, <22 4>;
-		};
-
 		pinctrl_0: pinctrl@11400000 {
 			compatible = "samsung,exynos5250-pinctrl";
 			reg = <0x11400000 0x1000>;
@@ -1076,6 +1062,20 @@
 		       };
 		};
 	};
+
+	timer {
+		compatible = "arm,armv7-timer";
+		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
+		/*
+		 * Unfortunately we need this since some versions
+		 * of U-Boot on Exynos don't set the CNTFRQ register,
+		 * so we need the value from DT.
+		 */
+		clock-frequency = <24000000>;
+	};
 };
 
 &dp {
diff --git a/arch/arm/boot/dts/exynos54xx.dtsi b/arch/arm/boot/dts/exynos54xx.dtsi
index de26e5ee0d2de..ae866bcc30c4e 100644
--- a/arch/arm/boot/dts/exynos54xx.dtsi
+++ b/arch/arm/boot/dts/exynos54xx.dtsi
@@ -25,27 +25,27 @@
 		usbdrdphy1 = &usbdrd_phy1;
 	};
 
-	soc: soc {
-		arm_a7_pmu: arm-a7-pmu {
-			compatible = "arm,cortex-a7-pmu";
-			interrupt-parent = <&gic>;
-			interrupts = <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 161 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
-			status = "disabled";
-		};
+	arm_a7_pmu: arm-a7-pmu {
+		compatible = "arm,cortex-a7-pmu";
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 161 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
+		status = "disabled";
+	};
 
-		arm_a15_pmu: arm-a15-pmu {
-			compatible = "arm,cortex-a15-pmu";
-			interrupt-parent = <&combiner>;
-			interrupts = <1 2>,
-				     <7 0>,
-				     <16 6>,
-				     <19 2>;
-			status = "disabled";
-		};
+	arm_a15_pmu: arm-a15-pmu {
+		compatible = "arm,cortex-a15-pmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <1 2>,
+			     <7 0>,
+			     <16 6>,
+			     <19 2>;
+		status = "disabled";
+	};
 
+	soc: soc {
 		sysram@2020000 {
 			compatible = "mmio-sram";
 			reg = <0x02020000 0x54000>;
-- 
2.39.2



