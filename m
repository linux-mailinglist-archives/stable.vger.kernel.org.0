Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1751D16D0
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbfJIRcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731977AbfJIRXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:23:55 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C477B21929;
        Wed,  9 Oct 2019 17:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641834;
        bh=QSwVlSXf04HQkDaO/JdeqF0RcKB3LgXn1tgaXirBcI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5X/i6n80Nk2A8PebYqGQcXUtmBYshjg/zYPNjt7hj7pruWCB4teGaUCDicVEfROp
         HIvUiXFkLfSsphCAMQFxYKYngAZMU7MpAd310964ojGt8KiTALU1lW3IsIt+/tA3Aw
         qNoabuBQJiItNXMs+4pOSHqavTQ1BBOkzpv68NdM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Suman Anna <s-anna@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 05/68] ARM: dts: Fix wrong clocks for dra7 mcasp
Date:   Wed,  9 Oct 2019 13:04:44 -0400
Message-Id: <20191009170547.32204-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170547.32204-1-sashal@kernel.org>
References: <20191009170547.32204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 2d3c8ba3cffa00f76bedb713c8c2126c82d8cd13 ]

The ahclkr clkctrl clock bit 28 only exists for mcasp 1 and 2 on dra7.
This causes the following warning on beagle-x15:

ti-sysc 48468000.target-module: could not add child clock ahclkr: -19

Also the mcasp clkctrl clock bits are wrong:

For mcasp1 and 2 we have four clocks at bits 28, 24, 22 and 0:

bit 28 is ahclkr
bit 24 is ahclkx
bit 22 is auxclk
bit 0 is fck

For mcasp3 to 8 we have three clocks at bits 24, 22 and 0.

bit 24 is ahclkx
bit 22 is auxclk
bit 0 is fck

We do not have currently mapped auxclk at bit 22 for the drivers, that can
be added if needed.

Fixes: 5241ccbf2819 ("ARM: dts: Add missing ranges for dra7 mcasp l3 ports")
Cc: Suman Anna <s-anna@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra7-l4.dtsi | 48 +++++++++++++++-------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index 21e5914fdd620..099d6fe2a57ad 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -2762,7 +2762,7 @@
 				interrupt-names = "tx", "rx";
 				dmas = <&edma_xbar 129 1>, <&edma_xbar 128 1>;
 				dma-names = "tx", "rx";
-				clocks = <&ipu_clkctrl DRA7_IPU_MCASP1_CLKCTRL 22>,
+				clocks = <&ipu_clkctrl DRA7_IPU_MCASP1_CLKCTRL 0>,
 					 <&ipu_clkctrl DRA7_IPU_MCASP1_CLKCTRL 24>,
 					 <&ipu_clkctrl DRA7_IPU_MCASP1_CLKCTRL 28>;
 				clock-names = "fck", "ahclkx", "ahclkr";
@@ -2799,8 +2799,8 @@
 				interrupt-names = "tx", "rx";
 				dmas = <&edma_xbar 131 1>, <&edma_xbar 130 1>;
 				dma-names = "tx", "rx";
-				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP2_CLKCTRL 22>,
-					 <&l4per2_clkctrl DRA7_L4PER2_MCASP2_CLKCTRL 24>,
+				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP2_CLKCTRL 0>,
+					 <&ipu_clkctrl DRA7_IPU_MCASP1_CLKCTRL 24>,
 					 <&l4per2_clkctrl DRA7_L4PER2_MCASP2_CLKCTRL 28>;
 				clock-names = "fck", "ahclkx", "ahclkr";
 				status = "disabled";
@@ -2818,9 +2818,8 @@
 					<SYSC_IDLE_SMART>;
 			/* Domains (P, C): l4per_pwrdm, l4per2_clkdm */
 			clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP3_CLKCTRL 0>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP3_CLKCTRL 24>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP3_CLKCTRL 28>;
-			clock-names = "fck", "ahclkx", "ahclkr";
+				 <&l4per2_clkctrl DRA7_L4PER2_MCASP3_CLKCTRL 24>;
+			clock-names = "fck", "ahclkx";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges = <0x0 0x68000 0x2000>,
@@ -2836,7 +2835,7 @@
 				interrupt-names = "tx", "rx";
 				dmas = <&edma_xbar 133 1>, <&edma_xbar 132 1>;
 				dma-names = "tx", "rx";
-				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP3_CLKCTRL 22>,
+				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP3_CLKCTRL 0>,
 					 <&l4per2_clkctrl DRA7_L4PER2_MCASP3_CLKCTRL 24>;
 				clock-names = "fck", "ahclkx";
 				status = "disabled";
@@ -2854,9 +2853,8 @@
 					<SYSC_IDLE_SMART>;
 			/* Domains (P, C): l4per_pwrdm, l4per2_clkdm */
 			clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP4_CLKCTRL 0>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP4_CLKCTRL 24>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP4_CLKCTRL 28>;
