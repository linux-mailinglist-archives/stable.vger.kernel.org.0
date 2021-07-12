Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CA53C6737
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 01:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhGLX5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 19:57:37 -0400
Received: from spindle.queued.net ([45.33.49.30]:54854 "EHLO
        spindle.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbhGLX5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 19:57:37 -0400
Received: from e7470.queued.net (cpe-104-162-173-121.nyc.res.rr.com [104.162.173.121])
        by spindle.queued.net (Postfix) with ESMTPSA id A1BE7101DBF;
        Mon, 12 Jul 2021 16:46:20 -0700 (PDT)
Date:   Mon, 12 Jul 2021 19:46:18 -0400
From:   Andres Salomon <dilinger@queued.net>
To:     stable@vger.kernel.org
Cc:     Cameron Nemo <cnemo@tutanota.com>, dilinger@queued.net
Subject: [PATCH stable 5.10 1/2] arm64: dts: rockchip: add rk3328 dwc3 usb
 controller node
Message-ID: <20210712194618.3f3e5098@e7470.queued.net>
In-Reply-To: <20210712194251.7af563ed@e7470.queued.net>
References: <20210712194251.7af563ed@e7470.queued.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cameron Nemo <cnemo@tutanota.com>

commit 44dd5e2106dc2fd01697b539085818d1d1c58df0 upstream

RK3328 SoCs have one USB 3.0 OTG controller which uses DWC_USB3
core's general architecture. It can act as static xHCI host
controller, static device controller, USB 3.0/2.0 OTG basing
on ID of USB3.0 PHY.

Signed-off-by: William Wu <william.wu@rock-chips.com>
Signed-off-by: Cameron Nemo <cnemo@tutanota.com>
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20210209192350.7130-7-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 93c734d8a46c..de1e5e8a0e88 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -984,6 +984,25 @@ usb_host0_ohci: usb@ff5d0000 {
 		status = "disabled";
 	};
 
+	usbdrd3: usb@ff600000 {
+		compatible = "rockchip,rk3328-dwc3", "snps,dwc3";
+		reg = <0x0 0xff600000 0x0 0x100000>;
+		interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru SCLK_USB3OTG_REF>, <&cru SCLK_USB3OTG_SUSPEND>,
+			 <&cru ACLK_USB3OTG>;
+		clock-names = "ref_clk", "suspend_clk",
+			      "bus_clk";
+		dr_mode = "otg";
+		phy_type = "utmi_wide";
+		snps,dis-del-phy-power-chg-quirk;
+		snps,dis_enblslpm_quirk;
+		snps,dis-tx-ipgap-linecheck-quirk;
+		snps,dis-u2-freeclk-exists-quirk;
+		snps,dis_u2_susphy_quirk;
+		snps,dis_u3_susphy_quirk;
+		status = "disabled";
+	};
+
 	gic: interrupt-controller@ff811000 {
 		compatible = "arm,gic-400";
 		#interrupt-cells = <3>;
-- 
2.30.2
