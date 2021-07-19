Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4193CE414
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347759AbhGSPmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348958AbhGSPfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0FE661355;
        Mon, 19 Jul 2021 16:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711343;
        bh=Y6/GUeuMad5FiLq+fvHnrAuMdO/GG+zSuEHNyBwYqC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdM+a310uaznWkrZl+hBYual4pzap/g2YpxdZhCOEM7W9G+iJr/R1/ePju0Wy9UBo
         GLmEQ+J7YZhWdUs+vbpuoexs6wYynq2U4uYNNS/4axST/Fv/loe6SYArmA8MJb/gPN
         yNPJnjXwbthEtUokgzoUR9/4wQqrHAO4v5TCAd+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gowtham Tammana <g-tammana@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 319/351] ARM: dts: dra7: Fix duplicate USB4 target module node
Date:   Mon, 19 Jul 2021 16:54:25 +0200
Message-Id: <20210719144955.609005577@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gowtham Tammana <g-tammana@ti.com>

[ Upstream commit 78b4b165280d3d70e7a217599f0c06a4c0bb11f9 ]

With [1] USB4 target-module node got defined in dra74x.dtsi file.
However, the earlier definition in [2] was not removed, and this
duplication of the target module is causing boot failure on dra74
variant boards - dra7-evm, dra76-evm.

USB4 is only present in DRA74x variants, so keeping the entry in
dra74x.dtsi and removing it from the top level interconnect hierarchy
dra7-l4.dtsi file. This change makes the USB4 target module no longer
visible to AM5718, DRA71x and DRA72x so removing references to it in
their respective dts files.

[1]: commit c7b72abca61ec ("ARM: OMAP2+: Drop legacy platform data for
dra7 dwc3")
[2]: commit 549fce068a311 ("ARM: dts: dra7: Add l4 interconnect
hierarchy and ti-sysc data")

Fixes: c7b72abca61ec ("ARM: OMAP2+: Drop legacy platform data for dra7 dwc3")
Signed-off-by: Gowtham Tammana <g-tammana@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am5718.dtsi  |  6 +--
 arch/arm/boot/dts/dra7-l4.dtsi | 22 --------
 arch/arm/boot/dts/dra71x.dtsi  |  4 --
 arch/arm/boot/dts/dra72x.dtsi  |  4 --
 arch/arm/boot/dts/dra74x.dtsi  | 92 ++++++++++++++++++----------------
 5 files changed, 50 insertions(+), 78 deletions(-)

diff --git a/arch/arm/boot/dts/am5718.dtsi b/arch/arm/boot/dts/am5718.dtsi
index ebf4d3cc1cfb..6d7530a48c73 100644
--- a/arch/arm/boot/dts/am5718.dtsi
+++ b/arch/arm/boot/dts/am5718.dtsi
@@ -17,17 +17,13 @@
  * VCP1, VCP2
  * MLB
  * ISS
- * USB3, USB4
+ * USB3
  */
 
 &usb3_tm {
 	status = "disabled";
 };
 
-&usb4_tm {
-	status = "disabled";
-};
-
 &atl_tm {
 	status = "disabled";
 };
diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index 149144cdff35..648d23f7f748 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -4129,28 +4129,6 @@
 			};
 		};
 
-		usb4_tm: target-module@140000 {		/* 0x48940000, ap 75 3c.0 */
-			compatible = "ti,sysc-omap4", "ti,sysc";
-			reg = <0x140000 0x4>,
-			      <0x140010 0x4>;
-			reg-names = "rev", "sysc";
-			ti,sysc-mask = <SYSC_OMAP4_DMADISABLE>;
-			ti,sysc-midle = <SYSC_IDLE_FORCE>,
-					<SYSC_IDLE_NO>,
-					<SYSC_IDLE_SMART>,
-					<SYSC_IDLE_SMART_WKUP>;
-			ti,sysc-sidle = <SYSC_IDLE_FORCE>,
-					<SYSC_IDLE_NO>,
-					<SYSC_IDLE_SMART>,
-					<SYSC_IDLE_SMART_WKUP>;
-			/* Domains (P, C): l3init_pwrdm, l3init_clkdm */
-			clocks = <&l3init_clkctrl DRA7_L3INIT_USB_OTG_SS4_CLKCTRL 0>;
-			clock-names = "fck";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0x0 0x140000 0x20000>;
-		};
-
 		target-module@170000 {			/* 0x48970000, ap 21 0a.0 */
 			compatible = "ti,sysc-omap4", "ti,sysc";
 			reg = <0x170010 0x4>;
diff --git a/arch/arm/boot/dts/dra71x.dtsi b/arch/arm/boot/dts/dra71x.dtsi
index cad0e4a2bd8d..9c270d8f75d5 100644
--- a/arch/arm/boot/dts/dra71x.dtsi
+++ b/arch/arm/boot/dts/dra71x.dtsi
@@ -11,7 +11,3 @@
 &rtctarget {
 	status = "disabled";
 };
-
-&usb4_tm {
-	status = "disabled";
-};
diff --git a/arch/arm/boot/dts/dra72x.dtsi b/arch/arm/boot/dts/dra72x.dtsi
index d403acc754b6..f3e934ef7d3e 100644
--- a/arch/arm/boot/dts/dra72x.dtsi
+++ b/arch/arm/boot/dts/dra72x.dtsi
@@ -108,7 +108,3 @@
 &pcie2_rc {
 	compatible = "ti,dra726-pcie-rc", "ti,dra7-pcie";
 };
-
-&usb4_tm {
-	status = "disabled";
-};
diff --git a/arch/arm/boot/dts/dra74x.dtsi b/arch/arm/boot/dts/dra74x.dtsi
index e1850d6c841a..b4e07d99ffde 100644
--- a/arch/arm/boot/dts/dra74x.dtsi
+++ b/arch/arm/boot/dts/dra74x.dtsi
@@ -49,49 +49,6 @@
 			reg = <0x41500000 0x100>;
 		};
 
