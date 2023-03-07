Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418E26AE863
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjCGRPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCGRPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:15:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F5396625
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:10:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67B9961508
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA7CC433EF;
        Tue,  7 Mar 2023 17:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209024;
        bh=zW+KwtOOO6nl/wfrjJHQ6QwFhY2YDCoWeM2hNFrUIAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TU3Yrz/+zyPfYbxyNwtF+ppwQoeWpbgrntelgjBnrvN2KUJ7vRSxtDHBQYKxhqApA
         jLBVkcdI+jX8BAg2fqBMMoe+Necr4jbyaCjrZkuPQQfD6qUcG53mGtLGq/JARm2pBS
         vAe4nc9/23zdHE9sJvUIfkYVi21cE4vIB9BV/lHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0085/1001] arm64: tegra: Bump #address-cells and #size-cells
Date:   Tue,  7 Mar 2023 17:47:37 +0100
Message-Id: <20230307170025.792957147@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 2838cfddbc1c4e12dacf8219efb481ab11c114a4 ]

The #address-cells and #size-cells properties for the top-level bus were
set to 1 because that was enough to represent the register ranges of all
the IP blocks on that bus. However, most of these devices can do DMA to
a larger address space, so translation of DMA addresses needs to happen
in a 64-bit address space.

Partially this was already done by the memory controller increasing that
address space by setting #address-cells and #size-cells to 2, but a full
DMA address translation would still cause truncation when traversing to
the top-level bus.

Fix this by setting #address-cells = <2> and #size-cells = <2> on the
top-level bus and adjusting all "reg" and "ranges" properties of its
children.

While at it, also move the PCI and GPU nodes back under the top-level
bus where they belong. The were put outside of it to work around this
same problem.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Stable-dep-of: 361238cdc525 ("arm64: tegra: Mark host1x as dma-coherent on Tegra194/234")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/nvidia/tegra194-p2972-0000.dts   |   84 +-
 .../boot/dts/nvidia/tegra194-p3509-0000.dtsi  |   54 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi      | 1128 ++++++------
 .../nvidia/tegra234-p3737-0000+p3701-0000.dts |  102 +-
 arch/arm64/boot/dts/nvidia/tegra234.dtsi      | 1530 +++++++++--------
 5 files changed, 1453 insertions(+), 1445 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts b/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts
index bc1041d11f6dc..f018fc4c0f707 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts
@@ -2184,67 +2184,67 @@ sor@15b80000 {
 							 GPIO_ACTIVE_LOW>;
 			};
 		};
-	};
 
-	pcie@14100000 {
-		status = "okay";
+		pcie@14100000 {
+			status = "okay";
 
-		vddio-pex-ctl-supply = <&vdd_1v8ao>;
+			vddio-pex-ctl-supply = <&vdd_1v8ao>;
 
-		phys = <&p2u_hsio_0>;
-		phy-names = "p2u-0";
-	};
+			phys = <&p2u_hsio_0>;
+			phy-names = "p2u-0";
+		};
 
-	pcie@14140000 {
-		status = "okay";
+		pcie@14140000 {
+			status = "okay";
 
-		vddio-pex-ctl-supply = <&vdd_1v8ao>;
+			vddio-pex-ctl-supply = <&vdd_1v8ao>;
 
-		phys = <&p2u_hsio_7>;
-		phy-names = "p2u-0";
-	};
+			phys = <&p2u_hsio_7>;
+			phy-names = "p2u-0";
+		};
 
-	pcie@14180000 {
-		status = "okay";
+		pcie@14180000 {
+			status = "okay";
 
-		vddio-pex-ctl-supply = <&vdd_1v8ao>;
+			vddio-pex-ctl-supply = <&vdd_1v8ao>;
 
-		phys = <&p2u_hsio_2>, <&p2u_hsio_3>, <&p2u_hsio_4>,
-		       <&p2u_hsio_5>;
-		phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3";
-	};
+			phys = <&p2u_hsio_2>, <&p2u_hsio_3>, <&p2u_hsio_4>,
+			       <&p2u_hsio_5>;
+			phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3";
+		};
 
-	pcie@141a0000 {
-		status = "okay";
+		pcie@141a0000 {
+			status = "okay";
 
-		vddio-pex-ctl-supply = <&vdd_1v8ao>;
-		vpcie3v3-supply = <&vdd_3v3_pcie>;
-		vpcie12v-supply = <&vdd_12v_pcie>;
+			vddio-pex-ctl-supply = <&vdd_1v8ao>;
+			vpcie3v3-supply = <&vdd_3v3_pcie>;
+			vpcie12v-supply = <&vdd_12v_pcie>;
 
-		phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
-		       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
-		       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
+			phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
+			       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
+			       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
 
-		phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
-			    "p2u-5", "p2u-6", "p2u-7";
-	};
+			phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
+				    "p2u-5", "p2u-6", "p2u-7";
+		};
 
-	pcie-ep@141a0000 {
-		status = "disabled";
+		pcie-ep@141a0000 {
+			status = "disabled";
 
-		vddio-pex-ctl-supply = <&vdd_1v8ao>;
+			vddio-pex-ctl-supply = <&vdd_1v8ao>;
 
-		reset-gpios = <&gpio TEGRA194_MAIN_GPIO(GG, 1) GPIO_ACTIVE_LOW>;
+			reset-gpios = <&gpio TEGRA194_MAIN_GPIO(GG, 1) GPIO_ACTIVE_LOW>;
 
-		nvidia,refclk-select-gpios = <&gpio_aon TEGRA194_AON_GPIO(AA, 5)
-					      GPIO_ACTIVE_HIGH>;
+			nvidia,refclk-select-gpios = <&gpio_aon TEGRA194_AON_GPIO(AA, 5)
+						      GPIO_ACTIVE_HIGH>;
 
-		phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
-		       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
-		       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
+			phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
+			       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
+			       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
 
-		phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
-			    "p2u-5", "p2u-6", "p2u-7";
+			phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
+				    "p2u-5", "p2u-6", "p2u-7";
+		};
 	};
 
 	fan: pwm-fan {
diff --git a/arch/arm64/boot/dts/nvidia/tegra194-p3509-0000.dtsi b/arch/arm64/boot/dts/nvidia/tegra194-p3509-0000.dtsi
index f212f6aced047..617fbfaaf02f6 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194-p3509-0000.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194-p3509-0000.dtsi
@@ -2209,46 +2209,46 @@ sor@15b40000 {
 							 GPIO_ACTIVE_LOW>;
 			};
 		};
-	};
 
-	pcie@14160000 {
-		status = "okay";
+		pcie@14160000 {
+			status = "okay";
 
-		vddio-pex-ctl-supply = <&vdd_1v8ao>;
+			vddio-pex-ctl-supply = <&vdd_1v8ao>;
 
-		phys = <&p2u_hsio_11>;
-		phy-names = "p2u-0";
-	};
+			phys = <&p2u_hsio_11>;
+			phy-names = "p2u-0";
+		};
 
-	pcie@141a0000 {
-		status = "okay";
+		pcie@141a0000 {
+			status = "okay";
 
-		vddio-pex-ctl-supply = <&vdd_1v8ao>;
+			vddio-pex-ctl-supply = <&vdd_1v8ao>;
 
-		phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
-		       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
-		       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
+			phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
+			       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
+			       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
 
-		phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
-			    "p2u-5", "p2u-6", "p2u-7";
-	};
+			phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
+				    "p2u-5", "p2u-6", "p2u-7";
+		};
 
