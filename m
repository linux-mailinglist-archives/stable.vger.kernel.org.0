Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C8A3CE3C5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbhGSPkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349823AbhGSPgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:36:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43A59606A5;
        Mon, 19 Jul 2021 16:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711420;
        bh=NdMQyKUo3ojIBs29U5e9s9o6VJj+zAlZWH7JPvaFnts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w497I79wTj4euW5cBTMnq1zVP3iiJOrU0AuMCCTo09p0WgzuMb4rbG57kZQfiQ7h/
         E569tA5u/6Zh05zGLlZhZtDrT47/xE8rGRZIOLV5oV+UsQW+a6/XTLb6yLIA0rVgVP
         dO3llCCxgKDLnLqr/7prVSfnBmedj6ScJjC1ugTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 313/351] arm64: dts: ti: k3-j721e-main: Fix external refclk input to SERDES
Date:   Mon, 19 Jul 2021 16:54:19 +0200
Message-Id: <20210719144955.407928773@linuxfoundation.org>
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

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 5c6d0b55b46aeb91355e6a9616decf50a3778c91 ]

Rename the external refclk inputs to the SERDES from
dummy_cmn_refclk/dummy_cmn_refclk1 to cmn_refclk/cmn_refclk1
respectively. Also move the external refclk DT nodes outside the
cbass_main DT node. Since in j721e common processor board, only the
cmn_refclk1 is connected to 100MHz clock, fix the clock frequency.

Fixes: afd094ebe69f ("arm64: dts: ti: k3-j721e-main: Add WIZ and SERDES PHY nodes")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210603143427.28735-2-kishon@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/ti/k3-j721e-common-proc-board.dts     |  4 ++
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi     | 58 ++++++++++---------
 2 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
index 60764366e22b..86f7ab511ee8 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -635,6 +635,10 @@
 	status = "disabled";
 };
 
