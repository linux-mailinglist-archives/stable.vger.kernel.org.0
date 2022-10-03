Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA925F2BA8
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 10:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiJCIY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 04:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiJCIXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 04:23:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAD7DFB1;
        Mon,  3 Oct 2022 00:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6992660FC1;
        Mon,  3 Oct 2022 07:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D15C433D6;
        Mon,  3 Oct 2022 07:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781800;
        bh=STakGTsX/N4qcxMRJf2QCaaSt/k3EDXQqGJJhtzSFtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AoZghiIh+aEQC2iIPSJLSqAzJJ7vAzNqA4yaLgjiUj3LV06UcE44Q2LEpceCHFCW3
         DOw7P0C0GBsSWCqnY1c8bdRIdt00bwxNoNz55ZQiWIjV2AMZHbyq76gkpXZzr/NiSZ
         rt0h35JVgKndZLk3yeKTpPLigpcOau/+gMdY2aIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/30] ARM: dts: Move am33xx and am43xx mmc nodes to sdhci-omap driver
Date:   Mon,  3 Oct 2022 09:11:58 +0200
Message-Id: <20221003070716.771590211@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
References: <20221003070716.269502440@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

[ Upstream commit 0b4edf111870b83ea77b1d7e16b8ceac29f9f388 ]

Move mmc nodes to be compatible with the sdhci-omap driver. The following
modifications are required for omap_hsmmc specific properties:

ti,non-removable: convert to the generic mmc non-removable
ti,needs-special-reset:  co-opted into the sdhci-omap driver
ti,dual-volt: removed. Legacy property not used in am335x or am43xx
ti,needs-special-hs-handling: removed. Legacy property not used in am335x
or am43xx

Also since the sdhci-omap driver does not support runtime PM, explicitly
disable the mmc3 instance in the dtsi.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Stable-dep-of: 2eb502f496f7 ("ARM: dts: am33xx: Fix MMCHS0 dma properties")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-baltos.dtsi              | 2 +-
 arch/arm/boot/dts/am335x-boneblack-common.dtsi    | 1 +
 arch/arm/boot/dts/am335x-boneblack-wireless.dts   | 1 -
 arch/arm/boot/dts/am335x-boneblue.dts             | 1 -
 arch/arm/boot/dts/am335x-bonegreen-wireless.dts   | 1 -
 arch/arm/boot/dts/am335x-evm.dts                  | 3 +--
 arch/arm/boot/dts/am335x-evmsk.dts                | 2 +-
 arch/arm/boot/dts/am335x-lxm.dts                  | 2 +-
 arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi | 2 +-
 arch/arm/boot/dts/am335x-moxa-uc-8100-me-t.dts    | 2 +-
 arch/arm/boot/dts/am335x-pepper.dts               | 4 ++--
 arch/arm/boot/dts/am335x-phycore-som.dtsi         | 2 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                  | 6 ++----
 arch/arm/boot/dts/am33xx.dtsi                     | 3 ++-
 arch/arm/boot/dts/am4372.dtsi                     | 3 ++-
 arch/arm/boot/dts/am437x-cm-t43.dts               | 2 +-
 arch/arm/boot/dts/am437x-gp-evm.dts               | 4 ++--
 arch/arm/boot/dts/am437x-l4.dtsi                  | 5 ++---
 arch/arm/boot/dts/am437x-sk-evm.dts               | 2 +-
 19 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-baltos.dtsi b/arch/arm/boot/dts/am335x-baltos.dtsi
