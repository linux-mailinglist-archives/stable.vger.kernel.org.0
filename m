Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B1A148018
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389519AbgAXLHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:07:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731030AbgAXLHh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:07:37 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F613214DB;
        Fri, 24 Jan 2020 11:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864057;
        bh=XtRbgFtwDq1bRrqpR5hzKEXjrhq/GLxRgF+yg6Wcgi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bY4sdQ586s3GIUaJG+wKZMTA1OC4sISLBfT02ZFOkZ/kCgPaC2tWEybXU7ihHOzhj
         GNX/r9EBb3YRYwdgaL5L0HaySjyjGJLzdkddDTdCYk3/qsYsnQgCQ2l4di0o/UM7i+
         wBFSmGFn6WRhyt6QW5wQXAAWlBvjjTPVUVlfYveA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/639] ARM: dts: sun8i-a23-a33: Move NAND controller device node to sort by address
Date:   Fri, 24 Jan 2020 10:25:16 +0100
Message-Id: <20200124093105.525053383@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit d027521497592773cd23d016d36975574d3452db ]

The NAND controller device node was inserted into the wrong position,
probably due to a rebase or merge, as the file's structure does not
provide enough context for git to accurately match the previous device
node block.

Fixes: d7b843df13ea ("ARM: dts: sun8i: add NAND controller node for A23/A33")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-a23-a33.dtsi | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-a23-a33.dtsi b/arch/arm/boot/dts/sun8i-a23-a33.dtsi
index c16ffcc4db7da..a272a69519a26 100644
--- a/arch/arm/boot/dts/sun8i-a23-a33.dtsi
+++ b/arch/arm/boot/dts/sun8i-a23-a33.dtsi
@@ -155,6 +155,19 @@
 			#dma-cells = <1>;
 		};
 
+		nfc: nand@1c03000 {
+			compatible = "allwinner,sun4i-a10-nand";
+			reg = <0x01c03000 0x1000>;
+			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_NAND>, <&ccu CLK_NAND>;
+			clock-names = "ahb", "mod";
+			resets = <&ccu RST_BUS_NAND>;
+			reset-names = "ahb";
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		mmc0: mmc@1c0f000 {
 			compatible = "allwinner,sun7i-a20-mmc";
 			reg = <0x01c0f000 0x1000>;
@@ -212,21 +225,6 @@
 			#size-cells = <0>;
 		};
 
-		nfc: nand@1c03000 {
-			compatible = "allwinner,sun4i-a10-nand";
-			reg = <0x01c03000 0x1000>;
-			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&ccu CLK_BUS_NAND>, <&ccu CLK_NAND>;
-			clock-names = "ahb", "mod";
-			resets = <&ccu RST_BUS_NAND>;
-			reset-names = "ahb";
-			pinctrl-names = "default";
-			pinctrl-0 = <&nand_pins &nand_pins_cs0 &nand_pins_rb0>;
-			status = "disabled";
-			#address-cells = <1>;
-			#size-cells = <0>;
-		};
-
 		usb_otg: usb@1c19000 {
 			/* compatible gets set in SoC specific dtsi file */
 			reg = <0x01c19000 0x0400>;
-- 
2.20.1



