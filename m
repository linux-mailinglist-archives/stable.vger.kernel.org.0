Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07DFF6227
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfKJCke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726916AbfKJCkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05DAA214E0;
        Sun, 10 Nov 2019 02:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353630;
        bh=9GpZghVh8JavbMok4A6OLs2mufrG9hzrrwqhY1b+89Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zx7/2swJVFCdwfZ34xExtipXIYEcVOvpeAM1iwv7IP865eOCnx72vuAvUoc8zCmrn
         MQBjWxPiE+lytFDKlsAUGWvVuHI5jy9VobQG1tblfsxjtkDVdhsCw6kTTDMbAGmIMp
         6r87AGzQVHVMZ7eYHjzrZwu0EGqWdhuFDRYIeSF4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>, Vignesh R <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 014/191] arm64: dts: ti: k3-am65: Change #address-cells and #size-cells of interconnect to 2
Date:   Sat,  9 Nov 2019 21:37:16 -0500
Message-Id: <20191110024013.29782-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 3bc1572068e3896b60d86f9c0fb56d1cef28201c ]

AM65 has two PCIe controllers and each PCIe controller has '2' address
spaces one within the 4GB address space of the SoC and the other above
the 4GB address space of the SoC (cbass_main) in addition to the
register space. The size of the address space above the 4GB SoC address
space is 4GB. These address ranges will be used by CPU/DMA to access
the PCIe address space. In order to represent the address space above
the 4GB SoC address space and to represent the size of this address
space as 4GB, change address-cells and size-cells of interconnect to 2.

Since OSPI has similar need in MCU Domain Memory Map, change
address-cells and size-cells of cbass_mcu interconnect also to 2.

Fixes: ea47eed33a3fe3d919 ("arm64: dts: ti: Add Support for AM654 SoC")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Vignesh R <vigneshr@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 10 +++---
 arch/arm64/boot/dts/ti/k3-am65.dtsi      | 44 ++++++++++++------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index 2409344df4fa2..faace3805c014 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -8,13 +8,13 @@
 &cbass_main {
 	gic500: interrupt-controller@1800000 {
 		compatible = "arm,gic-v3";
-		#address-cells = <1>;
-		#size-cells = <1>;
+		#address-cells = <2>;
+		#size-cells = <2>;
 		ranges;
 		#interrupt-cells = <3>;
 		interrupt-controller;
-		reg = <0x01800000 0x10000>,	/* GICD */
-		      <0x01880000 0x90000>;	/* GICR */
+		reg = <0x00 0x01800000 0x00 0x10000>,	/* GICD */
+		      <0x00 0x01880000 0x00 0x90000>;	/* GICR */
 		/*
 		 * vcpumntirq:
 		 * virtual CPU interface maintenance interrupt
@@ -23,7 +23,7 @@
 
 		gic_its: gic-its@18200000 {
 			compatible = "arm,gic-v3-its";
-			reg = <0x01820000 0x10000>;
+			reg = <0x00 0x01820000 0x00 0x10000>;
 			msi-controller;
 			#msi-cells = <1>;
 		};
diff --git a/arch/arm64/boot/dts/ti/k3-am65.dtsi b/arch/arm64/boot/dts/ti/k3-am65.dtsi
index cede1fa0983c9..ded364d208351 100644
--- a/arch/arm64/boot/dts/ti/k3-am65.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65.dtsi
@@ -46,38 +46,38 @@
 
 	cbass_main: interconnect@100000 {
 		compatible = "simple-bus";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges = <0x00100000 0x00 0x00100000 0x00020000>, /* ctrl mmr */
-			 <0x00600000 0x00 0x00600000 0x00001100>, /* GPIO */
-			 <0x00900000 0x00 0x00900000 0x00012000>, /* serdes */
-			 <0x01000000 0x00 0x01000000 0x0af02400>, /* Most peripherals */
-			 <0x30800000 0x00 0x30800000 0x0bc00000>, /* MAIN NAVSS */
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges = <0x00 0x00100000 0x00 0x00100000 0x00 0x00020000>, /* ctrl mmr */
+			 <0x00 0x00600000 0x00 0x00600000 0x00 0x00001100>, /* GPIO */
+			 <0x00 0x00900000 0x00 0x00900000 0x00 0x00012000>, /* serdes */
+			 <0x00 0x01000000 0x00 0x01000000 0x00 0x0af02400>, /* Most peripherals */
+			 <0x00 0x30800000 0x00 0x30800000 0x00 0x0bc00000>, /* MAIN NAVSS */
 			 /* MCUSS Range */
-			 <0x28380000 0x00 0x28380000 0x03880000>,
-			 <0x40200000 0x00 0x40200000 0x00900100>,
-			 <0x42040000 0x00 0x42040000 0x03ac2400>,
-			 <0x45100000 0x00 0x45100000 0x00c24000>,
-			 <0x46000000 0x00 0x46000000 0x00200000>,
-			 <0x47000000 0x00 0x47000000 0x00068400>;
+			 <0x00 0x28380000 0x00 0x28380000 0x00 0x03880000>,
+			 <0x00 0x40200000 0x00 0x40200000 0x00 0x00900100>,
+			 <0x00 0x42040000 0x00 0x42040000 0x00 0x03ac2400>,
+			 <0x00 0x45100000 0x00 0x45100000 0x00 0x00c24000>,
+			 <0x00 0x46000000 0x00 0x46000000 0x00 0x00200000>,
+			 <0x00 0x47000000 0x00 0x47000000 0x00 0x00068400>;
 
 		cbass_mcu: interconnect@28380000 {
 			compatible = "simple-bus";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0x28380000 0x28380000 0x03880000>, /* MCU NAVSS*/
-				 <0x40200000 0x40200000 0x00900100>, /* First peripheral window */
-				 <0x42040000 0x42040000 0x03ac2400>, /* WKUP */
-				 <0x45100000 0x45100000 0x00c24000>, /* MMRs, remaining NAVSS */
-				 <0x46000000 0x46000000 0x00200000>, /* CPSW */
-				 <0x47000000 0x47000000 0x00068400>; /* OSPI space 1 */
+			#address-cells = <2>;
+			#size-cells = <2>;
+			ranges = <0x00 0x28380000 0x00 0x28380000 0x00 0x03880000>, /* MCU NAVSS*/
+				 <0x00 0x40200000 0x00 0x40200000 0x00 0x00900100>, /* First peripheral window */
+				 <0x00 0x42040000 0x00 0x42040000 0x00 0x03ac2400>, /* WKUP */
+				 <0x00 0x45100000 0x00 0x45100000 0x00 0x00c24000>, /* MMRs, remaining NAVSS */
+				 <0x00 0x46000000 0x00 0x46000000 0x00 0x00200000>, /* CPSW */
+				 <0x00 0x47000000 0x00 0x47000000 0x00 0x00068400>; /* OSPI space 1 */
 
 			cbass_wakeup: interconnect@42040000 {
 				compatible = "simple-bus";
 				#address-cells = <1>;
 				#size-cells = <1>;
 				/* WKUP  Basic peripherals */
-				ranges = <0x42040000 0x42040000 0x03ac2400>;
+				ranges = <0x42040000 0x00 0x42040000 0x03ac2400>;
 			};
 		};
 	};
-- 
2.20.1

