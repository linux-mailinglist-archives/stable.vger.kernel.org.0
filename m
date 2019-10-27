Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D1FE685B
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbfJ0VSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731316AbfJ0VSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:18:41 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 990E2205C9;
        Sun, 27 Oct 2019 21:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211120;
        bh=QSwVlSXf04HQkDaO/JdeqF0RcKB3LgXn1tgaXirBcI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WK9XHbLucymbeS847TmAOMccqmBumO9yUcBwdO4MJqtmzqa6fX0PhG9Px2LAMeNKf
         qC0VJRWagRf38ghP0nRXrI9TpybeHY08QvfMKHyCbjg2g4UlzqjXKdup9GTzBZ7ozH
         K3iX7qtSFW3f4V86ISaiF9YHK4HpNaL84BmlTNqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 004/197] ARM: dts: Fix wrong clocks for dra7 mcasp
Date:   Sun, 27 Oct 2019 21:58:42 +0100
Message-Id: <20191027203351.928903827@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