-			clock-names = "fck", "ahclkx", "ahclkr";
+				 <&l4per2_clkctrl DRA7_L4PER2_MCASP4_CLKCTRL 24>;
+			clock-names = "fck", "ahclkx";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges = <0x0 0x6c000 0x2000>,
@@ -2872,7 +2870,7 @@
 				interrupt-names = "tx", "rx";
 				dmas = <&edma_xbar 135 1>, <&edma_xbar 134 1>;
 				dma-names = "tx", "rx";
-				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP4_CLKCTRL 22>,
+				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP4_CLKCTRL 0>,
 					 <&l4per2_clkctrl DRA7_L4PER2_MCASP4_CLKCTRL 24>;
 				clock-names = "fck", "ahclkx";
 				status = "disabled";
@@ -2890,9 +2888,8 @@
 					<SYSC_IDLE_SMART>;
 			/* Domains (P, C): l4per_pwrdm, l4per2_clkdm */
 			clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP5_CLKCTRL 0>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP5_CLKCTRL 24>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP5_CLKCTRL 28>;
-			clock-names = "fck", "ahclkx", "ahclkr";
+				 <&l4per2_clkctrl DRA7_L4PER2_MCASP5_CLKCTRL 24>;
+			clock-names = "fck", "ahclkx";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges = <0x0 0x70000 0x2000>,
@@ -2908,7 +2905,7 @@
 				interrupt-names = "tx", "rx";
 				dmas = <&edma_xbar 137 1>, <&edma_xbar 136 1>;
 				dma-names = "tx", "rx";
-				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP5_CLKCTRL 22>,
+				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP5_CLKCTRL 0>,
 					 <&l4per2_clkctrl DRA7_L4PER2_MCASP5_CLKCTRL 24>;
 				clock-names = "fck", "ahclkx";
 				status = "disabled";
@@ -2926,9 +2923,8 @@
 					<SYSC_IDLE_SMART>;
 			/* Domains (P, C): l4per_pwrdm, l4per2_clkdm */
 			clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP6_CLKCTRL 0>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP6_CLKCTRL 24>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP6_CLKCTRL 28>;
-			clock-names = "fck", "ahclkx", "ahclkr";
+				 <&l4per2_clkctrl DRA7_L4PER2_MCASP6_CLKCTRL 24>;
+			clock-names = "fck", "ahclkx";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges = <0x0 0x74000 0x2000>,
@@ -2944,7 +2940,7 @@
 				interrupt-names = "tx", "rx";
 				dmas = <&edma_xbar 139 1>, <&edma_xbar 138 1>;
 				dma-names = "tx", "rx";
-				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP6_CLKCTRL 22>,
+				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP6_CLKCTRL 0>,
 					 <&l4per2_clkctrl DRA7_L4PER2_MCASP6_CLKCTRL 24>;
 				clock-names = "fck", "ahclkx";
 				status = "disabled";
@@ -2962,9 +2958,8 @@
 					<SYSC_IDLE_SMART>;
 			/* Domains (P, C): l4per_pwrdm, l4per2_clkdm */
 			clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP7_CLKCTRL 0>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP7_CLKCTRL 24>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP7_CLKCTRL 28>;
-			clock-names = "fck", "ahclkx", "ahclkr";
+				 <&l4per2_clkctrl DRA7_L4PER2_MCASP7_CLKCTRL 24>;
+			clock-names = "fck", "ahclkx";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges = <0x0 0x78000 0x2000>,
@@ -2980,7 +2975,7 @@
 				interrupt-names = "tx", "rx";
 				dmas = <&edma_xbar 141 1>, <&edma_xbar 140 1>;
 				dma-names = "tx", "rx";
-				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP7_CLKCTRL 22>,
+				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP7_CLKCTRL 0>,
 					 <&l4per2_clkctrl DRA7_L4PER2_MCASP7_CLKCTRL 24>;
 				clock-names = "fck", "ahclkx";
 				status = "disabled";
@@ -2998,9 +2993,8 @@
 					<SYSC_IDLE_SMART>;
 			/* Domains (P, C): l4per_pwrdm, l4per2_clkdm */
 			clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP8_CLKCTRL 0>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP8_CLKCTRL 24>,
-				 <&l4per2_clkctrl DRA7_L4PER2_MCASP8_CLKCTRL 28>;
-			clock-names = "fck", "ahclkx", "ahclkr";
+				 <&l4per2_clkctrl DRA7_L4PER2_MCASP8_CLKCTRL 24>;
+			clock-names = "fck", "ahclkx";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges = <0x0 0x7c000 0x2000>,
@@ -3016,7 +3010,7 @@
 				interrupt-names = "tx", "rx";
 				dmas = <&edma_xbar 143 1>, <&edma_xbar 142 1>;
 				dma-names = "tx", "rx";
-				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP8_CLKCTRL 22>,
+				clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP8_CLKCTRL 0>,
 					 <&l4per2_clkctrl DRA7_L4PER2_MCASP8_CLKCTRL 24>;
 				clock-names = "fck", "ahclkx";
 				status = "disabled";
-- 
2.20.1

