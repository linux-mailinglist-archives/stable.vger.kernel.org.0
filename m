Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F1D635814
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbiKWJuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238278AbiKWJtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B52FB18
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:47:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43ABAB81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6432BC433C1;
        Wed, 23 Nov 2022 09:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196817;
        bh=PibUpeYMLBbUQiYCyPbuF/slTeh4Hlr4bhqqK+lE9bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2FLBLXz3wj7CPjI/WT9U01w7xYelixGF/o5bAkW3anzEbYXpkSCVqH5sS7vBcsQs
         V0Xi0MxYML7v9mwWZPi/U8IkC6D6Pl6SvOWLNiYQ7cuhdvsny+rhxHgmDD+e9FAwAe
         fEEaHSlDK70sIYPawi+Yrl9Ey3I99OSJYplIKd8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 131/314] arm64: dts: imx8mm-tqma8mqml-mba8mx: Fix USB DR
Date:   Wed, 23 Nov 2022 09:49:36 +0100
Message-Id: <20221123084631.474405706@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 63fd9437ec81899fc36bb642d558378bc89aa4f9 ]

Using extcon USB host mode works properly on DR interface, e.g.
enabling/disabling VBUS. But USB device mode is not working.
Fix this by switching to usb-role-switch instead.

Fixes: dfcd1b6f7620 ("arm64: dts: freescale: add initial device tree for TQMa8MQML with i.MX8MM")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/freescale/imx8mm-tqma8mqml-mba8mx.dts | 32 +++++++++++++++----
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts
index 7e0aeb2db305..a0aeac619929 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts
@@ -34,11 +34,25 @@ reg_usdhc2_vmmc: regulator-vmmc {
 		off-on-delay-us = <12000>;
 	};
 
-	extcon_usbotg1: extcon-usbotg1 {
-		compatible = "linux,extcon-usb-gpio";
+	connector {
+		compatible = "gpio-usb-b-connector", "usb-b-connector";
+		type = "micro";
+		label = "X19";
 		pinctrl-names = "default";
-		pinctrl-0 = <&pinctrl_usb1_extcon>;
-		id-gpio = <&gpio1 10 GPIO_ACTIVE_HIGH>;
+		pinctrl-0 = <&pinctrl_usb1_connector>;
+		id-gpios = <&gpio1 10 GPIO_ACTIVE_HIGH>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				usb_dr_connector: endpoint {
+					remote-endpoint = <&usb1_drd_sw>;
+				};
+			};
+		};
 	};
 };
 
@@ -105,13 +119,19 @@ &usbotg1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_usbotg1>;
 	dr_mode = "otg";
-	extcon = <&extcon_usbotg1>;
 	srp-disable;
 	hnp-disable;
 	adp-disable;
 	power-active-high;
 	over-current-active-low;
+	usb-role-switch;
 	status = "okay";
+
+	port {
+		usb1_drd_sw: endpoint {
+			remote-endpoint = <&usb_dr_connector>;
+		};
+	};
 };
 
 &usbotg2 {
@@ -231,7 +251,7 @@ pinctrl_usbotg1: usbotg1grp {
 			   <MX8MM_IOMUXC_GPIO1_IO13_USB1_OTG_OC		0x84>;
 	};
 
-	pinctrl_usb1_extcon: usb1-extcongrp {
+	pinctrl_usb1_connector: usb1-connectorgrp {
 		fsl,pins = <MX8MM_IOMUXC_GPIO1_IO10_GPIO1_IO10		0x1c0>;
 	};
 
-- 
2.35.1



