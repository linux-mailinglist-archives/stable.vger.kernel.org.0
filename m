Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F44B13F76F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387657AbgAPRAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732846AbgAPRAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EAFA2468E;
        Thu, 16 Jan 2020 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194003;
        bh=fTzTZdTov7HcnpdU0NW4Y0flZWYpEd2gLH97U0joLbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M170uZ5gz+lMwYn/1B4sbCI4vfEIqqJHoQsnjbQcu7qoaid2VYQuZVzEkH6ppCSDW
         olbU8y0MOLqaDYihd22ykzclfqv3gLhQEyo7/FzwKqAjHD8jupvKbC58wftYlocE17
         itBqqpWumvw6q1XkcRnqSFygrHPScZBH3D55nzy0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 130/671] ARM: dts: sun8i-a23-a33: Move NAND controller device node to sort by address
Date:   Thu, 16 Jan 2020 11:50:39 -0500
Message-Id: <20200116165940.10720-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c16ffcc4db7d..a272a69519a2 100644
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

