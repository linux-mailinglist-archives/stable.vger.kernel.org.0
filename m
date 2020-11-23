Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DA12C0814
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbgKWMpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733298AbgKWMpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A0B20857;
        Mon, 23 Nov 2020 12:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135520;
        bh=3TVnPurXfNOcMX3gJgej8eJAAQqInjvfxX3VZB2I0d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHK/zgtFHxYclUn9B7JVvoWQ6fJsPe7vuJsNLGA0NWSQ51c1dPMbQ6oaBE5vtbAg9
         V/QgdcmxU8iASPBAShHTJtcpeQyCQcEL9szbijEgiABwTkzJjBi9uLGmjv/wBXOM8j
         dpffCszQvUIN98N1Swos3Lbh0DIyGKrUKkr+6ozo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 097/252] arm64: dts imx8mn: Remove non-existent USB OTG2
Date:   Mon, 23 Nov 2020 13:20:47 +0100
Message-Id: <20201123121840.272061497@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit cf5abb0132193767c07c83e06f91b777d22ba495 ]

According to the i.MX8MN TRM, there is only one OTG port.  The
address for OTG2 is reserved on Nano.

This patch removes the non-existent OTG2, usbphynop2, and the usbmisc2
nodes.

Fixes: 6c3debcbae47 ("arm64: dts: freescale: Add i.MX8MN dtsi support")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 30 -----------------------
 1 file changed, 30 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index 9385dd7d1a2f7..b05f60503d45a 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -789,28 +789,6 @@
 				#index-cells = <1>;
 				reg = <0x32e40200 0x200>;
 			};
-
-			usbotg2: usb@32e50000 {
-				compatible = "fsl,imx8mn-usb", "fsl,imx7d-usb";
-				reg = <0x32e50000 0x200>;
-				interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MN_CLK_USB1_CTRL_ROOT>;
-				clock-names = "usb1_ctrl_root_clk";
-				assigned-clocks = <&clk IMX8MN_CLK_USB_BUS>,
-						  <&clk IMX8MN_CLK_USB_CORE_REF>;
-				assigned-clock-parents = <&clk IMX8MN_SYS_PLL2_500M>,
-							 <&clk IMX8MN_SYS_PLL1_100M>;
-				fsl,usbphy = <&usbphynop2>;
-				fsl,usbmisc = <&usbmisc2 0>;
-				status = "disabled";
-			};
-
-			usbmisc2: usbmisc@32e50200 {
-				compatible = "fsl,imx8mn-usbmisc", "fsl,imx7d-usbmisc";
-				#index-cells = <1>;
-				reg = <0x32e50200 0x200>;
-			};
-
 		};
 
 		dma_apbh: dma-controller@33000000 {
@@ -875,12 +853,4 @@
 		assigned-clock-parents = <&clk IMX8MN_SYS_PLL1_100M>;
 		clock-names = "main_clk";
 	};
-
-	usbphynop2: usbphynop2 {
-		compatible = "usb-nop-xceiv";
-		clocks = <&clk IMX8MN_CLK_USB_PHY_REF>;
-		assigned-clocks = <&clk IMX8MN_CLK_USB_PHY_REF>;
-		assigned-clock-parents = <&clk IMX8MN_SYS_PLL1_100M>;
-		clock-names = "main_clk";
-	};
 };
-- 
2.27.0



