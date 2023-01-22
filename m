Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96615676D19
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjAVNS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVNS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:18:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AA316AD0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:18:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F6A560C0D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D1FC433EF;
        Sun, 22 Jan 2023 13:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674393533;
        bh=thrI98yT5EOc2WGWvKeXnpLgPDMyV2UD/2Y62PpjVh4=;
        h=Subject:To:Cc:From:Date:From;
        b=lOob2JGpT7EVSWVuYB50vmYh6kFbUt2hbd1j3dMoMqIOUCi84AgpYs+d12Gg/8z/7
         AenhnEPIKotcjV9EFKQCSIfSBp7aGQ4zDfH/D9OhbfAeOY6rdOJqzT6qTMyAJizj1L
         x0ipXhAM22d17gwEM12d6nBOJNQV19LEjjJB2pOE=
Subject: FAILED: patch "[PATCH] arm64: dts: imx8mp: correct usb clocks" failed to apply to 5.15-stable tree
To:     jun.li@nxp.com, alexander.stein@ew.tq-group.com, peng.fan@nxp.com,
        shawnguo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 14:18:50 +0100
Message-ID: <167439353022316@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

8a1ed98fe0f2 ("arm64: dts: imx8mp: correct usb clocks")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8a1ed98fe0f2e7669f0409de0f46f317b275f8be Mon Sep 17 00:00:00 2001
From: Li Jun <jun.li@nxp.com>
Date: Fri, 30 Sep 2022 22:54:23 +0800
Subject: [PATCH] arm64: dts: imx8mp: correct usb clocks

After commit cf7f3f4fa9e5 ("clk: imx8mp: fix usb_root_clk parent"),
usb_root_clk is no longer for suspend clock so update dts accordingly
to use right bus clock and suspend clock.

Fixes: fb8587a2c165 ("arm64: dtsi: imx8mp: add usb nodes")
Cc: stable@vger.kernel.org # ed1f4ccfe947: clk: imx: imx8mp: add shared clk gate for usb suspend clk
Cc: stable@vger.kernel.org # v5.19+
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 7a6e6221f421..6a04d81c69e6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -1297,7 +1297,7 @@ usb3_0: usb@32f10100 {
 			reg = <0x32f10100 0x8>,
 			      <0x381f0000 0x20>;
 			clocks = <&clk IMX8MP_CLK_HSIO_ROOT>,
-				 <&clk IMX8MP_CLK_USB_ROOT>;
+				 <&clk IMX8MP_CLK_USB_SUSP>;
 			clock-names = "hsio", "suspend";
 			interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
 			power-domains = <&hsio_blk_ctrl IMX8MP_HSIOBLK_PD_USB>;
@@ -1310,9 +1310,9 @@ usb3_0: usb@32f10100 {
 			usb_dwc3_0: usb@38100000 {
 				compatible = "snps,dwc3";
 				reg = <0x38100000 0x10000>;
-				clocks = <&clk IMX8MP_CLK_HSIO_AXI>,
+				clocks = <&clk IMX8MP_CLK_USB_ROOT>,
 					 <&clk IMX8MP_CLK_USB_CORE_REF>,
-					 <&clk IMX8MP_CLK_USB_ROOT>;
+					 <&clk IMX8MP_CLK_USB_SUSP>;
 				clock-names = "bus_early", "ref", "suspend";
 				interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&usb3_phy0>, <&usb3_phy0>;
@@ -1339,7 +1339,7 @@ usb3_1: usb@32f10108 {
 			reg = <0x32f10108 0x8>,
 			      <0x382f0000 0x20>;
 			clocks = <&clk IMX8MP_CLK_HSIO_ROOT>,
-				 <&clk IMX8MP_CLK_USB_ROOT>;
+				 <&clk IMX8MP_CLK_USB_SUSP>;
 			clock-names = "hsio", "suspend";
 			interrupts = <GIC_SPI 149 IRQ_TYPE_LEVEL_HIGH>;
 			power-domains = <&hsio_blk_ctrl IMX8MP_HSIOBLK_PD_USB>;
@@ -1352,9 +1352,9 @@ usb3_1: usb@32f10108 {
 			usb_dwc3_1: usb@38200000 {
 				compatible = "snps,dwc3";
 				reg = <0x38200000 0x10000>;
-				clocks = <&clk IMX8MP_CLK_HSIO_AXI>,
+				clocks = <&clk IMX8MP_CLK_USB_ROOT>,
 					 <&clk IMX8MP_CLK_USB_CORE_REF>,
-					 <&clk IMX8MP_CLK_USB_ROOT>;
+					 <&clk IMX8MP_CLK_USB_SUSP>;
 				clock-names = "bus_early", "ref", "suspend";
 				interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&usb3_phy1>, <&usb3_phy1>;