index ed235f263e29..ee84155844ad 100644
--- a/arch/arm/boot/dts/am335x-baltos.dtsi
+++ b/arch/arm/boot/dts/am335x-baltos.dtsi
@@ -381,7 +381,7 @@
 &mmc2 {
 	status = "okay";
 	vmmc-supply = <&wl12xx_vmmc>;
-	ti,non-removable;
+	non-removable;
 	bus-width = <4>;
 	cap-power-off-card;
 	pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/am335x-boneblack-common.dtsi b/arch/arm/boot/dts/am335x-boneblack-common.dtsi
index 91f93bc89716..dd932220a8bf 100644
--- a/arch/arm/boot/dts/am335x-boneblack-common.dtsi
+++ b/arch/arm/boot/dts/am335x-boneblack-common.dtsi
@@ -22,6 +22,7 @@
 	pinctrl-0 = <&emmc_pins>;
 	bus-width = <8>;
 	status = "okay";
+	non-removable;
 };
 
 &am33xx_pinmux {
diff --git a/arch/arm/boot/dts/am335x-boneblack-wireless.dts b/arch/arm/boot/dts/am335x-boneblack-wireless.dts
index 3124d94c0b3c..e07dd7979586 100644
--- a/arch/arm/boot/dts/am335x-boneblack-wireless.dts
+++ b/arch/arm/boot/dts/am335x-boneblack-wireless.dts
@@ -75,7 +75,6 @@
 	bus-width = <4>;
 	non-removable;
 	cap-power-off-card;
-	ti,needs-special-hs-handling;
 	keep-power-in-suspend;
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc3_pins &wl18xx_pins>;
diff --git a/arch/arm/boot/dts/am335x-boneblue.dts b/arch/arm/boot/dts/am335x-boneblue.dts
index 2f6652ef9a15..30b62de86b5b 100644
--- a/arch/arm/boot/dts/am335x-boneblue.dts
+++ b/arch/arm/boot/dts/am335x-boneblue.dts
@@ -389,7 +389,6 @@
 	bus-width = <4>;
 	non-removable;
 	cap-power-off-card;
-	ti,needs-special-hs-handling;
 	keep-power-in-suspend;
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc3_pins &wl18xx_pins>;
diff --git a/arch/arm/boot/dts/am335x-bonegreen-wireless.dts b/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
index 4092cd193b8a..609c8db687ec 100644
--- a/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
+++ b/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
@@ -75,7 +75,6 @@
 	bus-width = <4>;
 	non-removable;
 	cap-power-off-card;
-	ti,needs-special-hs-handling;
 	keep-power-in-suspend;
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc3_pins &wl18xx_pins>;
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index a00145705c9b..af25b42e85f4 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -782,8 +782,7 @@
 	bus-width = <4>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc3_pins &wlan_pins>;
-	ti,non-removable;
-	ti,needs-special-hs-handling;
+	non-removable;
 	cap-power-off-card;
 	keep-power-in-suspend;
 
diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index e28a5b82fdf3..7805b0618a4f 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -700,7 +700,7 @@
 &mmc2 {
 	status = "okay";
 	vmmc-supply = <&wl12xx_vmmc>;
-	ti,non-removable;
+	non-removable;
 	bus-width = <4>;
 	cap-power-off-card;
 	keep-power-in-suspend;
diff --git a/arch/arm/boot/dts/am335x-lxm.dts b/arch/arm/boot/dts/am335x-lxm.dts
index a8005e975ea2..c3bfd8ed5f88 100644
--- a/arch/arm/boot/dts/am335x-lxm.dts
+++ b/arch/arm/boot/dts/am335x-lxm.dts
@@ -361,7 +361,7 @@
 	pinctrl-0 = <&emmc_pins>;
 	vmmc-supply = <&vmmcsd_fixed>;
 	bus-width = <8>;
-	ti,non-removable;
+	non-removable;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi b/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi
index 671d4a5da9c4..7749122dad71 100644
--- a/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi
+++ b/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi
@@ -176,7 +176,7 @@
 	vmmc-supply = <&vmmcsd_fixed>;
 	bus-width = <8>;
 	pinctrl-0 = <&mmc1_pins_default>;
-	ti,non-removable;
+	non-removable;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/am335x-moxa-uc-8100-me-t.dts b/arch/arm/boot/dts/am335x-moxa-uc-8100-me-t.dts
index 783d411f2cef..66a5c09ff388 100644
--- a/arch/arm/boot/dts/am335x-moxa-uc-8100-me-t.dts
+++ b/arch/arm/boot/dts/am335x-moxa-uc-8100-me-t.dts
@@ -473,7 +473,7 @@
 	vmmc-supply = <&vmmcsd_fixed>;
 	bus-width = <8>;
 	pinctrl-0 = <&mmc2_pins_default>;
-	ti,non-removable;
+	non-removable;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/am335x-pepper.dts b/arch/arm/boot/dts/am335x-pepper.dts
index e7764ecdf65f..03852eff2b3c 100644
--- a/arch/arm/boot/dts/am335x-pepper.dts
+++ b/arch/arm/boot/dts/am335x-pepper.dts
@@ -341,7 +341,7 @@
 	pinctrl-0 = <&emmc_pins>;
 	vmmc-supply = <&ldo3_reg>;
 	bus-width = <8>;
-	ti,non-removable;
+	non-removable;
 };
 
 &mmc3 {
@@ -351,7 +351,7 @@
 	pinctrl-0 = <&wireless_pins>;
 	vmmmc-supply = <&v3v3c_reg>;
 	bus-width = <4>;
-	ti,non-removable;
+	non-removable;
 	dmas = <&edma_xbar 12 0 1
 		&edma_xbar 13 0 2>;
 	dma-names = "tx", "rx";
diff --git a/arch/arm/boot/dts/am335x-phycore-som.dtsi b/arch/arm/boot/dts/am335x-phycore-som.dtsi
index 3d0672b53d77..7e46b4c02709 100644
--- a/arch/arm/boot/dts/am335x-phycore-som.dtsi
+++ b/arch/arm/boot/dts/am335x-phycore-som.dtsi
@@ -69,7 +69,7 @@
 	pinctrl-0 = <&emmc_pins>;
 	vmmc-supply = <&vmmc_reg>;
 	bus-width = <8>;
-	ti,non-removable;
+	non-removable;
 	status = "disabled";
 };
 
diff --git a/arch/arm/boot/dts/am33xx-l4.dtsi b/arch/arm/boot/dts/am33xx-l4.dtsi
index 7a9eb2b0d45b..b0fe02a91c37 100644
--- a/arch/arm/boot/dts/am33xx-l4.dtsi
+++ b/arch/arm/boot/dts/am33xx-l4.dtsi
@@ -1333,10 +1333,8 @@
 			ranges = <0x0 0x60000 0x1000>;
 
 			mmc1: mmc@0 {
-				compatible = "ti,omap4-hsmmc";
-				ti,dual-volt;
+				compatible = "ti,am335-sdhci";
 				ti,needs-special-reset;
-				ti,needs-special-hs-handling;
 				dmas = <&edma_xbar 24 0 0
 					&edma_xbar 25 0 0>;
 				dma-names = "tx", "rx";
@@ -1827,7 +1825,7 @@
 			ranges = <0x0 0xd8000 0x1000>;
 
 			mmc2: mmc@0 {
-				compatible = "ti,omap4-hsmmc";
+				compatible = "ti,am335-sdhci";
 				ti,needs-special-reset;
 				dmas = <&edma 2 0
 					&edma 3 0>;
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 77fa7c0f2104..efe36f395bdd 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -259,10 +259,11 @@
 			ranges = <0x0 0x47810000 0x1000>;
 
 			mmc3: mmc@0 {
-				compatible = "ti,omap4-hsmmc";
+				compatible = "ti,am335-sdhci";
 				ti,needs-special-reset;
 				interrupts = <29>;
 				reg = <0x0 0x1000>;
+				status = "disabled";
 			};
 		};
 
diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 14bbc438055f..c5b67993743d 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -250,10 +250,11 @@
 			ranges = <0x0 0x47810000 0x1000>;
 
 			mmc3: mmc@0 {
-				compatible = "ti,omap4-hsmmc";
+				compatible = "ti,am437-sdhci";
 				ti,needs-special-reset;
 				interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
 				reg = <0x0 0x1000>;
+				status = "disabled";
 			};
 		};
 
diff --git a/arch/arm/boot/dts/am437x-cm-t43.dts b/arch/arm/boot/dts/am437x-cm-t43.dts
index 063113a5da2d..a6b4fca8626a 100644
--- a/arch/arm/boot/dts/am437x-cm-t43.dts
+++ b/arch/arm/boot/dts/am437x-cm-t43.dts
@@ -291,7 +291,7 @@
 	pinctrl-0 = <&emmc_pins>;
 	vmmc-supply = <&vmmc_3v3>;
 	bus-width = <8>;
-	ti,non-removable;
+	non-removable;
 };
 
 &spi0 {
diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
index 126965a34841..448853701d3d 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -872,7 +872,7 @@
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&emmc_pins_default>;
 	pinctrl-1 = <&emmc_pins_sleep>;
-	ti,non-removable;
+	non-removable;
 };
 
 &mmc3 {
@@ -889,7 +889,7 @@
 	pinctrl-1 = <&mmc3_pins_sleep>;
 	cap-power-off-card;
 	keep-power-in-suspend;
-	ti,non-removable;
+	non-removable;
 
 	#address-cells = <1>;
 	#size-cells = <0>;
diff --git a/arch/arm/boot/dts/am437x-l4.dtsi b/arch/arm/boot/dts/am437x-l4.dtsi
index 64fdd5079d49..8c9e7e723fc9 100644
--- a/arch/arm/boot/dts/am437x-l4.dtsi
+++ b/arch/arm/boot/dts/am437x-l4.dtsi
@@ -1104,9 +1104,8 @@
 			ranges = <0x0 0x60000 0x1000>;
 
 			mmc1: mmc@0 {
-				compatible = "ti,omap4-hsmmc";
+				compatible = "ti,am437-sdhci";
 				reg = <0x0 0x1000>;
-				ti,dual-volt;
 				ti,needs-special-reset;
 				dmas = <&edma 24 0>,
 					<&edma 25 0>;
@@ -1641,7 +1640,7 @@
 			ranges = <0x0 0xd8000 0x1000>;
 
 			mmc2: mmc@0 {
-				compatible = "ti,omap4-hsmmc";
+				compatible = "ti,am437-sdhci";
 				reg = <0x0 0x1000>;
 				ti,needs-special-reset;
 				dmas = <&edma 2 0>,
diff --git a/arch/arm/boot/dts/am437x-sk-evm.dts b/arch/arm/boot/dts/am437x-sk-evm.dts
index 74eaa6a3b258..292153c6cb5d 100644
--- a/arch/arm/boot/dts/am437x-sk-evm.dts
+++ b/arch/arm/boot/dts/am437x-sk-evm.dts
@@ -694,7 +694,7 @@
 	pinctrl-1 = <&mmc3_pins_sleep>;
 	cap-power-off-card;
 	keep-power-in-suspend;
-	ti,non-removable;
+	non-removable;
 
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
2.35.1



