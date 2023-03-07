Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B486AE868
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjCGRPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCGRP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:15:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C91E97B67
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:10:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C9DCB8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815E2C433D2;
        Tue,  7 Mar 2023 17:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209030;
        bh=jj21DAyPRCNy6esFoF8o0t+XuVnFWf67WDza50GHmuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbAe7uBYZwZaCYCKsGnjZos2uldV1T2RcyIufuwCeUd4bJtVFD0TbpY5dRbhDIdk1
         Z4wjbkIMyP3e0g0absBcUqlZWwCmUQCKWdVCmV5zh8keChfQHzyOYkoiNClkOwLINF
         vELoOkae2VkzaNkJgjX5KkRTgt3bAPN/Ew0St0SQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0086/1001] arm64: tegra: Sort nodes by unit-address, then alphabetically
Date:   Tue,  7 Mar 2023 17:47:38 +0100
Message-Id: <20230307170025.861064226@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 79ed18d9ece474c15a2578e1cc5bfb4fce7a8eb7 ]

Nodes in device tree should be sorted by unit-address, followed by nodes
without a unit-address, sorted alphabetically. Some exceptions are the
top-level aliases, chosen, firmware, memory and reserved-memory nodes,
which are expected to come first.

These rules apply recursively with some exceptions, such as pinmux nodes
or regulator nodes, which often follow more complicated ordering (often
by "importance").

While at it, change the name of some of the nodes to follow standard
naming conventions, which helps with the sorting order and reduces the
amount of warnings from the DT validation tools.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Stable-dep-of: 361238cdc525 ("arm64: tegra: Mark host1x as dma-coherent on Tegra194/234")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/nvidia/tegra132-norrin.dts |   16 +-
 arch/arm64/boot/dts/nvidia/tegra132.dtsi      |  232 +-
 .../boot/dts/nvidia/tegra186-p2771-0000.dts   | 2564 ++++++++---------
 .../arm64/boot/dts/nvidia/tegra186-p3310.dtsi |   86 +-
 .../nvidia/tegra186-p3509-0000+p3636-0001.dts | 1730 +++++------
 arch/arm64/boot/dts/nvidia/tegra186.dtsi      |  470 +--
 .../arm64/boot/dts/nvidia/tegra194-p2888.dtsi |   36 +-
 .../boot/dts/nvidia/tegra194-p2972-0000.dts   | 2322 +++++++--------
 .../boot/dts/nvidia/tegra194-p3509-0000.dtsi  | 2435 ++++++++--------
 .../arm64/boot/dts/nvidia/tegra194-p3668.dtsi |   36 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi      |  519 ++--
 .../arm64/boot/dts/nvidia/tegra210-p2180.dtsi |   66 +-
 .../boot/dts/nvidia/tegra210-p2371-2180.dts   |  278 +-
 .../arm64/boot/dts/nvidia/tegra210-p2595.dtsi |    3 +
 .../arm64/boot/dts/nvidia/tegra210-p2597.dtsi |    3 +
 .../arm64/boot/dts/nvidia/tegra210-p2894.dtsi |   86 +-
 .../boot/dts/nvidia/tegra210-p3450-0000.dts   |  384 +--
 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts |   66 +-
 arch/arm64/boot/dts/nvidia/tegra210.dtsi      |  310 +-
 .../boot/dts/nvidia/tegra234-p3701-0000.dtsi  |   70 +-
 .../nvidia/tegra234-p3737-0000+p3701-0000.dts | 2486 ++++++++--------
 arch/arm64/boot/dts/nvidia/tegra234.dtsi      |  390 +--
 22 files changed, 7297 insertions(+), 7291 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra132-norrin.dts b/arch/arm64/boot/dts/nvidia/tegra132-norrin.dts
index 3e8dee85d55f2..d4c034ac12447 100644
--- a/arch/arm64/boot/dts/nvidia/tegra132-norrin.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra132-norrin.dts
@@ -1030,6 +1030,14 @@ clk32k_in: clock-32k {
 	gpio-keys {
 		compatible = "gpio-keys";
 
+		key-power {
+			label = "Power";
+			gpios = <&gpio TEGRA_GPIO(Q, 0) GPIO_ACTIVE_LOW>;
+			linux,code = <KEY_POWER>;
+			debounce-interval = <10>;
+			wakeup-source;
+		};
+
 		switch-lid {
 			label = "Lid";
 			gpios = <&gpio TEGRA_GPIO(R, 4) GPIO_ACTIVE_LOW>;
@@ -1038,14 +1046,6 @@ switch-lid {
 			debounce-interval = <1>;
 			wakeup-source;
 		};
-
-		key-power {
-			label = "Power";
-			gpios = <&gpio TEGRA_GPIO(Q, 0) GPIO_ACTIVE_LOW>;
-			linux,code = <KEY_POWER>;
-			debounce-interval = <10>;
-			wakeup-source;
-		};
 	};
 
 	panel: panel {
diff --git a/arch/arm64/boot/dts/nvidia/tegra132.dtsi b/arch/arm64/boot/dts/nvidia/tegra132.dtsi
index 858fc01cecb69..c017764bc27e9 100644
--- a/arch/arm64/boot/dts/nvidia/tegra132.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra132.dtsi
@@ -893,122 +893,6 @@ throttle_heavy: heavy {
 		};
 	};
 
-	thermal-zones {
-		cpu-thermal {
-			polling-delay-passive = <1000>;
-			polling-delay = <0>;
-
-			thermal-sensors =
-				<&soctherm TEGRA124_SOCTHERM_SENSOR_CPU>;
-
-			trips {
-				cpu_shutdown_trip {
-					temperature = <105000>;
-					hysteresis = <1000>;
-					type = "critical";
-				};
-
-				cpu_throttle_trip: throttle-trip {
-					temperature = <102000>;
-					hysteresis = <1000>;
-					type = "hot";
-				};
-			};
-
-			cooling-maps {
-				map0 {
-					trip = <&cpu_throttle_trip>;
-					cooling-device = <&throttle_heavy 1 1>;
-				};
-			};
-		};
-
-		mem-thermal {
-			polling-delay-passive = <0>;
-			polling-delay = <0>;
-
-			thermal-sensors =
-				<&soctherm TEGRA124_SOCTHERM_SENSOR_MEM>;
-
-			trips {
-				mem_shutdown_trip {
-					temperature = <101000>;
-					hysteresis = <1000>;
-					type = "critical";
-				};
-				mem_throttle_trip {
-					temperature = <99000>;
-					hysteresis = <1000>;
-					type = "hot";
-				};
-			};
-
-			cooling-maps {
-				/*
-				 * There are currently no cooling maps,
-				 * because there are no cooling devices.
-				 */
-			};
-		};
-
-		gpu-thermal {
-			polling-delay-passive = <1000>;
-			polling-delay = <0>;
-
-			thermal-sensors =
-				<&soctherm TEGRA124_SOCTHERM_SENSOR_GPU>;
-
-			trips {
-				gpu_shutdown_trip {
-					temperature = <101000>;
-					hysteresis = <1000>;
-					type = "critical";
-				};
-
-				gpu_throttle_trip: throttle-trip {
-					temperature = <99000>;
-					hysteresis = <1000>;
-					type = "hot";
-				};
-			};
-
-			cooling-maps {
-				map0 {
-					trip = <&gpu_throttle_trip>;
-					cooling-device = <&throttle_heavy 1 1>;
-				};
-			};
-		};
-
-		pllx-thermal {
-			polling-delay-passive = <0>;
-			polling-delay = <0>;
-
-			thermal-sensors =
-				<&soctherm TEGRA124_SOCTHERM_SENSOR_PLLX>;
-
-			trips {
-				pllx_shutdown_trip {
-					temperature = <105000>;
-					hysteresis = <1000>;
-					type = "critical";
-				};
-				pllx_throttle_trip {
-					temperature = <99000>;
-					hysteresis = <1000>;
-					type = "hot";
-				};
-			};
-
-			cooling-maps {
-				/*
-				 * There are currently no cooling maps,
-				 * because there are no cooling devices.
-				 */
-			};
-		};
-	};
-
 	ahub@70300000 {
 		compatible = "nvidia,tegra124-ahub";
 		reg = <0x0 0x70300000 0x0 0x200>,
@@ -1255,6 +1139,122 @@ cpu@1 {
 		};
 	};
 
+	thermal-zones {
+		cpu-thermal {
+			polling-delay-passive = <1000>;
+			polling-delay = <0>;
+
+			thermal-sensors =
+				<&soctherm TEGRA124_SOCTHERM_SENSOR_CPU>;
+
+			trips {
+				cpu_shutdown_trip {
+					temperature = <105000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+
+				cpu_throttle_trip: throttle-trip {
+					temperature = <102000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+
+			cooling-maps {
+				map0 {
+					trip = <&cpu_throttle_trip>;
+					cooling-device = <&throttle_heavy 1 1>;
+				};
+			};
+		};
+
+		mem-thermal {
+			polling-delay-passive = <0>;
+			polling-delay = <0>;
+
+			thermal-sensors =
+				<&soctherm TEGRA124_SOCTHERM_SENSOR_MEM>;
+
+			trips {
+				mem_shutdown_trip {
+					temperature = <101000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+				mem_throttle_trip {
+					temperature = <99000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+
+			cooling-maps {
+				/*
+				 * There are currently no cooling maps,
+				 * because there are no cooling devices.
+				 */
+			};
+		};
+
+		gpu-thermal {
+			polling-delay-passive = <1000>;
+			polling-delay = <0>;
+
+			thermal-sensors =
+				<&soctherm TEGRA124_SOCTHERM_SENSOR_GPU>;
+
+			trips {
+				gpu_shutdown_trip {
+					temperature = <101000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+
+				gpu_throttle_trip: throttle-trip {
+					temperature = <99000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+
+			cooling-maps {
+				map0 {
+					trip = <&gpu_throttle_trip>;
+					cooling-device = <&throttle_heavy 1 1>;
+				};
+			};
+		};
+
+		pllx-thermal {
+			polling-delay-passive = <0>;
+			polling-delay = <0>;
+
+			thermal-sensors =
+				<&soctherm TEGRA124_SOCTHERM_SENSOR_PLLX>;
+
+			trips {
+				pllx_shutdown_trip {
+					temperature = <105000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+				pllx_throttle_trip {
+					temperature = <99000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+
+			cooling-maps {
+				/*
+				 * There are currently no cooling maps,
+				 * because there are no cooling devices.
+				 */
+			};
+		};
+	};
+
 	timer {
 		compatible = "arm,armv7-timer";
 		interrupts = <GIC_PPI 13
diff --git a/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts b/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts
index 47cf2013afcc3..15aa49fc45039 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts
@@ -13,922 +13,984 @@ / {
 	aconnect@2900000 {
 		status = "okay";
 
-		dma-controller@2930000 {
-			status = "okay";
-		};
-
-		interrupt-controller@2a40000 {
-			status = "okay";
-		};
-
 		ahub@2900800 {
 			status = "okay";
 
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
+			i2s@2901000 {
+				status = "okay";
 
-				port@0 {
-					reg = <0x0>;
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-					xbar_admaif0_ep: endpoint {
-						remote-endpoint = <&admaif0_ep>;
+					port@0 {
+						reg = <0>;
+
+						i2s1_cif_ep: endpoint {
+							remote-endpoint = <&xbar_i2s1_ep>;
+						};
 					};
-				};
 
-				port@1 {
-					reg = <0x1>;
+					i2s1_port: port@1 {
+						reg = <1>;
 
-					xbar_admaif1_ep: endpoint {
-						remote-endpoint = <&admaif1_ep>;
+						i2s1_dap_ep: endpoint {
+							dai-format = "i2s";
+							/* Placeholder for external Codec */
+						};
 					};
 				};
+			};
 
-				port@2 {
-					reg = <0x2>;
+			i2s@2901100 {
+				status = "okay";
 
-					xbar_admaif2_ep: endpoint {
-						remote-endpoint = <&admaif2_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				port@3 {
-					reg = <0x3>;
+					port@0 {
+						reg = <0>;
 
-					xbar_admaif3_ep: endpoint {
-						remote-endpoint = <&admaif3_ep>;
+						i2s2_cif_ep: endpoint {
+							remote-endpoint = <&xbar_i2s2_ep>;
+						};
 					};
-				};
 
-				port@4 {
-					reg = <0x4>;
+					i2s2_port: port@1 {
+						reg = <1>;
 
-					xbar_admaif4_ep: endpoint {
-						remote-endpoint = <&admaif4_ep>;
+						i2s2_dap_ep: endpoint {
+							dai-format = "i2s";
+							/* Placeholder for external Codec */
+						};
 					};
 				};
+			};
 
-				port@5 {
-					reg = <0x5>;
+			i2s@2901200 {
+				status = "okay";
 
-					xbar_admaif5_ep: endpoint {
-						remote-endpoint = <&admaif5_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				port@6 {
-					reg = <0x6>;
+					port@0 {
+						reg = <0>;
 
-					xbar_admaif6_ep: endpoint {
-						remote-endpoint = <&admaif6_ep>;
+						i2s3_cif_ep: endpoint {
+							remote-endpoint = <&xbar_i2s3_ep>;
+						};
 					};
-				};
 
-				port@7 {
-					reg = <0x7>;
+					i2s3_port: port@1 {
+						reg = <1>;
 
-					xbar_admaif7_ep: endpoint {
-						remote-endpoint = <&admaif7_ep>;
+						i2s3_dap_ep: endpoint {
+							dai-format = "i2s";
+							/* Placeholder for external Codec */
+						};
 					};
 				};
+			};
 
-				port@8 {
-					reg = <0x8>;
+			i2s@2901300 {
+				status = "okay";
 
-					xbar_admaif8_ep: endpoint {
-						remote-endpoint = <&admaif8_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				port@9 {
-					reg = <0x9>;
+					port@0 {
+						reg = <0>;
 
-					xbar_admaif9_ep: endpoint {
-						remote-endpoint = <&admaif9_ep>;
+						i2s4_cif_ep: endpoint {
+							remote-endpoint = <&xbar_i2s4_ep>;
+						};
 					};
-				};
 
-				port@a {
-					reg = <0xa>;
+					i2s4_port: port@1 {
+						reg = <1>;
 
-					xbar_admaif10_ep: endpoint {
-						remote-endpoint = <&admaif10_ep>;
+						i2s4_dap_ep: endpoint {
+							dai-format = "i2s";
+							/* Placeholder for external Codec */
+						};
 					};
 				};
+			};
 
-				port@b {
-					reg = <0xb>;
+			i2s@2901400 {
+				status = "okay";
 
-					xbar_admaif11_ep: endpoint {
-						remote-endpoint = <&admaif11_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				port@c {
-					reg = <0xc>;
+					port@0 {
+						reg = <0>;
 
-					xbar_admaif12_ep: endpoint {
-						remote-endpoint = <&admaif12_ep>;
+						i2s5_cif_ep: endpoint {
+							remote-endpoint = <&xbar_i2s5_ep>;
+						};
 					};
-				};
 
-				port@d {
-					reg = <0xd>;
+					i2s5_port: port@1 {
+						reg = <1>;
 
-					xbar_admaif13_ep: endpoint {
-						remote-endpoint = <&admaif13_ep>;
+						i2s5_dap_ep: endpoint {
+							dai-format = "i2s";
+							/* Placeholder for external Codec */
+						};
 					};
 				};
+			};
 
-				port@e {
-					reg = <0xe>;
+			i2s@2901500 {
+				status = "okay";
 
-					xbar_admaif14_ep: endpoint {
-						remote-endpoint = <&admaif14_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				port@f {
-					reg = <0xf>;
+					port@0 {
+						reg = <0>;
 
-					xbar_admaif15_ep: endpoint {
-						remote-endpoint = <&admaif15_ep>;
+						i2s6_cif_ep: endpoint {
+							remote-endpoint = <&xbar_i2s6_ep>;
+						};
 					};
-				};
 
-				port@10 {
-					reg = <0x10>;
+					i2s6_port: port@1 {
+						reg = <1>;
 
-					xbar_admaif16_ep: endpoint {
-						remote-endpoint = <&admaif16_ep>;
+						i2s6_dap_ep: endpoint {
+							dai-format = "i2s";
+							/* Placeholder for external Codec */
+						};
 					};
 				};
+			};
 
-				port@11 {
-					reg = <0x11>;
+			sfc@2902000 {
+				status = "okay";
 
-					xbar_admaif17_ep: endpoint {
-						remote-endpoint = <&admaif17_ep>;
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						sfc1_cif_in_ep: endpoint {
+							remote-endpoint = <&xbar_sfc1_in_ep>;
+							convert-rate = <44100>;
+						};
 					};
-				};
 
-				port@12 {
-					reg = <0x12>;
+					sfc1_out_port: port@1 {
+						reg = <1>;
 
-					xbar_admaif18_ep: endpoint {
-						remote-endpoint = <&admaif18_ep>;
+						sfc1_cif_out_ep: endpoint {
+							remote-endpoint = <&xbar_sfc1_out_ep>;
+							convert-rate = <48000>;
+						};
 					};
 				};
+			};
 
-				port@13 {
-					reg = <0x13>;
+			sfc@2902200 {
+				status = "okay";
 
-					xbar_admaif19_ep: endpoint {
-						remote-endpoint = <&admaif19_ep>;
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						sfc2_cif_in_ep: endpoint {
+							remote-endpoint = <&xbar_sfc2_in_ep>;
+						};
 					};
-				};
 
-				xbar_i2s1_port: port@14 {
-					reg = <0x14>;
+					sfc2_out_port: port@1 {
+						reg = <1>;
 
-					xbar_i2s1_ep: endpoint {
-						remote-endpoint = <&i2s1_cif_ep>;
+						sfc2_cif_out_ep: endpoint {
+							remote-endpoint = <&xbar_sfc2_out_ep>;
+						};
 					};
 				};
+			};
+
+			sfc@2902400 {
+				status = "okay";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_i2s2_port: port@15 {
-					reg = <0x15>;
+					port@0 {
+						reg = <0>;
 
-					xbar_i2s2_ep: endpoint {
-						remote-endpoint = <&i2s2_cif_ep>;
+						sfc3_cif_in_ep: endpoint {
+							remote-endpoint = <&xbar_sfc3_in_ep>;
+						};
 					};
-				};
 
-				xbar_i2s3_port: port@16 {
-					reg = <0x16>;
+					sfc3_out_port: port@1 {
+						reg = <1>;
 
-					xbar_i2s3_ep: endpoint {
-						remote-endpoint = <&i2s3_cif_ep>;
+						sfc3_cif_out_ep: endpoint {
+							remote-endpoint = <&xbar_sfc3_out_ep>;
+						};
 					};
 				};
+			};
 
-				xbar_i2s4_port: port@17 {
-					reg = <0x17>;
+			sfc@2902600 {
+				status = "okay";
 
-					xbar_i2s4_ep: endpoint {
-						remote-endpoint = <&i2s4_cif_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_i2s5_port: port@18 {
-					reg = <0x18>;
+					port@0 {
+						reg = <0>;
 
-					xbar_i2s5_ep: endpoint {
-						remote-endpoint = <&i2s5_cif_ep>;
+						sfc4_cif_in_ep: endpoint {
+							remote-endpoint = <&xbar_sfc4_in_ep>;
+						};
 					};
-				};
 
-				xbar_i2s6_port: port@19 {
-					reg = <0x19>;
+					sfc4_out_port: port@1 {
+						reg = <1>;
 
-					xbar_i2s6_ep: endpoint {
-						remote-endpoint = <&i2s6_cif_ep>;
+						sfc4_cif_out_ep: endpoint {
+							remote-endpoint = <&xbar_sfc4_out_ep>;
+						};
 					};
 				};
+			};
 
-				xbar_dmic1_port: port@1a {
-					reg = <0x1a>;
+			amx@2903000 {
+				status = "okay";
 
-					xbar_dmic1_ep: endpoint {
-						remote-endpoint = <&dmic1_cif_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_dmic2_port: port@1b {
-					reg = <0x1b>;
+					port@0 {
+						reg = <0>;
 
-					xbar_dmic2_ep: endpoint {
-						remote-endpoint = <&dmic2_cif_ep>;
+						amx1_in1_ep: endpoint {
+							remote-endpoint = <&xbar_amx1_in1_ep>;
+						};
 					};
-				};
 
-				xbar_dmic3_port: port@1c {
-					reg = <0x1c>;
+					port@1 {
+						reg = <1>;
 
-					xbar_dmic3_ep: endpoint {
-						remote-endpoint = <&dmic3_cif_ep>;
+						amx1_in2_ep: endpoint {
+							remote-endpoint = <&xbar_amx1_in2_ep>;
+						};
 					};
-				};
 
-				xbar_dspk1_port: port@1e {
-					reg = <0x1e>;
+					port@2 {
+						reg = <2>;
 
-					xbar_dspk1_ep: endpoint {
-						remote-endpoint = <&dspk1_cif_ep>;
+						amx1_in3_ep: endpoint {
+							remote-endpoint = <&xbar_amx1_in3_ep>;
+						};
 					};
-				};
 
-				xbar_dspk2_port: port@1f {
-					reg = <0x1f>;
+					port@3 {
+						reg = <3>;
 
-					xbar_dspk2_ep: endpoint {
-						remote-endpoint = <&dspk2_cif_ep>;
+						amx1_in4_ep: endpoint {
+							remote-endpoint = <&xbar_amx1_in4_ep>;
+						};
 					};
-				};
 
-				xbar_sfc1_in_port: port@20 {
-					reg = <0x20>;
+					amx1_out_port: port@4 {
+						reg = <4>;
 
-					xbar_sfc1_in_ep: endpoint {
-						remote-endpoint = <&sfc1_cif_in_ep>;
+						amx1_out_ep: endpoint {
+							remote-endpoint = <&xbar_amx1_out_ep>;
+						};
 					};
 				};
+			};
 
-				port@21 {
-					reg = <0x21>;
+			amx@2903100 {
+				status = "okay";
 
-					xbar_sfc1_out_ep: endpoint {
-						remote-endpoint = <&sfc1_cif_out_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_sfc2_in_port: port@22 {
-					reg = <0x22>;
+					port@0 {
+						reg = <0>;
 
-					xbar_sfc2_in_ep: endpoint {
-						remote-endpoint = <&sfc2_cif_in_ep>;
+						amx2_in1_ep: endpoint {
+							remote-endpoint = <&xbar_amx2_in1_ep>;
+						};
 					};
-				};
 
-				port@23 {
-					reg = <0x23>;
+					port@1 {
+						reg = <1>;
 
-					xbar_sfc2_out_ep: endpoint {
-						remote-endpoint = <&sfc2_cif_out_ep>;
+						amx2_in2_ep: endpoint {
+							remote-endpoint = <&xbar_amx2_in2_ep>;
+						};
 					};
-				};
 
-				xbar_sfc3_in_port: port@24 {
-					reg = <0x24>;
+					amx2_in3_port: port@2 {
+						reg = <2>;
 
-					xbar_sfc3_in_ep: endpoint {
-						remote-endpoint = <&sfc3_cif_in_ep>;
+						amx2_in3_ep: endpoint {
+							remote-endpoint = <&xbar_amx2_in3_ep>;
+						};
 					};
-				};
 
-				port@25 {
-					reg = <0x25>;
+					amx2_in4_port: port@3 {
+						reg = <3>;
 
-					xbar_sfc3_out_ep: endpoint {
-						remote-endpoint = <&sfc3_cif_out_ep>;
+						amx2_in4_ep: endpoint {
+							remote-endpoint = <&xbar_amx2_in4_ep>;
+						};
 					};
-				};
 
-				xbar_sfc4_in_port: port@26 {
-					reg = <0x26>;
+					amx2_out_port: port@4 {
+						reg = <4>;
 
-					xbar_sfc4_in_ep: endpoint {
-						remote-endpoint = <&sfc4_cif_in_ep>;
+						amx2_out_ep: endpoint {
+							remote-endpoint = <&xbar_amx2_out_ep>;
+						};
 					};
 				};
+			};
 
-				port@27 {
-					reg = <0x27>;
+			amx@2903200 {
+				status = "okay";
 
-					xbar_sfc4_out_ep: endpoint {
-						remote-endpoint = <&sfc4_cif_out_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_mvc1_in_port: port@28 {
-					reg = <0x28>;
+					port@0 {
+						reg = <0>;
 
-					xbar_mvc1_in_ep: endpoint {
-						remote-endpoint = <&mvc1_cif_in_ep>;
+						amx3_in1_ep: endpoint {
+							remote-endpoint = <&xbar_amx3_in1_ep>;
+						};
 					};
-				};
 
-				port@29 {
-					reg = <0x29>;
+					port@1 {
+						reg = <1>;
 
-					xbar_mvc1_out_ep: endpoint {
-						remote-endpoint = <&mvc1_cif_out_ep>;
+						amx3_in2_ep: endpoint {
+							remote-endpoint = <&xbar_amx3_in2_ep>;
+						};
 					};
-				};
 
-				xbar_mvc2_in_port: port@2a {
-					reg = <0x2a>;
+					port@2 {
+						reg = <2>;
 
-					xbar_mvc2_in_ep: endpoint {
-						remote-endpoint = <&mvc2_cif_in_ep>;
+						amx3_in3_ep: endpoint {
+							remote-endpoint = <&xbar_amx3_in3_ep>;
+						};
 					};
-				};
 
-				port@2b {
-					reg = <0x2b>;
+					port@3 {
+						reg = <3>;
 
-					xbar_mvc2_out_ep: endpoint {
-						remote-endpoint = <&mvc2_cif_out_ep>;
+						amx3_in4_ep: endpoint {
+							remote-endpoint = <&xbar_amx3_in4_ep>;
+						};
 					};
-				};
 
-				xbar_amx1_in1_port: port@2c {
-					reg = <0x2c>;
+					amx3_out_port: port@4 {
+						reg = <4>;
 
-					xbar_amx1_in1_ep: endpoint {
-						remote-endpoint = <&amx1_in1_ep>;
+						amx3_out_ep: endpoint {
+							remote-endpoint = <&xbar_amx3_out_ep>;
+						};
 					};
 				};
+			};
 
-				xbar_amx1_in2_port: port@2d {
-					reg = <0x2d>;
+			amx@2903300 {
+				status = "okay";
 
-					xbar_amx1_in2_ep: endpoint {
-						remote-endpoint = <&amx1_in2_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_amx1_in3_port: port@2e {
-					reg = <0x2e>;
+					port@0 {
+						reg = <0>;
 
-					xbar_amx1_in3_ep: endpoint {
-						remote-endpoint = <&amx1_in3_ep>;
+						amx4_in1_ep: endpoint {
+							remote-endpoint = <&xbar_amx4_in1_ep>;
+						};
 					};
-				};
 
-				xbar_amx1_in4_port: port@2f {
-					reg = <0x2f>;
+					port@1 {
+						reg = <1>;
 
-					xbar_amx1_in4_ep: endpoint {
-						remote-endpoint = <&amx1_in4_ep>;
+						amx4_in2_ep: endpoint {
+							remote-endpoint = <&xbar_amx4_in2_ep>;
+						};
 					};
-				};
 
-				port@30 {
-					reg = <0x30>;
+					port@2 {
+						reg = <2>;
 
-					xbar_amx1_out_ep: endpoint {
-						remote-endpoint = <&amx1_out_ep>;
+						amx4_in3_ep: endpoint {
+							remote-endpoint = <&xbar_amx4_in3_ep>;
+						};
 					};
-				};
 
-				xbar_amx2_in1_port: port@31 {
-					reg = <0x31>;
+					port@3 {
+						reg = <3>;
 
-					xbar_amx2_in1_ep: endpoint {
-						remote-endpoint = <&amx2_in1_ep>;
+						amx4_in4_ep: endpoint {
+							remote-endpoint = <&xbar_amx4_in4_ep>;
+						};
 					};
-				};
 
-				xbar_amx2_in2_port: port@32 {
-					reg = <0x32>;
+					amx4_out_port: port@4 {
+						reg = <4>;
 
-					xbar_amx2_in2_ep: endpoint {
-						remote-endpoint = <&amx2_in2_ep>;
+						amx4_out_ep: endpoint {
+							remote-endpoint = <&xbar_amx4_out_ep>;
+						};
 					};
 				};
+			};
 
-				xbar_amx2_in3_port: port@33 {
-					reg = <0x33>;
+			adx@2903800 {
+				status = "okay";
 
-					xbar_amx2_in3_ep: endpoint {
-						remote-endpoint = <&amx2_in3_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_amx2_in4_port: port@34 {
-					reg = <0x34>;
+					port@0 {
+						reg = <0>;
 
-					xbar_amx2_in4_ep: endpoint {
-						remote-endpoint = <&amx2_in4_ep>;
+						adx1_in_ep: endpoint {
+							remote-endpoint = <&xbar_adx1_in_ep>;
+						};
 					};
-				};
 
-				port@35 {
-					reg = <0x35>;
+					adx1_out1_port: port@1 {
+						reg = <1>;
 
-					xbar_amx2_out_ep: endpoint {
-						remote-endpoint = <&amx2_out_ep>;
+						adx1_out1_ep: endpoint {
+							remote-endpoint = <&xbar_adx1_out1_ep>;
+						};
 					};
-				};
 
-				xbar_amx3_in1_port: port@36 {
-					reg = <0x36>;
+					adx1_out2_port: port@2 {
+						reg = <2>;
 
-					xbar_amx3_in1_ep: endpoint {
-						remote-endpoint = <&amx3_in1_ep>;
+						adx1_out2_ep: endpoint {
+							remote-endpoint = <&xbar_adx1_out2_ep>;
+						};
 					};
-				};
 
-				xbar_amx3_in2_port: port@37 {
-					reg = <0x37>;
+					adx1_out3_port: port@3 {
+						reg = <3>;
 
-					xbar_amx3_in2_ep: endpoint {
-						remote-endpoint = <&amx3_in2_ep>;
+						adx1_out3_ep: endpoint {
+							remote-endpoint = <&xbar_adx1_out3_ep>;
+						};
 					};
-				};
 
-				xbar_amx3_in3_port: port@38 {
-					reg = <0x38>;
+					adx1_out4_port: port@4 {
+						reg = <4>;
 
-					xbar_amx3_in3_ep: endpoint {
-						remote-endpoint = <&amx3_in3_ep>;
+						adx1_out4_ep: endpoint {
+							remote-endpoint = <&xbar_adx1_out4_ep>;
+						};
 					};
 				};
+			};
 
-				xbar_amx3_in4_port: port@39 {
-					reg = <0x39>;
+			adx@2903900 {
+				status = "okay";
 
-					xbar_amx3_in4_ep: endpoint {
-						remote-endpoint = <&amx3_in4_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				port@3a {
-					reg = <0x3a>;
+					port@0 {
+						reg = <0>;
 
-					xbar_amx3_out_ep: endpoint {
-						remote-endpoint = <&amx3_out_ep>;
+						adx2_in_ep: endpoint {
+							remote-endpoint = <&xbar_adx2_in_ep>;
+						};
 					};
-				};
 
-				xbar_amx4_in1_port: port@3b {
-					reg = <0x3b>;
+					adx2_out1_port: port@1 {
+						reg = <1>;
 
-					xbar_amx4_in1_ep: endpoint {
-						remote-endpoint = <&amx4_in1_ep>;
+						adx2_out1_ep: endpoint {
+							remote-endpoint = <&xbar_adx2_out1_ep>;
+						};
 					};
-				};
 
-				xbar_amx4_in2_port: port@3c {
-					reg = <0x3c>;
+					adx2_out2_port: port@2 {
+						reg = <2>;
 
-					xbar_amx4_in2_ep: endpoint {
-						remote-endpoint = <&amx4_in2_ep>;
+						adx2_out2_ep: endpoint {
+							remote-endpoint = <&xbar_adx2_out2_ep>;
+						};
 					};
-				};
 
-				xbar_amx4_in3_port: port@3d {
-					reg = <0x3d>;
+					adx2_out3_port: port@3 {
+						reg = <3>;
 
-					xbar_amx4_in3_ep: endpoint {
-						remote-endpoint = <&amx4_in3_ep>;
+						adx2_out3_ep: endpoint {
+							remote-endpoint = <&xbar_adx2_out3_ep>;
+						};
 					};
-				};
 
-				xbar_amx4_in4_port: port@3e {
-					reg = <0x3e>;
+					adx2_out4_port: port@4 {
+						reg = <4>;
 
-					xbar_amx4_in4_ep: endpoint {
-						remote-endpoint = <&amx4_in4_ep>;
+						adx2_out4_ep: endpoint {
+							remote-endpoint = <&xbar_adx2_out4_ep>;
+						};
 					};
 				};
+			};
 
-				port@3f {
-					reg = <0x3f>;
+			adx@2903a00 {
+				status = "okay";
 
-					xbar_amx4_out_ep: endpoint {
-						remote-endpoint = <&amx4_out_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_adx1_in_port: port@40 {
-					reg = <0x40>;
+					port@0 {
+						reg = <0>;
 
-					xbar_adx1_in_ep: endpoint {
-						remote-endpoint = <&adx1_in_ep>;
+						adx3_in_ep: endpoint {
+							remote-endpoint = <&xbar_adx3_in_ep>;
+						};
 					};
-				};
 
-				port@41 {
-					reg = <0x41>;
+					adx3_out1_port: port@1 {
+						reg = <1>;
 
-					xbar_adx1_out1_ep: endpoint {
-						remote-endpoint = <&adx1_out1_ep>;
+						adx3_out1_ep: endpoint {
+							remote-endpoint = <&xbar_adx3_out1_ep>;
+						};
 					};
-				};
 
-				port@42 {
-					reg = <0x42>;
+					adx3_out2_port: port@2 {
+						reg = <2>;
 
-					xbar_adx1_out2_ep: endpoint {
-						remote-endpoint = <&adx1_out2_ep>;
+						adx3_out2_ep: endpoint {
+							remote-endpoint = <&xbar_adx3_out2_ep>;
+						};
 					};
-				};
 
-				port@43 {
-					reg = <0x43>;
+					adx3_out3_port: port@3 {
+						reg = <3>;
 
-					xbar_adx1_out3_ep: endpoint {
-						remote-endpoint = <&adx1_out3_ep>;
+						adx3_out3_ep: endpoint {
+							remote-endpoint = <&xbar_adx3_out3_ep>;
+						};
 					};
-				};
 
-				port@44 {
-					reg = <0x44>;
+					adx3_out4_port: port@4 {
+						reg = <4>;
 
-					xbar_adx1_out4_ep: endpoint {
-						remote-endpoint = <&adx1_out4_ep>;
+						adx3_out4_ep: endpoint {
+							remote-endpoint = <&xbar_adx3_out4_ep>;
+						};
 					};
 				};
+			};
 
-				xbar_adx2_in_port: port@45 {
-					reg = <0x45>;
+			adx@2903b00 {
+				status = "okay";
 
-					xbar_adx2_in_ep: endpoint {
-						remote-endpoint = <&adx2_in_ep>;
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						adx4_in_ep: endpoint {
+							remote-endpoint = <&xbar_adx4_in_ep>;
+						};
 					};
-				};
 
-				port@46 {
-					reg = <0x46>;
+					adx4_out1_port: port@1 {
+						reg = <1>;
 
-					xbar_adx2_out1_ep: endpoint {
-						remote-endpoint = <&adx2_out1_ep>;
+						adx4_out1_ep: endpoint {
+							remote-endpoint = <&xbar_adx4_out1_ep>;
+						};
 					};
-				};
 
-				port@47 {
-					reg = <0x47>;
+					adx4_out2_port: port@2 {
+						reg = <2>;
 
-					xbar_adx2_out2_ep: endpoint {
-						remote-endpoint = <&adx2_out2_ep>;
+						adx4_out2_ep: endpoint {
+							remote-endpoint = <&xbar_adx4_out2_ep>;
+						};
 					};
-				};
 
-				port@48 {
-					reg = <0x48>;
+					adx4_out3_port: port@3 {
+						reg = <3>;
 
-					xbar_adx2_out3_ep: endpoint {
-						remote-endpoint = <&adx2_out3_ep>;
+						adx4_out3_ep: endpoint {
+							remote-endpoint = <&xbar_adx4_out3_ep>;
+						};
 					};
-				};
 
-				port@49 {
-					reg = <0x49>;
+					adx4_out4_port: port@4 {
+						reg = <4>;
 
-					xbar_adx2_out4_ep: endpoint {
-						remote-endpoint = <&adx2_out4_ep>;
+						adx4_out4_ep: endpoint {
+							remote-endpoint = <&xbar_adx4_out4_ep>;
+						};
 					};
 				};
+			};
 
-				xbar_adx3_in_port: port@4a {
-					reg = <0x4a>;
+			dmic@2904000 {
+				status = "okay";
 
-					xbar_adx3_in_ep: endpoint {
-						remote-endpoint = <&adx3_in_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				port@4b {
-					reg = <0x4b>;
+					port@0 {
+						reg = <0>;
 
-					xbar_adx3_out1_ep: endpoint {
-						remote-endpoint = <&adx3_out1_ep>;
+						dmic1_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dmic1_ep>;
+						};
 					};
-				};
 
-				port@4c {
-					reg = <0x4c>;
+					dmic1_port: port@1 {
+						reg = <1>;
 
-					xbar_adx3_out2_ep: endpoint {
-						remote-endpoint = <&adx3_out2_ep>;
+						dmic1_dap_ep: endpoint {
+							/* Place holder for external Codec */
+						};
 					};
 				};
+			};
 
-				port@4d {
-					reg = <0x4d>;
+			dmic@2904100 {
+				status = "okay";
 
-					xbar_adx3_out3_ep: endpoint {
-						remote-endpoint = <&adx3_out3_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				port@4e {
-					reg = <0x4e>;
+					port@0 {
+						reg = <0>;
 
-					xbar_adx3_out4_ep: endpoint {
-						remote-endpoint = <&adx3_out4_ep>;
+						dmic2_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dmic2_ep>;
+						};
 					};
-				};
 
-				xbar_adx4_in_port: port@4f {
-					reg = <0x4f>;
+					dmic2_port: port@1 {
+						reg = <1>;
 
-					xbar_adx4_in_ep: endpoint {
-						remote-endpoint = <&adx4_in_ep>;
+						dmic2_dap_ep: endpoint {
+							/* Place holder for external Codec */
+						};
 					};
 				};
+			};
 
-				port@50 {
-					reg = <0x50>;
+			dmic@2904200 {
+				status = "okay";
 
-					xbar_adx4_out1_ep: endpoint {
-						remote-endpoint = <&adx4_out1_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				port@51 {
-					reg = <0x51>;
+					port@0 {
+						reg = <0>;
 
-					xbar_adx4_out2_ep: endpoint {
-						remote-endpoint = <&adx4_out2_ep>;
+						dmic3_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dmic3_ep>;
+						};
 					};
-				};
 
-				port@52 {
-					reg = <0x52>;
+					dmic3_port: port@1 {
+						reg = <1>;
 
-					xbar_adx4_out3_ep: endpoint {
-						remote-endpoint = <&adx4_out3_ep>;
+						dmic3_dap_ep: endpoint {
+							/* Place holder for external Codec */
+						};
 					};
 				};
+			};
 
-				port@53 {
-					reg = <0x53>;
+			dspk@2905000 {
+				status = "okay";
 
-					xbar_adx4_out4_ep: endpoint {
-						remote-endpoint = <&adx4_out4_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_mixer_in1_port: port@54 {
-					reg = <0x54>;
+					port@0 {
+						reg = <0>;
 
-					xbar_mixer_in1_ep: endpoint {
-						remote-endpoint = <&mixer_in1_ep>;
+						dspk1_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dspk1_ep>;
+						};
 					};
-				};
 
-				xbar_mixer_in2_port: port@55 {
-					reg = <0x55>;
+					dspk1_port: port@1 {
+						reg = <1>;
 
-					xbar_mixer_in2_ep: endpoint {
-						remote-endpoint = <&mixer_in2_ep>;
+						dspk1_dap_ep: endpoint {
+							/* Place holder for external Codec */
+						};
 					};
 				};
+			};
 
-				xbar_mixer_in3_port: port@56 {
-					reg = <0x56>;
+			dspk@2905100 {
+				status = "okay";
 
-					xbar_mixer_in3_ep: endpoint {
-						remote-endpoint = <&mixer_in3_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_mixer_in4_port: port@57 {
-					reg = <0x57>;
+					port@0 {
+						reg = <0>;
 
-					xbar_mixer_in4_ep: endpoint {
-						remote-endpoint = <&mixer_in4_ep>;
+						dspk2_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dspk2_ep>;
+						};
 					};
-				};
 
-				xbar_mixer_in5_port: port@58 {
-					reg = <0x58>;
+					dspk2_port: port@1 {
+						reg = <1>;
 
-					xbar_mixer_in5_ep: endpoint {
-						remote-endpoint = <&mixer_in5_ep>;
+						dspk2_dap_ep: endpoint {
+							/* Place holder for external Codec */
+						};
 					};
 				};
+			};
 
-				xbar_mixer_in6_port: port@59 {
-					reg = <0x59>;
+			processing-engine@2908000 {
+				status = "okay";
 
-					xbar_mixer_in6_ep: endpoint {
-						remote-endpoint = <&mixer_in6_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_mixer_in7_port: port@5a {
-					reg = <0x5a>;
+					port@0 {
+						reg = <0x0>;
 
-					xbar_mixer_in7_ep: endpoint {
-						remote-endpoint = <&mixer_in7_ep>;
+						ope1_cif_in_ep: endpoint {
+							remote-endpoint = <&xbar_ope1_in_ep>;
+						};
 					};
-				};
 
-				xbar_mixer_in8_port: port@5b {
-					reg = <0x5b>;
+					ope1_out_port: port@1 {
+						reg = <0x1>;
 
-					xbar_mixer_in8_ep: endpoint {
-						remote-endpoint = <&mixer_in8_ep>;
+						ope1_cif_out_ep: endpoint {
+							remote-endpoint = <&xbar_ope1_out_ep>;
+						};
 					};
 				};
+			};
 
-				xbar_mixer_in9_port: port@5c {
-					reg = <0x5c>;
+			mvc@290a000 {
+				status = "okay";
 
-					xbar_mixer_in9_ep: endpoint {
-						remote-endpoint = <&mixer_in9_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_mixer_in10_port: port@5d {
-					reg = <0x5d>;
+					port@0 {
+						reg = <0>;
 
-					xbar_mixer_in10_ep: endpoint {
-						remote-endpoint = <&mixer_in10_ep>;
+						mvc1_cif_in_ep: endpoint {
+							remote-endpoint = <&xbar_mvc1_in_ep>;
+						};
 					};
-				};
 
-				port@5e {
-					reg = <0x5e>;
+					mvc1_out_port: port@1 {
+						reg = <1>;
 
-					xbar_mixer_out1_ep: endpoint {
-						remote-endpoint = <&mixer_out1_ep>;
+						mvc1_cif_out_ep: endpoint {
+							remote-endpoint = <&xbar_mvc1_out_ep>;
+						};
 					};
 				};
+			};
 
-				port@5f {
-					reg = <0x5f>;
+			mvc@290a200 {
+				status = "okay";
 
-					xbar_mixer_out2_ep: endpoint {
-						remote-endpoint = <&mixer_out2_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				port@60 {
-					reg = <0x60>;
+					port@0 {
+						reg = <0>;
 
-					xbar_mixer_out3_ep: endpoint {
-						remote-endpoint = <&mixer_out3_ep>;
+						mvc2_cif_in_ep: endpoint {
+							remote-endpoint = <&xbar_mvc2_in_ep>;
+						};
 					};
-				};
 
-				port@61 {
-					reg = <0x61>;
+					mvc2_out_port: port@1 {
+						reg = <1>;
 
-					xbar_mixer_out4_ep: endpoint {
-						remote-endpoint = <&mixer_out4_ep>;
+						mvc2_cif_out_ep: endpoint {
+							remote-endpoint = <&xbar_mvc2_out_ep>;
+						};
 					};
 				};
+			};
 
-				port@62 {
-					reg = <0x62>;
+			amixer@290bb00 {
+				status = "okay";
 
-					xbar_mixer_out5_ep: endpoint {
-						remote-endpoint = <&mixer_out5_ep>;
-					};
-				};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-				xbar_asrc_in1_port: port@63 {
-					reg = <0x63>;
+					port@0 {
+						reg = <0x0>;
 
-					xbar_asrc_in1_ep: endpoint {
-						remote-endpoint = <&asrc_in1_ep>;
+						mixer_in1_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_in1_ep>;
+						};
 					};
-				};
 
-				port@64 {
-					reg = <0x64>;
+					port@1 {
+						reg = <0x1>;
 
-					xbar_asrc_out1_ep: endpoint {
-						remote-endpoint = <&asrc_out1_ep>;
+						mixer_in2_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_in2_ep>;
+						};
 					};
-				};
 
-				xbar_asrc_in2_port: port@65 {
-					reg = <0x65>;
+					port@2 {
+						reg = <0x2>;
 
-					xbar_asrc_in2_ep: endpoint {
-						remote-endpoint = <&asrc_in2_ep>;
+						mixer_in3_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_in3_ep>;
+						};
 					};
-				};
 
-				port@66 {
-					reg = <0x66>;
+					port@3 {
+						reg = <0x3>;
 
-					xbar_asrc_out2_ep: endpoint {
-						remote-endpoint = <&asrc_out2_ep>;
+						mixer_in4_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_in4_ep>;
+						};
 					};
-				};
 
-				xbar_asrc_in3_port: port@67 {
-					reg = <0x67>;
+					port@4 {
+						reg = <0x4>;
 
-					xbar_asrc_in3_ep: endpoint {
-						remote-endpoint = <&asrc_in3_ep>;
+						mixer_in5_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_in5_ep>;
+						};
 					};
-				};
 
-				port@68 {
-					reg = <0x68>;
+					port@5 {
+						reg = <0x5>;
 
-					xbar_asrc_out3_ep: endpoint {
-						remote-endpoint = <&asrc_out3_ep>;
+						mixer_in6_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_in6_ep>;
+						};
 					};
-				};
 
-				xbar_asrc_in4_port: port@69 {
-					reg = <0x69>;
+					port@6 {
+						reg = <0x6>;
 
-					xbar_asrc_in4_ep: endpoint {
-						remote-endpoint = <&asrc_in4_ep>;
+						mixer_in7_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_in7_ep>;
+						};
 					};
-				};
 
-				port@6a {
-					reg = <0x6a>;
+					port@7 {
+						reg = <0x7>;
 
-					xbar_asrc_out4_ep: endpoint {
-						remote-endpoint = <&asrc_out4_ep>;
+						mixer_in8_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_in8_ep>;
+						};
 					};
-				};
 
-				xbar_asrc_in5_port: port@6b {
-					reg = <0x6b>;
+					port@8 {
+						reg = <0x8>;
 
-					xbar_asrc_in5_ep: endpoint {
-						remote-endpoint = <&asrc_in5_ep>;
+						mixer_in9_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_in9_ep>;
+						};
 					};
-				};
 
-				port@6c {
-					reg = <0x6c>;
+					port@9 {
+						reg = <0x9>;
 
-					xbar_asrc_out5_ep: endpoint {
-						remote-endpoint = <&asrc_out5_ep>;
+						mixer_in10_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_in10_ep>;
+						};
 					};
-				};
 
-				xbar_asrc_in6_port: port@6d {
-					reg = <0x6d>;
+					mixer_out1_port: port@a {
+						reg = <0xa>;
 
-					xbar_asrc_in6_ep: endpoint {
-						remote-endpoint = <&asrc_in6_ep>;
+						mixer_out1_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_out1_ep>;
+						};
 					};
-				};
 
-				port@6e {
-					reg = <0x6e>;
+					mixer_out2_port: port@b {
+						reg = <0xb>;
 
-					xbar_asrc_out6_ep: endpoint {
-						remote-endpoint = <&asrc_out6_ep>;
+						mixer_out2_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_out2_ep>;
+						};
 					};
-				};
 
-				xbar_asrc_in7_port: port@6f {
-					reg = <0x6f>;
+					mixer_out3_port: port@c {
+						reg = <0xc>;
 
-					xbar_asrc_in7_ep: endpoint {
-						remote-endpoint = <&asrc_in7_ep>;
+						mixer_out3_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_out3_ep>;
+						};
 					};
-				};
 
-				xbar_ope1_in_port: port@70 {
-					reg = <0x70>;
+					mixer_out4_port: port@d {
+						reg = <0xd>;
 
-					xbar_ope1_in_ep: endpoint {
-						remote-endpoint = <&ope1_cif_in_ep>;
+						mixer_out4_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_out4_ep>;
+						};
 					};
-				};
 
-				port@71 {
-					reg = <0x71>;
+					mixer_out5_port: port@e {
+						reg = <0xe>;
 
-					xbar_ope1_out_ep: endpoint {
-						remote-endpoint = <&ope1_cif_out_ep>;
+						mixer_out5_ep: endpoint {
+							remote-endpoint = <&xbar_mixer_out5_ep>;
+						};
 					};
 				};
 			};
@@ -1102,33 +1164,7 @@ admaif19_ep: endpoint {
 				};
 			};
 
-			i2s@2901000 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						i2s1_cif_ep: endpoint {
-							remote-endpoint = <&xbar_i2s1_ep>;
-						};
-					};
-
-					i2s1_port: port@1 {
-						reg = <1>;
-
-						i2s1_dap_ep: endpoint {
-							dai-format = "i2s";
-							/* Placeholder for external Codec */
-						};
-					};
-				};
-			};
-
-			i2s@2901100 {
+			asrc@2910000 {
 				status = "okay";
 
 				ports {
@@ -1136,1064 +1172,1028 @@ ports {
 					#size-cells = <0>;
 
 					port@0 {
-						reg = <0>;
+						reg = <0x0>;
 
-						i2s2_cif_ep: endpoint {
-							remote-endpoint = <&xbar_i2s2_ep>;
+						asrc_in1_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_in1_ep>;
 						};
 					};
 
-					i2s2_port: port@1 {
-						reg = <1>;
+					port@1 {
+						reg = <0x1>;
 
-						i2s2_dap_ep: endpoint {
-							dai-format = "i2s";
-							/* Placeholder for external Codec */
+						asrc_in2_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_in2_ep>;
 						};
 					};
-				};
-			};
-
-			i2s@2901200 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
 
-					port@0 {
-						reg = <0>;
+					port@2 {
+						reg = <0x2>;
 
-						i2s3_cif_ep: endpoint {
-							remote-endpoint = <&xbar_i2s3_ep>;
+						asrc_in3_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_in3_ep>;
 						};
 					};
 
-					i2s3_port: port@1 {
-						reg = <1>;
+					port@3 {
+						reg = <0x3>;
 
-						i2s3_dap_ep: endpoint {
-							dai-format = "i2s";
-							/* Placeholder for external Codec */
+						asrc_in4_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_in4_ep>;
 						};
 					};
-				};
-			};
-
-			i2s@2901300 {
-				status = "okay";
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					port@4 {
+						reg = <0x4>;
 
-					port@0 {
-						reg = <0>;
+						asrc_in5_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_in5_ep>;
+						};
+					};
 
-						i2s4_cif_ep: endpoint {
-							remote-endpoint = <&xbar_i2s4_ep>;
+					port@5 {
+						reg = <0x5>;
+
+						asrc_in6_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_in6_ep>;
 						};
 					};
 
-					i2s4_port: port@1 {
-						reg = <1>;
+					port@6 {
+						reg = <0x6>;
 
-						i2s4_dap_ep: endpoint {
-							dai-format = "i2s";
-							/* Placeholder for external Codec */
+						asrc_in7_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_in7_ep>;
 						};
 					};
-				};
-			};
 
-			i2s@2901400 {
-				status = "okay";
+					asrc_out1_port: port@7 {
+						reg = <0x7>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+						asrc_out1_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_out1_ep>;
+						};
+					};
 
-					port@0 {
-						reg = <0>;
+					asrc_out2_port: port@8 {
+						reg = <0x8>;
 
-						i2s5_cif_ep: endpoint {
-							remote-endpoint = <&xbar_i2s5_ep>;
+						asrc_out2_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_out2_ep>;
 						};
 					};
 
-					i2s5_port: port@1 {
-						reg = <1>;
+					asrc_out3_port: port@9 {
+						reg = <0x9>;
 
-						i2s5_dap_ep: endpoint {
-							dai-format = "i2s";
-							/* Placeholder for external Codec */
+						asrc_out3_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_out3_ep>;
 						};
 					};
-				};
-			};
 
-			i2s@2901500 {
-				status = "okay";
+					asrc_out4_port: port@a {
+						reg = <0xa>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+						asrc_out4_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_out4_ep>;
+						};
+					};
 
-					port@0 {
-						reg = <0>;
+					asrc_out5_port: port@b {
+						reg = <0xb>;
 
-						i2s6_cif_ep: endpoint {
-							remote-endpoint = <&xbar_i2s6_ep>;
+						asrc_out5_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_out5_ep>;
 						};
 					};
 
-					i2s6_port: port@1 {
-						reg = <1>;
+					asrc_out6_port: port@c {
+						reg = <0xc>;
 
-						i2s6_dap_ep: endpoint {
-							dai-format = "i2s";
-							/* Placeholder for external Codec */
+						asrc_out6_ep: endpoint {
+							remote-endpoint = <&xbar_asrc_out6_ep>;
 						};
 					};
 				};
 			};
 
-			dmic@2904000 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
 
-					port@0 {
-						reg = <0>;
+				port@0 {
+					reg = <0x0>;
 
-						dmic1_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dmic1_ep>;
-						};
+					xbar_admaif0_ep: endpoint {
+						remote-endpoint = <&admaif0_ep>;
 					};
+				};
 
-					dmic1_port: port@1 {
-						reg = <1>;
+				port@1 {
+					reg = <0x1>;
 
-						dmic1_dap_ep: endpoint {
-							/* Place holder for external Codec */
-						};
+					xbar_admaif1_ep: endpoint {
+						remote-endpoint = <&admaif1_ep>;
 					};
 				};
-			};
 
-			dmic@2904100 {
-				status = "okay";
+				port@2 {
+					reg = <0x2>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_admaif2_ep: endpoint {
+						remote-endpoint = <&admaif2_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				port@3 {
+					reg = <0x3>;
 
-						dmic2_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dmic2_ep>;
-						};
+					xbar_admaif3_ep: endpoint {
+						remote-endpoint = <&admaif3_ep>;
 					};
+				};
 
-					dmic2_port: port@1 {
-						reg = <1>;
+				port@4 {
+					reg = <0x4>;
 
-						dmic2_dap_ep: endpoint {
-							/* Place holder for external Codec */
-						};
+					xbar_admaif4_ep: endpoint {
+						remote-endpoint = <&admaif4_ep>;
 					};
 				};
-			};
 
-			dmic@2904200 {
-				status = "okay";
+				port@5 {
+					reg = <0x5>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_admaif5_ep: endpoint {
+						remote-endpoint = <&admaif5_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				port@6 {
+					reg = <0x6>;
 
-						dmic3_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dmic3_ep>;
-						};
+					xbar_admaif6_ep: endpoint {
+						remote-endpoint = <&admaif6_ep>;
 					};
+				};
 
-					dmic3_port: port@1 {
-						reg = <1>;
+				port@7 {
+					reg = <0x7>;
 
-						dmic3_dap_ep: endpoint {
-							/* Place holder for external Codec */
-						};
+					xbar_admaif7_ep: endpoint {
+						remote-endpoint = <&admaif7_ep>;
 					};
 				};
-			};
 
-			dspk@2905000 {
-				status = "okay";
+				port@8 {
+					reg = <0x8>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_admaif8_ep: endpoint {
+						remote-endpoint = <&admaif8_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				port@9 {
+					reg = <0x9>;
 
-						dspk1_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dspk1_ep>;
-						};
+					xbar_admaif9_ep: endpoint {
+						remote-endpoint = <&admaif9_ep>;
 					};
+				};
 
-					dspk1_port: port@1 {
-						reg = <1>;
+				port@a {
+					reg = <0xa>;
 
-						dspk1_dap_ep: endpoint {
-							/* Place holder for external Codec */
-						};
+					xbar_admaif10_ep: endpoint {
+						remote-endpoint = <&admaif10_ep>;
 					};
 				};
-			};
 
-			dspk@2905100 {
-				status = "okay";
+				port@b {
+					reg = <0xb>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_admaif11_ep: endpoint {
+						remote-endpoint = <&admaif11_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				port@c {
+					reg = <0xc>;
 
-						dspk2_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dspk2_ep>;
-						};
+					xbar_admaif12_ep: endpoint {
+						remote-endpoint = <&admaif12_ep>;
 					};
+				};
 
-					dspk2_port: port@1 {
-						reg = <1>;
+				port@d {
+					reg = <0xd>;
 
-						dspk2_dap_ep: endpoint {
-							/* Place holder for external Codec */
-						};
+					xbar_admaif13_ep: endpoint {
+						remote-endpoint = <&admaif13_ep>;
 					};
 				};
-			};
 
-			sfc@2902000 {
-				status = "okay";
+				port@e {
+					reg = <0xe>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_admaif14_ep: endpoint {
+						remote-endpoint = <&admaif14_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				port@f {
+					reg = <0xf>;
 
-						sfc1_cif_in_ep: endpoint {
-							remote-endpoint = <&xbar_sfc1_in_ep>;
-							convert-rate = <44100>;
-						};
+					xbar_admaif15_ep: endpoint {
+						remote-endpoint = <&admaif15_ep>;
 					};
+				};
 
-					sfc1_out_port: port@1 {
-						reg = <1>;
+				port@10 {
+					reg = <0x10>;
 
-						sfc1_cif_out_ep: endpoint {
-							remote-endpoint = <&xbar_sfc1_out_ep>;
-							convert-rate = <48000>;
-						};
+					xbar_admaif16_ep: endpoint {
+						remote-endpoint = <&admaif16_ep>;
 					};
 				};
-			};
 
-			sfc@2902200 {
-				status = "okay";
+				port@11 {
+					reg = <0x11>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_admaif17_ep: endpoint {
+						remote-endpoint = <&admaif17_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				port@12 {
+					reg = <0x12>;
 
-						sfc2_cif_in_ep: endpoint {
-							remote-endpoint = <&xbar_sfc2_in_ep>;
-						};
+					xbar_admaif18_ep: endpoint {
+						remote-endpoint = <&admaif18_ep>;
 					};
+				};
 
-					sfc2_out_port: port@1 {
-						reg = <1>;
+				port@13 {
+					reg = <0x13>;
 
-						sfc2_cif_out_ep: endpoint {
-							remote-endpoint = <&xbar_sfc2_out_ep>;
-						};
+					xbar_admaif19_ep: endpoint {
+						remote-endpoint = <&admaif19_ep>;
 					};
 				};
-			};
 
-			sfc@2902400 {
-				status = "okay";
+				xbar_i2s1_port: port@14 {
+					reg = <0x14>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_i2s1_ep: endpoint {
+						remote-endpoint = <&i2s1_cif_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				xbar_i2s2_port: port@15 {
+					reg = <0x15>;
 
-						sfc3_cif_in_ep: endpoint {
-							remote-endpoint = <&xbar_sfc3_in_ep>;
-						};
+					xbar_i2s2_ep: endpoint {
+						remote-endpoint = <&i2s2_cif_ep>;
 					};
+				};
 
-					sfc3_out_port: port@1 {
-						reg = <1>;
+				xbar_i2s3_port: port@16 {
+					reg = <0x16>;
 
-						sfc3_cif_out_ep: endpoint {
-							remote-endpoint = <&xbar_sfc3_out_ep>;
-						};
+					xbar_i2s3_ep: endpoint {
+						remote-endpoint = <&i2s3_cif_ep>;
 					};
 				};
-			};
 
-			sfc@2902600 {
-				status = "okay";
+				xbar_i2s4_port: port@17 {
+					reg = <0x17>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_i2s4_ep: endpoint {
+						remote-endpoint = <&i2s4_cif_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				xbar_i2s5_port: port@18 {
+					reg = <0x18>;
 
-						sfc4_cif_in_ep: endpoint {
-							remote-endpoint = <&xbar_sfc4_in_ep>;
-						};
+					xbar_i2s5_ep: endpoint {
+						remote-endpoint = <&i2s5_cif_ep>;
 					};
+				};
 
-					sfc4_out_port: port@1 {
-						reg = <1>;
+				xbar_i2s6_port: port@19 {
+					reg = <0x19>;
 
-						sfc4_cif_out_ep: endpoint {
-							remote-endpoint = <&xbar_sfc4_out_ep>;
-						};
+					xbar_i2s6_ep: endpoint {
+						remote-endpoint = <&i2s6_cif_ep>;
 					};
 				};
-			};
 
-			mvc@290a000 {
-				status = "okay";
+				xbar_dmic1_port: port@1a {
+					reg = <0x1a>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_dmic1_ep: endpoint {
+						remote-endpoint = <&dmic1_cif_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				xbar_dmic2_port: port@1b {
+					reg = <0x1b>;
 
-						mvc1_cif_in_ep: endpoint {
-							remote-endpoint = <&xbar_mvc1_in_ep>;
-						};
+					xbar_dmic2_ep: endpoint {
+						remote-endpoint = <&dmic2_cif_ep>;
 					};
+				};
 
-					mvc1_out_port: port@1 {
-						reg = <1>;
+				xbar_dmic3_port: port@1c {
+					reg = <0x1c>;
 
-						mvc1_cif_out_ep: endpoint {
-							remote-endpoint = <&xbar_mvc1_out_ep>;
-						};
+					xbar_dmic3_ep: endpoint {
+						remote-endpoint = <&dmic3_cif_ep>;
 					};
 				};
-			};
 
-			mvc@290a200 {
-				status = "okay";
+				xbar_dspk1_port: port@1e {
+					reg = <0x1e>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_dspk1_ep: endpoint {
+						remote-endpoint = <&dspk1_cif_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				xbar_dspk2_port: port@1f {
+					reg = <0x1f>;
 
-						mvc2_cif_in_ep: endpoint {
-							remote-endpoint = <&xbar_mvc2_in_ep>;
-						};
+					xbar_dspk2_ep: endpoint {
+						remote-endpoint = <&dspk2_cif_ep>;
 					};
+				};
 
-					mvc2_out_port: port@1 {
-						reg = <1>;
+				xbar_sfc1_in_port: port@20 {
+					reg = <0x20>;
 
-						mvc2_cif_out_ep: endpoint {
-							remote-endpoint = <&xbar_mvc2_out_ep>;
-						};
+					xbar_sfc1_in_ep: endpoint {
+						remote-endpoint = <&sfc1_cif_in_ep>;
 					};
 				};
-			};
 
-			amx@2903000 {
-				status = "okay";
+				port@21 {
+					reg = <0x21>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_sfc1_out_ep: endpoint {
+						remote-endpoint = <&sfc1_cif_out_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				xbar_sfc2_in_port: port@22 {
+					reg = <0x22>;
 
-						amx1_in1_ep: endpoint {
-							remote-endpoint = <&xbar_amx1_in1_ep>;
-						};
+					xbar_sfc2_in_ep: endpoint {
+						remote-endpoint = <&sfc2_cif_in_ep>;
 					};
+				};
 
-					port@1 {
-						reg = <1>;
+				port@23 {
+					reg = <0x23>;
 
-						amx1_in2_ep: endpoint {
-							remote-endpoint = <&xbar_amx1_in2_ep>;
-						};
+					xbar_sfc2_out_ep: endpoint {
+						remote-endpoint = <&sfc2_cif_out_ep>;
 					};
+				};
 
-					port@2 {
-						reg = <2>;
+				xbar_sfc3_in_port: port@24 {
+					reg = <0x24>;
 
-						amx1_in3_ep: endpoint {
-							remote-endpoint = <&xbar_amx1_in3_ep>;
-						};
+					xbar_sfc3_in_ep: endpoint {
+						remote-endpoint = <&sfc3_cif_in_ep>;
 					};
+				};
 
-					port@3 {
-						reg = <3>;
+				port@25 {
+					reg = <0x25>;
 
-						amx1_in4_ep: endpoint {
-							remote-endpoint = <&xbar_amx1_in4_ep>;
-						};
+					xbar_sfc3_out_ep: endpoint {
+						remote-endpoint = <&sfc3_cif_out_ep>;
 					};
+				};
 
-					amx1_out_port: port@4 {
-						reg = <4>;
+				xbar_sfc4_in_port: port@26 {
+					reg = <0x26>;
 
-						amx1_out_ep: endpoint {
-							remote-endpoint = <&xbar_amx1_out_ep>;
-						};
+					xbar_sfc4_in_ep: endpoint {
+						remote-endpoint = <&sfc4_cif_in_ep>;
 					};
 				};
-			};
 
-			amx@2903100 {
-				status = "okay";
+				port@27 {
+					reg = <0x27>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_sfc4_out_ep: endpoint {
+						remote-endpoint = <&sfc4_cif_out_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				xbar_mvc1_in_port: port@28 {
+					reg = <0x28>;
 
-						amx2_in1_ep: endpoint {
-							remote-endpoint = <&xbar_amx2_in1_ep>;
-						};
+					xbar_mvc1_in_ep: endpoint {
+						remote-endpoint = <&mvc1_cif_in_ep>;
 					};
+				};
 
-					port@1 {
-						reg = <1>;
-
-						amx2_in2_ep: endpoint {
-							remote-endpoint = <&xbar_amx2_in2_ep>;
-						};
+				port@29 {
+					reg = <0x29>;
+
+					xbar_mvc1_out_ep: endpoint {
+						remote-endpoint = <&mvc1_cif_out_ep>;
 					};
+				};
 
-					amx2_in3_port: port@2 {
-						reg = <2>;
+				xbar_mvc2_in_port: port@2a {
+					reg = <0x2a>;
 
-						amx2_in3_ep: endpoint {
-							remote-endpoint = <&xbar_amx2_in3_ep>;
-						};
+					xbar_mvc2_in_ep: endpoint {
+						remote-endpoint = <&mvc2_cif_in_ep>;
 					};
+				};
 
-					amx2_in4_port: port@3 {
-						reg = <3>;
+				port@2b {
+					reg = <0x2b>;
 
-						amx2_in4_ep: endpoint {
-							remote-endpoint = <&xbar_amx2_in4_ep>;
-						};
+					xbar_mvc2_out_ep: endpoint {
+						remote-endpoint = <&mvc2_cif_out_ep>;
 					};
+				};
 
-					amx2_out_port: port@4 {
-						reg = <4>;
+				xbar_amx1_in1_port: port@2c {
+					reg = <0x2c>;
 
-						amx2_out_ep: endpoint {
-							remote-endpoint = <&xbar_amx2_out_ep>;
-						};
+					xbar_amx1_in1_ep: endpoint {
+						remote-endpoint = <&amx1_in1_ep>;
 					};
 				};
-			};
 
-			amx@2903200 {
-				status = "okay";
+				xbar_amx1_in2_port: port@2d {
+					reg = <0x2d>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_amx1_in2_ep: endpoint {
+						remote-endpoint = <&amx1_in2_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				xbar_amx1_in3_port: port@2e {
+					reg = <0x2e>;
 
-						amx3_in1_ep: endpoint {
-							remote-endpoint = <&xbar_amx3_in1_ep>;
-						};
+					xbar_amx1_in3_ep: endpoint {
+						remote-endpoint = <&amx1_in3_ep>;
 					};
+				};
 
-					port@1 {
-						reg = <1>;
+				xbar_amx1_in4_port: port@2f {
+					reg = <0x2f>;
 
-						amx3_in2_ep: endpoint {
-							remote-endpoint = <&xbar_amx3_in2_ep>;
-						};
+					xbar_amx1_in4_ep: endpoint {
+						remote-endpoint = <&amx1_in4_ep>;
 					};
+				};
 
-					port@2 {
-						reg = <2>;
+				port@30 {
+					reg = <0x30>;
 
-						amx3_in3_ep: endpoint {
-							remote-endpoint = <&xbar_amx3_in3_ep>;
-						};
+					xbar_amx1_out_ep: endpoint {
+						remote-endpoint = <&amx1_out_ep>;
 					};
+				};
 
-					port@3 {
-						reg = <3>;
+				xbar_amx2_in1_port: port@31 {
+					reg = <0x31>;
 
-						amx3_in4_ep: endpoint {
-							remote-endpoint = <&xbar_amx3_in4_ep>;
-						};
+					xbar_amx2_in1_ep: endpoint {
+						remote-endpoint = <&amx2_in1_ep>;
 					};
+				};
 
-					amx3_out_port: port@4 {
-						reg = <4>;
+				xbar_amx2_in2_port: port@32 {
+					reg = <0x32>;
 
-						amx3_out_ep: endpoint {
-							remote-endpoint = <&xbar_amx3_out_ep>;
-						};
+					xbar_amx2_in2_ep: endpoint {
+						remote-endpoint = <&amx2_in2_ep>;
 					};
 				};
-			};
 
-			amx@2903300 {
-				status = "okay";
+				xbar_amx2_in3_port: port@33 {
+					reg = <0x33>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_amx2_in3_ep: endpoint {
+						remote-endpoint = <&amx2_in3_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				xbar_amx2_in4_port: port@34 {
+					reg = <0x34>;
 
-						amx4_in1_ep: endpoint {
-							remote-endpoint = <&xbar_amx4_in1_ep>;
-						};
+					xbar_amx2_in4_ep: endpoint {
+						remote-endpoint = <&amx2_in4_ep>;
 					};
+				};
 
-					port@1 {
-						reg = <1>;
+				port@35 {
+					reg = <0x35>;
 
-						amx4_in2_ep: endpoint {
-							remote-endpoint = <&xbar_amx4_in2_ep>;
-						};
+					xbar_amx2_out_ep: endpoint {
+						remote-endpoint = <&amx2_out_ep>;
 					};
+				};
 
-					port@2 {
-						reg = <2>;
+				xbar_amx3_in1_port: port@36 {
+					reg = <0x36>;
 
-						amx4_in3_ep: endpoint {
-							remote-endpoint = <&xbar_amx4_in3_ep>;
-						};
+					xbar_amx3_in1_ep: endpoint {
+						remote-endpoint = <&amx3_in1_ep>;
 					};
+				};
 
-					port@3 {
-						reg = <3>;
+				xbar_amx3_in2_port: port@37 {
+					reg = <0x37>;
 
-						amx4_in4_ep: endpoint {
-							remote-endpoint = <&xbar_amx4_in4_ep>;
-						};
+					xbar_amx3_in2_ep: endpoint {
+						remote-endpoint = <&amx3_in2_ep>;
 					};
+				};
 
-					amx4_out_port: port@4 {
-						reg = <4>;
+				xbar_amx3_in3_port: port@38 {
+					reg = <0x38>;
 
-						amx4_out_ep: endpoint {
-							remote-endpoint = <&xbar_amx4_out_ep>;
-						};
+					xbar_amx3_in3_ep: endpoint {
+						remote-endpoint = <&amx3_in3_ep>;
 					};
 				};
-			};
 
-			adx@2903800 {
-				status = "okay";
+				xbar_amx3_in4_port: port@39 {
+					reg = <0x39>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_amx3_in4_ep: endpoint {
+						remote-endpoint = <&amx3_in4_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				port@3a {
+					reg = <0x3a>;
 
-						adx1_in_ep: endpoint {
-							remote-endpoint = <&xbar_adx1_in_ep>;
-						};
+					xbar_amx3_out_ep: endpoint {
+						remote-endpoint = <&amx3_out_ep>;
 					};
+				};
 
-					adx1_out1_port: port@1 {
-						reg = <1>;
+				xbar_amx4_in1_port: port@3b {
+					reg = <0x3b>;
 
-						adx1_out1_ep: endpoint {
-							remote-endpoint = <&xbar_adx1_out1_ep>;
-						};
+					xbar_amx4_in1_ep: endpoint {
+						remote-endpoint = <&amx4_in1_ep>;
 					};
+				};
 
-					adx1_out2_port: port@2 {
-						reg = <2>;
+				xbar_amx4_in2_port: port@3c {
+					reg = <0x3c>;
 
-						adx1_out2_ep: endpoint {
-							remote-endpoint = <&xbar_adx1_out2_ep>;
-						};
+					xbar_amx4_in2_ep: endpoint {
+						remote-endpoint = <&amx4_in2_ep>;
 					};
+				};
 
-					adx1_out3_port: port@3 {
-						reg = <3>;
+				xbar_amx4_in3_port: port@3d {
+					reg = <0x3d>;
 
-						adx1_out3_ep: endpoint {
-							remote-endpoint = <&xbar_adx1_out3_ep>;
-						};
+					xbar_amx4_in3_ep: endpoint {
+						remote-endpoint = <&amx4_in3_ep>;
 					};
+				};
 
-					adx1_out4_port: port@4 {
-						reg = <4>;
+				xbar_amx4_in4_port: port@3e {
+					reg = <0x3e>;
 
-						adx1_out4_ep: endpoint {
-							remote-endpoint = <&xbar_adx1_out4_ep>;
-						};
+					xbar_amx4_in4_ep: endpoint {
+						remote-endpoint = <&amx4_in4_ep>;
 					};
 				};
-			};
 
-			adx@2903900 {
-				status = "okay";
+				port@3f {
+					reg = <0x3f>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_amx4_out_ep: endpoint {
+						remote-endpoint = <&amx4_out_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				xbar_adx1_in_port: port@40 {
+					reg = <0x40>;
 
-						adx2_in_ep: endpoint {
-							remote-endpoint = <&xbar_adx2_in_ep>;
-						};
+					xbar_adx1_in_ep: endpoint {
+						remote-endpoint = <&adx1_in_ep>;
 					};
+				};
 
-					adx2_out1_port: port@1 {
-						reg = <1>;
+				port@41 {
+					reg = <0x41>;
 
-						adx2_out1_ep: endpoint {
-							remote-endpoint = <&xbar_adx2_out1_ep>;
-						};
+					xbar_adx1_out1_ep: endpoint {
+						remote-endpoint = <&adx1_out1_ep>;
 					};
+				};
 
-					adx2_out2_port: port@2 {
-						reg = <2>;
-
-						adx2_out2_ep: endpoint {
-							remote-endpoint = <&xbar_adx2_out2_ep>;
-						};
+				port@42 {
+					reg = <0x42>;
+
+					xbar_adx1_out2_ep: endpoint {
+						remote-endpoint = <&adx1_out2_ep>;
 					};
+				};
 
-					adx2_out3_port: port@3 {
-						reg = <3>;
+				port@43 {
+					reg = <0x43>;
 
-						adx2_out3_ep: endpoint {
-							remote-endpoint = <&xbar_adx2_out3_ep>;
-						};
+					xbar_adx1_out3_ep: endpoint {
+						remote-endpoint = <&adx1_out3_ep>;
 					};
+				};
 
-					adx2_out4_port: port@4 {
-						reg = <4>;
+				port@44 {
+					reg = <0x44>;
 
-						adx2_out4_ep: endpoint {
-							remote-endpoint = <&xbar_adx2_out4_ep>;
-						};
+					xbar_adx1_out4_ep: endpoint {
+						remote-endpoint = <&adx1_out4_ep>;
 					};
 				};
-			};
 
-			adx@2903a00 {
-				status = "okay";
+				xbar_adx2_in_port: port@45 {
+					reg = <0x45>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_adx2_in_ep: endpoint {
+						remote-endpoint = <&adx2_in_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				port@46 {
+					reg = <0x46>;
 
-						adx3_in_ep: endpoint {
-							remote-endpoint = <&xbar_adx3_in_ep>;
-						};
+					xbar_adx2_out1_ep: endpoint {
+						remote-endpoint = <&adx2_out1_ep>;
 					};
+				};
 
-					adx3_out1_port: port@1 {
-						reg = <1>;
+				port@47 {
+					reg = <0x47>;
 
-						adx3_out1_ep: endpoint {
-							remote-endpoint = <&xbar_adx3_out1_ep>;
-						};
+					xbar_adx2_out2_ep: endpoint {
+						remote-endpoint = <&adx2_out2_ep>;
 					};
+				};
 
-					adx3_out2_port: port@2 {
-						reg = <2>;
+				port@48 {
+					reg = <0x48>;
 
-						adx3_out2_ep: endpoint {
-							remote-endpoint = <&xbar_adx3_out2_ep>;
-						};
+					xbar_adx2_out3_ep: endpoint {
+						remote-endpoint = <&adx2_out3_ep>;
 					};
+				};
 
-					adx3_out3_port: port@3 {
-						reg = <3>;
+				port@49 {
+					reg = <0x49>;
 
-						adx3_out3_ep: endpoint {
-							remote-endpoint = <&xbar_adx3_out3_ep>;
-						};
+					xbar_adx2_out4_ep: endpoint {
+						remote-endpoint = <&adx2_out4_ep>;
 					};
+				};
 
-					adx3_out4_port: port@4 {
-						reg = <4>;
+				xbar_adx3_in_port: port@4a {
+					reg = <0x4a>;
 
-						adx3_out4_ep: endpoint {
-							remote-endpoint = <&xbar_adx3_out4_ep>;
-						};
+					xbar_adx3_in_ep: endpoint {
+						remote-endpoint = <&adx3_in_ep>;
 					};
 				};
-			};
 
-			adx@2903b00 {
-				status = "okay";
+				port@4b {
+					reg = <0x4b>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_adx3_out1_ep: endpoint {
+						remote-endpoint = <&adx3_out1_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0>;
+				port@4c {
+					reg = <0x4c>;
 
-						adx4_in_ep: endpoint {
-							remote-endpoint = <&xbar_adx4_in_ep>;
-						};
+					xbar_adx3_out2_ep: endpoint {
+						remote-endpoint = <&adx3_out2_ep>;
 					};
+				};
 
-					adx4_out1_port: port@1 {
-						reg = <1>;
+				port@4d {
+					reg = <0x4d>;
 
-						adx4_out1_ep: endpoint {
-							remote-endpoint = <&xbar_adx4_out1_ep>;
-						};
+					xbar_adx3_out3_ep: endpoint {
+						remote-endpoint = <&adx3_out3_ep>;
 					};
+				};
 
-					adx4_out2_port: port@2 {
-						reg = <2>;
+				port@4e {
+					reg = <0x4e>;
 
-						adx4_out2_ep: endpoint {
-							remote-endpoint = <&xbar_adx4_out2_ep>;
-						};
+					xbar_adx3_out4_ep: endpoint {
+						remote-endpoint = <&adx3_out4_ep>;
 					};
+				};
 
-					adx4_out3_port: port@3 {
-						reg = <3>;
+				xbar_adx4_in_port: port@4f {
+					reg = <0x4f>;
 
-						adx4_out3_ep: endpoint {
-							remote-endpoint = <&xbar_adx4_out3_ep>;
-						};
+					xbar_adx4_in_ep: endpoint {
+						remote-endpoint = <&adx4_in_ep>;
 					};
+				};
 
-					adx4_out4_port: port@4 {
-						reg = <4>;
+				port@50 {
+					reg = <0x50>;
 
-						adx4_out4_ep: endpoint {
-							remote-endpoint = <&xbar_adx4_out4_ep>;
-						};
+					xbar_adx4_out1_ep: endpoint {
+						remote-endpoint = <&adx4_out1_ep>;
 					};
 				};
-			};
 
-			processing-engine@2908000 {
-				status = "okay";
+				port@51 {
+					reg = <0x51>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_adx4_out2_ep: endpoint {
+						remote-endpoint = <&adx4_out2_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0x0>;
+				port@52 {
+					reg = <0x52>;
 
-						ope1_cif_in_ep: endpoint {
-							remote-endpoint = <&xbar_ope1_in_ep>;
-						};
+					xbar_adx4_out3_ep: endpoint {
+						remote-endpoint = <&adx4_out3_ep>;
 					};
+				};
 
-					ope1_out_port: port@1 {
-						reg = <0x1>;
+				port@53 {
+					reg = <0x53>;
 
-						ope1_cif_out_ep: endpoint {
-							remote-endpoint = <&xbar_ope1_out_ep>;
-						};
+					xbar_adx4_out4_ep: endpoint {
+						remote-endpoint = <&adx4_out4_ep>;
 					};
 				};
-			};
 
-			amixer@290bb00 {
-				status = "okay";
+				xbar_mixer_in1_port: port@54 {
+					reg = <0x54>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_mixer_in1_ep: endpoint {
+						remote-endpoint = <&mixer_in1_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0x0>;
+				xbar_mixer_in2_port: port@55 {
+					reg = <0x55>;
 
-						mixer_in1_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_in1_ep>;
-						};
+					xbar_mixer_in2_ep: endpoint {
+						remote-endpoint = <&mixer_in2_ep>;
 					};
+				};
 
-					port@1 {
-						reg = <0x1>;
+				xbar_mixer_in3_port: port@56 {
+					reg = <0x56>;
 
-						mixer_in2_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_in2_ep>;
-						};
+					xbar_mixer_in3_ep: endpoint {
+						remote-endpoint = <&mixer_in3_ep>;
 					};
+				};
 
-					port@2 {
-						reg = <0x2>;
+				xbar_mixer_in4_port: port@57 {
+					reg = <0x57>;
 
-						mixer_in3_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_in3_ep>;
-						};
+					xbar_mixer_in4_ep: endpoint {
+						remote-endpoint = <&mixer_in4_ep>;
 					};
+				};
 
-					port@3 {
-						reg = <0x3>;
+				xbar_mixer_in5_port: port@58 {
+					reg = <0x58>;
 
-						mixer_in4_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_in4_ep>;
-						};
+					xbar_mixer_in5_ep: endpoint {
+						remote-endpoint = <&mixer_in5_ep>;
 					};
+				};
 
-					port@4 {
-						reg = <0x4>;
+				xbar_mixer_in6_port: port@59 {
+					reg = <0x59>;
 
-						mixer_in5_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_in5_ep>;
-						};
+					xbar_mixer_in6_ep: endpoint {
+						remote-endpoint = <&mixer_in6_ep>;
 					};
+				};
 
-					port@5 {
-						reg = <0x5>;
+				xbar_mixer_in7_port: port@5a {
+					reg = <0x5a>;
 
-						mixer_in6_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_in6_ep>;
-						};
+					xbar_mixer_in7_ep: endpoint {
+						remote-endpoint = <&mixer_in7_ep>;
 					};
+				};
 
-					port@6 {
-						reg = <0x6>;
-
-						mixer_in7_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_in7_ep>;
-						};
+				xbar_mixer_in8_port: port@5b {
+					reg = <0x5b>;
+
+					xbar_mixer_in8_ep: endpoint {
+						remote-endpoint = <&mixer_in8_ep>;
 					};
+				};
 
-					port@7 {
-						reg = <0x7>;
+				xbar_mixer_in9_port: port@5c {
+					reg = <0x5c>;
 
-						mixer_in8_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_in8_ep>;
-						};
+					xbar_mixer_in9_ep: endpoint {
+						remote-endpoint = <&mixer_in9_ep>;
 					};
+				};
 
-					port@8 {
-						reg = <0x8>;
+				xbar_mixer_in10_port: port@5d {
+					reg = <0x5d>;
 
-						mixer_in9_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_in9_ep>;
-						};
+					xbar_mixer_in10_ep: endpoint {
+						remote-endpoint = <&mixer_in10_ep>;
 					};
+				};
 
-					port@9 {
-						reg = <0x9>;
+				port@5e {
+					reg = <0x5e>;
 
-						mixer_in10_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_in10_ep>;
-						};
+					xbar_mixer_out1_ep: endpoint {
+						remote-endpoint = <&mixer_out1_ep>;
 					};
+				};
 
-					mixer_out1_port: port@a {
-						reg = <0xa>;
+				port@5f {
+					reg = <0x5f>;
 
-						mixer_out1_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_out1_ep>;
-						};
+					xbar_mixer_out2_ep: endpoint {
+						remote-endpoint = <&mixer_out2_ep>;
 					};
+				};
 
-					mixer_out2_port: port@b {
-						reg = <0xb>;
+				port@60 {
+					reg = <0x60>;
 
-						mixer_out2_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_out2_ep>;
-						};
+					xbar_mixer_out3_ep: endpoint {
+						remote-endpoint = <&mixer_out3_ep>;
 					};
+				};
 
-					mixer_out3_port: port@c {
-						reg = <0xc>;
+				port@61 {
+					reg = <0x61>;
 
-						mixer_out3_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_out3_ep>;
-						};
+					xbar_mixer_out4_ep: endpoint {
+						remote-endpoint = <&mixer_out4_ep>;
 					};
+				};
 
-					mixer_out4_port: port@d {
-						reg = <0xd>;
+				port@62 {
+					reg = <0x62>;
 
-						mixer_out4_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_out4_ep>;
-						};
+					xbar_mixer_out5_ep: endpoint {
+						remote-endpoint = <&mixer_out5_ep>;
 					};
+				};
 
-					mixer_out5_port: port@e {
-						reg = <0xe>;
+				xbar_asrc_in1_port: port@63 {
+					reg = <0x63>;
 
-						mixer_out5_ep: endpoint {
-							remote-endpoint = <&xbar_mixer_out5_ep>;
-						};
+					xbar_asrc_in1_ep: endpoint {
+						remote-endpoint = <&asrc_in1_ep>;
 					};
 				};
-			};
 
-			asrc@2910000 {
-				status = "okay";
+				port@64 {
+					reg = <0x64>;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					xbar_asrc_out1_ep: endpoint {
+						remote-endpoint = <&asrc_out1_ep>;
+					};
+				};
 
-					port@0 {
-						reg = <0x0>;
+				xbar_asrc_in2_port: port@65 {
+					reg = <0x65>;
 
-						asrc_in1_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_in1_ep>;
-						};
+					xbar_asrc_in2_ep: endpoint {
+						remote-endpoint = <&asrc_in2_ep>;
 					};
+				};
 
-					port@1 {
-						reg = <0x1>;
+				port@66 {
+					reg = <0x66>;
 
-						asrc_in2_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_in2_ep>;
-						};
+					xbar_asrc_out2_ep: endpoint {
+						remote-endpoint = <&asrc_out2_ep>;
 					};
+				};
 
-					port@2 {
-						reg = <0x2>;
+				xbar_asrc_in3_port: port@67 {
+					reg = <0x67>;
 
-						asrc_in3_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_in3_ep>;
-						};
+					xbar_asrc_in3_ep: endpoint {
+						remote-endpoint = <&asrc_in3_ep>;
 					};
+				};
 
-					port@3 {
-						reg = <0x3>;
+				port@68 {
+					reg = <0x68>;
 
-						asrc_in4_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_in4_ep>;
-						};
+					xbar_asrc_out3_ep: endpoint {
+						remote-endpoint = <&asrc_out3_ep>;
 					};
+				};
 
-					port@4 {
-						reg = <0x4>;
+				xbar_asrc_in4_port: port@69 {
+					reg = <0x69>;
 
-						asrc_in5_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_in5_ep>;
-						};
+					xbar_asrc_in4_ep: endpoint {
+						remote-endpoint = <&asrc_in4_ep>;
 					};
+				};
 
-					port@5 {
-						reg = <0x5>;
+				port@6a {
+					reg = <0x6a>;
 
-						asrc_in6_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_in6_ep>;
-						};
+					xbar_asrc_out4_ep: endpoint {
+						remote-endpoint = <&asrc_out4_ep>;
 					};
+				};
 
-					port@6 {
-						reg = <0x6>;
+				xbar_asrc_in5_port: port@6b {
+					reg = <0x6b>;
 
-						asrc_in7_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_in7_ep>;
-						};
+					xbar_asrc_in5_ep: endpoint {
+						remote-endpoint = <&asrc_in5_ep>;
 					};
+				};
 
-					asrc_out1_port: port@7 {
-						reg = <0x7>;
+				port@6c {
+					reg = <0x6c>;
 
-						asrc_out1_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_out1_ep>;
-						};
+					xbar_asrc_out5_ep: endpoint {
+						remote-endpoint = <&asrc_out5_ep>;
 					};
+				};
 
-					asrc_out2_port: port@8 {
-						reg = <0x8>;
+				xbar_asrc_in6_port: port@6d {
+					reg = <0x6d>;
 
-						asrc_out2_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_out2_ep>;
-						};
+					xbar_asrc_in6_ep: endpoint {
+						remote-endpoint = <&asrc_in6_ep>;
 					};
+				};
 
-					asrc_out3_port: port@9 {
-						reg = <0x9>;
+				port@6e {
+					reg = <0x6e>;
 
-						asrc_out3_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_out3_ep>;
-						};
+					xbar_asrc_out6_ep: endpoint {
+						remote-endpoint = <&asrc_out6_ep>;
 					};
+				};
 
-					asrc_out4_port: port@a {
-						reg = <0xa>;
+				xbar_asrc_in7_port: port@6f {
+					reg = <0x6f>;
 
-						asrc_out4_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_out4_ep>;
-						};
+					xbar_asrc_in7_ep: endpoint {
+						remote-endpoint = <&asrc_in7_ep>;
 					};
+				};
 
-					asrc_out5_port: port@b {
-						reg = <0xb>;
+				xbar_ope1_in_port: port@70 {
+					reg = <0x70>;
 
-						asrc_out5_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_out5_ep>;
-						};
+					xbar_ope1_in_ep: endpoint {
+						remote-endpoint = <&ope1_cif_in_ep>;
 					};
+				};
 
-					asrc_out6_port:	port@c {
-						reg = <0xc>;
+				port@71 {
+					reg = <0x71>;
 
-						asrc_out6_ep: endpoint {
-							remote-endpoint = <&xbar_asrc_out6_ep>;
-						};
+					xbar_ope1_out_ep: endpoint {
+						remote-endpoint = <&ope1_cif_out_ep>;
 					};
 				};
 			};
 		};
+
+		dma-controller@2930000 {
+			status = "okay";
+		};
+
+		interrupt-controller@2a40000 {
+			status = "okay";
+		};
 	};
 
 	i2c@3160000 {
@@ -2283,6 +2283,10 @@ mmc@3400000 {
 		vmmc-supply = <&vdd_sd>;
 	};
 
+	sata@3507000 {
+		status = "okay";
+	};
+
 	hda@3510000 {
 		nvidia,model = "NVIDIA Jetson TX2 HDA";
 		status = "okay";
@@ -2471,10 +2475,6 @@ dpaux@155c0000 {
 		};
 	};
 
-	sata@3507000 {
-		status = "okay";
-	};
-
 	gpio-keys {
 		compatible = "gpio-keys";
 
@@ -2489,21 +2489,21 @@ key-power {
 			wakeup-source;
 		};
 
-		key-volume-up {
-			label = "Volume Up";
-			gpios = <&gpio_aon TEGRA186_AON_GPIO(FF, 1)
+		key-volume-down {
+			label = "Volume Down";
+			gpios = <&gpio_aon TEGRA186_AON_GPIO(FF, 2)
 					   GPIO_ACTIVE_LOW>;
 			linux,input-type = <EV_KEY>;
-			linux,code = <KEY_VOLUMEUP>;
+			linux,code = <KEY_VOLUMEDOWN>;
 			debounce-interval = <10>;
 		};
 
-		key-volume-down {
-			label = "Volume Down";
-			gpios = <&gpio_aon TEGRA186_AON_GPIO(FF, 2)
+		key-volume-up {
+			label = "Volume Up";
+			gpios = <&gpio_aon TEGRA186_AON_GPIO(FF, 1)
 					   GPIO_ACTIVE_LOW>;
 			linux,input-type = <EV_KEY>;
-			linux,code = <KEY_VOLUMEDOWN>;
+			linux,code = <KEY_VOLUMEUP>;
 			debounce-interval = <10>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/nvidia/tegra186-p3310.dtsi b/arch/arm64/boot/dts/nvidia/tegra186-p3310.dtsi
index aff857df25cf4..a4264ea417285 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186-p3310.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186-p3310.dtsi
@@ -190,32 +190,6 @@ pmc@c360000 {
 		nvidia,invert-interrupt;
 	};
 
-	cpus {
-		cpu@0 {
-			enable-method = "psci";
-		};
-
-		cpu@1 {
-			enable-method = "psci";
-		};
-
-		cpu@2 {
-			enable-method = "psci";
-		};
-
-		cpu@3 {
-			enable-method = "psci";
-		};
-
-		cpu@4 {
-			enable-method = "psci";
-		};
-
-		cpu@5 {
-			enable-method = "psci";
-		};
-	};
-
 	bpmp {
 		i2c {
 			status = "okay";
@@ -235,6 +209,23 @@ pmic: pmic@3c {
 				pinctrl-names = "default";
 				pinctrl-0 = <&max77620_default>;
 
+				fps {
+					fps0 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+						maxim,shutdown-fps-time-period-us = <640>;
+					};
+
+					fps1 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
+						maxim,shutdown-fps-time-period-us = <640>;
+					};
+
+					fps2 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+						maxim,shutdown-fps-time-period-us = <640>;
+					};
+				};
+
 				max77620_default: pinmux {
 					gpio0 {
 						pins = "gpio0";
@@ -284,23 +275,6 @@ gpio7 {
 					};
 				};
 
-				fps {
-					fps0 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-						maxim,shutdown-fps-time-period-us = <640>;
-					};
-
-					fps1 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
-						maxim,shutdown-fps-time-period-us = <640>;
-					};
-
-					fps2 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-						maxim,shutdown-fps-time-period-us = <640>;
-					};
-				};
-
 				regulators {
 					in-sd0-supply = <&vdd_5v0_sys>;
 					in-sd1-supply = <&vdd_5v0_sys>;
@@ -387,6 +361,32 @@ vdd_pex: ldo8 {
 		};
 	};
 
+	cpus {
+		cpu@0 {
+			enable-method = "psci";
+		};
+
+		cpu@1 {
+			enable-method = "psci";
+		};
+
+		cpu@2 {
+			enable-method = "psci";
+		};
+
+		cpu@3 {
+			enable-method = "psci";
+		};
+
+		cpu@4 {
+			enable-method = "psci";
+		};
+
+		cpu@5 {
+			enable-method = "psci";
+		};
+	};
+
 	psci {
 		compatible = "arm,psci-1.0";
 		status = "okay";
diff --git a/arch/arm64/boot/dts/nvidia/tegra186-p3509-0000+p3636-0001.dts b/arch/arm64/boot/dts/nvidia/tegra186-p3509-0000+p3636-0001.dts
index 3e83a4d52eb1e..26f71651933d1 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186-p3509-0000+p3636-0001.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra186-p3509-0000+p3636-0001.dts
@@ -56,679 +56,282 @@ phy: ethernet-phy@0 {
 		};
 	};
 
-	memory-controller@2c00000 {
-		status = "okay";
-	};
-
-	timer@3010000 {
+	aconnect@2900000 {
 		status = "okay";
-	};
 
-	serial@3100000 {
-		status = "okay";
-	};
+		ahub@2900800 {
+			status = "okay";
 
-	i2c@3160000 {
-		status = "okay";
-	};
+			i2s@2901000 {
+				status = "okay";
 
-	i2c@3180000 {
-		status = "okay";
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-		power-monitor@40 {
-			compatible = "ti,ina3221";
-			reg = <0x40>;
-			#address-cells = <1>;
-			#size-cells = <0>;
+					port@0 {
+						reg = <0>;
 
-			input@0 {
-				reg = <0>;
-				label = "VDD_IN";
-				shunt-resistor-micro-ohms = <5>;
-			};
+						i2s1_cif_ep: endpoint {
+							remote-endpoint = <&xbar_i2s1_ep>;
+						};
+					};
 
-			input@1 {
-				reg = <1>;
-				label = "VDD_CPU_GPU";
-				shunt-resistor-micro-ohms = <5>;
-			};
+					i2s1_port: port@1 {
+						reg = <1>;
 
-			input@2 {
-				reg = <2>;
-				label = "VDD_SOC";
-				shunt-resistor-micro-ohms = <5>;
+						i2s1_dap_ep: endpoint {
+							dai-format = "i2s";
+							/* Placeholder for external Codec */
+						};
+					};
+				};
 			};
-		};
-	};
 
-	ddc: i2c@3190000 {
-		status = "okay";
-	};
+			i2s@2901200 {
+				status = "okay";
 
-	i2c@31c0000 {
-		status = "okay";
-	};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-	i2c@31e0000 {
-		status = "okay";
-	};
+					port@0 {
+						reg = <0>;
 
-	/* SDMMC4 (eMMC) */
-	mmc@3460000 {
-		status = "okay";
-		bus-width = <8>;
-		non-removable;
+						i2s3_cif_ep: endpoint {
+							remote-endpoint = <&xbar_i2s3_ep>;
+						};
+					};
 
-		vqmmc-supply = <&vdd_1v8_ap>;
-		vmmc-supply = <&vdd_3v3_sys>;
-	};
+					i2s3_port: port@1 {
+						reg = <1>;
 
-	hda@3510000 {
-		nvidia,model = "NVIDIA Jetson TX2 NX HDA";
-		status = "okay";
-	};
+						i2s3_dap_ep: endpoint {
+							dai-format = "i2s";
+							/* Placeholder for external Codec */
+						};
+					};
+				};
+			};
 
-	padctl@3520000 {
-		status = "okay";
+			dmic@2904000 {
+				status = "okay";
 
-		avdd-pll-erefeut-supply = <&vdd_1v8_pll>;
-		avdd-usb-supply = <&vdd_3v3_sys>;
-		vclamp-usb-supply = <&vdd_1v8>;
-		vddio-hsic-supply = <&gnd>;
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-		pads {
-			usb2 {
-				status = "okay";
+					port@0 {
+						reg = <0>;
 
-				lanes {
-					micro_b: usb2-0 {
-						nvidia,function = "xusb";
-						status = "okay";
+						dmic1_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dmic1_ep>;
+						};
 					};
 
-					usb2-1 {
-						nvidia,function = "xusb";
-						status = "okay";
-					};
+					dmic1_port: port@1 {
+						reg = <1>;
 
-					usb2-2 {
-						nvidia,function = "xusb";
-						status = "okay";
+						dmic1_dap_ep: endpoint {
+							/* Place holder for external Codec */
+						};
 					};
 				};
 			};
 
-			usb3 {
+			dmic@2904100 {
 				status = "okay";
 
-				lanes {
-					usb3-1 {
-						nvidia,function = "xusb";
-						status = "okay";
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						dmic2_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dmic2_ep>;
+						};
 					};
-				};
-			};
-		};
 
-		ports {
-			usb2-0 {
-				status = "okay";
-				mode = "otg";
-				vbus-supply = <&vdd_5v0_sys>;
-				usb-role-switch;
+					dmic2_port: port@1 {
+						reg = <1>;
 
-				connector {
-					compatible = "gpio-usb-b-connector",
-						     "usb-b-connector";
-					label = "micro-USB";
-					type = "micro";
-					vbus-gpios = <&gpio
-						      TEGRA186_MAIN_GPIO(L, 4)
-						      GPIO_ACTIVE_LOW>;
-					id-gpios = <&pmic 0 GPIO_ACTIVE_HIGH>;
+						dmic2_dap_ep: endpoint {
+							/* Place holder for external Codec */
+						};
+					};
 				};
 			};
 
-			usb2-1 {
+			admaif@290f000 {
 				status = "okay";
-				mode = "host";
 
-				vbus-supply = <&vdd_5v0_sys>;
-			};
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-			usb2-2 {
-				status = "okay";
-				mode = "host";
+					admaif0_port: port@0 {
+						reg = <0x0>;
 
-				vbus-supply = <&vdd_5v0_sys>;
-			};
+						admaif0_ep: endpoint {
+							remote-endpoint = <&xbar_admaif0_ep>;
+						};
+					};
 
-			usb3-1 {
-				nvidia,usb2-companion = <1>;
-				vbus-supply = <&vdd_5v0_sys>;
-				status = "okay";
-			};
-		};
-	};
+					admaif1_port: port@1 {
+						reg = <0x1>;
 
-	usb@3530000 {
-		status = "okay";
+						admaif1_ep: endpoint {
+							remote-endpoint = <&xbar_admaif1_ep>;
+						};
+					};
 
-		phys = <&{/padctl@3520000/pads/usb2/lanes/usb2-0}>,
-		       <&{/padctl@3520000/pads/usb2/lanes/usb2-1}>,
-		       <&{/padctl@3520000/pads/usb2/lanes/usb2-2}>,
-		       <&{/padctl@3520000/pads/usb3/lanes/usb3-1}>;
-		phy-names = "usb2-0", "usb2-1", "usb2-2", "usb3-1";
-	};
+					admaif2_port: port@2 {
+						reg = <0x2>;
 
-	usb@3550000 {
-		status = "okay";
+						admaif2_ep: endpoint {
+							remote-endpoint = <&xbar_admaif2_ep>;
+						};
+					};
 
-		phys = <&micro_b>;
-		phy-names = "usb2-0";
-	};
+					admaif3_port: port@3 {
+						reg = <0x3>;
 
-	hsp@3c00000 {
-		status = "okay";
-	};
+						admaif3_ep: endpoint {
+							remote-endpoint = <&xbar_admaif3_ep>;
+						};
+					};
 
-	i2c@c240000 {
-		status = "okay";
-	};
+					admaif4_port: port@4 {
+						reg = <0x4>;
 
-	i2c@c250000 {
-		status = "okay";
+						admaif4_ep: endpoint {
+							remote-endpoint = <&xbar_admaif4_ep>;
+						};
+					};
 
-		/* module ID EEPROM */
-		eeprom@50 {
-			compatible = "atmel,24c02";
-			reg = <0x50>;
+					admaif5_port: port@5 {
+						reg = <0x5>;
 
-			label = "module";
-			vcc-supply = <&vdd_1v8>;
-			address-width = <8>;
-			pagesize = <8>;
-			size = <256>;
-			read-only;
-		};
-
-		/* carrier board ID EEPROM */
-		eeprom@57 {
-			compatible = "atmel,24c02";
-			reg = <0x57>;
-
-			label = "system";
-			vcc-supply = <&vdd_1v8>;
-			address-width = <8>;
-			pagesize = <8>;
-			size = <256>;
-			read-only;
-		};
-	};
-
-	rtc@c2a0000 {
-		status = "okay";
-	};
-
-	pwm@c340000 {
-		status = "okay";
-	};
-
-	pmc@c360000 {
-		nvidia,invert-interrupt;
-	};
-
-	pcie@10003000 {
-		status = "okay";
-
-		dvdd-pex-supply = <&vdd_pex>;
-		hvdd-pex-pll-supply = <&vdd_1v8>;
-		hvdd-pex-supply = <&vdd_1v8>;
-		vddio-pexctl-aud-supply = <&vdd_1v8>;
-
-		pci@1,0 {
-			nvidia,num-lanes = <2>;
-			status = "okay";
-		};
-
-		pci@2,0 {
-			nvidia,num-lanes = <1>;
-			status = "disabled";
-		};
-
-		pci@3,0 {
-			nvidia,num-lanes = <1>;
-			status = "okay";
-		};
-	};
-
-	host1x@13e00000 {
-		status = "okay";
-
-		dpaux@15040000 {
-			status = "okay";
-		};
-
-		display-hub@15200000 {
-			status = "okay";
-		};
-
-		dsi@15300000 {
-			status = "disabled";
-		};
-
-		/* DP */
-		sor@15540000 {
-			status = "okay";
-
-			avdd-io-hdmi-dp-supply = <&vdd_hdmi_1v05>;
-			vdd-hdmi-dp-pll-supply = <&vdd_1v8_ap>;
-
-			nvidia,dpaux = <&dpaux>;
-		};
-
-		/* HDMI */
-		sor@15580000 {
-			status = "okay";
-
-			avdd-io-hdmi-dp-supply = <&vdd_hdmi_1v05>;
-			vdd-hdmi-dp-pll-supply = <&vdd_1v8_ap>;
-			hdmi-supply = <&vdd_hdmi>;
-
-			nvidia,ddc-i2c-bus = <&ddc>;
-			nvidia,hpd-gpio = <&gpio TEGRA186_MAIN_GPIO(P, 1)
-						 GPIO_ACTIVE_LOW>;
-		};
-
-		dpaux@155c0000 {
-			status = "okay";
-		};
-	};
-
-	gpu@17000000 {
-		status = "okay";
-	};
-
-	fan: pwm-fan {
-		compatible = "pwm-fan";
-		pwms = <&pwm4 0 45334>;
-
-		cooling-levels = <0 64 128 255>;
-		#cooling-cells = <2>;
-	};
-
-	gpio-keys {
-		compatible = "gpio-keys";
-
-		key-power {
-			label = "Power";
-			gpios = <&gpio_aon TEGRA186_AON_GPIO(FF, 0)
-					   GPIO_ACTIVE_LOW>;
-			linux,input-type = <EV_KEY>;
-			linux,code = <KEY_POWER>;
-			debounce-interval = <10>;
-			wakeup-event-action = <EV_ACT_ASSERTED>;
-			wakeup-source;
-		};
-
-		key-volume-up {
-			label = "Volume Up";
-			gpios = <&gpio_aon TEGRA186_AON_GPIO(FF, 1)
-					   GPIO_ACTIVE_LOW>;
-			linux,input-type = <EV_KEY>;
-			linux,code = <KEY_VOLUMEUP>;
-			debounce-interval = <10>;
-		};
-
-		key-volume-down {
-			label = "Volume Down";
-			gpios = <&gpio_aon TEGRA186_AON_GPIO(FF, 2)
-					   GPIO_ACTIVE_LOW>;
-			linux,input-type = <EV_KEY>;
-			linux,code = <KEY_VOLUMEDOWN>;
-			debounce-interval = <10>;
-		};
-	};
-
-	cpus {
-		cpu@0 {
-			enable-method = "psci";
-		};
-
-		cpu@1 {
-			enable-method = "psci";
-		};
-
-		cpu@2 {
-			enable-method = "psci";
-		};
-
-		cpu@3 {
-			enable-method = "psci";
-		};
-
-		cpu@4 {
-			enable-method = "psci";
-		};
-
-		cpu@5 {
-			enable-method = "psci";
-		};
-	};
-
-	bpmp {
-		i2c {
-			status = "okay";
-
-			pmic: pmic@3c {
-				compatible = "maxim,max77620";
-				reg = <0x3c>;
-
-				interrupt-parent = <&pmc>;
-				interrupts = <24 IRQ_TYPE_LEVEL_LOW>;
-				#interrupt-cells = <2>;
-				interrupt-controller;
-
-				#gpio-cells = <2>;
-				gpio-controller;
-
-				pinctrl-names = "default";
-				pinctrl-0 = <&max77620_default>;
-
-				max77620_default: pinmux {
-					gpio0 {
-						pins = "gpio0";
-						function = "gpio";
-					};
-
-					gpio1 {
-						pins = "gpio1";
-						function = "fps-out";
-						maxim,active-fps-source = <MAX77620_FPS_SRC_0>;
-					};
-
-					gpio2 {
-						pins = "gpio2";
-						function = "fps-out";
-						maxim,active-fps-source = <MAX77620_FPS_SRC_1>;
-					};
-
-					gpio3 {
-						pins = "gpio3";
-						function = "fps-out";
-						maxim,active-fps-source = <MAX77620_FPS_SRC_1>;
-					};
-
-					gpio4 {
-						pins = "gpio4";
-						function = "32k-out1";
-						drive-push-pull = <1>;
-					};
-
-					gpio5 {
-						pins = "gpio5";
-						function = "gpio";
-						drive-push-pull = <0>;
-					};
-
-					gpio6 {
-						pins = "gpio6";
-						function = "gpio";
-						drive-push-pull = <1>;
+						admaif5_ep: endpoint {
+							remote-endpoint = <&xbar_admaif5_ep>;
+						};
 					};
 
-					gpio7 {
-						pins = "gpio7";
-						function = "gpio";
-						drive-push-pull = <1>;
-					};
-				};
+					admaif6_port: port@6 {
+						reg = <0x6>;
 
-				fps {
-					fps0 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-						maxim,shutdown-fps-time-period-us = <640>;
+						admaif6_ep: endpoint {
+							remote-endpoint = <&xbar_admaif6_ep>;
+						};
 					};
 
-					fps1 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
-						maxim,shutdown-fps-time-period-us = <640>;
-					};
+					admaif7_port: port@7 {
+						reg = <0x7>;
 
-					fps2 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-						maxim,shutdown-fps-time-period-us = <640>;
+						admaif7_ep: endpoint {
+							remote-endpoint = <&xbar_admaif7_ep>;
+						};
 					};
-				};
-
-				regulators {
-					in-sd0-supply = <&vdd_5v0_sys>;
-					in-sd1-supply = <&vdd_5v0_sys>;
-					in-sd2-supply = <&vdd_5v0_sys>;
-					in-sd3-supply = <&vdd_5v0_sys>;
 
-					in-ldo0-1-supply = <&vdd_5v0_sys>;
-					in-ldo2-supply = <&vdd_5v0_sys>;
-					in-ldo3-5-supply = <&vdd_5v0_sys>;
-					in-ldo4-6-supply = <&vdd_1v8>;
-					in-ldo7-8-supply = <&avdd_dsi_csi>;
+					admaif8_port: port@8 {
+						reg = <0x8>;
 
-					sd0 {
-						regulator-name = "VDD_DDR_1V1_PMIC";
-						regulator-min-microvolt = <1100000>;
-						regulator-max-microvolt = <1100000>;
-						regulator-always-on;
-						regulator-boot-on;
+						admaif8_ep: endpoint {
+							remote-endpoint = <&xbar_admaif8_ep>;
+						};
 					};
 
-					avdd_dsi_csi: sd1 {
-						regulator-name = "AVDD_DSI_CSI_1V2";
-						regulator-min-microvolt = <1200000>;
-						regulator-max-microvolt = <1200000>;
-					};
+					admaif9_port: port@9 {
+						reg = <0x9>;
 
-					vdd_1v8: sd2 {
-						regulator-name = "VDD_1V8";
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
+						admaif9_ep: endpoint {
+							remote-endpoint = <&xbar_admaif9_ep>;
+						};
 					};
 
-					vdd_3v3_sys: sd3 {
-						regulator-name = "VDD_3V3_SYS";
-						regulator-min-microvolt = <3300000>;
-						regulator-max-microvolt = <3300000>;
-					};
+					admaif10_port: port@a {
+						reg = <0xa>;
 
-					vdd_1v8_pll: ldo0 {
-						regulator-name = "VDD_1V8_AP_PLL";
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
+						admaif10_ep: endpoint {
+							remote-endpoint = <&xbar_admaif10_ep>;
+						};
 					};
 
-					ldo2 {
-						regulator-name = "VDDIO_3V3_AOHV";
-						regulator-min-microvolt = <3300000>;
-						regulator-max-microvolt = <3300000>;
-						regulator-always-on;
-						regulator-boot-on;
-					};
+					admaif11_port: port@b {
+						reg = <0xb>;
 
-					vddio_sdmmc1: ldo3 {
-						regulator-name = "VDDIO_SDMMC1_AP";
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <3300000>;
+						admaif11_ep: endpoint {
+							remote-endpoint = <&xbar_admaif11_ep>;
+						};
 					};
 
-					ldo4 {
-						regulator-name = "VDD_RTC";
-						regulator-min-microvolt = <1000000>;
-						regulator-max-microvolt = <1000000>;
-					};
+					admaif12_port: port@c {
+						reg = <0xc>;
 
-					vddio_sdmmc3: ldo5 {
-						regulator-name = "VDDIO_SDMMC3_AP";
-						regulator-min-microvolt = <2800000>;
-						regulator-max-microvolt = <2800000>;
+						admaif12_ep: endpoint {
+							remote-endpoint = <&xbar_admaif12_ep>;
+						};
 					};
 
-					vdd_hdmi_1v05: ldo7 {
-						regulator-name = "VDD_HDMI_1V05";
-						regulator-min-microvolt = <1050000>;
-						regulator-max-microvolt = <1050000>;
-					};
+					admaif13_port: port@d {
+						reg = <0xd>;
 
-					vdd_pex: ldo8 {
-						regulator-name = "VDD_PEX_1V05";
-						regulator-min-microvolt = <1050000>;
-						regulator-max-microvolt = <1050000>;
+						admaif13_ep: endpoint {
+							remote-endpoint = <&xbar_admaif13_ep>;
+						};
 					};
-				};
-			};
-		};
-	};
-
-	psci {
-		compatible = "arm,psci-1.0";
-		status = "okay";
-		method = "smc";
-	};
-
-	gnd: regulator-gnd {
-		compatible = "regulator-fixed";
-		regulator-name = "GND";
-		regulator-min-microvolt = <0>;
-		regulator-max-microvolt = <0>;
-		regulator-always-on;
-		regulator-boot-on;
-	};
-
-	vdd_5v0_sys: regulator-vdd-5v0-sys {
-		compatible = "regulator-fixed";
-		regulator-name = "VDD_5V0_SYS";
-		regulator-min-microvolt = <5000000>;
-		regulator-max-microvolt = <5000000>;
-		regulator-always-on;
-		regulator-boot-on;
-	};
-
-	vdd_1v8_ap: regulator-vdd-1v8-ap {
-		compatible = "regulator-fixed";
-		regulator-name = "VDD_1V8_AP";
-		regulator-min-microvolt = <1800000>;
-		regulator-max-microvolt = <1800000>;
-
-		gpio = <&pmic 1 GPIO_ACTIVE_HIGH>;
-		enable-active-high;
-
-		vin-supply = <&vdd_1v8>;
-	};
-
-	vdd_hdmi: regulator-vdd-hdmi {
-		compatible = "regulator-fixed";
-		regulator-name = "VDD_5V0_HDMI_CON";
-		regulator-min-microvolt = <5000000>;
-		regulator-max-microvolt = <5000000>;
-
-		vin-supply = <&vdd_5v0_sys>;
-	};
-
-	thermal-zones {
-		cpu-thermal {
-			polling-delay = <0>;
-			polling-delay-passive = <500>;
-			status = "okay";
-
-			trips {
-				cpu_trip_critical: critical {
-					temperature = <96500>;
-					hysteresis = <0>;
-					type = "critical";
-				};
-
-				cpu_trip_hot: hot {
-					temperature = <79000>;
-					hysteresis = <2000>;
-					type = "hot";
-				};
-
-				cpu_trip_active: active {
-					temperature = <62000>;
-					hysteresis = <2000>;
-					type = "active";
-				};
-
-				cpu_trip_passive: passive {
-					temperature = <45000>;
-					hysteresis = <2000>;
-					type = "passive";
-				};
-			};
-
-			cooling-maps {
-				cpu-critical {
-					cooling-device = <&fan 3 3>;
-					trip = <&cpu_trip_critical>;
-				};
 
-				cpu-hot {
-					cooling-device = <&fan 2 2>;
-					trip = <&cpu_trip_hot>;
-				};
+					admaif14_port: port@e {
+						reg = <0xe>;
 
-				cpu-active {
-					cooling-device = <&fan 1 1>;
-					trip = <&cpu_trip_active>;
-				};
+						admaif14_ep: endpoint {
+							remote-endpoint = <&xbar_admaif14_ep>;
+						};
+					};
 
-				cpu-passive {
-					cooling-device = <&fan 0 0>;
-					trip = <&cpu_trip_passive>;
-				};
-			};
-		};
+					admaif15_port: port@f {
+						reg = <0xf>;
 
-		aux-thermal {
-			polling-delay = <0>;
-			polling-delay-passive = <500>;
-			status = "okay";
+						admaif15_ep: endpoint {
+							remote-endpoint = <&xbar_admaif15_ep>;
+						};
+					};
 
-			trips {
-				aux_alert0: critical {
-					temperature = <90000>;
-					hysteresis = <0>;
-					type = "critical";
-				};
-			};
-		};
+					admaif16_port: port@10 {
+						reg = <0x10>;
 
-		gpu-thermal {
-			polling-delay = <0>;
-			polling-delay-passive = <500>;
-			status = "okay";
+						admaif16_ep: endpoint {
+							remote-endpoint = <&xbar_admaif16_ep>;
+						};
+					};
 
-			trips {
-				gpu_alert0: critical {
-					temperature = <99000>;
-					hysteresis = <0>;
-					type = "critical";
-				};
-			};
-		};
-	};
+					admaif17_port: port@11 {
+						reg = <0x11>;
 
-	aconnect@2900000 {
-		status = "okay";
+						admaif17_ep: endpoint {
+							remote-endpoint = <&xbar_admaif17_ep>;
+						};
+					};
 
-		dma-controller@2930000 {
-			status = "okay";
-		};
+					admaif18_port: port@12 {
+						reg = <0x12>;
 
-		interrupt-controller@2a40000 {
-			status = "okay";
-		};
+						admaif18_ep: endpoint {
+							remote-endpoint = <&xbar_admaif18_ep>;
+						};
+					};
 
-		ahub@2900800 {
-			status = "okay";
+					admaif19_port: port@13 {
+						reg = <0x13>;
+
+						admaif19_ep: endpoint {
+							remote-endpoint = <&xbar_admaif19_ep>;
+						};
+					};
+				};
+			};
 
 			ports {
 				#address-cells = <1>;
@@ -809,395 +412,708 @@ xbar_admaif8_ep: endpoint {
 				port@9 {
 					reg = <0x9>;
 
-					xbar_admaif9_ep: endpoint {
-						remote-endpoint = <&admaif9_ep>;
-					};
-				};
+					xbar_admaif9_ep: endpoint {
+						remote-endpoint = <&admaif9_ep>;
+					};
+				};
+
+				port@a {
+					reg = <0xa>;
+
+					xbar_admaif10_ep: endpoint {
+						remote-endpoint = <&admaif10_ep>;
+					};
+				};
+
+				port@b {
+					reg = <0xb>;
+
+					xbar_admaif11_ep: endpoint {
+						remote-endpoint = <&admaif11_ep>;
+					};
+				};
+
+				port@c {
+					reg = <0xc>;
+
+					xbar_admaif12_ep: endpoint {
+						remote-endpoint = <&admaif12_ep>;
+					};
+				};
+
+				port@d {
+					reg = <0xd>;
+
+					xbar_admaif13_ep: endpoint {
+						remote-endpoint = <&admaif13_ep>;
+					};
+				};
+
+				port@e {
+					reg = <0xe>;
+
+					xbar_admaif14_ep: endpoint {
+						remote-endpoint = <&admaif14_ep>;
+					};
+				};
+
+				port@f {
+					reg = <0xf>;
+
+					xbar_admaif15_ep: endpoint {
+						remote-endpoint = <&admaif15_ep>;
+					};
+				};
+
+				port@10 {
+					reg = <0x10>;
+
+					xbar_admaif16_ep: endpoint {
+						remote-endpoint = <&admaif16_ep>;
+					};
+				};
+
+				port@11 {
+					reg = <0x11>;
+
+					xbar_admaif17_ep: endpoint {
+						remote-endpoint = <&admaif17_ep>;
+					};
+				};
+
+				port@12 {
+					reg = <0x12>;
+
+					xbar_admaif18_ep: endpoint {
+						remote-endpoint = <&admaif18_ep>;
+					};
+				};
+
+				port@13 {
+					reg = <0x13>;
+
+					xbar_admaif19_ep: endpoint {
+						remote-endpoint = <&admaif19_ep>;
+					};
+				};
+
+				xbar_i2s1_port: port@14 {
+					reg = <0x14>;
+
+					xbar_i2s1_ep: endpoint {
+						remote-endpoint = <&i2s1_cif_ep>;
+					};
+				};
+
+				xbar_i2s3_port: port@16 {
+					reg = <0x16>;
+
+					xbar_i2s3_ep: endpoint {
+						remote-endpoint = <&i2s3_cif_ep>;
+					};
+				};
+
+				xbar_dmic1_port: port@1a {
+					reg = <0x1a>;
+
+					xbar_dmic1_ep: endpoint {
+						remote-endpoint = <&dmic1_cif_ep>;
+					};
+				};
+
+				xbar_dmic2_port: port@1b {
+					reg = <0x1b>;
+
+					xbar_dmic2_ep: endpoint {
+						remote-endpoint = <&dmic2_cif_ep>;
+					};
+				};
+			};
+		};
+
+		dma-controller@2930000 {
+			status = "okay";
+		};
+
+		interrupt-controller@2a40000 {
+			status = "okay";
+		};
+	};
+
+	memory-controller@2c00000 {
+		status = "okay";
+	};
+
+	timer@3010000 {
+		status = "okay";
+	};
+
+	serial@3100000 {
+		status = "okay";
+	};
+
+	i2c@3160000 {
+		status = "okay";
+	};
+
+	i2c@3180000 {
+		status = "okay";
+
+		power-monitor@40 {
+			compatible = "ti,ina3221";
+			reg = <0x40>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			input@0 {
+				reg = <0>;
+				label = "VDD_IN";
+				shunt-resistor-micro-ohms = <5>;
+			};
+
+			input@1 {
+				reg = <1>;
+				label = "VDD_CPU_GPU";
+				shunt-resistor-micro-ohms = <5>;
+			};
+
+			input@2 {
+				reg = <2>;
+				label = "VDD_SOC";
+				shunt-resistor-micro-ohms = <5>;
+			};
+		};
+	};
+
+	ddc: i2c@3190000 {
+		status = "okay";
+	};
+
+	i2c@31c0000 {
+		status = "okay";
+	};
+
+	i2c@31e0000 {
+		status = "okay";
+	};
 
-				port@a {
-					reg = <0xa>;
+	/* SDMMC4 (eMMC) */
+	mmc@3460000 {
+		status = "okay";
+		bus-width = <8>;
+		non-removable;
 
-					xbar_admaif10_ep: endpoint {
-						remote-endpoint = <&admaif10_ep>;
-					};
-				};
+		vqmmc-supply = <&vdd_1v8_ap>;
+		vmmc-supply = <&vdd_3v3_sys>;
+	};
 
-				port@b {
-					reg = <0xb>;
+	hda@3510000 {
+		nvidia,model = "NVIDIA Jetson TX2 NX HDA";
+		status = "okay";
+	};
 
-					xbar_admaif11_ep: endpoint {
-						remote-endpoint = <&admaif11_ep>;
-					};
-				};
+	padctl@3520000 {
+		status = "okay";
 
-				port@c {
-					reg = <0xc>;
+		avdd-pll-erefeut-supply = <&vdd_1v8_pll>;
+		avdd-usb-supply = <&vdd_3v3_sys>;
+		vclamp-usb-supply = <&vdd_1v8>;
+		vddio-hsic-supply = <&gnd>;
 
-					xbar_admaif12_ep: endpoint {
-						remote-endpoint = <&admaif12_ep>;
+		pads {
+			usb2 {
+				status = "okay";
+
+				lanes {
+					micro_b: usb2-0 {
+						nvidia,function = "xusb";
+						status = "okay";
 					};
-				};
 
-				port@d {
-					reg = <0xd>;
+					usb2-1 {
+						nvidia,function = "xusb";
+						status = "okay";
+					};
 
-					xbar_admaif13_ep: endpoint {
-						remote-endpoint = <&admaif13_ep>;
+					usb2-2 {
+						nvidia,function = "xusb";
+						status = "okay";
 					};
 				};
+			};
 
-				port@e {
-					reg = <0xe>;
+			usb3 {
+				status = "okay";
 
-					xbar_admaif14_ep: endpoint {
-						remote-endpoint = <&admaif14_ep>;
+				lanes {
+					usb3-1 {
+						nvidia,function = "xusb";
+						status = "okay";
 					};
 				};
+			};
+		};
 
-				port@f {
-					reg = <0xf>;
+		ports {
+			usb2-0 {
+				status = "okay";
+				mode = "otg";
+				vbus-supply = <&vdd_5v0_sys>;
+				usb-role-switch;
 
-					xbar_admaif15_ep: endpoint {
-						remote-endpoint = <&admaif15_ep>;
-					};
+				connector {
+					compatible = "gpio-usb-b-connector",
+						     "usb-b-connector";
+					label = "micro-USB";
+					type = "micro";
+					vbus-gpios = <&gpio
+						      TEGRA186_MAIN_GPIO(L, 4)
+						      GPIO_ACTIVE_LOW>;
+					id-gpios = <&pmic 0 GPIO_ACTIVE_HIGH>;
 				};
+			};
 
-				port@10 {
-					reg = <0x10>;
+			usb2-1 {
+				status = "okay";
+				mode = "host";
 
-					xbar_admaif16_ep: endpoint {
-						remote-endpoint = <&admaif16_ep>;
-					};
-				};
+				vbus-supply = <&vdd_5v0_sys>;
+			};
 
-				port@11 {
-					reg = <0x11>;
+			usb2-2 {
+				status = "okay";
+				mode = "host";
 
-					xbar_admaif17_ep: endpoint {
-						remote-endpoint = <&admaif17_ep>;
-					};
-				};
+				vbus-supply = <&vdd_5v0_sys>;
+			};
 
-				port@12 {
-					reg = <0x12>;
+			usb3-1 {
+				nvidia,usb2-companion = <1>;
+				vbus-supply = <&vdd_5v0_sys>;
+				status = "okay";
+			};
+		};
+	};
 
-					xbar_admaif18_ep: endpoint {
-						remote-endpoint = <&admaif18_ep>;
-					};
-				};
+	usb@3530000 {
+		status = "okay";
 
-				port@13 {
-					reg = <0x13>;
+		phys = <&{/padctl@3520000/pads/usb2/lanes/usb2-0}>,
+		       <&{/padctl@3520000/pads/usb2/lanes/usb2-1}>,
+		       <&{/padctl@3520000/pads/usb2/lanes/usb2-2}>,
+		       <&{/padctl@3520000/pads/usb3/lanes/usb3-1}>;
+		phy-names = "usb2-0", "usb2-1", "usb2-2", "usb3-1";
+	};
 
-					xbar_admaif19_ep: endpoint {
-						remote-endpoint = <&admaif19_ep>;
-					};
-				};
+	usb@3550000 {
+		status = "okay";
 
-				xbar_i2s1_port: port@14 {
-					reg = <0x14>;
+		phys = <&micro_b>;
+		phy-names = "usb2-0";
+	};
 
-					xbar_i2s1_ep: endpoint {
-						remote-endpoint = <&i2s1_cif_ep>;
-					};
-				};
+	hsp@3c00000 {
+		status = "okay";
+	};
 
-				xbar_i2s3_port: port@16 {
-					reg = <0x16>;
+	i2c@c240000 {
+		status = "okay";
+	};
 
-					xbar_i2s3_ep: endpoint {
-						remote-endpoint = <&i2s3_cif_ep>;
-					};
-				};
+	i2c@c250000 {
+		status = "okay";
 
-				xbar_dmic1_port: port@1a {
-					reg = <0x1a>;
+		/* module ID EEPROM */
+		eeprom@50 {
+			compatible = "atmel,24c02";
+			reg = <0x50>;
 
-					xbar_dmic1_ep: endpoint {
-						remote-endpoint = <&dmic1_cif_ep>;
-					};
-				};
+			label = "module";
+			vcc-supply = <&vdd_1v8>;
+			address-width = <8>;
+			pagesize = <8>;
+			size = <256>;
+			read-only;
+		};
 
-				xbar_dmic2_port: port@1b {
-					reg = <0x1b>;
+		/* carrier board ID EEPROM */
+		eeprom@57 {
+			compatible = "atmel,24c02";
+			reg = <0x57>;
 
-					xbar_dmic2_ep: endpoint {
-						remote-endpoint = <&dmic2_cif_ep>;
-					};
-				};
-			};
+			label = "system";
+			vcc-supply = <&vdd_1v8>;
+			address-width = <8>;
+			pagesize = <8>;
+			size = <256>;
+			read-only;
+		};
+	};
 
-			admaif@290f000 {
-				status = "okay";
+	rtc@c2a0000 {
+		status = "okay";
+	};
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+	pwm@c340000 {
+		status = "okay";
+	};
 
-					admaif0_port: port@0 {
-						reg = <0x0>;
+	pmc@c360000 {
+		nvidia,invert-interrupt;
+	};
 
-						admaif0_ep: endpoint {
-							remote-endpoint = <&xbar_admaif0_ep>;
-						};
-					};
+	pcie@10003000 {
+		status = "okay";
 
-					admaif1_port: port@1 {
-						reg = <0x1>;
+		dvdd-pex-supply = <&vdd_pex>;
+		hvdd-pex-pll-supply = <&vdd_1v8>;
+		hvdd-pex-supply = <&vdd_1v8>;
+		vddio-pexctl-aud-supply = <&vdd_1v8>;
 
-						admaif1_ep: endpoint {
-							remote-endpoint = <&xbar_admaif1_ep>;
-						};
-					};
+		pci@1,0 {
+			nvidia,num-lanes = <2>;
+			status = "okay";
+		};
 
-					admaif2_port: port@2 {
-						reg = <0x2>;
+		pci@2,0 {
+			nvidia,num-lanes = <1>;
+			status = "disabled";
+		};
 
-						admaif2_ep: endpoint {
-							remote-endpoint = <&xbar_admaif2_ep>;
-						};
-					};
+		pci@3,0 {
+			nvidia,num-lanes = <1>;
+			status = "okay";
+		};
+	};
 
-					admaif3_port: port@3 {
-						reg = <0x3>;
+	host1x@13e00000 {
+		status = "okay";
 
-						admaif3_ep: endpoint {
-							remote-endpoint = <&xbar_admaif3_ep>;
-						};
-					};
+		dpaux@15040000 {
+			status = "okay";
+		};
 
-					admaif4_port: port@4 {
-						reg = <0x4>;
+		display-hub@15200000 {
+			status = "okay";
+		};
 
-						admaif4_ep: endpoint {
-							remote-endpoint = <&xbar_admaif4_ep>;
-						};
-					};
+		dsi@15300000 {
+			status = "disabled";
+		};
 
-					admaif5_port: port@5 {
-						reg = <0x5>;
+		/* DP */
+		sor@15540000 {
+			status = "okay";
 
-						admaif5_ep: endpoint {
-							remote-endpoint = <&xbar_admaif5_ep>;
-						};
-					};
+			avdd-io-hdmi-dp-supply = <&vdd_hdmi_1v05>;
+			vdd-hdmi-dp-pll-supply = <&vdd_1v8_ap>;
 
-					admaif6_port: port@6 {
-						reg = <0x6>;
+			nvidia,dpaux = <&dpaux>;
+		};
 
-						admaif6_ep: endpoint {
-							remote-endpoint = <&xbar_admaif6_ep>;
-						};
-					};
+		/* HDMI */
+		sor@15580000 {
+			status = "okay";
 
-					admaif7_port: port@7 {
-						reg = <0x7>;
+			avdd-io-hdmi-dp-supply = <&vdd_hdmi_1v05>;
+			vdd-hdmi-dp-pll-supply = <&vdd_1v8_ap>;
+			hdmi-supply = <&vdd_hdmi>;
 
-						admaif7_ep: endpoint {
-							remote-endpoint = <&xbar_admaif7_ep>;
-						};
-					};
+			nvidia,ddc-i2c-bus = <&ddc>;
+			nvidia,hpd-gpio = <&gpio TEGRA186_MAIN_GPIO(P, 1)
+						 GPIO_ACTIVE_LOW>;
+		};
 
-					admaif8_port: port@8 {
-						reg = <0x8>;
+		dpaux@155c0000 {
+			status = "okay";
+		};
+	};
 
-						admaif8_ep: endpoint {
-							remote-endpoint = <&xbar_admaif8_ep>;
-						};
-					};
+	gpu@17000000 {
+		status = "okay";
+	};
 
-					admaif9_port: port@9 {
-						reg = <0x9>;
+	bpmp {
+		i2c {
+			status = "okay";
 
-						admaif9_ep: endpoint {
-							remote-endpoint = <&xbar_admaif9_ep>;
-						};
-					};
+			pmic: pmic@3c {
+				compatible = "maxim,max77620";
+				reg = <0x3c>;
 
-					admaif10_port: port@a {
-						reg = <0xa>;
+				interrupt-parent = <&pmc>;
+				interrupts = <24 IRQ_TYPE_LEVEL_LOW>;
+				#interrupt-cells = <2>;
+				interrupt-controller;
 
-						admaif10_ep: endpoint {
-							remote-endpoint = <&xbar_admaif10_ep>;
-						};
-					};
+				#gpio-cells = <2>;
+				gpio-controller;
 
-					admaif11_port: port@b {
-						reg = <0xb>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&max77620_default>;
 
-						admaif11_ep: endpoint {
-							remote-endpoint = <&xbar_admaif11_ep>;
-						};
+				fps {
+					fps0 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+						maxim,shutdown-fps-time-period-us = <640>;
 					};
 
-					admaif12_port: port@c {
-						reg = <0xc>;
+					fps1 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
+						maxim,shutdown-fps-time-period-us = <640>;
+					};
 
-						admaif12_ep: endpoint {
-							remote-endpoint = <&xbar_admaif12_ep>;
-						};
+					fps2 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+						maxim,shutdown-fps-time-period-us = <640>;
 					};
+				};
 
-					admaif13_port: port@d {
-						reg = <0xd>;
+				max77620_default: pinmux {
+					gpio0 {
+						pins = "gpio0";
+						function = "gpio";
+					};
 
-						admaif13_ep: endpoint {
-							remote-endpoint = <&xbar_admaif13_ep>;
-						};
+					gpio1 {
+						pins = "gpio1";
+						function = "fps-out";
+						maxim,active-fps-source = <MAX77620_FPS_SRC_0>;
 					};
 
-					admaif14_port: port@e {
-						reg = <0xe>;
+					gpio2 {
+						pins = "gpio2";
+						function = "fps-out";
+						maxim,active-fps-source = <MAX77620_FPS_SRC_1>;
+					};
 
-						admaif14_ep: endpoint {
-							remote-endpoint = <&xbar_admaif14_ep>;
-						};
+					gpio3 {
+						pins = "gpio3";
+						function = "fps-out";
+						maxim,active-fps-source = <MAX77620_FPS_SRC_1>;
 					};
 
-					admaif15_port: port@f {
-						reg = <0xf>;
+					gpio4 {
+						pins = "gpio4";
+						function = "32k-out1";
+						drive-push-pull = <1>;
+					};
 
-						admaif15_ep: endpoint {
-							remote-endpoint = <&xbar_admaif15_ep>;
-						};
+					gpio5 {
+						pins = "gpio5";
+						function = "gpio";
+						drive-push-pull = <0>;
 					};
 
-					admaif16_port: port@10 {
-						reg = <0x10>;
+					gpio6 {
+						pins = "gpio6";
+						function = "gpio";
+						drive-push-pull = <1>;
+					};
 
-						admaif16_ep: endpoint {
-							remote-endpoint = <&xbar_admaif16_ep>;
-						};
+					gpio7 {
+						pins = "gpio7";
+						function = "gpio";
+						drive-push-pull = <1>;
 					};
+				};
 
-					admaif17_port: port@11 {
-						reg = <0x11>;
+				regulators {
+					in-sd0-supply = <&vdd_5v0_sys>;
+					in-sd1-supply = <&vdd_5v0_sys>;
+					in-sd2-supply = <&vdd_5v0_sys>;
+					in-sd3-supply = <&vdd_5v0_sys>;
 
-						admaif17_ep: endpoint {
-							remote-endpoint = <&xbar_admaif17_ep>;
-						};
+					in-ldo0-1-supply = <&vdd_5v0_sys>;
+					in-ldo2-supply = <&vdd_5v0_sys>;
+					in-ldo3-5-supply = <&vdd_5v0_sys>;
+					in-ldo4-6-supply = <&vdd_1v8>;
+					in-ldo7-8-supply = <&avdd_dsi_csi>;
+
+					sd0 {
+						regulator-name = "VDD_DDR_1V1_PMIC";
+						regulator-min-microvolt = <1100000>;
+						regulator-max-microvolt = <1100000>;
+						regulator-always-on;
+						regulator-boot-on;
 					};
 
-					admaif18_port: port@12 {
-						reg = <0x12>;
+					avdd_dsi_csi: sd1 {
+						regulator-name = "AVDD_DSI_CSI_1V2";
+						regulator-min-microvolt = <1200000>;
+						regulator-max-microvolt = <1200000>;
+					};
 
-						admaif18_ep: endpoint {
-							remote-endpoint = <&xbar_admaif18_ep>;
-						};
+					vdd_1v8: sd2 {
+						regulator-name = "VDD_1V8";
+						regulator-min-microvolt = <1800000>;
+						regulator-max-microvolt = <1800000>;
 					};
 
-					admaif19_port: port@13 {
-						reg = <0x13>;
+					vdd_3v3_sys: sd3 {
+						regulator-name = "VDD_3V3_SYS";
+						regulator-min-microvolt = <3300000>;
+						regulator-max-microvolt = <3300000>;
+					};
 
-						admaif19_ep: endpoint {
-							remote-endpoint = <&xbar_admaif19_ep>;
-						};
+					vdd_1v8_pll: ldo0 {
+						regulator-name = "VDD_1V8_AP_PLL";
+						regulator-min-microvolt = <1800000>;
+						regulator-max-microvolt = <1800000>;
 					};
-				};
-			};
 
-			i2s@2901000 {
-				status = "okay";
+					ldo2 {
+						regulator-name = "VDDIO_3V3_AOHV";
+						regulator-min-microvolt = <3300000>;
+						regulator-max-microvolt = <3300000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+					vddio_sdmmc1: ldo3 {
+						regulator-name = "VDDIO_SDMMC1_AP";
+						regulator-min-microvolt = <1800000>;
+						regulator-max-microvolt = <3300000>;
+					};
 
-					port@0 {
-						reg = <0>;
+					ldo4 {
+						regulator-name = "VDD_RTC";
+						regulator-min-microvolt = <1000000>;
+						regulator-max-microvolt = <1000000>;
+					};
 
-						i2s1_cif_ep: endpoint {
-							remote-endpoint = <&xbar_i2s1_ep>;
-						};
+					vddio_sdmmc3: ldo5 {
+						regulator-name = "VDDIO_SDMMC3_AP";
+						regulator-min-microvolt = <2800000>;
+						regulator-max-microvolt = <2800000>;
 					};
 
-					i2s1_port: port@1 {
-						reg = <1>;
+					vdd_hdmi_1v05: ldo7 {
+						regulator-name = "VDD_HDMI_1V05";
+						regulator-min-microvolt = <1050000>;
+						regulator-max-microvolt = <1050000>;
+					};
 
-						i2s1_dap_ep: endpoint {
-							dai-format = "i2s";
-							/* Placeholder for external Codec */
-						};
+					vdd_pex: ldo8 {
+						regulator-name = "VDD_PEX_1V05";
+						regulator-min-microvolt = <1050000>;
+						regulator-max-microvolt = <1050000>;
 					};
 				};
 			};
+		};
+	};
 
-			i2s@2901200 {
-				status = "okay";
+	cpus {
+		cpu@0 {
+			enable-method = "psci";
+		};
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+		cpu@1 {
+			enable-method = "psci";
+		};
 
-					port@0 {
-						reg = <0>;
+		cpu@2 {
+			enable-method = "psci";
+		};
 
-						i2s3_cif_ep: endpoint {
-							remote-endpoint = <&xbar_i2s3_ep>;
-						};
-					};
+		cpu@3 {
+			enable-method = "psci";
+		};
 
-					i2s3_port: port@1 {
-						reg = <1>;
+		cpu@4 {
+			enable-method = "psci";
+		};
 
-						i2s3_dap_ep: endpoint {
-							dai-format = "i2s";
-							/* Placeholder for external Codec */
-						};
-					};
-				};
-			};
+		cpu@5 {
+			enable-method = "psci";
+		};
+	};
 
-			dmic@2904000 {
-				status = "okay";
+	gpio-keys {
+		compatible = "gpio-keys";
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+		key-power {
+			label = "Power";
+			gpios = <&gpio_aon TEGRA186_AON_GPIO(FF, 0)
+					   GPIO_ACTIVE_LOW>;
+			linux,input-type = <EV_KEY>;
+			linux,code = <KEY_POWER>;
+			debounce-interval = <10>;
+			wakeup-event-action = <EV_ACT_ASSERTED>;
+			wakeup-source;
+		};
 
-					port@0 {
-						reg = <0>;
+		key-volume-down {
+			label = "Volume Down";
+			gpios = <&gpio_aon TEGRA186_AON_GPIO(FF, 2)
+					   GPIO_ACTIVE_LOW>;
+			linux,input-type = <EV_KEY>;
+			linux,code = <KEY_VOLUMEDOWN>;
+			debounce-interval = <10>;
+		};
 
-						dmic1_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dmic1_ep>;
-						};
-					};
+		key-volume-up {
+			label = "Volume Up";
+			gpios = <&gpio_aon TEGRA186_AON_GPIO(FF, 1)
+					   GPIO_ACTIVE_LOW>;
+			linux,input-type = <EV_KEY>;
+			linux,code = <KEY_VOLUMEUP>;
+			debounce-interval = <10>;
+		};
+	};
 
-					dmic1_port: port@1 {
-						reg = <1>;
+	psci {
+		compatible = "arm,psci-1.0";
+		status = "okay";
+		method = "smc";
+	};
 
-						dmic1_dap_ep: endpoint {
-							/* Place holder for external Codec */
-						};
-					};
-				};
-			};
+	fan: pwm-fan {
+		compatible = "pwm-fan";
+		pwms = <&pwm4 0 45334>;
 
-			dmic@2904100 {
-				status = "okay";
+		cooling-levels = <0 64 128 255>;
+		#cooling-cells = <2>;
+	};
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+	gnd: regulator-gnd {
+		compatible = "regulator-fixed";
+		regulator-name = "GND";
+		regulator-min-microvolt = <0>;
+		regulator-max-microvolt = <0>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
 
-					port@0 {
-						reg = <0>;
+	vdd_5v0_sys: regulator-vdd-5v0-sys {
+		compatible = "regulator-fixed";
+		regulator-name = "VDD_5V0_SYS";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
 
-						dmic2_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dmic2_ep>;
-						};
-					};
+	vdd_1v8_ap: regulator-vdd-1v8-ap {
+		compatible = "regulator-fixed";
+		regulator-name = "VDD_1V8_AP";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
 
-					dmic2_port: port@1 {
-						reg = <1>;
+		gpio = <&pmic 1 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
 
-						dmic2_dap_ep: endpoint {
-							/* Place holder for external Codec */
-						};
-					};
-				};
-			};
-		};
+		vin-supply = <&vdd_1v8>;
+	};
+
+	vdd_hdmi: regulator-vdd-hdmi {
+		compatible = "regulator-fixed";
+		regulator-name = "VDD_5V0_HDMI_CON";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+
+		vin-supply = <&vdd_5v0_sys>;
 	};
 
 	sound {
@@ -1219,4 +1135,88 @@ sound {
 
 		label = "NVIDIA Jetson TX2 NX APE";
 	};
+
+	thermal-zones {
+		cpu-thermal {
+			polling-delay = <0>;
+			polling-delay-passive = <500>;
+			status = "okay";
+
+			trips {
+				cpu_trip_critical: critical {
+					temperature = <96500>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				cpu_trip_hot: hot {
+					temperature = <79000>;
+					hysteresis = <2000>;
+					type = "hot";
+				};
+
+				cpu_trip_active: active {
+					temperature = <62000>;
+					hysteresis = <2000>;
+					type = "active";
+				};
+
+				cpu_trip_passive: passive {
+					temperature = <45000>;
+					hysteresis = <2000>;
+					type = "passive";
+				};
+			};
+
+			cooling-maps {
+				cpu-critical {
+					cooling-device = <&fan 3 3>;
+					trip = <&cpu_trip_critical>;
+				};
+
+				cpu-hot {
+					cooling-device = <&fan 2 2>;
+					trip = <&cpu_trip_hot>;
+				};
+
+				cpu-active {
+					cooling-device = <&fan 1 1>;
+					trip = <&cpu_trip_active>;
+				};
+
+				cpu-passive {
+					cooling-device = <&fan 0 0>;
+					trip = <&cpu_trip_passive>;
+				};
+			};
+		};
+
+		aux-thermal {
+			polling-delay = <0>;
+			polling-delay-passive = <500>;
+			status = "okay";
+
+			trips {
+				aux_alert0: critical {
+					temperature = <90000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+		};
+
+		gpu-thermal {
+			polling-delay = <0>;
+			polling-delay-passive = <500>;
+			status = "okay";
+
+			trips {
+				gpu_alert0: critical {
+					temperature = <99000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+		};
+	};
 };
diff --git a/arch/arm64/boot/dts/nvidia/tegra186.dtsi b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
index b3f1494c02c11..0216b565a3703 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -129,62 +129,6 @@ aconnect@2900000 {
 		ranges = <0x02900000 0x0 0x02900000 0x200000>;
 		status = "disabled";
 
-		adma: dma-controller@2930000 {
-			compatible = "nvidia,tegra186-adma";
-			reg = <0x02930000 0x20000>;
-			interrupt-parent = <&agic>;
-			interrupts =  <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
-			#dma-cells = <1>;
-			clocks = <&bpmp TEGRA186_CLK_AHUB>;
-			clock-names = "d_audio";
-			status = "disabled";
-		};
-
-		agic: interrupt-controller@2a40000 {
-			compatible = "nvidia,tegra186-agic",
-				     "nvidia,tegra210-agic";
-			#interrupt-cells = <3>;
-			interrupt-controller;
-			reg = <0x02a41000 0x1000>,
-			      <0x02a42000 0x2000>;
-			interrupts = <GIC_SPI 145
-				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
-			clocks = <&bpmp TEGRA186_CLK_APE>;
-			clock-names = "clk";
-			status = "disabled";
-		};
-
 		tegra_ahub: ahub@2900800 {
 			compatible = "nvidia,tegra186-ahub";
 			reg = <0x02900800 0x800>;
@@ -197,52 +141,6 @@ tegra_ahub: ahub@2900800 {
 			ranges = <0x02900800 0x02900800 0x11800>;
 			status = "disabled";
 
-			tegra_admaif: admaif@290f000 {
-				compatible = "nvidia,tegra186-admaif";
-				reg = <0x0290f000 0x1000>;
-				dmas = <&adma 1>, <&adma 1>,
-				       <&adma 2>, <&adma 2>,
-				       <&adma 3>, <&adma 3>,
-				       <&adma 4>, <&adma 4>,
-				       <&adma 5>, <&adma 5>,
-				       <&adma 6>, <&adma 6>,
-				       <&adma 7>, <&adma 7>,
-				       <&adma 8>, <&adma 8>,
-				       <&adma 9>, <&adma 9>,
-				       <&adma 10>, <&adma 10>,
-				       <&adma 11>, <&adma 11>,
-				       <&adma 12>, <&adma 12>,
-				       <&adma 13>, <&adma 13>,
-				       <&adma 14>, <&adma 14>,
-				       <&adma 15>, <&adma 15>,
-				       <&adma 16>, <&adma 16>,
-				       <&adma 17>, <&adma 17>,
-				       <&adma 18>, <&adma 18>,
-				       <&adma 19>, <&adma 19>,
-				       <&adma 20>, <&adma 20>;
-				dma-names = "rx1", "tx1",
-					    "rx2", "tx2",
-					    "rx3", "tx3",
-					    "rx4", "tx4",
-					    "rx5", "tx5",
-					    "rx6", "tx6",
-					    "rx7", "tx7",
-					    "rx8", "tx8",
-					    "rx9", "tx9",
-					    "rx10", "tx10",
-					    "rx11", "tx11",
-					    "rx12", "tx12",
-					    "rx13", "tx13",
-					    "rx14", "tx14",
-					    "rx15", "tx15",
-					    "rx16", "tx16",
-					    "rx17", "tx17",
-					    "rx18", "tx18",
-					    "rx19", "tx19",
-					    "rx20", "tx20";
-				status = "disabled";
-			};
-
 			tegra_i2s1: i2s@2901000 {
 				compatible = "nvidia,tegra186-i2s",
 					     "nvidia,tegra210-i2s";
@@ -327,78 +225,6 @@ tegra_i2s6: i2s@2901500 {
 				status = "disabled";
 			};
 
-			tegra_dmic1: dmic@2904000 {
-				compatible = "nvidia,tegra210-dmic";
-				reg = <0x2904000 0x100>;
-				clocks = <&bpmp TEGRA186_CLK_DMIC1>;
-				clock-names = "dmic";
-				assigned-clocks = <&bpmp TEGRA186_CLK_DMIC1>;
-				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
-				assigned-clock-rates = <3072000>;
-				sound-name-prefix = "DMIC1";
-				status = "disabled";
-			};
-
-			tegra_dmic2: dmic@2904100 {
-				compatible = "nvidia,tegra210-dmic";
-				reg = <0x2904100 0x100>;
-				clocks = <&bpmp TEGRA186_CLK_DMIC2>;
-				clock-names = "dmic";
-				assigned-clocks = <&bpmp TEGRA186_CLK_DMIC2>;
-				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
-				assigned-clock-rates = <3072000>;
-				sound-name-prefix = "DMIC2";
-				status = "disabled";
-			};
-
-			tegra_dmic3: dmic@2904200 {
-				compatible = "nvidia,tegra210-dmic";
-				reg = <0x2904200 0x100>;
-				clocks = <&bpmp TEGRA186_CLK_DMIC3>;
-				clock-names = "dmic";
-				assigned-clocks = <&bpmp TEGRA186_CLK_DMIC3>;
-				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
-				assigned-clock-rates = <3072000>;
-				sound-name-prefix = "DMIC3";
-				status = "disabled";
-			};
-
-			tegra_dmic4: dmic@2904300 {
-				compatible = "nvidia,tegra210-dmic";
-				reg = <0x2904300 0x100>;
-				clocks = <&bpmp TEGRA186_CLK_DMIC4>;
-				clock-names = "dmic";
-				assigned-clocks = <&bpmp TEGRA186_CLK_DMIC4>;
-				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
-				assigned-clock-rates = <3072000>;
-				sound-name-prefix = "DMIC4";
-				status = "disabled";
-			};
-
-			tegra_dspk1: dspk@2905000 {
-				compatible = "nvidia,tegra186-dspk";
-				reg = <0x2905000 0x100>;
-				clocks = <&bpmp TEGRA186_CLK_DSPK1>;
-				clock-names = "dspk";
-				assigned-clocks = <&bpmp TEGRA186_CLK_DSPK1>;
-				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
-				assigned-clock-rates = <12288000>;
-				sound-name-prefix = "DSPK1";
-				status = "disabled";
-			};
-
-			tegra_dspk2: dspk@2905100 {
-				compatible = "nvidia,tegra186-dspk";
-				reg = <0x2905100 0x100>;
-				clocks = <&bpmp TEGRA186_CLK_DSPK2>;
-				clock-names = "dspk";
-				assigned-clocks = <&bpmp TEGRA186_CLK_DSPK2>;
-				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
-				assigned-clock-rates = <12288000>;
-				sound-name-prefix = "DSPK2";
-				status = "disabled";
-			};
-
 			tegra_sfc1: sfc@2902000 {
 				compatible = "nvidia,tegra186-sfc",
 					     "nvidia,tegra210-sfc";
@@ -431,22 +257,6 @@ tegra_sfc4: sfc@2902600 {
 				status = "disabled";
 			};
 
-			tegra_mvc1: mvc@290a000 {
-				compatible = "nvidia,tegra186-mvc",
-					     "nvidia,tegra210-mvc";
-				reg = <0x290a000 0x200>;
-				sound-name-prefix = "MVC1";
-				status = "disabled";
-			};
-
-			tegra_mvc2: mvc@290a200 {
-				compatible = "nvidia,tegra186-mvc",
-					     "nvidia,tegra210-mvc";
-				reg = <0x290a200 0x200>;
-				sound-name-prefix = "MVC2";
-				status = "disabled";
-			};
-
 			tegra_amx1: amx@2903000 {
 				compatible = "nvidia,tegra186-amx",
 					     "nvidia,tegra210-amx";
@@ -511,6 +321,78 @@ tegra_adx4: adx@2903b00 {
 				status = "disabled";
 			};
 
+			tegra_dmic1: dmic@2904000 {
+				compatible = "nvidia,tegra210-dmic";
+				reg = <0x2904000 0x100>;
+				clocks = <&bpmp TEGRA186_CLK_DMIC1>;
+				clock-names = "dmic";
+				assigned-clocks = <&bpmp TEGRA186_CLK_DMIC1>;
+				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
+				assigned-clock-rates = <3072000>;
+				sound-name-prefix = "DMIC1";
+				status = "disabled";
+			};
+
+			tegra_dmic2: dmic@2904100 {
+				compatible = "nvidia,tegra210-dmic";
+				reg = <0x2904100 0x100>;
+				clocks = <&bpmp TEGRA186_CLK_DMIC2>;
+				clock-names = "dmic";
+				assigned-clocks = <&bpmp TEGRA186_CLK_DMIC2>;
+				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
+				assigned-clock-rates = <3072000>;
+				sound-name-prefix = "DMIC2";
+				status = "disabled";
+			};
+
+			tegra_dmic3: dmic@2904200 {
+				compatible = "nvidia,tegra210-dmic";
+				reg = <0x2904200 0x100>;
+				clocks = <&bpmp TEGRA186_CLK_DMIC3>;
+				clock-names = "dmic";
+				assigned-clocks = <&bpmp TEGRA186_CLK_DMIC3>;
+				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
+				assigned-clock-rates = <3072000>;
+				sound-name-prefix = "DMIC3";
+				status = "disabled";
+			};
+
+			tegra_dmic4: dmic@2904300 {
+				compatible = "nvidia,tegra210-dmic";
+				reg = <0x2904300 0x100>;
+				clocks = <&bpmp TEGRA186_CLK_DMIC4>;
+				clock-names = "dmic";
+				assigned-clocks = <&bpmp TEGRA186_CLK_DMIC4>;
+				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
+				assigned-clock-rates = <3072000>;
+				sound-name-prefix = "DMIC4";
+				status = "disabled";
+			};
+
+			tegra_dspk1: dspk@2905000 {
+				compatible = "nvidia,tegra186-dspk";
+				reg = <0x2905000 0x100>;
+				clocks = <&bpmp TEGRA186_CLK_DSPK1>;
+				clock-names = "dspk";
+				assigned-clocks = <&bpmp TEGRA186_CLK_DSPK1>;
+				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
+				assigned-clock-rates = <12288000>;
+				sound-name-prefix = "DSPK1";
+				status = "disabled";
+			};
+
+			tegra_dspk2: dspk@2905100 {
+				compatible = "nvidia,tegra186-dspk";
+				reg = <0x2905100 0x100>;
+				clocks = <&bpmp TEGRA186_CLK_DSPK2>;
+				clock-names = "dspk";
+				assigned-clocks = <&bpmp TEGRA186_CLK_DSPK2>;
+				assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
+				assigned-clock-rates = <12288000>;
+				sound-name-prefix = "DSPK2";
+				status = "disabled";
+			};
+
 			tegra_ope1: processing-engine@2908000 {
 				compatible = "nvidia,tegra186-ope",
 					     "nvidia,tegra210-ope";
@@ -534,6 +416,22 @@ dynamic-range-compressor@2908200 {
 				};
 			};
 
+			tegra_mvc1: mvc@290a000 {
+				compatible = "nvidia,tegra186-mvc",
+					     "nvidia,tegra210-mvc";
+				reg = <0x290a000 0x200>;
+				sound-name-prefix = "MVC1";
+				status = "disabled";
+			};
+
+			tegra_mvc2: mvc@290a200 {
+				compatible = "nvidia,tegra186-mvc",
+					     "nvidia,tegra210-mvc";
+				reg = <0x290a200 0x200>;
+				sound-name-prefix = "MVC2";
+				status = "disabled";
+			};
+
 			tegra_amixer: amixer@290bb00 {
 				compatible = "nvidia,tegra186-amixer",
 					     "nvidia,tegra210-amixer";
@@ -542,6 +440,52 @@ tegra_amixer: amixer@290bb00 {
 				status = "disabled";
 			};
 
+			tegra_admaif: admaif@290f000 {
+				compatible = "nvidia,tegra186-admaif";
+				reg = <0x0290f000 0x1000>;
+				dmas = <&adma 1>, <&adma 1>,
+				       <&adma 2>, <&adma 2>,
+				       <&adma 3>, <&adma 3>,
+				       <&adma 4>, <&adma 4>,
+				       <&adma 5>, <&adma 5>,
+				       <&adma 6>, <&adma 6>,
+				       <&adma 7>, <&adma 7>,
+				       <&adma 8>, <&adma 8>,
+				       <&adma 9>, <&adma 9>,
+				       <&adma 10>, <&adma 10>,
+				       <&adma 11>, <&adma 11>,
+				       <&adma 12>, <&adma 12>,
+				       <&adma 13>, <&adma 13>,
+				       <&adma 14>, <&adma 14>,
+				       <&adma 15>, <&adma 15>,
+				       <&adma 16>, <&adma 16>,
+				       <&adma 17>, <&adma 17>,
+				       <&adma 18>, <&adma 18>,
+				       <&adma 19>, <&adma 19>,
+				       <&adma 20>, <&adma 20>;
+				dma-names = "rx1", "tx1",
+					    "rx2", "tx2",
+					    "rx3", "tx3",
+					    "rx4", "tx4",
+					    "rx5", "tx5",
+					    "rx6", "tx6",
+					    "rx7", "tx7",
+					    "rx8", "tx8",
+					    "rx9", "tx9",
+					    "rx10", "tx10",
+					    "rx11", "tx11",
+					    "rx12", "tx12",
+					    "rx13", "tx13",
+					    "rx14", "tx14",
+					    "rx15", "tx15",
+					    "rx16", "tx16",
+					    "rx17", "tx17",
+					    "rx18", "tx18",
+					    "rx19", "tx19",
+					    "rx20", "tx20";
+				status = "disabled";
+			};
+
 			tegra_asrc: asrc@2910000 {
 				compatible = "nvidia,tegra186-asrc";
 				reg = <0x2910000 0x2000>;
@@ -549,6 +493,62 @@ tegra_asrc: asrc@2910000 {
 				status = "disabled";
 			};
 		};
+
+		adma: dma-controller@2930000 {
+			compatible = "nvidia,tegra186-adma";
+			reg = <0x02930000 0x20000>;
+			interrupt-parent = <&agic>;
+			interrupts =  <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			clocks = <&bpmp TEGRA186_CLK_AHUB>;
+			clock-names = "d_audio";
+			status = "disabled";
+		};
+
+		agic: interrupt-controller@2a40000 {
+			compatible = "nvidia,tegra186-agic",
+				     "nvidia,tegra210-agic";
+			#interrupt-cells = <3>;
+			interrupt-controller;
+			reg = <0x02a41000 0x1000>,
+			      <0x02a42000 0x2000>;
+			interrupts = <GIC_SPI 145
+				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
+			clocks = <&bpmp TEGRA186_CLK_APE>;
+			clock-names = "clk";
+			status = "disabled";
+		};
 	};
 
 	mc: memory-controller@2c00000 {
@@ -970,6 +970,34 @@ sdmmc4: mmc@3460000 {
 		status = "disabled";
 	};
 
+	sata@3507000 {
+		compatible = "nvidia,tegra186-ahci";
+		reg = <0x0 0x03507000 0x0 0x00002000>, /* AHCI */
+		      <0x0 0x03500000 0x0 0x00007000>, /* SATA */
+		      <0x0 0x03A90000 0x0 0x00010000>; /* SATA AUX */
+		interrupts = <GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>;
+
+		power-domains = <&bpmp TEGRA186_POWER_DOMAIN_SAX>;
+		interconnects = <&mc TEGRA186_MEMORY_CLIENT_SATAR &emc>,
+				<&mc TEGRA186_MEMORY_CLIENT_SATAW &emc>;
+		interconnect-names = "dma-mem", "write";
+		iommus = <&smmu TEGRA186_SID_SATA>;
+
+		clocks = <&bpmp TEGRA186_CLK_SATA>,
+			 <&bpmp TEGRA186_CLK_SATA_OOB>;
+		clock-names = "sata", "sata-oob";
+		assigned-clocks = <&bpmp TEGRA186_CLK_SATA>,
+				  <&bpmp TEGRA186_CLK_SATA_OOB>;
+		assigned-clock-parents = <&bpmp TEGRA186_CLK_PLLP_OUT0>,
+					 <&bpmp TEGRA186_CLK_PLLP>;
+		assigned-clock-rates = <102000000>,
+				       <204000000>;
+		resets = <&bpmp TEGRA186_RESET_SATA>,
+			<&bpmp TEGRA186_RESET_SATACOLD>;
+		reset-names = "sata", "sata-cold";
+		status = "disabled";
+	};
+
 	hda@3510000 {
 		compatible = "nvidia,tegra186-hda", "nvidia,tegra30-hda";
 		reg = <0x0 0x03510000 0x0 0x10000>;
@@ -1286,18 +1314,13 @@ pmc: pmc@c360000 {
 		#interrupt-cells = <2>;
 		interrupt-controller;
 
-		sdmmc1_3v3: sdmmc1-3v3 {
-			pins = "sdmmc1-hv";
-			power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
-		};
-
 		sdmmc1_1v8: sdmmc1-1v8 {
 			pins = "sdmmc1-hv";
 			power-source = <TEGRA_IO_PAD_VOLTAGE_1V8>;
 		};
 
-		sdmmc2_3v3: sdmmc2-3v3 {
-			pins = "sdmmc2-hv";
+		sdmmc1_3v3: sdmmc1-3v3 {
+			pins = "sdmmc1-hv";
 			power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
 		};
 
@@ -1306,8 +1329,8 @@ sdmmc2_1v8: sdmmc2-1v8 {
 			power-source = <TEGRA_IO_PAD_VOLTAGE_1V8>;
 		};
 
-		sdmmc3_3v3: sdmmc3-3v3 {
-			pins = "sdmmc3-hv";
+		sdmmc2_3v3: sdmmc2-3v3 {
+			pins = "sdmmc2-hv";
 			power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
 		};
 
@@ -1315,6 +1338,11 @@ sdmmc3_1v8: sdmmc3-1v8 {
 			pins = "sdmmc3-hv";
 			power-source = <TEGRA_IO_PAD_VOLTAGE_1V8>;
 		};
+
+		sdmmc3_3v3: sdmmc3-3v3 {
+			pins = "sdmmc3-hv";
+			power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
+		};
 	};
 
 	ccplex@e000000 {
@@ -1894,34 +1922,6 @@ cpu_bpmp_rx: sram@4f000 {
 		};
 	};
 
-	sata@3507000 {
-		compatible = "nvidia,tegra186-ahci";
-		reg = <0x0 0x03507000 0x0 0x00002000>, /* AHCI */
-		      <0x0 0x03500000 0x0 0x00007000>, /* SATA */
-		      <0x0 0x03A90000 0x0 0x00010000>; /* SATA AUX */
-		interrupts = <GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>;
-
-		power-domains = <&bpmp TEGRA186_POWER_DOMAIN_SAX>;
-		interconnects = <&mc TEGRA186_MEMORY_CLIENT_SATAR &emc>,
-				<&mc TEGRA186_MEMORY_CLIENT_SATAW &emc>;
-		interconnect-names = "dma-mem", "write";
-		iommus = <&smmu TEGRA186_SID_SATA>;
-
-		clocks = <&bpmp TEGRA186_CLK_SATA>,
-			 <&bpmp TEGRA186_CLK_SATA_OOB>;
-		clock-names = "sata", "sata-oob";
-		assigned-clocks = <&bpmp TEGRA186_CLK_SATA>,
-				  <&bpmp TEGRA186_CLK_SATA_OOB>;
-		assigned-clock-parents = <&bpmp TEGRA186_CLK_PLLP_OUT0>,
-					 <&bpmp TEGRA186_CLK_PLLP>;
-		assigned-clock-rates = <102000000>,
-				       <204000000>;
-		resets = <&bpmp TEGRA186_RESET_SATA>,
-			<&bpmp TEGRA186_RESET_SATACOLD>;
-		reset-names = "sata", "sata-cold";
-		status = "disabled";
-	};
-
 	bpmp: bpmp {
 		compatible = "nvidia,tegra186-bpmp";
 		interconnects = <&mc TEGRA186_MEMORY_CLIENT_BPMPR &emc>,
@@ -2052,14 +2052,7 @@ L2_A57: l2-cache1 {
 		};
 	};
 
-	pmu_denver {
-		compatible = "nvidia,denver-pmu";
-		interrupts = <GIC_SPI 320 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 321 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-affinity = <&denver_0 &denver_1>;
-	};
-
-	pmu_a57 {
+	pmu-a57 {
 		compatible = "arm,cortex-a57-pmu";
 		interrupts = <GIC_SPI 296 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 297 IRQ_TYPE_LEVEL_HIGH>,
@@ -2068,6 +2061,13 @@ pmu_a57 {
 		interrupt-affinity = <&ca57_0 &ca57_1 &ca57_2 &ca57_3>;
 	};
 
+	pmu-denver {
+		compatible = "nvidia,denver-pmu";
+		interrupts = <GIC_SPI 320 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 321 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-affinity = <&denver_0 &denver_1>;
+	};
+
 	sound {
 		status = "disabled";
 
diff --git a/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi b/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
index cd272d407e012..5b59c1986e9b5 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
@@ -147,6 +147,24 @@ pmic: pmic@3c {
 				pinctrl-names = "default";
 				pinctrl-0 = <&max20024_default>;
 
+				fps {
+					fps0 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+						maxim,shutdown-fps-time-period-us = <640>;
+					};
+
+					fps1 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
+						maxim,shutdown-fps-time-period-us = <640>;
+						maxim,device-state-on-disabled-event = <MAX77620_FPS_INACTIVE_STATE_SLEEP>;
+					};
+
+					fps2 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+						maxim,shutdown-fps-time-period-us = <640>;
+					};
+				};
+
 				max20024_default: pinmux {
 					gpio0 {
 						pins = "gpio0";
@@ -190,24 +208,6 @@ gpio7 {
 					};
 				};
 
-				fps {
-					fps0 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-						maxim,shutdown-fps-time-period-us = <640>;
-					};
-
-					fps1 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
-						maxim,shutdown-fps-time-period-us = <640>;
-						maxim,device-state-on-disabled-event = <MAX77620_FPS_INACTIVE_STATE_SLEEP>;
-					};
-
-					fps2 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-						maxim,shutdown-fps-time-period-us = <640>;
-					};
-				};
-
 				regulators {
 					in-sd0-supply = <&vdd_5v0_sys>;
 					in-sd1-supply = <&vdd_5v0_sys>;
diff --git a/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts b/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts
index f018fc4c0f707..64a3398fe7a6d 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts
@@ -14,874 +14,830 @@ bus@0 {
 		aconnect@2900000 {
 			status = "okay";
 
-			dma-controller@2930000 {
-				status = "okay";
-			};
-
-			interrupt-controller@2a40000 {
-				status = "okay";
-			};
-
 			ahub@2900800 {
 				status = "okay";
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0x0>;
-
-						xbar_admaif0_ep: endpoint {
-							remote-endpoint = <&admaif0_ep>;
-						};
-					};
-
-					port@1 {
-						reg = <0x1>;
-
-						xbar_admaif1_ep: endpoint {
-							remote-endpoint = <&admaif1_ep>;
-						};
-					};
-
-					port@2 {
-						reg = <0x2>;
-
-						xbar_admaif2_ep: endpoint {
-							remote-endpoint = <&admaif2_ep>;
-						};
-					};
-
-					port@3 {
-						reg = <0x3>;
-
-						xbar_admaif3_ep: endpoint {
-							remote-endpoint = <&admaif3_ep>;
-						};
-					};
-
-					port@4 {
-						reg = <0x4>;
-
-						xbar_admaif4_ep: endpoint {
-							remote-endpoint = <&admaif4_ep>;
-						};
-					};
-
-					port@5 {
-						reg = <0x5>;
-
-						xbar_admaif5_ep: endpoint {
-							remote-endpoint = <&admaif5_ep>;
-						};
-					};
-
-					port@6 {
-						reg = <0x6>;
-
-						xbar_admaif6_ep: endpoint {
-							remote-endpoint = <&admaif6_ep>;
-						};
-					};
-
-					port@7 {
-						reg = <0x7>;
+				i2s@2901000 {
+					status = "okay";
 
-						xbar_admaif7_ep: endpoint {
-							remote-endpoint = <&admaif7_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@8 {
-						reg = <0x8>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif8_ep: endpoint {
-							remote-endpoint = <&admaif8_ep>;
+							i2s1_cif_ep: endpoint {
+								remote-endpoint = <&xbar_i2s1_ep>;
+							};
 						};
-					};
 
-					port@9 {
-						reg = <0x9>;
+						i2s1_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif9_ep: endpoint {
-							remote-endpoint = <&admaif9_ep>;
+							i2s1_dap_ep: endpoint {
+								dai-format = "i2s";
+								remote-endpoint = <&rt5658_ep>;
+							};
 						};
 					};
+				};
 
-					port@a {
-						reg = <0xa>;
+				i2s@2901100 {
+					status = "okay";
 
-						xbar_admaif10_ep: endpoint {
-							remote-endpoint = <&admaif10_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@b {
-						reg = <0xb>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif11_ep: endpoint {
-							remote-endpoint = <&admaif11_ep>;
+							i2s2_cif_ep: endpoint {
+								remote-endpoint = <&xbar_i2s2_ep>;
+							};
 						};
-					};
 
-					port@c {
-						reg = <0xc>;
+						i2s2_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif12_ep: endpoint {
-							remote-endpoint = <&admaif12_ep>;
+							i2s2_dap_ep: endpoint {
+								dai-format = "i2s";
+								/* Place holder for external Codec */
+							};
 						};
 					};
+				};
 
-					port@d {
-						reg = <0xd>;
+				i2s@2901300 {
+					status = "okay";
 
-						xbar_admaif13_ep: endpoint {
-							remote-endpoint = <&admaif13_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@e {
-						reg = <0xe>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif14_ep: endpoint {
-							remote-endpoint = <&admaif14_ep>;
+							i2s4_cif_ep: endpoint {
+								remote-endpoint = <&xbar_i2s4_ep>;
+							};
 						};
-					};
 
-					port@f {
-						reg = <0xf>;
+						i2s4_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif15_ep: endpoint {
-							remote-endpoint = <&admaif15_ep>;
+							i2s4_dap_ep: endpoint {
+								dai-format = "i2s";
+								/* Place holder for external Codec */
+							};
 						};
 					};
+				};
 
-					port@10 {
-						reg = <0x10>;
+				i2s@2901500 {
+					status = "okay";
 
-						xbar_admaif16_ep: endpoint {
-							remote-endpoint = <&admaif16_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@11 {
-						reg = <0x11>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif17_ep: endpoint {
-							remote-endpoint = <&admaif17_ep>;
+							i2s6_cif_ep: endpoint {
+								remote-endpoint = <&xbar_i2s6_ep>;
+							};
 						};
-					};
 
-					port@12 {
-						reg = <0x12>;
+						i2s6_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif18_ep: endpoint {
-							remote-endpoint = <&admaif18_ep>;
+							i2s6_dap_ep: endpoint {
+								dai-format = "i2s";
+								/* Place holder for external Codec */
+							};
 						};
 					};
+				};
 
-					port@13 {
-						reg = <0x13>;
+				sfc@2902000 {
+					status = "okay";
 
-						xbar_admaif19_ep: endpoint {
-							remote-endpoint = <&admaif19_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_i2s1_port: port@14 {
-						reg = <0x14>;
+						port@0 {
+							reg = <0>;
 
-						xbar_i2s1_ep: endpoint {
-							remote-endpoint = <&i2s1_cif_ep>;
+							sfc1_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_sfc1_in_ep>;
+							};
 						};
-					};
 
-					xbar_i2s2_port: port@15 {
-						reg = <0x15>;
+						sfc1_out_port: port@1 {
+							reg = <1>;
 
-						xbar_i2s2_ep: endpoint {
-							remote-endpoint = <&i2s2_cif_ep>;
+							sfc1_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_sfc1_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_i2s4_port: port@17 {
-						reg = <0x17>;
+				sfc@2902200 {
+					status = "okay";
 
-						xbar_i2s4_ep: endpoint {
-							remote-endpoint = <&i2s4_cif_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_i2s6_port: port@19 {
-						reg = <0x19>;
+						port@0 {
+							reg = <0>;
 
-						xbar_i2s6_ep: endpoint {
-							remote-endpoint = <&i2s6_cif_ep>;
+							sfc2_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_sfc2_in_ep>;
+							};
 						};
-					};
 
-					xbar_dmic3_port: port@1c {
-						reg = <0x1c>;
+						sfc2_out_port: port@1 {
+							reg = <1>;
 
-						xbar_dmic3_ep: endpoint {
-							remote-endpoint = <&dmic3_cif_ep>;
+							sfc2_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_sfc2_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_sfc1_in_port: port@20 {
-						reg = <0x20>;
+				sfc@2902400 {
+					status = "okay";
 
-						xbar_sfc1_in_ep: endpoint {
-							remote-endpoint = <&sfc1_cif_in_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@21 {
-						reg = <0x21>;
+						port@0 {
+							reg = <0>;
 
-						xbar_sfc1_out_ep: endpoint {
-							remote-endpoint = <&sfc1_cif_out_ep>;
+							sfc3_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_sfc3_in_ep>;
+							};
 						};
-					};
 
-					xbar_sfc2_in_port: port@22 {
-						reg = <0x22>;
+						sfc3_out_port: port@1 {
+							reg = <1>;
 
-						xbar_sfc2_in_ep: endpoint {
-							remote-endpoint = <&sfc2_cif_in_ep>;
+							sfc3_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_sfc3_out_ep>;
+							};
 						};
 					};
+				};
 
-					port@23 {
-						reg = <0x23>;
+				sfc@2902600 {
+					status = "okay";
 
-						xbar_sfc2_out_ep: endpoint {
-							remote-endpoint = <&sfc2_cif_out_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_sfc3_in_port: port@24 {
-						reg = <0x24>;
+						port@0 {
+							reg = <0>;
 
-						xbar_sfc3_in_ep: endpoint {
-							remote-endpoint = <&sfc3_cif_in_ep>;
+							sfc4_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_sfc4_in_ep>;
+							};
 						};
-					};
 
-					port@25 {
-						reg = <0x25>;
+						sfc4_out_port: port@1 {
+							reg = <1>;
 
-						xbar_sfc3_out_ep: endpoint {
-							remote-endpoint = <&sfc3_cif_out_ep>;
+							sfc4_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_sfc4_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_sfc4_in_port: port@26 {
-						reg = <0x26>;
+				amx@2903000 {
+					status = "okay";
 
-						xbar_sfc4_in_ep: endpoint {
-							remote-endpoint = <&sfc4_cif_in_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@27 {
-						reg = <0x27>;
+						port@0 {
+							reg = <0>;
 
-						xbar_sfc4_out_ep: endpoint {
-							remote-endpoint = <&sfc4_cif_out_ep>;
+							amx1_in1_ep: endpoint {
+								remote-endpoint = <&xbar_amx1_in1_ep>;
+							};
 						};
-					};
 
-					xbar_mvc1_in_port: port@28 {
-						reg = <0x28>;
+						port@1 {
+							reg = <1>;
 
-						xbar_mvc1_in_ep: endpoint {
-							remote-endpoint = <&mvc1_cif_in_ep>;
+							amx1_in2_ep: endpoint {
+								remote-endpoint = <&xbar_amx1_in2_ep>;
+							};
 						};
-					};
 
-					port@29 {
-						reg = <0x29>;
+						port@2 {
+							reg = <2>;
 
-						xbar_mvc1_out_ep: endpoint {
-							remote-endpoint = <&mvc1_cif_out_ep>;
+							amx1_in3_ep: endpoint {
+								remote-endpoint = <&xbar_amx1_in3_ep>;
+							};
 						};
-					};
 
-					xbar_mvc2_in_port: port@2a {
-						reg = <0x2a>;
+						port@3 {
+							reg = <3>;
 
-						xbar_mvc2_in_ep: endpoint {
-							remote-endpoint = <&mvc2_cif_in_ep>;
+							amx1_in4_ep: endpoint {
+								remote-endpoint = <&xbar_amx1_in4_ep>;
+							};
 						};
-					};
 
-					port@2b {
-						reg = <0x2b>;
+						amx1_out_port: port@4 {
+							reg = <4>;
 
-						xbar_mvc2_out_ep: endpoint {
-							remote-endpoint = <&mvc2_cif_out_ep>;
+							amx1_out_ep: endpoint {
+								remote-endpoint = <&xbar_amx1_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_amx1_in1_port: port@2c {
-						reg = <0x2c>;
+				amx@2903100 {
+					status = "okay";
 
-						xbar_amx1_in1_ep: endpoint {
-							remote-endpoint = <&amx1_in1_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_amx1_in2_port: port@2d {
-						reg = <0x2d>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx1_in2_ep: endpoint {
-							remote-endpoint = <&amx1_in2_ep>;
+							amx2_in1_ep: endpoint {
+								remote-endpoint = <&xbar_amx2_in1_ep>;
+							};
 						};
-					};
 
-					xbar_amx1_in3_port: port@2e {
-						reg = <0x2e>;
+						port@1 {
+							reg = <1>;
 
-						xbar_amx1_in3_ep: endpoint {
-							remote-endpoint = <&amx1_in3_ep>;
+							amx2_in2_ep: endpoint {
+								remote-endpoint = <&xbar_amx2_in2_ep>;
+							};
 						};
-					};
 
-					xbar_amx1_in4_port: port@2f {
-						reg = <0x2f>;
+						amx2_in3_port: port@2 {
+							reg = <2>;
 
-						xbar_amx1_in4_ep: endpoint {
-							remote-endpoint = <&amx1_in4_ep>;
+							amx2_in3_ep: endpoint {
+								remote-endpoint = <&xbar_amx2_in3_ep>;
+							};
 						};
-					};
 
-					port@30 {
-						reg = <0x30>;
+						amx2_in4_port: port@3 {
+							reg = <3>;
 
-						xbar_amx1_out_ep: endpoint {
-							remote-endpoint = <&amx1_out_ep>;
+							amx2_in4_ep: endpoint {
+								remote-endpoint = <&xbar_amx2_in4_ep>;
+							};
 						};
-					};
 
-					xbar_amx2_in1_port: port@31 {
-						reg = <0x31>;
+						amx2_out_port: port@4 {
+							reg = <4>;
 
-						xbar_amx2_in1_ep: endpoint {
-							remote-endpoint = <&amx2_in1_ep>;
+							amx2_out_ep: endpoint {
+								remote-endpoint = <&xbar_amx2_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_amx2_in2_port: port@32 {
-						reg = <0x32>;
+				amx@2903200 {
+					status = "okay";
 
-						xbar_amx2_in2_ep: endpoint {
-							remote-endpoint = <&amx2_in2_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_amx2_in3_port: port@33 {
-						reg = <0x33>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx2_in3_ep: endpoint {
-							remote-endpoint = <&amx2_in3_ep>;
+							amx3_in1_ep: endpoint {
+								remote-endpoint = <&xbar_amx3_in1_ep>;
+							};
 						};
-					};
 
-					xbar_amx2_in4_port: port@34 {
-						reg = <0x34>;
+						port@1 {
+							reg = <1>;
 
-						xbar_amx2_in4_ep: endpoint {
-							remote-endpoint = <&amx2_in4_ep>;
+							amx3_in2_ep: endpoint {
+								remote-endpoint = <&xbar_amx3_in2_ep>;
+							};
 						};
-					};
 
-					port@35 {
-						reg = <0x35>;
+						port@2 {
+							reg = <2>;
 
-						xbar_amx2_out_ep: endpoint {
-							remote-endpoint = <&amx2_out_ep>;
+							amx3_in3_ep: endpoint {
+								remote-endpoint = <&xbar_amx3_in3_ep>;
+							};
 						};
-					};
 
-					xbar_amx3_in1_port: port@36 {
-						reg = <0x36>;
+						port@3 {
+							reg = <3>;
 
-						xbar_amx3_in1_ep: endpoint {
-							remote-endpoint = <&amx3_in1_ep>;
+							amx3_in4_ep: endpoint {
+								remote-endpoint = <&xbar_amx3_in4_ep>;
+							};
 						};
-					};
 
-					xbar_amx3_in2_port: port@37 {
-						reg = <0x37>;
+						amx3_out_port: port@4 {
+							reg = <4>;
 
-						xbar_amx3_in2_ep: endpoint {
-							remote-endpoint = <&amx3_in2_ep>;
+							amx3_out_ep: endpoint {
+								remote-endpoint = <&xbar_amx3_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_amx3_in3_port: port@38 {
-						reg = <0x38>;
+				amx@2903300 {
+					status = "okay";
 
-						xbar_amx3_in3_ep: endpoint {
-							remote-endpoint = <&amx3_in3_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_amx3_in4_port: port@39 {
-						reg = <0x39>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx3_in4_ep: endpoint {
-							remote-endpoint = <&amx3_in4_ep>;
+							amx4_in1_ep: endpoint {
+								remote-endpoint = <&xbar_amx4_in1_ep>;
+							};
 						};
-					};
 
-					port@3a {
-						reg = <0x3a>;
+						port@1 {
+							reg = <1>;
 
-						xbar_amx3_out_ep: endpoint {
-							remote-endpoint = <&amx3_out_ep>;
+							amx4_in2_ep: endpoint {
+								remote-endpoint = <&xbar_amx4_in2_ep>;
+							};
 						};
-					};
 
-					xbar_amx4_in1_port: port@3b {
-						reg = <0x3b>;
+						port@2 {
+							reg = <2>;
 
-						xbar_amx4_in1_ep: endpoint {
-							remote-endpoint = <&amx4_in1_ep>;
+							amx4_in3_ep: endpoint {
+								remote-endpoint = <&xbar_amx4_in3_ep>;
+							};
 						};
-					};
 
-					xbar_amx4_in2_port: port@3c {
-						reg = <0x3c>;
+						port@3 {
+							reg = <3>;
 
-						xbar_amx4_in2_ep: endpoint {
-							remote-endpoint = <&amx4_in2_ep>;
+							amx4_in4_ep: endpoint {
+								remote-endpoint = <&xbar_amx4_in4_ep>;
+							};
 						};
-					};
 
-					xbar_amx4_in3_port: port@3d {
-						reg = <0x3d>;
+						amx4_out_port: port@4 {
+							reg = <4>;
 
-						xbar_amx4_in3_ep: endpoint {
-							remote-endpoint = <&amx4_in3_ep>;
+							amx4_out_ep: endpoint {
+								remote-endpoint = <&xbar_amx4_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_amx4_in4_port: port@3e {
-						reg = <0x3e>;
+				adx@2903800 {
+					status = "okay";
 
-						xbar_amx4_in4_ep: endpoint {
-							remote-endpoint = <&amx4_in4_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@3f {
-						reg = <0x3f>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx4_out_ep: endpoint {
-							remote-endpoint = <&amx4_out_ep>;
+							adx1_in_ep: endpoint {
+								remote-endpoint = <&xbar_adx1_in_ep>;
+							};
 						};
-					};
 
-					xbar_adx1_in_port: port@40 {
-						reg = <0x40>;
+						adx1_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_adx1_in_ep: endpoint {
-							remote-endpoint = <&adx1_in_ep>;
+							adx1_out1_ep: endpoint {
+								remote-endpoint = <&xbar_adx1_out1_ep>;
+							};
 						};
-					};
 
-					port@41 {
-						reg = <0x41>;
+						adx1_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_adx1_out1_ep: endpoint {
-							remote-endpoint = <&adx1_out1_ep>;
+							adx1_out2_ep: endpoint {
+								remote-endpoint = <&xbar_adx1_out2_ep>;
+							};
 						};
-					};
 
-					port@42 {
-						reg = <0x42>;
+						adx1_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_adx1_out2_ep: endpoint {
-							remote-endpoint = <&adx1_out2_ep>;
+							adx1_out3_ep: endpoint {
+								remote-endpoint = <&xbar_adx1_out3_ep>;
+							};
 						};
-					};
 
-					port@43 {
-						reg = <0x43>;
+						adx1_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_adx1_out3_ep: endpoint {
-							remote-endpoint = <&adx1_out3_ep>;
+							adx1_out4_ep: endpoint {
+								remote-endpoint = <&xbar_adx1_out4_ep>;
+							};
 						};
 					};
+				};
 
-					port@44 {
-						reg = <0x44>;
+				adx@2903900 {
+					status = "okay";
 
-						xbar_adx1_out4_ep: endpoint {
-							remote-endpoint = <&adx1_out4_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_adx2_in_port: port@45 {
-						reg = <0x45>;
+						port@0 {
+							reg = <0>;
 
-						xbar_adx2_in_ep: endpoint {
-							remote-endpoint = <&adx2_in_ep>;
+							adx2_in_ep: endpoint {
+								remote-endpoint = <&xbar_adx2_in_ep>;
+							};
 						};
-					};
 
-					port@46 {
-						reg = <0x46>;
+						adx2_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_adx2_out1_ep: endpoint {
-							remote-endpoint = <&adx2_out1_ep>;
+							adx2_out1_ep: endpoint {
+								remote-endpoint = <&xbar_adx2_out1_ep>;
+							};
 						};
-					};
 
-					port@47 {
-						reg = <0x47>;
+						adx2_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_adx2_out2_ep: endpoint {
-							remote-endpoint = <&adx2_out2_ep>;
+							adx2_out2_ep: endpoint {
+								remote-endpoint = <&xbar_adx2_out2_ep>;
+							};
 						};
-					};
 
-					port@48 {
-						reg = <0x48>;
+						adx2_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_adx2_out3_ep: endpoint {
-							remote-endpoint = <&adx2_out3_ep>;
+							adx2_out3_ep: endpoint {
+								remote-endpoint = <&xbar_adx2_out3_ep>;
+							};
 						};
-					};
 
-					port@49 {
-						reg = <0x49>;
+						adx2_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_adx2_out4_ep: endpoint {
-							remote-endpoint = <&adx2_out4_ep>;
+							adx2_out4_ep: endpoint {
+								remote-endpoint = <&xbar_adx2_out4_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_adx3_in_port: port@4a {
-						reg = <0x4a>;
+				adx@2903a00 {
+					status = "okay";
 
-						xbar_adx3_in_ep: endpoint {
-							remote-endpoint = <&adx3_in_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@4b {
-						reg = <0x4b>;
+						port@0 {
+							reg = <0>;
 
-						xbar_adx3_out1_ep: endpoint {
-							remote-endpoint = <&adx3_out1_ep>;
+							adx3_in_ep: endpoint {
+								remote-endpoint = <&xbar_adx3_in_ep>;
+							};
 						};
-					};
 
-					port@4c {
-						reg = <0x4c>;
+						adx3_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_adx3_out2_ep: endpoint {
-							remote-endpoint = <&adx3_out2_ep>;
+							adx3_out1_ep: endpoint {
+								remote-endpoint = <&xbar_adx3_out1_ep>;
+							};
 						};
-					};
 
-					port@4d {
-						reg = <0x4d>;
+						adx3_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_adx3_out3_ep: endpoint {
-							remote-endpoint = <&adx3_out3_ep>;
+							adx3_out2_ep: endpoint {
+								remote-endpoint = <&xbar_adx3_out2_ep>;
+							};
 						};
-					};
 
-					port@4e {
-						reg = <0x4e>;
+						adx3_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_adx3_out4_ep: endpoint {
-							remote-endpoint = <&adx3_out4_ep>;
+							adx3_out3_ep: endpoint {
+								remote-endpoint = <&xbar_adx3_out3_ep>;
+							};
 						};
-					};
 
-					xbar_adx4_in_port: port@4f {
-						reg = <0x4f>;
+						adx3_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_adx4_in_ep: endpoint {
-							remote-endpoint = <&adx4_in_ep>;
+							adx3_out4_ep: endpoint {
+								remote-endpoint = <&xbar_adx3_out4_ep>;
+							};
 						};
 					};
+				};
 
-					port@50 {
-						reg = <0x50>;
+				adx@2903b00 {
+					status = "okay";
 
-						xbar_adx4_out1_ep: endpoint {
-							remote-endpoint = <&adx4_out1_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@51 {
-						reg = <0x51>;
+						port@0 {
+							reg = <0>;
 
-						xbar_adx4_out2_ep: endpoint {
-							remote-endpoint = <&adx4_out2_ep>;
+							adx4_in_ep: endpoint {
+								remote-endpoint = <&xbar_adx4_in_ep>;
+							};
 						};
-					};
 
-					port@52 {
-						reg = <0x52>;
+						adx4_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_adx4_out3_ep: endpoint {
-							remote-endpoint = <&adx4_out3_ep>;
+							adx4_out1_ep: endpoint {
+								remote-endpoint = <&xbar_adx4_out1_ep>;
+							};
 						};
-					};
 
-					port@53 {
-						reg = <0x53>;
+						adx4_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_adx4_out4_ep: endpoint {
-							remote-endpoint = <&adx4_out4_ep>;
+							adx4_out2_ep: endpoint {
+								remote-endpoint = <&xbar_adx4_out2_ep>;
+							};
 						};
-					};
 
-					xbar_mixer_in1_port: port@54 {
-						reg = <0x54>;
+						adx4_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_mixer_in1_ep: endpoint {
-							remote-endpoint = <&mixer_in1_ep>;
+							adx4_out3_ep: endpoint {
+								remote-endpoint = <&xbar_adx4_out3_ep>;
+							};
 						};
-					};
 
-					xbar_mixer_in2_port: port@55 {
-						reg = <0x55>;
+						adx4_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_mixer_in2_ep: endpoint {
-							remote-endpoint = <&mixer_in2_ep>;
+							adx4_out4_ep: endpoint {
+								remote-endpoint = <&xbar_adx4_out4_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_mixer_in3_port: port@56 {
-						reg = <0x56>;
+				dmic@2904200 {
+					status = "okay";
 
-						xbar_mixer_in3_ep: endpoint {
-							remote-endpoint = <&mixer_in3_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_mixer_in4_port: port@57 {
-						reg = <0x57>;
+						port@0 {
+							reg = <0>;
 
-						xbar_mixer_in4_ep: endpoint {
-							remote-endpoint = <&mixer_in4_ep>;
+							dmic3_cif_ep: endpoint {
+								remote-endpoint = <&xbar_dmic3_ep>;
+							};
 						};
-					};
 
-					xbar_mixer_in5_port: port@58 {
-						reg = <0x58>;
+						dmic3_port: port@1 {
+							reg = <1>;
 
-						xbar_mixer_in5_ep: endpoint {
-							remote-endpoint = <&mixer_in5_ep>;
+							dmic3_dap_ep: endpoint {
+								/* Place holder for external Codec */
+							};
 						};
 					};
+				};
 
-					xbar_mixer_in6_port: port@59 {
-						reg = <0x59>;
+				processing-engine@2908000 {
+					status = "okay";
 
-						xbar_mixer_in6_ep: endpoint {
-							remote-endpoint = <&mixer_in6_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_mixer_in7_port: port@5a {
-						reg = <0x5a>;
+						port@0 {
+							reg = <0x0>;
 
-						xbar_mixer_in7_ep: endpoint {
-							remote-endpoint = <&mixer_in7_ep>;
+							ope1_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_ope1_in_ep>;
+							};
 						};
-					};
 
-					xbar_mixer_in8_port: port@5b {
-						reg = <0x5b>;
+						ope1_out_port: port@1 {
+							reg = <0x1>;
 
-						xbar_mixer_in8_ep: endpoint {
-							remote-endpoint = <&mixer_in8_ep>;
+							ope1_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_ope1_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_mixer_in9_port: port@5c {
-						reg = <0x5c>;
+				mvc@290a000 {
+					status = "okay";
 
-						xbar_mixer_in9_ep: endpoint {
-							remote-endpoint = <&mixer_in9_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_mixer_in10_port: port@5d {
-						reg = <0x5d>;
+						port@0 {
+							reg = <0>;
 
-						xbar_mixer_in10_ep: endpoint {
-							remote-endpoint = <&mixer_in10_ep>;
+							mvc1_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_mvc1_in_ep>;
+							};
 						};
-					};
 
-					port@5e {
-						reg = <0x5e>;
+						mvc1_out_port: port@1 {
+							reg = <1>;
 
-						xbar_mixer_out1_ep: endpoint {
-							remote-endpoint = <&mixer_out1_ep>;
+							mvc1_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_mvc1_out_ep>;
+							};
 						};
 					};
+				};
 
-					port@5f {
-						reg = <0x5f>;
+				mvc@290a200 {
+					status = "okay";
 
-						xbar_mixer_out2_ep: endpoint {
-							remote-endpoint = <&mixer_out2_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@60 {
-						reg = <0x60>;
+						port@0 {
+							reg = <0>;
 
-						xbar_mixer_out3_ep: endpoint {
-							remote-endpoint = <&mixer_out3_ep>;
+							mvc2_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_mvc2_in_ep>;
+							};
 						};
-					};
 
-					port@61 {
-						reg = <0x61>;
+						mvc2_out_port: port@1 {
+							reg = <1>;
 
-						xbar_mixer_out4_ep: endpoint {
-							remote-endpoint = <&mixer_out4_ep>;
+							mvc2_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_mvc2_out_ep>;
+							};
 						};
 					};
+				};
 
-					port@62 {
-						reg = <0x62>;
+				amixer@290bb00 {
+					status = "okay";
 
-						xbar_mixer_out5_ep: endpoint {
-							remote-endpoint = <&mixer_out5_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_asrc_in1_port: port@63 {
-						reg = <0x63>;
+						port@0 {
+							reg = <0x0>;
 
-						xbar_asrc_in1_ep: endpoint {
-							remote-endpoint = <&asrc_in1_ep>;
+							mixer_in1_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in1_ep>;
+							};
 						};
-					};
 
-					port@64 {
-						reg = <0x64>;
+						port@1 {
+							reg = <0x1>;
 
-						xbar_asrc_out1_ep: endpoint {
-							remote-endpoint = <&asrc_out1_ep>;
+							mixer_in2_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in2_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in2_port: port@65 {
-						reg = <0x65>;
+						port@2 {
+							reg = <0x2>;
 
-						xbar_asrc_in2_ep: endpoint {
-							remote-endpoint = <&asrc_in2_ep>;
+							mixer_in3_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in3_ep>;
+							};
 						};
-					};
 
-					port@66 {
-						reg = <0x66>;
+						port@3 {
+							reg = <0x3>;
 
-						xbar_asrc_out2_ep: endpoint {
-							remote-endpoint = <&asrc_out2_ep>;
+							mixer_in4_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in4_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in3_port: port@67 {
-						reg = <0x67>;
+						port@4 {
+							reg = <0x4>;
 
-						xbar_asrc_in3_ep: endpoint {
-							remote-endpoint = <&asrc_in3_ep>;
+							mixer_in5_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in5_ep>;
+							};
 						};
-					};
 
-					port@68 {
-						reg = <0x68>;
+						port@5 {
+							reg = <0x5>;
 
-						xbar_asrc_out3_ep: endpoint {
-							remote-endpoint = <&asrc_out3_ep>;
+							mixer_in6_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in6_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in4_port: port@69 {
-						reg = <0x69>;
+						port@6 {
+							reg = <0x6>;
 
-						xbar_asrc_in4_ep: endpoint {
-							remote-endpoint = <&asrc_in4_ep>;
+							mixer_in7_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in7_ep>;
+							};
 						};
-					};
 
-					port@6a {
-						reg = <0x6a>;
+						port@7 {
+							reg = <0x7>;
 
-						xbar_asrc_out4_ep: endpoint {
-							remote-endpoint = <&asrc_out4_ep>;
+							mixer_in8_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in8_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in5_port: port@6b {
-						reg = <0x6b>;
+						port@8 {
+							reg = <0x8>;
 
-						xbar_asrc_in5_ep: endpoint {
-							remote-endpoint = <&asrc_in5_ep>;
+							mixer_in9_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in9_ep>;
+							};
 						};
-					};
 
-					port@6c {
-						reg = <0x6c>;
+						port@9 {
+							reg = <0x9>;
 
-						xbar_asrc_out5_ep: endpoint {
-							remote-endpoint = <&asrc_out5_ep>;
+							mixer_in10_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in10_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in6_port: port@6d {
-						reg = <0x6d>;
+						mixer_out1_port: port@a {
+							reg = <0xa>;
 
-						xbar_asrc_in6_ep: endpoint {
-							remote-endpoint = <&asrc_in6_ep>;
+							mixer_out1_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_out1_ep>;
+							};
 						};
-					};
 
-					port@6e {
-						reg = <0x6e>;
+						mixer_out2_port: port@b {
+							reg = <0xb>;
 
-						xbar_asrc_out6_ep: endpoint {
-							remote-endpoint = <&asrc_out6_ep>;
+							mixer_out2_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_out2_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in7_port: port@6f {
-						reg = <0x6f>;
+						mixer_out3_port: port@c {
+							reg = <0xc>;
 
-						xbar_asrc_in7_ep: endpoint {
-							remote-endpoint = <&asrc_in7_ep>;
+							mixer_out3_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_out3_ep>;
+							};
 						};
-					};
 
-					xbar_ope1_in_port: port@70 {
-						reg = <0x70>;
+						mixer_out4_port: port@d {
+							reg = <0xd>;
 
-						xbar_ope1_in_ep: endpoint {
-							remote-endpoint = <&ope1_cif_in_ep>;
+							mixer_out4_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_out4_ep>;
+							};
 						};
-					};
 
-					port@71 {
-						reg = <0x71>;
+						mixer_out5_port: port@e {
+							reg = <0xe>;
 
-						xbar_ope1_out_ep: endpoint {
-							remote-endpoint = <&ope1_cif_out_ep>;
+							mixer_out5_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_out5_ep>;
+							};
 						};
 					};
 				};
@@ -1055,7 +1011,7 @@ admaif19_ep: endpoint {
 					};
 				};
 
-				i2s@2901000 {
+				asrc@2910000 {
 					status = "okay";
 
 					ports {
@@ -1063,936 +1019,980 @@ ports {
 						#size-cells = <0>;
 
 						port@0 {
-							reg = <0>;
+							reg = <0x0>;
 
-							i2s1_cif_ep: endpoint {
-								remote-endpoint = <&xbar_i2s1_ep>;
+							asrc_in1_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in1_ep>;
 							};
 						};
 
-						i2s1_port: port@1 {
-							reg = <1>;
+						port@1 {
+							reg = <0x1>;
 
-							i2s1_dap_ep: endpoint {
-								dai-format = "i2s";
-								remote-endpoint = <&rt5658_ep>;
+							asrc_in2_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in2_ep>;
 							};
 						};
-					};
-				};
 
-				i2s@2901100 {
-					status = "okay";
+						port@2 {
+							reg = <0x2>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							asrc_in3_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in3_ep>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						port@3 {
+							reg = <0x3>;
 
-							i2s2_cif_ep: endpoint {
-								remote-endpoint = <&xbar_i2s2_ep>;
+							asrc_in4_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in4_ep>;
 							};
 						};
 
-						i2s2_port: port@1 {
-							reg = <1>;
+						port@4 {
+							reg = <0x4>;
 
-							i2s2_dap_ep: endpoint {
-								dai-format = "i2s";
-								/* Place holder for external Codec */
+							asrc_in5_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in5_ep>;
 							};
 						};
-					};
-				};
 
-				i2s@2901300 {
-					status = "okay";
+						port@5 {
+							reg = <0x5>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							asrc_in6_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in6_ep>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						port@6 {
+							reg = <0x6>;
 
-							i2s4_cif_ep: endpoint {
-								remote-endpoint = <&xbar_i2s4_ep>;
+							asrc_in7_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in7_ep>;
 							};
 						};
 
-						i2s4_port: port@1 {
-							reg = <1>;
+						asrc_out1_port: port@7 {
+							reg = <0x7>;
 
-							i2s4_dap_ep: endpoint {
-								dai-format = "i2s";
-								/* Place holder for external Codec */
+							asrc_out1_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out1_ep>;
 							};
 						};
-					};
-				};
 
-				i2s@2901500 {
-					status = "okay";
+						asrc_out2_port: port@8 {
+							reg = <0x8>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							asrc_out2_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out2_ep>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						asrc_out3_port: port@9 {
+							reg = <0x9>;
 
-							i2s6_cif_ep: endpoint {
-								remote-endpoint = <&xbar_i2s6_ep>;
+							asrc_out3_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out3_ep>;
 							};
 						};
 
-						i2s6_port: port@1 {
-							reg = <1>;
+						asrc_out4_port: port@a {
+							reg = <0xa>;
 
-							i2s6_dap_ep: endpoint {
-								dai-format = "i2s";
-								/* Place holder for external Codec */
+							asrc_out4_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out4_ep>;
+							};
+						};
+
+						asrc_out5_port: port@b {
+							reg = <0xb>;
+
+							asrc_out5_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out5_ep>;
+							};
+						};
+
+						asrc_out6_port: port@c {
+							reg = <0xc>;
+
+							asrc_out6_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out6_ep>;
 							};
 						};
 					};
 				};
 
-				dmic@2904200 {
-					status = "okay";
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+					port@0 {
+						reg = <0x0>;
 
-						port@0 {
-							reg = <0>;
+						xbar_admaif0_ep: endpoint {
+							remote-endpoint = <&admaif0_ep>;
+						};
+					};
 
-							dmic3_cif_ep: endpoint {
-								remote-endpoint = <&xbar_dmic3_ep>;
-							};
+					port@1 {
+						reg = <0x1>;
+
+						xbar_admaif1_ep: endpoint {
+							remote-endpoint = <&admaif1_ep>;
 						};
+					};
 
-						dmic3_port: port@1 {
-							reg = <1>;
+					port@2 {
+						reg = <0x2>;
 
-							dmic3_dap_ep: endpoint {
-								/* Place holder for external Codec */
-							};
+						xbar_admaif2_ep: endpoint {
+							remote-endpoint = <&admaif2_ep>;
 						};
 					};
-				};
 
-				sfc@2902000 {
-					status = "okay";
+					port@3 {
+						reg = <0x3>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif3_ep: endpoint {
+							remote-endpoint = <&admaif3_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@4 {
+						reg = <0x4>;
+
+						xbar_admaif4_ep: endpoint {
+							remote-endpoint = <&admaif4_ep>;
+						};
+					};
+
+					port@5 {
+						reg = <0x5>;
+
+						xbar_admaif5_ep: endpoint {
+							remote-endpoint = <&admaif5_ep>;
+						};
+					};
+
+					port@6 {
+						reg = <0x6>;
+
+						xbar_admaif6_ep: endpoint {
+							remote-endpoint = <&admaif6_ep>;
+						};
+					};
+
+					port@7 {
+						reg = <0x7>;
+
+						xbar_admaif7_ep: endpoint {
+							remote-endpoint = <&admaif7_ep>;
+						};
+					};
+
+					port@8 {
+						reg = <0x8>;
 
-							sfc1_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_sfc1_in_ep>;
-							};
+						xbar_admaif8_ep: endpoint {
+							remote-endpoint = <&admaif8_ep>;
 						};
+					};
 
-						sfc1_out_port: port@1 {
-							reg = <1>;
+					port@9 {
+						reg = <0x9>;
 
-							sfc1_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_sfc1_out_ep>;
-							};
+						xbar_admaif9_ep: endpoint {
+							remote-endpoint = <&admaif9_ep>;
 						};
 					};
-				};
 
-				sfc@2902200 {
-					status = "okay";
+					port@a {
+						reg = <0xa>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif10_ep: endpoint {
+							remote-endpoint = <&admaif10_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@b {
+						reg = <0xb>;
 
-							sfc2_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_sfc2_in_ep>;
-							};
+						xbar_admaif11_ep: endpoint {
+							remote-endpoint = <&admaif11_ep>;
 						};
+					};
 
-						sfc2_out_port: port@1 {
-							reg = <1>;
+					port@c {
+						reg = <0xc>;
 
-							sfc2_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_sfc2_out_ep>;
-							};
+						xbar_admaif12_ep: endpoint {
+							remote-endpoint = <&admaif12_ep>;
 						};
 					};
-				};
 
-				sfc@2902400 {
-					status = "okay";
+					port@d {
+						reg = <0xd>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif13_ep: endpoint {
+							remote-endpoint = <&admaif13_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@e {
+						reg = <0xe>;
 
-							sfc3_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_sfc3_in_ep>;
-							};
+						xbar_admaif14_ep: endpoint {
+							remote-endpoint = <&admaif14_ep>;
 						};
+					};
 
-						sfc3_out_port: port@1 {
-							reg = <1>;
+					port@f {
+						reg = <0xf>;
 
-							sfc3_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_sfc3_out_ep>;
-							};
+						xbar_admaif15_ep: endpoint {
+							remote-endpoint = <&admaif15_ep>;
 						};
 					};
-				};
 
-				sfc@2902600 {
-					status = "okay";
+					port@10 {
+						reg = <0x10>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif16_ep: endpoint {
+							remote-endpoint = <&admaif16_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@11 {
+						reg = <0x11>;
 
-							sfc4_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_sfc4_in_ep>;
-							};
+						xbar_admaif17_ep: endpoint {
+							remote-endpoint = <&admaif17_ep>;
 						};
+					};
 
-						sfc4_out_port: port@1 {
-							reg = <1>;
+					port@12 {
+						reg = <0x12>;
 
-							sfc4_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_sfc4_out_ep>;
-							};
+						xbar_admaif18_ep: endpoint {
+							remote-endpoint = <&admaif18_ep>;
 						};
 					};
-				};
 
-				mvc@290a000 {
-					status = "okay";
+					port@13 {
+						reg = <0x13>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif19_ep: endpoint {
+							remote-endpoint = <&admaif19_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_i2s1_port: port@14 {
+						reg = <0x14>;
 
-							mvc1_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_mvc1_in_ep>;
-							};
+						xbar_i2s1_ep: endpoint {
+							remote-endpoint = <&i2s1_cif_ep>;
 						};
+					};
 
-						mvc1_out_port: port@1 {
-							reg = <1>;
+					xbar_i2s2_port: port@15 {
+						reg = <0x15>;
 
-							mvc1_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_mvc1_out_ep>;
-							};
+						xbar_i2s2_ep: endpoint {
+							remote-endpoint = <&i2s2_cif_ep>;
 						};
 					};
-				};
 
-				mvc@290a200 {
-					status = "okay";
+					xbar_i2s4_port: port@17 {
+						reg = <0x17>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_i2s4_ep: endpoint {
+							remote-endpoint = <&i2s4_cif_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_i2s6_port: port@19 {
+						reg = <0x19>;
 
-							mvc2_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_mvc2_in_ep>;
-							};
+						xbar_i2s6_ep: endpoint {
+							remote-endpoint = <&i2s6_cif_ep>;
 						};
+					};
 
-						mvc2_out_port: port@1 {
-							reg = <1>;
+					xbar_dmic3_port: port@1c {
+						reg = <0x1c>;
 
-							mvc2_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_mvc2_out_ep>;
-							};
+						xbar_dmic3_ep: endpoint {
+							remote-endpoint = <&dmic3_cif_ep>;
 						};
 					};
-				};
 
-				amx@2903000 {
-					status = "okay";
+					xbar_sfc1_in_port: port@20 {
+						reg = <0x20>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_sfc1_in_ep: endpoint {
+							remote-endpoint = <&sfc1_cif_in_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@21 {
+						reg = <0x21>;
 
-							amx1_in1_ep: endpoint {
-								remote-endpoint = <&xbar_amx1_in1_ep>;
-							};
+						xbar_sfc1_out_ep: endpoint {
+							remote-endpoint = <&sfc1_cif_out_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <1>;
+					xbar_sfc2_in_port: port@22 {
+						reg = <0x22>;
 
-							amx1_in2_ep: endpoint {
-								remote-endpoint = <&xbar_amx1_in2_ep>;
-							};
+						xbar_sfc2_in_ep: endpoint {
+							remote-endpoint = <&sfc2_cif_in_ep>;
 						};
+					};
 
-						port@2 {
-							reg = <2>;
+					port@23 {
+						reg = <0x23>;
 
-							amx1_in3_ep: endpoint {
-								remote-endpoint = <&xbar_amx1_in3_ep>;
-							};
+						xbar_sfc2_out_ep: endpoint {
+							remote-endpoint = <&sfc2_cif_out_ep>;
 						};
+					};
 
-						port@3 {
-							reg = <3>;
+					xbar_sfc3_in_port: port@24 {
+						reg = <0x24>;
 
-							amx1_in4_ep: endpoint {
-								remote-endpoint = <&xbar_amx1_in4_ep>;
-							};
+						xbar_sfc3_in_ep: endpoint {
+							remote-endpoint = <&sfc3_cif_in_ep>;
 						};
+					};
 
-						amx1_out_port: port@4 {
-							reg = <4>;
+					port@25 {
+						reg = <0x25>;
 
-							amx1_out_ep: endpoint {
-								remote-endpoint = <&xbar_amx1_out_ep>;
-							};
+						xbar_sfc3_out_ep: endpoint {
+							remote-endpoint = <&sfc3_cif_out_ep>;
 						};
 					};
-				};
 
-				amx@2903100 {
-					status = "okay";
+					xbar_sfc4_in_port: port@26 {
+						reg = <0x26>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_sfc4_in_ep: endpoint {
+							remote-endpoint = <&sfc4_cif_in_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@27 {
+						reg = <0x27>;
 
-							amx2_in1_ep: endpoint {
-								remote-endpoint = <&xbar_amx2_in1_ep>;
-							};
+						xbar_sfc4_out_ep: endpoint {
+							remote-endpoint = <&sfc4_cif_out_ep>;
+						};
+					};
+
+					xbar_mvc1_in_port: port@28 {
+						reg = <0x28>;
+
+						xbar_mvc1_in_ep: endpoint {
+							remote-endpoint = <&mvc1_cif_in_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <1>;
+					port@29 {
+						reg = <0x29>;
 
-							amx2_in2_ep: endpoint {
-								remote-endpoint = <&xbar_amx2_in2_ep>;
-							};
+						xbar_mvc1_out_ep: endpoint {
+							remote-endpoint = <&mvc1_cif_out_ep>;
 						};
+					};
 
-						amx2_in3_port: port@2 {
-							reg = <2>;
+					xbar_mvc2_in_port: port@2a {
+						reg = <0x2a>;
 
-							amx2_in3_ep: endpoint {
-								remote-endpoint = <&xbar_amx2_in3_ep>;
-							};
+						xbar_mvc2_in_ep: endpoint {
+							remote-endpoint = <&mvc2_cif_in_ep>;
 						};
+					};
 
-						amx2_in4_port: port@3 {
-							reg = <3>;
+					port@2b {
+						reg = <0x2b>;
 
-							amx2_in4_ep: endpoint {
-								remote-endpoint = <&xbar_amx2_in4_ep>;
-							};
+						xbar_mvc2_out_ep: endpoint {
+							remote-endpoint = <&mvc2_cif_out_ep>;
 						};
+					};
 
-						amx2_out_port: port@4 {
-							reg = <4>;
+					xbar_amx1_in1_port: port@2c {
+						reg = <0x2c>;
 
-							amx2_out_ep: endpoint {
-								remote-endpoint = <&xbar_amx2_out_ep>;
-							};
+						xbar_amx1_in1_ep: endpoint {
+							remote-endpoint = <&amx1_in1_ep>;
 						};
 					};
-				};
 
-				amx@2903200 {
-					status = "okay";
+					xbar_amx1_in2_port: port@2d {
+						reg = <0x2d>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx1_in2_ep: endpoint {
+							remote-endpoint = <&amx1_in2_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_amx1_in3_port: port@2e {
+						reg = <0x2e>;
 
-							amx3_in1_ep: endpoint {
-								remote-endpoint = <&xbar_amx3_in1_ep>;
-							};
+						xbar_amx1_in3_ep: endpoint {
+							remote-endpoint = <&amx1_in3_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <1>;
+					xbar_amx1_in4_port: port@2f {
+						reg = <0x2f>;
 
-							amx3_in2_ep: endpoint {
-								remote-endpoint = <&xbar_amx3_in2_ep>;
-							};
+						xbar_amx1_in4_ep: endpoint {
+							remote-endpoint = <&amx1_in4_ep>;
 						};
+					};
 
-						port@2 {
-							reg = <2>;
+					port@30 {
+						reg = <0x30>;
 
-							amx3_in3_ep: endpoint {
-								remote-endpoint = <&xbar_amx3_in3_ep>;
-							};
+						xbar_amx1_out_ep: endpoint {
+							remote-endpoint = <&amx1_out_ep>;
 						};
+					};
 
-						port@3 {
-							reg = <3>;
+					xbar_amx2_in1_port: port@31 {
+						reg = <0x31>;
 
-							amx3_in4_ep: endpoint {
-								remote-endpoint = <&xbar_amx3_in4_ep>;
-							};
+						xbar_amx2_in1_ep: endpoint {
+							remote-endpoint = <&amx2_in1_ep>;
 						};
+					};
 
-						amx3_out_port: port@4 {
-							reg = <4>;
+					xbar_amx2_in2_port: port@32 {
+						reg = <0x32>;
 
-							amx3_out_ep: endpoint {
-								remote-endpoint = <&xbar_amx3_out_ep>;
-							};
+						xbar_amx2_in2_ep: endpoint {
+							remote-endpoint = <&amx2_in2_ep>;
 						};
 					};
-				};
 
-				amx@2903300 {
-					status = "okay";
+					xbar_amx2_in3_port: port@33 {
+						reg = <0x33>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx2_in3_ep: endpoint {
+							remote-endpoint = <&amx2_in3_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_amx2_in4_port: port@34 {
+						reg = <0x34>;
 
-							amx4_in1_ep: endpoint {
-								remote-endpoint = <&xbar_amx4_in1_ep>;
-							};
+						xbar_amx2_in4_ep: endpoint {
+							remote-endpoint = <&amx2_in4_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <1>;
+					port@35 {
+						reg = <0x35>;
 
-							amx4_in2_ep: endpoint {
-								remote-endpoint = <&xbar_amx4_in2_ep>;
-							};
+						xbar_amx2_out_ep: endpoint {
+							remote-endpoint = <&amx2_out_ep>;
 						};
+					};
 
-						port@2 {
-							reg = <2>;
+					xbar_amx3_in1_port: port@36 {
+						reg = <0x36>;
 
-							amx4_in3_ep: endpoint {
-								remote-endpoint = <&xbar_amx4_in3_ep>;
-							};
+						xbar_amx3_in1_ep: endpoint {
+							remote-endpoint = <&amx3_in1_ep>;
 						};
+					};
 
-						port@3 {
-							reg = <3>;
+					xbar_amx3_in2_port: port@37 {
+						reg = <0x37>;
 
-							amx4_in4_ep: endpoint {
-								remote-endpoint = <&xbar_amx4_in4_ep>;
-							};
+						xbar_amx3_in2_ep: endpoint {
+							remote-endpoint = <&amx3_in2_ep>;
 						};
+					};
 
-						amx4_out_port: port@4 {
-							reg = <4>;
+					xbar_amx3_in3_port: port@38 {
+						reg = <0x38>;
 
-							amx4_out_ep: endpoint {
-								remote-endpoint = <&xbar_amx4_out_ep>;
-							};
+						xbar_amx3_in3_ep: endpoint {
+							remote-endpoint = <&amx3_in3_ep>;
 						};
 					};
-				};
 
-				adx@2903800 {
-					status = "okay";
+					xbar_amx3_in4_port: port@39 {
+						reg = <0x39>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx3_in4_ep: endpoint {
+							remote-endpoint = <&amx3_in4_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@3a {
+						reg = <0x3a>;
 
-							adx1_in_ep: endpoint {
-								remote-endpoint = <&xbar_adx1_in_ep>;
-							};
+						xbar_amx3_out_ep: endpoint {
+							remote-endpoint = <&amx3_out_ep>;
 						};
+					};
 
-						adx1_out1_port: port@1 {
-							reg = <1>;
+					xbar_amx4_in1_port: port@3b {
+						reg = <0x3b>;
 
-							adx1_out1_ep: endpoint {
-								remote-endpoint = <&xbar_adx1_out1_ep>;
-							};
+						xbar_amx4_in1_ep: endpoint {
+							remote-endpoint = <&amx4_in1_ep>;
 						};
+					};
 
-						adx1_out2_port: port@2 {
-							reg = <2>;
+					xbar_amx4_in2_port: port@3c {
+						reg = <0x3c>;
 
-							adx1_out2_ep: endpoint {
-								remote-endpoint = <&xbar_adx1_out2_ep>;
-							};
+						xbar_amx4_in2_ep: endpoint {
+							remote-endpoint = <&amx4_in2_ep>;
 						};
+					};
 
-						adx1_out3_port: port@3 {
-							reg = <3>;
+					xbar_amx4_in3_port: port@3d {
+						reg = <0x3d>;
 
-							adx1_out3_ep: endpoint {
-								remote-endpoint = <&xbar_adx1_out3_ep>;
-							};
+						xbar_amx4_in3_ep: endpoint {
+							remote-endpoint = <&amx4_in3_ep>;
 						};
+					};
 
-						adx1_out4_port: port@4 {
-							reg = <4>;
+					xbar_amx4_in4_port: port@3e {
+						reg = <0x3e>;
 
-							adx1_out4_ep: endpoint {
-								remote-endpoint = <&xbar_adx1_out4_ep>;
-							};
+						xbar_amx4_in4_ep: endpoint {
+							remote-endpoint = <&amx4_in4_ep>;
 						};
 					};
-				};
 
-				adx@2903900 {
-					status = "okay";
+					port@3f {
+						reg = <0x3f>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx4_out_ep: endpoint {
+							remote-endpoint = <&amx4_out_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_adx1_in_port: port@40 {
+						reg = <0x40>;
 
-							adx2_in_ep: endpoint {
-								remote-endpoint = <&xbar_adx2_in_ep>;
-							};
+						xbar_adx1_in_ep: endpoint {
+							remote-endpoint = <&adx1_in_ep>;
 						};
+					};
 
-						adx2_out1_port: port@1 {
-							reg = <1>;
-
-							adx2_out1_ep: endpoint {
-								remote-endpoint = <&xbar_adx2_out1_ep>;
-							};
+					port@41 {
+						reg = <0x41>;
+
+						xbar_adx1_out1_ep: endpoint {
+							remote-endpoint = <&adx1_out1_ep>;
 						};
+					};
 
-						adx2_out2_port: port@2 {
-							reg = <2>;
+					port@42 {
+						reg = <0x42>;
 
-							adx2_out2_ep: endpoint {
-								remote-endpoint = <&xbar_adx2_out2_ep>;
-							};
+						xbar_adx1_out2_ep: endpoint {
+							remote-endpoint = <&adx1_out2_ep>;
 						};
+					};
 
-						adx2_out3_port: port@3 {
-							reg = <3>;
+					port@43 {
+						reg = <0x43>;
 
-							adx2_out3_ep: endpoint {
-								remote-endpoint = <&xbar_adx2_out3_ep>;
-							};
+						xbar_adx1_out3_ep: endpoint {
+							remote-endpoint = <&adx1_out3_ep>;
 						};
+					};
 
-						adx2_out4_port: port@4 {
-							reg = <4>;
+					port@44 {
+						reg = <0x44>;
 
-							adx2_out4_ep: endpoint {
-								remote-endpoint = <&xbar_adx2_out4_ep>;
-							};
+						xbar_adx1_out4_ep: endpoint {
+							remote-endpoint = <&adx1_out4_ep>;
 						};
 					};
-				};
 
-				adx@2903a00 {
-					status = "okay";
+					xbar_adx2_in_port: port@45 {
+						reg = <0x45>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_adx2_in_ep: endpoint {
+							remote-endpoint = <&adx2_in_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@46 {
+						reg = <0x46>;
 
-							adx3_in_ep: endpoint {
-								remote-endpoint = <&xbar_adx3_in_ep>;
-							};
+						xbar_adx2_out1_ep: endpoint {
+							remote-endpoint = <&adx2_out1_ep>;
 						};
+					};
 
-						adx3_out1_port: port@1 {
-							reg = <1>;
+					port@47 {
+						reg = <0x47>;
 
-							adx3_out1_ep: endpoint {
-								remote-endpoint = <&xbar_adx3_out1_ep>;
-							};
+						xbar_adx2_out2_ep: endpoint {
+							remote-endpoint = <&adx2_out2_ep>;
 						};
+					};
 
-						adx3_out2_port: port@2 {
-							reg = <2>;
+					port@48 {
+						reg = <0x48>;
 
-							adx3_out2_ep: endpoint {
-								remote-endpoint = <&xbar_adx3_out2_ep>;
-							};
+						xbar_adx2_out3_ep: endpoint {
+							remote-endpoint = <&adx2_out3_ep>;
 						};
+					};
 
-						adx3_out3_port: port@3 {
-							reg = <3>;
+					port@49 {
+						reg = <0x49>;
 
-							adx3_out3_ep: endpoint {
-								remote-endpoint = <&xbar_adx3_out3_ep>;
-							};
+						xbar_adx2_out4_ep: endpoint {
+							remote-endpoint = <&adx2_out4_ep>;
 						};
+					};
 
-						adx3_out4_port: port@4 {
-							reg = <4>;
+					xbar_adx3_in_port: port@4a {
+						reg = <0x4a>;
 
-							adx3_out4_ep: endpoint {
-								remote-endpoint = <&xbar_adx3_out4_ep>;
-							};
+						xbar_adx3_in_ep: endpoint {
+							remote-endpoint = <&adx3_in_ep>;
 						};
 					};
-				};
 
-				adx@2903b00 {
-					status = "okay";
+					port@4b {
+						reg = <0x4b>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_adx3_out1_ep: endpoint {
+							remote-endpoint = <&adx3_out1_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@4c {
+						reg = <0x4c>;
 
-							adx4_in_ep: endpoint {
-								remote-endpoint = <&xbar_adx4_in_ep>;
-							};
+						xbar_adx3_out2_ep: endpoint {
+							remote-endpoint = <&adx3_out2_ep>;
 						};
+					};
 
-						adx4_out1_port: port@1 {
-							reg = <1>;
+					port@4d {
+						reg = <0x4d>;
 
-							adx4_out1_ep: endpoint {
-								remote-endpoint = <&xbar_adx4_out1_ep>;
-							};
+						xbar_adx3_out3_ep: endpoint {
+							remote-endpoint = <&adx3_out3_ep>;
 						};
+					};
 
-						adx4_out2_port: port@2 {
-							reg = <2>;
+					port@4e {
+						reg = <0x4e>;
 
-							adx4_out2_ep: endpoint {
-								remote-endpoint = <&xbar_adx4_out2_ep>;
-							};
+						xbar_adx3_out4_ep: endpoint {
+							remote-endpoint = <&adx3_out4_ep>;
 						};
+					};
 
-						adx4_out3_port: port@3 {
-							reg = <3>;
+					xbar_adx4_in_port: port@4f {
+						reg = <0x4f>;
 
-							adx4_out3_ep: endpoint {
-								remote-endpoint = <&xbar_adx4_out3_ep>;
-							};
+						xbar_adx4_in_ep: endpoint {
+							remote-endpoint = <&adx4_in_ep>;
 						};
+					};
 
-						adx4_out4_port: port@4 {
-							reg = <4>;
+					port@50 {
+						reg = <0x50>;
 
-							adx4_out4_ep: endpoint {
-								remote-endpoint = <&xbar_adx4_out4_ep>;
-							};
+						xbar_adx4_out1_ep: endpoint {
+							remote-endpoint = <&adx4_out1_ep>;
 						};
 					};
-				};
 
-				processing-engine@2908000 {
-					status = "okay";
+					port@51 {
+						reg = <0x51>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_adx4_out2_ep: endpoint {
+							remote-endpoint = <&adx4_out2_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0x0>;
+					port@52 {
+						reg = <0x52>;
 
-							ope1_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_ope1_in_ep>;
-							};
+						xbar_adx4_out3_ep: endpoint {
+							remote-endpoint = <&adx4_out3_ep>;
 						};
+					};
 
-						ope1_out_port: port@1 {
-							reg = <0x1>;
+					port@53 {
+						reg = <0x53>;
 
-							ope1_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_ope1_out_ep>;
-							};
+						xbar_adx4_out4_ep: endpoint {
+							remote-endpoint = <&adx4_out4_ep>;
 						};
 					};
-				};
 
-				amixer@290bb00 {
-					status = "okay";
+					xbar_mixer_in1_port: port@54 {
+						reg = <0x54>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_mixer_in1_ep: endpoint {
+							remote-endpoint = <&mixer_in1_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0x0>;
+					xbar_mixer_in2_port: port@55 {
+						reg = <0x55>;
 
-							mixer_in1_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in1_ep>;
-							};
+						xbar_mixer_in2_ep: endpoint {
+							remote-endpoint = <&mixer_in2_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <0x1>;
+					xbar_mixer_in3_port: port@56 {
+						reg = <0x56>;
 
-							mixer_in2_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in2_ep>;
-							};
+						xbar_mixer_in3_ep: endpoint {
+							remote-endpoint = <&mixer_in3_ep>;
 						};
+					};
 
-						port@2 {
-							reg = <0x2>;
+					xbar_mixer_in4_port: port@57 {
+						reg = <0x57>;
 
-							mixer_in3_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in3_ep>;
-							};
+						xbar_mixer_in4_ep: endpoint {
+							remote-endpoint = <&mixer_in4_ep>;
 						};
+					};
 
-						port@3 {
-							reg = <0x3>;
+					xbar_mixer_in5_port: port@58 {
+						reg = <0x58>;
 
-							mixer_in4_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in4_ep>;
-							};
+						xbar_mixer_in5_ep: endpoint {
+							remote-endpoint = <&mixer_in5_ep>;
 						};
+					};
 
-						port@4 {
-							reg = <0x4>;
+					xbar_mixer_in6_port: port@59 {
+						reg = <0x59>;
 
-							mixer_in5_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in5_ep>;
-							};
+						xbar_mixer_in6_ep: endpoint {
+							remote-endpoint = <&mixer_in6_ep>;
 						};
+					};
 
-						port@5 {
-							reg = <0x5>;
+					xbar_mixer_in7_port: port@5a {
+						reg = <0x5a>;
 
-							mixer_in6_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in6_ep>;
-							};
+						xbar_mixer_in7_ep: endpoint {
+							remote-endpoint = <&mixer_in7_ep>;
 						};
+					};
 
-						port@6 {
-							reg = <0x6>;
+					xbar_mixer_in8_port: port@5b {
+						reg = <0x5b>;
 
-							mixer_in7_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in7_ep>;
-							};
+						xbar_mixer_in8_ep: endpoint {
+							remote-endpoint = <&mixer_in8_ep>;
 						};
+					};
 
-						port@7 {
-							reg = <0x7>;
+					xbar_mixer_in9_port: port@5c {
+						reg = <0x5c>;
 
-							mixer_in8_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in8_ep>;
-							};
+						xbar_mixer_in9_ep: endpoint {
+							remote-endpoint = <&mixer_in9_ep>;
 						};
+					};
 
-						port@8 {
-							reg = <0x8>;
+					xbar_mixer_in10_port: port@5d {
+						reg = <0x5d>;
 
-							mixer_in9_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in9_ep>;
-							};
+						xbar_mixer_in10_ep: endpoint {
+							remote-endpoint = <&mixer_in10_ep>;
 						};
+					};
 
-						port@9 {
-							reg = <0x9>;
+					port@5e {
+						reg = <0x5e>;
 
-							mixer_in10_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in10_ep>;
-							};
+						xbar_mixer_out1_ep: endpoint {
+							remote-endpoint = <&mixer_out1_ep>;
 						};
+					};
 
-						mixer_out1_port: port@a {
-							reg = <0xa>;
+					port@5f {
+						reg = <0x5f>;
 
-							mixer_out1_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_out1_ep>;
-							};
+						xbar_mixer_out2_ep: endpoint {
+							remote-endpoint = <&mixer_out2_ep>;
 						};
+					};
 
-						mixer_out2_port: port@b {
-							reg = <0xb>;
+					port@60 {
+						reg = <0x60>;
 
-							mixer_out2_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_out2_ep>;
-							};
+						xbar_mixer_out3_ep: endpoint {
+							remote-endpoint = <&mixer_out3_ep>;
 						};
+					};
 
-						mixer_out3_port: port@c {
-							reg = <0xc>;
+					port@61 {
+						reg = <0x61>;
 
-							mixer_out3_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_out3_ep>;
-							};
+						xbar_mixer_out4_ep: endpoint {
+							remote-endpoint = <&mixer_out4_ep>;
 						};
+					};
 
-						mixer_out4_port: port@d {
-							reg = <0xd>;
+					port@62 {
+						reg = <0x62>;
 
-							mixer_out4_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_out4_ep>;
-							};
+						xbar_mixer_out5_ep: endpoint {
+							remote-endpoint = <&mixer_out5_ep>;
 						};
+					};
 
-						mixer_out5_port: port@e {
-							reg = <0xe>;
+					xbar_asrc_in1_port: port@63 {
+						reg = <0x63>;
 
-							mixer_out5_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_out5_ep>;
-							};
+						xbar_asrc_in1_ep: endpoint {
+							remote-endpoint = <&asrc_in1_ep>;
 						};
 					};
-				};
 
-				asrc@2910000 {
-					status = "okay";
+					port@64 {
+						reg = <0x64>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_asrc_out1_ep: endpoint {
+							remote-endpoint = <&asrc_out1_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0x0>;
+					xbar_asrc_in2_port: port@65 {
+						reg = <0x65>;
 
-							asrc_in1_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in1_ep>;
-							};
+						xbar_asrc_in2_ep: endpoint {
+							remote-endpoint = <&asrc_in2_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <0x1>;
+					port@66 {
+						reg = <0x66>;
 
-							asrc_in2_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in2_ep>;
-							};
+						xbar_asrc_out2_ep: endpoint {
+							remote-endpoint = <&asrc_out2_ep>;
 						};
+					};
 
-						port@2 {
-							reg = <0x2>;
+					xbar_asrc_in3_port: port@67 {
+						reg = <0x67>;
 
-							asrc_in3_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in3_ep>;
-							};
+						xbar_asrc_in3_ep: endpoint {
+							remote-endpoint = <&asrc_in3_ep>;
 						};
+					};
 
-						port@3 {
-							reg = <0x3>;
+					port@68 {
+						reg = <0x68>;
 
-							asrc_in4_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in4_ep>;
-							};
+						xbar_asrc_out3_ep: endpoint {
+							remote-endpoint = <&asrc_out3_ep>;
 						};
+					};
 
-						port@4 {
-							reg = <0x4>;
+					xbar_asrc_in4_port: port@69 {
+						reg = <0x69>;
 
-							asrc_in5_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in5_ep>;
-							};
+						xbar_asrc_in4_ep: endpoint {
+							remote-endpoint = <&asrc_in4_ep>;
 						};
+					};
 
-						port@5 {
-							reg = <0x5>;
+					port@6a {
+						reg = <0x6a>;
 
-							asrc_in6_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in6_ep>;
-							};
+						xbar_asrc_out4_ep: endpoint {
+							remote-endpoint = <&asrc_out4_ep>;
 						};
+					};
 
-						port@6 {
-							reg = <0x6>;
+					xbar_asrc_in5_port: port@6b {
+						reg = <0x6b>;
 
-							asrc_in7_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in7_ep>;
-							};
+						xbar_asrc_in5_ep: endpoint {
+							remote-endpoint = <&asrc_in5_ep>;
 						};
+					};
 
-						asrc_out1_port: port@7 {
-							reg = <0x7>;
+					port@6c {
+						reg = <0x6c>;
 
-							asrc_out1_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out1_ep>;
-							};
+						xbar_asrc_out5_ep: endpoint {
+							remote-endpoint = <&asrc_out5_ep>;
 						};
+					};
 
-						asrc_out2_port: port@8 {
-							reg = <0x8>;
+					xbar_asrc_in6_port: port@6d {
+						reg = <0x6d>;
 
-							asrc_out2_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out2_ep>;
-							};
+						xbar_asrc_in6_ep: endpoint {
+							remote-endpoint = <&asrc_in6_ep>;
 						};
+					};
 
-						asrc_out3_port: port@9 {
-							reg = <0x9>;
+					port@6e {
+						reg = <0x6e>;
 
-							asrc_out3_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out3_ep>;
-							};
+						xbar_asrc_out6_ep: endpoint {
+							remote-endpoint = <&asrc_out6_ep>;
 						};
+					};
 
-						asrc_out4_port: port@a {
-							reg = <0xa>;
+					xbar_asrc_in7_port: port@6f {
+						reg = <0x6f>;
 
-							asrc_out4_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out4_ep>;
-							};
+						xbar_asrc_in7_ep: endpoint {
+							remote-endpoint = <&asrc_in7_ep>;
 						};
+					};
 
-						asrc_out5_port: port@b {
-							reg = <0xb>;
+					xbar_ope1_in_port: port@70 {
+						reg = <0x70>;
 
-							asrc_out5_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out5_ep>;
-							};
+						xbar_ope1_in_ep: endpoint {
+							remote-endpoint = <&ope1_cif_in_ep>;
 						};
+					};
 
-						asrc_out6_port:	port@c {
-							reg = <0xc>;
+					port@71 {
+						reg = <0x71>;
 
-							asrc_out6_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out6_ep>;
-							};
+						xbar_ope1_out_ep: endpoint {
+							remote-endpoint = <&ope1_cif_out_ep>;
 						};
 					};
 				};
 			};
+
+			dma-controller@2930000 {
+				status = "okay";
+			};
+
+			interrupt-controller@2a40000 {
+				status = "okay";
+			};
 		};
 
 		i2c@3160000 {
@@ -2247,14 +2247,6 @@ pcie-ep@141a0000 {
 		};
 	};
 
-	fan: pwm-fan {
-		compatible = "pwm-fan";
-		pwms = <&pwm4 0 45334>;
-
-		cooling-levels = <0 64 128 255>;
-		#cooling-cells = <2>;
-	};
-
 	gpio-keys {
 		compatible = "gpio-keys";
 
@@ -2279,6 +2271,14 @@ key-power {
 		};
 	};
 
+	fan: pwm-fan {
+		compatible = "pwm-fan";
+		pwms = <&pwm4 0 45334>;
+
+		cooling-levels = <0 64 128 255>;
+		#cooling-cells = <2>;
+	};
+
 	sound {
 		compatible = "nvidia,tegra186-audio-graph-card";
 		status = "okay";
diff --git a/arch/arm64/boot/dts/nvidia/tegra194-p3509-0000.dtsi b/arch/arm64/boot/dts/nvidia/tegra194-p3509-0000.dtsi
index 617fbfaaf02f6..4a17ea5e40fd0 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194-p3509-0000.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194-p3509-0000.dtsi
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <dt-bindings/gpio/tegra194-gpio.h>
 #include <dt-bindings/input/linux-event-codes.h>
 #include <dt-bindings/input/gpio-keys.h>
 
@@ -8,890 +9,880 @@ bus@0 {
 		aconnect@2900000 {
 			status = "okay";
 
-			dma-controller@2930000 {
-				status = "okay";
-			};
-
-			interrupt-controller@2a40000 {
-				status = "okay";
-			};
-
 			ahub@2900800 {
 				status = "okay";
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0x0>;
-
-						xbar_admaif0_ep: endpoint {
-							remote-endpoint = <&admaif0_ep>;
-						};
-					};
-
-					port@1 {
-						reg = <0x1>;
-
-						xbar_admaif1_ep: endpoint {
-							remote-endpoint = <&admaif1_ep>;
-						};
-					};
-
-					port@2 {
-						reg = <0x2>;
-
-						xbar_admaif2_ep: endpoint {
-							remote-endpoint = <&admaif2_ep>;
-						};
-					};
-
-					port@3 {
-						reg = <0x3>;
+				i2s@2901200 {
+					status = "okay";
 
-						xbar_admaif3_ep: endpoint {
-							remote-endpoint = <&admaif3_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@4 {
-						reg = <0x4>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif4_ep: endpoint {
-							remote-endpoint = <&admaif4_ep>;
+							i2s3_cif_ep: endpoint {
+								remote-endpoint = <&xbar_i2s3_ep>;
+							};
 						};
-					};
 
-					port@5 {
-						reg = <0x5>;
+						i2s3_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif5_ep: endpoint {
-							remote-endpoint = <&admaif5_ep>;
+							i2s3_dap_ep: endpoint {
+								dai-format = "i2s";
+								/* Place holder for external Codec */
+							};
 						};
 					};
+				};
 
-					port@6 {
-						reg = <0x6>;
+				i2s@2901400 {
+					status = "okay";
 
-						xbar_admaif6_ep: endpoint {
-							remote-endpoint = <&admaif6_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@7 {
-						reg = <0x7>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif7_ep: endpoint {
-							remote-endpoint = <&admaif7_ep>;
+							i2s5_cif_ep: endpoint {
+								remote-endpoint = <&xbar_i2s5_ep>;
+							};
 						};
-					};
 
-					port@8 {
-						reg = <0x8>;
+						i2s5_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif8_ep: endpoint {
-							remote-endpoint = <&admaif8_ep>;
+							i2s5_dap_ep: endpoint {
+								dai-format = "i2s";
+								/* Place holder for external Codec */
+							};
 						};
 					};
+				};
 
-					port@9 {
-						reg = <0x9>;
+				sfc@2902000 {
+					status = "okay";
 
-						xbar_admaif9_ep: endpoint {
-							remote-endpoint = <&admaif9_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@a {
-						reg = <0xa>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif10_ep: endpoint {
-							remote-endpoint = <&admaif10_ep>;
+							sfc1_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_sfc1_in_ep>;
+								convert-rate = <44100>;
+							};
 						};
-					};
 
-					port@b {
-						reg = <0xb>;
+						sfc1_out_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif11_ep: endpoint {
-							remote-endpoint = <&admaif11_ep>;
+							sfc1_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_sfc1_out_ep>;
+								convert-rate = <48000>;
+							};
 						};
 					};
+				};
 
-					port@c {
-						reg = <0xc>;
+				sfc@2902200 {
+					status = "okay";
 
-						xbar_admaif12_ep: endpoint {
-							remote-endpoint = <&admaif12_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@d {
-						reg = <0xd>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif13_ep: endpoint {
-							remote-endpoint = <&admaif13_ep>;
+							sfc2_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_sfc2_in_ep>;
+							};
 						};
-					};
 
-					port@e {
-						reg = <0xe>;
+						sfc2_out_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif14_ep: endpoint {
-							remote-endpoint = <&admaif14_ep>;
+							sfc2_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_sfc2_out_ep>;
+							};
 						};
 					};
+				};
 
-					port@f {
-						reg = <0xf>;
+				sfc@2902400 {
+					status = "okay";
 
-						xbar_admaif15_ep: endpoint {
-							remote-endpoint = <&admaif15_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@10 {
-						reg = <0x10>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif16_ep: endpoint {
-							remote-endpoint = <&admaif16_ep>;
+							sfc3_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_sfc3_in_ep>;
+							};
 						};
-					};
 
-					port@11 {
-						reg = <0x11>;
+						sfc3_out_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif17_ep: endpoint {
-							remote-endpoint = <&admaif17_ep>;
+							sfc3_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_sfc3_out_ep>;
+							};
 						};
 					};
+				};
 
-					port@12 {
-						reg = <0x12>;
+				sfc@2902600 {
+					status = "okay";
 
-						xbar_admaif18_ep: endpoint {
-							remote-endpoint = <&admaif18_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@13 {
-						reg = <0x13>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif19_ep: endpoint {
-							remote-endpoint = <&admaif19_ep>;
+							sfc4_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_sfc4_in_ep>;
+							};
 						};
-					};
 
-					xbar_i2s3_port: port@16 {
-						reg = <0x16>;
+						sfc4_out_port: port@1 {
+							reg = <1>;
 
-						xbar_i2s3_ep: endpoint {
-							remote-endpoint = <&i2s3_cif_ep>;
+							sfc4_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_sfc4_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_i2s5_port: port@18 {
-						reg = <0x18>;
+				amx@2903000 {
+					status = "okay";
 
-						xbar_i2s5_ep: endpoint {
-							remote-endpoint = <&i2s5_cif_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_dmic1_port: port@1a {
-						reg = <0x1a>;
+						port@0 {
+							reg = <0>;
 
-						xbar_dmic1_ep: endpoint {
-							remote-endpoint = <&dmic1_cif_ep>;
+							amx1_in1_ep: endpoint {
+								remote-endpoint = <&xbar_amx1_in1_ep>;
+							};
 						};
-					};
 
-					xbar_dmic2_port: port@1b {
-						reg = <0x1b>;
+						port@1 {
+							reg = <1>;
 
-						xbar_dmic2_ep: endpoint {
-							remote-endpoint = <&dmic2_cif_ep>;
+							amx1_in2_ep: endpoint {
+								remote-endpoint = <&xbar_amx1_in2_ep>;
+							};
 						};
-					};
 
-					xbar_dmic4_port: port@1d {
-						reg = <0x1d>;
+						port@2 {
+							reg = <2>;
 
-						xbar_dmic4_ep: endpoint {
-							remote-endpoint = <&dmic4_cif_ep>;
+							amx1_in3_ep: endpoint {
+								remote-endpoint = <&xbar_amx1_in3_ep>;
+							};
 						};
-					};
 
-					xbar_dspk1_port: port@1e {
-						reg = <0x1e>;
+						port@3 {
+							reg = <3>;
 
-						xbar_dspk1_ep: endpoint {
-							remote-endpoint = <&dspk1_cif_ep>;
+							amx1_in4_ep: endpoint {
+								remote-endpoint = <&xbar_amx1_in4_ep>;
+							};
 						};
-					};
 
-					xbar_dspk2_port: port@1f {
-						reg = <0x1f>;
+						amx1_out_port: port@4 {
+							reg = <4>;
 
-						xbar_dspk2_ep: endpoint {
-							remote-endpoint = <&dspk2_cif_ep>;
+							amx1_out_ep: endpoint {
+								remote-endpoint = <&xbar_amx1_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_sfc1_in_port: port@20 {
-						reg = <0x20>;
+				amx@2903100 {
+					status = "okay";
 
-						xbar_sfc1_in_ep: endpoint {
-							remote-endpoint = <&sfc1_cif_in_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@21 {
-						reg = <0x21>;
+						port@0 {
+							reg = <0>;
 
-						xbar_sfc1_out_ep: endpoint {
-							remote-endpoint = <&sfc1_cif_out_ep>;
+							amx2_in1_ep: endpoint {
+								remote-endpoint = <&xbar_amx2_in1_ep>;
+							};
 						};
-					};
 
-					xbar_sfc2_in_port: port@22 {
-						reg = <0x22>;
+						port@1 {
+							reg = <1>;
 
-						xbar_sfc2_in_ep: endpoint {
-							remote-endpoint = <&sfc2_cif_in_ep>;
+							amx2_in2_ep: endpoint {
+								remote-endpoint = <&xbar_amx2_in2_ep>;
+							};
 						};
-					};
 
-					port@23 {
-						reg = <0x23>;
+						amx2_in3_port: port@2 {
+							reg = <2>;
 
-						xbar_sfc2_out_ep: endpoint {
-							remote-endpoint = <&sfc2_cif_out_ep>;
+							amx2_in3_ep: endpoint {
+								remote-endpoint = <&xbar_amx2_in3_ep>;
+							};
 						};
-					};
 
-					xbar_sfc3_in_port: port@24 {
-						reg = <0x24>;
+						amx2_in4_port: port@3 {
+							reg = <3>;
 
-						xbar_sfc3_in_ep: endpoint {
-							remote-endpoint = <&sfc3_cif_in_ep>;
+							amx2_in4_ep: endpoint {
+								remote-endpoint = <&xbar_amx2_in4_ep>;
+							};
 						};
-					};
 
-					port@25 {
-						reg = <0x25>;
+						amx2_out_port: port@4 {
+							reg = <4>;
 
-						xbar_sfc3_out_ep: endpoint {
-							remote-endpoint = <&sfc3_cif_out_ep>;
+							amx2_out_ep: endpoint {
+								remote-endpoint = <&xbar_amx2_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_sfc4_in_port: port@26 {
-						reg = <0x26>;
+				amx@2903200 {
+					status = "okay";
 
-						xbar_sfc4_in_ep: endpoint {
-							remote-endpoint = <&sfc4_cif_in_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@27 {
-						reg = <0x27>;
+						port@0 {
+							reg = <0>;
 
-						xbar_sfc4_out_ep: endpoint {
-							remote-endpoint = <&sfc4_cif_out_ep>;
+							amx3_in1_ep: endpoint {
+								remote-endpoint = <&xbar_amx3_in1_ep>;
+							};
 						};
-					};
 
-					xbar_mvc1_in_port: port@28 {
-						reg = <0x28>;
+						port@1 {
+							reg = <1>;
 
-						xbar_mvc1_in_ep: endpoint {
-							remote-endpoint = <&mvc1_cif_in_ep>;
+							amx3_in2_ep: endpoint {
+								remote-endpoint = <&xbar_amx3_in2_ep>;
+							};
 						};
-					};
-
-					port@29 {
-						reg = <0x29>;
 
-						xbar_mvc1_out_ep: endpoint {
-							remote-endpoint = <&mvc1_cif_out_ep>;
+						port@2 {
+							reg = <2>;
+
+							amx3_in3_ep: endpoint {
+								remote-endpoint = <&xbar_amx3_in3_ep>;
+							};
 						};
-					};
 
-					xbar_mvc2_in_port: port@2a {
-						reg = <0x2a>;
+						port@3 {
+							reg = <3>;
 
-						xbar_mvc2_in_ep: endpoint {
-							remote-endpoint = <&mvc2_cif_in_ep>;
+							amx3_in4_ep: endpoint {
+								remote-endpoint = <&xbar_amx3_in4_ep>;
+							};
 						};
-					};
 
-					port@2b {
-						reg = <0x2b>;
+						amx3_out_port: port@4 {
+							reg = <4>;
 
-						xbar_mvc2_out_ep: endpoint {
-							remote-endpoint = <&mvc2_cif_out_ep>;
+							amx3_out_ep: endpoint {
+								remote-endpoint = <&xbar_amx3_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_amx1_in1_port: port@2c {
-						reg = <0x2c>;
+				amx@2903300 {
+					status = "okay";
 
-						xbar_amx1_in1_ep: endpoint {
-							remote-endpoint = <&amx1_in1_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_amx1_in2_port: port@2d {
-						reg = <0x2d>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx1_in2_ep: endpoint {
-							remote-endpoint = <&amx1_in2_ep>;
+							amx4_in1_ep: endpoint {
+								remote-endpoint = <&xbar_amx4_in1_ep>;
+							};
 						};
-					};
 
-					xbar_amx1_in3_port: port@2e {
-						reg = <0x2e>;
+						port@1 {
+							reg = <1>;
 
-						xbar_amx1_in3_ep: endpoint {
-							remote-endpoint = <&amx1_in3_ep>;
+							amx4_in2_ep: endpoint {
+								remote-endpoint = <&xbar_amx4_in2_ep>;
+							};
 						};
-					};
 
-					xbar_amx1_in4_port: port@2f {
-						reg = <0x2f>;
+						port@2 {
+							reg = <2>;
 
-						xbar_amx1_in4_ep: endpoint {
-							remote-endpoint = <&amx1_in4_ep>;
+							amx4_in3_ep: endpoint {
+								remote-endpoint = <&xbar_amx4_in3_ep>;
+							};
 						};
-					};
 
-					port@30 {
-						reg = <0x30>;
+						port@3 {
+							reg = <3>;
 
-						xbar_amx1_out_ep: endpoint {
-							remote-endpoint = <&amx1_out_ep>;
+							amx4_in4_ep: endpoint {
+								remote-endpoint = <&xbar_amx4_in4_ep>;
+							};
 						};
-					};
 
-					xbar_amx2_in1_port: port@31 {
-						reg = <0x31>;
+						amx4_out_port: port@4 {
+							reg = <4>;
 
-						xbar_amx2_in1_ep: endpoint {
-							remote-endpoint = <&amx2_in1_ep>;
+							amx4_out_ep: endpoint {
+								remote-endpoint = <&xbar_amx4_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_amx2_in2_port: port@32 {
-						reg = <0x32>;
+				adx@2903800 {
+					status = "okay";
 
-						xbar_amx2_in2_ep: endpoint {
-							remote-endpoint = <&amx2_in2_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_amx2_in3_port: port@33 {
-						reg = <0x33>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx2_in3_ep: endpoint {
-							remote-endpoint = <&amx2_in3_ep>;
+							adx1_in_ep: endpoint {
+								remote-endpoint = <&xbar_adx1_in_ep>;
+							};
 						};
-					};
 
-					xbar_amx2_in4_port: port@34 {
-						reg = <0x34>;
+						adx1_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_amx2_in4_ep: endpoint {
-							remote-endpoint = <&amx2_in4_ep>;
+							adx1_out1_ep: endpoint {
+								remote-endpoint = <&xbar_adx1_out1_ep>;
+							};
 						};
-					};
 
-					port@35 {
-						reg = <0x35>;
+						adx1_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_amx2_out_ep: endpoint {
-							remote-endpoint = <&amx2_out_ep>;
+							adx1_out2_ep: endpoint {
+								remote-endpoint = <&xbar_adx1_out2_ep>;
+							};
 						};
-					};
 
-					xbar_amx3_in1_port: port@36 {
-						reg = <0x36>;
+						adx1_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_amx3_in1_ep: endpoint {
-							remote-endpoint = <&amx3_in1_ep>;
+							adx1_out3_ep: endpoint {
+								remote-endpoint = <&xbar_adx1_out3_ep>;
+							};
 						};
-					};
 
-					xbar_amx3_in2_port: port@37 {
-						reg = <0x37>;
+						adx1_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_amx3_in2_ep: endpoint {
-							remote-endpoint = <&amx3_in2_ep>;
+							adx1_out4_ep: endpoint {
+								remote-endpoint = <&xbar_adx1_out4_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_amx3_in3_port: port@38 {
-						reg = <0x38>;
+				adx@2903900 {
+					status = "okay";
 
-						xbar_amx3_in3_ep: endpoint {
-							remote-endpoint = <&amx3_in3_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_amx3_in4_port: port@39 {
-						reg = <0x39>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx3_in4_ep: endpoint {
-							remote-endpoint = <&amx3_in4_ep>;
+							adx2_in_ep: endpoint {
+								remote-endpoint = <&xbar_adx2_in_ep>;
+							};
 						};
-					};
 
-					port@3a {
-						reg = <0x3a>;
+						adx2_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_amx3_out_ep: endpoint {
-							remote-endpoint = <&amx3_out_ep>;
+							adx2_out1_ep: endpoint {
+								remote-endpoint = <&xbar_adx2_out1_ep>;
+							};
 						};
-					};
 
-					xbar_amx4_in1_port: port@3b {
-						reg = <0x3b>;
+						adx2_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_amx4_in1_ep: endpoint {
-							remote-endpoint = <&amx4_in1_ep>;
+							adx2_out2_ep: endpoint {
+								remote-endpoint = <&xbar_adx2_out2_ep>;
+							};
 						};
-					};
 
-					xbar_amx4_in2_port: port@3c {
-						reg = <0x3c>;
+						adx2_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_amx4_in2_ep: endpoint {
-							remote-endpoint = <&amx4_in2_ep>;
+							adx2_out3_ep: endpoint {
+								remote-endpoint = <&xbar_adx2_out3_ep>;
+							};
 						};
-					};
 
-					xbar_amx4_in3_port: port@3d {
-						reg = <0x3d>;
+						adx2_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_amx4_in3_ep: endpoint {
-							remote-endpoint = <&amx4_in3_ep>;
+							adx2_out4_ep: endpoint {
+								remote-endpoint = <&xbar_adx2_out4_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_amx4_in4_port: port@3e {
-						reg = <0x3e>;
+				adx@2903a00 {
+					status = "okay";
 
-						xbar_amx4_in4_ep: endpoint {
-							remote-endpoint = <&amx4_in4_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@3f {
-						reg = <0x3f>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx4_out_ep: endpoint {
-							remote-endpoint = <&amx4_out_ep>;
+							adx3_in_ep: endpoint {
+								remote-endpoint = <&xbar_adx3_in_ep>;
+							};
 						};
-					};
 
-					xbar_adx1_in_port: port@40 {
-						reg = <0x40>;
+						adx3_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_adx1_in_ep: endpoint {
-							remote-endpoint = <&adx1_in_ep>;
+							adx3_out1_ep: endpoint {
+								remote-endpoint = <&xbar_adx3_out1_ep>;
+							};
 						};
-					};
 
-					port@41 {
-						reg = <0x41>;
+						adx3_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_adx1_out1_ep: endpoint {
-							remote-endpoint = <&adx1_out1_ep>;
+							adx3_out2_ep: endpoint {
+								remote-endpoint = <&xbar_adx3_out2_ep>;
+							};
 						};
-					};
 
-					port@42 {
-						reg = <0x42>;
+						adx3_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_adx1_out2_ep: endpoint {
-							remote-endpoint = <&adx1_out2_ep>;
+							adx3_out3_ep: endpoint {
+								remote-endpoint = <&xbar_adx3_out3_ep>;
+							};
 						};
-					};
 
-					port@43 {
-						reg = <0x43>;
+						adx3_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_adx1_out3_ep: endpoint {
-							remote-endpoint = <&adx1_out3_ep>;
+							adx3_out4_ep: endpoint {
+								remote-endpoint = <&xbar_adx3_out4_ep>;
+							};
 						};
 					};
+				};
 
-					port@44 {
-						reg = <0x44>;
+				adx@2903b00 {
+					status = "okay";
 
-						xbar_adx1_out4_ep: endpoint {
-							remote-endpoint = <&adx1_out4_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_adx2_in_port: port@45 {
-						reg = <0x45>;
+						port@0 {
+							reg = <0>;
 
-						xbar_adx2_in_ep: endpoint {
-							remote-endpoint = <&adx2_in_ep>;
+							adx4_in_ep: endpoint {
+								remote-endpoint = <&xbar_adx4_in_ep>;
+							};
 						};
-					};
 
-					port@46 {
-						reg = <0x46>;
+						adx4_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_adx2_out1_ep: endpoint {
-							remote-endpoint = <&adx2_out1_ep>;
+							adx4_out1_ep: endpoint {
+								remote-endpoint = <&xbar_adx4_out1_ep>;
+							};
 						};
-					};
 
-					port@47 {
-						reg = <0x47>;
+						adx4_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_adx2_out2_ep: endpoint {
-							remote-endpoint = <&adx2_out2_ep>;
+							adx4_out2_ep: endpoint {
+								remote-endpoint = <&xbar_adx4_out2_ep>;
+							};
 						};
-					};
 
-					port@48 {
-						reg = <0x48>;
+						adx4_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_adx2_out3_ep: endpoint {
-							remote-endpoint = <&adx2_out3_ep>;
+							adx4_out3_ep: endpoint {
+								remote-endpoint = <&xbar_adx4_out3_ep>;
+							};
 						};
-					};
 
-					port@49 {
-						reg = <0x49>;
+						adx4_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_adx2_out4_ep: endpoint {
-							remote-endpoint = <&adx2_out4_ep>;
+							adx4_out4_ep: endpoint {
+								remote-endpoint = <&xbar_adx4_out4_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_adx3_in_port: port@4a {
-						reg = <0x4a>;
+				dmic@2904000 {
+					status = "okay";
 
-						xbar_adx3_in_ep: endpoint {
-							remote-endpoint = <&adx3_in_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@4b {
-						reg = <0x4b>;
+						port@0 {
+							reg = <0>;
 
-						xbar_adx3_out1_ep: endpoint {
-							remote-endpoint = <&adx3_out1_ep>;
+							dmic1_cif_ep: endpoint {
+								remote-endpoint = <&xbar_dmic1_ep>;
+							};
 						};
-					};
 
-					port@4c {
-						reg = <0x4c>;
+						dmic1_port: port@1 {
+							reg = <1>;
 
-						xbar_adx3_out2_ep: endpoint {
-							remote-endpoint = <&adx3_out2_ep>;
+							dmic1_dap_ep: endpoint {
+								/* Place holder for external Codec */
+							};
 						};
 					};
+				};
 
-					port@4d {
-						reg = <0x4d>;
+				dmic@2904100 {
+					status = "okay";
 
-						xbar_adx3_out3_ep: endpoint {
-							remote-endpoint = <&adx3_out3_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@4e {
-						reg = <0x4e>;
+						port@0 {
+							reg = <0>;
 
-						xbar_adx3_out4_ep: endpoint {
-							remote-endpoint = <&adx3_out4_ep>;
+							dmic2_cif_ep: endpoint {
+								remote-endpoint = <&xbar_dmic2_ep>;
+							};
 						};
-					};
 
-					xbar_adx4_in_port: port@4f {
-						reg = <0x4f>;
+						dmic2_port: port@1 {
+							reg = <1>;
 
-						xbar_adx4_in_ep: endpoint {
-							remote-endpoint = <&adx4_in_ep>;
+							dmic2_dap_ep: endpoint {
+								/* Place holder for external Codec */
+							};
 						};
 					};
+				};
 
-					port@50 {
-						reg = <0x50>;
+				dmic@2904300 {
+					status = "okay";
 
-						xbar_adx4_out1_ep: endpoint {
-							remote-endpoint = <&adx4_out1_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@51 {
-						reg = <0x51>;
+						port@0 {
+							reg = <0>;
 
-						xbar_adx4_out2_ep: endpoint {
-							remote-endpoint = <&adx4_out2_ep>;
+							dmic4_cif_ep: endpoint {
+								remote-endpoint = <&xbar_dmic4_ep>;
+							};
 						};
-					};
 
-					port@52 {
-						reg = <0x52>;
+						dmic4_port: port@1 {
+							reg = <1>;
 
-						xbar_adx4_out3_ep: endpoint {
-							remote-endpoint = <&adx4_out3_ep>;
+							dmic4_dap_ep: endpoint {
+								/* Place holder for external Codec */
+							};
 						};
 					};
+				};
 
-					port@53 {
-						reg = <0x53>;
+				dspk@2905000 {
+					status = "okay";
 
-						xbar_adx4_out4_ep: endpoint {
-							remote-endpoint = <&adx4_out4_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_mixer_in1_port: port@54 {
-						reg = <0x54>;
+						port@0 {
+							reg = <0>;
 
-						xbar_mixer_in1_ep: endpoint {
-							remote-endpoint = <&mixer_in1_ep>;
+							dspk1_cif_ep: endpoint {
+								remote-endpoint = <&xbar_dspk1_ep>;
+							};
 						};
-					};
 
-					xbar_mixer_in2_port: port@55 {
-						reg = <0x55>;
+						dspk1_port: port@1 {
+							reg = <1>;
 
-						xbar_mixer_in2_ep: endpoint {
-							remote-endpoint = <&mixer_in2_ep>;
+							dspk1_dap_ep: endpoint {
+								/* Place holder for external Codec */
+							};
 						};
 					};
+				};
 
-					xbar_mixer_in3_port: port@56 {
-						reg = <0x56>;
+				dspk@2905100 {
+					status = "okay";
 
-						xbar_mixer_in3_ep: endpoint {
-							remote-endpoint = <&mixer_in3_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_mixer_in4_port: port@57 {
-						reg = <0x57>;
+						port@0 {
+							reg = <0>;
 
-						xbar_mixer_in4_ep: endpoint {
-							remote-endpoint = <&mixer_in4_ep>;
+							dspk2_cif_ep: endpoint {
+								remote-endpoint = <&xbar_dspk2_ep>;
+							};
 						};
-					};
 
-					xbar_mixer_in5_port: port@58 {
-						reg = <0x58>;
+						dspk2_port: port@1 {
+							reg = <1>;
 
-						xbar_mixer_in5_ep: endpoint {
-							remote-endpoint = <&mixer_in5_ep>;
+							dspk2_dap_ep: endpoint {
+								/* Place holder for external Codec */
+							};
 						};
 					};
+				};
 
-					xbar_mixer_in6_port: port@59 {
-						reg = <0x59>;
+				processing-engine@2908000 {
+					status = "okay";
 
-						xbar_mixer_in6_ep: endpoint {
-							remote-endpoint = <&mixer_in6_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_mixer_in7_port: port@5a {
-						reg = <0x5a>;
+						port@0 {
+							reg = <0x0>;
 
-						xbar_mixer_in7_ep: endpoint {
-							remote-endpoint = <&mixer_in7_ep>;
+							ope1_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_ope1_in_ep>;
+							};
 						};
-					};
 
-					xbar_mixer_in8_port: port@5b {
-						reg = <0x5b>;
+						ope1_out_port: port@1 {
+							reg = <0x1>;
 
-						xbar_mixer_in8_ep: endpoint {
-							remote-endpoint = <&mixer_in8_ep>;
+							ope1_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_ope1_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_mixer_in9_port: port@5c {
-						reg = <0x5c>;
+				mvc@290a000 {
+					status = "okay";
 
-						xbar_mixer_in9_ep: endpoint {
-							remote-endpoint = <&mixer_in9_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_mixer_in10_port: port@5d {
-						reg = <0x5d>;
+						port@0 {
+							reg = <0>;
 
-						xbar_mixer_in10_ep: endpoint {
-							remote-endpoint = <&mixer_in10_ep>;
+							mvc1_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_mvc1_in_ep>;
+							};
 						};
-					};
 
-					port@5e {
-						reg = <0x5e>;
+						mvc1_out_port: port@1 {
+							reg = <1>;
 
-						xbar_mixer_out1_ep: endpoint {
-							remote-endpoint = <&mixer_out1_ep>;
+							mvc1_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_mvc1_out_ep>;
+							};
 						};
 					};
+				};
 
-					port@5f {
-						reg = <0x5f>;
+				mvc@290a200 {
+					status = "okay";
 
-						xbar_mixer_out2_ep: endpoint {
-							remote-endpoint = <&mixer_out2_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@60 {
-						reg = <0x60>;
+						port@0 {
+							reg = <0>;
 
-						xbar_mixer_out3_ep: endpoint {
-							remote-endpoint = <&mixer_out3_ep>;
+							mvc2_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_mvc2_in_ep>;
+							};
 						};
-					};
 
-					port@61 {
-						reg = <0x61>;
+						mvc2_out_port: port@1 {
+							reg = <1>;
 
-						xbar_mixer_out4_ep: endpoint {
-							remote-endpoint = <&mixer_out4_ep>;
+							mvc2_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_mvc2_out_ep>;
+							};
 						};
 					};
+				};
 
-					port@62 {
-						reg = <0x62>;
+				amixer@290bb00 {
+					status = "okay";
 
-						xbar_mixer_out5_ep: endpoint {
-							remote-endpoint = <&mixer_out5_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_asrc_in1_port: port@63 {
-						reg = <0x63>;
+						port@0 {
+							reg = <0x0>;
 
-						xbar_asrc_in1_ep: endpoint {
-							remote-endpoint = <&asrc_in1_ep>;
+							mixer_in1_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in1_ep>;
+							};
 						};
-					};
 
-					port@64 {
-						reg = <0x64>;
+						port@1 {
+							reg = <0x1>;
 
-						xbar_asrc_out1_ep: endpoint {
-							remote-endpoint = <&asrc_out1_ep>;
+							mixer_in2_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in2_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in2_port: port@65 {
-						reg = <0x65>;
+						port@2 {
+							reg = <0x2>;
 
-						xbar_asrc_in2_ep: endpoint {
-							remote-endpoint = <&asrc_in2_ep>;
+							mixer_in3_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in3_ep>;
+							};
 						};
-					};
 
-					port@66 {
-						reg = <0x66>;
+						port@3 {
+							reg = <0x3>;
 
-						xbar_asrc_out2_ep: endpoint {
-							remote-endpoint = <&asrc_out2_ep>;
+							mixer_in4_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in4_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in3_port: port@67 {
-						reg = <0x67>;
+						port@4 {
+							reg = <0x4>;
 
-						xbar_asrc_in3_ep: endpoint {
-							remote-endpoint = <&asrc_in3_ep>;
+							mixer_in5_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in5_ep>;
+							};
 						};
-					};
 
-					port@68 {
-						reg = <0x68>;
+						port@5 {
+							reg = <0x5>;
 
-						xbar_asrc_out3_ep: endpoint {
-							remote-endpoint = <&asrc_out3_ep>;
+							mixer_in6_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in6_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in4_port: port@69 {
-						reg = <0x69>;
+						port@6 {
+							reg = <0x6>;
 
-						xbar_asrc_in4_ep: endpoint {
-							remote-endpoint = <&asrc_in4_ep>;
+							mixer_in7_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in7_ep>;
+							};
 						};
-					};
 
-					port@6a {
-						reg = <0x6a>;
+						port@7 {
+							reg = <0x7>;
 
-						xbar_asrc_out4_ep: endpoint {
-							remote-endpoint = <&asrc_out4_ep>;
+							mixer_in8_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in8_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in5_port: port@6b {
-						reg = <0x6b>;
+						port@8 {
+							reg = <0x8>;
 
-						xbar_asrc_in5_ep: endpoint {
-							remote-endpoint = <&asrc_in5_ep>;
+							mixer_in9_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in9_ep>;
+							};
 						};
-					};
 
-					port@6c {
-						reg = <0x6c>;
+						port@9 {
+							reg = <0x9>;
 
-						xbar_asrc_out5_ep: endpoint {
-							remote-endpoint = <&asrc_out5_ep>;
+							mixer_in10_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_in10_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in6_port: port@6d {
-						reg = <0x6d>;
+						mixer_out1_port: port@a {
+							reg = <0xa>;
 
-						xbar_asrc_in6_ep: endpoint {
-							remote-endpoint = <&asrc_in6_ep>;
+							mixer_out1_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_out1_ep>;
+							};
 						};
-					};
 
-					port@6e {
-						reg = <0x6e>;
+						mixer_out2_port: port@b {
+							reg = <0xb>;
 
-						xbar_asrc_out6_ep: endpoint {
-							remote-endpoint = <&asrc_out6_ep>;
+							mixer_out2_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_out2_ep>;
+							};
 						};
-					};
 
-					xbar_asrc_in7_port: port@6f {
-						reg = <0x6f>;
+						mixer_out3_port: port@c {
+							reg = <0xc>;
 
-						xbar_asrc_in7_ep: endpoint {
-							remote-endpoint = <&asrc_in7_ep>;
+							mixer_out3_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_out3_ep>;
+							};
 						};
-					};
 
-					xbar_ope1_in_port: port@70 {
-						reg = <0x70>;
+						mixer_out4_port: port@d {
+							reg = <0xd>;
 
-						xbar_ope1_in_ep: endpoint {
-							remote-endpoint = <&ope1_cif_in_ep>;
+							mixer_out4_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_out4_ep>;
+							};
 						};
-					};
 
-					port@71 {
-						reg = <0x71>;
+						mixer_out5_port: port@e {
+							reg = <0xe>;
 
-						xbar_ope1_out_ep: endpoint {
-							remote-endpoint = <&ope1_cif_out_ep>;
+							mixer_out5_ep: endpoint {
+								remote-endpoint = <&xbar_mixer_out5_ep>;
+							};
 						};
 					};
 				};
@@ -1065,7 +1056,7 @@ admaif19_ep: endpoint {
 					};
 				};
 
-				i2s@2901200 {
+				asrc@2910000 {
 					status = "okay";
 
 					ports {
@@ -1073,990 +1064,996 @@ ports {
 						#size-cells = <0>;
 
 						port@0 {
-							reg = <0>;
+							reg = <0x0>;
 
-							i2s3_cif_ep: endpoint {
-								remote-endpoint = <&xbar_i2s3_ep>;
+							asrc_in1_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in1_ep>;
 							};
 						};
 
-						i2s3_port: port@1 {
-							reg = <1>;
+						port@1 {
+							reg = <0x1>;
 
-							i2s3_dap_ep: endpoint {
-								dai-format = "i2s";
-								/* Place holder for external Codec */
+							asrc_in2_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in2_ep>;
+							};
+						};
+
+						port@2 {
+							reg = <0x2>;
+
+							asrc_in3_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in3_ep>;
+							};
+						};
+
+						port@3 {
+							reg = <0x3>;
+
+							asrc_in4_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in4_ep>;
 							};
 						};
-					};
-				};
 
-				i2s@2901400 {
-					status = "okay";
+						port@4 {
+							reg = <0x4>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							asrc_in5_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in5_ep>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						port@5 {
+							reg = <0x5>;
 
-							i2s5_cif_ep: endpoint {
-								remote-endpoint = <&xbar_i2s5_ep>;
+							asrc_in6_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in6_ep>;
 							};
 						};
 
-						i2s5_port: port@1 {
-							reg = <1>;
+						port@6 {
+							reg = <0x6>;
 
-							i2s5_dap_ep: endpoint {
-								dai-format = "i2s";
-								/* Place holder for external Codec */
+							asrc_in7_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in7_ep>;
 							};
 						};
-					};
-				};
 
-				dmic@2904000 {
-					status = "okay";
+						asrc_out1_port: port@7 {
+							reg = <0x7>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							asrc_out1_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out1_ep>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						asrc_out2_port: port@8 {
+							reg = <0x8>;
 
-							dmic1_cif_ep: endpoint {
-								remote-endpoint = <&xbar_dmic1_ep>;
+							asrc_out2_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out2_ep>;
 							};
 						};
 
-						dmic1_port: port@1 {
-							reg = <1>;
+						asrc_out3_port: port@9 {
+							reg = <0x9>;
 
-							dmic1_dap_ep: endpoint {
-								/* Place holder for external Codec */
+							asrc_out3_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out3_ep>;
 							};
 						};
-					};
-				};
 
-				dmic@2904100 {
-					status = "okay";
+						asrc_out4_port: port@a {
+							reg = <0xa>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							asrc_out4_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out4_ep>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						asrc_out5_port: port@b {
+							reg = <0xb>;
 
-							dmic2_cif_ep: endpoint {
-								remote-endpoint = <&xbar_dmic2_ep>;
+							asrc_out5_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out5_ep>;
 							};
 						};
 
-						dmic2_port: port@1 {
-							reg = <1>;
+						asrc_out6_port:	port@c {
+							reg = <0xc>;
 
-							dmic2_dap_ep: endpoint {
-								/* Place holder for external Codec */
+							asrc_out6_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out6_ep>;
 							};
 						};
 					};
 				};
 
-				dmic@2904300 {
-					status = "okay";
-
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-						port@0 {
-							reg = <0>;
+					port@0 {
+						reg = <0x0>;
 
-							dmic4_cif_ep: endpoint {
-								remote-endpoint = <&xbar_dmic4_ep>;
-							};
+						xbar_admaif0_ep: endpoint {
+							remote-endpoint = <&admaif0_ep>;
 						};
+					};
 
-						dmic4_port: port@1 {
-							reg = <1>;
+					port@1 {
+						reg = <0x1>;
 
-							dmic4_dap_ep: endpoint {
-								/* Place holder for external Codec */
-							};
+						xbar_admaif1_ep: endpoint {
+							remote-endpoint = <&admaif1_ep>;
 						};
 					};
-				};
 
-				dspk@2905000 {
-					status = "okay";
+					port@2 {
+						reg = <0x2>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif2_ep: endpoint {
+							remote-endpoint = <&admaif2_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@3 {
+						reg = <0x3>;
 
-							dspk1_cif_ep: endpoint {
-								remote-endpoint = <&xbar_dspk1_ep>;
-							};
+						xbar_admaif3_ep: endpoint {
+							remote-endpoint = <&admaif3_ep>;
 						};
+					};
 
-						dspk1_port: port@1 {
-							reg = <1>;
+					port@4 {
+						reg = <0x4>;
 
-							dspk1_dap_ep: endpoint {
-								/* Place holder for external Codec */
-							};
+						xbar_admaif4_ep: endpoint {
+							remote-endpoint = <&admaif4_ep>;
 						};
 					};
-				};
 
-				dspk@2905100 {
-					status = "okay";
+					port@5 {
+						reg = <0x5>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif5_ep: endpoint {
+							remote-endpoint = <&admaif5_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@6 {
+						reg = <0x6>;
 
-							dspk2_cif_ep: endpoint {
-								remote-endpoint = <&xbar_dspk2_ep>;
-							};
+						xbar_admaif6_ep: endpoint {
+							remote-endpoint = <&admaif6_ep>;
 						};
+					};
 
-						dspk2_port: port@1 {
-							reg = <1>;
+					port@7 {
+						reg = <0x7>;
 
-							dspk2_dap_ep: endpoint {
-								/* Place holder for external Codec */
-							};
+						xbar_admaif7_ep: endpoint {
+							remote-endpoint = <&admaif7_ep>;
 						};
 					};
-				};
 
-				sfc@2902000 {
-					status = "okay";
+					port@8 {
+						reg = <0x8>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif8_ep: endpoint {
+							remote-endpoint = <&admaif8_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@9 {
+						reg = <0x9>;
 
-							sfc1_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_sfc1_in_ep>;
-								convert-rate = <44100>;
-							};
+						xbar_admaif9_ep: endpoint {
+							remote-endpoint = <&admaif9_ep>;
 						};
+					};
 
-						sfc1_out_port: port@1 {
-							reg = <1>;
+					port@a {
+						reg = <0xa>;
 
-							sfc1_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_sfc1_out_ep>;
-								convert-rate = <48000>;
-							};
+						xbar_admaif10_ep: endpoint {
+							remote-endpoint = <&admaif10_ep>;
 						};
 					};
-				};
 
-				sfc@2902200 {
-					status = "okay";
+					port@b {
+						reg = <0xb>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif11_ep: endpoint {
+							remote-endpoint = <&admaif11_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@c {
+						reg = <0xc>;
 
-							sfc2_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_sfc2_in_ep>;
-							};
+						xbar_admaif12_ep: endpoint {
+							remote-endpoint = <&admaif12_ep>;
 						};
+					};
 
-						sfc2_out_port: port@1 {
-							reg = <1>;
+					port@d {
+						reg = <0xd>;
 
-							sfc2_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_sfc2_out_ep>;
-							};
+						xbar_admaif13_ep: endpoint {
+							remote-endpoint = <&admaif13_ep>;
 						};
 					};
-				};
 
-				sfc@2902400 {
-					status = "okay";
+					port@e {
+						reg = <0xe>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif14_ep: endpoint {
+							remote-endpoint = <&admaif14_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@f {
+						reg = <0xf>;
 
-							sfc3_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_sfc3_in_ep>;
-							};
+						xbar_admaif15_ep: endpoint {
+							remote-endpoint = <&admaif15_ep>;
 						};
+					};
 
-						sfc3_out_port: port@1 {
-							reg = <1>;
+					port@10 {
+						reg = <0x10>;
 
-							sfc3_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_sfc3_out_ep>;
-							};
+						xbar_admaif16_ep: endpoint {
+							remote-endpoint = <&admaif16_ep>;
 						};
 					};
-				};
 
-				sfc@2902600 {
-					status = "okay";
+					port@11 {
+						reg = <0x11>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif17_ep: endpoint {
+							remote-endpoint = <&admaif17_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@12 {
+						reg = <0x12>;
 
-							sfc4_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_sfc4_in_ep>;
-							};
+						xbar_admaif18_ep: endpoint {
+							remote-endpoint = <&admaif18_ep>;
 						};
+					};
 
-						sfc4_out_port: port@1 {
-							reg = <1>;
+					port@13 {
+						reg = <0x13>;
 
-							sfc4_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_sfc4_out_ep>;
-							};
+						xbar_admaif19_ep: endpoint {
+							remote-endpoint = <&admaif19_ep>;
 						};
 					};
-				};
 
-				mvc@290a000 {
-					status = "okay";
+					xbar_i2s3_port: port@16 {
+						reg = <0x16>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_i2s3_ep: endpoint {
+							remote-endpoint = <&i2s3_cif_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_i2s5_port: port@18 {
+						reg = <0x18>;
 
-							mvc1_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_mvc1_in_ep>;
-							};
+						xbar_i2s5_ep: endpoint {
+							remote-endpoint = <&i2s5_cif_ep>;
 						};
+					};
 
-						mvc1_out_port: port@1 {
-							reg = <1>;
+					xbar_dmic1_port: port@1a {
+						reg = <0x1a>;
 
-							mvc1_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_mvc1_out_ep>;
-							};
+						xbar_dmic1_ep: endpoint {
+							remote-endpoint = <&dmic1_cif_ep>;
 						};
 					};
-				};
 
-				mvc@290a200 {
-					status = "okay";
+					xbar_dmic2_port: port@1b {
+						reg = <0x1b>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_dmic2_ep: endpoint {
+							remote-endpoint = <&dmic2_cif_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_dmic4_port: port@1d {
+						reg = <0x1d>;
 
-							mvc2_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_mvc2_in_ep>;
-							};
+						xbar_dmic4_ep: endpoint {
+							remote-endpoint = <&dmic4_cif_ep>;
 						};
+					};
 
-						mvc2_out_port: port@1 {
-							reg = <1>;
+					xbar_dspk1_port: port@1e {
+						reg = <0x1e>;
 
-							mvc2_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_mvc2_out_ep>;
-							};
+						xbar_dspk1_ep: endpoint {
+							remote-endpoint = <&dspk1_cif_ep>;
 						};
 					};
-				};
 
-				amx@2903000 {
-					status = "okay";
+					xbar_dspk2_port: port@1f {
+						reg = <0x1f>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_dspk2_ep: endpoint {
+							remote-endpoint = <&dspk2_cif_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_sfc1_in_port: port@20 {
+						reg = <0x20>;
 
-							amx1_in1_ep: endpoint {
-								remote-endpoint = <&xbar_amx1_in1_ep>;
-							};
+						xbar_sfc1_in_ep: endpoint {
+							remote-endpoint = <&sfc1_cif_in_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <1>;
+					port@21 {
+						reg = <0x21>;
 
-							amx1_in2_ep: endpoint {
-								remote-endpoint = <&xbar_amx1_in2_ep>;
-							};
+						xbar_sfc1_out_ep: endpoint {
+							remote-endpoint = <&sfc1_cif_out_ep>;
 						};
+					};
 
-						port@2 {
-							reg = <2>;
+					xbar_sfc2_in_port: port@22 {
+						reg = <0x22>;
 
-							amx1_in3_ep: endpoint {
-								remote-endpoint = <&xbar_amx1_in3_ep>;
-							};
+						xbar_sfc2_in_ep: endpoint {
+							remote-endpoint = <&sfc2_cif_in_ep>;
 						};
+					};
 
-						port@3 {
-							reg = <3>;
+					port@23 {
+						reg = <0x23>;
 
-							amx1_in4_ep: endpoint {
-								remote-endpoint = <&xbar_amx1_in4_ep>;
-							};
+						xbar_sfc2_out_ep: endpoint {
+							remote-endpoint = <&sfc2_cif_out_ep>;
 						};
+					};
 
-						amx1_out_port: port@4 {
-							reg = <4>;
+					xbar_sfc3_in_port: port@24 {
+						reg = <0x24>;
 
-							amx1_out_ep: endpoint {
-								remote-endpoint = <&xbar_amx1_out_ep>;
-							};
+						xbar_sfc3_in_ep: endpoint {
+							remote-endpoint = <&sfc3_cif_in_ep>;
 						};
 					};
-				};
 
-				amx@2903100 {
-					status = "okay";
+					port@25 {
+						reg = <0x25>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_sfc3_out_ep: endpoint {
+							remote-endpoint = <&sfc3_cif_out_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_sfc4_in_port: port@26 {
+						reg = <0x26>;
 
-							amx2_in1_ep: endpoint {
-								remote-endpoint = <&xbar_amx2_in1_ep>;
-							};
+						xbar_sfc4_in_ep: endpoint {
+							remote-endpoint = <&sfc4_cif_in_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <1>;
+					port@27 {
+						reg = <0x27>;
 
-							amx2_in2_ep: endpoint {
-								remote-endpoint = <&xbar_amx2_in2_ep>;
-							};
+						xbar_sfc4_out_ep: endpoint {
+							remote-endpoint = <&sfc4_cif_out_ep>;
 						};
+					};
 
-						amx2_in3_port: port@2 {
-							reg = <2>;
+					xbar_mvc1_in_port: port@28 {
+						reg = <0x28>;
 
-							amx2_in3_ep: endpoint {
-								remote-endpoint = <&xbar_amx2_in3_ep>;
-							};
+						xbar_mvc1_in_ep: endpoint {
+							remote-endpoint = <&mvc1_cif_in_ep>;
 						};
+					};
 
-						amx2_in4_port: port@3 {
-							reg = <3>;
+					port@29 {
+						reg = <0x29>;
 
-							amx2_in4_ep: endpoint {
-								remote-endpoint = <&xbar_amx2_in4_ep>;
-							};
+						xbar_mvc1_out_ep: endpoint {
+							remote-endpoint = <&mvc1_cif_out_ep>;
 						};
+					};
 
-						amx2_out_port: port@4 {
-							reg = <4>;
+					xbar_mvc2_in_port: port@2a {
+						reg = <0x2a>;
 
-							amx2_out_ep: endpoint {
-								remote-endpoint = <&xbar_amx2_out_ep>;
-							};
+						xbar_mvc2_in_ep: endpoint {
+							remote-endpoint = <&mvc2_cif_in_ep>;
 						};
 					};
-				};
 
-				amx@2903200 {
-					status = "okay";
+					port@2b {
+						reg = <0x2b>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_mvc2_out_ep: endpoint {
+							remote-endpoint = <&mvc2_cif_out_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_amx1_in1_port: port@2c {
+						reg = <0x2c>;
+
+						xbar_amx1_in1_ep: endpoint {
+							remote-endpoint = <&amx1_in1_ep>;
+						};
+					};
 
-							amx3_in1_ep: endpoint {
-								remote-endpoint = <&xbar_amx3_in1_ep>;
-							};
+					xbar_amx1_in2_port: port@2d {
+						reg = <0x2d>;
+
+						xbar_amx1_in2_ep: endpoint {
+							remote-endpoint = <&amx1_in2_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <1>;
+					xbar_amx1_in3_port: port@2e {
+						reg = <0x2e>;
 
-							amx3_in2_ep: endpoint {
-								remote-endpoint = <&xbar_amx3_in2_ep>;
-							};
+						xbar_amx1_in3_ep: endpoint {
+							remote-endpoint = <&amx1_in3_ep>;
 						};
+					};
 
-						port@2 {
-							reg = <2>;
+					xbar_amx1_in4_port: port@2f {
+						reg = <0x2f>;
 
-							amx3_in3_ep: endpoint {
-								remote-endpoint = <&xbar_amx3_in3_ep>;
-							};
+						xbar_amx1_in4_ep: endpoint {
+							remote-endpoint = <&amx1_in4_ep>;
 						};
+					};
 
-						port@3 {
-							reg = <3>;
+					port@30 {
+						reg = <0x30>;
 
-							amx3_in4_ep: endpoint {
-								remote-endpoint = <&xbar_amx3_in4_ep>;
-							};
+						xbar_amx1_out_ep: endpoint {
+							remote-endpoint = <&amx1_out_ep>;
 						};
+					};
 
-						amx3_out_port: port@4 {
-							reg = <4>;
+					xbar_amx2_in1_port: port@31 {
+						reg = <0x31>;
 
-							amx3_out_ep: endpoint {
-								remote-endpoint = <&xbar_amx3_out_ep>;
-							};
+						xbar_amx2_in1_ep: endpoint {
+							remote-endpoint = <&amx2_in1_ep>;
 						};
 					};
-				};
 
-				amx@2903300 {
-					status = "okay";
+					xbar_amx2_in2_port: port@32 {
+						reg = <0x32>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx2_in2_ep: endpoint {
+							remote-endpoint = <&amx2_in2_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_amx2_in3_port: port@33 {
+						reg = <0x33>;
 
-							amx4_in1_ep: endpoint {
-								remote-endpoint = <&xbar_amx4_in1_ep>;
-							};
+						xbar_amx2_in3_ep: endpoint {
+							remote-endpoint = <&amx2_in3_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <1>;
+					xbar_amx2_in4_port: port@34 {
+						reg = <0x34>;
 
-							amx4_in2_ep: endpoint {
-								remote-endpoint = <&xbar_amx4_in2_ep>;
-							};
+						xbar_amx2_in4_ep: endpoint {
+							remote-endpoint = <&amx2_in4_ep>;
 						};
+					};
 
-						port@2 {
-							reg = <2>;
+					port@35 {
+						reg = <0x35>;
 
-							amx4_in3_ep: endpoint {
-								remote-endpoint = <&xbar_amx4_in3_ep>;
-							};
+						xbar_amx2_out_ep: endpoint {
+							remote-endpoint = <&amx2_out_ep>;
 						};
+					};
 
-						port@3 {
-							reg = <3>;
+					xbar_amx3_in1_port: port@36 {
+						reg = <0x36>;
 
-							amx4_in4_ep: endpoint {
-								remote-endpoint = <&xbar_amx4_in4_ep>;
-							};
+						xbar_amx3_in1_ep: endpoint {
+							remote-endpoint = <&amx3_in1_ep>;
 						};
+					};
 
-						amx4_out_port: port@4 {
-							reg = <4>;
+					xbar_amx3_in2_port: port@37 {
+						reg = <0x37>;
 
-							amx4_out_ep: endpoint {
-								remote-endpoint = <&xbar_amx4_out_ep>;
-							};
+						xbar_amx3_in2_ep: endpoint {
+							remote-endpoint = <&amx3_in2_ep>;
 						};
 					};
-				};
 
-				adx@2903800 {
-					status = "okay";
+					xbar_amx3_in3_port: port@38 {
+						reg = <0x38>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx3_in3_ep: endpoint {
+							remote-endpoint = <&amx3_in3_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_amx3_in4_port: port@39 {
+						reg = <0x39>;
 
-							adx1_in_ep: endpoint {
-								remote-endpoint = <&xbar_adx1_in_ep>;
-							};
+						xbar_amx3_in4_ep: endpoint {
+							remote-endpoint = <&amx3_in4_ep>;
 						};
+					};
 
-						adx1_out1_port: port@1 {
-							reg = <1>;
+					port@3a {
+						reg = <0x3a>;
 
-							adx1_out1_ep: endpoint {
-								remote-endpoint = <&xbar_adx1_out1_ep>;
-							};
+						xbar_amx3_out_ep: endpoint {
+							remote-endpoint = <&amx3_out_ep>;
 						};
+					};
 
-						adx1_out2_port: port@2 {
-							reg = <2>;
+					xbar_amx4_in1_port: port@3b {
+						reg = <0x3b>;
 
-							adx1_out2_ep: endpoint {
-								remote-endpoint = <&xbar_adx1_out2_ep>;
-							};
+						xbar_amx4_in1_ep: endpoint {
+							remote-endpoint = <&amx4_in1_ep>;
 						};
+					};
 
-						adx1_out3_port: port@3 {
-							reg = <3>;
+					xbar_amx4_in2_port: port@3c {
+						reg = <0x3c>;
 
-							adx1_out3_ep: endpoint {
-								remote-endpoint = <&xbar_adx1_out3_ep>;
-							};
+						xbar_amx4_in2_ep: endpoint {
+							remote-endpoint = <&amx4_in2_ep>;
 						};
+					};
 
-						adx1_out4_port: port@4 {
-							reg = <4>;
+					xbar_amx4_in3_port: port@3d {
+						reg = <0x3d>;
 
-							adx1_out4_ep: endpoint {
-								remote-endpoint = <&xbar_adx1_out4_ep>;
-							};
+						xbar_amx4_in3_ep: endpoint {
+							remote-endpoint = <&amx4_in3_ep>;
 						};
 					};
-				};
 
-				adx@2903900 {
-					status = "okay";
+					xbar_amx4_in4_port: port@3e {
+						reg = <0x3e>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx4_in4_ep: endpoint {
+							remote-endpoint = <&amx4_in4_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@3f {
+						reg = <0x3f>;
 
-							adx2_in_ep: endpoint {
-								remote-endpoint = <&xbar_adx2_in_ep>;
-							};
+						xbar_amx4_out_ep: endpoint {
+							remote-endpoint = <&amx4_out_ep>;
 						};
+					};
 
-						adx2_out1_port: port@1 {
-							reg = <1>;
+					xbar_adx1_in_port: port@40 {
+						reg = <0x40>;
 
-							adx2_out1_ep: endpoint {
-								remote-endpoint = <&xbar_adx2_out1_ep>;
-							};
+						xbar_adx1_in_ep: endpoint {
+							remote-endpoint = <&adx1_in_ep>;
 						};
+					};
 
-						adx2_out2_port: port@2 {
-							reg = <2>;
+					port@41 {
+						reg = <0x41>;
 
-							adx2_out2_ep: endpoint {
-								remote-endpoint = <&xbar_adx2_out2_ep>;
-							};
+						xbar_adx1_out1_ep: endpoint {
+							remote-endpoint = <&adx1_out1_ep>;
 						};
+					};
 
-						adx2_out3_port: port@3 {
-							reg = <3>;
+					port@42 {
+						reg = <0x42>;
 
-							adx2_out3_ep: endpoint {
-								remote-endpoint = <&xbar_adx2_out3_ep>;
-							};
+						xbar_adx1_out2_ep: endpoint {
+							remote-endpoint = <&adx1_out2_ep>;
 						};
+					};
 
-						adx2_out4_port: port@4 {
-							reg = <4>;
+					port@43 {
+						reg = <0x43>;
 
-							adx2_out4_ep: endpoint {
-								remote-endpoint = <&xbar_adx2_out4_ep>;
-							};
+						xbar_adx1_out3_ep: endpoint {
+							remote-endpoint = <&adx1_out3_ep>;
 						};
 					};
-				};
 
-				adx@2903a00 {
-					status = "okay";
+					port@44 {
+						reg = <0x44>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_adx1_out4_ep: endpoint {
+							remote-endpoint = <&adx1_out4_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_adx2_in_port: port@45 {
+						reg = <0x45>;
 
-							adx3_in_ep: endpoint {
-								remote-endpoint = <&xbar_adx3_in_ep>;
-							};
+						xbar_adx2_in_ep: endpoint {
+							remote-endpoint = <&adx2_in_ep>;
+						};
+					};
+
+					port@46 {
+						reg = <0x46>;
+
+						xbar_adx2_out1_ep: endpoint {
+							remote-endpoint = <&adx2_out1_ep>;
 						};
+					};
 
-						adx3_out1_port: port@1 {
-							reg = <1>;
+					port@47 {
+						reg = <0x47>;
 
-							adx3_out1_ep: endpoint {
-								remote-endpoint = <&xbar_adx3_out1_ep>;
-							};
+						xbar_adx2_out2_ep: endpoint {
+							remote-endpoint = <&adx2_out2_ep>;
 						};
+					};
 
-						adx3_out2_port: port@2 {
-							reg = <2>;
+					port@48 {
+						reg = <0x48>;
 
-							adx3_out2_ep: endpoint {
-								remote-endpoint = <&xbar_adx3_out2_ep>;
-							};
+						xbar_adx2_out3_ep: endpoint {
+							remote-endpoint = <&adx2_out3_ep>;
 						};
+					};
 
-						adx3_out3_port: port@3 {
-							reg = <3>;
+					port@49 {
+						reg = <0x49>;
 
-							adx3_out3_ep: endpoint {
-								remote-endpoint = <&xbar_adx3_out3_ep>;
-							};
+						xbar_adx2_out4_ep: endpoint {
+							remote-endpoint = <&adx2_out4_ep>;
 						};
+					};
 
-						adx3_out4_port: port@4 {
-							reg = <4>;
+					xbar_adx3_in_port: port@4a {
+						reg = <0x4a>;
 
-							adx3_out4_ep: endpoint {
-								remote-endpoint = <&xbar_adx3_out4_ep>;
-							};
+						xbar_adx3_in_ep: endpoint {
+							remote-endpoint = <&adx3_in_ep>;
 						};
 					};
-				};
 
-				adx@2903b00 {
-					status = "okay";
+					port@4b {
+						reg = <0x4b>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_adx3_out1_ep: endpoint {
+							remote-endpoint = <&adx3_out1_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@4c {
+						reg = <0x4c>;
 
-							adx4_in_ep: endpoint {
-								remote-endpoint = <&xbar_adx4_in_ep>;
-							};
+						xbar_adx3_out2_ep: endpoint {
+							remote-endpoint = <&adx3_out2_ep>;
 						};
+					};
 
-						adx4_out1_port: port@1 {
-							reg = <1>;
+					port@4d {
+						reg = <0x4d>;
 
-							adx4_out1_ep: endpoint {
-								remote-endpoint = <&xbar_adx4_out1_ep>;
-							};
+						xbar_adx3_out3_ep: endpoint {
+							remote-endpoint = <&adx3_out3_ep>;
 						};
+					};
 
-						adx4_out2_port: port@2 {
-							reg = <2>;
+					port@4e {
+						reg = <0x4e>;
 
-							adx4_out2_ep: endpoint {
-								remote-endpoint = <&xbar_adx4_out2_ep>;
-							};
+						xbar_adx3_out4_ep: endpoint {
+							remote-endpoint = <&adx3_out4_ep>;
 						};
+					};
 
-						adx4_out3_port: port@3 {
-							reg = <3>;
+					xbar_adx4_in_port: port@4f {
+						reg = <0x4f>;
 
-							adx4_out3_ep: endpoint {
-								remote-endpoint = <&xbar_adx4_out3_ep>;
-							};
+						xbar_adx4_in_ep: endpoint {
+							remote-endpoint = <&adx4_in_ep>;
 						};
+					};
 
-						adx4_out4_port: port@4 {
-							reg = <4>;
+					port@50 {
+						reg = <0x50>;
 
-							adx4_out4_ep: endpoint {
-								remote-endpoint = <&xbar_adx4_out4_ep>;
-							};
+						xbar_adx4_out1_ep: endpoint {
+							remote-endpoint = <&adx4_out1_ep>;
 						};
 					};
-				};
 
-				processing-engine@2908000 {
-					status = "okay";
+					port@51 {
+						reg = <0x51>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_adx4_out2_ep: endpoint {
+							remote-endpoint = <&adx4_out2_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0x0>;
+					port@52 {
+						reg = <0x52>;
 
-							ope1_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_ope1_in_ep>;
-							};
+						xbar_adx4_out3_ep: endpoint {
+							remote-endpoint = <&adx4_out3_ep>;
 						};
+					};
 
-						ope1_out_port: port@1 {
-							reg = <0x1>;
+					port@53 {
+						reg = <0x53>;
 
-							ope1_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_ope1_out_ep>;
-							};
+						xbar_adx4_out4_ep: endpoint {
+							remote-endpoint = <&adx4_out4_ep>;
 						};
 					};
-				};
 
-				amixer@290bb00 {
-					status = "okay";
+					xbar_mixer_in1_port: port@54 {
+						reg = <0x54>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_mixer_in1_ep: endpoint {
+							remote-endpoint = <&mixer_in1_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0x0>;
+					xbar_mixer_in2_port: port@55 {
+						reg = <0x55>;
 
-							mixer_in1_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in1_ep>;
-							};
+						xbar_mixer_in2_ep: endpoint {
+							remote-endpoint = <&mixer_in2_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <0x1>;
+					xbar_mixer_in3_port: port@56 {
+						reg = <0x56>;
 
-							mixer_in2_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in2_ep>;
-							};
+						xbar_mixer_in3_ep: endpoint {
+							remote-endpoint = <&mixer_in3_ep>;
 						};
+					};
 
-						port@2 {
-							reg = <0x2>;
+					xbar_mixer_in4_port: port@57 {
+						reg = <0x57>;
 
-							mixer_in3_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in3_ep>;
-							};
+						xbar_mixer_in4_ep: endpoint {
+							remote-endpoint = <&mixer_in4_ep>;
 						};
+					};
 
-						port@3 {
-							reg = <0x3>;
+					xbar_mixer_in5_port: port@58 {
+						reg = <0x58>;
 
-							mixer_in4_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in4_ep>;
-							};
+						xbar_mixer_in5_ep: endpoint {
+							remote-endpoint = <&mixer_in5_ep>;
 						};
+					};
 
-						port@4 {
-							reg = <0x4>;
+					xbar_mixer_in6_port: port@59 {
+						reg = <0x59>;
 
-							mixer_in5_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in5_ep>;
-							};
+						xbar_mixer_in6_ep: endpoint {
+							remote-endpoint = <&mixer_in6_ep>;
 						};
+					};
 
-						port@5 {
-							reg = <0x5>;
+					xbar_mixer_in7_port: port@5a {
+						reg = <0x5a>;
 
-							mixer_in6_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in6_ep>;
-							};
+						xbar_mixer_in7_ep: endpoint {
+							remote-endpoint = <&mixer_in7_ep>;
 						};
+					};
 
-						port@6 {
-							reg = <0x6>;
+					xbar_mixer_in8_port: port@5b {
+						reg = <0x5b>;
 
-							mixer_in7_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in7_ep>;
-							};
+						xbar_mixer_in8_ep: endpoint {
+							remote-endpoint = <&mixer_in8_ep>;
 						};
+					};
 
-						port@7 {
-							reg = <0x7>;
+					xbar_mixer_in9_port: port@5c {
+						reg = <0x5c>;
 
-							mixer_in8_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in8_ep>;
-							};
+						xbar_mixer_in9_ep: endpoint {
+							remote-endpoint = <&mixer_in9_ep>;
 						};
+					};
 
-						port@8 {
-							reg = <0x8>;
+					xbar_mixer_in10_port: port@5d {
+						reg = <0x5d>;
 
-							mixer_in9_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in9_ep>;
-							};
+						xbar_mixer_in10_ep: endpoint {
+							remote-endpoint = <&mixer_in10_ep>;
 						};
+					};
 
-						port@9 {
-							reg = <0x9>;
+					port@5e {
+						reg = <0x5e>;
 
-							mixer_in10_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_in10_ep>;
-							};
+						xbar_mixer_out1_ep: endpoint {
+							remote-endpoint = <&mixer_out1_ep>;
 						};
+					};
 
-						mixer_out1_port: port@a {
-							reg = <0xa>;
-
-							mixer_out1_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_out1_ep>;
-							};
+					port@5f {
+						reg = <0x5f>;
+
+						xbar_mixer_out2_ep: endpoint {
+							remote-endpoint = <&mixer_out2_ep>;
 						};
+					};
 
-						mixer_out2_port: port@b {
-							reg = <0xb>;
+					port@60 {
+						reg = <0x60>;
 
-							mixer_out2_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_out2_ep>;
-							};
+						xbar_mixer_out3_ep: endpoint {
+							remote-endpoint = <&mixer_out3_ep>;
 						};
+					};
 
-						mixer_out3_port: port@c {
-							reg = <0xc>;
+					port@61 {
+						reg = <0x61>;
 
-							mixer_out3_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_out3_ep>;
-							};
+						xbar_mixer_out4_ep: endpoint {
+							remote-endpoint = <&mixer_out4_ep>;
 						};
+					};
 
-						mixer_out4_port: port@d {
-							reg = <0xd>;
+					port@62 {
+						reg = <0x62>;
 
-							mixer_out4_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_out4_ep>;
-							};
+						xbar_mixer_out5_ep: endpoint {
+							remote-endpoint = <&mixer_out5_ep>;
 						};
+					};
 
-						mixer_out5_port: port@e {
-							reg = <0xe>;
+					xbar_asrc_in1_port: port@63 {
+						reg = <0x63>;
 
-							mixer_out5_ep: endpoint {
-								remote-endpoint = <&xbar_mixer_out5_ep>;
-							};
+						xbar_asrc_in1_ep: endpoint {
+							remote-endpoint = <&asrc_in1_ep>;
 						};
 					};
-				};
 
-				asrc@2910000 {
-					status = "okay";
+					port@64 {
+						reg = <0x64>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_asrc_out1_ep: endpoint {
+							remote-endpoint = <&asrc_out1_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0x0>;
+					xbar_asrc_in2_port: port@65 {
+						reg = <0x65>;
 
-							asrc_in1_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in1_ep>;
-							};
+						xbar_asrc_in2_ep: endpoint {
+							remote-endpoint = <&asrc_in2_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <0x1>;
+					port@66 {
+						reg = <0x66>;
 
-							asrc_in2_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in2_ep>;
-							};
+						xbar_asrc_out2_ep: endpoint {
+							remote-endpoint = <&asrc_out2_ep>;
 						};
+					};
 
-						port@2 {
-							reg = <0x2>;
+					xbar_asrc_in3_port: port@67 {
+						reg = <0x67>;
 
-							asrc_in3_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in3_ep>;
-							};
+						xbar_asrc_in3_ep: endpoint {
+							remote-endpoint = <&asrc_in3_ep>;
 						};
+					};
 
-						port@3 {
-							reg = <0x3>;
+					port@68 {
+						reg = <0x68>;
 
-							asrc_in4_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in4_ep>;
-							};
+						xbar_asrc_out3_ep: endpoint {
+							remote-endpoint = <&asrc_out3_ep>;
 						};
+					};
 
-						port@4 {
-							reg = <0x4>;
+					xbar_asrc_in4_port: port@69 {
+						reg = <0x69>;
 
-							asrc_in5_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in5_ep>;
-							};
+						xbar_asrc_in4_ep: endpoint {
+							remote-endpoint = <&asrc_in4_ep>;
 						};
+					};
 
-						port@5 {
-							reg = <0x5>;
+					port@6a {
+						reg = <0x6a>;
 
-							asrc_in6_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in6_ep>;
-							};
+						xbar_asrc_out4_ep: endpoint {
+							remote-endpoint = <&asrc_out4_ep>;
 						};
+					};
 
-						port@6 {
-							reg = <0x6>;
+					xbar_asrc_in5_port: port@6b {
+						reg = <0x6b>;
 
-							asrc_in7_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in7_ep>;
-							};
+						xbar_asrc_in5_ep: endpoint {
+							remote-endpoint = <&asrc_in5_ep>;
 						};
+					};
 
-						asrc_out1_port: port@7 {
-							reg = <0x7>;
+					port@6c {
+						reg = <0x6c>;
 
-							asrc_out1_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out1_ep>;
-							};
+						xbar_asrc_out5_ep: endpoint {
+							remote-endpoint = <&asrc_out5_ep>;
 						};
+					};
 
-						asrc_out2_port: port@8 {
-							reg = <0x8>;
+					xbar_asrc_in6_port: port@6d {
+						reg = <0x6d>;
 
-							asrc_out2_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out2_ep>;
-							};
+						xbar_asrc_in6_ep: endpoint {
+							remote-endpoint = <&asrc_in6_ep>;
 						};
+					};
 
-						asrc_out3_port: port@9 {
-							reg = <0x9>;
+					port@6e {
+						reg = <0x6e>;
 
-							asrc_out3_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out3_ep>;
-							};
+						xbar_asrc_out6_ep: endpoint {
+							remote-endpoint = <&asrc_out6_ep>;
 						};
+					};
 
-						asrc_out4_port: port@a {
-							reg = <0xa>;
+					xbar_asrc_in7_port: port@6f {
+						reg = <0x6f>;
 
-							asrc_out4_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out4_ep>;
-							};
+						xbar_asrc_in7_ep: endpoint {
+							remote-endpoint = <&asrc_in7_ep>;
 						};
+					};
 
-						asrc_out5_port: port@b {
-							reg = <0xb>;
+					xbar_ope1_in_port: port@70 {
+						reg = <0x70>;
 
-							asrc_out5_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out5_ep>;
-							};
+						xbar_ope1_in_ep: endpoint {
+							remote-endpoint = <&ope1_cif_in_ep>;
 						};
+					};
 
-						asrc_out6_port:	port@c {
-							reg = <0xc>;
+					port@71 {
+						reg = <0x71>;
 
-							asrc_out6_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out6_ep>;
-							};
+						xbar_ope1_out_ep: endpoint {
+							remote-endpoint = <&ope1_cif_out_ep>;
 						};
 					};
 				};
 			};
-		};
 
-		ddc: i2c@3190000 {
-			status = "okay";
+			dma-controller@2930000 {
+				status = "okay";
+			};
+
+			interrupt-controller@2a40000 {
+				status = "okay";
+			};
 		};
 
 		i2c@3160000 {
@@ -2073,6 +2070,26 @@ eeprom@57 {
 			};
 		};
 
+		ddc: i2c@3190000 {
+			status = "okay";
+		};
+
+		spi@3270000 {
+			status = "okay";
+
+			flash@0 {
+				compatible = "jedec,spi-nor";
+				reg = <0>;
+				spi-max-frequency = <102000000>;
+				spi-tx-bus-width = <4>;
+				spi-rx-bus-width = <4>;
+			};
+		};
+
+		pwm@32d0000 {
+			status = "okay";
+		};
+
 		hda@3510000 {
 			nvidia,model = "NVIDIA Jetson Xavier NX HDA";
 			status = "okay";
@@ -2141,15 +2158,6 @@ usb3-2 {
 			};
 		};
 
-		usb@3610000 {
-			status = "okay";
-
-			phys =	<&{/bus@0/padctl@3520000/pads/usb2/lanes/usb2-1}>,
-				<&{/bus@0/padctl@3520000/pads/usb2/lanes/usb2-2}>,
-				<&{/bus@0/padctl@3520000/pads/usb3/lanes/usb3-2}>;
-			phy-names = "usb2-1", "usb2-2", "usb3-2";
-		};
-
 		usb@3550000 {
 			status = "okay";
 
@@ -2157,20 +2165,13 @@ usb@3550000 {
 			phy-names = "usb2-0";
 		};
 
-		spi@3270000 {
+		usb@3610000 {
 			status = "okay";
 
-			flash@0 {
-				compatible = "jedec,spi-nor";
-				reg = <0>;
-				spi-max-frequency = <102000000>;
-				spi-tx-bus-width = <4>;
-				spi-rx-bus-width = <4>;
-			};
-		};
-
-		pwm@32d0000 {
-			status = "okay";
+			phys =	<&{/bus@0/padctl@3520000/pads/usb2/lanes/usb2-1}>,
+				<&{/bus@0/padctl@3520000/pads/usb2/lanes/usb2-2}>,
+				<&{/bus@0/padctl@3520000/pads/usb3/lanes/usb3-2}>;
+			phy-names = "usb2-1", "usb2-2", "usb3-2";
 		};
 
 		host1x@13e00000 {
@@ -2251,14 +2252,6 @@ pcie-ep@141a0000 {
 		};
 	};
 
-	fan: pwm-fan {
-		compatible = "pwm-fan";
-		pwms = <&pwm6 0 45334>;
-
-		cooling-levels = <0 64 128 255>;
-		#cooling-cells = <2>;
-	};
-
 	gpio-keys {
 		compatible = "gpio-keys";
 
@@ -2283,6 +2276,14 @@ key-power {
 		};
 	};
 
+	fan: pwm-fan {
+		compatible = "pwm-fan";
+		pwms = <&pwm6 0 45334>;
+
+		cooling-levels = <0 64 128 255>;
+		#cooling-cells = <2>;
+	};
+
 	vdd_5v0_sys: regulator-vdd-5v0-sys {
 		compatible = "regulator-fixed";
 		regulator-name = "VDD_5V_SYS";
diff --git a/arch/arm64/boot/dts/nvidia/tegra194-p3668.dtsi b/arch/arm64/boot/dts/nvidia/tegra194-p3668.dtsi
index 0751edddf7d59..58f190b0f8687 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194-p3668.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194-p3668.dtsi
@@ -121,6 +121,24 @@ pmic: pmic@3c {
 				pinctrl-names = "default";
 				pinctrl-0 = <&max20024_default>;
 
+				fps {
+					fps0 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+						maxim,shutdown-fps-time-period-us = <640>;
+					};
+
+					fps1 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
+						maxim,shutdown-fps-time-period-us = <640>;
+						maxim,device-state-on-disabled-event = <MAX77620_FPS_INACTIVE_STATE_SLEEP>;
+					};
+
+					fps2 {
+						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+						maxim,shutdown-fps-time-period-us = <640>;
+					};
+				};
+
 				max20024_default: pinmux {
 					gpio0 {
 						pins = "gpio0";
@@ -164,24 +182,6 @@ gpio7 {
 					};
 				};
 
-				fps {
-					fps0 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-						maxim,shutdown-fps-time-period-us = <640>;
-					};
-
-					fps1 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
-						maxim,shutdown-fps-time-period-us = <640>;
-						maxim,device-state-on-disabled-event = <MAX77620_FPS_INACTIVE_STATE_SLEEP>;
-					};
-
-					fps2 {
-						maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-						maxim,shutdown-fps-time-period-us = <640>;
-					};
-				};
-
 				regulators {
 					in-sd0-supply = <&vdd_5v0_sys>;
 					in-sd1-supply = <&vdd_5v0_sys>;
diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index b941b1c77713c..45a204d753b1b 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -111,6 +111,34 @@ axi2apb: axi2apb@2390000 {
 			status = "okay";
 		};
 
+		pinmux: pinmux@2430000 {
+			compatible = "nvidia,tegra194-pinmux";
+			reg = <0x0 0x2430000 0x0 0x17000>;
+			status = "okay";
+
+			pex_clkreq_c5_bi_dir_state: pinmux-pex-clkreq-c5-bi-dir {
+				clkreq {
+					nvidia,pins = "pex_l5_clkreq_n_pgg0";
+					nvidia,schmitt = <TEGRA_PIN_DISABLE>;
+					nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+					nvidia,io-hv = <TEGRA_PIN_ENABLE>;
+					nvidia,tristate = <TEGRA_PIN_DISABLE>;
+					nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				};
+			};
+
+			pex_rst_c5_out_state: pinmux-pex-rst-c5-out {
+				pex_rst {
+					nvidia,pins = "pex_l5_rst_n_pgg1";
+					nvidia,schmitt = <TEGRA_PIN_DISABLE>;
+					nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+					nvidia,io-hv = <TEGRA_PIN_ENABLE>;
+					nvidia,tristate = <TEGRA_PIN_DISABLE>;
+					nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				};
+			};
+		};
+
 		ethernet@2490000 {
 			compatible = "nvidia,tegra194-eqos",
 				     "nvidia,tegra186-eqos",
@@ -196,64 +224,6 @@ aconnect@2900000 {
 			#size-cells = <2>;
 			ranges = <0x0 0x02900000 0x0 0x02900000 0x0 0x200000>;
 
-			adma: dma-controller@2930000 {
-				compatible = "nvidia,tegra194-adma",
-					     "nvidia,tegra186-adma";
-				reg = <0x0 0x02930000 0x0 0x20000>;
-				interrupt-parent = <&agic>;
-				interrupts =  <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
-					      <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
-				#dma-cells = <1>;
-				clocks = <&bpmp TEGRA194_CLK_AHUB>;
-				clock-names = "d_audio";
-				status = "disabled";
-			};
-
-			agic: interrupt-controller@2a40000 {
-				compatible = "nvidia,tegra194-agic",
-					     "nvidia,tegra210-agic";
-				#interrupt-cells = <3>;
-				interrupt-controller;
-				reg = <0x0 0x02a41000 0x0 0x1000>,
-				      <0x0 0x02a42000 0x0 0x2000>;
-				interrupts = <GIC_SPI 145
-					      (GIC_CPU_MASK_SIMPLE(4) |
-					       IRQ_TYPE_LEVEL_HIGH)>;
-				clocks = <&bpmp TEGRA194_CLK_APE>;
-				clock-names = "clk";
-				status = "disabled";
-			};
-
 			tegra_ahub: ahub@2900800 {
 				compatible = "nvidia,tegra194-ahub",
 					     "nvidia,tegra186-ahub";
@@ -268,57 +238,6 @@ tegra_ahub: ahub@2900800 {
 				#size-cells = <2>;
 				ranges = <0x0 0x02900800 0x0 0x02900800 0x0 0x11800>;
 
-				tegra_admaif: admaif@290f000 {
-					compatible = "nvidia,tegra194-admaif",
-						     "nvidia,tegra186-admaif";
-					reg = <0x0 0x0290f000 0x0 0x1000>;
-					dmas = <&adma 1>, <&adma 1>,
-					       <&adma 2>, <&adma 2>,
-					       <&adma 3>, <&adma 3>,
-					       <&adma 4>, <&adma 4>,
-					       <&adma 5>, <&adma 5>,
-					       <&adma 6>, <&adma 6>,
-					       <&adma 7>, <&adma 7>,
-					       <&adma 8>, <&adma 8>,
-					       <&adma 9>, <&adma 9>,
-					       <&adma 10>, <&adma 10>,
-					       <&adma 11>, <&adma 11>,
-					       <&adma 12>, <&adma 12>,
-					       <&adma 13>, <&adma 13>,
-					       <&adma 14>, <&adma 14>,
-					       <&adma 15>, <&adma 15>,
-					       <&adma 16>, <&adma 16>,
-					       <&adma 17>, <&adma 17>,
-					       <&adma 18>, <&adma 18>,
-					       <&adma 19>, <&adma 19>,
-					       <&adma 20>, <&adma 20>;
-					dma-names = "rx1", "tx1",
-						    "rx2", "tx2",
-						    "rx3", "tx3",
-						    "rx4", "tx4",
-						    "rx5", "tx5",
-						    "rx6", "tx6",
-						    "rx7", "tx7",
-						    "rx8", "tx8",
-						    "rx9", "tx9",
-						    "rx10", "tx10",
-						    "rx11", "tx11",
-						    "rx12", "tx12",
-						    "rx13", "tx13",
-						    "rx14", "tx14",
-						    "rx15", "tx15",
-						    "rx16", "tx16",
-						    "rx17", "tx17",
-						    "rx18", "tx18",
-						    "rx19", "tx19",
-						    "rx20", "tx20";
-					status = "disabled";
-					interconnects = <&mc TEGRA194_MEMORY_CLIENT_APEDMAR &emc>,
-							<&mc TEGRA194_MEMORY_CLIENT_APEDMAW &emc>;
-					interconnect-names = "dma-mem", "write";
-					iommus = <&smmu TEGRA194_SID_APE>;
-				};
-
 				tegra_i2s1: i2s@2901000 {
 					compatible = "nvidia,tegra194-i2s",
 						     "nvidia,tegra210-i2s";
@@ -403,84 +322,6 @@ tegra_i2s6: i2s@2901500 {
 					status = "disabled";
 				};
 
-				tegra_dmic1: dmic@2904000 {
-					compatible = "nvidia,tegra194-dmic",
-						     "nvidia,tegra210-dmic";
-					reg = <0x0 0x2904000 0x0 0x100>;
-					clocks = <&bpmp TEGRA194_CLK_DMIC1>;
-					clock-names = "dmic";
-					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC1>;
-					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
-					assigned-clock-rates = <3072000>;
-					sound-name-prefix = "DMIC1";
-					status = "disabled";
-				};
-
-				tegra_dmic2: dmic@2904100 {
-					compatible = "nvidia,tegra194-dmic",
-						     "nvidia,tegra210-dmic";
-					reg = <0x0 0x2904100 0x0 0x100>;
-					clocks = <&bpmp TEGRA194_CLK_DMIC2>;
-					clock-names = "dmic";
-					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC2>;
-					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
-					assigned-clock-rates = <3072000>;
-					sound-name-prefix = "DMIC2";
-					status = "disabled";
-				};
-
-				tegra_dmic3: dmic@2904200 {
-					compatible = "nvidia,tegra194-dmic",
-						     "nvidia,tegra210-dmic";
-					reg = <0x0 0x2904200 0x0 0x100>;
-					clocks = <&bpmp TEGRA194_CLK_DMIC3>;
-					clock-names = "dmic";
-					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC3>;
-					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
-					assigned-clock-rates = <3072000>;
-					sound-name-prefix = "DMIC3";
-					status = "disabled";
-				};
-
-				tegra_dmic4: dmic@2904300 {
-					compatible = "nvidia,tegra194-dmic",
-						     "nvidia,tegra210-dmic";
-					reg = <0x0 0x2904300 0x0 0x100>;
-					clocks = <&bpmp TEGRA194_CLK_DMIC4>;
-					clock-names = "dmic";
-					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC4>;
-					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
-					assigned-clock-rates = <3072000>;
-					sound-name-prefix = "DMIC4";
-					status = "disabled";
-				};
-
-				tegra_dspk1: dspk@2905000 {
-					compatible = "nvidia,tegra194-dspk",
-						     "nvidia,tegra186-dspk";
-					reg = <0x0 0x2905000 0x0 0x100>;
-					clocks = <&bpmp TEGRA194_CLK_DSPK1>;
-					clock-names = "dspk";
-					assigned-clocks = <&bpmp TEGRA194_CLK_DSPK1>;
-					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
-					assigned-clock-rates = <12288000>;
-					sound-name-prefix = "DSPK1";
-					status = "disabled";
-				};
-
-				tegra_dspk2: dspk@2905100 {
-					compatible = "nvidia,tegra194-dspk",
-						     "nvidia,tegra186-dspk";
-					reg = <0x0 0x2905100 0x0 0x100>;
-					clocks = <&bpmp TEGRA194_CLK_DSPK2>;
-					clock-names = "dspk";
-					assigned-clocks = <&bpmp TEGRA194_CLK_DSPK2>;
-					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
-					assigned-clock-rates = <12288000>;
-					sound-name-prefix = "DSPK2";
-					status = "disabled";
-				};
-
 				tegra_sfc1: sfc@2902000 {
 					compatible = "nvidia,tegra194-sfc",
 						     "nvidia,tegra210-sfc";
@@ -513,22 +354,6 @@ tegra_sfc4: sfc@2902600 {
 					status = "disabled";
 				};
 
-				tegra_mvc1: mvc@290a000 {
-					compatible = "nvidia,tegra194-mvc",
-						     "nvidia,tegra210-mvc";
-					reg = <0x0 0x290a000 0x0 0x200>;
-					sound-name-prefix = "MVC1";
-					status = "disabled";
-				};
-
-				tegra_mvc2: mvc@290a200 {
-					compatible = "nvidia,tegra194-mvc",
-						     "nvidia,tegra210-mvc";
-					reg = <0x0 0x290a200 0x0 0x200>;
-					sound-name-prefix = "MVC2";
-					status = "disabled";
-				};
-
 				tegra_amx1: amx@2903000 {
 					compatible = "nvidia,tegra194-amx";
 					reg = <0x0 0x2903000 0x0 0x100>;
@@ -589,6 +414,84 @@ tegra_adx4: adx@2903b00 {
 					status = "disabled";
 				};
 
+				tegra_dmic1: dmic@2904000 {
+					compatible = "nvidia,tegra194-dmic",
+						     "nvidia,tegra210-dmic";
+					reg = <0x0 0x2904000 0x0 0x100>;
+					clocks = <&bpmp TEGRA194_CLK_DMIC1>;
+					clock-names = "dmic";
+					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC1>;
+					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
+					assigned-clock-rates = <3072000>;
+					sound-name-prefix = "DMIC1";
+					status = "disabled";
+				};
+
+				tegra_dmic2: dmic@2904100 {
+					compatible = "nvidia,tegra194-dmic",
+						     "nvidia,tegra210-dmic";
+					reg = <0x0 0x2904100 0x0 0x100>;
+					clocks = <&bpmp TEGRA194_CLK_DMIC2>;
+					clock-names = "dmic";
+					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC2>;
+					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
+					assigned-clock-rates = <3072000>;
+					sound-name-prefix = "DMIC2";
+					status = "disabled";
+				};
+
+				tegra_dmic3: dmic@2904200 {
+					compatible = "nvidia,tegra194-dmic",
+						     "nvidia,tegra210-dmic";
+					reg = <0x0 0x2904200 0x0 0x100>;
+					clocks = <&bpmp TEGRA194_CLK_DMIC3>;
+					clock-names = "dmic";
+					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC3>;
+					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
+					assigned-clock-rates = <3072000>;
+					sound-name-prefix = "DMIC3";
+					status = "disabled";
+				};
+
+				tegra_dmic4: dmic@2904300 {
+					compatible = "nvidia,tegra194-dmic",
+						     "nvidia,tegra210-dmic";
+					reg = <0x0 0x2904300 0x0 0x100>;
+					clocks = <&bpmp TEGRA194_CLK_DMIC4>;
+					clock-names = "dmic";
+					assigned-clocks = <&bpmp TEGRA194_CLK_DMIC4>;
+					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
+					assigned-clock-rates = <3072000>;
+					sound-name-prefix = "DMIC4";
+					status = "disabled";
+				};
+
+				tegra_dspk1: dspk@2905000 {
+					compatible = "nvidia,tegra194-dspk",
+						     "nvidia,tegra186-dspk";
+					reg = <0x0 0x2905000 0x0 0x100>;
+					clocks = <&bpmp TEGRA194_CLK_DSPK1>;
+					clock-names = "dspk";
+					assigned-clocks = <&bpmp TEGRA194_CLK_DSPK1>;
+					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
+					assigned-clock-rates = <12288000>;
+					sound-name-prefix = "DSPK1";
+					status = "disabled";
+				};
+
+				tegra_dspk2: dspk@2905100 {
+					compatible = "nvidia,tegra194-dspk",
+						     "nvidia,tegra186-dspk";
+					reg = <0x0 0x2905100 0x0 0x100>;
+					clocks = <&bpmp TEGRA194_CLK_DSPK2>;
+					clock-names = "dspk";
+					assigned-clocks = <&bpmp TEGRA194_CLK_DSPK2>;
+					assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
+					assigned-clock-rates = <12288000>;
+					sound-name-prefix = "DSPK2";
+					status = "disabled";
+				};
+
 				tegra_ope1: processing-engine@2908000 {
 					compatible = "nvidia,tegra194-ope",
 						     "nvidia,tegra210-ope";
@@ -613,6 +516,22 @@ dynamic-range-compressor@2908200 {
 					};
 				};
 
+				tegra_mvc1: mvc@290a000 {
+					compatible = "nvidia,tegra194-mvc",
+						     "nvidia,tegra210-mvc";
+					reg = <0x0 0x290a000 0x0 0x200>;
+					sound-name-prefix = "MVC1";
+					status = "disabled";
+				};
+
+				tegra_mvc2: mvc@290a200 {
+					compatible = "nvidia,tegra194-mvc",
+						     "nvidia,tegra210-mvc";
+					reg = <0x0 0x290a200 0x0 0x200>;
+					sound-name-prefix = "MVC2";
+					status = "disabled";
+				};
+
 				tegra_amixer: amixer@290bb00 {
 					compatible = "nvidia,tegra194-amixer",
 						     "nvidia,tegra210-amixer";
@@ -621,6 +540,57 @@ tegra_amixer: amixer@290bb00 {
 					status = "disabled";
 				};
 
+				tegra_admaif: admaif@290f000 {
+					compatible = "nvidia,tegra194-admaif",
+						     "nvidia,tegra186-admaif";
+					reg = <0x0 0x0290f000 0x0 0x1000>;
+					dmas = <&adma 1>, <&adma 1>,
+					       <&adma 2>, <&adma 2>,
+					       <&adma 3>, <&adma 3>,
+					       <&adma 4>, <&adma 4>,
+					       <&adma 5>, <&adma 5>,
+					       <&adma 6>, <&adma 6>,
+					       <&adma 7>, <&adma 7>,
+					       <&adma 8>, <&adma 8>,
+					       <&adma 9>, <&adma 9>,
+					       <&adma 10>, <&adma 10>,
+					       <&adma 11>, <&adma 11>,
+					       <&adma 12>, <&adma 12>,
+					       <&adma 13>, <&adma 13>,
+					       <&adma 14>, <&adma 14>,
+					       <&adma 15>, <&adma 15>,
+					       <&adma 16>, <&adma 16>,
+					       <&adma 17>, <&adma 17>,
+					       <&adma 18>, <&adma 18>,
+					       <&adma 19>, <&adma 19>,
+					       <&adma 20>, <&adma 20>;
+					dma-names = "rx1", "tx1",
+						    "rx2", "tx2",
+						    "rx3", "tx3",
+						    "rx4", "tx4",
+						    "rx5", "tx5",
+						    "rx6", "tx6",
+						    "rx7", "tx7",
+						    "rx8", "tx8",
+						    "rx9", "tx9",
+						    "rx10", "tx10",
+						    "rx11", "tx11",
+						    "rx12", "tx12",
+						    "rx13", "tx13",
+						    "rx14", "tx14",
+						    "rx15", "tx15",
+						    "rx16", "tx16",
+						    "rx17", "tx17",
+						    "rx18", "tx18",
+						    "rx19", "tx19",
+						    "rx20", "tx20";
+					status = "disabled";
+					interconnects = <&mc TEGRA194_MEMORY_CLIENT_APEDMAR &emc>,
+							<&mc TEGRA194_MEMORY_CLIENT_APEDMAW &emc>;
+					interconnect-names = "dma-mem", "write";
+					iommus = <&smmu TEGRA194_SID_APE>;
+				};
+
 				tegra_asrc: asrc@2910000 {
 					compatible = "nvidia,tegra194-asrc",
 						     "nvidia,tegra186-asrc";
@@ -629,33 +599,63 @@ tegra_asrc: asrc@2910000 {
 					status = "disabled";
 				};
 			};
-		};
 
-		pinmux: pinmux@2430000 {
-			compatible = "nvidia,tegra194-pinmux";
-			reg = <0x0 0x2430000 0x0 0x17000>;
-			status = "okay";
-
-			pex_rst_c5_out_state: pinmux-pex-rst-c5-out {
-				pex_rst {
-					nvidia,pins = "pex_l5_rst_n_pgg1";
-					nvidia,schmitt = <TEGRA_PIN_DISABLE>;
-					nvidia,enable-input = <TEGRA_PIN_DISABLE>;
-					nvidia,io-hv = <TEGRA_PIN_ENABLE>;
-					nvidia,tristate = <TEGRA_PIN_DISABLE>;
-					nvidia,pull = <TEGRA_PIN_PULL_NONE>;
-				};
+			adma: dma-controller@2930000 {
+				compatible = "nvidia,tegra194-adma",
+					     "nvidia,tegra186-adma";
+				reg = <0x0 0x02930000 0x0 0x20000>;
+				interrupt-parent = <&agic>;
+				interrupts =  <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
+					      <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
+				#dma-cells = <1>;
+				clocks = <&bpmp TEGRA194_CLK_AHUB>;
+				clock-names = "d_audio";
+				status = "disabled";
 			};
 
-			clkreq_c5_bi_dir_state: pinmux-clkreq-c5-bi-dir {
-				clkreq {
-					nvidia,pins = "pex_l5_clkreq_n_pgg0";
-					nvidia,schmitt = <TEGRA_PIN_DISABLE>;
-					nvidia,enable-input = <TEGRA_PIN_ENABLE>;
-					nvidia,io-hv = <TEGRA_PIN_ENABLE>;
-					nvidia,tristate = <TEGRA_PIN_DISABLE>;
-					nvidia,pull = <TEGRA_PIN_PULL_NONE>;
-				};
+			agic: interrupt-controller@2a40000 {
+				compatible = "nvidia,tegra194-agic",
+					     "nvidia,tegra210-agic";
+				#interrupt-cells = <3>;
+				interrupt-controller;
+				reg = <0x0 0x02a41000 0x0 0x1000>,
+				      <0x0 0x02a42000 0x0 0x2000>;
+				interrupts = <GIC_SPI 145
+					      (GIC_CPU_MASK_SIMPLE(4) |
+					       IRQ_TYPE_LEVEL_HIGH)>;
+				clocks = <&bpmp TEGRA194_CLK_APE>;
+				clock-names = "clk";
+				status = "disabled";
 			};
 		};
 
@@ -942,19 +942,6 @@ spi@3270000 {
 			status = "disabled";
 		};
 
-		spi@3300000 {
-			compatible = "nvidia,tegra194-qspi";
-			reg = <0x0 0x3300000 0x0 0x1000>;
-			interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			clocks = <&bpmp TEGRA194_CLK_QSPI1>,
-				 <&bpmp TEGRA194_CLK_QSPI1_PM>;
-			clock-names = "qspi", "qspi_out";
-			resets = <&bpmp TEGRA194_RESET_QSPI1>;
-			status = "disabled";
-		};
-
 		pwm1: pwm@3280000 {
 			compatible = "nvidia,tegra194-pwm",
 				     "nvidia,tegra186-pwm";
@@ -1032,6 +1019,19 @@ pwm8: pwm@32f0000 {
 			#pwm-cells = <2>;
 		};
 
+		spi@3300000 {
+			compatible = "nvidia,tegra194-qspi";
+			reg = <0x0 0x3300000 0x0 0x1000>;
+			interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&bpmp TEGRA194_CLK_QSPI1>,
+				 <&bpmp TEGRA194_CLK_QSPI1_PM>;
+			clock-names = "qspi", "qspi_out";
+			resets = <&bpmp TEGRA194_RESET_QSPI1>;
+			status = "disabled";
+		};
+
 		sdmmc1: mmc@3400000 {
 			compatible = "nvidia,tegra194-sdhci";
 			reg = <0x0 0x03400000 0x0 0x10000>;
@@ -1707,17 +1707,14 @@ pmc: pmc@c360000 {
 
 			#interrupt-cells = <2>;
 			interrupt-controller;
-			sdmmc1_3v3: sdmmc1-3v3 {
-				pins = "sdmmc1-hv";
-				power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
-			};
 
 			sdmmc1_1v8: sdmmc1-1v8 {
 				pins = "sdmmc1-hv";
 				power-source = <TEGRA_IO_PAD_VOLTAGE_1V8>;
 			};
-			sdmmc3_3v3: sdmmc3-3v3 {
-				pins = "sdmmc3-hv";
+
+			sdmmc1_3v3: sdmmc1-3v3 {
+				pins = "sdmmc1-hv";
 				power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
 			};
 
@@ -1726,6 +1723,10 @@ sdmmc3_1v8: sdmmc3-1v8 {
 				power-source = <TEGRA_IO_PAD_VOLTAGE_1V8>;
 			};
 
+			sdmmc3_3v3: sdmmc3-3v3 {
+				pins = "sdmmc3-hv";
+				power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
+			};
 		};
 
 		aon-noc@c600000 {
@@ -2373,10 +2374,10 @@ sor3: sor@15bc0000 {
 		pcie@14100000 {
 			compatible = "nvidia,tegra194-pcie";
 			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
-			reg = <0x0 0x14100000 0x0 0x00020000>, /* appl registers (128K)      */
-			      <0x0 0x30000000 0x0 0x00040000>, /* configuration space (256K) */
-			      <0x0 0x30040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-			      <0x0 0x30080000 0x0 0x00040000>; /* DBI reg space (256K)       */
+			reg = <0x00 0x14100000 0x0 0x00020000>, /* appl registers (128K)      */
+			      <0x00 0x30000000 0x0 0x00040000>, /* configuration space (256K) */
+			      <0x00 0x30040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
+			      <0x00 0x30080000 0x0 0x00040000>; /* DBI reg space (256K)       */
 			reg-names = "appl", "config", "atu_dma", "dbi";
 
 			status = "disabled";
@@ -2726,7 +2727,7 @@ pcie@141a0000 {
 			linux,pci-domain = <5>;
 
 			pinctrl-names = "default";
-			pinctrl-0 = <&pex_rst_c5_out_state>, <&clkreq_c5_bi_dir_state>;
+			pinctrl-0 = <&pex_rst_c5_out_state>, <&pex_clkreq_c5_bi_dir_state>;
 
 			clocks = <&bpmp TEGRA194_CLK_PEX1_CORE_5>;
 			clock-names = "core";
@@ -2779,7 +2780,7 @@ pcie-ep@141a0000 {
 			num-ob-windows = <8>;
 
 			pinctrl-names = "default";
-			pinctrl-0 = <&clkreq_c5_bi_dir_state>;
+			pinctrl-0 = <&pex_clkreq_c5_bi_dir_state>;
 
 			clocks = <&bpmp TEGRA194_CLK_PEX1_CORE_5>;
 			clock-names = "core";
@@ -3121,6 +3122,13 @@ psci {
 		method = "smc";
 	};
 
+	tcu: serial {
+		compatible = "nvidia,tegra194-tcu";
+		mboxes = <&hsp_top0 TEGRA_HSP_MBOX_TYPE_SM TEGRA_HSP_SM_RX(0)>,
+			 <&hsp_aon TEGRA_HSP_MBOX_TYPE_SM TEGRA_HSP_SM_TX(1)>;
+		mbox-names = "rx", "tx";
+	};
+
 	sound {
 		status = "disabled";
 
@@ -3141,13 +3149,6 @@ sound {
 		assigned-clock-rates = <258000000>;
 	};
 
-	tcu: serial {
-		compatible = "nvidia,tegra194-tcu";
-		mboxes = <&hsp_top0 TEGRA_HSP_MBOX_TYPE_SM TEGRA_HSP_SM_RX(0)>,
-		         <&hsp_aon TEGRA_HSP_MBOX_TYPE_SM TEGRA_HSP_SM_TX(1)>;
-		mbox-names = "rx", "tx";
-	};
-
 	thermal-zones {
 		cpu-thermal {
 			thermal-sensors = <&{/bpmp/thermal} TEGRA194_BPMP_THERMAL_ZONE_CPU>;
diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
index 75eb743a72427..92163b6809801 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
@@ -31,6 +31,23 @@ serial@70006000 {
 		status = "okay";
 	};
 
+	i2c@7000c500 {
+		status = "okay";
+
+		/* module ID EEPROM */
+		eeprom@50 {
+			compatible = "atmel,24c02";
+			reg = <0x50>;
+
+			label = "module";
+			vcc-supply = <&vdd_1v8>;
+			address-width = <8>;
+			pagesize = <8>;
+			size = <256>;
+			read-only;
+		};
+	};
+
 	i2c@7000d000 {
 		status = "okay";
 		clock-frequency = <400000>;
@@ -50,6 +67,22 @@ pmic: pmic@3c {
 			pinctrl-names = "default";
 			pinctrl-0 = <&max77620_default>;
 
+			fps {
+				fps0 {
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+					maxim,suspend-fps-time-period-us = <1280>;
+				};
+
+				fps1 {
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
+					maxim,suspend-fps-time-period-us = <1280>;
+				};
+
+				fps2 {
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+				};
+			};
+
 			max77620_default: pinmux {
 				gpio0 {
 					pins = "gpio0";
@@ -84,22 +117,6 @@ gpio5_6_7 {
 				};
 			};
 
-			fps {
-				fps0 {
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-					maxim,suspend-fps-time-period-us = <1280>;
-				};
-
-				fps1 {
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
-					maxim,suspend-fps-time-period-us = <1280>;
-				};
-
-				fps2 {
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-				};
-			};
-
 			regulators {
 				in-ldo0-1-supply = <&vdd_pre>;
 				in-ldo7-8-supply = <&vdd_pre>;
@@ -265,23 +282,6 @@ avdd_1v05: ldo8 {
 		};
 	};
 
-	i2c@7000c500 {
-		status = "okay";
-
-		/* module ID EEPROM */
-		eeprom@50 {
-			compatible = "atmel,24c02";
-			reg = <0x50>;
-
-			label = "module";
-			vcc-supply = <&vdd_1v8>;
-			address-width = <8>;
-			pagesize = <8>;
-			size = <256>;
-			read-only;
-		};
-	};
-
 	pmc@7000e400 {
 		nvidia,invert-interrupt;
 		nvidia,suspend-mode = <0>;
diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2371-2180.dts b/arch/arm64/boot/dts/nvidia/tegra210-p2371-2180.dts
index 1e26ca91a9449..38f4ff229beff 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2371-2180.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2371-2180.dts
@@ -63,17 +63,17 @@ backlight: backlight@2c {
 			pwms = <&pwm 0 29334>;
 			pwm-names = "lp8557";
 
-			/* 3 LED string */
-			rom_14h {
-				rom-addr = /bits/ 8 <0x14>;
-				rom-val = /bits/ 8 <0x87>;
-			};
-
 			/* boost frequency 1 MHz */
 			rom_13h {
 				rom-addr = /bits/ 8 <0x13>;
 				rom-val = /bits/ 8 <0x01>;
 			};
+
+			/* 3 LED string */
+			rom_14h {
+				rom-addr = /bits/ 8 <0x14>;
+				rom-val = /bits/ 8 <0x87>;
+			};
 		};
 	};
 
@@ -116,14 +116,6 @@ clock@70110000 {
 	aconnect@702c0000 {
 		status = "okay";
 
-		dma-controller@702e2000 {
-			status = "okay";
-		};
-
-		interrupt-controller@702f9000 {
-			status = "okay";
-		};
-
 		ahub@702d0800 {
 			status = "okay";
 
@@ -261,81 +253,6 @@ i2s5_dap_ep: endpoint {
 				};
 			};
 
-			dmic@702d4000 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						dmic1_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dmic1_ep>;
-						};
-					};
-
-					dmic1_port: port@1 {
-						reg = <1>;
-
-						dmic1_dap_ep: endpoint {
-							/* Placeholder for external Codec */
-						};
-					};
-				};
-			};
-
-			dmic@702d4100 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						dmic2_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dmic2_ep>;
-						};
-					};
-
-					dmic2_port: port@1 {
-						reg = <1>;
-
-						dmic2_dap_ep: endpoint {
-							/* Placeholder for external Codec */
-						};
-					};
-				};
-			};
-
-			dmic@702d4200 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						dmic3_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dmic3_ep>;
-						};
-					};
-
-					dmic3_port: port@1 {
-						reg = <1>;
-
-						dmic3_dap_ep: endpoint {
-							/* Placeholder for external Codec */
-						};
-					};
-				};
-			};
-
 			sfc@702d2000 {
 				status = "okay";
 
@@ -436,56 +353,6 @@ sfc4_cif_out_ep: endpoint {
 				};
 			};
 
-			mvc@702da000 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						mvc1_cif_in_ep: endpoint {
-							remote-endpoint = <&xbar_mvc1_in_ep>;
-						};
-					};
-
-					mvc1_out_port: port@1 {
-						reg = <1>;
-
-						mvc1_cif_out_ep: endpoint {
-							remote-endpoint = <&xbar_mvc1_out_ep>;
-						};
-					};
-				};
-			};
-
-			mvc@702da200 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						mvc2_cif_in_ep: endpoint {
-							remote-endpoint = <&xbar_mvc2_in_ep>;
-						};
-					};
-
-					mvc2_out_port: port@1 {
-						reg = <1>;
-
-						mvc2_cif_out_ep: endpoint {
-							remote-endpoint = <&xbar_mvc2_out_ep>;
-						};
-					};
-				};
-			};
-
 			amx@702d3000 {
 				status = "okay";
 
@@ -682,6 +549,81 @@ adx2_out4_ep: endpoint {
 				};
 			};
 
+			dmic@702d4000 {
+				status = "okay";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						dmic1_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dmic1_ep>;
+						};
+					};
+
+					dmic1_port: port@1 {
+						reg = <1>;
+
+						dmic1_dap_ep: endpoint {
+							/* Placeholder for external Codec */
+						};
+					};
+				};
+			};
+
+			dmic@702d4100 {
+				status = "okay";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						dmic2_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dmic2_ep>;
+						};
+					};
+
+					dmic2_port: port@1 {
+						reg = <1>;
+
+						dmic2_dap_ep: endpoint {
+							/* Placeholder for external Codec */
+						};
+					};
+				};
+			};
+
+			dmic@702d4200 {
+				status = "okay";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						dmic3_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dmic3_ep>;
+						};
+					};
+
+					dmic3_port: port@1 {
+						reg = <1>;
+
+						dmic3_dap_ep: endpoint {
+							/* Placeholder for external Codec */
+						};
+					};
+				};
+			};
+
 			processing-engine@702d8000 {
 				status = "okay";
 
@@ -732,6 +674,56 @@ ope2_cif_out_ep: endpoint {
 				};
 			};
 
+			mvc@702da000 {
+				status = "okay";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						mvc1_cif_in_ep: endpoint {
+							remote-endpoint = <&xbar_mvc1_in_ep>;
+						};
+					};
+
+					mvc1_out_port: port@1 {
+						reg = <1>;
+
+						mvc1_cif_out_ep: endpoint {
+							remote-endpoint = <&xbar_mvc1_out_ep>;
+						};
+					};
+				};
+			};
+
+			mvc@702da200 {
+				status = "okay";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						mvc2_cif_in_ep: endpoint {
+							remote-endpoint = <&xbar_mvc2_in_ep>;
+						};
+					};
+
+					mvc2_out_port: port@1 {
+						reg = <1>;
+
+						mvc2_cif_out_ep: endpoint {
+							remote-endpoint = <&xbar_mvc2_out_ep>;
+						};
+					};
+				};
+			};
+
 			amixer@702dbb00 {
 				status = "okay";
 
@@ -1335,6 +1327,14 @@ xbar_ope2_out_ep: endpoint {
 				};
 			};
 		};
+
+		dma-controller@702e2000 {
+			status = "okay";
+		};
+
+		interrupt-controller@702f9000 {
+			status = "okay";
+		};
 	};
 
 	sound {
diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2595.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2595.dtsi
index 6ae292da72949..65181da730fa6 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2595.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2595.dtsi
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
+
+#include <dt-bindings/pinctrl/pinctrl-tegra.h>
+
 / {
 	model = "NVIDIA Tegra210 P2595 I/O board";
 	compatible = "nvidia,p2595", "nvidia,tegra210";
diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
index a87e103f3828d..b4a1108c2dd74 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1,5 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
+
+#include <dt-bindings/gpio/tegra-gpio.h>
 #include <dt-bindings/input/input.h>
+#include <dt-bindings/pinctrl/pinctrl-tegra.h>
 
 / {
 	model = "NVIDIA Tegra210 P2597 I/O board";
diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2894.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2894.dtsi
index 8e657b10569d6..1f263fd32a7a0 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2894.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2894.dtsi
@@ -1342,7 +1342,35 @@ pmic: pmic@3c {
 			pinctrl-names = "default";
 			pinctrl-0 = <&max77620_default>;
 
-			max77620_default: pinmux@0 {
+			fps {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				fps0 {
+					reg = <0>;
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+				};
+
+				fps1 {
+					reg = <1>;
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
+					maxim,device-state-on-disabled-event = <MAX77620_FPS_INACTIVE_STATE_SLEEP>;
+				};
+
+				fps2 {
+					reg = <2>;
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+				};
+			};
+
+			hog-0 {
+				gpio-hog;
+				output-high;
+				gpios = <2 GPIO_ACTIVE_HIGH>,
+					<7 GPIO_ACTIVE_HIGH>;
+			};
+
+			max77620_default: pinmux {
 				gpio0 {
 					pins = "gpio0";
 					function = "gpio";
@@ -1383,34 +1411,6 @@ gpio5_6_7 {
 				};
 			};
 
-			hog-0 {
-				gpio-hog;
-				output-high;
-				gpios = <2 GPIO_ACTIVE_HIGH>,
-					<7 GPIO_ACTIVE_HIGH>;
-			};
-
-			fps {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				fps0 {
-					reg = <0>;
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-				};
-
-				fps1 {
-					reg = <1>;
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
-					maxim,device-state-on-disabled-event = <MAX77620_FPS_INACTIVE_STATE_SLEEP>;
-				};
-
-				fps2 {
-					reg = <2>;
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-				};
-			};
-
 			regulators {
 				in-ldo0-1-supply = <&max77620_sd2>;
 				in-ldo7-8-supply = <&max77620_sd2>;
@@ -1592,20 +1592,6 @@ clk32k_in: clock-32k {
 		#clock-cells = <0>;
 	};
 
-	gpio-keys {
-		compatible = "gpio-keys";
-		status = "okay";
-
-		key-power {
-			debounce-interval = <30>;
-			gpios = <&gpio TEGRA_GPIO(X, 7) GPIO_ACTIVE_LOW>;
-			label = "Power";
-			linux,code = <KEY_POWER>;
-			wakeup-event-action = <EV_ACT_ASSERTED>;
-			wakeup-source;
-		};
-	};
-
 	cpus {
 		cpu@0 {
 			enable-method = "psci";
@@ -1630,6 +1616,20 @@ cpu-sleep {
 		};
 	};
 
+	gpio-keys {
+		compatible = "gpio-keys";
+		status = "okay";
+
+		key-power {
+			debounce-interval = <30>;
+			gpios = <&gpio TEGRA_GPIO(X, 7) GPIO_ACTIVE_LOW>;
+			label = "Power";
+			linux,code = <KEY_POWER>;
+			wakeup-event-action = <EV_ACT_ASSERTED>;
+			wakeup-source;
+		};
+	};
+
 	psci {
 		compatible = "arm,psci-1.0";
 		method = "smc";
diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts b/arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts
index 2041371ea7ff8..c9f488e14f377 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts
@@ -186,6 +186,22 @@ pmic: pmic@3c {
 			pinctrl-names = "default";
 			pinctrl-0 = <&max77620_default>;
 
+			fps {
+				fps0 {
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+					maxim,suspend-fps-time-period-us = <5120>;
+				};
+
+				fps1 {
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
+					maxim,suspend-fps-time-period-us = <5120>;
+				};
+
+				fps2 {
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+				};
+			};
+
 			max77620_default: pinmux {
 				gpio0 {
 					pins = "gpio0";
@@ -231,22 +247,6 @@ gpio5_6_7 {
 				};
 			};
 
-			fps {
-				fps0 {
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-					maxim,suspend-fps-time-period-us = <5120>;
-				};
-
-				fps1 {
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
-					maxim,suspend-fps-time-period-us = <5120>;
-				};
-
-				fps2 {
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-				};
-			};
-
 			regulators {
 				in-ldo0-1-supply = <&vdd_pre>;
 				in-ldo2-supply = <&vdd_3v3_sys>;
@@ -611,14 +611,6 @@ clock@70110000 {
 	aconnect@702c0000 {
 		status = "okay";
 
-		dma-controller@702e2000 {
-			status = "okay";
-		};
-
-		interrupt-controller@702f9000 {
-			status = "okay";
-		};
-
 		ahub@702d0800 {
 			status = "okay";
 
@@ -678,56 +670,6 @@ i2s4_dap_ep: endpoint {
 				};
 			};
 
-			dmic@702d4000 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						dmic1_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dmic1_ep>;
-						};
-					};
-
-					dmic1_port: port@1 {
-						reg = <1>;
-
-						dmic1_dap_ep: endpoint {
-							/* Placeholder for external Codec */
-						};
-					};
-				};
-			};
-
-			dmic@702d4100 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						dmic2_cif_ep: endpoint {
-							remote-endpoint = <&xbar_dmic2_ep>;
-						};
-					};
-
-					dmic2_port: port@1 {
-						reg = <1>;
-
-						dmic2_dap_ep: endpoint {
-							/* Placeholder for external Codec */
-						};
-					};
-				};
-			};
-
 			sfc@702d2000 {
 				status = "okay";
 
@@ -828,56 +770,6 @@ sfc4_cif_out_ep: endpoint {
 				};
 			};
 
-			mvc@702da000 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						mvc1_cif_in_ep: endpoint {
-							remote-endpoint = <&xbar_mvc1_in_ep>;
-						};
-					};
-
-					mvc1_out_port: port@1 {
-						reg = <1>;
-
-						mvc1_cif_out_ep: endpoint {
-							remote-endpoint = <&xbar_mvc1_out_ep>;
-						};
-					};
-				};
-			};
-
-			mvc@702da200 {
-				status = "okay";
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						mvc2_cif_in_ep: endpoint {
-							remote-endpoint = <&xbar_mvc2_in_ep>;
-						};
-					};
-
-					mvc2_out_port: port@1 {
-						reg = <1>;
-
-						mvc2_cif_out_ep: endpoint {
-							remote-endpoint = <&xbar_mvc2_out_ep>;
-						};
-					};
-				};
-			};
-
 			amx@702d3000 {
 				status = "okay";
 
@@ -1074,6 +966,56 @@ adx2_out4_ep: endpoint {
 				};
 			};
 
+			dmic@702d4000 {
+				status = "okay";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						dmic1_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dmic1_ep>;
+						};
+					};
+
+					dmic1_port: port@1 {
+						reg = <1>;
+
+						dmic1_dap_ep: endpoint {
+							/* Placeholder for external Codec */
+						};
+					};
+				};
+			};
+
+			dmic@702d4100 {
+				status = "okay";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						dmic2_cif_ep: endpoint {
+							remote-endpoint = <&xbar_dmic2_ep>;
+						};
+					};
+
+					dmic2_port: port@1 {
+						reg = <1>;
+
+						dmic2_dap_ep: endpoint {
+							/* Placeholder for external Codec */
+						};
+					};
+				};
+			};
+
 			processing-engine@702d8000 {
 				status = "okay";
 
@@ -1124,6 +1066,56 @@ ope2_cif_out_ep: endpoint {
 				};
 			};
 
+			mvc@702da000 {
+				status = "okay";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						mvc1_cif_in_ep: endpoint {
+							remote-endpoint = <&xbar_mvc1_in_ep>;
+						};
+					};
+
+					mvc1_out_port: port@1 {
+						reg = <1>;
+
+						mvc1_cif_out_ep: endpoint {
+							remote-endpoint = <&xbar_mvc1_out_ep>;
+						};
+					};
+				};
+			};
+
+			mvc@702da200 {
+				status = "okay";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+
+						mvc2_cif_in_ep: endpoint {
+							remote-endpoint = <&xbar_mvc2_in_ep>;
+						};
+					};
+
+					mvc2_out_port: port@1 {
+						reg = <1>;
+
+						mvc2_cif_out_ep: endpoint {
+							remote-endpoint = <&xbar_mvc2_out_ep>;
+						};
+					};
+				};
+			};
+
 			amixer@702dbb00 {
 				status = "okay";
 
@@ -1695,6 +1687,14 @@ xbar_ope2_out_ep: endpoint {
 				};
 			};
 		};
+
+		dma-controller@702e2000 {
+			status = "okay";
+		};
+
+		interrupt-controller@702f9000 {
+			status = "okay";
+		};
 	};
 
 	spi@70410000 {
@@ -1739,69 +1739,17 @@ cpu-sleep {
 		};
 	};
 
-	fan: pwm-fan {
-		compatible = "pwm-fan";
-		pwms = <&pwm 3 45334>;
-
-		cooling-levels = <0 64 128 255>;
-		#cooling-cells = <2>;
-	};
-
-	thermal-zones {
-		cpu-thermal {
-			trips {
-				cpu_trip_critical: critical {
-					temperature = <96500>;
-					hysteresis = <0>;
-					type = "critical";
-				};
-
-				cpu_trip_hot: hot {
-					temperature = <70000>;
-					hysteresis = <2000>;
-					type = "hot";
-				};
-
-				cpu_trip_active: active {
-					temperature = <50000>;
-					hysteresis = <2000>;
-					type = "active";
-				};
-
-				cpu_trip_passive: passive {
-					temperature = <30000>;
-					hysteresis = <2000>;
-					type = "passive";
-				};
-			};
-
-			cooling-maps {
-				cpu-critical {
-					cooling-device = <&fan 3 3>;
-					trip = <&cpu_trip_critical>;
-				};
-
-				cpu-hot {
-					cooling-device = <&fan 2 2>;
-					trip = <&cpu_trip_hot>;
-				};
-
-				cpu-active {
-					cooling-device = <&fan 1 1>;
-					trip = <&cpu_trip_active>;
-				};
-
-				cpu-passive {
-					cooling-device = <&fan 0 0>;
-					trip = <&cpu_trip_passive>;
-				};
-			};
-		};
-	};
-
 	gpio-keys {
 		compatible = "gpio-keys";
 
+		key-force-recovery {
+			label = "Force Recovery";
+			gpios = <&gpio TEGRA_GPIO(X, 6) GPIO_ACTIVE_LOW>;
+			linux,input-type = <EV_KEY>;
+			linux,code = <BTN_1>;
+			debounce-interval = <30>;
+		};
+
 		key-power {
 			label = "Power";
 			gpios = <&gpio TEGRA_GPIO(X, 5) GPIO_ACTIVE_LOW>;
@@ -1811,14 +1759,6 @@ key-power {
 			wakeup-event-action = <EV_ACT_ASSERTED>;
 			wakeup-source;
 		};
-
-		key-force-recovery {
-			label = "Force Recovery";
-			gpios = <&gpio TEGRA_GPIO(X, 6) GPIO_ACTIVE_LOW>;
-			linux,input-type = <EV_KEY>;
-			linux,code = <BTN_1>;
-			debounce-interval = <30>;
-		};
 	};
 
 	psci {
@@ -1826,6 +1766,14 @@ psci {
 		method = "smc";
 	};
 
+	fan: pwm-fan {
+		compatible = "pwm-fan";
+		pwms = <&pwm 3 45334>;
+
+		cooling-levels = <0 64 128 255>;
+		#cooling-cells = <2>;
+	};
+
 	vdd_5v0_sys: regulator-vdd-5v0-sys {
 		compatible = "regulator-fixed";
 
@@ -1986,4 +1934,56 @@ sound {
 
 		label = "NVIDIA Jetson Nano APE";
 	};
+
+	thermal-zones {
+		cpu-thermal {
+			trips {
+				cpu_trip_critical: critical {
+					temperature = <96500>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				cpu_trip_hot: hot {
+					temperature = <70000>;
+					hysteresis = <2000>;
+					type = "hot";
+				};
+
+				cpu_trip_active: active {
+					temperature = <50000>;
+					hysteresis = <2000>;
+					type = "active";
+				};
+
+				cpu_trip_passive: passive {
+					temperature = <30000>;
+					hysteresis = <2000>;
+					type = "passive";
+				};
+			};
+
+			cooling-maps {
+				cpu-critical {
+					cooling-device = <&fan 3 3>;
+					trip = <&cpu_trip_critical>;
+				};
+
+				cpu-hot {
+					cooling-device = <&fan 2 2>;
+					trip = <&cpu_trip_hot>;
+				};
+
+				cpu-active {
+					cooling-device = <&fan 1 1>;
+					trip = <&cpu_trip_active>;
+				};
+
+				cpu-passive {
+					cooling-device = <&fan 0 0>;
+					trip = <&cpu_trip_passive>;
+				};
+			};
+		};
+	};
 };
diff --git a/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts b/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
index 7c569695b7052..d7d7c63e62e25 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
@@ -1389,6 +1389,23 @@ pmic: pmic@3c {
 			pinctrl-names = "default";
 			pinctrl-0 = <&max77620_default>;
 
+			fps {
+				fps0 {
+					maxim,shutdown-fps-time-period-us = <5120>;
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+				};
+
+				fps1 {
+					maxim,shutdown-fps-time-period-us = <5120>;
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
+					maxim,device-state-on-disabled-event = <MAX77620_FPS_INACTIVE_STATE_SLEEP>;
+				};
+
+				fps2 {
+					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+				};
+			};
+
 			max77620_default: pinmux {
 				gpio0_1_2_7 {
 					pins = "gpio0", "gpio1", "gpio2", "gpio7";
@@ -1409,32 +1426,15 @@ gpio3 {
 					maxim,active-fps-power-down-slot = <2>;
 				};
 
-				gpio5_6 {
-					pins = "gpio5", "gpio6";
-					function = "gpio";
-					drive-push-pull = <1>;
-				};
-
 				gpio4 {
 					pins = "gpio4";
 					function = "32k-out1";
 				};
-			};
-
-			fps {
-				fps0 {
-					maxim,shutdown-fps-time-period-us = <5120>;
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
-				};
-
-				fps1 {
-					maxim,shutdown-fps-time-period-us = <5120>;
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN1>;
-					maxim,device-state-on-disabled-event = <MAX77620_FPS_INACTIVE_STATE_SLEEP>;
-				};
 
-				fps2 {
-					maxim,fps-event-source = <MAX77620_FPS_EVENT_SRC_EN0>;
+				gpio5_6 {
+					pins = "gpio5", "gpio6";
+					function = "gpio";
+					drive-push-pull = <1>;
 				};
 			};
 
@@ -1800,6 +1800,18 @@ key-power {
 			wakeup-source;
 		};
 
+		key-volume-down {
+			label = "Volume Down";
+			gpios = <&gpio TEGRA_GPIO(X, 7) GPIO_ACTIVE_LOW>;
+			linux,code = <KEY_VOLUMEDOWN>;
+		};
+
+		key-volume-up {
+			label = "Volume Up";
+			gpios = <&gpio TEGRA_GPIO(M, 4) GPIO_ACTIVE_LOW>;
+			linux,code = <KEY_VOLUMEUP>;
+		};
+
 		switch-lid {
 			label = "Lid";
 			gpios = <&gpio TEGRA_GPIO(B, 4) GPIO_ACTIVE_LOW>;
@@ -1815,18 +1827,6 @@ switch-tablet-mode {
 			linux,code = <SW_TABLET_MODE>;
 			wakeup-source;
 		};
-
-		key-volume-down {
-			label = "Volume Down";
-			gpios = <&gpio TEGRA_GPIO(X, 7) GPIO_ACTIVE_LOW>;
-			linux,code = <KEY_VOLUMEDOWN>;
-		};
-
-		key-volume-up {
-			label = "Volume Up";
-			gpios = <&gpio TEGRA_GPIO(M, 4) GPIO_ACTIVE_LOW>;
-			linux,code = <KEY_VOLUMEUP>;
-		};
 	};
 
 	max98357a {
diff --git a/arch/arm64/boot/dts/nvidia/tegra210.dtsi b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
index bc0cacb20d7a3..980565bf02c9d 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -555,19 +555,19 @@ pinmux: pinmux@700008d4 {
 		reg = <0x0 0x700008d4 0x0 0x29c>, /* Pad control registers */
 		      <0x0 0x70003000 0x0 0x294>; /* Mux registers */
 
-		sdmmc1_3v3_drv: pinmux-sdmmc1-3v3-drv {
+		sdmmc1_1v8_drv: pinmux-sdmmc1-1v8-drv {
 			sdmmc1 {
 				nvidia,pins = "drive_sdmmc1";
-				nvidia,pull-down-strength = <0x8>;
-				nvidia,pull-up-strength = <0x8>;
+				nvidia,pull-down-strength = <0x4>;
+				nvidia,pull-up-strength = <0x3>;
 			};
 		};
 
-		sdmmc1_1v8_drv: pinmux-sdmmc1-1v8-drv {
+		sdmmc1_3v3_drv: pinmux-sdmmc1-3v3-drv {
 			sdmmc1 {
 				nvidia,pins = "drive_sdmmc1";
-				nvidia,pull-down-strength = <0x4>;
-				nvidia,pull-up-strength = <0x3>;
+				nvidia,pull-down-strength = <0x8>;
+				nvidia,pull-up-strength = <0x8>;
 			};
 		};
 
@@ -579,19 +579,19 @@ sdmmc2 {
 			};
 		};
 
-		sdmmc3_3v3_drv: pinmux-sdmmc3-3v3-drv {
+		sdmmc3_1v8_drv: pinmux-sdmmc3-1v8-drv {
 			sdmmc3 {
 				nvidia,pins = "drive_sdmmc3";
-				nvidia,pull-down-strength = <0x8>;
-				nvidia,pull-up-strength = <0x8>;
+				nvidia,pull-down-strength = <0x4>;
+				nvidia,pull-up-strength = <0x3>;
 			};
 		};
 
-		sdmmc3_1v8_drv: pinmux-sdmmc3-1v8-drv {
+		sdmmc3_3v3_drv: pinmux-sdmmc3-3v3-drv {
 			sdmmc3 {
 				nvidia,pins = "drive_sdmmc3";
-				nvidia,pull-down-strength = <0x4>;
-				nvidia,pull-up-strength = <0x3>;
+				nvidia,pull-down-strength = <0x8>;
+				nvidia,pull-up-strength = <0x8>;
 			};
 		};
 
@@ -852,6 +852,38 @@ tegra_pmc: pmc@7000e400 {
 		#interrupt-cells = <2>;
 		interrupt-controller;
 
+		pinmux {
+			pex_dpd_disable: pex-dpd-disable {
+				pins = "pex-bias", "pex-clk1", "pex-clk2";
+				low-power-disable;
+			};
+
+			pex_dpd_enable: pex-dpd-enable {
+				pins = "pex-bias", "pex-clk1", "pex-clk2";
+				low-power-enable;
+			};
+
+			sdmmc1_1v8: sdmmc1-1v8 {
+				pins = "sdmmc1";
+				power-source = <TEGRA_IO_PAD_VOLTAGE_1V8>;
+			};
+
+			sdmmc1_3v3: sdmmc1-3v3 {
+				pins = "sdmmc1";
+				power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
+			};
+
+			sdmmc3_1v8: sdmmc3-1v8 {
+				pins = "sdmmc3";
+				power-source = <TEGRA_IO_PAD_VOLTAGE_1V8>;
+			};
+
+			sdmmc3_3v3: sdmmc3-3v3 {
+				pins = "sdmmc3";
+				power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
+			};
+		};
+
 		powergates {
 			pd_audio: aud {
 				clocks = <&tegra_car TEGRA210_CLK_APE>,
@@ -881,21 +913,12 @@ pd_sor: sor {
 				#power-domain-cells = <0>;
 			};
 
-			pd_xusbss: xusba {
-				clocks = <&tegra_car TEGRA210_CLK_XUSB_SS>;
-				resets = <&tegra_car TEGRA210_CLK_XUSB_SS>;
-				#power-domain-cells = <0>;
-			};
-
-			pd_xusbdev: xusbb {
-				clocks = <&tegra_car TEGRA210_CLK_XUSB_DEV>;
-				resets = <&tegra_car 95>;
-				#power-domain-cells = <0>;
-			};
-
-			pd_xusbhost: xusbc {
-				clocks = <&tegra_car TEGRA210_CLK_XUSB_HOST>;
-				resets = <&tegra_car TEGRA210_CLK_XUSB_HOST>;
+			pd_venc: venc {
+				clocks = <&tegra_car TEGRA210_CLK_VI>,
+					 <&tegra_car TEGRA210_CLK_CSI>;
+				resets = <&mc TEGRA210_MC_RESET_VI>,
+					 <&tegra_car 20>,
+					 <&tegra_car 52>;
 				#power-domain-cells = <0>;
 			};
 
@@ -907,45 +930,22 @@ pd_vic: vic {
 				#power-domain-cells = <0>;
 			};
 
-			pd_venc: venc {
-				clocks = <&tegra_car TEGRA210_CLK_VI>,
-					 <&tegra_car TEGRA210_CLK_CSI>;
-				resets = <&mc TEGRA210_MC_RESET_VI>,
-					 <&tegra_car 20>,
-					 <&tegra_car 52>;
+			pd_xusbss: xusba {
+				clocks = <&tegra_car TEGRA210_CLK_XUSB_SS>;
+				resets = <&tegra_car TEGRA210_CLK_XUSB_SS>;
 				#power-domain-cells = <0>;
 			};
-		};
-
-		pinmux {
-			sdmmc1_3v3: sdmmc1-3v3 {
-				pins = "sdmmc1";
-				power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
-			};
-
-			sdmmc1_1v8: sdmmc1-1v8 {
-				pins = "sdmmc1";
-				power-source = <TEGRA_IO_PAD_VOLTAGE_1V8>;
-			};
 
-			sdmmc3_3v3: sdmmc3-3v3 {
-				pins = "sdmmc3";
-				power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
-			};
-
-			sdmmc3_1v8: sdmmc3-1v8 {
-				pins = "sdmmc3";
-				power-source = <TEGRA_IO_PAD_VOLTAGE_1V8>;
-			};
-
-			pex_dpd_disable: pex-dpd-disable {
-				pins = "pex-bias", "pex-clk1", "pex-clk2";
-				low-power-disable;
+			pd_xusbdev: xusbb {
+				clocks = <&tegra_car TEGRA210_CLK_XUSB_DEV>;
+				resets = <&tegra_car 95>;
+				#power-domain-cells = <0>;
 			};
 
-			pex_dpd_enable: pex-dpd-enable {
-				pins = "pex-bias", "pex-clk1", "pex-clk2";
-				low-power-enable;
+			pd_xusbhost: xusbc {
+				clocks = <&tegra_car TEGRA210_CLK_XUSB_HOST>;
+				resets = <&tegra_car TEGRA210_CLK_XUSB_HOST>;
+				#power-domain-cells = <0>;
 			};
 		};
 	};
@@ -1388,50 +1388,6 @@ aconnect@702c0000 {
 		ranges = <0x702c0000 0x0 0x702c0000 0x00040000>;
 		status = "disabled";
 
-		adma: dma-controller@702e2000 {
-			compatible = "nvidia,tegra210-adma";
-			reg = <0x702e2000 0x2000>;
-			interrupt-parent = <&agic>;
-			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
-			#dma-cells = <1>;
-			clocks = <&tegra_car TEGRA210_CLK_D_AUDIO>;
-			clock-names = "d_audio";
-			status = "disabled";
-		};
-
-		agic: interrupt-controller@702f9000 {
-			compatible = "nvidia,tegra210-agic";
-			#interrupt-cells = <3>;
-			interrupt-controller;
-			reg = <0x702f9000 0x1000>,
-			      <0x702fa000 0x2000>;
-			interrupts = <GIC_SPI 102 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
-			clocks = <&tegra_car TEGRA210_CLK_APE>;
-			clock-names = "clk";
-			status = "disabled";
-		};
-
 		tegra_ahub: ahub@702d0800 {
 			compatible = "nvidia,tegra210-ahub";
 			reg = <0x702d0800 0x800>;
@@ -1620,42 +1576,6 @@ tegra_i2s5: i2s@702d1400 {
 				status = "disabled";
 			};
 
-			tegra_dmic1: dmic@702d4000 {
-				compatible = "nvidia,tegra210-dmic";
-				reg = <0x702d4000 0x100>;
-				clocks = <&tegra_car TEGRA210_CLK_DMIC1>;
-				clock-names = "dmic";
-				assigned-clocks = <&tegra_car TEGRA210_CLK_DMIC1>;
-				assigned-clock-parents = <&tegra_car TEGRA210_CLK_PLL_A_OUT0>;
-				assigned-clock-rates = <3072000>;
-				sound-name-prefix = "DMIC1";
-				status = "disabled";
-			};
-
-			tegra_dmic2: dmic@702d4100 {
-				compatible = "nvidia,tegra210-dmic";
-				reg = <0x702d4100 0x100>;
-				clocks = <&tegra_car TEGRA210_CLK_DMIC2>;
-				clock-names = "dmic";
-				assigned-clocks = <&tegra_car TEGRA210_CLK_DMIC2>;
-				assigned-clock-parents = <&tegra_car TEGRA210_CLK_PLL_A_OUT0>;
-				assigned-clock-rates = <3072000>;
-				sound-name-prefix = "DMIC2";
-				status = "disabled";
-			};
-
-			tegra_dmic3: dmic@702d4200 {
-				compatible = "nvidia,tegra210-dmic";
-				reg = <0x702d4200 0x100>;
-				clocks = <&tegra_car TEGRA210_CLK_DMIC3>;
-				clock-names = "dmic";
-				assigned-clocks = <&tegra_car TEGRA210_CLK_DMIC3>;
-				assigned-clock-parents = <&tegra_car TEGRA210_CLK_PLL_A_OUT0>;
-				assigned-clock-rates = <3072000>;
-				sound-name-prefix = "DMIC3";
-				status = "disabled";
-			};
-
 			tegra_sfc1: sfc@702d2000 {
 				compatible = "nvidia,tegra210-sfc";
 				reg = <0x702d2000 0x200>;
@@ -1684,20 +1604,6 @@ tegra_sfc4: sfc@702d2600 {
 				status = "disabled";
 			};
 
-			tegra_mvc1: mvc@702da000 {
-				compatible = "nvidia,tegra210-mvc";
-				reg = <0x702da000 0x200>;
-				sound-name-prefix = "MVC1";
-				status = "disabled";
-			};
-
-			tegra_mvc2: mvc@702da200 {
-				compatible = "nvidia,tegra210-mvc";
-				reg = <0x702da200 0x200>;
-				sound-name-prefix = "MVC2";
-				status = "disabled";
-			};
-
 			tegra_amx1: amx@702d3000 {
 				compatible = "nvidia,tegra210-amx";
 				reg = <0x702d3000 0x100>;
@@ -1726,6 +1632,42 @@ tegra_adx2: adx@702d3900 {
 				status = "disabled";
 			};
 
+			tegra_dmic1: dmic@702d4000 {
+				compatible = "nvidia,tegra210-dmic";
+				reg = <0x702d4000 0x100>;
+				clocks = <&tegra_car TEGRA210_CLK_DMIC1>;
+				clock-names = "dmic";
+				assigned-clocks = <&tegra_car TEGRA210_CLK_DMIC1>;
+				assigned-clock-parents = <&tegra_car TEGRA210_CLK_PLL_A_OUT0>;
+				assigned-clock-rates = <3072000>;
+				sound-name-prefix = "DMIC1";
+				status = "disabled";
+			};
+
+			tegra_dmic2: dmic@702d4100 {
+				compatible = "nvidia,tegra210-dmic";
+				reg = <0x702d4100 0x100>;
+				clocks = <&tegra_car TEGRA210_CLK_DMIC2>;
+				clock-names = "dmic";
+				assigned-clocks = <&tegra_car TEGRA210_CLK_DMIC2>;
+				assigned-clock-parents = <&tegra_car TEGRA210_CLK_PLL_A_OUT0>;
+				assigned-clock-rates = <3072000>;
+				sound-name-prefix = "DMIC2";
+				status = "disabled";
+			};
+
+			tegra_dmic3: dmic@702d4200 {
+				compatible = "nvidia,tegra210-dmic";
+				reg = <0x702d4200 0x100>;
+				clocks = <&tegra_car TEGRA210_CLK_DMIC3>;
+				clock-names = "dmic";
+				assigned-clocks = <&tegra_car TEGRA210_CLK_DMIC3>;
+				assigned-clock-parents = <&tegra_car TEGRA210_CLK_PLL_A_OUT0>;
+				assigned-clock-rates = <3072000>;
+				sound-name-prefix = "DMIC3";
+				status = "disabled";
+			};
+
 			tegra_ope1: processing-engine@702d8000 {
 				compatible = "nvidia,tegra210-ope";
 				reg = <0x702d8000 0x100>;
@@ -1766,6 +1708,20 @@ dynamic-range-compressor@702d8600 {
 				};
 			};
 
+			tegra_mvc1: mvc@702da000 {
+				compatible = "nvidia,tegra210-mvc";
+				reg = <0x702da000 0x200>;
+				sound-name-prefix = "MVC1";
+				status = "disabled";
+			};
+
+			tegra_mvc2: mvc@702da200 {
+				compatible = "nvidia,tegra210-mvc";
+				reg = <0x702da200 0x200>;
+				sound-name-prefix = "MVC2";
+				status = "disabled";
+			};
+
 			tegra_amixer: amixer@702dbb00 {
 				compatible = "nvidia,tegra210-amixer";
 				reg = <0x702dbb00 0x800>;
@@ -1856,6 +1812,50 @@ xbar_admaif10_ep: endpoint {
 				};
 			};
 		};
+
+		adma: dma-controller@702e2000 {
+			compatible = "nvidia,tegra210-adma";
+			reg = <0x702e2000 0x2000>;
+			interrupt-parent = <&agic>;
+			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			clocks = <&tegra_car TEGRA210_CLK_D_AUDIO>;
+			clock-names = "d_audio";
+			status = "disabled";
+		};
+
+		agic: interrupt-controller@702f9000 {
+			compatible = "nvidia,tegra210-agic";
+			#interrupt-cells = <3>;
+			interrupt-controller;
+			reg = <0x702f9000 0x1000>,
+			      <0x702fa000 0x2000>;
+			interrupts = <GIC_SPI 102 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
+			clocks = <&tegra_car TEGRA210_CLK_APE>;
+			clock-names = "clk";
+			status = "disabled";
+		};
 	};
 
 	spi@70410000 {
diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3701-0000.dtsi b/arch/arm64/boot/dts/nvidia/tegra234-p3701-0000.dtsi
index 8b86ea9cb50c1..07aa5dc83fc6b 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3701-0000.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3701-0000.dtsi
@@ -6,41 +6,6 @@ / {
 	model = "NVIDIA Jetson AGX Orin";
 	compatible = "nvidia,p3701-0000", "nvidia,tegra234";
 
-	vdd_1v8_ls: regulator-vdd-1v8-ls {
-		compatible = "regulator-fixed";
-		regulator-name = "VDD_1V8_LS";
-		regulator-min-microvolt = <1800000>;
-		regulator-max-microvolt = <1800000>;
-		regulator-always-on;
-	};
-
-	vdd_1v8_ao: regulator-vdd-1v8-ao {
-		compatible = "regulator-fixed";
-		regulator-name = "VDD_1V8_AO";
-		regulator-min-microvolt = <1800000>;
-		regulator-max-microvolt = <1800000>;
-		regulator-always-on;
-	};
-
-	vdd_3v3_pcie: regulator-vdd-3v3-pcie {
-		compatible = "regulator-fixed";
-		regulator-name = "VDD_3V3_PCIE";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-		gpio = <&gpio TEGRA234_MAIN_GPIO(Z, 2) GPIO_ACTIVE_HIGH>;
-		regulator-boot-on;
-		enable-active-high;
-	};
-
-	vdd_12v_pcie: regulator-vdd-12v-pcie {
-		compatible = "regulator-fixed";
-		regulator-name = "VDD_12V_PCIE";
-		regulator-min-microvolt = <12000000>;
-		regulator-max-microvolt = <12000000>;
-		gpio = <&gpio TEGRA234_MAIN_GPIO(A, 1) GPIO_ACTIVE_LOW>;
-		regulator-boot-on;
-	};
-
 	bus@0 {
 		spi@3270000 {
 			status = "okay";
@@ -75,4 +40,39 @@ pmc@c360000 {
 			nvidia,invert-interrupt;
 		};
 	};
+
+	vdd_1v8_ls: regulator-vdd-1v8-ls {
+		compatible = "regulator-fixed";
+		regulator-name = "VDD_1V8_LS";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		regulator-always-on;
+	};
+
+	vdd_1v8_ao: regulator-vdd-1v8-ao {
+		compatible = "regulator-fixed";
+		regulator-name = "VDD_1V8_AO";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		regulator-always-on;
+	};
+
+	vdd_3v3_pcie: regulator-vdd-3v3-pcie {
+		compatible = "regulator-fixed";
+		regulator-name = "VDD_3V3_PCIE";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio TEGRA234_MAIN_GPIO(Z, 2) GPIO_ACTIVE_HIGH>;
+		regulator-boot-on;
+		enable-active-high;
+	};
+
+	vdd_12v_pcie: regulator-vdd-12v-pcie {
+		compatible = "regulator-fixed";
+		regulator-name = "VDD_12V_PCIE";
+		regulator-min-microvolt = <12000000>;
+		regulator-max-microvolt = <12000000>;
+		gpio = <&gpio TEGRA234_MAIN_GPIO(A, 1) GPIO_ACTIVE_LOW>;
+		regulator-boot-on;
+	};
 };
diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
index 431f42a266f5b..a4d1be2d32929 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
@@ -17,6 +17,11 @@ aliases {
 		serial1 = &uarta;
 	};
 
+	chosen {
+		bootargs = "console=ttyTCU0,115200n8";
+		stdout-path = "serial0:115200n8";
+	};
+
 	bus@0 {
 		aconnect@2900000 {
 			status = "okay";
@@ -24,997 +29,1001 @@ aconnect@2900000 {
 			ahub@2900800 {
 				status = "okay";
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
+				i2s@2901000 {
+					status = "okay";
 
-					port@0 {
-						reg = <0x0>;
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-						xbar_admaif0: endpoint {
-							remote-endpoint = <&admaif0>;
+						port@0 {
+							reg = <0>;
+
+							i2s1_cif: endpoint {
+								remote-endpoint = <&xbar_i2s1>;
+							};
 						};
-					};
 
-					port@1 {
-						reg = <0x1>;
+						i2s1_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif1: endpoint {
-							remote-endpoint = <&admaif1>;
+							i2s1_dap: endpoint {
+								dai-format = "i2s";
+								/* placeholder for external codec */
+							};
 						};
 					};
+				};
 
-					port@2 {
-						reg = <0x2>;
+				i2s@2901100 {
+					status = "okay";
 
-						xbar_admaif2: endpoint {
-							remote-endpoint = <&admaif2>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@3 {
-						reg = <0x3>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif3: endpoint {
-							remote-endpoint = <&admaif3>;
+							i2s2_cif: endpoint {
+								remote-endpoint = <&xbar_i2s2>;
+							};
 						};
-					};
 
-					port@4 {
-						reg = <0x4>;
+						i2s2_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif4: endpoint {
-							remote-endpoint = <&admaif4>;
+							i2s2_dap: endpoint {
+								dai-format = "i2s";
+								/* placeholder for external codec */
+							};
 						};
 					};
+				};
 
-					port@5 {
-						reg = <0x5>;
+				i2s@2901300 {
+					status = "okay";
 
-						xbar_admaif5: endpoint {
-							remote-endpoint = <&admaif5>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@6 {
-						reg = <0x6>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif6: endpoint {
-							remote-endpoint = <&admaif6>;
+							i2s4_cif: endpoint {
+								remote-endpoint = <&xbar_i2s4>;
+							};
 						};
-					};
 
-					port@7 {
-						reg = <0x7>;
+						i2s4_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif7: endpoint {
-							remote-endpoint = <&admaif7>;
+							i2s4_dap: endpoint {
+								dai-format = "i2s";
+								/* placeholder for external codec */
+							};
 						};
 					};
+				};
 
-					port@8 {
-						reg = <0x8>;
+				i2s@2901500 {
+					status = "okay";
 
-						xbar_admaif8: endpoint {
-							remote-endpoint = <&admaif8>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@9 {
-						reg = <0x9>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif9: endpoint {
-							remote-endpoint = <&admaif9>;
+							i2s6_cif: endpoint {
+								remote-endpoint = <&xbar_i2s6>;
+							};
 						};
-					};
 
-					port@a {
-						reg = <0xa>;
+						i2s6_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif10: endpoint {
-							remote-endpoint = <&admaif10>;
+							i2s6_dap: endpoint {
+								dai-format = "i2s";
+								/* placeholder for external codec */
+							};
 						};
 					};
+				};
 
-					port@b {
-						reg = <0xb>;
+				sfc@2902000 {
+					status = "okay";
 
-						xbar_admaif11: endpoint {
-							remote-endpoint = <&admaif11>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@c {
-						reg = <0xc>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif12: endpoint {
-							remote-endpoint = <&admaif12>;
+							sfc1_cif_in: endpoint {
+								remote-endpoint = <&xbar_sfc1_in>;
+							};
 						};
-					};
 
-					port@d {
-						reg = <0xd>;
+						sfc1_out_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif13: endpoint {
-							remote-endpoint = <&admaif13>;
+							sfc1_cif_out: endpoint {
+								remote-endpoint = <&xbar_sfc1_out>;
+							};
 						};
 					};
+				};
 
-					port@e {
-						reg = <0xe>;
+				sfc@2902200 {
+					status = "okay";
 
-						xbar_admaif14: endpoint {
-							remote-endpoint = <&admaif14>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@f {
-						reg = <0xf>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif15: endpoint {
-							remote-endpoint = <&admaif15>;
+							sfc2_cif_in: endpoint {
+								remote-endpoint = <&xbar_sfc2_in>;
+							};
 						};
-					};
 
-					port@10 {
-						reg = <0x10>;
+						sfc2_out_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif16: endpoint {
-							remote-endpoint = <&admaif16>;
+							sfc2_cif_out: endpoint {
+								remote-endpoint = <&xbar_sfc2_out>;
+							};
 						};
 					};
+				};
 
-					port@11 {
-						reg = <0x11>;
+				sfc@2902400 {
+					status = "okay";
 
-						xbar_admaif17: endpoint {
-							remote-endpoint = <&admaif17>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@12 {
-						reg = <0x12>;
+						port@0 {
+							reg = <0>;
 
-						xbar_admaif18: endpoint {
-							remote-endpoint = <&admaif18>;
+							sfc3_cif_in: endpoint {
+								remote-endpoint = <&xbar_sfc3_in>;
+							};
 						};
-					};
 
-					port@13 {
-						reg = <0x13>;
+						sfc3_out_port: port@1 {
+							reg = <1>;
 
-						xbar_admaif19: endpoint {
-							remote-endpoint = <&admaif19>;
+							sfc3_cif_out: endpoint {
+								remote-endpoint = <&xbar_sfc3_out>;
+							};
 						};
 					};
+				};
 
-					xbar_i2s1_port: port@14 {
-						reg = <0x14>;
+				sfc@2902600 {
+					status = "okay";
 
-						xbar_i2s1: endpoint {
-							remote-endpoint = <&i2s1_cif>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_i2s2_port: port@15 {
-						reg = <0x15>;
+						port@0 {
+							reg = <0>;
 
-						xbar_i2s2: endpoint {
-							remote-endpoint = <&i2s2_cif>;
+							sfc4_cif_in: endpoint {
+								remote-endpoint = <&xbar_sfc4_in>;
+							};
 						};
-					};
 
-					xbar_i2s4_port: port@17 {
-						reg = <0x17>;
+						sfc4_out_port: port@1 {
+							reg = <1>;
 
-						xbar_i2s4: endpoint {
-							remote-endpoint = <&i2s4_cif>;
+							sfc4_cif_out: endpoint {
+								remote-endpoint = <&xbar_sfc4_out>;
+							};
 						};
 					};
+				};
 
-					xbar_i2s6_port: port@19 {
-						reg = <0x19>;
-
-						xbar_i2s6: endpoint {
-							remote-endpoint = <&i2s6_cif>;
-						};
-					};
-
-					xbar_dmic3_port: port@1c {
-						reg = <0x1c>;
-
-						xbar_dmic3: endpoint {
-							remote-endpoint = <&dmic3_cif>;
-						};
-					};
-
-					xbar_sfc1_in_port: port@20 {
-						reg = <0x20>;
+				amx@2903000 {
+					status = "okay";
 
-						xbar_sfc1_in: endpoint {
-							remote-endpoint = <&sfc1_cif_in>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@21 {
-						reg = <0x21>;
+						port@0 {
+							reg = <0>;
 
-						xbar_sfc1_out: endpoint {
-							remote-endpoint = <&sfc1_cif_out>;
+							amx1_in1: endpoint {
+								remote-endpoint = <&xbar_amx1_in1>;
+							};
 						};
-					};
 
-					xbar_sfc2_in_port: port@22 {
-						reg = <0x22>;
+						port@1 {
+							reg = <1>;
 
-						xbar_sfc2_in: endpoint {
-							remote-endpoint = <&sfc2_cif_in>;
+							amx1_in2: endpoint {
+								remote-endpoint = <&xbar_amx1_in2>;
+							};
 						};
-					};
 
-					port@23 {
-						reg = <0x23>;
+						port@2 {
+							reg = <2>;
 
-						xbar_sfc2_out: endpoint {
-							remote-endpoint = <&sfc2_cif_out>;
+							amx1_in3: endpoint {
+								remote-endpoint = <&xbar_amx1_in3>;
+							};
 						};
-					};
 
-					xbar_sfc3_in_port: port@24 {
-						reg = <0x24>;
+						port@3 {
+							reg = <3>;
 
-						xbar_sfc3_in: endpoint {
-							remote-endpoint = <&sfc3_cif_in>;
+							amx1_in4: endpoint {
+								remote-endpoint = <&xbar_amx1_in4>;
+							};
 						};
-					};
 
-					port@25 {
-						reg = <0x25>;
+						amx1_out_port: port@4 {
+							reg = <4>;
 
-						xbar_sfc3_out: endpoint {
-							remote-endpoint = <&sfc3_cif_out>;
+							amx1_out: endpoint {
+								remote-endpoint = <&xbar_amx1_out>;
+							};
 						};
 					};
+				};
 
-					xbar_sfc4_in_port: port@26 {
-						reg = <0x26>;
+				amx@2903100 {
+					status = "okay";
 
-						xbar_sfc4_in: endpoint {
-							remote-endpoint = <&sfc4_cif_in>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@27 {
-						reg = <0x27>;
+						port@0 {
+							reg = <0>;
 
-						xbar_sfc4_out: endpoint {
-							remote-endpoint = <&sfc4_cif_out>;
+							amx2_in1: endpoint {
+								remote-endpoint = <&xbar_amx2_in1>;
+							};
 						};
-					};
 
-					xbar_mvc1_in_port: port@28 {
-						reg = <0x28>;
+						port@1 {
+							reg = <1>;
 
-						xbar_mvc1_in: endpoint {
-							remote-endpoint = <&mvc1_cif_in>;
+							amx2_in2: endpoint {
+								remote-endpoint = <&xbar_amx2_in2>;
+							};
 						};
-					};
 
-					port@29 {
-						reg = <0x29>;
+						port@2 {
+							reg = <2>;
 
-						xbar_mvc1_out: endpoint {
-							remote-endpoint = <&mvc1_cif_out>;
+							amx2_in3: endpoint {
+								remote-endpoint = <&xbar_amx2_in3>;
+							};
 						};
-					};
 
-					xbar_mvc2_in_port: port@2a {
-						reg = <0x2a>;
+						port@3 {
+							reg = <3>;
 
-						xbar_mvc2_in: endpoint {
-							remote-endpoint = <&mvc2_cif_in>;
+							amx2_in4: endpoint {
+								remote-endpoint = <&xbar_amx2_in4>;
+							};
 						};
-					};
 
-					port@2b {
-						reg = <0x2b>;
+						amx2_out_port: port@4 {
+							reg = <4>;
 
-						xbar_mvc2_out: endpoint {
-							remote-endpoint = <&mvc2_cif_out>;
+							amx2_out: endpoint {
+								remote-endpoint = <&xbar_amx2_out>;
+							};
 						};
 					};
+				};
 
-					xbar_amx1_in1_port: port@2c {
-						reg = <0x2c>;
+				amx@2903200 {
+					status = "okay";
 
-						xbar_amx1_in1: endpoint {
-							remote-endpoint = <&amx1_in1>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_amx1_in2_port: port@2d {
-						reg = <0x2d>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx1_in2: endpoint {
-							remote-endpoint = <&amx1_in2>;
+							amx3_in1: endpoint {
+								remote-endpoint = <&xbar_amx3_in1>;
+							};
 						};
-					};
 
-					xbar_amx1_in3_port: port@2e {
-						reg = <0x2e>;
+						port@1 {
+							reg = <1>;
 
-						xbar_amx1_in3: endpoint {
-							remote-endpoint = <&amx1_in3>;
+							amx3_in2: endpoint {
+								remote-endpoint = <&xbar_amx3_in2>;
+							};
 						};
-					};
 
-					xbar_amx1_in4_port: port@2f {
-						reg = <0x2f>;
+						port@2 {
+							reg = <2>;
 
-						xbar_amx1_in4: endpoint {
-							remote-endpoint = <&amx1_in4>;
+							amx3_in3: endpoint {
+								remote-endpoint = <&xbar_amx3_in3>;
+							};
 						};
-					};
 
-					port@30 {
-						reg = <0x30>;
+						port@3 {
+							reg = <3>;
 
-						xbar_amx1_out: endpoint {
-							remote-endpoint = <&amx1_out>;
+							amx3_in4: endpoint {
+								remote-endpoint = <&xbar_amx3_in4>;
+							};
 						};
-					};
 
-					xbar_amx2_in1_port: port@31 {
-						reg = <0x31>;
+						amx3_out_port: port@4 {
+							reg = <4>;
 
-						xbar_amx2_in1: endpoint {
-							remote-endpoint = <&amx2_in1>;
+							amx3_out: endpoint {
+								remote-endpoint = <&xbar_amx3_out>;
+							};
 						};
 					};
+				};
 
-					xbar_amx2_in2_port: port@32 {
-						reg = <0x32>;
+				amx@2903300 {
+					status = "okay";
 
-						xbar_amx2_in2: endpoint {
-							remote-endpoint = <&amx2_in2>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_amx2_in3_port: port@33 {
-						reg = <0x33>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx2_in3: endpoint {
-							remote-endpoint = <&amx2_in3>;
+							amx4_in1: endpoint {
+								remote-endpoint = <&xbar_amx4_in1>;
+							};
 						};
-					};
 
-					xbar_amx2_in4_port: port@34 {
-						reg = <0x34>;
+						port@1 {
+							reg = <1>;
 
-						xbar_amx2_in4: endpoint {
-							remote-endpoint = <&amx2_in4>;
+							amx4_in2: endpoint {
+								remote-endpoint = <&xbar_amx4_in2>;
+							};
 						};
-					};
 
-					port@35 {
-						reg = <0x35>;
+						port@2 {
+							reg = <2>;
 
-						xbar_amx2_out: endpoint {
-							remote-endpoint = <&amx2_out>;
+							amx4_in3: endpoint {
+								remote-endpoint = <&xbar_amx4_in3>;
+							};
 						};
-					};
 
-					xbar_amx3_in1_port: port@36 {
-						reg = <0x36>;
+						port@3 {
+							reg = <3>;
 
-						xbar_amx3_in1: endpoint {
-							remote-endpoint = <&amx3_in1>;
+							amx4_in4: endpoint {
+								remote-endpoint = <&xbar_amx4_in4>;
+							};
 						};
-					};
 
-					xbar_amx3_in2_port: port@37 {
-						reg = <0x37>;
+						amx4_out_port: port@4 {
+							reg = <4>;
 
-						xbar_amx3_in2: endpoint {
-							remote-endpoint = <&amx3_in2>;
+							amx4_out: endpoint {
+								remote-endpoint = <&xbar_amx4_out>;
+							};
 						};
 					};
+				};
 
-					xbar_amx3_in3_port: port@38 {
-						reg = <0x38>;
+				adx@2903800 {
+					status = "okay";
 
-						xbar_amx3_in3: endpoint {
-							remote-endpoint = <&amx3_in3>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_amx3_in4_port: port@39 {
-						reg = <0x39>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx3_in4: endpoint {
-							remote-endpoint = <&amx3_in4>;
+							adx1_in: endpoint {
+								remote-endpoint = <&xbar_adx1_in>;
+							};
 						};
-					};
 
-					port@3a {
-						reg = <0x3a>;
+						adx1_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_amx3_out: endpoint {
-							remote-endpoint = <&amx3_out>;
+							adx1_out1: endpoint {
+								remote-endpoint = <&xbar_adx1_out1>;
+							};
 						};
-					};
 
-					xbar_amx4_in1_port: port@3b {
-						reg = <0x3b>;
+						adx1_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_amx4_in1: endpoint {
-							remote-endpoint = <&amx4_in1>;
+							adx1_out2: endpoint {
+								remote-endpoint = <&xbar_adx1_out2>;
+							};
 						};
-					};
 
-					xbar_amx4_in2_port: port@3c {
-						reg = <0x3c>;
+						adx1_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_amx4_in2: endpoint {
-							remote-endpoint = <&amx4_in2>;
+							adx1_out3: endpoint {
+								remote-endpoint = <&xbar_adx1_out3>;
+							};
 						};
-					};
 
-					xbar_amx4_in3_port: port@3d {
-						reg = <0x3d>;
+						adx1_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_amx4_in3: endpoint {
-							remote-endpoint = <&amx4_in3>;
+							adx1_out4: endpoint {
+								remote-endpoint = <&xbar_adx1_out4>;
+							};
 						};
 					};
+				};
 
-					xbar_amx4_in4_port: port@3e {
-						reg = <0x3e>;
+				adx@2903900 {
+					status = "okay";
 
-						xbar_amx4_in4: endpoint {
-							remote-endpoint = <&amx4_in4>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@3f {
-						reg = <0x3f>;
+						port@0 {
+							reg = <0>;
 
-						xbar_amx4_out: endpoint {
-							remote-endpoint = <&amx4_out>;
+							adx2_in: endpoint {
+								remote-endpoint = <&xbar_adx2_in>;
+							};
 						};
-					};
 
-					xbar_adx1_in_port: port@40 {
-						reg = <0x40>;
+						adx2_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_adx1_in: endpoint {
-							remote-endpoint = <&adx1_in>;
+							adx2_out1: endpoint {
+								remote-endpoint = <&xbar_adx2_out1>;
+							};
 						};
-					};
 
-					port@41 {
-						reg = <0x41>;
+						adx2_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_adx1_out1: endpoint {
-							remote-endpoint = <&adx1_out1>;
+							adx2_out2: endpoint {
+								remote-endpoint = <&xbar_adx2_out2>;
+							};
 						};
-					};
 
-					port@42 {
-						reg = <0x42>;
+						adx2_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_adx1_out2: endpoint {
-							remote-endpoint = <&adx1_out2>;
+							adx2_out3: endpoint {
+								remote-endpoint = <&xbar_adx2_out3>;
+							};
 						};
-					};
 
-					port@43 {
-						reg = <0x43>;
+						adx2_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_adx1_out3: endpoint {
-							remote-endpoint = <&adx1_out3>;
+							adx2_out4: endpoint {
+								remote-endpoint = <&xbar_adx2_out4>;
+							};
 						};
 					};
+				};
 
-					port@44 {
-						reg = <0x44>;
+				adx@2903a00 {
+					status = "okay";
 
-						xbar_adx1_out4: endpoint {
-							remote-endpoint = <&adx1_out4>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_adx2_in_port: port@45 {
-						reg = <0x45>;
+						port@0 {
+							reg = <0>;
 
-						xbar_adx2_in: endpoint {
-							remote-endpoint = <&adx2_in>;
+							adx3_in: endpoint {
+								remote-endpoint = <&xbar_adx3_in>;
+							};
 						};
-					};
 
-					port@46 {
-						reg = <0x46>;
+						adx3_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_adx2_out1: endpoint {
-							remote-endpoint = <&adx2_out1>;
+							adx3_out1: endpoint {
+								remote-endpoint = <&xbar_adx3_out1>;
+							};
 						};
-					};
 
-					port@47 {
-						reg = <0x47>;
+						adx3_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_adx2_out2: endpoint {
-							remote-endpoint = <&adx2_out2>;
+							adx3_out2: endpoint {
+								remote-endpoint = <&xbar_adx3_out2>;
+							};
 						};
-					};
 
-					port@48 {
-						reg = <0x48>;
+						adx3_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_adx2_out3: endpoint {
-							remote-endpoint = <&adx2_out3>;
+							adx3_out3: endpoint {
+								remote-endpoint = <&xbar_adx3_out3>;
+							};
 						};
-					};
 
-					port@49 {
-						reg = <0x49>;
+						adx3_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_adx2_out4: endpoint {
-							remote-endpoint = <&adx2_out4>;
+							adx3_out4: endpoint {
+								remote-endpoint = <&xbar_adx3_out4>;
+							};
 						};
 					};
+				};
 
-					xbar_adx3_in_port: port@4a {
-						reg = <0x4a>;
+				adx@2903b00 {
+					status = "okay";
 
-						xbar_adx3_in: endpoint {
-							remote-endpoint = <&adx3_in>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@4b {
-						reg = <0x4b>;
+						port@0 {
+							reg = <0>;
 
-						xbar_adx3_out1: endpoint {
-							remote-endpoint = <&adx3_out1>;
+							adx4_in: endpoint {
+								remote-endpoint = <&xbar_adx4_in>;
+							};
 						};
-					};
 
-					port@4c {
-						reg = <0x4c>;
+						adx4_out1_port: port@1 {
+							reg = <1>;
 
-						xbar_adx3_out2: endpoint {
-							remote-endpoint = <&adx3_out2>;
+							adx4_out1: endpoint {
+								remote-endpoint = <&xbar_adx4_out1>;
+							};
 						};
-					};
 
-					port@4d {
-						reg = <0x4d>;
+						adx4_out2_port: port@2 {
+							reg = <2>;
 
-						xbar_adx3_out3: endpoint {
-							remote-endpoint = <&adx3_out3>;
+							adx4_out2: endpoint {
+								remote-endpoint = <&xbar_adx4_out2>;
+							};
 						};
-					};
 
-					port@4e {
-						reg = <0x4e>;
+						adx4_out3_port: port@3 {
+							reg = <3>;
 
-						xbar_adx3_out4: endpoint {
-							remote-endpoint = <&adx3_out4>;
+							adx4_out3: endpoint {
+								remote-endpoint = <&xbar_adx4_out3>;
+							};
 						};
-					};
 
-					xbar_adx4_in_port: port@4f {
-						reg = <0x4f>;
+						adx4_out4_port: port@4 {
+							reg = <4>;
 
-						xbar_adx4_in: endpoint {
-							remote-endpoint = <&adx4_in>;
+							adx4_out4: endpoint {
+								remote-endpoint = <&xbar_adx4_out4>;
+							};
 						};
 					};
+				};
 
-					port@50 {
-						reg = <0x50>;
+				dmic@2904200 {
+					status = "okay";
 
-						xbar_adx4_out1: endpoint {
-							remote-endpoint = <&adx4_out1>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					port@51 {
-						reg = <0x51>;
+						port@0 {
+							reg = <0>;
 
-						xbar_adx4_out2: endpoint {
-							remote-endpoint = <&adx4_out2>;
+							dmic3_cif: endpoint {
+								remote-endpoint = <&xbar_dmic3>;
+							};
 						};
-					};
 
-					port@52 {
-						reg = <0x52>;
+						dmic3_port: port@1 {
+							reg = <1>;
 
-						xbar_adx4_out3: endpoint {
-							remote-endpoint = <&adx4_out3>;
+							dmic3_dap: endpoint {
+								/* placeholder for external codec */
+							};
 						};
 					};
+				};
 
-					port@53 {
-						reg = <0x53>;
+				processing-engine@2908000 {
+					status = "okay";
 
-						xbar_adx4_out4: endpoint {
-							remote-endpoint = <&adx4_out4>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_mix_in1_port: port@54 {
-						reg = <0x54>;
+						port@0 {
+							reg = <0x0>;
 
-						xbar_mix_in1: endpoint {
-							remote-endpoint = <&mix_in1>;
+							ope1_cif_in_ep: endpoint {
+								remote-endpoint = <&xbar_ope1_in_ep>;
+							};
 						};
-					};
 
-					xbar_mix_in2_port: port@55 {
-						reg = <0x55>;
+						ope1_out_port: port@1 {
+							reg = <0x1>;
 
-						xbar_mix_in2: endpoint {
-							remote-endpoint = <&mix_in2>;
+							ope1_cif_out_ep: endpoint {
+								remote-endpoint = <&xbar_ope1_out_ep>;
+							};
 						};
 					};
+				};
 
-					xbar_mix_in3_port: port@56 {
-						reg = <0x56>;
+				mvc@290a000 {
+					status = "okay";
 
-						xbar_mix_in3: endpoint {
-							remote-endpoint = <&mix_in3>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_mix_in4_port: port@57 {
-						reg = <0x57>;
+						port@0 {
+							reg = <0>;
 
-						xbar_mix_in4: endpoint {
-							remote-endpoint = <&mix_in4>;
+							mvc1_cif_in: endpoint {
+								remote-endpoint = <&xbar_mvc1_in>;
+							};
 						};
-					};
 
-					xbar_mix_in5_port: port@58 {
-						reg = <0x58>;
+						mvc1_out_port: port@1 {
+							reg = <1>;
 
-						xbar_mix_in5: endpoint {
-							remote-endpoint = <&mix_in5>;
+							mvc1_cif_out: endpoint {
+								remote-endpoint = <&xbar_mvc1_out>;
+							};
 						};
 					};
+				};
 
-					xbar_mix_in6_port: port@59 {
-						reg = <0x59>;
+				mvc@290a200 {
+					status = "okay";
 
-						xbar_mix_in6: endpoint {
-							remote-endpoint = <&mix_in6>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_mix_in7_port: port@5a {
-						reg = <0x5a>;
+						port@0 {
+							reg = <0>;
 
-						xbar_mix_in7: endpoint {
-							remote-endpoint = <&mix_in7>;
+							mvc2_cif_in: endpoint {
+								remote-endpoint = <&xbar_mvc2_in>;
+							};
 						};
-					};
 
-					xbar_mix_in8_port: port@5b {
-						reg = <0x5b>;
+						mvc2_out_port: port@1 {
+							reg = <1>;
 
-						xbar_mix_in8: endpoint {
-							remote-endpoint = <&mix_in8>;
+							mvc2_cif_out: endpoint {
+								remote-endpoint = <&xbar_mvc2_out>;
+							};
 						};
 					};
+				};
 
-					xbar_mix_in9_port: port@5c {
-						reg = <0x5c>;
+				amixer@290bb00 {
+					status = "okay";
 
-						xbar_mix_in9: endpoint {
-							remote-endpoint = <&mix_in9>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_mix_in10_port: port@5d {
-						reg = <0x5d>;
+						port@0 {
+							reg = <0x0>;
 
-						xbar_mix_in10: endpoint {
-							remote-endpoint = <&mix_in10>;
+							mix_in1: endpoint {
+								remote-endpoint = <&xbar_mix_in1>;
+							};
 						};
-					};
 
-					port@5e {
-						reg = <0x5e>;
+						port@1 {
+							reg = <0x1>;
 
-						xbar_mix_out1: endpoint {
-							remote-endpoint = <&mix_out1>;
+							mix_in2: endpoint {
+								remote-endpoint = <&xbar_mix_in2>;
+							};
 						};
-					};
 
-					port@5f {
-						reg = <0x5f>;
+						port@2 {
+							reg = <0x2>;
 
-						xbar_mix_out2: endpoint {
-							remote-endpoint = <&mix_out2>;
+							mix_in3: endpoint {
+								remote-endpoint = <&xbar_mix_in3>;
+							};
 						};
-					};
 
-					port@60 {
-						reg = <0x60>;
+						port@3 {
+							reg = <0x3>;
 
-						xbar_mix_out3: endpoint {
-							remote-endpoint = <&mix_out3>;
+							mix_in4: endpoint {
+								remote-endpoint = <&xbar_mix_in4>;
+							};
 						};
-					};
 
-					port@61 {
-						reg = <0x61>;
+						port@4 {
+							reg = <0x4>;
 
-						xbar_mix_out4: endpoint {
-							remote-endpoint = <&mix_out4>;
+							mix_in5: endpoint {
+								remote-endpoint = <&xbar_mix_in5>;
+							};
 						};
-					};
 
-					port@62 {
-						reg = <0x62>;
+						port@5 {
+							reg = <0x5>;
 
-						xbar_mix_out5: endpoint {
-							remote-endpoint = <&mix_out5>;
+							mix_in6: endpoint {
+								remote-endpoint = <&xbar_mix_in6>;
+							};
 						};
-					};
 
-					xbar_asrc_in1_port: port@63 {
-						reg = <0x63>;
+						port@6 {
+							reg = <0x6>;
 
-						xbar_asrc_in1_ep: endpoint {
-							remote-endpoint = <&asrc_in1_ep>;
+							mix_in7: endpoint {
+								remote-endpoint = <&xbar_mix_in7>;
+							};
 						};
-					};
 
-					port@64 {
-						reg = <0x64>;
+						port@7 {
+							reg = <0x7>;
 
-						xbar_asrc_out1_ep: endpoint {
-							remote-endpoint = <&asrc_out1_ep>;
+							mix_in8: endpoint {
+								remote-endpoint = <&xbar_mix_in8>;
+							};
 						};
-					};
 
-					xbar_asrc_in2_port: port@65 {
-						reg = <0x65>;
+						port@8 {
+							reg = <0x8>;
 
-						xbar_asrc_in2_ep: endpoint {
-							remote-endpoint = <&asrc_in2_ep>;
+							mix_in9: endpoint {
+								remote-endpoint = <&xbar_mix_in9>;
+							};
 						};
-					};
 
-					port@66 {
-						reg = <0x66>;
+						port@9 {
+							reg = <0x9>;
 
-						xbar_asrc_out2_ep: endpoint {
-							remote-endpoint = <&asrc_out2_ep>;
+							mix_in10: endpoint {
+								remote-endpoint = <&xbar_mix_in10>;
+							};
 						};
-					};
 
-					xbar_asrc_in3_port: port@67 {
-						reg = <0x67>;
+						mix_out1_port: port@a {
+							reg = <0xa>;
 
-						xbar_asrc_in3_ep: endpoint {
-							remote-endpoint = <&asrc_in3_ep>;
+							mix_out1: endpoint {
+								remote-endpoint = <&xbar_mix_out1>;
+							};
 						};
-					};
 
-					port@68 {
-						reg = <0x68>;
+						mix_out2_port: port@b {
+							reg = <0xb>;
 
-						xbar_asrc_out3_ep: endpoint {
-							remote-endpoint = <&asrc_out3_ep>;
+							mix_out2: endpoint {
+								remote-endpoint = <&xbar_mix_out2>;
+							};
 						};
-					};
 
-					xbar_asrc_in4_port: port@69 {
-						reg = <0x69>;
+						mix_out3_port: port@c {
+							reg = <0xc>;
 
-						xbar_asrc_in4_ep: endpoint {
-							remote-endpoint = <&asrc_in4_ep>;
+							mix_out3: endpoint {
+								remote-endpoint = <&xbar_mix_out3>;
+							};
 						};
-					};
 
-					port@6a {
-						reg = <0x6a>;
+						mix_out4_port: port@d {
+							reg = <0xd>;
 
-						xbar_asrc_out4_ep: endpoint {
-							remote-endpoint = <&asrc_out4_ep>;
+							mix_out4: endpoint {
+								remote-endpoint = <&xbar_mix_out4>;
+							};
 						};
-					};
 
-					xbar_asrc_in5_port: port@6b {
-						reg = <0x6b>;
+						mix_out5_port: port@e {
+							reg = <0xe>;
 
-						xbar_asrc_in5_ep: endpoint {
-							remote-endpoint = <&asrc_in5_ep>;
+							mix_out5: endpoint {
+								remote-endpoint = <&xbar_mix_out5>;
+							};
 						};
 					};
+				};
 
-					port@6c {
-						reg = <0x6c>;
+				admaif@290f000 {
+					status = "okay";
 
-						xbar_asrc_out5_ep: endpoint {
-							remote-endpoint = <&asrc_out5_ep>;
-						};
-					};
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
 
-					xbar_asrc_in6_port: port@6d {
-						reg = <0x6d>;
+						admaif0_port: port@0 {
+							reg = <0x0>;
 
-						xbar_asrc_in6_ep: endpoint {
-							remote-endpoint = <&asrc_in6_ep>;
+							admaif0: endpoint {
+								remote-endpoint = <&xbar_admaif0>;
+							};
 						};
-					};
 
-					port@6e {
-						reg = <0x6e>;
+						admaif1_port: port@1 {
+							reg = <0x1>;
 
-						xbar_asrc_out6_ep: endpoint {
-							remote-endpoint = <&asrc_out6_ep>;
+							admaif1: endpoint {
+								remote-endpoint = <&xbar_admaif1>;
+							};
 						};
-					};
 
-					xbar_asrc_in7_port: port@6f {
-						reg = <0x6f>;
+						admaif2_port: port@2 {
+							reg = <0x2>;
 
-						xbar_asrc_in7_ep: endpoint {
-							remote-endpoint = <&asrc_in7_ep>;
+							admaif2: endpoint {
+								remote-endpoint = <&xbar_admaif2>;
+							};
 						};
-					};
 
-					xbar_ope1_in_port: port@70 {
-						reg = <0x70>;
+						admaif3_port: port@3 {
+							reg = <0x3>;
 
-						xbar_ope1_in_ep: endpoint {
-							remote-endpoint = <&ope1_cif_in_ep>;
+							admaif3: endpoint {
+								remote-endpoint = <&xbar_admaif3>;
+							};
 						};
-					};
 
-					port@71 {
-						reg = <0x71>;
+						admaif4_port: port@4 {
+							reg = <0x4>;
 
-						xbar_ope1_out_ep: endpoint {
-							remote-endpoint = <&ope1_cif_out_ep>;
+							admaif4: endpoint {
+								remote-endpoint = <&xbar_admaif4>;
+							};
 						};
-					};
-				};
 
-				i2s@2901000 {
-					status = "okay";
+						admaif5_port: port@5 {
+							reg = <0x5>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							admaif5: endpoint {
+								remote-endpoint = <&xbar_admaif5>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						admaif6_port: port@6 {
+							reg = <0x6>;
 
-							i2s1_cif: endpoint {
-								remote-endpoint = <&xbar_i2s1>;
+							admaif6: endpoint {
+								remote-endpoint = <&xbar_admaif6>;
 							};
 						};
 
-						i2s1_port: port@1 {
-							reg = <1>;
+						admaif7_port: port@7 {
+							reg = <0x7>;
 
-							i2s1_dap: endpoint {
-								dai-format = "i2s";
-								/* placeholder for external codec */
+							admaif7: endpoint {
+								remote-endpoint = <&xbar_admaif7>;
 							};
 						};
-					};
-				};
 
-				i2s@2901100 {
-					status = "okay";
+						admaif8_port: port@8 {
+							reg = <0x8>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							admaif8: endpoint {
+								remote-endpoint = <&xbar_admaif8>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						admaif9_port: port@9 {
+							reg = <0x9>;
 
-							i2s2_cif: endpoint {
-								remote-endpoint = <&xbar_i2s2>;
+							admaif9: endpoint {
+								remote-endpoint = <&xbar_admaif9>;
 							};
 						};
 
-						i2s2_port: port@1 {
-							reg = <1>;
+						admaif10_port: port@a {
+							reg = <0xa>;
 
-							i2s2_dap: endpoint {
-								dai-format = "i2s";
-								/* placeholder for external codec */
+							admaif10: endpoint {
+								remote-endpoint = <&xbar_admaif10>;
 							};
 						};
-					};
-				};
 
-				i2s@2901300 {
-					status = "okay";
+						admaif11_port: port@b {
+							reg = <0xb>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							admaif11: endpoint {
+								remote-endpoint = <&xbar_admaif11>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						admaif12_port: port@c {
+							reg = <0xc>;
 
-							i2s4_cif: endpoint {
-								remote-endpoint = <&xbar_i2s4>;
+							admaif12: endpoint {
+								remote-endpoint = <&xbar_admaif12>;
 							};
 						};
 
-						i2s4_port: port@1 {
-							reg = <1>;
+						admaif13_port: port@d {
+							reg = <0xd>;
 
-							i2s4_dap: endpoint {
-								dai-format = "i2s";
-								/* placeholder for external codec */
+							admaif13: endpoint {
+								remote-endpoint = <&xbar_admaif13>;
 							};
 						};
-					};
-				};
 
-				i2s@2901500 {
-					status = "okay";
+						admaif14_port: port@e {
+							reg = <0xe>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							admaif14: endpoint {
+								remote-endpoint = <&xbar_admaif14>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						admaif15_port: port@f {
+							reg = <0xf>;
 
-							i2s6_cif: endpoint {
-								remote-endpoint = <&xbar_i2s6>;
+							admaif15: endpoint {
+								remote-endpoint = <&xbar_admaif15>;
 							};
 						};
 
-						i2s6_port: port@1 {
-							reg = <1>;
+						admaif16_port: port@10 {
+							reg = <0x10>;
 
-							i2s6_dap: endpoint {
-								dai-format = "i2s";
-								/* placeholder for external codec */
+							admaif16: endpoint {
+								remote-endpoint = <&xbar_admaif16>;
 							};
 						};
-					};
-				};
 
-				sfc@2902000 {
-					status = "okay";
+						admaif17_port: port@11 {
+							reg = <0x11>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							admaif17: endpoint {
+								remote-endpoint = <&xbar_admaif17>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						admaif18_port: port@12 {
+							reg = <0x12>;
 
-							sfc1_cif_in: endpoint {
-								remote-endpoint = <&xbar_sfc1_in>;
+							admaif18: endpoint {
+								remote-endpoint = <&xbar_admaif18>;
 							};
 						};
 
-						sfc1_out_port: port@1 {
-							reg = <1>;
+						admaif19_port: port@13 {
+							reg = <0x13>;
 
-							sfc1_cif_out: endpoint {
-								remote-endpoint = <&xbar_sfc1_out>;
+							admaif19: endpoint {
+								remote-endpoint = <&xbar_admaif19>;
 							};
 						};
 					};
 				};
 
-				sfc@2902200 {
+				asrc@2910000 {
 					status = "okay";
 
 					ports {
@@ -1022,972 +1031,968 @@ ports {
 						#size-cells = <0>;
 
 						port@0 {
-							reg = <0>;
+							reg = <0x0>;
 
-							sfc2_cif_in: endpoint {
-								remote-endpoint = <&xbar_sfc2_in>;
+							asrc_in1_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in1_ep>;
 							};
 						};
 
-						sfc2_out_port: port@1 {
-							reg = <1>;
+						port@1 {
+							reg = <0x1>;
 
-							sfc2_cif_out: endpoint {
-								remote-endpoint = <&xbar_sfc2_out>;
+							asrc_in2_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in2_ep>;
 							};
 						};
-					};
-				};
-
-				sfc@2902400 {
-					status = "okay";
-
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
 
-						port@0 {
-							reg = <0>;
+						port@2 {
+							reg = <0x2>;
 
-							sfc3_cif_in: endpoint {
-								remote-endpoint = <&xbar_sfc3_in>;
+							asrc_in3_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in3_ep>;
 							};
 						};
 
-						sfc3_out_port: port@1 {
-							reg = <1>;
+						port@3 {
+							reg = <0x3>;
 
-							sfc3_cif_out: endpoint {
-								remote-endpoint = <&xbar_sfc3_out>;
+							asrc_in4_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in4_ep>;
 							};
 						};
-					};
-				};
 
-				sfc@2902600 {
-					status = "okay";
+						port@4 {
+							reg = <0x4>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							asrc_in5_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in5_ep>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						port@5 {
+							reg = <0x5>;
 
-							sfc4_cif_in: endpoint {
-								remote-endpoint = <&xbar_sfc4_in>;
+							asrc_in6_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in6_ep>;
 							};
 						};
 
-						sfc4_out_port: port@1 {
-							reg = <1>;
+						port@6 {
+							reg = <0x6>;
 
-							sfc4_cif_out: endpoint {
-								remote-endpoint = <&xbar_sfc4_out>;
+							asrc_in7_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_in7_ep>;
 							};
 						};
-					};
-				};
 
-				amx@2903000 {
-					status = "okay";
+						asrc_out1_port: port@7 {
+							reg = <0x7>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+							asrc_out1_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out1_ep>;
+							};
+						};
 
-						port@0 {
-							reg = <0>;
+						asrc_out2_port: port@8 {
+							reg = <0x8>;
 
-							amx1_in1: endpoint {
-								remote-endpoint = <&xbar_amx1_in1>;
+							asrc_out2_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out2_ep>;
 							};
 						};
 
-						port@1 {
-							reg = <1>;
+						asrc_out3_port: port@9 {
+							reg = <0x9>;
 
-							amx1_in2: endpoint {
-								remote-endpoint = <&xbar_amx1_in2>;
+							asrc_out3_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out3_ep>;
 							};
 						};
 
-						port@2 {
-							reg = <2>;
+						asrc_out4_port: port@a {
+							reg = <0xa>;
 
-							amx1_in3: endpoint {
-								remote-endpoint = <&xbar_amx1_in3>;
+							asrc_out4_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out4_ep>;
 							};
 						};
 
-						port@3 {
-							reg = <3>;
+						asrc_out5_port: port@b {
+							reg = <0xb>;
 
-							amx1_in4: endpoint {
-								remote-endpoint = <&xbar_amx1_in4>;
+							asrc_out5_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out5_ep>;
 							};
 						};
 
-						amx1_out_port: port@4 {
-							reg = <4>;
+						asrc_out6_port:	port@c {
+							reg = <0xc>;
 
-							amx1_out: endpoint {
-								remote-endpoint = <&xbar_amx1_out>;
+							asrc_out6_ep: endpoint {
+								remote-endpoint = <&xbar_asrc_out6_ep>;
 							};
 						};
 					};
 				};
 
-				amx@2903100 {
-					status = "okay";
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+					port@0 {
+						reg = <0x0>;
 
-						port@0 {
-							reg = <0>;
+						xbar_admaif0: endpoint {
+							remote-endpoint = <&admaif0>;
+						};
+					};
 
-							amx2_in1: endpoint {
-								remote-endpoint = <&xbar_amx2_in1>;
-							};
+					port@1 {
+						reg = <0x1>;
+
+						xbar_admaif1: endpoint {
+							remote-endpoint = <&admaif1>;
 						};
+					};
 
-						port@1 {
-							reg = <1>;
+					port@2 {
+						reg = <0x2>;
 
-							amx2_in2: endpoint {
-								remote-endpoint = <&xbar_amx2_in2>;
-							};
+						xbar_admaif2: endpoint {
+							remote-endpoint = <&admaif2>;
 						};
+					};
 
-						port@2 {
-							reg = <2>;
+					port@3 {
+						reg = <0x3>;
 
-							amx2_in3: endpoint {
-								remote-endpoint = <&xbar_amx2_in3>;
-							};
+						xbar_admaif3: endpoint {
+							remote-endpoint = <&admaif3>;
 						};
+					};
 
-						port@3 {
-							reg = <3>;
+					port@4 {
+						reg = <0x4>;
 
-							amx2_in4: endpoint {
-								remote-endpoint = <&xbar_amx2_in4>;
-							};
+						xbar_admaif4: endpoint {
+							remote-endpoint = <&admaif4>;
 						};
+					};
 
-						amx2_out_port: port@4 {
-							reg = <4>;
+					port@5 {
+						reg = <0x5>;
 
-							amx2_out: endpoint {
-								remote-endpoint = <&xbar_amx2_out>;
-							};
+						xbar_admaif5: endpoint {
+							remote-endpoint = <&admaif5>;
+						};
+					};
+
+					port@6 {
+						reg = <0x6>;
+
+						xbar_admaif6: endpoint {
+							remote-endpoint = <&admaif6>;
+						};
+					};
+
+					port@7 {
+						reg = <0x7>;
+
+						xbar_admaif7: endpoint {
+							remote-endpoint = <&admaif7>;
+						};
+					};
+
+					port@8 {
+						reg = <0x8>;
+
+						xbar_admaif8: endpoint {
+							remote-endpoint = <&admaif8>;
 						};
 					};
-				};
-
-				amx@2903200 {
-					status = "okay";
-
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
 
-						port@0 {
-							reg = <0>;
+					port@9 {
+						reg = <0x9>;
 
-							amx3_in1: endpoint {
-								remote-endpoint = <&xbar_amx3_in1>;
-							};
+						xbar_admaif9: endpoint {
+							remote-endpoint = <&admaif9>;
 						};
+					};
 
-						port@1 {
-							reg = <1>;
+					port@a {
+						reg = <0xa>;
 
-							amx3_in2: endpoint {
-								remote-endpoint = <&xbar_amx3_in2>;
-							};
+						xbar_admaif10: endpoint {
+							remote-endpoint = <&admaif10>;
 						};
+					};
 
-						port@2 {
-							reg = <2>;
+					port@b {
+						reg = <0xb>;
 
-							amx3_in3: endpoint {
-								remote-endpoint = <&xbar_amx3_in3>;
-							};
+						xbar_admaif11: endpoint {
+							remote-endpoint = <&admaif11>;
 						};
+					};
 
-						port@3 {
-							reg = <3>;
+					port@c {
+						reg = <0xc>;
 
-							amx3_in4: endpoint {
-								remote-endpoint = <&xbar_amx3_in4>;
-							};
+						xbar_admaif12: endpoint {
+							remote-endpoint = <&admaif12>;
 						};
+					};
 
-						amx3_out_port: port@4 {
-							reg = <4>;
+					port@d {
+						reg = <0xd>;
 
-							amx3_out: endpoint {
-								remote-endpoint = <&xbar_amx3_out>;
-							};
+						xbar_admaif13: endpoint {
+							remote-endpoint = <&admaif13>;
 						};
 					};
-				};
 
-				amx@2903300 {
-					status = "okay";
+					port@e {
+						reg = <0xe>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_admaif14: endpoint {
+							remote-endpoint = <&admaif14>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@f {
+						reg = <0xf>;
 
-							amx4_in1: endpoint {
-								remote-endpoint = <&xbar_amx4_in1>;
-							};
+						xbar_admaif15: endpoint {
+							remote-endpoint = <&admaif15>;
 						};
+					};
 
-						port@1 {
-							reg = <1>;
+					port@10 {
+						reg = <0x10>;
 
-							amx4_in2: endpoint {
-								remote-endpoint = <&xbar_amx4_in2>;
-							};
+						xbar_admaif16: endpoint {
+							remote-endpoint = <&admaif16>;
 						};
+					};
 
-						port@2 {
-							reg = <2>;
+					port@11 {
+						reg = <0x11>;
 
-							amx4_in3: endpoint {
-								remote-endpoint = <&xbar_amx4_in3>;
-							};
+						xbar_admaif17: endpoint {
+							remote-endpoint = <&admaif17>;
 						};
+					};
 
-						port@3 {
-							reg = <3>;
+					port@12 {
+						reg = <0x12>;
 
-							amx4_in4: endpoint {
-								remote-endpoint = <&xbar_amx4_in4>;
-							};
+						xbar_admaif18: endpoint {
+							remote-endpoint = <&admaif18>;
 						};
+					};
 
-						amx4_out_port: port@4 {
-							reg = <4>;
+					port@13 {
+						reg = <0x13>;
 
-							amx4_out: endpoint {
-								remote-endpoint = <&xbar_amx4_out>;
-							};
+						xbar_admaif19: endpoint {
+							remote-endpoint = <&admaif19>;
 						};
 					};
-				};
 
-				adx@2903800 {
-					status = "okay";
+					xbar_i2s1_port: port@14 {
+						reg = <0x14>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_i2s1: endpoint {
+							remote-endpoint = <&i2s1_cif>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_i2s2_port: port@15 {
+						reg = <0x15>;
 
-							adx1_in: endpoint {
-								remote-endpoint = <&xbar_adx1_in>;
-							};
+						xbar_i2s2: endpoint {
+							remote-endpoint = <&i2s2_cif>;
 						};
+					};
 
-						adx1_out1_port: port@1 {
-							reg = <1>;
+					xbar_i2s4_port: port@17 {
+						reg = <0x17>;
 
-							adx1_out1: endpoint {
-								remote-endpoint = <&xbar_adx1_out1>;
-							};
+						xbar_i2s4: endpoint {
+							remote-endpoint = <&i2s4_cif>;
 						};
+					};
 
-						adx1_out2_port: port@2 {
-							reg = <2>;
+					xbar_i2s6_port: port@19 {
+						reg = <0x19>;
 
-							adx1_out2: endpoint {
-								remote-endpoint = <&xbar_adx1_out2>;
-							};
+						xbar_i2s6: endpoint {
+							remote-endpoint = <&i2s6_cif>;
 						};
+					};
 
-						adx1_out3_port: port@3 {
-							reg = <3>;
+					xbar_dmic3_port: port@1c {
+						reg = <0x1c>;
 
-							adx1_out3: endpoint {
-								remote-endpoint = <&xbar_adx1_out3>;
-							};
+						xbar_dmic3: endpoint {
+							remote-endpoint = <&dmic3_cif>;
 						};
+					};
 
-						adx1_out4_port: port@4 {
-							reg = <4>;
+					xbar_sfc1_in_port: port@20 {
+						reg = <0x20>;
 
-							adx1_out4: endpoint {
-								remote-endpoint = <&xbar_adx1_out4>;
-							};
+						xbar_sfc1_in: endpoint {
+							remote-endpoint = <&sfc1_cif_in>;
 						};
 					};
-				};
 
-				adx@2903900 {
-					status = "okay";
+					port@21 {
+						reg = <0x21>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_sfc1_out: endpoint {
+							remote-endpoint = <&sfc1_cif_out>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_sfc2_in_port: port@22 {
+						reg = <0x22>;
 
-							adx2_in: endpoint {
-								remote-endpoint = <&xbar_adx2_in>;
-							};
+						xbar_sfc2_in: endpoint {
+							remote-endpoint = <&sfc2_cif_in>;
 						};
+					};
 
-						adx2_out1_port: port@1 {
-							reg = <1>;
+					port@23 {
+						reg = <0x23>;
 
-							adx2_out1: endpoint {
-								remote-endpoint = <&xbar_adx2_out1>;
-							};
+						xbar_sfc2_out: endpoint {
+							remote-endpoint = <&sfc2_cif_out>;
 						};
+					};
 
-						adx2_out2_port: port@2 {
-							reg = <2>;
+					xbar_sfc3_in_port: port@24 {
+						reg = <0x24>;
 
-							adx2_out2: endpoint {
-								remote-endpoint = <&xbar_adx2_out2>;
-							};
+						xbar_sfc3_in: endpoint {
+							remote-endpoint = <&sfc3_cif_in>;
 						};
+					};
 
-						adx2_out3_port: port@3 {
-							reg = <3>;
+					port@25 {
+						reg = <0x25>;
 
-							adx2_out3: endpoint {
-								remote-endpoint = <&xbar_adx2_out3>;
-							};
+						xbar_sfc3_out: endpoint {
+							remote-endpoint = <&sfc3_cif_out>;
 						};
+					};
 
-						adx2_out4_port: port@4 {
-							reg = <4>;
+					xbar_sfc4_in_port: port@26 {
+						reg = <0x26>;
 
-							adx2_out4: endpoint {
-								remote-endpoint = <&xbar_adx2_out4>;
-							};
+						xbar_sfc4_in: endpoint {
+							remote-endpoint = <&sfc4_cif_in>;
 						};
 					};
-				};
 
-				adx@2903a00 {
-					status = "okay";
+					port@27 {
+						reg = <0x27>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_sfc4_out: endpoint {
+							remote-endpoint = <&sfc4_cif_out>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_mvc1_in_port: port@28 {
+						reg = <0x28>;
 
-							adx3_in: endpoint {
-								remote-endpoint = <&xbar_adx3_in>;
-							};
+						xbar_mvc1_in: endpoint {
+							remote-endpoint = <&mvc1_cif_in>;
 						};
+					};
 
-						adx3_out1_port: port@1 {
-							reg = <1>;
+					port@29 {
+						reg = <0x29>;
 
-							adx3_out1: endpoint {
-								remote-endpoint = <&xbar_adx3_out1>;
-							};
+						xbar_mvc1_out: endpoint {
+							remote-endpoint = <&mvc1_cif_out>;
 						};
+					};
 
-						adx3_out2_port: port@2 {
-							reg = <2>;
+					xbar_mvc2_in_port: port@2a {
+						reg = <0x2a>;
 
-							adx3_out2: endpoint {
-								remote-endpoint = <&xbar_adx3_out2>;
-							};
+						xbar_mvc2_in: endpoint {
+							remote-endpoint = <&mvc2_cif_in>;
 						};
+					};
 
-						adx3_out3_port: port@3 {
-							reg = <3>;
+					port@2b {
+						reg = <0x2b>;
 
-							adx3_out3: endpoint {
-								remote-endpoint = <&xbar_adx3_out3>;
-							};
+						xbar_mvc2_out: endpoint {
+							remote-endpoint = <&mvc2_cif_out>;
 						};
+					};
 
-						adx3_out4_port: port@4 {
-							reg = <4>;
+					xbar_amx1_in1_port: port@2c {
+						reg = <0x2c>;
 
-							adx3_out4: endpoint {
-								remote-endpoint = <&xbar_adx3_out4>;
-							};
+						xbar_amx1_in1: endpoint {
+							remote-endpoint = <&amx1_in1>;
 						};
 					};
-				};
 
-				adx@2903b00 {
-					status = "okay";
+					xbar_amx1_in2_port: port@2d {
+						reg = <0x2d>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx1_in2: endpoint {
+							remote-endpoint = <&amx1_in2>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_amx1_in3_port: port@2e {
+						reg = <0x2e>;
 
-							adx4_in: endpoint {
-								remote-endpoint = <&xbar_adx4_in>;
-							};
+						xbar_amx1_in3: endpoint {
+							remote-endpoint = <&amx1_in3>;
 						};
+					};
 
-						adx4_out1_port: port@1 {
-							reg = <1>;
+					xbar_amx1_in4_port: port@2f {
+						reg = <0x2f>;
 
-							adx4_out1: endpoint {
-								remote-endpoint = <&xbar_adx4_out1>;
-							};
+						xbar_amx1_in4: endpoint {
+							remote-endpoint = <&amx1_in4>;
 						};
+					};
 
-						adx4_out2_port: port@2 {
-							reg = <2>;
+					port@30 {
+						reg = <0x30>;
 
-							adx4_out2: endpoint {
-								remote-endpoint = <&xbar_adx4_out2>;
-							};
+						xbar_amx1_out: endpoint {
+							remote-endpoint = <&amx1_out>;
 						};
+					};
 
-						adx4_out3_port: port@3 {
-							reg = <3>;
+					xbar_amx2_in1_port: port@31 {
+						reg = <0x31>;
 
-							adx4_out3: endpoint {
-								remote-endpoint = <&xbar_adx4_out3>;
-							};
+						xbar_amx2_in1: endpoint {
+							remote-endpoint = <&amx2_in1>;
 						};
+					};
 
-						adx4_out4_port: port@4 {
-							reg = <4>;
+					xbar_amx2_in2_port: port@32 {
+						reg = <0x32>;
 
-							adx4_out4: endpoint {
-								remote-endpoint = <&xbar_adx4_out4>;
-							};
+						xbar_amx2_in2: endpoint {
+							remote-endpoint = <&amx2_in2>;
 						};
 					};
-				};
 
-				dmic@2904200 {
-					status = "okay";
+					xbar_amx2_in3_port: port@33 {
+						reg = <0x33>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx2_in3: endpoint {
+							remote-endpoint = <&amx2_in3>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_amx2_in4_port: port@34 {
+						reg = <0x34>;
 
-							dmic3_cif: endpoint {
-								remote-endpoint = <&xbar_dmic3>;
-							};
+						xbar_amx2_in4: endpoint {
+							remote-endpoint = <&amx2_in4>;
 						};
+					};
 
-						dmic3_port: port@1 {
-							reg = <1>;
+					port@35 {
+						reg = <0x35>;
 
-							dmic3_dap: endpoint {
-								/* placeholder for external codec */
-							};
+						xbar_amx2_out: endpoint {
+							remote-endpoint = <&amx2_out>;
 						};
 					};
-				};
 
-				processing-engine@2908000 {
-					status = "okay";
+					xbar_amx3_in1_port: port@36 {
+						reg = <0x36>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx3_in1: endpoint {
+							remote-endpoint = <&amx3_in1>;
+						};
+					};
 
-						port@0 {
-							reg = <0x0>;
+					xbar_amx3_in2_port: port@37 {
+						reg = <0x37>;
 
-							ope1_cif_in_ep: endpoint {
-								remote-endpoint = <&xbar_ope1_in_ep>;
-							};
+						xbar_amx3_in2: endpoint {
+							remote-endpoint = <&amx3_in2>;
 						};
+					};
 
-						ope1_out_port: port@1 {
-							reg = <0x1>;
+					xbar_amx3_in3_port: port@38 {
+						reg = <0x38>;
 
-							ope1_cif_out_ep: endpoint {
-								remote-endpoint = <&xbar_ope1_out_ep>;
-							};
+						xbar_amx3_in3: endpoint {
+							remote-endpoint = <&amx3_in3>;
 						};
 					};
-				};
 
-				mvc@290a000 {
-					status = "okay";
+					xbar_amx3_in4_port: port@39 {
+						reg = <0x39>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx3_in4: endpoint {
+							remote-endpoint = <&amx3_in4>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					port@3a {
+						reg = <0x3a>;
 
-							mvc1_cif_in: endpoint {
-								remote-endpoint = <&xbar_mvc1_in>;
-							};
+						xbar_amx3_out: endpoint {
+							remote-endpoint = <&amx3_out>;
 						};
+					};
 
-						mvc1_out_port: port@1 {
-							reg = <1>;
+					xbar_amx4_in1_port: port@3b {
+						reg = <0x3b>;
 
-							mvc1_cif_out: endpoint {
-								remote-endpoint = <&xbar_mvc1_out>;
-							};
+						xbar_amx4_in1: endpoint {
+							remote-endpoint = <&amx4_in1>;
 						};
 					};
-				};
 
-				mvc@290a200 {
-					status = "okay";
+					xbar_amx4_in2_port: port@3c {
+						reg = <0x3c>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx4_in2: endpoint {
+							remote-endpoint = <&amx4_in2>;
+						};
+					};
 
-						port@0 {
-							reg = <0>;
+					xbar_amx4_in3_port: port@3d {
+						reg = <0x3d>;
 
-							mvc2_cif_in: endpoint {
-								remote-endpoint = <&xbar_mvc2_in>;
-							};
+						xbar_amx4_in3: endpoint {
+							remote-endpoint = <&amx4_in3>;
 						};
+					};
 
-						mvc2_out_port: port@1 {
-							reg = <1>;
+					xbar_amx4_in4_port: port@3e {
+						reg = <0x3e>;
 
-							mvc2_cif_out: endpoint {
-								remote-endpoint = <&xbar_mvc2_out>;
-							};
+						xbar_amx4_in4: endpoint {
+							remote-endpoint = <&amx4_in4>;
 						};
 					};
-				};
 
-				amixer@290bb00 {
-					status = "okay";
+					port@3f {
+						reg = <0x3f>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_amx4_out: endpoint {
+							remote-endpoint = <&amx4_out>;
+						};
+					};
 
-						port@0 {
-							reg = <0x0>;
+					xbar_adx1_in_port: port@40 {
+						reg = <0x40>;
 
-							mix_in1: endpoint {
-								remote-endpoint = <&xbar_mix_in1>;
-							};
+						xbar_adx1_in: endpoint {
+							remote-endpoint = <&adx1_in>;
 						};
+					};
 
-						port@1 {
-							reg = <0x1>;
+					port@41 {
+						reg = <0x41>;
 
-							mix_in2: endpoint {
-								remote-endpoint = <&xbar_mix_in2>;
-							};
+						xbar_adx1_out1: endpoint {
+							remote-endpoint = <&adx1_out1>;
 						};
+					};
 
-						port@2 {
-							reg = <0x2>;
+					port@42 {
+						reg = <0x42>;
 
-							mix_in3: endpoint {
-								remote-endpoint = <&xbar_mix_in3>;
-							};
+						xbar_adx1_out2: endpoint {
+							remote-endpoint = <&adx1_out2>;
 						};
+					};
 
-						port@3 {
-							reg = <0x3>;
+					port@43 {
+						reg = <0x43>;
 
-							mix_in4: endpoint {
-								remote-endpoint = <&xbar_mix_in4>;
-							};
+						xbar_adx1_out3: endpoint {
+							remote-endpoint = <&adx1_out3>;
 						};
+					};
 
-						port@4 {
-							reg = <0x4>;
+					port@44 {
+						reg = <0x44>;
 
-							mix_in5: endpoint {
-								remote-endpoint = <&xbar_mix_in5>;
-							};
+						xbar_adx1_out4: endpoint {
+							remote-endpoint = <&adx1_out4>;
 						};
+					};
 
-						port@5 {
-							reg = <0x5>;
+					xbar_adx2_in_port: port@45 {
+						reg = <0x45>;
 
-							mix_in6: endpoint {
-								remote-endpoint = <&xbar_mix_in6>;
-							};
+						xbar_adx2_in: endpoint {
+							remote-endpoint = <&adx2_in>;
 						};
+					};
 
-						port@6 {
-							reg = <0x6>;
+					port@46 {
+						reg = <0x46>;
 
-							mix_in7: endpoint {
-								remote-endpoint = <&xbar_mix_in7>;
-							};
+						xbar_adx2_out1: endpoint {
+							remote-endpoint = <&adx2_out1>;
 						};
+					};
 
-						port@7 {
-							reg = <0x7>;
+					port@47 {
+						reg = <0x47>;
 
-							mix_in8: endpoint {
-								remote-endpoint = <&xbar_mix_in8>;
-							};
+						xbar_adx2_out2: endpoint {
+							remote-endpoint = <&adx2_out2>;
 						};
+					};
 
-						port@8 {
-							reg = <0x8>;
+					port@48 {
+						reg = <0x48>;
 
-							mix_in9: endpoint {
-								remote-endpoint = <&xbar_mix_in9>;
-							};
+						xbar_adx2_out3: endpoint {
+							remote-endpoint = <&adx2_out3>;
 						};
+					};
 
-						port@9 {
-							reg = <0x9>;
+					port@49 {
+						reg = <0x49>;
 
-							mix_in10: endpoint {
-								remote-endpoint = <&xbar_mix_in10>;
-							};
+						xbar_adx2_out4: endpoint {
+							remote-endpoint = <&adx2_out4>;
 						};
+					};
 
-						mix_out1_port: port@a {
-							reg = <0xa>;
+					xbar_adx3_in_port: port@4a {
+						reg = <0x4a>;
 
-							mix_out1: endpoint {
-								remote-endpoint = <&xbar_mix_out1>;
-							};
+						xbar_adx3_in: endpoint {
+							remote-endpoint = <&adx3_in>;
 						};
+					};
 
-						mix_out2_port: port@b {
-							reg = <0xb>;
+					port@4b {
+						reg = <0x4b>;
 
-							mix_out2: endpoint {
-								remote-endpoint = <&xbar_mix_out2>;
-							};
+						xbar_adx3_out1: endpoint {
+							remote-endpoint = <&adx3_out1>;
 						};
+					};
 
-						mix_out3_port: port@c {
-							reg = <0xc>;
+					port@4c {
+						reg = <0x4c>;
 
-							mix_out3: endpoint {
-								remote-endpoint = <&xbar_mix_out3>;
-							};
+						xbar_adx3_out2: endpoint {
+							remote-endpoint = <&adx3_out2>;
 						};
+					};
 
-						mix_out4_port: port@d {
-							reg = <0xd>;
+					port@4d {
+						reg = <0x4d>;
 
-							mix_out4: endpoint {
-								remote-endpoint = <&xbar_mix_out4>;
-							};
+						xbar_adx3_out3: endpoint {
+							remote-endpoint = <&adx3_out3>;
 						};
+					};
 
-						mix_out5_port: port@e {
-							reg = <0xe>;
+					port@4e {
+						reg = <0x4e>;
 
-							mix_out5: endpoint {
-								remote-endpoint = <&xbar_mix_out5>;
-							};
+						xbar_adx3_out4: endpoint {
+							remote-endpoint = <&adx3_out4>;
 						};
 					};
-				};
 
-				admaif@290f000 {
-					status = "okay";
+					xbar_adx4_in_port: port@4f {
+						reg = <0x4f>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_adx4_in: endpoint {
+							remote-endpoint = <&adx4_in>;
+						};
+					};
 
-						admaif0_port: port@0 {
-							reg = <0x0>;
+					port@50 {
+						reg = <0x50>;
 
-							admaif0: endpoint {
-								remote-endpoint = <&xbar_admaif0>;
-							};
+						xbar_adx4_out1: endpoint {
+							remote-endpoint = <&adx4_out1>;
 						};
+					};
 
-						admaif1_port: port@1 {
-							reg = <0x1>;
+					port@51 {
+						reg = <0x51>;
 
-							admaif1: endpoint {
-								remote-endpoint = <&xbar_admaif1>;
-							};
+						xbar_adx4_out2: endpoint {
+							remote-endpoint = <&adx4_out2>;
 						};
+					};
 
-						admaif2_port: port@2 {
-							reg = <0x2>;
+					port@52 {
+						reg = <0x52>;
 
-							admaif2: endpoint {
-								remote-endpoint = <&xbar_admaif2>;
-							};
+						xbar_adx4_out3: endpoint {
+							remote-endpoint = <&adx4_out3>;
 						};
+					};
 
-						admaif3_port: port@3 {
-							reg = <0x3>;
+					port@53 {
+						reg = <0x53>;
 
-							admaif3: endpoint {
-								remote-endpoint = <&xbar_admaif3>;
-							};
+						xbar_adx4_out4: endpoint {
+							remote-endpoint = <&adx4_out4>;
 						};
+					};
 
-						admaif4_port: port@4 {
-							reg = <0x4>;
+					xbar_mix_in1_port: port@54 {
+						reg = <0x54>;
 
-							admaif4: endpoint {
-								remote-endpoint = <&xbar_admaif4>;
-							};
+						xbar_mix_in1: endpoint {
+							remote-endpoint = <&mix_in1>;
 						};
+					};
 
-						admaif5_port: port@5 {
-							reg = <0x5>;
+					xbar_mix_in2_port: port@55 {
+						reg = <0x55>;
 
-							admaif5: endpoint {
-								remote-endpoint = <&xbar_admaif5>;
-							};
+						xbar_mix_in2: endpoint {
+							remote-endpoint = <&mix_in2>;
 						};
+					};
 
-						admaif6_port: port@6 {
-							reg = <0x6>;
+					xbar_mix_in3_port: port@56 {
+						reg = <0x56>;
 
-							admaif6: endpoint {
-								remote-endpoint = <&xbar_admaif6>;
-							};
+						xbar_mix_in3: endpoint {
+							remote-endpoint = <&mix_in3>;
 						};
+					};
 
-						admaif7_port: port@7 {
-							reg = <0x7>;
+					xbar_mix_in4_port: port@57 {
+						reg = <0x57>;
 
-							admaif7: endpoint {
-								remote-endpoint = <&xbar_admaif7>;
-							};
+						xbar_mix_in4: endpoint {
+							remote-endpoint = <&mix_in4>;
 						};
+					};
 
-						admaif8_port: port@8 {
-							reg = <0x8>;
+					xbar_mix_in5_port: port@58 {
+						reg = <0x58>;
 
-							admaif8: endpoint {
-								remote-endpoint = <&xbar_admaif8>;
-							};
+						xbar_mix_in5: endpoint {
+							remote-endpoint = <&mix_in5>;
 						};
+					};
 
-						admaif9_port: port@9 {
-							reg = <0x9>;
+					xbar_mix_in6_port: port@59 {
+						reg = <0x59>;
 
-							admaif9: endpoint {
-								remote-endpoint = <&xbar_admaif9>;
-							};
+						xbar_mix_in6: endpoint {
+							remote-endpoint = <&mix_in6>;
 						};
+					};
 
-						admaif10_port: port@a {
-							reg = <0xa>;
+					xbar_mix_in7_port: port@5a {
+						reg = <0x5a>;
 
-							admaif10: endpoint {
-								remote-endpoint = <&xbar_admaif10>;
-							};
+						xbar_mix_in7: endpoint {
+							remote-endpoint = <&mix_in7>;
 						};
+					};
 
-						admaif11_port: port@b {
-							reg = <0xb>;
+					xbar_mix_in8_port: port@5b {
+						reg = <0x5b>;
 
-							admaif11: endpoint {
-								remote-endpoint = <&xbar_admaif11>;
-							};
+						xbar_mix_in8: endpoint {
+							remote-endpoint = <&mix_in8>;
 						};
+					};
 
-						admaif12_port: port@c {
-							reg = <0xc>;
+					xbar_mix_in9_port: port@5c {
+						reg = <0x5c>;
 
-							admaif12: endpoint {
-								remote-endpoint = <&xbar_admaif12>;
-							};
+						xbar_mix_in9: endpoint {
+							remote-endpoint = <&mix_in9>;
 						};
+					};
 
-						admaif13_port: port@d {
-							reg = <0xd>;
+					xbar_mix_in10_port: port@5d {
+						reg = <0x5d>;
 
-							admaif13: endpoint {
-								remote-endpoint = <&xbar_admaif13>;
-							};
+						xbar_mix_in10: endpoint {
+							remote-endpoint = <&mix_in10>;
 						};
+					};
 
-						admaif14_port: port@e {
-							reg = <0xe>;
+					port@5e {
+						reg = <0x5e>;
 
-							admaif14: endpoint {
-								remote-endpoint = <&xbar_admaif14>;
-							};
+						xbar_mix_out1: endpoint {
+							remote-endpoint = <&mix_out1>;
 						};
+					};
 
-						admaif15_port: port@f {
-							reg = <0xf>;
+					port@5f {
+						reg = <0x5f>;
 
-							admaif15: endpoint {
-								remote-endpoint = <&xbar_admaif15>;
-							};
+						xbar_mix_out2: endpoint {
+							remote-endpoint = <&mix_out2>;
 						};
+					};
 
-						admaif16_port: port@10 {
-							reg = <0x10>;
+					port@60 {
+						reg = <0x60>;
 
-							admaif16: endpoint {
-								remote-endpoint = <&xbar_admaif16>;
-							};
+						xbar_mix_out3: endpoint {
+							remote-endpoint = <&mix_out3>;
 						};
+					};
 
-						admaif17_port: port@11 {
-							reg = <0x11>;
+					port@61 {
+						reg = <0x61>;
 
-							admaif17: endpoint {
-								remote-endpoint = <&xbar_admaif17>;
-							};
+						xbar_mix_out4: endpoint {
+							remote-endpoint = <&mix_out4>;
 						};
+					};
 
-						admaif18_port: port@12 {
-							reg = <0x12>;
+					port@62 {
+						reg = <0x62>;
 
-							admaif18: endpoint {
-								remote-endpoint = <&xbar_admaif18>;
-							};
+						xbar_mix_out5: endpoint {
+							remote-endpoint = <&mix_out5>;
 						};
+					};
 
-						admaif19_port: port@13 {
-							reg = <0x13>;
+					xbar_asrc_in1_port: port@63 {
+						reg = <0x63>;
 
-							admaif19: endpoint {
-								remote-endpoint = <&xbar_admaif19>;
-							};
+						xbar_asrc_in1_ep: endpoint {
+							remote-endpoint = <&asrc_in1_ep>;
 						};
 					};
-				};
 
-				asrc@2910000 {
-					status = "okay";
+					port@64 {
+						reg = <0x64>;
 
-					ports {
-						#address-cells = <1>;
-						#size-cells = <0>;
+						xbar_asrc_out1_ep: endpoint {
+							remote-endpoint = <&asrc_out1_ep>;
+						};
+					};
 
-						port@0 {
-							reg = <0x0>;
+					xbar_asrc_in2_port: port@65 {
+						reg = <0x65>;
 
-							asrc_in1_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in1_ep>;
-							};
+						xbar_asrc_in2_ep: endpoint {
+							remote-endpoint = <&asrc_in2_ep>;
 						};
+					};
 
-						port@1 {
-							reg = <0x1>;
+					port@66 {
+						reg = <0x66>;
 
-							asrc_in2_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in2_ep>;
-							};
+						xbar_asrc_out2_ep: endpoint {
+							remote-endpoint = <&asrc_out2_ep>;
 						};
+					};
 
-						port@2 {
-							reg = <0x2>;
+					xbar_asrc_in3_port: port@67 {
+						reg = <0x67>;
 
-							asrc_in3_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in3_ep>;
-							};
+						xbar_asrc_in3_ep: endpoint {
+							remote-endpoint = <&asrc_in3_ep>;
 						};
+					};
 
-						port@3 {
-							reg = <0x3>;
+					port@68 {
+						reg = <0x68>;
 
-							asrc_in4_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in4_ep>;
-							};
+						xbar_asrc_out3_ep: endpoint {
+							remote-endpoint = <&asrc_out3_ep>;
 						};
+					};
 
-						port@4 {
-							reg = <0x4>;
+					xbar_asrc_in4_port: port@69 {
+						reg = <0x69>;
 
-							asrc_in5_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in5_ep>;
-							};
+						xbar_asrc_in4_ep: endpoint {
+							remote-endpoint = <&asrc_in4_ep>;
 						};
+					};
 
-						port@5 {
-							reg = <0x5>;
+					port@6a {
+						reg = <0x6a>;
 
-							asrc_in6_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in6_ep>;
-							};
+						xbar_asrc_out4_ep: endpoint {
+							remote-endpoint = <&asrc_out4_ep>;
 						};
+					};
 
-						port@6 {
-							reg = <0x6>;
+					xbar_asrc_in5_port: port@6b {
+						reg = <0x6b>;
 
-							asrc_in7_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_in7_ep>;
-							};
+						xbar_asrc_in5_ep: endpoint {
+							remote-endpoint = <&asrc_in5_ep>;
 						};
+					};
 
-						asrc_out1_port: port@7 {
-							reg = <0x7>;
+					port@6c {
+						reg = <0x6c>;
 
-							asrc_out1_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out1_ep>;
-							};
+						xbar_asrc_out5_ep: endpoint {
+							remote-endpoint = <&asrc_out5_ep>;
 						};
+					};
 
-						asrc_out2_port: port@8 {
-							reg = <0x8>;
+					xbar_asrc_in6_port: port@6d {
+						reg = <0x6d>;
 
-							asrc_out2_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out2_ep>;
-							};
+						xbar_asrc_in6_ep: endpoint {
+							remote-endpoint = <&asrc_in6_ep>;
 						};
+					};
 
-						asrc_out3_port: port@9 {
-							reg = <0x9>;
+					port@6e {
+						reg = <0x6e>;
 
-							asrc_out3_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out3_ep>;
-							};
+						xbar_asrc_out6_ep: endpoint {
+							remote-endpoint = <&asrc_out6_ep>;
 						};
+					};
 
-						asrc_out4_port: port@a {
-							reg = <0xa>;
+					xbar_asrc_in7_port: port@6f {
+						reg = <0x6f>;
 
-							asrc_out4_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out4_ep>;
-							};
+						xbar_asrc_in7_ep: endpoint {
+							remote-endpoint = <&asrc_in7_ep>;
 						};
+					};
 
-						asrc_out5_port: port@b {
-							reg = <0xb>;
+					xbar_ope1_in_port: port@70 {
+						reg = <0x70>;
 
-							asrc_out5_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out5_ep>;
-							};
+						xbar_ope1_in_ep: endpoint {
+							remote-endpoint = <&ope1_cif_in_ep>;
 						};
+					};
 
-						asrc_out6_port:	port@c {
-							reg = <0xc>;
+					port@71 {
+						reg = <0x71>;
 
-							asrc_out6_ep: endpoint {
-								remote-endpoint = <&xbar_asrc_out6_ep>;
-							};
+						xbar_ope1_out_ep: endpoint {
+							remote-endpoint = <&ope1_cif_out_ep>;
 						};
 					};
 				};
@@ -2022,14 +2027,7 @@ hda@3510000 {
 			nvidia,model = "NVIDIA Jetson AGX Orin HDA";
 			status = "okay";
 		};
-	};
-
-	chosen {
-		bootargs = "console=ttyTCU0,115200n8";
-		stdout-path = "serial0:115200n8";
-	};
 
-	bus@0 {
 		ethernet@6800000 {
 			status = "okay";
 
@@ -2129,6 +2127,14 @@ key-suspend {
 		};
 	};
 
+	pwm-fan {
+		compatible = "pwm-fan";
+		pwms = <&pwm3 0 45334>;
+
+		cooling-levels = <0 95 178 255>;
+		#cooling-cells = <2>;
+	};
+
 	serial {
 		status = "okay";
 	};
@@ -2195,12 +2201,4 @@ sound {
 
 		label = "NVIDIA Jetson AGX Orin APE";
 	};
-
-	pwm-fan {
-		compatible = "pwm-fan";
-		pwms = <&pwm3 0 45334>;
-
-		cooling-levels = <0 95 178 255>;
-		#cooling-cells = <2>;
-	};
 };
diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 3d680ee0f4d17..7a3112c82cdc7 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -22,6 +22,94 @@ bus@0 {
 		#size-cells = <2>;
 		ranges = <0x0 0x0 0x0 0x0 0x0 0x40000000>;
 
+		misc@100000 {
+			compatible = "nvidia,tegra234-misc";
+			reg = <0x0 0x00100000 0x0 0xf000>,
+			      <0x0 0x0010f000 0x0 0x1000>;
+			status = "okay";
+		};
+
+		timer@2080000 {
+			compatible = "nvidia,tegra234-timer";
+			reg = <0x0 0x02080000 0x0 0x00121000>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
+			status = "okay";
+		};
+
+		gpio: gpio@2200000 {
+			compatible = "nvidia,tegra234-gpio";
+			reg-names = "security", "gpio";
+			reg = <0x0 0x02200000 0x0 0x10000>,
+			      <0x0 0x02210000 0x0 0x10000>;
+			interrupts = <GIC_SPI 288 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 289 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 290 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 291 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 292 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 293 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 294 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 295 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 296 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 297 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 298 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 299 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 300 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 301 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 302 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 303 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 304 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 305 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 306 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 307 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 308 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 309 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 310 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 311 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 312 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 313 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 314 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 315 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 316 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 317 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 318 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 319 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 320 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 321 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 322 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 323 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 324 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 325 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 326 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 327 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 328 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 329 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 330 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 331 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 333 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>;
+			#interrupt-cells = <2>;
+			interrupt-controller;
+			#gpio-cells = <2>;
+			gpio-controller;
+		};
+
 		gpcdma: dma-controller@2600000 {
 			compatible = "nvidia,tegra234-gpcdma",
 				     "nvidia,tegra186-gpcdma";
@@ -518,194 +606,6 @@ agic: interrupt-controller@2a40000 {
 			};
 		};
 
-		misc@100000 {
-			compatible = "nvidia,tegra234-misc";
-			reg = <0x0 0x00100000 0x0 0xf000>,
-			      <0x0 0x0010f000 0x0 0x1000>;
-			status = "okay";
-		};
-
-		timer@2080000 {
-			compatible = "nvidia,tegra234-timer";
-			reg = <0x0 0x02080000 0x0 0x00121000>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
-			status = "okay";
-		};
-
-		host1x@13e00000 {
-			compatible = "nvidia,tegra234-host1x";
-			reg = <0x0 0x13e00000 0x0 0x10000>,
-			      <0x0 0x13e10000 0x0 0x10000>,
-			      <0x0 0x13e40000 0x0 0x10000>;
-			reg-names = "common", "hypervisor", "vm";
-			interrupts = <GIC_SPI 448 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 449 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 450 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 451 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 452 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 453 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 454 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 455 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 263 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "syncpt0", "syncpt1", "syncpt2", "syncpt3", "syncpt4",
-					  "syncpt5", "syncpt6", "syncpt7", "host1x";
-			clocks = <&bpmp TEGRA234_CLK_HOST1X>;
-			clock-names = "host1x";
-
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges = <0x0 0x14800000 0x0 0x14800000 0x0 0x02000000>;
-
-			interconnects = <&mc TEGRA234_MEMORY_CLIENT_HOST1XDMAR &emc>;
-			interconnect-names = "dma-mem";
-			iommus = <&smmu_niso1 TEGRA234_SID_HOST1X>;
-
-			/* Context isolation domains */
-			iommu-map = <0 &smmu_niso0 TEGRA234_SID_HOST1X_CTX0 1>,
-				    <1 &smmu_niso0 TEGRA234_SID_HOST1X_CTX1 1>,
-				    <2 &smmu_niso0 TEGRA234_SID_HOST1X_CTX2 1>,
-				    <3 &smmu_niso0 TEGRA234_SID_HOST1X_CTX3 1>,
-				    <4 &smmu_niso0 TEGRA234_SID_HOST1X_CTX4 1>,
-				    <5 &smmu_niso0 TEGRA234_SID_HOST1X_CTX5 1>,
-				    <6 &smmu_niso0 TEGRA234_SID_HOST1X_CTX6 1>,
-				    <7 &smmu_niso0 TEGRA234_SID_HOST1X_CTX7 1>,
-				    <8 &smmu_niso1 TEGRA234_SID_HOST1X_CTX0 1>,
-				    <9 &smmu_niso1 TEGRA234_SID_HOST1X_CTX1 1>,
-				    <10 &smmu_niso1 TEGRA234_SID_HOST1X_CTX2 1>,
-				    <11 &smmu_niso1 TEGRA234_SID_HOST1X_CTX3 1>,
-				    <12 &smmu_niso1 TEGRA234_SID_HOST1X_CTX4 1>,
-				    <13 &smmu_niso1 TEGRA234_SID_HOST1X_CTX5 1>,
-				    <14 &smmu_niso1 TEGRA234_SID_HOST1X_CTX6 1>,
-				    <15 &smmu_niso1 TEGRA234_SID_HOST1X_CTX7 1>;
-
-			vic@15340000 {
-				compatible = "nvidia,tegra234-vic";
-				reg = <0x0 0x15340000 0x0 0x00040000>;
-				interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&bpmp TEGRA234_CLK_VIC>;
-				clock-names = "vic";
-				resets = <&bpmp TEGRA234_RESET_VIC>;
-				reset-names = "vic";
-
-				power-domains = <&bpmp TEGRA234_POWER_DOMAIN_VIC>;
-				interconnects = <&mc TEGRA234_MEMORY_CLIENT_VICSRD &emc>,
-						<&mc TEGRA234_MEMORY_CLIENT_VICSWR &emc>;
-				interconnect-names = "dma-mem", "write";
-				iommus = <&smmu_niso1 TEGRA234_SID_VIC>;
-				dma-coherent;
-			};
-
-			nvdec@15480000 {
-				compatible = "nvidia,tegra234-nvdec";
-				reg = <0x0 0x15480000 0x0 0x00040000>;
-				clocks = <&bpmp TEGRA234_CLK_NVDEC>,
-					 <&bpmp TEGRA234_CLK_FUSE>,
-					 <&bpmp TEGRA234_CLK_TSEC_PKA>;
-				clock-names = "nvdec", "fuse", "tsec_pka";
-				resets = <&bpmp TEGRA234_RESET_NVDEC>;
-				reset-names = "nvdec";
-				power-domains = <&bpmp TEGRA234_POWER_DOMAIN_NVDEC>;
-				interconnects = <&mc TEGRA234_MEMORY_CLIENT_NVDECSRD &emc>,
-						<&mc TEGRA234_MEMORY_CLIENT_NVDECSWR &emc>;
-				interconnect-names = "dma-mem", "write";
-				iommus = <&smmu_niso1 TEGRA234_SID_NVDEC>;
-				dma-coherent;
-
-				nvidia,memory-controller = <&mc>;
-
-				/*
-				 * Placeholder values that firmware needs to update with the real
-				 * offsets parsed from the microcode headers.
-				 */
-				nvidia,bl-manifest-offset = <0>;
-				nvidia,bl-data-offset = <0>;
-				nvidia,bl-code-offset = <0>;
-				nvidia,os-manifest-offset = <0>;
-				nvidia,os-data-offset = <0>;
-				nvidia,os-code-offset = <0>;
-
-				/*
-				 * Firmware needs to set this to "okay" once the above values have
-				 * been updated.
-				 */
-				status = "disabled";
-			};
-		};
-
-		gpio: gpio@2200000 {
-			compatible = "nvidia,tegra234-gpio";
-			reg-names = "security", "gpio";
-			reg = <0x0 0x02200000 0x0 0x10000>,
-			      <0x0 0x02210000 0x0 0x10000>;
-			interrupts = <GIC_SPI 288 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 289 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 290 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 291 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 292 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 293 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 294 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 295 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 296 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 297 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 298 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 299 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 300 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 301 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 302 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 303 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 304 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 305 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 306 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 307 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 308 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 309 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 310 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 311 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 312 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 313 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 314 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 315 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 316 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 317 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 318 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 319 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 320 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 321 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 322 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 323 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 324 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 325 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 326 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 327 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 328 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 329 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 330 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 331 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 333 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>;
-			#interrupt-cells = <2>;
-			interrupt-controller;
-			#gpio-cells = <2>;
-			gpio-controller;
-		};
-
 		mc: memory-controller@2c00000 {
 			compatible = "nvidia,tegra234-mc";
 			reg = <0x0 0x02c00000 0x0 0x10000>,   /* MC-SID */
@@ -1690,18 +1590,13 @@ pmc: pmc@c360000 {
 			#interrupt-cells = <2>;
 			interrupt-controller;
 
-			sdmmc1_3v3: sdmmc1-3v3 {
-				pins = "sdmmc1-hv";
-				power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
-			};
-
 			sdmmc1_1v8: sdmmc1-1v8 {
 				pins = "sdmmc1-hv";
 				power-source = <TEGRA_IO_PAD_VOLTAGE_1V8>;
 			};
 
-			sdmmc3_3v3: sdmmc3-3v3 {
-				pins = "sdmmc3-hv";
+			sdmmc1_3v3: sdmmc1-3v3 {
+				pins = "sdmmc1-hv";
 				power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
 			};
 
@@ -1709,6 +1604,11 @@ sdmmc3_1v8: sdmmc3-1v8 {
 				pins = "sdmmc3-hv";
 				power-source = <TEGRA_IO_PAD_VOLTAGE_1V8>;
 			};
+
+			sdmmc3_3v3: sdmmc3-3v3 {
+				pins = "sdmmc3-hv";
+				power-source = <TEGRA_IO_PAD_VOLTAGE_3V3>;
+			};
 		};
 
 		aon-fabric@c600000 {
@@ -2040,6 +1940,106 @@ cbb-fabric@13a00000 {
 			status = "okay";
 		};
 
+		host1x@13e00000 {
+			compatible = "nvidia,tegra234-host1x";
+			reg = <0x0 0x13e00000 0x0 0x10000>,
+			      <0x0 0x13e10000 0x0 0x10000>,
+			      <0x0 0x13e40000 0x0 0x10000>;
+			reg-names = "common", "hypervisor", "vm";
+			interrupts = <GIC_SPI 448 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 449 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 450 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 451 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 452 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 453 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 454 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 455 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 263 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "syncpt0", "syncpt1", "syncpt2", "syncpt3", "syncpt4",
+					  "syncpt5", "syncpt6", "syncpt7", "host1x";
+			clocks = <&bpmp TEGRA234_CLK_HOST1X>;
+			clock-names = "host1x";
+
+			#address-cells = <2>;
+			#size-cells = <2>;
+			ranges = <0x0 0x14800000 0x0 0x14800000 0x0 0x02000000>;
+
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_HOST1XDMAR &emc>;
+			interconnect-names = "dma-mem";
+			iommus = <&smmu_niso1 TEGRA234_SID_HOST1X>;
+
+			/* Context isolation domains */
+			iommu-map = <0 &smmu_niso0 TEGRA234_SID_HOST1X_CTX0 1>,
+				    <1 &smmu_niso0 TEGRA234_SID_HOST1X_CTX1 1>,
+				    <2 &smmu_niso0 TEGRA234_SID_HOST1X_CTX2 1>,
+				    <3 &smmu_niso0 TEGRA234_SID_HOST1X_CTX3 1>,
+				    <4 &smmu_niso0 TEGRA234_SID_HOST1X_CTX4 1>,
+				    <5 &smmu_niso0 TEGRA234_SID_HOST1X_CTX5 1>,
+				    <6 &smmu_niso0 TEGRA234_SID_HOST1X_CTX6 1>,
+				    <7 &smmu_niso0 TEGRA234_SID_HOST1X_CTX7 1>,
+				    <8 &smmu_niso1 TEGRA234_SID_HOST1X_CTX0 1>,
+				    <9 &smmu_niso1 TEGRA234_SID_HOST1X_CTX1 1>,
+				    <10 &smmu_niso1 TEGRA234_SID_HOST1X_CTX2 1>,
+				    <11 &smmu_niso1 TEGRA234_SID_HOST1X_CTX3 1>,
+				    <12 &smmu_niso1 TEGRA234_SID_HOST1X_CTX4 1>,
+				    <13 &smmu_niso1 TEGRA234_SID_HOST1X_CTX5 1>,
+				    <14 &smmu_niso1 TEGRA234_SID_HOST1X_CTX6 1>,
+				    <15 &smmu_niso1 TEGRA234_SID_HOST1X_CTX7 1>;
+
+			vic@15340000 {
+				compatible = "nvidia,tegra234-vic";
+				reg = <0x0 0x15340000 0x0 0x00040000>;
+				interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&bpmp TEGRA234_CLK_VIC>;
+				clock-names = "vic";
+				resets = <&bpmp TEGRA234_RESET_VIC>;
+				reset-names = "vic";
+
+				power-domains = <&bpmp TEGRA234_POWER_DOMAIN_VIC>;
+				interconnects = <&mc TEGRA234_MEMORY_CLIENT_VICSRD &emc>,
+						<&mc TEGRA234_MEMORY_CLIENT_VICSWR &emc>;
+				interconnect-names = "dma-mem", "write";
+				iommus = <&smmu_niso1 TEGRA234_SID_VIC>;
+				dma-coherent;
+			};
+
+			nvdec@15480000 {
+				compatible = "nvidia,tegra234-nvdec";
+				reg = <0x0 0x15480000 0x0 0x00040000>;
+				clocks = <&bpmp TEGRA234_CLK_NVDEC>,
+					 <&bpmp TEGRA234_CLK_FUSE>,
+					 <&bpmp TEGRA234_CLK_TSEC_PKA>;
+				clock-names = "nvdec", "fuse", "tsec_pka";
+				resets = <&bpmp TEGRA234_RESET_NVDEC>;
+				reset-names = "nvdec";
+				power-domains = <&bpmp TEGRA234_POWER_DOMAIN_NVDEC>;
+				interconnects = <&mc TEGRA234_MEMORY_CLIENT_NVDECSRD &emc>,
+						<&mc TEGRA234_MEMORY_CLIENT_NVDECSWR &emc>;
+				interconnect-names = "dma-mem", "write";
+				iommus = <&smmu_niso1 TEGRA234_SID_NVDEC>;
+				dma-coherent;
+
+				nvidia,memory-controller = <&mc>;
+
+				/*
+				 * Placeholder values that firmware needs to update with the real
+				 * offsets parsed from the microcode headers.
+				 */
+				nvidia,bl-manifest-offset = <0>;
+				nvidia,bl-data-offset = <0>;
+				nvidia,bl-code-offset = <0>;
+				nvidia,os-manifest-offset = <0>;
+				nvidia,os-data-offset = <0>;
+				nvidia,os-code-offset = <0>;
+
+				/*
+				 * Firmware needs to set this to "okay" once the above values have
+				 * been updated.
+				 */
+				status = "disabled";
+			};
+		};
+
 		pcie@140a0000 {
 			compatible = "nvidia,tegra234-pcie";
 			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_PCIEX4CA>;
-- 
2.39.2