-	pcie-ep@141a0000 {
-		status = "disabled";
+		pcie-ep@141a0000 {
+			status = "disabled";
 
-		vddio-pex-ctl-supply = <&vdd_1v8ao>;
+			vddio-pex-ctl-supply = <&vdd_1v8ao>;
 
-		reset-gpios = <&gpio TEGRA194_MAIN_GPIO(GG, 1) GPIO_ACTIVE_LOW>;
+			reset-gpios = <&gpio TEGRA194_MAIN_GPIO(GG, 1) GPIO_ACTIVE_LOW>;
 
-		nvidia,refclk-select-gpios = <&gpio_aon TEGRA194_AON_GPIO(AA, 5)
-					      GPIO_ACTIVE_HIGH>;
+			nvidia,refclk-select-gpios = <&gpio_aon TEGRA194_AON_GPIO(AA, 5)
+						      GPIO_ACTIVE_HIGH>;
 
-		phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
-		       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
-		       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
+			phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
+			       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
+			       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
 
-		phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
-			    "p2u-5", "p2u-6", "p2u-7";
+			phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
+				    "p2u-5", "p2u-6", "p2u-7";
+		};
 	};
 
 	fan: pwm-fan {
diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 4afcbd60e144e..b941b1c77713c 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -19,21 +19,22 @@ / {
 	/* control backbone */
 	bus@0 {
 		compatible = "simple-bus";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges = <0x0 0x0 0x0 0x40000000>;
+
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges = <0x0 0x0 0x0 0x0 0x0 0x40000000>;
 
 		apbmisc: misc@100000 {
 			compatible = "nvidia,tegra194-misc";
-			reg = <0x00100000 0xf000>,
-			      <0x0010f000 0x1000>;
+			reg = <0x0 0x00100000 0x0 0xf000>,
+			      <0x0 0x0010f000 0x0 0x1000>;
 		};
 
 		gpio: gpio@2200000 {
 			compatible = "nvidia,tegra194-gpio";
 			reg-names = "security", "gpio";
-			reg = <0x2200000 0x10000>,
-			      <0x2210000 0x10000>;
+			reg = <0x0 0x2200000 0x0 0x10000>,
+			      <0x0 0x2210000 0x0 0x10000>;
 			interrupts = <GIC_SPI 288 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 289 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 290 IRQ_TYPE_LEVEL_HIGH>,
@@ -91,7 +92,7 @@ gpio: gpio@2200000 {
 
 		cbb-noc@2300000 {
 			compatible = "nvidia,tegra194-cbb-noc";
-			reg = <0x02300000 0x1000>;
+			reg = <0x0 0x02300000 0x0 0x1000>;
 			interrupts = <GIC_SPI 230 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 231 IRQ_TYPE_LEVEL_HIGH>;
 			nvidia,axi2apb = <&axi2apb>;
@@ -101,12 +102,12 @@ cbb-noc@2300000 {
 
 		axi2apb: axi2apb@2390000 {
 			compatible = "nvidia,tegra194-axi2apb";
-			reg = <0x2390000 0x1000>,
-			      <0x23a0000 0x1000>,
-			      <0x23b0000 0x1000>,
-			      <0x23c0000 0x1000>,
-			      <0x23d0000 0x1000>,
-			      <0x23e0000 0x1000>;
+			reg = <0x0 0x2390000 0x0 0x1000>,
+			      <0x0 0x23a0000 0x0 0x1000>,
+			      <0x0 0x23b0000 0x0 0x1000>,
+			      <0x0 0x23c0000 0x0 0x1000>,
+			      <0x0 0x23d0000 0x0 0x1000>,
+			      <0x0 0x23e0000 0x0 0x1000>;
 			status = "okay";
 		};
 
@@ -114,7 +115,7 @@ ethernet@2490000 {
 			compatible = "nvidia,tegra194-eqos",
 				     "nvidia,tegra186-eqos",
 				     "snps,dwc-qos-ethernet-4.10";
-			reg = <0x02490000 0x10000>;
+			reg = <0x0 0x02490000 0x0 0x10000>;
 			interrupts = <GIC_SPI 194 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_AXI_CBB>,
 				 <&bpmp TEGRA194_CLK_EQOS_AXI>,
@@ -140,7 +141,7 @@ ethernet@2490000 {
 		gpcdma: dma-controller@2600000 {
 			compatible = "nvidia,tegra194-gpcdma",
 				     "nvidia,tegra186-gpcdma";
-			reg = <0x2600000 0x210000>;
+			reg = <0x0 0x2600000 0x0 0x210000>;
 			resets = <&bpmp TEGRA194_RESET_GPCDMA>;
 			reset-names = "gpcdma";
 			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>,
@@ -189,15 +190,16 @@ aconnect@2900000 {
 				 <&bpmp TEGRA194_CLK_APB2APE>;
 			clock-names = "ape", "apb2ape";
 			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_AUD>;
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0x02900000 0x02900000 0x200000>;
 			status = "disabled";
 
+			#address-cells = <2>;
+			#size-cells = <2>;
+			ranges = <0x0 0x02900000 0x0 0x02900000 0x0 0x200000>;
+
 			adma: dma-controller@2930000 {
 				compatible = "nvidia,tegra194-adma",
 					     "nvidia,tegra186-adma";
-				reg = <0x02930000 0x20000>;
+				reg = <0x0 0x02930000 0x0 0x20000>;
 				interrupt-parent = <&agic>;
 				interrupts =  <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
 					      <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
@@ -242,8 +244,8 @@ agic: interrupt-controller@2a40000 {
 					     "nvidia,tegra210-agic";
 				#interrupt-cells = <3>;
 				interrupt-controller;
-				reg = <0x02a41000 0x1000>,
-				      <0x02a42000 0x2000>;
+				reg = <0x0 0x02a41000 0x0 0x1000>,
+				      <0x0 0x02a42000 0x0 0x2000>;
 				interrupts = <GIC_SPI 145
 					      (GIC_CPU_MASK_SIMPLE(4) |
 					       IRQ_TYPE_LEVEL_HIGH)>;
@@ -255,20 +257,21 @@ agic: interrupt-controller@2a40000 {
 			tegra_ahub: ahub@2900800 {
 				compatible = "nvidia,tegra194-ahub",
 					     "nvidia,tegra186-ahub";
-				reg = <0x02900800 0x800>;
+				reg = <0x0 0x02900800 0x0 0x800>;
 				clocks = <&bpmp TEGRA194_CLK_AHUB>;
 				clock-names = "ahub";
 				assigned-clocks = <&bpmp TEGRA194_CLK_AHUB>;
 				assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
-				#address-cells = <1>;
-				#size-cells = <1>;
-				ranges = <0x02900800 0x02900800 0x11800>;
 				status = "disabled";
 
+				#address-cells = <2>;
+				#size-cells = <2>;
+				ranges = <0x0 0x02900800 0x0 0x02900800 0x0 0x11800>;
+
 				tegra_admaif: admaif@290f000 {
 					compatible = "nvidia,tegra194-admaif",
 						     "nvidia,tegra186-admaif";
-					reg = <0x0290f000 0x1000>;
+					reg = <0x0 0x0290f000 0x0 0x1000>;
 					dmas = <&adma 1>, <&adma 1>,
 					       <&adma 2>, <&adma 2>,
 					       <&adma 3>, <&adma 3>,
@@ -319,7 +322,7 @@ tegra_admaif: admaif@290f000 {
 				tegra_i2s1: i2s@2901000 {
 					compatible = "nvidia,tegra194-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901000 0x100>;
+					reg = <0x0 0x2901000 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_I2S1>,
 						 <&bpmp TEGRA194_CLK_I2S1_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -333,7 +336,7 @@ tegra_i2s1: i2s@2901000 {
 				tegra_i2s2: i2s@2901100 {
 					compatible = "nvidia,tegra194-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901100 0x100>;
+					reg = <0x0 0x2901100 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_I2S2>,
 						 <&bpmp TEGRA194_CLK_I2S2_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -347,7 +350,7 @@ tegra_i2s2: i2s@2901100 {
 				tegra_i2s3: i2s@2901200 {
 					compatible = "nvidia,tegra194-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901200 0x100>;
+					reg = <0x0 0x2901200 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_I2S3>,
 						 <&bpmp TEGRA194_CLK_I2S3_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -361,7 +364,7 @@ tegra_i2s3: i2s@2901200 {
 				tegra_i2s4: i2s@2901300 {
 					compatible = "nvidia,tegra194-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901300 0x100>;
+					reg = <0x0 0x2901300 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_I2S4>,
 						 <&bpmp TEGRA194_CLK_I2S4_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -375,7 +378,7 @@ tegra_i2s4: i2s@2901300 {
 				tegra_i2s5: i2s@2901400 {
 					compatible = "nvidia,tegra194-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901400 0x100>;
+					reg = <0x0 0x2901400 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_I2S5>,
 						 <&bpmp TEGRA194_CLK_I2S5_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -389,7 +392,7 @@ tegra_i2s5: i2s@2901400 {
 				tegra_i2s6: i2s@2901500 {
 					compatible = "nvidia,tegra194-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901500 0x100>;
+					reg = <0x0 0x2901500 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_I2S6>,
 						 <&bpmp TEGRA194_CLK_I2S6_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -403,7 +406,7 @@ tegra_i2s6: i2s@2901500 {
 				tegra_dmic1: dmic@2904000 {
 					compatible = "nvidia,tegra194-dmic",
 						     "nvidia,tegra210-dmic";
-					reg = <0x2904000 0x100>;
+					reg = <0x0 0x2904000 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_DMIC1>;
 					clock-names = "dmic";
 					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC1>;
@@ -416,7 +419,7 @@ tegra_dmic1: dmic@2904000 {
 				tegra_dmic2: dmic@2904100 {
 					compatible = "nvidia,tegra194-dmic",
 						     "nvidia,tegra210-dmic";
-					reg = <0x2904100 0x100>;
+					reg = <0x0 0x2904100 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_DMIC2>;
 					clock-names = "dmic";
 					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC2>;
@@ -429,7 +432,7 @@ tegra_dmic2: dmic@2904100 {
 				tegra_dmic3: dmic@2904200 {
 					compatible = "nvidia,tegra194-dmic",
 						     "nvidia,tegra210-dmic";
-					reg = <0x2904200 0x100>;
+					reg = <0x0 0x2904200 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_DMIC3>;
 					clock-names = "dmic";
 					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC3>;
@@ -442,7 +445,7 @@ tegra_dmic3: dmic@2904200 {
 				tegra_dmic4: dmic@2904300 {
 					compatible = "nvidia,tegra194-dmic",
 						     "nvidia,tegra210-dmic";
-					reg = <0x2904300 0x100>;
+					reg = <0x0 0x2904300 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_DMIC4>;
 					clock-names = "dmic";
 					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC4>;
@@ -455,7 +458,7 @@ tegra_dmic4: dmic@2904300 {
 				tegra_dspk1: dspk@2905000 {
 					compatible = "nvidia,tegra194-dspk",
 						     "nvidia,tegra186-dspk";
-					reg = <0x2905000 0x100>;
+					reg = <0x0 0x2905000 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_DSPK1>;
 					clock-names = "dspk";
 					assigned-clocks = <&bpmp TEGRA194_CLK_DSPK1>;
@@ -468,7 +471,7 @@ tegra_dspk1: dspk@2905000 {
 				tegra_dspk2: dspk@2905100 {
 					compatible = "nvidia,tegra194-dspk",
 						     "nvidia,tegra186-dspk";
-					reg = <0x2905100 0x100>;
+					reg = <0x0 0x2905100 0x0 0x100>;
 					clocks = <&bpmp TEGRA194_CLK_DSPK2>;
 					clock-names = "dspk";
 					assigned-clocks = <&bpmp TEGRA194_CLK_DSPK2>;
@@ -481,7 +484,7 @@ tegra_dspk2: dspk@2905100 {
 				tegra_sfc1: sfc@2902000 {
 					compatible = "nvidia,tegra194-sfc",
 						     "nvidia,tegra210-sfc";
-					reg = <0x2902000 0x200>;
+					reg = <0x0 0x2902000 0x0 0x200>;
 					sound-name-prefix = "SFC1";
 					status = "disabled";
 				};
@@ -489,7 +492,7 @@ tegra_sfc1: sfc@2902000 {
 				tegra_sfc2: sfc@2902200 {
 					compatible = "nvidia,tegra194-sfc",
 						     "nvidia,tegra210-sfc";
-					reg = <0x2902200 0x200>;
+					reg = <0x0 0x2902200 0x0 0x200>;
 					sound-name-prefix = "SFC2";
 					status = "disabled";
 				};
@@ -497,7 +500,7 @@ tegra_sfc2: sfc@2902200 {
 				tegra_sfc3: sfc@2902400 {
 					compatible = "nvidia,tegra194-sfc",
 						     "nvidia,tegra210-sfc";
-					reg = <0x2902400 0x200>;
+					reg = <0x0 0x2902400 0x0 0x200>;
 					sound-name-prefix = "SFC3";
 					status = "disabled";
 				};
@@ -505,7 +508,7 @@ tegra_sfc3: sfc@2902400 {
 				tegra_sfc4: sfc@2902600 {
 					compatible = "nvidia,tegra194-sfc",
 						     "nvidia,tegra210-sfc";
-					reg = <0x2902600 0x200>;
+					reg = <0x0 0x2902600 0x0 0x200>;
 					sound-name-prefix = "SFC4";
 					status = "disabled";
 				};
@@ -513,7 +516,7 @@ tegra_sfc4: sfc@2902600 {
 				tegra_mvc1: mvc@290a000 {
 					compatible = "nvidia,tegra194-mvc",
 						     "nvidia,tegra210-mvc";
-					reg = <0x290a000 0x200>;
+					reg = <0x0 0x290a000 0x0 0x200>;
 					sound-name-prefix = "MVC1";
 					status = "disabled";
 				};
@@ -521,35 +524,35 @@ tegra_mvc1: mvc@290a000 {
 				tegra_mvc2: mvc@290a200 {
 					compatible = "nvidia,tegra194-mvc",
 						     "nvidia,tegra210-mvc";
-					reg = <0x290a200 0x200>;
+					reg = <0x0 0x290a200 0x0 0x200>;
 					sound-name-prefix = "MVC2";
 					status = "disabled";
 				};
 
 				tegra_amx1: amx@2903000 {
 					compatible = "nvidia,tegra194-amx";
-					reg = <0x2903000 0x100>;
+					reg = <0x0 0x2903000 0x0 0x100>;
 					sound-name-prefix = "AMX1";
 					status = "disabled";
 				};
 
 				tegra_amx2: amx@2903100 {
 					compatible = "nvidia,tegra194-amx";
-					reg = <0x2903100 0x100>;
+					reg = <0x0 0x2903100 0x0 0x100>;
 					sound-name-prefix = "AMX2";
 					status = "disabled";
 				};
 
 				tegra_amx3: amx@2903200 {
 					compatible = "nvidia,tegra194-amx";
-					reg = <0x2903200 0x100>;
+					reg = <0x0 0x2903200 0x0 0x100>;
 					sound-name-prefix = "AMX3";
 					status = "disabled";
 				};
 
 				tegra_amx4: amx@2903300 {
 					compatible = "nvidia,tegra194-amx";
-					reg = <0x2903300 0x100>;
+					reg = <0x0 0x2903300 0x0 0x100>;
 					sound-name-prefix = "AMX4";
 					status = "disabled";
 				};
@@ -557,7 +560,7 @@ tegra_amx4: amx@2903300 {
 				tegra_adx1: adx@2903800 {
 					compatible = "nvidia,tegra194-adx",
 						     "nvidia,tegra210-adx";
-					reg = <0x2903800 0x100>;
+					reg = <0x0 0x2903800 0x0 0x100>;
 					sound-name-prefix = "ADX1";
 					status = "disabled";
 				};
@@ -565,7 +568,7 @@ tegra_adx1: adx@2903800 {
 				tegra_adx2: adx@2903900 {
 					compatible = "nvidia,tegra194-adx",
 						     "nvidia,tegra210-adx";
-					reg = <0x2903900 0x100>;
+					reg = <0x0 0x2903900 0x0 0x100>;
 					sound-name-prefix = "ADX2";
 					status = "disabled";
 				};
@@ -573,7 +576,7 @@ tegra_adx2: adx@2903900 {
 				tegra_adx3: adx@2903a00 {
 					compatible = "nvidia,tegra194-adx",
 						     "nvidia,tegra210-adx";
-					reg = <0x2903a00 0x100>;
+					reg = <0x0 0x2903a00 0x0 0x100>;
 					sound-name-prefix = "ADX3";
 					status = "disabled";
 				};
@@ -581,7 +584,7 @@ tegra_adx3: adx@2903a00 {
 				tegra_adx4: adx@2903b00 {
 					compatible = "nvidia,tegra194-adx",
 						     "nvidia,tegra210-adx";
-					reg = <0x2903b00 0x100>;
+					reg = <0x0 0x2903b00 0x0 0x100>;
 					sound-name-prefix = "ADX4";
 					status = "disabled";
 				};
@@ -589,30 +592,31 @@ tegra_adx4: adx@2903b00 {
 				tegra_ope1: processing-engine@2908000 {
 					compatible = "nvidia,tegra194-ope",
 						     "nvidia,tegra210-ope";
-					reg = <0x2908000 0x100>;
-					#address-cells = <1>;
-					#size-cells = <1>;
-					ranges;
+					reg = <0x0 0x2908000 0x0 0x100>;
 					sound-name-prefix = "OPE1";
 					status = "disabled";
 
+					#address-cells = <2>;
+					#size-cells = <2>;
+					ranges;
+
 					equalizer@2908100 {
 						compatible = "nvidia,tegra194-peq",
 							     "nvidia,tegra210-peq";
-						reg = <0x2908100 0x100>;
+						reg = <0x0 0x2908100 0x0 0x100>;
 					};
 
 					dynamic-range-compressor@2908200 {
 						compatible = "nvidia,tegra194-mbdrc",
 							     "nvidia,tegra210-mbdrc";
-						reg = <0x2908200 0x200>;
+						reg = <0x0 0x2908200 0x0 0x200>;
 					};
 				};
 
 				tegra_amixer: amixer@290bb00 {
 					compatible = "nvidia,tegra194-amixer",
 						     "nvidia,tegra210-amixer";
-					reg = <0x290bb00 0x800>;
+					reg = <0x0 0x290bb00 0x0 0x800>;
 					sound-name-prefix = "MIXER1";
 					status = "disabled";
 				};
@@ -620,7 +624,7 @@ tegra_amixer: amixer@290bb00 {
 				tegra_asrc: asrc@2910000 {
 					compatible = "nvidia,tegra194-asrc",
 						     "nvidia,tegra186-asrc";
-					reg = <0x2910000 0x2000>;
+					reg = <0x0 0x2910000 0x0 0x2000>;
 					sound-name-prefix = "ASRC1";
 					status = "disabled";
 				};
@@ -629,7 +633,7 @@ tegra_asrc: asrc@2910000 {
 
 		pinmux: pinmux@2430000 {
 			compatible = "nvidia,tegra194-pinmux";
-			reg = <0x2430000 0x17000>;
+			reg = <0x0 0x2430000 0x0 0x17000>;
 			status = "okay";
 
 			pex_rst_c5_out_state: pinmux-pex-rst-c5-out {
@@ -657,24 +661,24 @@ clkreq {
 
 		mc: memory-controller@2c00000 {
 			compatible = "nvidia,tegra194-mc";
-			reg = <0x02c00000 0x10000>,   /* MC-SID */
-			      <0x02c10000 0x10000>,   /* MC Broadcast*/
-			      <0x02c20000 0x10000>,   /* MC0 */
-			      <0x02c30000 0x10000>,   /* MC1 */
-			      <0x02c40000 0x10000>,   /* MC2 */
-			      <0x02c50000 0x10000>,   /* MC3 */
-			      <0x02b80000 0x10000>,   /* MC4 */
-			      <0x02b90000 0x10000>,   /* MC5 */
-			      <0x02ba0000 0x10000>,   /* MC6 */
-			      <0x02bb0000 0x10000>,   /* MC7 */
-			      <0x01700000 0x10000>,   /* MC8 */
-			      <0x01710000 0x10000>,   /* MC9 */
-			      <0x01720000 0x10000>,   /* MC10 */
-			      <0x01730000 0x10000>,   /* MC11 */
-			      <0x01740000 0x10000>,   /* MC12 */
-			      <0x01750000 0x10000>,   /* MC13 */
-			      <0x01760000 0x10000>,   /* MC14 */
-			      <0x01770000 0x10000>;   /* MC15 */
+			reg = <0x0 0x02c00000 0x0 0x10000>,   /* MC-SID */
+			      <0x0 0x02c10000 0x0 0x10000>,   /* MC Broadcast*/
+			      <0x0 0x02c20000 0x0 0x10000>,   /* MC0 */
+			      <0x0 0x02c30000 0x0 0x10000>,   /* MC1 */
+			      <0x0 0x02c40000 0x0 0x10000>,   /* MC2 */
+			      <0x0 0x02c50000 0x0 0x10000>,   /* MC3 */
+			      <0x0 0x02b80000 0x0 0x10000>,   /* MC4 */
+			      <0x0 0x02b90000 0x0 0x10000>,   /* MC5 */
+			      <0x0 0x02ba0000 0x0 0x10000>,   /* MC6 */
+			      <0x0 0x02bb0000 0x0 0x10000>,   /* MC7 */
+			      <0x0 0x01700000 0x0 0x10000>,   /* MC8 */
+			      <0x0 0x01710000 0x0 0x10000>,   /* MC9 */
+			      <0x0 0x01720000 0x0 0x10000>,   /* MC10 */
+			      <0x0 0x01730000 0x0 0x10000>,   /* MC11 */
+			      <0x0 0x01740000 0x0 0x10000>,   /* MC12 */
+			      <0x0 0x01750000 0x0 0x10000>,   /* MC13 */
+			      <0x0 0x01760000 0x0 0x10000>,   /* MC14 */
+			      <0x0 0x01770000 0x0 0x10000>;   /* MC15 */
 			reg-names = "sid", "broadcast", "ch0", "ch1", "ch2", "ch3",
 				    "ch4", "ch5", "ch6", "ch7", "ch8", "ch9", "ch10",
 				    "ch11", "ch12", "ch13", "ch14", "ch15";
@@ -684,10 +688,9 @@ mc: memory-controller@2c00000 {
 
 			#address-cells = <2>;
 			#size-cells = <2>;
-
-			ranges = <0x01700000 0x0 0x01700000 0x0 0x100000>,
-				 <0x02b80000 0x0 0x02b80000 0x0 0x040000>,
-				 <0x02c00000 0x0 0x02c00000 0x0 0x100000>;
+			ranges = <0x0 0x01700000 0x0 0x01700000 0x0 0x100000>,
+				 <0x0 0x02b80000 0x0 0x02b80000 0x0 0x040000>,
+				 <0x0 0x02c00000 0x0 0x02c00000 0x0 0x100000>;
 
 			/*
 			 * Bit 39 of addresses passing through the memory
@@ -704,7 +707,7 @@ mc: memory-controller@2c00000 {
 			 *
 			 * Limit the DMA range for memory clients to [38:0].
 			 */
-			dma-ranges = <0x0 0x0 0x0 0x80 0x0>;
+			dma-ranges = <0x0 0x0 0x0 0x0 0x80 0x0>;
 
 			emc: external-memory-controller@2c60000 {
 				compatible = "nvidia,tegra194-emc";
@@ -722,7 +725,7 @@ emc: external-memory-controller@2c60000 {
 
 		timer@3010000 {
 			compatible = "nvidia,tegra186-timer";
-			reg = <0x03010000 0x000e0000>;
+			reg = <0x0 0x03010000 0x0 0x000e0000>;
 			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
@@ -738,7 +741,7 @@ timer@3010000 {
 
 		uarta: serial@3100000 {
 			compatible = "nvidia,tegra194-uart", "nvidia,tegra20-uart";
-			reg = <0x03100000 0x40>;
+			reg = <0x0 0x03100000 0x0 0x40>;
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTA>;
@@ -750,7 +753,7 @@ uarta: serial@3100000 {
 
 		uartb: serial@3110000 {
 			compatible = "nvidia,tegra194-uart", "nvidia,tegra20-uart";
-			reg = <0x03110000 0x40>;
+			reg = <0x0 0x03110000 0x0 0x40>;
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTB>;
@@ -762,7 +765,7 @@ uartb: serial@3110000 {
 
 		uartd: serial@3130000 {
 			compatible = "nvidia,tegra194-uart", "nvidia,tegra20-uart";
-			reg = <0x03130000 0x40>;
+			reg = <0x0 0x03130000 0x0 0x40>;
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTD>;
@@ -774,7 +777,7 @@ uartd: serial@3130000 {
 
 		uarte: serial@3140000 {
 			compatible = "nvidia,tegra194-uart", "nvidia,tegra20-uart";
-			reg = <0x03140000 0x40>;
+			reg = <0x0 0x03140000 0x0 0x40>;
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTE>;
@@ -786,7 +789,7 @@ uarte: serial@3140000 {
 
 		uartf: serial@3150000 {
 			compatible = "nvidia,tegra194-uart", "nvidia,tegra20-uart";
-			reg = <0x03150000 0x40>;
+			reg = <0x0 0x03150000 0x0 0x40>;
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTF>;
@@ -798,7 +801,7 @@ uartf: serial@3150000 {
 
 		gen1_i2c: i2c@3160000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x03160000 0x10000>;
+			reg = <0x0 0x03160000 0x0 0x10000>;
 			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -815,7 +818,7 @@ gen1_i2c: i2c@3160000 {
 
 		uarth: serial@3170000 {
 			compatible = "nvidia,tegra194-uart", "nvidia,tegra20-uart";
-			reg = <0x03170000 0x40>;
+			reg = <0x0 0x03170000 0x0 0x40>;
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 207 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTH>;
@@ -827,7 +830,7 @@ uarth: serial@3170000 {
 
 		cam_i2c: i2c@3180000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x03180000 0x10000>;
+			reg = <0x0 0x03180000 0x0 0x10000>;
 			interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -845,7 +848,7 @@ cam_i2c: i2c@3180000 {
 		/* shares pads with dpaux1 */
 		dp_aux_ch1_i2c: i2c@3190000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x03190000 0x10000>;
+			reg = <0x0 0x03190000 0x0 0x10000>;
 			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -866,7 +869,7 @@ dp_aux_ch1_i2c: i2c@3190000 {
 		/* shares pads with dpaux0 */
 		dp_aux_ch0_i2c: i2c@31b0000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x031b0000 0x10000>;
+			reg = <0x0 0x031b0000 0x0 0x10000>;
 			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -887,7 +890,7 @@ dp_aux_ch0_i2c: i2c@31b0000 {
 		/* shares pads with dpaux2 */
 		dp_aux_ch2_i2c: i2c@31c0000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x031c0000 0x10000>;
+			reg = <0x0 0x031c0000 0x0 0x10000>;
 			interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -908,7 +911,7 @@ dp_aux_ch2_i2c: i2c@31c0000 {
 		/* shares pads with dpaux3 */
 		dp_aux_ch3_i2c: i2c@31e0000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x031e0000 0x10000>;
+			reg = <0x0 0x031e0000 0x0 0x10000>;
 			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -928,7 +931,7 @@ dp_aux_ch3_i2c: i2c@31e0000 {
 
 		spi@3270000 {
 			compatible = "nvidia,tegra194-qspi";
-			reg = <0x3270000 0x1000>;
+			reg = <0x0 0x3270000 0x0 0x1000>;
 			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -941,7 +944,7 @@ spi@3270000 {
 
 		spi@3300000 {
 			compatible = "nvidia,tegra194-qspi";
-			reg = <0x3300000 0x1000>;
+			reg = <0x0 0x3300000 0x0 0x1000>;
 			interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -955,7 +958,7 @@ spi@3300000 {
 		pwm1: pwm@3280000 {
 			compatible = "nvidia,tegra194-pwm",
 				     "nvidia,tegra186-pwm";
-			reg = <0x3280000 0x10000>;
+			reg = <0x0 0x3280000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA194_CLK_PWM1>;
 			resets = <&bpmp TEGRA194_RESET_PWM1>;
 			reset-names = "pwm";
@@ -966,7 +969,7 @@ pwm1: pwm@3280000 {
 		pwm2: pwm@3290000 {
 			compatible = "nvidia,tegra194-pwm",
 				     "nvidia,tegra186-pwm";
-			reg = <0x3290000 0x10000>;
+			reg = <0x0 0x3290000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA194_CLK_PWM2>;
 			resets = <&bpmp TEGRA194_RESET_PWM2>;
 			reset-names = "pwm";
@@ -977,7 +980,7 @@ pwm2: pwm@3290000 {
 		pwm3: pwm@32a0000 {
 			compatible = "nvidia,tegra194-pwm",
 				     "nvidia,tegra186-pwm";
-			reg = <0x32a0000 0x10000>;
+			reg = <0x0 0x32a0000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA194_CLK_PWM3>;
 			resets = <&bpmp TEGRA194_RESET_PWM3>;
 			reset-names = "pwm";
@@ -988,7 +991,7 @@ pwm3: pwm@32a0000 {
 		pwm5: pwm@32c0000 {
 			compatible = "nvidia,tegra194-pwm",
 				     "nvidia,tegra186-pwm";
-			reg = <0x32c0000 0x10000>;
+			reg = <0x0 0x32c0000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA194_CLK_PWM5>;
 			resets = <&bpmp TEGRA194_RESET_PWM5>;
 			reset-names = "pwm";
@@ -999,7 +1002,7 @@ pwm5: pwm@32c0000 {
 		pwm6: pwm@32d0000 {
 			compatible = "nvidia,tegra194-pwm",
 				     "nvidia,tegra186-pwm";
-			reg = <0x32d0000 0x10000>;
+			reg = <0x0 0x32d0000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA194_CLK_PWM6>;
 			resets = <&bpmp TEGRA194_RESET_PWM6>;
 			reset-names = "pwm";
@@ -1010,7 +1013,7 @@ pwm6: pwm@32d0000 {
 		pwm7: pwm@32e0000 {
 			compatible = "nvidia,tegra194-pwm",
 				     "nvidia,tegra186-pwm";
-			reg = <0x32e0000 0x10000>;
+			reg = <0x0 0x32e0000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA194_CLK_PWM7>;
 			resets = <&bpmp TEGRA194_RESET_PWM7>;
 			reset-names = "pwm";
@@ -1021,7 +1024,7 @@ pwm7: pwm@32e0000 {
 		pwm8: pwm@32f0000 {
 			compatible = "nvidia,tegra194-pwm",
 				     "nvidia,tegra186-pwm";
-			reg = <0x32f0000 0x10000>;
+			reg = <0x0 0x32f0000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA194_CLK_PWM8>;
 			resets = <&bpmp TEGRA194_RESET_PWM8>;
 			reset-names = "pwm";
@@ -1031,7 +1034,7 @@ pwm8: pwm@32f0000 {
 
 		sdmmc1: mmc@3400000 {
 			compatible = "nvidia,tegra194-sdhci";
-			reg = <0x03400000 0x10000>;
+			reg = <0x0 0x03400000 0x0 0x10000>;
 			interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_SDMMC1>,
 				 <&bpmp TEGRA194_CLK_SDMMC_LEGACY_TM>;
@@ -1070,7 +1073,7 @@ sdmmc1: mmc@3400000 {
 
 		sdmmc3: mmc@3440000 {
 			compatible = "nvidia,tegra194-sdhci";
-			reg = <0x03440000 0x10000>;
+			reg = <0x0 0x03440000 0x0 0x10000>;
 			interrupts = <GIC_SPI 64 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_SDMMC3>,
 				 <&bpmp TEGRA194_CLK_SDMMC_LEGACY_TM>;
@@ -1110,7 +1113,7 @@ sdmmc3: mmc@3440000 {
 
 		sdmmc4: mmc@3460000 {
 			compatible = "nvidia,tegra194-sdhci";
-			reg = <0x03460000 0x10000>;
+			reg = <0x0 0x03460000 0x0 0x10000>;
 			interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_SDMMC4>,
 				 <&bpmp TEGRA194_CLK_SDMMC_LEGACY_TM>;
@@ -1147,7 +1150,7 @@ sdmmc4: mmc@3460000 {
 
 		hda@3510000 {
 			compatible = "nvidia,tegra194-hda";
-			reg = <0x3510000 0x10000>;
+			reg = <0x0 0x3510000 0x0 0x10000>;
 			interrupts = <GIC_SPI 161 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_HDA>,
 				 <&bpmp TEGRA194_CLK_HDA2HDMICODEC>,
@@ -1166,8 +1169,8 @@ hda@3510000 {
 
 		xusb_padctl: padctl@3520000 {
 			compatible = "nvidia,tegra194-xusb-padctl";
-			reg = <0x03520000 0x1000>,
-			      <0x03540000 0x1000>;
+			reg = <0x0 0x03520000 0x0 0x1000>,
+			      <0x0 0x03540000 0x0 0x1000>;
 			reg-names = "padctl", "ao";
 			interrupts = <GIC_SPI 167 IRQ_TYPE_LEVEL_HIGH>;
 
@@ -1274,8 +1277,8 @@ usb3-3 {
 
 		usb@3550000 {
 			compatible = "nvidia,tegra194-xudc";
-			reg = <0x03550000 0x8000>,
-			      <0x03558000 0x1000>;
+			reg = <0x0 0x03550000 0x0 0x8000>,
+			      <0x0 0x03558000 0x0 0x1000>;
 			reg-names = "base", "fpci";
 			interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_XUSB_CORE_DEV>,
@@ -1296,8 +1299,8 @@ usb@3550000 {
 
 		usb@3610000 {
 			compatible = "nvidia,tegra194-xusb";
-			reg = <0x03610000 0x40000>,
-			      <0x03600000 0x10000>;
+			reg = <0x0 0x03610000 0x0 0x40000>,
+			      <0x0 0x03600000 0x0 0x10000>;
 			reg-names = "hcd", "fpci";
 
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>,
@@ -1331,7 +1334,7 @@ usb@3610000 {
 
 		fuse@3820000 {
 			compatible = "nvidia,tegra194-efuse";
-			reg = <0x03820000 0x10000>;
+			reg = <0x0 0x03820000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA194_CLK_FUSE>;
 			clock-names = "fuse";
 		};
@@ -1340,10 +1343,10 @@ gic: interrupt-controller@3881000 {
 			compatible = "arm,gic-400";
 			#interrupt-cells = <3>;
 			interrupt-controller;
-			reg = <0x03881000 0x1000>,
-			      <0x03882000 0x2000>,
-			      <0x03884000 0x2000>,
-			      <0x03886000 0x2000>;
+			reg = <0x0 0x03881000 0x0 0x1000>,
+			      <0x0 0x03882000 0x0 0x2000>,
+			      <0x0 0x03884000 0x0 0x2000>,
+			      <0x0 0x03886000 0x0 0x2000>;
 			interrupts = <GIC_PPI 9
 				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 			interrupt-parent = <&gic>;
@@ -1351,7 +1354,7 @@ gic: interrupt-controller@3881000 {
 
 		cec@3960000 {
 			compatible = "nvidia,tegra194-cec";
-			reg = <0x03960000 0x10000>;
+			reg = <0x0 0x03960000 0x0 0x10000>;
 			interrupts = <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_CEC>;
 			clock-names = "cec";
@@ -1360,7 +1363,7 @@ cec@3960000 {
 
 		hte_lic: hardware-timestamp@3aa0000 {
 			compatible = "nvidia,tegra194-gte-lic";
-			reg = <0x3aa0000 0x10000>;
+			reg = <0x0 0x3aa0000 0x0 0x10000>;
 			interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
 			nvidia,int-threshold = <1>;
 			nvidia,slices = <11>;
@@ -1370,7 +1373,7 @@ hte_lic: hardware-timestamp@3aa0000 {
 
 		hsp_top0: hsp@3c00000 {
 			compatible = "nvidia,tegra194-hsp";
-			reg = <0x03c00000 0xa0000>;
+			reg = <0x0 0x03c00000 0x0 0xa0000>;
 			interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>,
 			             <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
 			             <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
@@ -1388,7 +1391,7 @@ hsp_top0: hsp@3c00000 {
 
 		p2u_hsio_0: phy@3e10000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03e10000 0x10000>;
+			reg = <0x0 0x03e10000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1396,7 +1399,7 @@ p2u_hsio_0: phy@3e10000 {
 
 		p2u_hsio_1: phy@3e20000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03e20000 0x10000>;
+			reg = <0x0 0x03e20000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1404,7 +1407,7 @@ p2u_hsio_1: phy@3e20000 {
 
 		p2u_hsio_2: phy@3e30000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03e30000 0x10000>;
+			reg = <0x0 0x03e30000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1412,7 +1415,7 @@ p2u_hsio_2: phy@3e30000 {
 
 		p2u_hsio_3: phy@3e40000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03e40000 0x10000>;
+			reg = <0x0 0x03e40000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1420,7 +1423,7 @@ p2u_hsio_3: phy@3e40000 {
 
 		p2u_hsio_4: phy@3e50000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03e50000 0x10000>;
+			reg = <0x0 0x03e50000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1428,7 +1431,7 @@ p2u_hsio_4: phy@3e50000 {
 
 		p2u_hsio_5: phy@3e60000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03e60000 0x10000>;
+			reg = <0x0 0x03e60000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1436,7 +1439,7 @@ p2u_hsio_5: phy@3e60000 {
 
 		p2u_hsio_6: phy@3e70000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03e70000 0x10000>;
+			reg = <0x0 0x03e70000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1444,7 +1447,7 @@ p2u_hsio_6: phy@3e70000 {
 
 		p2u_hsio_7: phy@3e80000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03e80000 0x10000>;
+			reg = <0x0 0x03e80000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1452,7 +1455,7 @@ p2u_hsio_7: phy@3e80000 {
 
 		p2u_hsio_8: phy@3e90000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03e90000 0x10000>;
+			reg = <0x0 0x03e90000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1460,7 +1463,7 @@ p2u_hsio_8: phy@3e90000 {
 
 		p2u_hsio_9: phy@3ea0000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03ea0000 0x10000>;
+			reg = <0x0 0x03ea0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1468,7 +1471,7 @@ p2u_hsio_9: phy@3ea0000 {
 
 		p2u_nvhs_0: phy@3eb0000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03eb0000 0x10000>;
+			reg = <0x0 0x03eb0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1476,7 +1479,7 @@ p2u_nvhs_0: phy@3eb0000 {
 
 		p2u_nvhs_1: phy@3ec0000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03ec0000 0x10000>;
+			reg = <0x0 0x03ec0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1484,7 +1487,7 @@ p2u_nvhs_1: phy@3ec0000 {
 
 		p2u_nvhs_2: phy@3ed0000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03ed0000 0x10000>;
+			reg = <0x0 0x03ed0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1492,7 +1495,7 @@ p2u_nvhs_2: phy@3ed0000 {
 
 		p2u_nvhs_3: phy@3ee0000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03ee0000 0x10000>;
+			reg = <0x0 0x03ee0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1500,7 +1503,7 @@ p2u_nvhs_3: phy@3ee0000 {
 
 		p2u_nvhs_4: phy@3ef0000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03ef0000 0x10000>;
+			reg = <0x0 0x03ef0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1508,7 +1511,7 @@ p2u_nvhs_4: phy@3ef0000 {
 
 		p2u_nvhs_5: phy@3f00000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03f00000 0x10000>;
+			reg = <0x0 0x03f00000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1516,7 +1519,7 @@ p2u_nvhs_5: phy@3f00000 {
 
 		p2u_nvhs_6: phy@3f10000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03f10000 0x10000>;
+			reg = <0x0 0x03f10000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1524,7 +1527,7 @@ p2u_nvhs_6: phy@3f10000 {
 
 		p2u_nvhs_7: phy@3f20000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03f20000 0x10000>;
+			reg = <0x0 0x03f20000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1532,7 +1535,7 @@ p2u_nvhs_7: phy@3f20000 {
 
 		p2u_hsio_10: phy@3f30000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03f30000 0x10000>;
+			reg = <0x0 0x03f30000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1540,7 +1543,7 @@ p2u_hsio_10: phy@3f30000 {
 
 		p2u_hsio_11: phy@3f40000 {
 			compatible = "nvidia,tegra194-p2u";
-			reg = <0x03f40000 0x10000>;
+			reg = <0x0 0x03f40000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1548,7 +1551,7 @@ p2u_hsio_11: phy@3f40000 {
 
 		sce-noc@b600000 {
 			compatible = "nvidia,tegra194-sce-noc";
-			reg = <0xb600000 0x1000>;
+			reg = <0x0 0xb600000 0x0 0x1000>;
 			interrupts = <GIC_SPI 261 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>;
 			nvidia,axi2apb = <&axi2apb>;
@@ -1558,7 +1561,7 @@ sce-noc@b600000 {
 
 		rce-noc@be00000 {
 			compatible = "nvidia,tegra194-rce-noc";
-			reg = <0xbe00000 0x1000>;
+			reg = <0x0 0xbe00000 0x0 0x1000>;
 			interrupts = <GIC_SPI 259 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 175 IRQ_TYPE_LEVEL_HIGH>;
 			nvidia,axi2apb = <&axi2apb>;
@@ -1568,7 +1571,7 @@ rce-noc@be00000 {
 
 		hsp_aon: hsp@c150000 {
 			compatible = "nvidia,tegra194-hsp";
-			reg = <0x0c150000 0x90000>;
+			reg = <0x0 0x0c150000 0x0 0x90000>;
 			interrupts = <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>,
 			             <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>,
 			             <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>,
@@ -1583,7 +1586,7 @@ hsp_aon: hsp@c150000 {
 
 		hte_aon: hardware-timestamp@c1e0000 {
 			compatible = "nvidia,tegra194-gte-aon";
-			reg = <0xc1e0000 0x10000>;
+			reg = <0x0 0xc1e0000 0x0 0x10000>;
 			interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
 			nvidia,int-threshold = <1>;
 			nvidia,slices = <3>;
@@ -1593,7 +1596,7 @@ hte_aon: hardware-timestamp@c1e0000 {
 
 		gen2_i2c: i2c@c240000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x0c240000 0x10000>;
+			reg = <0x0 0x0c240000 0x0 0x10000>;
 			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -1610,7 +1613,7 @@ gen2_i2c: i2c@c240000 {
 
 		gen8_i2c: i2c@c250000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x0c250000 0x10000>;
+			reg = <0x0 0x0c250000 0x0 0x10000>;
 			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -1627,7 +1630,7 @@ gen8_i2c: i2c@c250000 {
 
 		uartc: serial@c280000 {
 			compatible = "nvidia,tegra194-uart", "nvidia,tegra20-uart";
-			reg = <0x0c280000 0x40>;
+			reg = <0x0 0x0c280000 0x0 0x40>;
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTC>;
@@ -1639,7 +1642,7 @@ uartc: serial@c280000 {
 
 		uartg: serial@c290000 {
 			compatible = "nvidia,tegra194-uart", "nvidia,tegra20-uart";
-			reg = <0x0c290000 0x40>;
+			reg = <0x0 0x0c290000 0x0 0x40>;
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTG>;
@@ -1651,7 +1654,7 @@ uartg: serial@c290000 {
 
 		rtc: rtc@c2a0000 {
 			compatible = "nvidia,tegra194-rtc", "nvidia,tegra20-rtc";
-			reg = <0x0c2a0000 0x10000>;
+			reg = <0x0 0x0c2a0000 0x0 0x10000>;
 			interrupt-parent = <&pmc>;
 			interrupts = <73 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_CLK_32K>;
@@ -1662,8 +1665,8 @@ rtc: rtc@c2a0000 {
 		gpio_aon: gpio@c2f0000 {
 			compatible = "nvidia,tegra194-gpio-aon";
 			reg-names = "security", "gpio";
-			reg = <0xc2f0000 0x1000>,
-			      <0xc2f1000 0x1000>;
+			reg = <0x0 0xc2f0000 0x0 0x1000>,
+			      <0x0 0xc2f1000 0x0 0x1000>;
 			interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>,
@@ -1677,7 +1680,7 @@ gpio_aon: gpio@c2f0000 {
 
 		pinmux_aon: pinmux@c300000 {
 			compatible = "nvidia,tegra194-pinmux-aon";
-			reg = <0xc300000 0x4000>;
+			reg = <0x0 0xc300000 0x0 0x4000>;
 
 			status = "okay";
 		};
@@ -1685,7 +1688,7 @@ pinmux_aon: pinmux@c300000 {
 		pwm4: pwm@c340000 {
 			compatible = "nvidia,tegra194-pwm",
 				     "nvidia,tegra186-pwm";
-			reg = <0xc340000 0x10000>;
+			reg = <0x0 0xc340000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA194_CLK_PWM4>;
 			resets = <&bpmp TEGRA194_RESET_PWM4>;
 			reset-names = "pwm";
@@ -1695,11 +1698,11 @@ pwm4: pwm@c340000 {
 
 		pmc: pmc@c360000 {
 			compatible = "nvidia,tegra194-pmc";
-			reg = <0x0c360000 0x10000>,
-			      <0x0c370000 0x10000>,
-			      <0x0c380000 0x10000>,
-			      <0x0c390000 0x10000>,
-			      <0x0c3a0000 0x10000>;
+			reg = <0x0 0x0c360000 0x0 0x10000>,
+			      <0x0 0x0c370000 0x0 0x10000>,
+			      <0x0 0x0c380000 0x0 0x10000>,
+			      <0x0 0x0c390000 0x0 0x10000>,
+			      <0x0 0x0c3a0000 0x0 0x10000>;
 			reg-names = "pmc", "wake", "aotag", "scratch", "misc";
 
 			#interrupt-cells = <2>;
@@ -1727,7 +1730,7 @@ sdmmc3_1v8: sdmmc3-1v8 {
 
 		aon-noc@c600000 {
 			compatible = "nvidia,tegra194-aon-noc";
-			reg = <0xc600000 0x1000>;
+			reg = <0x0 0xc600000 0x0 0x1000>;
 			interrupts = <GIC_SPI 260 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
 			nvidia,apbmisc = <&apbmisc>;
@@ -1736,7 +1739,7 @@ aon-noc@c600000 {
 
 		bpmp-noc@d600000 {
 			compatible = "nvidia,tegra194-bpmp-noc";
-			reg = <0xd600000 0x1000>;
+			reg = <0x0 0xd600000 0x0 0x1000>;
 			interrupts = <GIC_SPI 262 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>;
 			nvidia,axi2apb = <&axi2apb>;
@@ -1746,7 +1749,7 @@ bpmp-noc@d600000 {
 
 		iommu@10000000 {
 			compatible = "nvidia,tegra194-smmu", "nvidia,smmu-500";
-			reg = <0x10000000 0x800000>;
+			reg = <0x0 0x10000000 0x0 0x800000>;
 			interrupts = <GIC_SPI 240 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 240 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 240 IRQ_TYPE_LEVEL_HIGH>,
@@ -1822,8 +1825,8 @@ iommu@10000000 {
 
 		smmu: iommu@12000000 {
 			compatible = "nvidia,tegra194-smmu", "nvidia,smmu-500";
-			reg = <0x12000000 0x800000>,
-			      <0x11000000 0x800000>;
+			reg = <0x0 0x12000000 0x0 0x800000>,
+			      <0x0 0x11000000 0x0 0x800000>;
 			interrupts = <GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 232 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>,
@@ -1900,8 +1903,8 @@ smmu: iommu@12000000 {
 
 		host1x@13e00000 {
 			compatible = "nvidia,tegra194-host1x";
-			reg = <0x13e00000 0x10000>,
-			      <0x13e10000 0x10000>;
+			reg = <0x0 0x13e00000 0x0 0x10000>,
+			      <0x0 0x13e10000 0x0 0x10000>;
 			reg-names = "hypervisor", "vm";
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 263 IRQ_TYPE_LEVEL_HIGH>;
@@ -1911,10 +1914,10 @@ host1x@13e00000 {
 			resets = <&bpmp TEGRA194_RESET_HOST1X>;
 			reset-names = "host1x";
 
-			#address-cells = <1>;
-			#size-cells = <1>;
+			#address-cells = <2>;
+			#size-cells = <2>;
+			ranges = <0x0 0x14800000 0x0 0x14800000 0x0 0x02800000>;
 
-			ranges = <0x14800000 0x14800000 0x02800000>;
 			interconnects = <&mc TEGRA194_MEMORY_CLIENT_HOST1XDMAR &emc>;
 			interconnect-names = "dma-mem";
 			iommus = <&smmu TEGRA194_SID_HOST1X>;
@@ -1931,7 +1934,7 @@ host1x@13e00000 {
 
 			nvdec@15140000 {
 				compatible = "nvidia,tegra194-nvdec";
-				reg = <0x15140000 0x00040000>;
+				reg = <0x0 0x15140000 0x0 0x00040000>;
 				clocks = <&bpmp TEGRA194_CLK_NVDEC1>;
 				clock-names = "nvdec";
 				resets = <&bpmp TEGRA194_RESET_NVDEC1>;
@@ -1950,7 +1953,7 @@ nvdec@15140000 {
 
 			display-hub@15200000 {
 				compatible = "nvidia,tegra194-display";
-				reg = <0x15200000 0x00040000>;
+				reg = <0x0 0x15200000 0x0 0x00040000>;
 				resets = <&bpmp TEGRA194_RESET_NVDISPLAY0_MISC>,
 					 <&bpmp TEGRA194_RESET_NVDISPLAY0_WGRP0>,
 					 <&bpmp TEGRA194_RESET_NVDISPLAY0_WGRP1>,
@@ -1967,14 +1970,13 @@ display-hub@15200000 {
 
 				power-domains = <&bpmp TEGRA194_POWER_DOMAIN_DISP>;
 
-				#address-cells = <1>;
-				#size-cells = <1>;
-
-				ranges = <0x15200000 0x15200000 0x40000>;
+				#address-cells = <2>;
+				#size-cells = <2>;
+				ranges = <0x0 0x15200000 0x0 0x15200000 0x0 0x40000>;
 
 				display@15200000 {
 					compatible = "nvidia,tegra194-dc";
-					reg = <0x15200000 0x10000>;
+					reg = <0x0 0x15200000 0x0 0x10000>;
 					interrupts = <GIC_SPI 153 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&bpmp TEGRA194_CLK_NVDISPLAY_P0>;
 					clock-names = "dc";
@@ -1992,7 +1994,7 @@ display@15200000 {
 
 				display@15210000 {
 					compatible = "nvidia,tegra194-dc";
-					reg = <0x15210000 0x10000>;
+					reg = <0x0 0x15210000 0x0 0x10000>;
 					interrupts = <GIC_SPI 154 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&bpmp TEGRA194_CLK_NVDISPLAY_P1>;
 					clock-names = "dc";
@@ -2010,7 +2012,7 @@ display@15210000 {
 
 				display@15220000 {
 					compatible = "nvidia,tegra194-dc";
-					reg = <0x15220000 0x10000>;
+					reg = <0x0 0x15220000 0x0 0x10000>;
 					interrupts = <GIC_SPI 155 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&bpmp TEGRA194_CLK_NVDISPLAY_P2>;
 					clock-names = "dc";
@@ -2028,7 +2030,7 @@ display@15220000 {
 
 				display@15230000 {
 					compatible = "nvidia,tegra194-dc";
-					reg = <0x15230000 0x10000>;
+					reg = <0x0 0x15230000 0x0 0x10000>;
 					interrupts = <GIC_SPI 242 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&bpmp TEGRA194_CLK_NVDISPLAY_P3>;
 					clock-names = "dc";
@@ -2047,7 +2049,7 @@ display@15230000 {
 
 			vic@15340000 {
 				compatible = "nvidia,tegra194-vic";
-				reg = <0x15340000 0x00040000>;
+				reg = <0x0 0x15340000 0x0 0x00040000>;
 				interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&bpmp TEGRA194_CLK_VIC>;
 				clock-names = "vic";
@@ -2064,7 +2066,7 @@ vic@15340000 {
 
 			nvjpg@15380000 {
 				compatible = "nvidia,tegra194-nvjpg";
-				reg = <0x15380000 0x40000>;
+				reg = <0x0 0x15380000 0x0 0x40000>;
 				clocks = <&bpmp TEGRA194_CLK_NVJPG>;
 				clock-names = "nvjpg";
 				resets = <&bpmp TEGRA194_RESET_NVJPG>;
@@ -2080,7 +2082,7 @@ nvjpg@15380000 {
 
 			nvdec@15480000 {
 				compatible = "nvidia,tegra194-nvdec";
-				reg = <0x15480000 0x00040000>;
+				reg = <0x0 0x15480000 0x0 0x00040000>;
 				clocks = <&bpmp TEGRA194_CLK_NVDEC>;
 				clock-names = "nvdec";
 				resets = <&bpmp TEGRA194_RESET_NVDEC>;
@@ -2099,7 +2101,7 @@ nvdec@15480000 {
 
 			nvenc@154c0000 {
 				compatible = "nvidia,tegra194-nvenc";
-				reg = <0x154c0000 0x40000>;
+				reg = <0x0 0x154c0000 0x0 0x40000>;
 				clocks = <&bpmp TEGRA194_CLK_NVENC>;
 				clock-names = "nvenc";
 				resets = <&bpmp TEGRA194_RESET_NVENC>;
@@ -2118,7 +2120,7 @@ nvenc@154c0000 {
 
 			dpaux0: dpaux@155c0000 {
 				compatible = "nvidia,tegra194-dpaux";
-				reg = <0x155c0000 0x10000>;
+				reg = <0x0 0x155c0000 0x0 0x10000>;
 				interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&bpmp TEGRA194_CLK_DPAUX>,
 					 <&bpmp TEGRA194_CLK_PLLDP>;
@@ -2152,7 +2154,7 @@ i2c-bus {
 
 			dpaux1: dpaux@155d0000 {
 				compatible = "nvidia,tegra194-dpaux";
-				reg = <0x155d0000 0x10000>;
+				reg = <0x0 0x155d0000 0x0 0x10000>;
 				interrupts = <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&bpmp TEGRA194_CLK_DPAUX1>,
 					 <&bpmp TEGRA194_CLK_PLLDP>;
@@ -2186,7 +2188,7 @@ i2c-bus {
 
 			dpaux2: dpaux@155e0000 {
 				compatible = "nvidia,tegra194-dpaux";
-				reg = <0x155e0000 0x10000>;
+				reg = <0x0 0x155e0000 0x0 0x10000>;
 				interrupts = <GIC_SPI 245 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&bpmp TEGRA194_CLK_DPAUX2>,
 					 <&bpmp TEGRA194_CLK_PLLDP>;
@@ -2220,7 +2222,7 @@ i2c-bus {
 
 			dpaux3: dpaux@155f0000 {
 				compatible = "nvidia,tegra194-dpaux";
-				reg = <0x155f0000 0x10000>;
+				reg = <0x0 0x155f0000 0x0 0x10000>;
 				interrupts = <GIC_SPI 246 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&bpmp TEGRA194_CLK_DPAUX3>,
 					 <&bpmp TEGRA194_CLK_PLLDP>;
@@ -2254,7 +2256,7 @@ i2c-bus {
 
 			nvenc@15a80000 {
 				compatible = "nvidia,tegra194-nvenc";
-				reg = <0x15a80000 0x00040000>;
+				reg = <0x0 0x15a80000 0x0 0x00040000>;
 				clocks = <&bpmp TEGRA194_CLK_NVENC1>;
 				clock-names = "nvenc";
 				resets = <&bpmp TEGRA194_RESET_NVENC1>;
@@ -2273,7 +2275,7 @@ nvenc@15a80000 {
 
 			sor0: sor@15b00000 {
 				compatible = "nvidia,tegra194-sor";
-				reg = <0x15b00000 0x40000>;
+				reg = <0x0 0x15b00000 0x0 0x40000>;
 				interrupts = <GIC_SPI 157 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&bpmp TEGRA194_CLK_SOR0_REF>,
 					 <&bpmp TEGRA194_CLK_SOR0_OUT>,
@@ -2297,7 +2299,7 @@ sor0: sor@15b00000 {
 
 			sor1: sor@15b40000 {
 				compatible = "nvidia,tegra194-sor";
-				reg = <0x15b40000 0x40000>;
+				reg = <0x0 0x15b40000 0x0 0x40000>;
 				interrupts = <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&bpmp TEGRA194_CLK_SOR1_REF>,
 					 <&bpmp TEGRA194_CLK_SOR1_OUT>,
@@ -2321,7 +2323,7 @@ sor1: sor@15b40000 {
 
 			sor2: sor@15b80000 {
 				compatible = "nvidia,tegra194-sor";
-				reg = <0x15b80000 0x40000>;
+				reg = <0x0 0x15b80000 0x0 0x40000>;
 				interrupts = <GIC_SPI 243 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&bpmp TEGRA194_CLK_SOR2_REF>,
 					 <&bpmp TEGRA194_CLK_SOR2_OUT>,
@@ -2345,7 +2347,7 @@ sor2: sor@15b80000 {
 
 			sor3: sor@15bc0000 {
 				compatible = "nvidia,tegra194-sor";
-				reg = <0x15bc0000 0x40000>;
+				reg = <0x0 0x15bc0000 0x0 0x40000>;
 				interrupts = <GIC_SPI 244 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&bpmp TEGRA194_CLK_SOR3_REF>,
 					 <&bpmp TEGRA194_CLK_SOR3_OUT>,
@@ -2368,482 +2370,484 @@ sor3: sor@15bc0000 {
 			};
 		};
 
-		gpu@17000000 {
-			compatible = "nvidia,gv11b";
-			reg = <0x17000000 0x1000000>,
-			      <0x18000000 0x1000000>;
-			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "stall", "nonstall";
-			clocks = <&bpmp TEGRA194_CLK_GPCCLK>,
-				 <&bpmp TEGRA194_CLK_GPU_PWR>,
-				 <&bpmp TEGRA194_CLK_FUSE>;
-			clock-names = "gpu", "pwr", "fuse";
-			resets = <&bpmp TEGRA194_RESET_GPU>;
-			reset-names = "gpu";
-			dma-coherent;
+		pcie@14100000 {
+			compatible = "nvidia,tegra194-pcie";
+			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
+			reg = <0x0 0x14100000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x0 0x30000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x0 0x30040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x0 0x30080000 0x0 0x00040000>; /* DBI reg space (256K)       */
+			reg-names = "appl", "config", "atu_dma", "dbi";
 
-			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_GPU>;
-			interconnects = <&mc TEGRA194_MEMORY_CLIENT_NVL1R &emc>,
-					<&mc TEGRA194_MEMORY_CLIENT_NVL1RHP &emc>,
-					<&mc TEGRA194_MEMORY_CLIENT_NVL1W &emc>,
-					<&mc TEGRA194_MEMORY_CLIENT_NVL2R &emc>,
-					<&mc TEGRA194_MEMORY_CLIENT_NVL2RHP &emc>,
-					<&mc TEGRA194_MEMORY_CLIENT_NVL2W &emc>,
-					<&mc TEGRA194_MEMORY_CLIENT_NVL3R &emc>,
-					<&mc TEGRA194_MEMORY_CLIENT_NVL3RHP &emc>,
-					<&mc TEGRA194_MEMORY_CLIENT_NVL3W &emc>,
-					<&mc TEGRA194_MEMORY_CLIENT_NVL4R &emc>,
-					<&mc TEGRA194_MEMORY_CLIENT_NVL4RHP &emc>,
-					<&mc TEGRA194_MEMORY_CLIENT_NVL4W &emc>;
-			interconnect-names = "dma-mem", "read-0-hp", "write-0",
-					     "read-1", "read-1-hp", "write-1",
-					     "read-2", "read-2-hp", "write-2",
-					     "read-3", "read-3-hp", "write-3";
-		};
-	};
+			status = "disabled";
 
-	pcie@14100000 {
-		compatible = "nvidia,tegra194-pcie";
-		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
-		reg = <0x00 0x14100000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x30000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x30040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x30080000 0x0 0x00040000>; /* DBI reg space (256K)       */
-		reg-names = "appl", "config", "atu_dma", "dbi";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <1>;
+			linux,pci-domain = <1>;
 
-		status = "disabled";
+			clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_1>;
+			clock-names = "core";
 
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <1>;
-		linux,pci-domain = <1>;
+			resets = <&bpmp TEGRA194_RESET_PEX0_CORE_1_APB>,
+				 <&bpmp TEGRA194_RESET_PEX0_CORE_1>;
+			reset-names = "apb", "core";
 
-		clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_1>;
-		clock-names = "core";
+			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		resets = <&bpmp TEGRA194_RESET_PEX0_CORE_1_APB>,
-			 <&bpmp TEGRA194_RESET_PEX0_CORE_1>;
-		reset-names = "apb", "core";
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
 
-		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			nvidia,bpmp = <&bpmp 1>;
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		nvidia,bpmp = <&bpmp 1>;
+			bus-range = <0x0 0xff>;
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			ranges = <0x43000000 0x12 0x00000000 0x12 0x00000000 0x0 0x30000000>, /* prefetchable memory (768 MiB) */
+				 <0x02000000 0x0  0x40000000 0x12 0x30000000 0x0 0x0fff0000>, /* non-prefetchable memory (256 MiB - 64 KiB) */
+				 <0x01000000 0x0  0x00000000 0x12 0x3fff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
 
-		bus-range = <0x0 0xff>;
+			interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE1R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_PCIE1W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu TEGRA194_SID_PCIE1 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
+		};
 
-		ranges = <0x43000000 0x12 0x00000000 0x12 0x00000000 0x0 0x30000000>, /* prefetchable memory (768 MiB) */
-			 <0x02000000 0x0  0x40000000 0x12 0x30000000 0x0 0x0fff0000>, /* non-prefetchable memory (256 MiB - 64 KiB) */
-			 <0x01000000 0x0  0x00000000 0x12 0x3fff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
+		pcie@14120000 {
+			compatible = "nvidia,tegra194-pcie";
+			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
+			reg = <0x00 0x14120000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x32000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x32040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x32080000 0x0 0x00040000>; /* DBI reg space (256K)       */
+			reg-names = "appl", "config", "atu_dma", "dbi";
 
-		interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE1R &emc>,
-				<&mc TEGRA194_MEMORY_CLIENT_PCIE1W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu TEGRA194_SID_PCIE1 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
-	};
+			status = "disabled";
 
-	pcie@14120000 {
-		compatible = "nvidia,tegra194-pcie";
-		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
-		reg = <0x00 0x14120000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x32000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x32040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x32080000 0x0 0x00040000>; /* DBI reg space (256K)       */
-		reg-names = "appl", "config", "atu_dma", "dbi";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <1>;
+			linux,pci-domain = <2>;
 
-		status = "disabled";
+			clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_2>;
+			clock-names = "core";
 
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <1>;
-		linux,pci-domain = <2>;
+			resets = <&bpmp TEGRA194_RESET_PEX0_CORE_2_APB>,
+				 <&bpmp TEGRA194_RESET_PEX0_CORE_2>;
+			reset-names = "apb", "core";
 
-		clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_2>;
-		clock-names = "core";
+			interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		resets = <&bpmp TEGRA194_RESET_PEX0_CORE_2_APB>,
-			 <&bpmp TEGRA194_RESET_PEX0_CORE_2>;
-		reset-names = "apb", "core";
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
 
-		interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			nvidia,bpmp = <&bpmp 2>;
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		nvidia,bpmp = <&bpmp 2>;
+			bus-range = <0x0 0xff>;
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			ranges = <0x43000000 0x12 0x40000000 0x12 0x40000000 0x0 0x30000000>, /* prefetchable memory (768 MiB) */
+				 <0x02000000 0x0  0x40000000 0x12 0x70000000 0x0 0x0fff0000>, /* non-prefetchable memory (256 MiB - 64 KiB) */
+				 <0x01000000 0x0  0x00000000 0x12 0x7fff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
 
-		bus-range = <0x0 0xff>;
+			interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE2AR &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_PCIE2AW &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu TEGRA194_SID_PCIE2 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
+		};
 
-		ranges = <0x43000000 0x12 0x40000000 0x12 0x40000000 0x0 0x30000000>, /* prefetchable memory (768 MiB) */
-			 <0x02000000 0x0  0x40000000 0x12 0x70000000 0x0 0x0fff0000>, /* non-prefetchable memory (256 MiB - 64 KiB) */
-			 <0x01000000 0x0  0x00000000 0x12 0x7fff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
+		pcie@14140000 {
+			compatible = "nvidia,tegra194-pcie";
+			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
+			reg = <0x00 0x14140000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x34000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x34040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x34080000 0x0 0x00040000>; /* DBI reg space (256K)       */
+			reg-names = "appl", "config", "atu_dma", "dbi";
 
-		interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE2AR &emc>,
-				<&mc TEGRA194_MEMORY_CLIENT_PCIE2AW &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu TEGRA194_SID_PCIE2 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
-	};
+			status = "disabled";
 
-	pcie@14140000 {
-		compatible = "nvidia,tegra194-pcie";
-		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
-		reg = <0x00 0x14140000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x34000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x34040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x34080000 0x0 0x00040000>; /* DBI reg space (256K)       */
-		reg-names = "appl", "config", "atu_dma", "dbi";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <1>;
+			linux,pci-domain = <3>;
 
-		status = "disabled";
+			clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_3>;
+			clock-names = "core";
 
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <1>;
-		linux,pci-domain = <3>;
+			resets = <&bpmp TEGRA194_RESET_PEX0_CORE_3_APB>,
+				 <&bpmp TEGRA194_RESET_PEX0_CORE_3>;
+			reset-names = "apb", "core";
 
-		clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_3>;
-		clock-names = "core";
+			interrupts = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		resets = <&bpmp TEGRA194_RESET_PEX0_CORE_3_APB>,
-			 <&bpmp TEGRA194_RESET_PEX0_CORE_3>;
-		reset-names = "apb", "core";
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
 
-		interrupts = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			nvidia,bpmp = <&bpmp 3>;
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		nvidia,bpmp = <&bpmp 3>;
+			bus-range = <0x0 0xff>;
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			ranges = <0x43000000 0x12 0x80000000 0x12 0x80000000 0x0 0x30000000>, /* prefetchable memory (768 MiB) */
+				 <0x02000000 0x0  0x40000000 0x12 0xb0000000 0x0 0x0fff0000>, /* non-prefetchable memory (256 MiB + 64 KiB) */
+				 <0x01000000 0x0  0x00000000 0x12 0xbfff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
 
-		bus-range = <0x0 0xff>;
+			interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE3R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_PCIE3W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu TEGRA194_SID_PCIE3 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
+		};
 
-		ranges = <0x43000000 0x12 0x80000000 0x12 0x80000000 0x0 0x30000000>, /* prefetchable memory (768 MiB) */
-			 <0x02000000 0x0  0x40000000 0x12 0xb0000000 0x0 0x0fff0000>, /* non-prefetchable memory (256 MiB + 64 KiB) */
-			 <0x01000000 0x0  0x00000000 0x12 0xbfff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
+		pcie@14160000 {
+			compatible = "nvidia,tegra194-pcie";
+			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX4A>;
+			reg = <0x00 0x14160000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x36000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x36040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x36080000 0x0 0x00040000>; /* DBI reg space (256K)       */
+			reg-names = "appl", "config", "atu_dma", "dbi";
 
-		interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE3R &emc>,
-				<&mc TEGRA194_MEMORY_CLIENT_PCIE3W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu TEGRA194_SID_PCIE3 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
-	};
+			status = "disabled";
 
-	pcie@14160000 {
-		compatible = "nvidia,tegra194-pcie";
-		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX4A>;
-		reg = <0x00 0x14160000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x36000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x36040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x36080000 0x0 0x00040000>; /* DBI reg space (256K)       */
-		reg-names = "appl", "config", "atu_dma", "dbi";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <4>;
+			linux,pci-domain = <4>;
 
-		status = "disabled";
+			clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_4>;
+			clock-names = "core";
 
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <4>;
-		linux,pci-domain = <4>;
+			resets = <&bpmp TEGRA194_RESET_PEX0_CORE_4_APB>,
+				 <&bpmp TEGRA194_RESET_PEX0_CORE_4>;
+			reset-names = "apb", "core";
 
-		clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_4>;
-		clock-names = "core";
+			interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		resets = <&bpmp TEGRA194_RESET_PEX0_CORE_4_APB>,
-			 <&bpmp TEGRA194_RESET_PEX0_CORE_4>;
-		reset-names = "apb", "core";
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
 
-		interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			nvidia,bpmp = <&bpmp 4>;
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		nvidia,bpmp = <&bpmp 4>;
+			bus-range = <0x0 0xff>;
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			ranges = <0x43000000 0x14 0x00000000 0x14 0x00000000 0x3 0x40000000>, /* prefetchable memory (13 GiB) */
+				 <0x02000000 0x0  0x40000000 0x17 0x40000000 0x0 0xbfff0000>, /* non-prefetchable memory (3 GiB - 64 KiB) */
+				 <0x01000000 0x0  0x00000000 0x17 0xffff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
 
-		bus-range = <0x0 0xff>;
+			interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE4R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_PCIE4W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu TEGRA194_SID_PCIE4 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
+		};
 
-		ranges = <0x43000000 0x14 0x00000000 0x14 0x00000000 0x3 0x40000000>, /* prefetchable memory (13 GiB) */
-			 <0x02000000 0x0  0x40000000 0x17 0x40000000 0x0 0xbfff0000>, /* non-prefetchable memory (3 GiB - 64 KiB) */
-			 <0x01000000 0x0  0x00000000 0x17 0xffff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
+		pcie-ep@14160000 {
+			compatible = "nvidia,tegra194-pcie-ep";
+			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX4A>;
+			reg = <0x00 0x14160000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x36040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x36080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x14 0x00000000 0x4 0x00000000>; /* Address Space (16G)        */
+			reg-names = "appl", "atu_dma", "dbi", "addr_space";
 
-		interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE4R &emc>,
-				<&mc TEGRA194_MEMORY_CLIENT_PCIE4W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu TEGRA194_SID_PCIE4 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
-	};
+			status = "disabled";
 
-	pcie@14180000 {
-		compatible = "nvidia,tegra194-pcie";
-		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
-		reg = <0x00 0x14180000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x38000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x38040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x38080000 0x0 0x00040000>; /* DBI reg space (256K)       */
-		reg-names = "appl", "config", "atu_dma", "dbi";
+			num-lanes = <4>;
+			num-ib-windows = <2>;
+			num-ob-windows = <8>;
 
-		status = "disabled";
+			clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_4>;
+			clock-names = "core";
 
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <8>;
-		linux,pci-domain = <0>;
+			resets = <&bpmp TEGRA194_RESET_PEX0_CORE_4_APB>,
+				 <&bpmp TEGRA194_RESET_PEX0_CORE_4>;
+			reset-names = "apb", "core";
 
-		clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_0>;
-		clock-names = "core";
+			interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
+			interrupt-names = "intr";
 
-		resets = <&bpmp TEGRA194_RESET_PEX0_CORE_0_APB>,
-			 <&bpmp TEGRA194_RESET_PEX0_CORE_0>;
-		reset-names = "apb", "core";
+			nvidia,bpmp = <&bpmp 4>;
 
-		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
+			interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE4R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_PCIE4W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu TEGRA194_SID_PCIE4 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
+		};
 
-		nvidia,bpmp = <&bpmp 0>;
+		pcie@14180000 {
+			compatible = "nvidia,tegra194-pcie";
+			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
+			reg = <0x00 0x14180000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x38000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x38040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x38080000 0x0 0x00040000>; /* DBI reg space (256K)       */
+			reg-names = "appl", "config", "atu_dma", "dbi";
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			status = "disabled";
 
-		bus-range = <0x0 0xff>;
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <8>;
+			linux,pci-domain = <0>;
 
-		ranges = <0x43000000 0x18 0x00000000 0x18 0x00000000 0x3 0x40000000>, /* prefetchable memory (13 GiB) */
-			 <0x02000000 0x0  0x40000000 0x1b 0x40000000 0x0 0xbfff0000>, /* non-prefetchable memory (3 GiB - 64 KiB) */
-			 <0x01000000 0x0  0x00000000 0x1b 0xffff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
+			clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_0>;
+			clock-names = "core";
 
-		interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE0R &emc>,
-				<&mc TEGRA194_MEMORY_CLIENT_PCIE0W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu TEGRA194_SID_PCIE0 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
-	};
+			resets = <&bpmp TEGRA194_RESET_PEX0_CORE_0_APB>,
+				 <&bpmp TEGRA194_RESET_PEX0_CORE_0>;
+			reset-names = "apb", "core";
 
-	pcie@141a0000 {
-		compatible = "nvidia,tegra194-pcie";
-		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8A>;
-		reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x3a000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x3a080000 0x0 0x00040000>; /* DBI reg space (256K)       */
-		reg-names = "appl", "config", "atu_dma", "dbi";
+			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		status = "disabled";
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
 
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <8>;
-		linux,pci-domain = <5>;
+			nvidia,bpmp = <&bpmp 0>;
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&pex_rst_c5_out_state>, <&clkreq_c5_bi_dir_state>;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		clocks = <&bpmp TEGRA194_CLK_PEX1_CORE_5>;
-		clock-names = "core";
+			bus-range = <0x0 0xff>;
 
-		resets = <&bpmp TEGRA194_RESET_PEX1_CORE_5_APB>,
-			 <&bpmp TEGRA194_RESET_PEX1_CORE_5>;
-		reset-names = "apb", "core";
+			ranges = <0x43000000 0x18 0x00000000 0x18 0x00000000 0x3 0x40000000>, /* prefetchable memory (13 GiB) */
+				 <0x02000000 0x0  0x40000000 0x1b 0x40000000 0x0 0xbfff0000>, /* non-prefetchable memory (3 GiB - 64 KiB) */
+				 <0x01000000 0x0  0x00000000 0x1b 0xffff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
 
-		interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE0R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_PCIE0W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu TEGRA194_SID_PCIE0 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
+		};
 
-		nvidia,bpmp = <&bpmp 5>;
+		pcie-ep@14180000 {
+			compatible = "nvidia,tegra194-pcie-ep";
+			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
+			reg = <0x00 0x14180000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x38040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x38080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x18 0x00000000 0x4 0x00000000>; /* Address Space (16G)        */
+			reg-names = "appl", "atu_dma", "dbi", "addr_space";
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
+			status = "disabled";
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			num-lanes = <8>;
+			num-ib-windows = <2>;
+			num-ob-windows = <8>;
 
-		bus-range = <0x0 0xff>;
+			clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_0>;
+			clock-names = "core";
 
-		ranges = <0x43000000 0x1c 0x00000000 0x1c 0x00000000 0x3 0x40000000>, /* prefetchable memory (13 GiB) */
-			 <0x02000000 0x0  0x40000000 0x1f 0x40000000 0x0 0xbfff0000>, /* non-prefetchable memory (3 GiB - 64 KiB) */
-			 <0x01000000 0x0  0x00000000 0x1f 0xffff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
+			resets = <&bpmp TEGRA194_RESET_PEX0_CORE_0_APB>,
+				 <&bpmp TEGRA194_RESET_PEX0_CORE_0>;
+			reset-names = "apb", "core";
 
-		interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE5R &emc>,
-				<&mc TEGRA194_MEMORY_CLIENT_PCIE5W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu TEGRA194_SID_PCIE5 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
-	};
+			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
+			interrupt-names = "intr";
 
-	pcie-ep@14160000 {
-		compatible = "nvidia,tegra194-pcie-ep";
-		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX4A>;
-		reg = <0x00 0x14160000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x36040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x36080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x14 0x00000000 0x4 0x00000000>; /* Address Space (16G)        */
-		reg-names = "appl", "atu_dma", "dbi", "addr_space";
+			nvidia,bpmp = <&bpmp 0>;
 
-		status = "disabled";
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		num-lanes = <4>;
-		num-ib-windows = <2>;
-		num-ob-windows = <8>;
+			interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE0R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_PCIE0W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu TEGRA194_SID_PCIE0 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
+		};
 
-		clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_4>;
-		clock-names = "core";
+		pcie@141a0000 {
+			compatible = "nvidia,tegra194-pcie";
+			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8A>;
+			reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x3a000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x3a080000 0x0 0x00040000>; /* DBI reg space (256K)       */
+			reg-names = "appl", "config", "atu_dma", "dbi";
 
-		resets = <&bpmp TEGRA194_RESET_PEX0_CORE_4_APB>,
-			 <&bpmp TEGRA194_RESET_PEX0_CORE_4>;
-		reset-names = "apb", "core";
+			status = "disabled";
 
-		interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
-		interrupt-names = "intr";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <8>;
+			linux,pci-domain = <5>;
 
-		nvidia,bpmp = <&bpmp 4>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pex_rst_c5_out_state>, <&clkreq_c5_bi_dir_state>;
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			clocks = <&bpmp TEGRA194_CLK_PEX1_CORE_5>;
+			clock-names = "core";
 
-		interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE4R &emc>,
-				<&mc TEGRA194_MEMORY_CLIENT_PCIE4W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu TEGRA194_SID_PCIE4 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
-	};
+			resets = <&bpmp TEGRA194_RESET_PEX1_CORE_5_APB>,
+				 <&bpmp TEGRA194_RESET_PEX1_CORE_5>;
+			reset-names = "apb", "core";
 
-	pcie-ep@14180000 {
-		compatible = "nvidia,tegra194-pcie-ep";
-		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
-		reg = <0x00 0x14180000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x38040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x38080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x18 0x00000000 0x4 0x00000000>; /* Address Space (16G)        */
-		reg-names = "appl", "atu_dma", "dbi", "addr_space";
+			interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		status = "disabled";
+			nvidia,bpmp = <&bpmp 5>;
 
-		num-lanes = <8>;
-		num-ib-windows = <2>;
-		num-ob-windows = <8>;
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
 
-		clocks = <&bpmp TEGRA194_CLK_PEX0_CORE_0>;
-		clock-names = "core";
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		resets = <&bpmp TEGRA194_RESET_PEX0_CORE_0_APB>,
-			 <&bpmp TEGRA194_RESET_PEX0_CORE_0>;
-		reset-names = "apb", "core";
+			bus-range = <0x0 0xff>;
 
-		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
-		interrupt-names = "intr";
+			ranges = <0x43000000 0x1c 0x00000000 0x1c 0x00000000 0x3 0x40000000>, /* prefetchable memory (13 GiB) */
+				 <0x02000000 0x0  0x40000000 0x1f 0x40000000 0x0 0xbfff0000>, /* non-prefetchable memory (3 GiB - 64 KiB) */
+				 <0x01000000 0x0  0x00000000 0x1f 0xffff0000 0x0 0x00010000>; /* downstream I/O (64 KiB) */
 
-		nvidia,bpmp = <&bpmp 0>;
+			interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE5R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_PCIE5W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu TEGRA194_SID_PCIE5 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
+		};
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+		pcie-ep@141a0000 {
+			compatible = "nvidia,tegra194-pcie-ep";
+			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8A>;
+			reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x3a080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x1c 0x00000000 0x4 0x00000000>; /* Address Space (16G)        */
+			reg-names = "appl", "atu_dma", "dbi", "addr_space";
 
-		interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE0R &emc>,
-				<&mc TEGRA194_MEMORY_CLIENT_PCIE0W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu TEGRA194_SID_PCIE0 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
-	};
+			status = "disabled";
 
-	pcie-ep@141a0000 {
-		compatible = "nvidia,tegra194-pcie-ep";
-		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8A>;
-		reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x3a080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x1c 0x00000000 0x4 0x00000000>; /* Address Space (16G)        */
-		reg-names = "appl", "atu_dma", "dbi", "addr_space";
+			num-lanes = <8>;
+			num-ib-windows = <2>;
+			num-ob-windows = <8>;
 
-		status = "disabled";
+			pinctrl-names = "default";
+			pinctrl-0 = <&clkreq_c5_bi_dir_state>;
 
-		num-lanes = <8>;
-		num-ib-windows = <2>;
-		num-ob-windows = <8>;
+			clocks = <&bpmp TEGRA194_CLK_PEX1_CORE_5>;
+			clock-names = "core";
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&clkreq_c5_bi_dir_state>;
+			resets = <&bpmp TEGRA194_RESET_PEX1_CORE_5_APB>,
+				 <&bpmp TEGRA194_RESET_PEX1_CORE_5>;
+			reset-names = "apb", "core";
 
-		clocks = <&bpmp TEGRA194_CLK_PEX1_CORE_5>;
-		clock-names = "core";
+			interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
+			interrupt-names = "intr";
 
-		resets = <&bpmp TEGRA194_RESET_PEX1_CORE_5_APB>,
-			 <&bpmp TEGRA194_RESET_PEX1_CORE_5>;
-		reset-names = "apb", "core";
+			nvidia,bpmp = <&bpmp 5>;
 
-		interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
-		interrupt-names = "intr";
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		nvidia,bpmp = <&bpmp 5>;
+			interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE5R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_PCIE5W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu TEGRA194_SID_PCIE5 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
+		};
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+		gpu@17000000 {
+			compatible = "nvidia,gv11b";
+			reg = <0x0 0x17000000 0x0 0x1000000>,
+			      <0x0 0x18000000 0x0 0x1000000>;
+			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "stall", "nonstall";
+			clocks = <&bpmp TEGRA194_CLK_GPCCLK>,
+				 <&bpmp TEGRA194_CLK_GPU_PWR>,
+				 <&bpmp TEGRA194_CLK_FUSE>;
+			clock-names = "gpu", "pwr", "fuse";
+			resets = <&bpmp TEGRA194_RESET_GPU>;
+			reset-names = "gpu";
+			dma-coherent;
 
-		interconnects = <&mc TEGRA194_MEMORY_CLIENT_PCIE5R &emc>,
-				<&mc TEGRA194_MEMORY_CLIENT_PCIE5W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu TEGRA194_SID_PCIE5 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_GPU>;
+			interconnects = <&mc TEGRA194_MEMORY_CLIENT_NVL1R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_NVL1RHP &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_NVL1W &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_NVL2R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_NVL2RHP &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_NVL2W &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_NVL3R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_NVL3RHP &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_NVL3W &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_NVL4R &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_NVL4RHP &emc>,
+					<&mc TEGRA194_MEMORY_CLIENT_NVL4W &emc>;
+			interconnect-names = "dma-mem", "read-0-hp", "write-0",
+					     "read-1", "read-1-hp", "write-1",
+					     "read-2", "read-2-hp", "write-2",
+					     "read-3", "read-3-hp", "write-3";
+		};
 	};
 
 	sram@40000000 {
 		compatible = "nvidia,tegra194-sysram", "mmio-sram";
 		reg = <0x0 0x40000000 0x0 0x50000>;
+
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0x40000000 0x50000>;
+
 		no-memory-wc;
 
 		cpu_bpmp_tx: sram@4e000 {
diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
index 96aa2267b06d8..431f42a266f5b 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
@@ -2048,6 +2048,57 @@ mgbe0_phy: phy@0 {
 				};
 			};
 		};
+
+		pcie@14100000 {
+			status = "okay";
+
+			vddio-pex-ctl-supply = <&vdd_1v8_ao>;
+
+			phys = <&p2u_hsio_3>;
+			phy-names = "p2u-0";
+		};
+
+		pcie@14160000 {
+			status = "okay";
+
+			vddio-pex-ctl-supply = <&vdd_1v8_ao>;
+
+			phys = <&p2u_hsio_4>, <&p2u_hsio_5>, <&p2u_hsio_6>,
+			       <&p2u_hsio_7>;
+			phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3";
+		};
+
+		pcie@141a0000 {
+			status = "okay";
+
+			vddio-pex-ctl-supply = <&vdd_1v8_ls>;
+			vpcie3v3-supply = <&vdd_3v3_pcie>;
+			vpcie12v-supply = <&vdd_12v_pcie>;
+
+			phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
+			       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
+			       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
+			phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
+				    "p2u-5", "p2u-6", "p2u-7";
+		};
+
+		pcie-ep@141a0000 {
+			status = "disabled";
+
+			vddio-pex-ctl-supply = <&vdd_1v8_ls>;
+
+			reset-gpios = <&gpio TEGRA234_MAIN_GPIO(AF, 1) GPIO_ACTIVE_LOW>;
+
+			nvidia,refclk-select-gpios = <&gpio_aon
+						      TEGRA234_AON_GPIO(AA, 4)
+						      GPIO_ACTIVE_HIGH>;
+
+			phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
+			       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
+			       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
+			phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
+				    "p2u-5", "p2u-6", "p2u-7";
+		};
 	};
 
 	gpio-keys {
@@ -2145,57 +2196,6 @@ sound {
 		label = "NVIDIA Jetson AGX Orin APE";
 	};
 
-	pcie@14100000 {
-		status = "okay";
-
-		vddio-pex-ctl-supply = <&vdd_1v8_ao>;
-
-		phys = <&p2u_hsio_3>;
-		phy-names = "p2u-0";
-	};
-
-	pcie@14160000 {
-		status = "okay";
-
-		vddio-pex-ctl-supply = <&vdd_1v8_ao>;
-
-		phys = <&p2u_hsio_4>, <&p2u_hsio_5>, <&p2u_hsio_6>,
-		       <&p2u_hsio_7>;
-		phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3";
-	};
-
-	pcie@141a0000 {
-		status = "okay";
-
-		vddio-pex-ctl-supply = <&vdd_1v8_ls>;
-		vpcie3v3-supply = <&vdd_3v3_pcie>;
-		vpcie12v-supply = <&vdd_12v_pcie>;
-
-		phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
-		       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
-		       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
-		phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
-			    "p2u-5", "p2u-6", "p2u-7";
-	};
-
-	pcie-ep@141a0000 {
-		status = "disabled";
-
-		vddio-pex-ctl-supply = <&vdd_1v8_ls>;
-
-		reset-gpios = <&gpio TEGRA234_MAIN_GPIO(AF, 1) GPIO_ACTIVE_LOW>;
-
-		nvidia,refclk-select-gpios = <&gpio_aon
-					      TEGRA234_AON_GPIO(AA, 4)
-					      GPIO_ACTIVE_HIGH>;
-
-		phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
-		       <&p2u_nvhs_3>, <&p2u_nvhs_4>, <&p2u_nvhs_5>,
-		       <&p2u_nvhs_6>, <&p2u_nvhs_7>;
-		phy-names = "p2u-0", "p2u-1", "p2u-2", "p2u-3", "p2u-4",
-			    "p2u-5", "p2u-6", "p2u-7";
-	};
-
 	pwm-fan {
 		compatible = "pwm-fan";
 		pwms = <&pwm3 0 45334>;
diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index eaf05ee9acd18..3d680ee0f4d17 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -17,15 +17,15 @@ / {
 
 	bus@0 {
 		compatible = "simple-bus";
-		#address-cells = <1>;
-		#size-cells = <1>;
 
-		ranges = <0x0 0x0 0x0 0x40000000>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges = <0x0 0x0 0x0 0x0 0x0 0x40000000>;
 
 		gpcdma: dma-controller@2600000 {
 			compatible = "nvidia,tegra234-gpcdma",
 				     "nvidia,tegra186-gpcdma";
-			reg = <0x2600000 0x210000>;
+			reg = <0x0 0x2600000 0x0 0x210000>;
 			resets = <&bpmp TEGRA234_RESET_GPCDMA>;
 			reset-names = "gpcdma";
 			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>,
@@ -73,27 +73,29 @@ aconnect@2900000 {
 				 <&bpmp TEGRA234_CLK_APB2APE>;
 			clock-names = "ape", "apb2ape";
 			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_AUD>;
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0x02900000 0x02900000 0x200000>;
 			status = "disabled";
 
+			#address-cells = <2>;
+			#size-cells = <2>;
+			ranges = <0x0 0x02900000 0x0 0x02900000 0x0 0x200000>;
+
 			tegra_ahub: ahub@2900800 {
 				compatible = "nvidia,tegra234-ahub";
-				reg = <0x02900800 0x800>;
+				reg = <0x0 0x02900800 0x0 0x800>;
 				clocks = <&bpmp TEGRA234_CLK_AHUB>;
 				clock-names = "ahub";
 				assigned-clocks = <&bpmp TEGRA234_CLK_AHUB>;
 				assigned-clock-parents = <&bpmp TEGRA234_CLK_PLLA_OUT0>;
-				#address-cells = <1>;
-				#size-cells = <1>;
-				ranges = <0x02900800 0x02900800 0x11800>;
 				status = "disabled";
 
+				#address-cells = <2>;
+				#size-cells = <2>;
+				ranges = <0x0 0x02900800 0x0 0x02900800 0x0 0x11800>;
+
 				tegra_i2s1: i2s@2901000 {
 					compatible = "nvidia,tegra234-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901000 0x100>;
+					reg = <0x0 0x2901000 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_I2S1>,
 						 <&bpmp TEGRA234_CLK_I2S1_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -107,7 +109,7 @@ tegra_i2s1: i2s@2901000 {
 				tegra_i2s2: i2s@2901100 {
 					compatible = "nvidia,tegra234-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901100 0x100>;
+					reg = <0x0 0x2901100 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_I2S2>,
 						 <&bpmp TEGRA234_CLK_I2S2_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -121,7 +123,7 @@ tegra_i2s2: i2s@2901100 {
 				tegra_i2s3: i2s@2901200 {
 					compatible = "nvidia,tegra234-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901200 0x100>;
+					reg = <0x0 0x2901200 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_I2S3>,
 						 <&bpmp TEGRA234_CLK_I2S3_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -135,7 +137,7 @@ tegra_i2s3: i2s@2901200 {
 				tegra_i2s4: i2s@2901300 {
 					compatible = "nvidia,tegra234-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901300 0x100>;
+					reg = <0x0 0x2901300 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_I2S4>,
 						 <&bpmp TEGRA234_CLK_I2S4_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -149,7 +151,7 @@ tegra_i2s4: i2s@2901300 {
 				tegra_i2s5: i2s@2901400 {
 					compatible = "nvidia,tegra234-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901400 0x100>;
+					reg = <0x0 0x2901400 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_I2S5>,
 						 <&bpmp TEGRA234_CLK_I2S5_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -163,7 +165,7 @@ tegra_i2s5: i2s@2901400 {
 				tegra_i2s6: i2s@2901500 {
 					compatible = "nvidia,tegra234-i2s",
 						     "nvidia,tegra210-i2s";
-					reg = <0x2901500 0x100>;
+					reg = <0x0 0x2901500 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_I2S6>,
 						 <&bpmp TEGRA234_CLK_I2S6_SYNC_INPUT>;
 					clock-names = "i2s", "sync_input";
@@ -177,7 +179,7 @@ tegra_i2s6: i2s@2901500 {
 				tegra_sfc1: sfc@2902000 {
 					compatible = "nvidia,tegra234-sfc",
 						     "nvidia,tegra210-sfc";
-					reg = <0x2902000 0x200>;
+					reg = <0x0 0x2902000 0x0 0x200>;
 					sound-name-prefix = "SFC1";
 					status = "disabled";
 				};
@@ -185,7 +187,7 @@ tegra_sfc1: sfc@2902000 {
 				tegra_sfc2: sfc@2902200 {
 					compatible = "nvidia,tegra234-sfc",
 						     "nvidia,tegra210-sfc";
-					reg = <0x2902200 0x200>;
+					reg = <0x0 0x2902200 0x0 0x200>;
 					sound-name-prefix = "SFC2";
 					status = "disabled";
 				};
@@ -193,7 +195,7 @@ tegra_sfc2: sfc@2902200 {
 				tegra_sfc3: sfc@2902400 {
 					compatible = "nvidia,tegra234-sfc",
 						     "nvidia,tegra210-sfc";
-					reg = <0x2902400 0x200>;
+					reg = <0x0 0x2902400 0x0 0x200>;
 					sound-name-prefix = "SFC3";
 					status = "disabled";
 				};
@@ -201,7 +203,7 @@ tegra_sfc3: sfc@2902400 {
 				tegra_sfc4: sfc@2902600 {
 					compatible = "nvidia,tegra234-sfc",
 						     "nvidia,tegra210-sfc";
-					reg = <0x2902600 0x200>;
+					reg = <0x0 0x2902600 0x0 0x200>;
 					sound-name-prefix = "SFC4";
 					status = "disabled";
 				};
@@ -209,7 +211,7 @@ tegra_sfc4: sfc@2902600 {
 				tegra_amx1: amx@2903000 {
 					compatible = "nvidia,tegra234-amx",
 						     "nvidia,tegra194-amx";
-					reg = <0x2903000 0x100>;
+					reg = <0x0 0x2903000 0x0 0x100>;
 					sound-name-prefix = "AMX1";
 					status = "disabled";
 				};
@@ -217,7 +219,7 @@ tegra_amx1: amx@2903000 {
 				tegra_amx2: amx@2903100 {
 					compatible = "nvidia,tegra234-amx",
 						     "nvidia,tegra194-amx";
-					reg = <0x2903100 0x100>;
+					reg = <0x0 0x2903100 0x0 0x100>;
 					sound-name-prefix = "AMX2";
 					status = "disabled";
 				};
@@ -225,7 +227,7 @@ tegra_amx2: amx@2903100 {
 				tegra_amx3: amx@2903200 {
 					compatible = "nvidia,tegra234-amx",
 						     "nvidia,tegra194-amx";
-					reg = <0x2903200 0x100>;
+					reg = <0x0 0x2903200 0x0 0x100>;
 					sound-name-prefix = "AMX3";
 					status = "disabled";
 				};
@@ -233,7 +235,7 @@ tegra_amx3: amx@2903200 {
 				tegra_amx4: amx@2903300 {
 					compatible = "nvidia,tegra234-amx",
 						     "nvidia,tegra194-amx";
-					reg = <0x2903300 0x100>;
+					reg = <0x0 0x2903300 0x0 0x100>;
 					sound-name-prefix = "AMX4";
 					status = "disabled";
 				};
@@ -241,7 +243,7 @@ tegra_amx4: amx@2903300 {
 				tegra_adx1: adx@2903800 {
 					compatible = "nvidia,tegra234-adx",
 						     "nvidia,tegra210-adx";
-					reg = <0x2903800 0x100>;
+					reg = <0x0 0x2903800 0x0 0x100>;
 					sound-name-prefix = "ADX1";
 					status = "disabled";
 				};
@@ -249,7 +251,7 @@ tegra_adx1: adx@2903800 {
 				tegra_adx2: adx@2903900 {
 					compatible = "nvidia,tegra234-adx",
 						     "nvidia,tegra210-adx";
-					reg = <0x2903900 0x100>;
+					reg = <0x0 0x2903900 0x0 0x100>;
 					sound-name-prefix = "ADX2";
 					status = "disabled";
 				};
@@ -257,7 +259,7 @@ tegra_adx2: adx@2903900 {
 				tegra_adx3: adx@2903a00 {
 					compatible = "nvidia,tegra234-adx",
 						     "nvidia,tegra210-adx";
-					reg = <0x2903a00 0x100>;
+					reg = <0x0 0x2903a00 0x0 0x100>;
 					sound-name-prefix = "ADX3";
 					status = "disabled";
 				};
@@ -265,7 +267,7 @@ tegra_adx3: adx@2903a00 {
 				tegra_adx4: adx@2903b00 {
 					compatible = "nvidia,tegra234-adx",
 						     "nvidia,tegra210-adx";
-					reg = <0x2903b00 0x100>;
+					reg = <0x0 0x2903b00 0x0 0x100>;
 					sound-name-prefix = "ADX4";
 					status = "disabled";
 				};
@@ -274,7 +276,7 @@ tegra_adx4: adx@2903b00 {
 				tegra_dmic1: dmic@2904000 {
 					compatible = "nvidia,tegra234-dmic",
 						     "nvidia,tegra210-dmic";
-					reg = <0x2904000 0x100>;
+					reg = <0x0 0x2904000 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_DMIC1>;
 					clock-names = "dmic";
 					assigned-clocks = <&bpmp TEGRA234_CLK_DMIC1>;
@@ -287,7 +289,7 @@ tegra_dmic1: dmic@2904000 {
 				tegra_dmic2: dmic@2904100 {
 					compatible = "nvidia,tegra234-dmic",
 						     "nvidia,tegra210-dmic";
-					reg = <0x2904100 0x100>;
+					reg = <0x0 0x2904100 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_DMIC2>;
 					clock-names = "dmic";
 					assigned-clocks = <&bpmp TEGRA234_CLK_DMIC2>;
@@ -300,7 +302,7 @@ tegra_dmic2: dmic@2904100 {
 				tegra_dmic3: dmic@2904200 {
 					compatible = "nvidia,tegra234-dmic",
 						     "nvidia,tegra210-dmic";
-					reg = <0x2904200 0x100>;
+					reg = <0x0 0x2904200 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_DMIC3>;
 					clock-names = "dmic";
 					assigned-clocks = <&bpmp TEGRA234_CLK_DMIC3>;
@@ -313,7 +315,7 @@ tegra_dmic3: dmic@2904200 {
 				tegra_dmic4: dmic@2904300 {
 					compatible = "nvidia,tegra234-dmic",
 						     "nvidia,tegra210-dmic";
-					reg = <0x2904300 0x100>;
+					reg = <0x0 0x2904300 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_DMIC4>;
 					clock-names = "dmic";
 					assigned-clocks = <&bpmp TEGRA234_CLK_DMIC4>;
@@ -326,7 +328,7 @@ tegra_dmic4: dmic@2904300 {
 				tegra_dspk1: dspk@2905000 {
 					compatible = "nvidia,tegra234-dspk",
 						     "nvidia,tegra186-dspk";
-					reg = <0x2905000 0x100>;
+					reg = <0x0 0x2905000 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_DSPK1>;
 					clock-names = "dspk";
 					assigned-clocks = <&bpmp TEGRA234_CLK_DSPK1>;
@@ -339,7 +341,7 @@ tegra_dspk1: dspk@2905000 {
 				tegra_dspk2: dspk@2905100 {
 					compatible = "nvidia,tegra234-dspk",
 						     "nvidia,tegra186-dspk";
-					reg = <0x2905100 0x100>;
+					reg = <0x0 0x2905100 0x0 0x100>;
 					clocks = <&bpmp TEGRA234_CLK_DSPK2>;
 					clock-names = "dspk";
 					assigned-clocks = <&bpmp TEGRA234_CLK_DSPK2>;
@@ -352,30 +354,31 @@ tegra_dspk2: dspk@2905100 {
 				tegra_ope1: processing-engine@2908000 {
 					compatible = "nvidia,tegra234-ope",
 						     "nvidia,tegra210-ope";
-					reg = <0x2908000 0x100>;
-					#address-cells = <1>;
-					#size-cells = <1>;
-					ranges;
+					reg = <0x0 0x2908000 0x0 0x100>;
 					sound-name-prefix = "OPE1";
 					status = "disabled";
 
+					#address-cells = <2>;
+					#size-cells = <2>;
+					ranges;
+
 					equalizer@2908100 {
 						compatible = "nvidia,tegra234-peq",
 							     "nvidia,tegra210-peq";
-						reg = <0x2908100 0x100>;
+						reg = <0x0 0x2908100 0x0 0x100>;
 					};
 
 					dynamic-range-compressor@2908200 {
 						compatible = "nvidia,tegra234-mbdrc",
 							     "nvidia,tegra210-mbdrc";
-						reg = <0x2908200 0x200>;
+						reg = <0x0 0x2908200 0x0 0x200>;
 					};
 				};
 
 				tegra_mvc1: mvc@290a000 {
 					compatible = "nvidia,tegra234-mvc",
 						     "nvidia,tegra210-mvc";
-					reg = <0x290a000 0x200>;
+					reg = <0x0 0x290a000 0x0 0x200>;
 					sound-name-prefix = "MVC1";
 					status = "disabled";
 				};
@@ -383,7 +386,7 @@ tegra_mvc1: mvc@290a000 {
 				tegra_mvc2: mvc@290a200 {
 					compatible = "nvidia,tegra234-mvc",
 						     "nvidia,tegra210-mvc";
-					reg = <0x290a200 0x200>;
+					reg = <0x0 0x290a200 0x0 0x200>;
 					sound-name-prefix = "MVC2";
 					status = "disabled";
 				};
@@ -391,7 +394,7 @@ tegra_mvc2: mvc@290a200 {
 				tegra_amixer: amixer@290bb00 {
 					compatible = "nvidia,tegra234-amixer",
 						     "nvidia,tegra210-amixer";
-					reg = <0x290bb00 0x800>;
+					reg = <0x0 0x290bb00 0x0 0x800>;
 					sound-name-prefix = "MIXER1";
 					status = "disabled";
 				};
@@ -399,7 +402,7 @@ tegra_amixer: amixer@290bb00 {
 				tegra_admaif: admaif@290f000 {
 					compatible = "nvidia,tegra234-admaif",
 						     "nvidia,tegra186-admaif";
-					reg = <0x0290f000 0x1000>;
+					reg = <0x0 0x0290f000 0x0 0x1000>;
 					dmas = <&adma 1>, <&adma 1>,
 					       <&adma 2>, <&adma 2>,
 					       <&adma 3>, <&adma 3>,
@@ -450,7 +453,7 @@ tegra_admaif: admaif@290f000 {
 				tegra_asrc: asrc@2910000 {
 					compatible = "nvidia,tegra234-asrc",
 						     "nvidia,tegra186-asrc";
-					reg = <0x2910000 0x2000>;
+					reg = <0x0 0x2910000 0x0 0x2000>;
 					sound-name-prefix = "ASRC1";
 					status = "disabled";
 				};
@@ -459,7 +462,7 @@ tegra_asrc: asrc@2910000 {
 			adma: dma-controller@2930000 {
 				compatible = "nvidia,tegra234-adma",
 					     "nvidia,tegra186-adma";
-				reg = <0x02930000 0x20000>;
+				reg = <0x0 0x02930000 0x0 0x20000>;
 				interrupt-parent = <&agic>;
 				interrupts =  <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
 					      <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
@@ -504,8 +507,8 @@ agic: interrupt-controller@2a40000 {
 					     "nvidia,tegra210-agic";
 				#interrupt-cells = <3>;
 				interrupt-controller;
-				reg = <0x02a41000 0x1000>,
-				      <0x02a42000 0x2000>;
+				reg = <0x0 0x02a41000 0x0 0x1000>,
+				      <0x0 0x02a42000 0x0 0x2000>;
 				interrupts = <GIC_SPI 145
 					      (GIC_CPU_MASK_SIMPLE(4) |
 					       IRQ_TYPE_LEVEL_HIGH)>;
@@ -517,14 +520,14 @@ agic: interrupt-controller@2a40000 {
 
 		misc@100000 {
 			compatible = "nvidia,tegra234-misc";
-			reg = <0x00100000 0xf000>,
-			      <0x0010f000 0x1000>;
+			reg = <0x0 0x00100000 0x0 0xf000>,
+			      <0x0 0x0010f000 0x0 0x1000>;
 			status = "okay";
 		};
 
 		timer@2080000 {
 			compatible = "nvidia,tegra234-timer";
-			reg = <0x02080000 0x00121000>;
+			reg = <0x0 0x02080000 0x0 0x00121000>;
 			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
@@ -546,9 +549,9 @@ timer@2080000 {
 
 		host1x@13e00000 {
 			compatible = "nvidia,tegra234-host1x";
-			reg = <0x13e00000 0x10000>,
-			      <0x13e10000 0x10000>,
-			      <0x13e40000 0x10000>;
+			reg = <0x0 0x13e00000 0x0 0x10000>,
+			      <0x0 0x13e10000 0x0 0x10000>,
+			      <0x0 0x13e40000 0x0 0x10000>;
 			reg-names = "common", "hypervisor", "vm";
 			interrupts = <GIC_SPI 448 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 449 IRQ_TYPE_LEVEL_HIGH>,
@@ -564,10 +567,10 @@ host1x@13e00000 {
 			clocks = <&bpmp TEGRA234_CLK_HOST1X>;
 			clock-names = "host1x";
 
-			#address-cells = <1>;
-			#size-cells = <1>;
+			#address-cells = <2>;
+			#size-cells = <2>;
+			ranges = <0x0 0x14800000 0x0 0x14800000 0x0 0x02000000>;
 
-			ranges = <0x14800000 0x14800000 0x02000000>;
 			interconnects = <&mc TEGRA234_MEMORY_CLIENT_HOST1XDMAR &emc>;
 			interconnect-names = "dma-mem";
 			iommus = <&smmu_niso1 TEGRA234_SID_HOST1X>;
@@ -592,7 +595,7 @@ host1x@13e00000 {
 
 			vic@15340000 {
 				compatible = "nvidia,tegra234-vic";
-				reg = <0x15340000 0x00040000>;
+				reg = <0x0 0x15340000 0x0 0x00040000>;
 				interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&bpmp TEGRA234_CLK_VIC>;
 				clock-names = "vic";
@@ -609,7 +612,7 @@ vic@15340000 {
 
 			nvdec@15480000 {
 				compatible = "nvidia,tegra234-nvdec";
-				reg = <0x15480000 0x00040000>;
+				reg = <0x0 0x15480000 0x0 0x00040000>;
 				clocks = <&bpmp TEGRA234_CLK_NVDEC>,
 					 <&bpmp TEGRA234_CLK_FUSE>,
 					 <&bpmp TEGRA234_CLK_TSEC_PKA>;
@@ -647,8 +650,8 @@ nvdec@15480000 {
 		gpio: gpio@2200000 {
 			compatible = "nvidia,tegra234-gpio";
 			reg-names = "security", "gpio";
-			reg = <0x02200000 0x10000>,
-			      <0x02210000 0x10000>;
+			reg = <0x0 0x02200000 0x0 0x10000>,
+			      <0x0 0x02210000 0x0 0x10000>;
 			interrupts = <GIC_SPI 288 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 289 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 290 IRQ_TYPE_LEVEL_HIGH>,
@@ -705,24 +708,24 @@ gpio: gpio@2200000 {
 
 		mc: memory-controller@2c00000 {
 			compatible = "nvidia,tegra234-mc";
-			reg = <0x02c00000 0x10000>,   /* MC-SID */
-			      <0x02c10000 0x10000>,   /* MC Broadcast*/
-			      <0x02c20000 0x10000>,   /* MC0 */
-			      <0x02c30000 0x10000>,   /* MC1 */
-			      <0x02c40000 0x10000>,   /* MC2 */
-			      <0x02c50000 0x10000>,   /* MC3 */
-			      <0x02b80000 0x10000>,   /* MC4 */
-			      <0x02b90000 0x10000>,   /* MC5 */
-			      <0x02ba0000 0x10000>,   /* MC6 */
-			      <0x02bb0000 0x10000>,   /* MC7 */
-			      <0x01700000 0x10000>,   /* MC8 */
-			      <0x01710000 0x10000>,   /* MC9 */
-			      <0x01720000 0x10000>,   /* MC10 */
-			      <0x01730000 0x10000>,   /* MC11 */
-			      <0x01740000 0x10000>,   /* MC12 */
-			      <0x01750000 0x10000>,   /* MC13 */
-			      <0x01760000 0x10000>,   /* MC14 */
-			      <0x01770000 0x10000>;   /* MC15 */
+			reg = <0x0 0x02c00000 0x0 0x10000>,   /* MC-SID */
+			      <0x0 0x02c10000 0x0 0x10000>,   /* MC Broadcast*/
+			      <0x0 0x02c20000 0x0 0x10000>,   /* MC0 */
+			      <0x0 0x02c30000 0x0 0x10000>,   /* MC1 */
+			      <0x0 0x02c40000 0x0 0x10000>,   /* MC2 */
+			      <0x0 0x02c50000 0x0 0x10000>,   /* MC3 */
+			      <0x0 0x02b80000 0x0 0x10000>,   /* MC4 */
+			      <0x0 0x02b90000 0x0 0x10000>,   /* MC5 */
+			      <0x0 0x02ba0000 0x0 0x10000>,   /* MC6 */
+			      <0x0 0x02bb0000 0x0 0x10000>,   /* MC7 */
+			      <0x0 0x01700000 0x0 0x10000>,   /* MC8 */
+			      <0x0 0x01710000 0x0 0x10000>,   /* MC9 */
+			      <0x0 0x01720000 0x0 0x10000>,   /* MC10 */
+			      <0x0 0x01730000 0x0 0x10000>,   /* MC11 */
+			      <0x0 0x01740000 0x0 0x10000>,   /* MC12 */
+			      <0x0 0x01750000 0x0 0x10000>,   /* MC13 */
+			      <0x0 0x01760000 0x0 0x10000>,   /* MC14 */
+			      <0x0 0x01770000 0x0 0x10000>;   /* MC15 */
 			reg-names = "sid", "broadcast", "ch0", "ch1", "ch2", "ch3",
 				    "ch4", "ch5", "ch6", "ch7", "ch8", "ch9", "ch10",
 				    "ch11", "ch12", "ch13", "ch14", "ch15";
@@ -732,10 +735,9 @@ mc: memory-controller@2c00000 {
 
 			#address-cells = <2>;
 			#size-cells = <2>;
-
-			ranges = <0x01700000 0x0 0x01700000 0x0 0x100000>,
-				 <0x02b80000 0x0 0x02b80000 0x0 0x040000>,
-				 <0x02c00000 0x0 0x02c00000 0x0 0x100000>;
+			ranges = <0x0 0x01700000 0x0 0x01700000 0x0 0x100000>,
+				 <0x0 0x02b80000 0x0 0x02b80000 0x0 0x040000>,
+				 <0x0 0x02c00000 0x0 0x02c00000 0x0 0x100000>;
 
 			/*
 			 * Bit 39 of addresses passing through the memory
@@ -752,7 +754,7 @@ mc: memory-controller@2c00000 {
 			 *
 			 * Limit the DMA range for memory clients to [38:0].
 			 */
-			dma-ranges = <0x0 0x0 0x0 0x80 0x0>;
+			dma-ranges = <0x0 0x0 0x0 0x0 0x80 0x0>;
 
 			emc: external-memory-controller@2c60000 {
 				compatible = "nvidia,tegra234-emc";
@@ -771,7 +773,7 @@ emc: external-memory-controller@2c60000 {
 
 		uarta: serial@3100000 {
 			compatible = "nvidia,tegra234-uart", "nvidia,tegra20-uart";
-			reg = <0x03100000 0x10000>;
+			reg = <0x0 0x03100000 0x0 0x10000>;
 			interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA234_CLK_UARTA>;
 			clock-names = "serial";
@@ -782,7 +784,7 @@ uarta: serial@3100000 {
 
 		gen1_i2c: i2c@3160000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x3160000 0x100>;
+			reg = <0x0 0x3160000 0x0 0x100>;
 			status = "disabled";
 			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
 			clock-frequency = <400000>;
@@ -801,7 +803,7 @@ gen1_i2c: i2c@3160000 {
 
 		cam_i2c: i2c@3180000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x3180000 0x100>;
+			reg = <0x0 0x3180000 0x0 0x100>;
 			interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clock-frequency = <400000>;
@@ -820,7 +822,7 @@ cam_i2c: i2c@3180000 {
 
 		dp_aux_ch1_i2c: i2c@3190000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x3190000 0x100>;
+			reg = <0x0 0x3190000 0x0 0x100>;
 			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clock-frequency = <100000>;
@@ -839,7 +841,7 @@ dp_aux_ch1_i2c: i2c@3190000 {
 
 		dp_aux_ch0_i2c: i2c@31b0000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x31b0000 0x100>;
+			reg = <0x0 0x31b0000 0x0 0x100>;
 			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clock-frequency = <100000>;
@@ -858,7 +860,7 @@ dp_aux_ch0_i2c: i2c@31b0000 {
 
 		dp_aux_ch2_i2c: i2c@31c0000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x31c0000 0x100>;
+			reg = <0x0 0x31c0000 0x0 0x100>;
 			interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clock-frequency = <100000>;
@@ -877,14 +879,14 @@ dp_aux_ch2_i2c: i2c@31c0000 {
 
 		uarti: serial@31d0000 {
 			compatible = "arm,sbsa-uart";
-			reg = <0x31d0000 0x10000>;
+			reg = <0x0 0x31d0000 0x0 0x10000>;
 			interrupts = <GIC_SPI 285 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 		};
 
 		dp_aux_ch3_i2c: i2c@31e0000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0x31e0000 0x100>;
+			reg = <0x0 0x31e0000 0x0 0x100>;
 			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clock-frequency = <100000>;
@@ -903,7 +905,7 @@ dp_aux_ch3_i2c: i2c@31e0000 {
 
 		spi@3270000 {
 			compatible = "nvidia,tegra234-qspi";
-			reg = <0x3270000 0x1000>;
+			reg = <0x0 0x3270000 0x0 0x1000>;
 			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -916,7 +918,7 @@ spi@3270000 {
 
 		pwm1: pwm@3280000 {
 			compatible = "nvidia,tegra234-pwm", "nvidia,tegra194-pwm";
-			reg = <0x3280000 0x10000>;
+			reg = <0x0 0x3280000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA234_CLK_PWM1>;
 			resets = <&bpmp TEGRA234_RESET_PWM1>;
 			reset-names = "pwm";
@@ -926,7 +928,7 @@ pwm1: pwm@3280000 {
 
 		pwm2: pwm@3290000 {
 			compatible = "nvidia,tegra234-pwm", "nvidia,tegra194-pwm";
-			reg = <0x3290000 0x10000>;
+			reg = <0x0 0x3290000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA234_CLK_PWM2>;
 			resets = <&bpmp TEGRA234_RESET_PWM2>;
 			reset-names = "pwm";
@@ -936,7 +938,7 @@ pwm2: pwm@3290000 {
 
 		pwm3: pwm@32a0000 {
 			compatible = "nvidia,tegra234-pwm", "nvidia,tegra194-pwm";
-			reg = <0x32a0000 0x10000>;
+			reg = <0x0 0x32a0000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA234_CLK_PWM3>;
 			resets = <&bpmp TEGRA234_RESET_PWM3>;
 			reset-names = "pwm";
@@ -946,7 +948,7 @@ pwm3: pwm@32a0000 {
 
 		pwm5: pwm@32c0000 {
 			compatible = "nvidia,tegra234-pwm", "nvidia,tegra194-pwm";
-			reg = <0x32c0000 0x10000>;
+			reg = <0x0 0x32c0000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA234_CLK_PWM5>;
 			resets = <&bpmp TEGRA234_RESET_PWM5>;
 			reset-names = "pwm";
@@ -956,7 +958,7 @@ pwm5: pwm@32c0000 {
 
 		pwm6: pwm@32d0000 {
 			compatible = "nvidia,tegra234-pwm", "nvidia,tegra194-pwm";
-			reg = <0x32d0000 0x10000>;
+			reg = <0x0 0x32d0000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA234_CLK_PWM6>;
 			resets = <&bpmp TEGRA234_RESET_PWM6>;
 			reset-names = "pwm";
@@ -966,7 +968,7 @@ pwm6: pwm@32d0000 {
 
 		pwm7: pwm@32e0000 {
 			compatible = "nvidia,tegra234-pwm", "nvidia,tegra194-pwm";
-			reg = <0x32e0000 0x10000>;
+			reg = <0x0 0x32e0000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA234_CLK_PWM7>;
 			resets = <&bpmp TEGRA234_RESET_PWM7>;
 			reset-names = "pwm";
@@ -976,7 +978,7 @@ pwm7: pwm@32e0000 {
 
 		pwm8: pwm@32f0000 {
 			compatible = "nvidia,tegra234-pwm", "nvidia,tegra194-pwm";
-			reg = <0x32f0000 0x10000>;
+			reg = <0x0 0x32f0000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA234_CLK_PWM8>;
 			resets = <&bpmp TEGRA234_RESET_PWM8>;
 			reset-names = "pwm";
@@ -986,7 +988,7 @@ pwm8: pwm@32f0000 {
 
 		spi@3300000 {
 			compatible = "nvidia,tegra234-qspi";
-			reg = <0x3300000 0x1000>;
+			reg = <0x0 0x3300000 0x0 0x1000>;
 			interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -999,7 +1001,7 @@ spi@3300000 {
 
 		mmc@3400000 {
 			compatible = "nvidia,tegra234-sdhci", "nvidia,tegra186-sdhci";
-			reg = <0x03400000 0x20000>;
+			reg = <0x0 0x03400000 0x0 0x20000>;
 			interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA234_CLK_SDMMC1>,
 				 <&bpmp TEGRA234_CLK_SDMMC_LEGACY_TM>;
@@ -1034,7 +1036,7 @@ mmc@3400000 {
 
 		mmc@3460000 {
 			compatible = "nvidia,tegra234-sdhci", "nvidia,tegra186-sdhci";
-			reg = <0x03460000 0x20000>;
+			reg = <0x0 0x03460000 0x0 0x20000>;
 			interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA234_CLK_SDMMC4>,
 				 <&bpmp TEGRA234_CLK_SDMMC_LEGACY_TM>;
@@ -1063,7 +1065,7 @@ mmc@3460000 {
 
 		hda@3510000 {
 			compatible = "nvidia,tegra234-hda";
-			reg = <0x3510000 0x10000>;
+			reg = <0x0 0x3510000 0x0 0x10000>;
 			interrupts = <GIC_SPI 60 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA234_CLK_AZA_BIT>,
 				 <&bpmp TEGRA234_CLK_AZA_2XBIT>;
@@ -1081,14 +1083,14 @@ hda@3510000 {
 
 		fuse@3810000 {
 			compatible = "nvidia,tegra234-efuse";
-			reg = <0x03810000 0x10000>;
+			reg = <0x0 0x03810000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA234_CLK_FUSE>;
 			clock-names = "fuse";
 		};
 
 		hsp_top0: hsp@3c00000 {
 			compatible = "nvidia,tegra234-hsp", "nvidia,tegra194-hsp";
-			reg = <0x03c00000 0xa0000>;
+			reg = <0x0 0x03c00000 0x0 0xa0000>;
 			interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
@@ -1106,7 +1108,7 @@ hsp_top0: hsp@3c00000 {
 
 		p2u_hsio_0: phy@3e00000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03e00000 0x10000>;
+			reg = <0x0 0x03e00000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1114,7 +1116,7 @@ p2u_hsio_0: phy@3e00000 {
 
 		p2u_hsio_1: phy@3e10000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03e10000 0x10000>;
+			reg = <0x0 0x03e10000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1122,7 +1124,7 @@ p2u_hsio_1: phy@3e10000 {
 
 		p2u_hsio_2: phy@3e20000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03e20000 0x10000>;
+			reg = <0x0 0x03e20000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1130,7 +1132,7 @@ p2u_hsio_2: phy@3e20000 {
 
 		p2u_hsio_3: phy@3e30000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03e30000 0x10000>;
+			reg = <0x0 0x03e30000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1138,7 +1140,7 @@ p2u_hsio_3: phy@3e30000 {
 
 		p2u_hsio_4: phy@3e40000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03e40000 0x10000>;
+			reg = <0x0 0x03e40000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1146,7 +1148,7 @@ p2u_hsio_4: phy@3e40000 {
 
 		p2u_hsio_5: phy@3e50000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03e50000 0x10000>;
+			reg = <0x0 0x03e50000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1154,7 +1156,7 @@ p2u_hsio_5: phy@3e50000 {
 
 		p2u_hsio_6: phy@3e60000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03e60000 0x10000>;
+			reg = <0x0 0x03e60000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1162,7 +1164,7 @@ p2u_hsio_6: phy@3e60000 {
 
 		p2u_hsio_7: phy@3e70000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03e70000 0x10000>;
+			reg = <0x0 0x03e70000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1170,7 +1172,7 @@ p2u_hsio_7: phy@3e70000 {
 
 		p2u_nvhs_0: phy@3e90000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03e90000 0x10000>;
+			reg = <0x0 0x03e90000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1178,7 +1180,7 @@ p2u_nvhs_0: phy@3e90000 {
 
 		p2u_nvhs_1: phy@3ea0000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03ea0000 0x10000>;
+			reg = <0x0 0x03ea0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1186,7 +1188,7 @@ p2u_nvhs_1: phy@3ea0000 {
 
 		p2u_nvhs_2: phy@3eb0000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03eb0000 0x10000>;
+			reg = <0x0 0x03eb0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1194,7 +1196,7 @@ p2u_nvhs_2: phy@3eb0000 {
 
 		p2u_nvhs_3: phy@3ec0000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03ec0000 0x10000>;
+			reg = <0x0 0x03ec0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1202,7 +1204,7 @@ p2u_nvhs_3: phy@3ec0000 {
 
 		p2u_nvhs_4: phy@3ed0000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03ed0000 0x10000>;
+			reg = <0x0 0x03ed0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1210,7 +1212,7 @@ p2u_nvhs_4: phy@3ed0000 {
 
 		p2u_nvhs_5: phy@3ee0000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03ee0000 0x10000>;
+			reg = <0x0 0x03ee0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1218,7 +1220,7 @@ p2u_nvhs_5: phy@3ee0000 {
 
 		p2u_nvhs_6: phy@3ef0000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03ef0000 0x10000>;
+			reg = <0x0 0x03ef0000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1226,7 +1228,7 @@ p2u_nvhs_6: phy@3ef0000 {
 
 		p2u_nvhs_7: phy@3f00000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03f00000 0x10000>;
+			reg = <0x0 0x03f00000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1234,7 +1236,7 @@ p2u_nvhs_7: phy@3f00000 {
 
 		p2u_gbe_0: phy@3f20000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03f20000 0x10000>;
+			reg = <0x0 0x03f20000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1242,7 +1244,7 @@ p2u_gbe_0: phy@3f20000 {
 
 		p2u_gbe_1: phy@3f30000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03f30000 0x10000>;
+			reg = <0x0 0x03f30000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1250,7 +1252,7 @@ p2u_gbe_1: phy@3f30000 {
 
 		p2u_gbe_2: phy@3f40000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03f40000 0x10000>;
+			reg = <0x0 0x03f40000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1258,7 +1260,7 @@ p2u_gbe_2: phy@3f40000 {
 
 		p2u_gbe_3: phy@3f50000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03f50000 0x10000>;
+			reg = <0x0 0x03f50000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1266,7 +1268,7 @@ p2u_gbe_3: phy@3f50000 {
 
 		p2u_gbe_4: phy@3f60000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03f60000 0x10000>;
+			reg = <0x0 0x03f60000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1274,7 +1276,7 @@ p2u_gbe_4: phy@3f60000 {
 
 		p2u_gbe_5: phy@3f70000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03f70000 0x10000>;
+			reg = <0x0 0x03f70000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1282,7 +1284,7 @@ p2u_gbe_5: phy@3f70000 {
 
 		p2u_gbe_6: phy@3f80000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03f80000 0x10000>;
+			reg = <0x0 0x03f80000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1290,7 +1292,7 @@ p2u_gbe_6: phy@3f80000 {
 
 		p2u_gbe_7: phy@3f90000 {
 			compatible = "nvidia,tegra234-p2u";
-			reg = <0x03f90000 0x10000>;
+			reg = <0x0 0x03f90000 0x0 0x10000>;
 			reg-names = "ctl";
 
 			#phy-cells = <0>;
@@ -1298,9 +1300,9 @@ p2u_gbe_7: phy@3f90000 {
 
 		ethernet@6800000 {
 			compatible = "nvidia,tegra234-mgbe";
-			reg = <0x06800000 0x10000>,
-			      <0x06810000 0x10000>,
-			      <0x068a0000 0x10000>;
+			reg = <0x0 0x06800000 0x0 0x10000>,
+			      <0x0 0x06810000 0x0 0x10000>,
+			      <0x0 0x068a0000 0x0 0x10000>;
 			reg-names = "hypervisor", "mac", "xpcs";
 			interrupts = <GIC_SPI 384 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "common";
@@ -1332,9 +1334,9 @@ ethernet@6800000 {
 
 		ethernet@6900000 {
 			compatible = "nvidia,tegra234-mgbe";
-			reg = <0x06900000 0x10000>,
-			      <0x06910000 0x10000>,
-			      <0x069a0000 0x10000>;
+			reg = <0x0 0x06900000 0x0 0x10000>,
+			      <0x0 0x06910000 0x0 0x10000>,
+			      <0x0 0x069a0000 0x0 0x10000>;
 			reg-names = "hypervisor", "mac", "xpcs";
 			interrupts = <GIC_SPI 392 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "common";
@@ -1366,9 +1368,9 @@ ethernet@6900000 {
 
 		ethernet@6a00000 {
 			compatible = "nvidia,tegra234-mgbe";
-			reg = <0x06a00000 0x10000>,
-			      <0x06a10000 0x10000>,
-			      <0x06aa0000 0x10000>;
+			reg = <0x0 0x06a00000 0x0 0x10000>,
+			      <0x0 0x06a10000 0x0 0x10000>,
+			      <0x0 0x06aa0000 0x0 0x10000>;
 			reg-names = "hypervisor", "mac", "xpcs";
 			interrupts = <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "common";
@@ -1400,9 +1402,9 @@ ethernet@6a00000 {
 
 		ethernet@6b00000 {
 			compatible = "nvidia,tegra234-mgbe";
-			reg = <0x06b00000 0x10000>,
-			      <0x06b10000 0x10000>,
-			      <0x06ba0000 0x10000>;
+			reg = <0x0 0x06b00000 0x0 0x10000>,
+			      <0x0 0x06b10000 0x0 0x10000>,
+			      <0x0 0x06ba0000 0x0 0x10000>;
 			reg-names = "hypervisor", "mac", "xpcs";
 			interrupts = <GIC_SPI 408 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "common";
@@ -1434,8 +1436,8 @@ ethernet@6b00000 {
 
 		smmu_niso1: iommu@8000000 {
 			compatible = "nvidia,tegra234-smmu", "nvidia,smmu-500";
-			reg = <0x8000000 0x1000000>,
-			      <0x7000000 0x1000000>;
+			reg = <0x0 0x8000000 0x0 0x1000000>,
+			      <0x0 0x7000000 0x0 0x1000000>;
 			interrupts = <GIC_SPI 238 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 242 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 238 IRQ_TYPE_LEVEL_HIGH>,
@@ -1576,21 +1578,21 @@ smmu_niso1: iommu@8000000 {
 
 		sce-fabric@b600000 {
 			compatible = "nvidia,tegra234-sce-fabric";
-			reg = <0xb600000 0x40000>;
+			reg = <0x0 0xb600000 0x0 0x40000>;
 			interrupts = <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>;
 			status = "okay";
 		};
 
 		rce-fabric@be00000 {
 			compatible = "nvidia,tegra234-rce-fabric";
-			reg = <0xbe00000 0x40000>;
+			reg = <0x0 0xbe00000 0x0 0x40000>;
 			interrupts = <GIC_SPI 175 IRQ_TYPE_LEVEL_HIGH>;
 			status = "okay";
 		};
 
 		hsp_aon: hsp@c150000 {
 			compatible = "nvidia,tegra234-hsp", "nvidia,tegra194-hsp";
-			reg = <0x0c150000 0x90000>;
+			reg = <0x0 0x0c150000 0x0 0x90000>;
 			interrupts = <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>,
@@ -1605,7 +1607,7 @@ hsp_aon: hsp@c150000 {
 
 		gen2_i2c: i2c@c240000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0xc240000 0x100>;
+			reg = <0x0 0xc240000 0x0 0x100>;
 			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clock-frequency = <100000>;
@@ -1624,7 +1626,7 @@ gen2_i2c: i2c@c240000 {
 
 		gen8_i2c: i2c@c250000 {
 			compatible = "nvidia,tegra194-i2c";
-			reg = <0xc250000 0x100>;
+			reg = <0x0 0xc250000 0x0 0x100>;
 			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clock-frequency = <400000>;
@@ -1643,7 +1645,7 @@ gen8_i2c: i2c@c250000 {
 
 		rtc@c2a0000 {
 			compatible = "nvidia,tegra234-rtc", "nvidia,tegra20-rtc";
-			reg = <0x0c2a0000 0x10000>;
+			reg = <0x0 0x0c2a0000 0x0 0x10000>;
 			interrupt-parent = <&pmc>;
 			interrupts = <73 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA234_CLK_CLK_32K>;
@@ -1654,8 +1656,8 @@ rtc@c2a0000 {
 		gpio_aon: gpio@c2f0000 {
 			compatible = "nvidia,tegra234-gpio-aon";
 			reg-names = "security", "gpio";
-			reg = <0x0c2f0000 0x1000>,
-			      <0x0c2f1000 0x1000>;
+			reg = <0x0 0x0c2f0000 0x0 0x1000>,
+			      <0x0 0x0c2f1000 0x0 0x1000>;
 			interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>,
@@ -1668,7 +1670,7 @@ gpio_aon: gpio@c2f0000 {
 
 		pwm4: pwm@c340000 {
 			compatible = "nvidia,tegra234-pwm", "nvidia,tegra194-pwm";
-			reg = <0xc340000 0x10000>;
+			reg = <0x0 0xc340000 0x0 0x10000>;
 			clocks = <&bpmp TEGRA234_CLK_PWM4>;
 			resets = <&bpmp TEGRA234_RESET_PWM4>;
 			reset-names = "pwm";
@@ -1678,11 +1680,11 @@ pwm4: pwm@c340000 {
 
 		pmc: pmc@c360000 {
 			compatible = "nvidia,tegra234-pmc";
-			reg = <0x0c360000 0x10000>,
-			      <0x0c370000 0x10000>,
-			      <0x0c380000 0x10000>,
-			      <0x0c390000 0x10000>,
-			      <0x0c3a0000 0x10000>;
+			reg = <0x0 0x0c360000 0x0 0x10000>,
+			      <0x0 0x0c370000 0x0 0x10000>,
+			      <0x0 0x0c380000 0x0 0x10000>,
+			      <0x0 0x0c390000 0x0 0x10000>,
+			      <0x0 0x0c3a0000 0x0 0x10000>;
 			reg-names = "pmc", "wake", "aotag", "scratch", "misc";
 
 			#interrupt-cells = <2>;
@@ -1711,29 +1713,36 @@ sdmmc3_1v8: sdmmc3-1v8 {
 
 		aon-fabric@c600000 {
 			compatible = "nvidia,tegra234-aon-fabric";
-			reg = <0xc600000 0x40000>;
+			reg = <0x0 0xc600000 0x0 0x40000>;
 			interrupts = <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
 			status = "okay";
 		};
 
 		bpmp-fabric@d600000 {
 			compatible = "nvidia,tegra234-bpmp-fabric";
-			reg = <0xd600000 0x40000>;
+			reg = <0x0 0xd600000 0x0 0x40000>;
 			interrupts = <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>;
 			status = "okay";
 		};
 
 		dce-fabric@de00000 {
 			compatible = "nvidia,tegra234-sce-fabric";
-			reg = <0xde00000 0x40000>;
+			reg = <0x0 0xde00000 0x0 0x40000>;
 			interrupts = <GIC_SPI 381 IRQ_TYPE_LEVEL_HIGH>;
 			status = "okay";
 		};
 
+		ccplex@e000000 {
+			compatible = "nvidia,tegra234-ccplex-cluster";
+			reg = <0x0 0x0e000000 0x0 0x5ffff>;
+			nvidia,bpmp = <&bpmp>;
+			status = "okay";
+		};
+
 		gic: interrupt-controller@f400000 {
 			compatible = "arm,gic-v3";
-			reg = <0x0f400000 0x010000>, /* GICD */
-			      <0x0f440000 0x200000>; /* GICR */
+			reg = <0x0 0x0f400000 0x0 0x010000>, /* GICD */
+			      <0x0 0x0f440000 0x0 0x200000>; /* GICR */
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 
@@ -1744,7 +1753,7 @@ gic: interrupt-controller@f400000 {
 
 		smmu_iso: iommu@10000000 {
 			compatible = "nvidia,tegra234-smmu", "nvidia,smmu-500";
-			reg = <0x10000000 0x1000000>;
+			reg = <0x0 0x10000000 0x0 0x1000000>;
 			interrupts = <GIC_SPI 240 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 240 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 240 IRQ_TYPE_LEVEL_HIGH>,
@@ -1884,8 +1893,8 @@ smmu_iso: iommu@10000000 {
 
 		smmu_niso0: iommu@12000000 {
 			compatible = "nvidia,tegra234-smmu", "nvidia,smmu-500";
-			reg = <0x12000000 0x1000000>,
-			      <0x11000000 0x1000000>;
+			reg = <0x0 0x12000000 0x0 0x1000000>,
+			      <0x0 0x11000000 0x0 0x1000000>;
 			interrupts = <GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 232 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>,
@@ -2026,771 +2035,766 @@ smmu_niso0: iommu@12000000 {
 
 		cbb-fabric@13a00000 {
 			compatible = "nvidia,tegra234-cbb-fabric";
-			reg = <0x13a00000 0x400000>;
+			reg = <0x0 0x13a00000 0x0 0x400000>;
 			interrupts = <GIC_SPI 231 IRQ_TYPE_LEVEL_HIGH>;
 			status = "okay";
 		};
-	};
 
-	ccplex@e000000 {
-		compatible = "nvidia,tegra234-ccplex-cluster";
-		reg = <0x0 0x0e000000 0x0 0x5ffff>;
-		nvidia,bpmp = <&bpmp>;
-		status = "okay";
-	};
+		pcie@140a0000 {
+			compatible = "nvidia,tegra234-pcie";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4CA>;
+			reg = <0x00 0x140a0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x2a000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x2a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x2a080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x35 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
+			reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
 
-	pcie@140a0000 {
-		compatible = "nvidia,tegra234-pcie";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4CA>;
-		reg = <0x00 0x140a0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x2a000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x2a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x2a080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x35 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
-		reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <4>;
-		num-viewport = <8>;
-		linux,pci-domain = <8>;
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <4>;
+			num-viewport = <8>;
+			linux,pci-domain = <8>;
 
-		clocks = <&bpmp TEGRA234_CLK_PEX2_C8_CORE>;
-		clock-names = "core";
+			clocks = <&bpmp TEGRA234_CLK_PEX2_C8_CORE>;
+			clock-names = "core";
 
-		resets = <&bpmp TEGRA234_RESET_PEX2_CORE_8_APB>,
-			 <&bpmp TEGRA234_RESET_PEX2_CORE_8>;
-		reset-names = "apb", "core";
+			resets = <&bpmp TEGRA234_RESET_PEX2_CORE_8_APB>,
+				 <&bpmp TEGRA234_RESET_PEX2_CORE_8>;
+			reset-names = "apb", "core";
 
-		interrupts = <GIC_SPI 356 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 357 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			interrupts = <GIC_SPI 356 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 357 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 356 IRQ_TYPE_LEVEL_HIGH>;
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 356 IRQ_TYPE_LEVEL_HIGH>;
 
-		nvidia,bpmp = <&bpmp 8>;
+			nvidia,bpmp = <&bpmp 8>;
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		bus-range = <0x0 0xff>;
+			bus-range = <0x0 0xff>;
 
-		ranges = <0x43000000 0x32 0x40000000 0x32 0x40000000 0x2 0xe8000000>, /* prefetchable memory (11904 MB) */
-			 <0x02000000 0x0  0x40000000 0x35 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
-			 <0x01000000 0x0  0x2a100000 0x00 0x2a100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
+			ranges = <0x43000000 0x32 0x40000000 0x32 0x40000000 0x2 0xe8000000>, /* prefetchable memory (11904 MB) */
+				 <0x02000000 0x0  0x40000000 0x35 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+				 <0x01000000 0x0  0x2a100000 0x00 0x2a100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE8AR &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE8AW &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE8 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE8AR &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE8AW &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE8 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-		status = "disabled";
-	};
+			status = "disabled";
+		};
 
-	pcie@140c0000 {
-		compatible = "nvidia,tegra234-pcie";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4CB>;
-		reg = <0x00 0x140c0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x2c000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x2c040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x2c080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x38 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
-		reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <4>;
-		num-viewport = <8>;
-		linux,pci-domain = <9>;
+		pcie@140c0000 {
+			compatible = "nvidia,tegra234-pcie";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4CB>;
+			reg = <0x00 0x140c0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x2c000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x2c040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x2c080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x38 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
+			reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
 
-		clocks = <&bpmp TEGRA234_CLK_PEX2_C9_CORE>;
-		clock-names = "core";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <4>;
+			num-viewport = <8>;
+			linux,pci-domain = <9>;
 
-		resets = <&bpmp TEGRA234_RESET_PEX2_CORE_9_APB>,
-			 <&bpmp TEGRA234_RESET_PEX2_CORE_9>;
-		reset-names = "apb", "core";
+			clocks = <&bpmp TEGRA234_CLK_PEX2_C9_CORE>;
+			clock-names = "core";
 
-		interrupts = <GIC_SPI 358 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 359 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			resets = <&bpmp TEGRA234_RESET_PEX2_CORE_9_APB>,
+				 <&bpmp TEGRA234_RESET_PEX2_CORE_9>;
+			reset-names = "apb", "core";
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 358 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 358 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 359 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		nvidia,bpmp = <&bpmp 9>;
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 358 IRQ_TYPE_LEVEL_HIGH>;
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			nvidia,bpmp = <&bpmp 9>;
 
-		bus-range = <0x0 0xff>;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		ranges = <0x43000000 0x35 0x40000000 0x35 0x40000000 0x2 0xc0000000>, /* prefetchable memory (11264 MB) */
-			 <0x02000000 0x0  0x40000000 0x38 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
-			 <0x01000000 0x0  0x2c100000 0x00 0x2c100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
+			bus-range = <0x0 0xff>;
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE9AR &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE9AW &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE9 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			ranges = <0x43000000 0x35 0x40000000 0x35 0x40000000 0x2 0xc0000000>, /* prefetchable memory (11264 MB) */
+				 <0x02000000 0x0  0x40000000 0x38 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+				 <0x01000000 0x0  0x2c100000 0x00 0x2c100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-		status = "disabled";
-	};
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE9AR &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE9AW &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE9 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-	pcie@140e0000 {
-		compatible = "nvidia,tegra234-pcie";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4CC>;
-		reg = <0x00 0x140e0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x2e000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x2e040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x2e080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x3b 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
-		reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <4>;
-		num-viewport = <8>;
-		linux,pci-domain = <10>;
+			status = "disabled";
+		};
 
-		clocks = <&bpmp TEGRA234_CLK_PEX2_C10_CORE>;
-		clock-names = "core";
+		pcie@140e0000 {
+			compatible = "nvidia,tegra234-pcie";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4CC>;
+			reg = <0x00 0x140e0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x2e000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x2e040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x2e080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x3b 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
+			reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
 
-		resets = <&bpmp TEGRA234_RESET_PEX2_CORE_10_APB>,
-			 <&bpmp TEGRA234_RESET_PEX2_CORE_10>;
-		reset-names = "apb", "core";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <4>;
+			num-viewport = <8>;
+			linux,pci-domain = <10>;
 
-		interrupts = <GIC_SPI 360 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 361 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			clocks = <&bpmp TEGRA234_CLK_PEX2_C10_CORE>;
+			clock-names = "core";
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 360 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&bpmp TEGRA234_RESET_PEX2_CORE_10_APB>,
+				 <&bpmp TEGRA234_RESET_PEX2_CORE_10>;
+			reset-names = "apb", "core";
 
-		nvidia,bpmp = <&bpmp 10>;
+			interrupts = <GIC_SPI 360 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 361 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 360 IRQ_TYPE_LEVEL_HIGH>;
 
-		bus-range = <0x0 0xff>;
+			nvidia,bpmp = <&bpmp 10>;
 
-		ranges = <0x43000000 0x38 0x40000000 0x38 0x40000000 0x2 0xe8000000>, /* prefetchable memory (11904 MB) */
-			 <0x02000000 0x0  0x40000000 0x3b 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
-			 <0x01000000 0x0  0x2e100000 0x00 0x2e100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE10AR &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE10AW &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE10 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			bus-range = <0x0 0xff>;
 
-		status = "disabled";
-	};
+			ranges = <0x43000000 0x38 0x40000000 0x38 0x40000000 0x2 0xe8000000>, /* prefetchable memory (11904 MB) */
+				 <0x02000000 0x0  0x40000000 0x3b 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+				 <0x01000000 0x0  0x2e100000 0x00 0x2e100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-	pcie@14100000 {
-		compatible = "nvidia,tegra234-pcie";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX1A>;
-		reg = <0x00 0x14100000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x30000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x30040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x30080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x20 0xb0000000 0x0 0x10000000>; /* ECAM (256MB)               */
-		reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <1>;
-		num-viewport = <8>;
-		linux,pci-domain = <1>;
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE10AR &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE10AW &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE10 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-		clocks = <&bpmp TEGRA234_CLK_PEX0_C1_CORE>;
-		clock-names = "core";
+			status = "disabled";
+		};
 
-		resets = <&bpmp TEGRA234_RESET_PEX0_CORE_1_APB>,
-			 <&bpmp TEGRA234_RESET_PEX0_CORE_1>;
-		reset-names = "apb", "core";
+		pcie-ep@140e0000 {
+			compatible = "nvidia,tegra234-pcie-ep";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4CC>;
+			reg = <0x00 0x140e0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x2e040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x2e080000 0x0 0x00040000>, /* DBI space (256K)           */
+			      <0x38 0x40000000 0x3 0x00000000>; /* Address Space (12G)        */
+			reg-names = "appl", "atu_dma", "dbi", "addr_space";
 
-		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			num-lanes = <4>;
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&bpmp TEGRA234_CLK_PEX2_C10_CORE>;
+			clock-names = "core";
 
-		nvidia,bpmp = <&bpmp 1>;
+			resets = <&bpmp TEGRA234_RESET_PEX2_CORE_10_APB>,
+				 <&bpmp TEGRA234_RESET_PEX2_CORE_10>;
+			reset-names = "apb", "core";
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			interrupts = <GIC_SPI 360 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
+			interrupt-names = "intr";
 
-		bus-range = <0x0 0xff>;
+			nvidia,bpmp = <&bpmp 10>;
 
-		ranges = <0x43000000 0x20 0x80000000 0x20 0x80000000 0x0 0x28000000>, /* prefetchable memory (640 MB) */
-			 <0x02000000 0x0  0x40000000 0x20 0xa8000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
-			 <0x01000000 0x0  0x30100000 0x00 0x30100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
+			nvidia,enable-ext-refclk;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE1R &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE1W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE1 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE10AR &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE10AW &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE10 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-		status = "disabled";
-	};
+			status = "disabled";
+		};
 
-	pcie@14120000 {
-		compatible = "nvidia,tegra234-pcie";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX1A>;
-		reg = <0x00 0x14120000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x32000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x32040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x32080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x20 0xf0000000 0x0 0x10000000>; /* ECAM (256MB)               */
-		reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <1>;
-		num-viewport = <8>;
-		linux,pci-domain = <2>;
+		pcie@14100000 {
+			compatible = "nvidia,tegra234-pcie";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX1A>;
+			reg = <0x00 0x14100000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x30000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x30040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x30080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x20 0xb0000000 0x0 0x10000000>; /* ECAM (256MB)               */
+			reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
 
-		clocks = <&bpmp TEGRA234_CLK_PEX0_C2_CORE>;
-		clock-names = "core";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <1>;
+			num-viewport = <8>;
+			linux,pci-domain = <1>;
 
-		resets = <&bpmp TEGRA234_RESET_PEX0_CORE_2_APB>,
-			 <&bpmp TEGRA234_RESET_PEX0_CORE_2>;
-		reset-names = "apb", "core";
+			clocks = <&bpmp TEGRA234_CLK_PEX0_C1_CORE>;
+			clock-names = "core";
 
-		interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			resets = <&bpmp TEGRA234_RESET_PEX0_CORE_1_APB>,
+				 <&bpmp TEGRA234_RESET_PEX0_CORE_1>;
+			reset-names = "apb", "core";
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		nvidia,bpmp = <&bpmp 2>;
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			nvidia,bpmp = <&bpmp 1>;
 
-		bus-range = <0x0 0xff>;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		ranges = <0x43000000 0x20 0xc0000000 0x20 0xc0000000 0x0 0x28000000>, /* prefetchable memory (640 MB) */
-			 <0x02000000 0x0  0x40000000 0x20 0xe8000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
-			 <0x01000000 0x0  0x32100000 0x00 0x32100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
+			bus-range = <0x0 0xff>;
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE2AR &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE2AW &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE2 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			ranges = <0x43000000 0x20 0x80000000 0x20 0x80000000 0x0 0x28000000>, /* prefetchable memory (640 MB) */
+				 <0x02000000 0x0  0x40000000 0x20 0xa8000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+				 <0x01000000 0x0  0x30100000 0x00 0x30100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-		status = "disabled";
-	};
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE1R &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE1W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE1 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-	pcie@14140000 {
-		compatible = "nvidia,tegra234-pcie";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX1A>;
-		reg = <0x00 0x14140000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x34000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x34040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x34080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x21 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
-		reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <1>;
-		num-viewport = <8>;
-		linux,pci-domain = <3>;
+			status = "disabled";
+		};
 
-		clocks = <&bpmp TEGRA234_CLK_PEX0_C3_CORE>;
-		clock-names = "core";
+		pcie@14120000 {
+			compatible = "nvidia,tegra234-pcie";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX1A>;
+			reg = <0x00 0x14120000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x32000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x32040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x32080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x20 0xf0000000 0x0 0x10000000>; /* ECAM (256MB)               */
+			reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
 
-		resets = <&bpmp TEGRA234_RESET_PEX0_CORE_3_APB>,
-			 <&bpmp TEGRA234_RESET_PEX0_CORE_3>;
-		reset-names = "apb", "core";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <1>;
+			num-viewport = <8>;
+			linux,pci-domain = <2>;
 
-		interrupts = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			clocks = <&bpmp TEGRA234_CLK_PEX0_C2_CORE>;
+			clock-names = "core";
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&bpmp TEGRA234_RESET_PEX0_CORE_2_APB>,
+				 <&bpmp TEGRA234_RESET_PEX0_CORE_2>;
+			reset-names = "apb", "core";
 
-		nvidia,bpmp = <&bpmp 3>;
+			interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
 
-		bus-range = <0x0 0xff>;
+			nvidia,bpmp = <&bpmp 2>;
 
-		ranges = <0x43000000 0x21 0x00000000 0x21 0x00000000 0x0 0x28000000>, /* prefetchable memory (640 MB) */
-			 <0x02000000 0x0  0x40000000 0x21 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
-			 <0x01000000 0x0  0x34100000 0x00 0x34100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE3R &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE3W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE3 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			bus-range = <0x0 0xff>;
 
-		status = "disabled";
-	};
+			ranges = <0x43000000 0x20 0xc0000000 0x20 0xc0000000 0x0 0x28000000>, /* prefetchable memory (640 MB) */
+				 <0x02000000 0x0  0x40000000 0x20 0xe8000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+				 <0x01000000 0x0  0x32100000 0x00 0x32100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-	pcie@14160000 {
-		compatible = "nvidia,tegra234-pcie";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4BB>;
-		reg = <0x00 0x14160000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x36000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x36040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x36080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x24 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
-		reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <4>;
-		num-viewport = <8>;
-		linux,pci-domain = <4>;
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE2AR &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE2AW &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE2 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-		clocks = <&bpmp TEGRA234_CLK_PEX0_C4_CORE>;
-		clock-names = "core";
+			status = "disabled";
+		};
 
-		resets = <&bpmp TEGRA234_RESET_PEX0_CORE_4_APB>,
-			 <&bpmp TEGRA234_RESET_PEX0_CORE_4>;
-		reset-names = "apb", "core";
+		pcie@14140000 {
+			compatible = "nvidia,tegra234-pcie";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX1A>;
+			reg = <0x00 0x14140000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x34000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x34040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x34080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x21 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
+			reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
 
-		interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <1>;
+			num-viewport = <8>;
+			linux,pci-domain = <3>;
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&bpmp TEGRA234_CLK_PEX0_C3_CORE>;
+			clock-names = "core";
 
-		nvidia,bpmp = <&bpmp 4>;
+			resets = <&bpmp TEGRA234_RESET_PEX0_CORE_3_APB>,
+				 <&bpmp TEGRA234_RESET_PEX0_CORE_3>;
+			reset-names = "apb", "core";
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			interrupts = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		bus-range = <0x0 0xff>;
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
 
-		ranges = <0x43000000 0x21 0x40000000 0x21 0x40000000 0x2 0xe8000000>, /* prefetchable memory (11904 MB) */
-			 <0x02000000 0x0  0x40000000 0x24 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
-			 <0x01000000 0x0  0x36100000 0x00 0x36100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
+			nvidia,bpmp = <&bpmp 3>;
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE4R &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE4W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE4 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		status = "disabled";
-	};
+			bus-range = <0x0 0xff>;
 
-	pcie@14180000 {
-		compatible = "nvidia,tegra234-pcie";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4BA>;
-		reg = <0x00 0x14180000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x38000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x38040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x38080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x27 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
-		reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <4>;
-		num-viewport = <8>;
-		linux,pci-domain = <0>;
+			ranges = <0x43000000 0x21 0x00000000 0x21 0x00000000 0x0 0x28000000>, /* prefetchable memory (640 MB) */
+				 <0x02000000 0x0  0x40000000 0x21 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+				 <0x01000000 0x0  0x34100000 0x00 0x34100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-		clocks = <&bpmp TEGRA234_CLK_PEX0_C0_CORE>;
-		clock-names = "core";
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE3R &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE3W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE3 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-		resets = <&bpmp TEGRA234_RESET_PEX0_CORE_0_APB>,
-			 <&bpmp TEGRA234_RESET_PEX0_CORE_0>;
-		reset-names = "apb", "core";
+			status = "disabled";
+		};
 
-		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+		pcie@14160000 {
+			compatible = "nvidia,tegra234-pcie";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4BB>;
+			reg = <0x00 0x14160000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x36000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x36040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x36080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x24 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
+			reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <4>;
+			num-viewport = <8>;
+			linux,pci-domain = <4>;
 
-		nvidia,bpmp = <&bpmp 0>;
+			clocks = <&bpmp TEGRA234_CLK_PEX0_C4_CORE>;
+			clock-names = "core";
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			resets = <&bpmp TEGRA234_RESET_PEX0_CORE_4_APB>,
+				 <&bpmp TEGRA234_RESET_PEX0_CORE_4>;
+			reset-names = "apb", "core";
 
-		bus-range = <0x0 0xff>;
+			interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		ranges = <0x43000000 0x24 0x40000000 0x24 0x40000000 0x2 0xe8000000>, /* prefetchable memory (11904 MB) */
-			 <0x02000000 0x0  0x40000000 0x27 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
-			 <0x01000000 0x0  0x38100000 0x00 0x38100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE0R &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE0W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE0 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			nvidia,bpmp = <&bpmp 4>;
 
-		status = "disabled";
-	};
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-	pcie@141a0000 {
-		compatible = "nvidia,tegra234-pcie";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX8A>;
-		reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x3a000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x3a080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x2b 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
-		reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <8>;
-		num-viewport = <8>;
-		linux,pci-domain = <5>;
+			bus-range = <0x0 0xff>;
 
-		clocks = <&bpmp TEGRA234_CLK_PEX1_C5_CORE>;
-		clock-names = "core";
+			ranges = <0x43000000 0x21 0x40000000 0x21 0x40000000 0x2 0xe8000000>, /* prefetchable memory (11904 MB) */
+				 <0x02000000 0x0  0x40000000 0x24 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+				 <0x01000000 0x0  0x36100000 0x00 0x36100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-		resets = <&bpmp TEGRA234_RESET_PEX1_CORE_5_APB>,
-			 <&bpmp TEGRA234_RESET_PEX1_CORE_5>;
-		reset-names = "apb", "core";
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE4R &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE4W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE4 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-		interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			status = "disabled";
+		};
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
+		pcie@14180000 {
+			compatible = "nvidia,tegra234-pcie";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4BA>;
+			reg = <0x00 0x14180000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x38000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x38040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x38080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x27 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
+			reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
 
-		nvidia,bpmp = <&bpmp 5>;
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <4>;
+			num-viewport = <8>;
+			linux,pci-domain = <0>;
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			clocks = <&bpmp TEGRA234_CLK_PEX0_C0_CORE>;
+			clock-names = "core";
 
-		bus-range = <0x0 0xff>;
+			resets = <&bpmp TEGRA234_RESET_PEX0_CORE_0_APB>,
+				 <&bpmp TEGRA234_RESET_PEX0_CORE_0>;
+			reset-names = "apb", "core";
 
-		ranges = <0x43000000 0x28 0x00000000 0x28 0x00000000 0x3 0x28000000>, /* prefetchable memory (12928 MB) */
-			 <0x02000000 0x0  0x40000000 0x2b 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
-			 <0x01000000 0x0  0x3a100000 0x00 0x3a100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
+			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE5R &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE5W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE5 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
 
-		status = "disabled";
-	};
+			nvidia,bpmp = <&bpmp 0>;
 
-	pcie@141c0000 {
-		compatible = "nvidia,tegra234-pcie";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4A>;
-		reg = <0x00 0x141c0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x3c000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x3c040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x3c080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x2e 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
-		reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <4>;
-		num-viewport = <8>;
-		linux,pci-domain = <6>;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
+
+			bus-range = <0x0 0xff>;
 
-		clocks = <&bpmp TEGRA234_CLK_PEX1_C6_CORE>;
-		clock-names = "core";
+			ranges = <0x43000000 0x24 0x40000000 0x24 0x40000000 0x2 0xe8000000>, /* prefetchable memory (11904 MB) */
+				 <0x02000000 0x0  0x40000000 0x27 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+				 <0x01000000 0x0  0x38100000 0x00 0x38100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-		resets = <&bpmp TEGRA234_RESET_PEX1_CORE_6_APB>,
-			 <&bpmp TEGRA234_RESET_PEX1_CORE_6>;
-		reset-names = "apb", "core";
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE0R &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE0W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE0 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-		interrupts = <GIC_SPI 352 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 353 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			status = "disabled";
+		};
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 352 IRQ_TYPE_LEVEL_HIGH>;
+		pcie@141a0000 {
+			compatible = "nvidia,tegra234-pcie";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX8A>;
+			reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x3a000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x3a080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x2b 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
+			reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
 
-		nvidia,bpmp = <&bpmp 6>;
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <8>;
+			num-viewport = <8>;
+			linux,pci-domain = <5>;
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			clocks = <&bpmp TEGRA234_CLK_PEX1_C5_CORE>;
+			clock-names = "core";
 
-		bus-range = <0x0 0xff>;
+			resets = <&bpmp TEGRA234_RESET_PEX1_CORE_5_APB>,
+				 <&bpmp TEGRA234_RESET_PEX1_CORE_5>;
+			reset-names = "apb", "core";
 
-		ranges = <0x43000000 0x2b 0x40000000 0x2b 0x40000000 0x2 0xe8000000>, /* prefetchable memory (11904 MB) */
-			 <0x02000000 0x0  0x40000000 0x2e 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
-			 <0x01000000 0x0  0x3c100000 0x00 0x3c100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
+			interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE6AR &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE6AW &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE6 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
 
-		status = "disabled";
-	};
+			nvidia,bpmp = <&bpmp 5>;
 
-	pcie@141e0000 {
-		compatible = "nvidia,tegra234-pcie";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX8B>;
-		reg = <0x00 0x141e0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x3e000000 0x0 0x00040000>, /* configuration space (256K) */
-		      <0x00 0x3e040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x3e080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x32 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
-		reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		device_type = "pci";
-		num-lanes = <8>;
-		num-viewport = <8>;
-		linux,pci-domain = <7>;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
+
+			bus-range = <0x0 0xff>;
 
-		clocks = <&bpmp TEGRA234_CLK_PEX2_C7_CORE>;
-		clock-names = "core";
+			ranges = <0x43000000 0x28 0x00000000 0x28 0x00000000 0x3 0x28000000>, /* prefetchable memory (12928 MB) */
+				 <0x02000000 0x0  0x40000000 0x2b 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+				 <0x01000000 0x0  0x3a100000 0x00 0x3a100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-		resets = <&bpmp TEGRA234_RESET_PEX2_CORE_7_APB>,
-			 <&bpmp TEGRA234_RESET_PEX2_CORE_7>;
-		reset-names = "apb", "core";
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE5R &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE5W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE5 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-		interrupts = <GIC_SPI 354 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
-			     <GIC_SPI 355 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
-		interrupt-names = "intr", "msi";
+			status = "disabled";
+		};
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &gic GIC_SPI 354 IRQ_TYPE_LEVEL_HIGH>;
+		pcie-ep@141a0000 {
+			compatible = "nvidia,tegra234-pcie-ep";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX8A>;
+			reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x3a080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x27 0x40000000 0x4 0x00000000>; /* Address Space (16G)        */
+			reg-names = "appl", "atu_dma", "dbi", "addr_space";
 
-		nvidia,bpmp = <&bpmp 7>;
+			num-lanes = <8>;
 
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			clocks = <&bpmp TEGRA234_CLK_PEX1_C5_CORE>;
+			clock-names = "core";
 
-		bus-range = <0x0 0xff>;
+			resets = <&bpmp TEGRA234_RESET_PEX1_CORE_5_APB>,
+				 <&bpmp TEGRA234_RESET_PEX1_CORE_5>;
+			reset-names = "apb", "core";
 
-		ranges = <0x43000000 0x30 0x00000000 0x30 0x00000000 0x2 0x28000000>, /* prefetchable memory (8832 MB) */
-			 <0x02000000 0x0  0x40000000 0x32 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
-			 <0x01000000 0x0  0x3e100000 0x00 0x3e100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
+			interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
+			interrupt-names = "intr";
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE7AR &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE7AW &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE7 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			nvidia,bpmp = <&bpmp 5>;
 
-		status = "disabled";
-	};
+			nvidia,enable-ext-refclk;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
+
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE5R &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE5W &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE5 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-	pcie-ep@141a0000 {
-		compatible = "nvidia,tegra234-pcie-ep";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX8A>;
-		reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x3a080000 0x0 0x00040000>, /* DBI reg space (256K)       */
-		      <0x27 0x40000000 0x4 0x00000000>; /* Address Space (16G)        */
-		reg-names = "appl", "atu_dma", "dbi", "addr_space";
+			status = "disabled";
+		};
 
-		num-lanes = <8>;
+		pcie@141c0000 {
+			compatible = "nvidia,tegra234-pcie";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4A>;
+			reg = <0x00 0x141c0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x3c000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x3c040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x3c080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x2e 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
+			reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
 
-		clocks = <&bpmp TEGRA234_CLK_PEX1_C5_CORE>;
-		clock-names = "core";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <4>;
+			num-viewport = <8>;
+			linux,pci-domain = <6>;
 
-		resets = <&bpmp TEGRA234_RESET_PEX1_CORE_5_APB>,
-			 <&bpmp TEGRA234_RESET_PEX1_CORE_5>;
-		reset-names = "apb", "core";
+			clocks = <&bpmp TEGRA234_CLK_PEX1_C6_CORE>;
+			clock-names = "core";
 
-		interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
-		interrupt-names = "intr";
+			resets = <&bpmp TEGRA234_RESET_PEX1_CORE_6_APB>,
+				 <&bpmp TEGRA234_RESET_PEX1_CORE_6>;
+			reset-names = "apb", "core";
 
-		nvidia,bpmp = <&bpmp 5>;
+			interrupts = <GIC_SPI 352 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 353 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-		nvidia,enable-ext-refclk;
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 352 IRQ_TYPE_LEVEL_HIGH>;
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE5R &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE5W &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE5 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			nvidia,bpmp = <&bpmp 6>;
 
-		status = "disabled";
-	};
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-	pcie-ep@141c0000{
-		compatible = "nvidia,tegra234-pcie-ep";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4A>;
-		reg = <0x00 0x141c0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x3c040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x3c080000 0x0 0x00040000>, /* DBI space (256K)           */
-		      <0x2b 0x40000000 0x3 0x00000000>; /* Address Space (12G)        */
-		reg-names = "appl", "atu_dma", "dbi", "addr_space";
+			bus-range = <0x0 0xff>;
 
-		num-lanes = <4>;
+			ranges = <0x43000000 0x2b 0x40000000 0x2b 0x40000000 0x2 0xe8000000>, /* prefetchable memory (11904 MB) */
+				 <0x02000000 0x0  0x40000000 0x2e 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+				 <0x01000000 0x0  0x3c100000 0x00 0x3c100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-		clocks = <&bpmp TEGRA234_CLK_PEX1_C6_CORE>;
-		clock-names = "core";
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE6AR &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE6AW &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE6 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-		resets = <&bpmp TEGRA234_RESET_PEX1_CORE_6_APB>,
-			 <&bpmp TEGRA234_RESET_PEX1_CORE_6>;
-		reset-names = "apb", "core";
+			status = "disabled";
+		};
 
-		interrupts = <GIC_SPI 352 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
-		interrupt-names = "intr";
+		pcie-ep@141c0000 {
+			compatible = "nvidia,tegra234-pcie-ep";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4A>;
+			reg = <0x00 0x141c0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x3c040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x3c080000 0x0 0x00040000>, /* DBI space (256K)           */
+			      <0x2b 0x40000000 0x3 0x00000000>; /* Address Space (12G)        */
+			reg-names = "appl", "atu_dma", "dbi", "addr_space";
 
-		nvidia,bpmp = <&bpmp 6>;
+			num-lanes = <4>;
 
-		nvidia,enable-ext-refclk;
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			clocks = <&bpmp TEGRA234_CLK_PEX1_C6_CORE>;
+			clock-names = "core";
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE6AR &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE6AW &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE6 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			resets = <&bpmp TEGRA234_RESET_PEX1_CORE_6_APB>,
+				 <&bpmp TEGRA234_RESET_PEX1_CORE_6>;
+			reset-names = "apb", "core";
 
-		status = "disabled";
-	};
+			interrupts = <GIC_SPI 352 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
+			interrupt-names = "intr";
 
-	pcie-ep@141e0000{
-		compatible = "nvidia,tegra234-pcie-ep";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX8B>;
-		reg = <0x00 0x141e0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x3e040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x3e080000 0x0 0x00040000>, /* DBI space (256K)           */
-		      <0x2e 0x40000000 0x4 0x00000000>; /* Address Space (16G)        */
-		reg-names = "appl", "atu_dma", "dbi", "addr_space";
+			nvidia,bpmp = <&bpmp 6>;
 
-		num-lanes = <8>;
+			nvidia,enable-ext-refclk;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		clocks = <&bpmp TEGRA234_CLK_PEX2_C7_CORE>;
-		clock-names = "core";
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE6AR &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE6AW &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso0 TEGRA234_SID_PCIE6 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-		resets = <&bpmp TEGRA234_RESET_PEX2_CORE_7_APB>,
-			 <&bpmp TEGRA234_RESET_PEX2_CORE_7>;
-		reset-names = "apb", "core";
+			status = "disabled";
+		};
 
-		interrupts = <GIC_SPI 354 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
-		interrupt-names = "intr";
+		pcie@141e0000 {
+			compatible = "nvidia,tegra234-pcie";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX8B>;
+			reg = <0x00 0x141e0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x3e000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x3e040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x3e080000 0x0 0x00040000>, /* DBI reg space (256K)       */
+			      <0x32 0x30000000 0x0 0x10000000>; /* ECAM (256MB)               */
+			reg-names = "appl", "config", "atu_dma", "dbi", "ecam";
 
-		nvidia,bpmp = <&bpmp 7>;
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			num-lanes = <8>;
+			num-viewport = <8>;
+			linux,pci-domain = <7>;
 
-		nvidia,enable-ext-refclk;
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			clocks = <&bpmp TEGRA234_CLK_PEX2_C7_CORE>;
+			clock-names = "core";
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE7AR &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE7AW &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE7 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+			resets = <&bpmp TEGRA234_RESET_PEX2_CORE_7_APB>,
+				 <&bpmp TEGRA234_RESET_PEX2_CORE_7>;
+			reset-names = "apb", "core";
 
-		status = "disabled";
-	};
+			interrupts = <GIC_SPI 354 IRQ_TYPE_LEVEL_HIGH>, /* controller interrupt */
+				     <GIC_SPI 355 IRQ_TYPE_LEVEL_HIGH>; /* MSI interrupt */
+			interrupt-names = "intr", "msi";
 
-	pcie-ep@140e0000{
-		compatible = "nvidia,tegra234-pcie-ep";
-		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4CC>;
-		reg = <0x00 0x140e0000 0x0 0x00020000>, /* appl registers (128K)      */
-		      <0x00 0x2e040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-		      <0x00 0x2e080000 0x0 0x00040000>, /* DBI space (256K)           */
-		      <0x38 0x40000000 0x3 0x00000000>; /* Address Space (12G)        */
-		reg-names = "appl", "atu_dma", "dbi", "addr_space";
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0 0 0 0 &gic GIC_SPI 354 IRQ_TYPE_LEVEL_HIGH>;
 
-		num-lanes = <4>;
+			nvidia,bpmp = <&bpmp 7>;
 
-		clocks = <&bpmp TEGRA234_CLK_PEX2_C10_CORE>;
-		clock-names = "core";
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
 
-		resets = <&bpmp TEGRA234_RESET_PEX2_CORE_10_APB>,
-			 <&bpmp TEGRA234_RESET_PEX2_CORE_10>;
-		reset-names = "apb", "core";
+			bus-range = <0x0 0xff>;
 
-		interrupts = <GIC_SPI 360 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
-		interrupt-names = "intr";
+			ranges = <0x43000000 0x30 0x00000000 0x30 0x00000000 0x2 0x28000000>, /* prefetchable memory (8832 MB) */
+				 <0x02000000 0x0  0x40000000 0x32 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+				 <0x01000000 0x0  0x3e100000 0x00 0x3e100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-		nvidia,bpmp = <&bpmp 10>;
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE7AR &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE7AW &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE7 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
 
-		nvidia,enable-ext-refclk;
-		nvidia,aspm-cmrt-us = <60>;
-		nvidia,aspm-pwr-on-t-us = <20>;
-		nvidia,aspm-l0s-entrance-latency-us = <3>;
+			status = "disabled";
+		};
 
-		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE10AR &emc>,
-				<&mc TEGRA234_MEMORY_CLIENT_PCIE10AW &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE10 0x1000>;
-		iommu-map-mask = <0x0>;
-		dma-coherent;
+		pcie-ep@141e0000 {
+			compatible = "nvidia,tegra234-pcie-ep";
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX8B>;
+			reg = <0x00 0x141e0000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x3e040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x3e080000 0x0 0x00040000>, /* DBI space (256K)           */
+			      <0x2e 0x40000000 0x4 0x00000000>; /* Address Space (16G)        */
+			reg-names = "appl", "atu_dma", "dbi", "addr_space";
 
-		status = "disabled";
+			num-lanes = <8>;
+
+			clocks = <&bpmp TEGRA234_CLK_PEX2_C7_CORE>;
+			clock-names = "core";
+
+			resets = <&bpmp TEGRA234_RESET_PEX2_CORE_7_APB>,
+				 <&bpmp TEGRA234_RESET_PEX2_CORE_7>;
+			reset-names = "apb", "core";
+
+			interrupts = <GIC_SPI 354 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
+			interrupt-names = "intr";
+
+			nvidia,bpmp = <&bpmp 7>;
+
+			nvidia,enable-ext-refclk;
+			nvidia,aspm-cmrt-us = <60>;
+			nvidia,aspm-pwr-on-t-us = <20>;
+			nvidia,aspm-l0s-entrance-latency-us = <3>;
+
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE7AR &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_PCIE7AW &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommu-map = <0x0 &smmu_niso1 TEGRA234_SID_PCIE7 0x1000>;
+			iommu-map-mask = <0x0>;
+			dma-coherent;
+
+			status = "disabled";
+		};
 	};
 
 	sram@40000000 {
 		compatible = "nvidia,tegra234-sysram", "mmio-sram";
 		reg = <0x0 0x40000000 0x0 0x80000>;
+
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0x40000000 0x80000>;
+
 		no-memory-wc;
 
 		cpu_bpmp_tx: sram@70000 {
-- 
2.39.2



