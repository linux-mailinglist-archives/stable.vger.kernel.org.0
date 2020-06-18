Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4851FE54D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgFRBRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728859AbgFRBR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68FC7206F1;
        Thu, 18 Jun 2020 01:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443048;
        bh=KHiBjjQXyS2XbbFWRPkBxHYIWFZ7BXKEogmoM+xGfb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7SJ7m+eI8UsHMRAUQRLD10fUM+ctRMzto0FjA6nMBPtRLSFrEuJTBaSUGYzepOL3
         dZT4HsxNwWzxanxUrtvfkL9+z3i4DZ9GtywteP9mZAUO0sLIjVKoAupkVzLjYaEs4c
         Wcf34f+4mWVr1u84NGESCh4nrlMZTHFFqLfppAjY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 042/266] arm64: dts: fvp: Fix GIC child nodes
Date:   Wed, 17 Jun 2020 21:12:47 -0400
Message-Id: <20200618011631.604574-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 78631aecc52c4b2adcf611769df2ff9c67ac16d0 ]

The GIC DT nodes for the fastmodels were not fully compliant with the
DT binding, which has certain expectations about child nodes and their
size and address cells values.

Use smaller #address-cells and #size-cells values, as the binding
requests, and adjust the reg properties accordingly.
This requires adjusting the interrupt nexus nodes as well, as one
field of the interrupt-map property depends on the GIC's address-size.

Since the .dts files share interrupt nexus nodes across different
interrupt controllers (GICv2 vs. GICv3), we need to use the only
commonly allowed #address-size value of <1> for both.

Link: https://lore.kernel.org/r/20200513103016.130417-11-andre.przywara@arm.com
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/arm/foundation-v8-gicv2.dtsi     |  2 +-
 .../boot/dts/arm/foundation-v8-gicv3.dtsi     |  8 +-
 arch/arm64/boot/dts/arm/foundation-v8.dtsi    | 86 +++++++++----------
 3 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/boot/dts/arm/foundation-v8-gicv2.dtsi b/arch/arm64/boot/dts/arm/foundation-v8-gicv2.dtsi
index 15fe81738e94..dfb23dfc0b0f 100644
--- a/arch/arm64/boot/dts/arm/foundation-v8-gicv2.dtsi
+++ b/arch/arm64/boot/dts/arm/foundation-v8-gicv2.dtsi
@@ -8,7 +8,7 @@ / {
 	gic: interrupt-controller@2c001000 {
 		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
 		#interrupt-cells = <3>;
-		#address-cells = <2>;
+		#address-cells = <1>;
 		interrupt-controller;
 		reg = <0x0 0x2c001000 0 0x1000>,
 		      <0x0 0x2c002000 0 0x2000>,
diff --git a/arch/arm64/boot/dts/arm/foundation-v8-gicv3.dtsi b/arch/arm64/boot/dts/arm/foundation-v8-gicv3.dtsi
index f2c75c756039..906f51935b36 100644
--- a/arch/arm64/boot/dts/arm/foundation-v8-gicv3.dtsi
+++ b/arch/arm64/boot/dts/arm/foundation-v8-gicv3.dtsi
@@ -8,9 +8,9 @@ / {
 	gic: interrupt-controller@2f000000 {
 		compatible = "arm,gic-v3";
 		#interrupt-cells = <3>;
-		#address-cells = <2>;
-		#size-cells = <2>;
-		ranges;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0x0 0x0 0x2f000000 0x100000>;
 		interrupt-controller;
 		reg =	<0x0 0x2f000000 0x0 0x10000>,
 			<0x0 0x2f100000 0x0 0x200000>,
@@ -22,7 +22,7 @@ gic: interrupt-controller@2f000000 {
 		its: its@2f020000 {
 			compatible = "arm,gic-v3-its";
 			msi-controller;
-			reg = <0x0 0x2f020000 0x0 0x20000>;
+			reg = <0x20000 0x20000>;
 		};
 	};
 };
diff --git a/arch/arm64/boot/dts/arm/foundation-v8.dtsi b/arch/arm64/boot/dts/arm/foundation-v8.dtsi
index 3f78373f708a..2a6aa43241b3 100644
--- a/arch/arm64/boot/dts/arm/foundation-v8.dtsi
+++ b/arch/arm64/boot/dts/arm/foundation-v8.dtsi
@@ -107,49 +107,49 @@ smb@8000000 {
 
 		#interrupt-cells = <1>;
 		interrupt-map-mask = <0 0 63>;
-		interrupt-map = <0 0  0 &gic 0 0 GIC_SPI  0 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  1 &gic 0 0 GIC_SPI  1 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  2 &gic 0 0 GIC_SPI  2 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  3 &gic 0 0 GIC_SPI  3 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  4 &gic 0 0 GIC_SPI  4 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  5 &gic 0 0 GIC_SPI  5 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  6 &gic 0 0 GIC_SPI  6 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  7 &gic 0 0 GIC_SPI  7 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  8 &gic 0 0 GIC_SPI  8 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  9 &gic 0 0 GIC_SPI  9 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 10 &gic 0 0 GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 11 &gic 0 0 GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 12 &gic 0 0 GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 13 &gic 0 0 GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 14 &gic 0 0 GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 15 &gic 0 0 GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 16 &gic 0 0 GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 17 &gic 0 0 GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 18 &gic 0 0 GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 19 &gic 0 0 GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 20 &gic 0 0 GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 21 &gic 0 0 GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 22 &gic 0 0 GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 23 &gic 0 0 GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 24 &gic 0 0 GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 25 &gic 0 0 GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 26 &gic 0 0 GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 27 &gic 0 0 GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 28 &gic 0 0 GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 29 &gic 0 0 GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 30 &gic 0 0 GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 31 &gic 0 0 GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 32 &gic 0 0 GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 33 &gic 0 0 GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 34 &gic 0 0 GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 35 &gic 0 0 GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 36 &gic 0 0 GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 37 &gic 0 0 GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 38 &gic 0 0 GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 39 &gic 0 0 GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 40 &gic 0 0 GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 41 &gic 0 0 GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 42 &gic 0 0 GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-map = <0 0  0 &gic 0 GIC_SPI  0 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  1 &gic 0 GIC_SPI  1 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  2 &gic 0 GIC_SPI  2 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  3 &gic 0 GIC_SPI  3 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  4 &gic 0 GIC_SPI  4 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  5 &gic 0 GIC_SPI  5 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  6 &gic 0 GIC_SPI  6 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  7 &gic 0 GIC_SPI  7 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  8 &gic 0 GIC_SPI  8 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  9 &gic 0 GIC_SPI  9 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 10 &gic 0 GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 11 &gic 0 GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 12 &gic 0 GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 13 &gic 0 GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 14 &gic 0 GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 15 &gic 0 GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 16 &gic 0 GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 17 &gic 0 GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 18 &gic 0 GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 19 &gic 0 GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 20 &gic 0 GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 21 &gic 0 GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 22 &gic 0 GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 23 &gic 0 GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 24 &gic 0 GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 25 &gic 0 GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 26 &gic 0 GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 27 &gic 0 GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 28 &gic 0 GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 29 &gic 0 GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 30 &gic 0 GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 31 &gic 0 GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 32 &gic 0 GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 33 &gic 0 GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 34 &gic 0 GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 35 &gic 0 GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 36 &gic 0 GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 37 &gic 0 GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 38 &gic 0 GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 39 &gic 0 GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 40 &gic 0 GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 41 &gic 0 GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 42 &gic 0 GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
 
 		ethernet@2,02000000 {
 			compatible = "smsc,lan91c111";
-- 
2.25.1