+&cmn_refclk1 {
+	clock-frequency = <100000000>;
+};
+
 &serdes0 {
 	serdes0_pcie_link: link@0 {
 		reg = <0>;
diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 3bcafe4c1742..9ce4afd6da62 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -8,6 +8,20 @@
 #include <dt-bindings/mux/mux.h>
 #include <dt-bindings/mux/ti-serdes.h>
 
+/ {
+	cmn_refclk: clock-cmnrefclk {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <0>;
+	};
+
+	cmn_refclk1: clock-cmnrefclk1 {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <0>;
+	};
+};
+
 &cbass_main {
 	msmc_ram: sram@70000000 {
 		compatible = "mmio-sram";
@@ -338,24 +352,12 @@
 		pinctrl-single,function-mask = <0xffffffff>;
 	};
 
-	dummy_cmn_refclk: dummy-cmn-refclk {
-		#clock-cells = <0>;
-		compatible = "fixed-clock";
-		clock-frequency = <100000000>;
-	};
-
-	dummy_cmn_refclk1: dummy-cmn-refclk1 {
-		#clock-cells = <0>;
-		compatible = "fixed-clock";
-		clock-frequency = <100000000>;
-	};
-
 	serdes_wiz0: wiz@5000000 {
 		compatible = "ti,j721e-wiz-16g";
 		#address-cells = <1>;
 		#size-cells = <1>;
 		power-domains = <&k3_pds 292 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 292 5>, <&k3_clks 292 11>, <&dummy_cmn_refclk>;
+		clocks = <&k3_clks 292 5>, <&k3_clks 292 11>, <&cmn_refclk>;
 		clock-names = "fck", "core_ref_clk", "ext_ref_clk";
 		assigned-clocks = <&k3_clks 292 11>, <&k3_clks 292 0>;
 		assigned-clock-parents = <&k3_clks 292 15>, <&k3_clks 292 4>;
@@ -364,21 +366,21 @@
 		ranges = <0x5000000 0x0 0x5000000 0x10000>;
 
 		wiz0_pll0_refclk: pll0-refclk {
-			clocks = <&k3_clks 292 11>, <&dummy_cmn_refclk>;
+			clocks = <&k3_clks 292 11>, <&cmn_refclk>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz0_pll0_refclk>;
 			assigned-clock-parents = <&k3_clks 292 11>;
 		};
 
 		wiz0_pll1_refclk: pll1-refclk {
-			clocks = <&k3_clks 292 0>, <&dummy_cmn_refclk1>;
+			clocks = <&k3_clks 292 0>, <&cmn_refclk1>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz0_pll1_refclk>;
 			assigned-clock-parents = <&k3_clks 292 0>;
 		};
 
 		wiz0_refclk_dig: refclk-dig {
-			clocks = <&k3_clks 292 11>, <&k3_clks 292 0>, <&dummy_cmn_refclk>, <&dummy_cmn_refclk1>;
+			clocks = <&k3_clks 292 11>, <&k3_clks 292 0>, <&cmn_refclk>, <&cmn_refclk1>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz0_refclk_dig>;
 			assigned-clock-parents = <&k3_clks 292 11>;
@@ -412,7 +414,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		power-domains = <&k3_pds 293 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 293 5>, <&k3_clks 293 13>, <&dummy_cmn_refclk>;
+		clocks = <&k3_clks 293 5>, <&k3_clks 293 13>, <&cmn_refclk>;
 		clock-names = "fck", "core_ref_clk", "ext_ref_clk";
 		assigned-clocks = <&k3_clks 293 13>, <&k3_clks 293 0>;
 		assigned-clock-parents = <&k3_clks 293 17>, <&k3_clks 293 4>;
@@ -421,21 +423,21 @@
 		ranges = <0x5010000 0x0 0x5010000 0x10000>;
 
 		wiz1_pll0_refclk: pll0-refclk {
-			clocks = <&k3_clks 293 13>, <&dummy_cmn_refclk>;
+			clocks = <&k3_clks 293 13>, <&cmn_refclk>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz1_pll0_refclk>;
 			assigned-clock-parents = <&k3_clks 293 13>;
 		};
 
 		wiz1_pll1_refclk: pll1-refclk {
-			clocks = <&k3_clks 293 0>, <&dummy_cmn_refclk1>;
+			clocks = <&k3_clks 293 0>, <&cmn_refclk1>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz1_pll1_refclk>;
 			assigned-clock-parents = <&k3_clks 293 0>;
 		};
 
 		wiz1_refclk_dig: refclk-dig {
-			clocks = <&k3_clks 293 13>, <&k3_clks 293 0>, <&dummy_cmn_refclk>, <&dummy_cmn_refclk1>;
+			clocks = <&k3_clks 293 13>, <&k3_clks 293 0>, <&cmn_refclk>, <&cmn_refclk1>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz1_refclk_dig>;
 			assigned-clock-parents = <&k3_clks 293 13>;
@@ -469,7 +471,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		power-domains = <&k3_pds 294 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 294 5>, <&k3_clks 294 11>, <&dummy_cmn_refclk>;
+		clocks = <&k3_clks 294 5>, <&k3_clks 294 11>, <&cmn_refclk>;
 		clock-names = "fck", "core_ref_clk", "ext_ref_clk";
 		assigned-clocks = <&k3_clks 294 11>, <&k3_clks 294 0>;
 		assigned-clock-parents = <&k3_clks 294 15>, <&k3_clks 294 4>;
@@ -478,21 +480,21 @@
 		ranges = <0x5020000 0x0 0x5020000 0x10000>;
 
 		wiz2_pll0_refclk: pll0-refclk {
-			clocks = <&k3_clks 294 11>, <&dummy_cmn_refclk>;
+			clocks = <&k3_clks 294 11>, <&cmn_refclk>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz2_pll0_refclk>;
 			assigned-clock-parents = <&k3_clks 294 11>;
 		};
 
 		wiz2_pll1_refclk: pll1-refclk {
-			clocks = <&k3_clks 294 0>, <&dummy_cmn_refclk1>;
+			clocks = <&k3_clks 294 0>, <&cmn_refclk1>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz2_pll1_refclk>;
 			assigned-clock-parents = <&k3_clks 294 0>;
 		};
 
 		wiz2_refclk_dig: refclk-dig {
-			clocks = <&k3_clks 294 11>, <&k3_clks 294 0>, <&dummy_cmn_refclk>, <&dummy_cmn_refclk1>;
+			clocks = <&k3_clks 294 11>, <&k3_clks 294 0>, <&cmn_refclk>, <&cmn_refclk1>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz2_refclk_dig>;
 			assigned-clock-parents = <&k3_clks 294 11>;
@@ -526,7 +528,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		power-domains = <&k3_pds 295 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 295 5>, <&k3_clks 295 9>, <&dummy_cmn_refclk>;
+		clocks = <&k3_clks 295 5>, <&k3_clks 295 9>, <&cmn_refclk>;
 		clock-names = "fck", "core_ref_clk", "ext_ref_clk";
 		assigned-clocks = <&k3_clks 295 9>, <&k3_clks 295 0>;
 		assigned-clock-parents = <&k3_clks 295 13>, <&k3_clks 295 4>;
@@ -535,21 +537,21 @@
 		ranges = <0x5030000 0x0 0x5030000 0x10000>;
 
 		wiz3_pll0_refclk: pll0-refclk {
-			clocks = <&k3_clks 295 9>, <&dummy_cmn_refclk>;
+			clocks = <&k3_clks 295 9>, <&cmn_refclk>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz3_pll0_refclk>;
 			assigned-clock-parents = <&k3_clks 295 9>;
 		};
 
 		wiz3_pll1_refclk: pll1-refclk {
-			clocks = <&k3_clks 295 0>, <&dummy_cmn_refclk1>;
+			clocks = <&k3_clks 295 0>, <&cmn_refclk1>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz3_pll1_refclk>;
 			assigned-clock-parents = <&k3_clks 295 0>;
 		};
 
 		wiz3_refclk_dig: refclk-dig {
-			clocks = <&k3_clks 295 9>, <&k3_clks 295 0>, <&dummy_cmn_refclk>, <&dummy_cmn_refclk1>;
+			clocks = <&k3_clks 295 9>, <&k3_clks 295 0>, <&cmn_refclk>, <&cmn_refclk1>;
 			#clock-cells = <0>;
 			assigned-clocks = <&wiz3_refclk_dig>;
 			assigned-clock-parents = <&k3_clks 295 9>;
-- 
2.30.2