-		target-module@48940000 {
-			compatible = "ti,sysc-omap4", "ti,sysc";
-			reg = <0x48940000 0x4>,
-			      <0x48940010 0x4>;
-			reg-names = "rev", "sysc";
-			ti,sysc-mask = <SYSC_OMAP4_DMADISABLE>;
-			ti,sysc-midle = <SYSC_IDLE_FORCE>,
-					<SYSC_IDLE_NO>,
-					<SYSC_IDLE_SMART>,
-					<SYSC_IDLE_SMART_WKUP>;
-			ti,sysc-sidle = <SYSC_IDLE_FORCE>,
-					<SYSC_IDLE_NO>,
-					<SYSC_IDLE_SMART>,
-					<SYSC_IDLE_SMART_WKUP>;
-			clocks = <&l3init_clkctrl DRA7_L3INIT_USB_OTG_SS4_CLKCTRL 0>;
-			clock-names = "fck";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0x0 0x48940000 0x20000>;
-
-			omap_dwc3_4: omap_dwc3_4@0 {
-				compatible = "ti,dwc3";
-				reg = <0 0x10000>;
-				interrupts = <GIC_SPI 346 IRQ_TYPE_LEVEL_HIGH>;
-				#address-cells = <1>;
-				#size-cells = <1>;
-				utmi-mode = <2>;
-				ranges;
-				status = "disabled";
-				usb4: usb@10000 {
-					compatible = "snps,dwc3";
-					reg = <0x10000 0x17000>;
-					interrupts = <GIC_SPI 345 IRQ_TYPE_LEVEL_HIGH>,
-						     <GIC_SPI 345 IRQ_TYPE_LEVEL_HIGH>,
-						     <GIC_SPI 346 IRQ_TYPE_LEVEL_HIGH>;
-					interrupt-names = "peripheral",
-							  "host",
-							  "otg";
-					maximum-speed = "high-speed";
-					dr_mode = "otg";
-				};
-			};
-		};
 
 		target-module@41501000 {
 			compatible = "ti,sysc-omap2", "ti,sysc";
@@ -224,3 +181,52 @@
 &pcie2_rc {
 	compatible = "ti,dra746-pcie-rc", "ti,dra7-pcie";
 };
+
+&l4_per3 {
+	segment@0 {
+		usb4_tm: target-module@140000 {         /* 0x48940000, ap 75 3c.0 */
+			compatible = "ti,sysc-omap4", "ti,sysc";
+			reg = <0x140000 0x4>,
+			      <0x140010 0x4>;
+			reg-names = "rev", "sysc";
+			ti,sysc-mask = <SYSC_OMAP4_DMADISABLE>;
+			ti,sysc-midle = <SYSC_IDLE_FORCE>,
+					<SYSC_IDLE_NO>,
+					<SYSC_IDLE_SMART>,
+					<SYSC_IDLE_SMART_WKUP>;
+			ti,sysc-sidle = <SYSC_IDLE_FORCE>,
+					<SYSC_IDLE_NO>,
+					<SYSC_IDLE_SMART>,
+					<SYSC_IDLE_SMART_WKUP>;
+			/* Domains (P, C): l3init_pwrdm, l3init_clkdm */
+			clocks = <&l3init_clkctrl DRA7_L3INIT_USB_OTG_SS4_CLKCTRL 0>;
+			clock-names = "fck";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0x0 0x140000 0x20000>;
+
+			omap_dwc3_4: omap_dwc3_4@0 {
+				compatible = "ti,dwc3";
+				reg = <0 0x10000>;
+				interrupts = <GIC_SPI 346 IRQ_TYPE_LEVEL_HIGH>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				utmi-mode = <2>;
+				ranges;
+				status = "disabled";
+				usb4: usb@10000 {
+					compatible = "snps,dwc3";
+					reg = <0x10000 0x17000>;
+					interrupts = <GIC_SPI 345 IRQ_TYPE_LEVEL_HIGH>,
+						     <GIC_SPI 345 IRQ_TYPE_LEVEL_HIGH>,
+						     <GIC_SPI 346 IRQ_TYPE_LEVEL_HIGH>;
+					interrupt-names = "peripheral",
+							  "host",
+							  "otg";
+					maximum-speed = "high-speed";
+					dr_mode = "otg";
+				};
+			};
+		};
+	};
+};
-- 
2.30.2



