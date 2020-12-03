Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F7D2CD7D6
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436512AbgLCNaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:30:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436461AbgLCNaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:30:05 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 10/39] arm64: dts: broadcom: clear the warnings caused by empty dma-ranges
Date:   Thu,  3 Dec 2020 08:28:04 -0500
Message-Id: <20201203132834.930999-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132834.930999-1-sashal@kernel.org>
References: <20201203132834.930999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 2013a4b684b6eb614ee5c9a3c07b0ae6f5ca96d9 ]

The scripts/dtc/checks.c requires that the node have empty "dma-ranges"
property must have the same "#address-cells" and "#size-cells" values as
the parent node. Otherwise, the following warnings is reported:

arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi:7.3-14: Warning \
(dma_ranges_format): /usb:dma-ranges: empty "dma-ranges" property but \
its #address-cells (1) differs from / (2)
arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi:7.3-14: Warning \
(dma_ranges_format): /usb:dma-ranges: empty "dma-ranges" property but \
its #size-cells (1) differs from / (2)

Arnd Bergmann figured out why it's necessary:
Also note that the #address-cells=<1> means that any device under
this bus is assumed to only support 32-bit addressing, and DMA will
have to go through a slow swiotlb in the absence of an IOMMU.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20201016090833.1892-2-thunder.leizhen@huawei.com'
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/broadcom/stingray/stingray-usb.dtsi   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi b/arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi
index 55259f973b5a9..aef8f2b00778d 100644
--- a/arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi
+++ b/arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi
@@ -5,20 +5,20 @@
 	usb {
 		compatible = "simple-bus";
 		dma-ranges;
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges = <0x0 0x0 0x68500000 0x00400000>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges = <0x0 0x0 0x0 0x68500000 0x0 0x00400000>;
 
 		usbphy0: usb-phy@0 {
 			compatible = "brcm,sr-usb-combo-phy";
-			reg = <0x00000000 0x100>;
+			reg = <0x0 0x00000000 0x0 0x100>;
 			#phy-cells = <1>;
 			status = "disabled";
 		};
 
 		xhci0: usb@1000 {
 			compatible = "generic-xhci";
-			reg = <0x00001000 0x1000>;
+			reg = <0x0 0x00001000 0x0 0x1000>;
 			interrupts = <GIC_SPI 256 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&usbphy0 1>, <&usbphy0 0>;
 			phy-names = "phy0", "phy1";
@@ -28,7 +28,7 @@ xhci0: usb@1000 {
 
 		bdc0: usb@2000 {
 			compatible = "brcm,bdc-v0.16";
-			reg = <0x00002000 0x1000>;
+			reg = <0x0 0x00002000 0x0 0x1000>;
 			interrupts = <GIC_SPI 259 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&usbphy0 0>, <&usbphy0 1>;
 			phy-names = "phy0", "phy1";
@@ -38,21 +38,21 @@ bdc0: usb@2000 {
 
 		usbphy1: usb-phy@10000 {
 			compatible = "brcm,sr-usb-combo-phy";
-			reg = <0x00010000 0x100>;
+			reg = <0x0 0x00010000 0x0 0x100>;
 			#phy-cells = <1>;
 			status = "disabled";
 		};
 
 		usbphy2: usb-phy@20000 {
 			compatible = "brcm,sr-usb-hs-phy";
-			reg = <0x00020000 0x100>;
+			reg = <0x0 0x00020000 0x0 0x100>;
 			#phy-cells = <0>;
 			status = "disabled";
 		};
 
 		xhci1: usb@11000 {
 			compatible = "generic-xhci";
-			reg = <0x00011000 0x1000>;
+			reg = <0x0 0x00011000 0x0 0x1000>;
 			interrupts = <GIC_SPI 263 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&usbphy1 1>, <&usbphy2>, <&usbphy1 0>;
 			phy-names = "phy0", "phy1", "phy2";
@@ -62,7 +62,7 @@ xhci1: usb@11000 {
 
 		bdc1: usb@21000 {
 			compatible = "brcm,bdc-v0.16";
-			reg = <0x00021000 0x1000>;
+			reg = <0x0 0x00021000 0x0 0x1000>;
 			interrupts = <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&usbphy2>;
 			phy-names = "phy0";
-- 
2.27.0

