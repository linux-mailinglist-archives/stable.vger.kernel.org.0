Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289FB68D75B
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjBGM7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjBGM7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD9F7EE4
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 294CA613FB
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E16C433D2;
        Tue,  7 Feb 2023 12:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774741;
        bh=O/6GDpEeuBvP6taL58YDYxmD2dKdZDzZFzy/BWsyqz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOA0xAdg5uiPQ5lhwZkAPesg8JBXwg4wEG0AeJYc30fWzcNY4Wy99H5bwQPv8ZtT7
         6udbpOuIKiLlCLLJqOiH99X6jQPIhI16OR5WpNxZXJkbee16iNOXRvmH7PERK6BXwc
         jXiZRRprvBzgG3jh9OhXmNKks4j6FMdn6d+SsXlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabio Estevam <festevam@denx.de>,
        Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/208] arm64: dts: imx8m-venice: Remove incorrect uart-has-rtscts
Date:   Tue,  7 Feb 2023 13:54:17 +0100
Message-Id: <20230207125634.469359879@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit fca053893e8d5be8173c92876c6329cbee78b880 ]

The following build warnings are seen when running:

make dtbs_check DT_SCHEMA_FILES=fsl-imx-uart.yaml

arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dtb: serial@30860000: cts-gpios: False schema does not allow [[33, 3, 1]]
	From schema: Documentation/devicetree/bindings/serial/fsl-imx-uart.yaml
arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dtb: serial@30860000: rts-gpios: False schema does not allow [[33, 5, 1]]
	From schema: Documentation/devicetree/bindings/serial/fsl-imx-uart.yaml
...

The imx8m Venice Gateworks boards do not expose the UART RTS and CTS
as native UART pins, so 'uart-has-rtscts' should not be used.

Using 'uart-has-rtscts' with 'rts-gpios' is an invalid combination
detected by serial.yaml.

Fix the problem by removing the incorrect 'uart-has-rtscts' property.

Fixes: 27c8f4ccc1b9 ("arm64: dts: imx8mm-venice-gw72xx-0x: add dt overlays for serial modes")
Fixes: d9a9a7cf32c9 ("arm64: dts: imx8m{m,n}-venice-*: add missing uart-has-rtscts property to UARTs")
Fixes: 870f645b396b ("arm64: dts: imx8mp-venice-gw74xx: add WiFi/BT module support")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Acked-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mm-venice-gw72xx-0x-rs232-rts.dts   | 1 -
 .../boot/dts/freescale/imx8mm-venice-gw73xx-0x-rs232-rts.dts   | 1 -
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi        | 1 -
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts         | 3 ---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts         | 3 ---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts         | 1 -
 arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts         | 1 -
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts         | 1 -
 8 files changed, 12 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx-0x-rs232-rts.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx-0x-rs232-rts.dts
index 3ea73a6886ff..f6ad1a4b8b66 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx-0x-rs232-rts.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx-0x-rs232-rts.dts
@@ -33,7 +33,6 @@
 	pinctrl-0 = <&pinctrl_uart2>;
 	rts-gpios = <&gpio5 29 GPIO_ACTIVE_LOW>;
 	cts-gpios = <&gpio5 28 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx-0x-rs232-rts.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx-0x-rs232-rts.dts
index 2fa635e1c1a8..1f8ea20dfafc 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx-0x-rs232-rts.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx-0x-rs232-rts.dts
@@ -33,7 +33,6 @@
 	pinctrl-0 = <&pinctrl_uart2>;
 	rts-gpios = <&gpio5 29 GPIO_ACTIVE_LOW>;
 	cts-gpios = <&gpio5 28 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
index 244ef8d6cc68..7761d5671cb1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
@@ -222,7 +222,6 @@
 	pinctrl-0 = <&pinctrl_uart3>, <&pinctrl_bten>;
 	cts-gpios = <&gpio5 8 GPIO_ACTIVE_LOW>;
 	rts-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 
 	bluetooth {
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
index 72311b55f06d..5a770c8b777e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
@@ -721,7 +721,6 @@
 	dtr-gpios = <&gpio1 14 GPIO_ACTIVE_LOW>;
 	dsr-gpios = <&gpio1 1 GPIO_ACTIVE_LOW>;
 	dcd-gpios = <&gpio1 11 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -737,7 +736,6 @@
 	pinctrl-0 = <&pinctrl_uart3>, <&pinctrl_uart3_gpio>;
 	cts-gpios = <&gpio4 10 GPIO_ACTIVE_LOW>;
 	rts-gpios = <&gpio4 9 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -746,7 +744,6 @@
 	pinctrl-0 = <&pinctrl_uart4>, <&pinctrl_uart4_gpio>;
 	cts-gpios = <&gpio5 11 GPIO_ACTIVE_LOW>;
 	rts-gpios = <&gpio5 12 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
index 31f4c735fe4f..ba0b3f507855 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
@@ -651,7 +651,6 @@
 	pinctrl-0 = <&pinctrl_uart1>, <&pinctrl_uart1_gpio>;
 	rts-gpios = <&gpio4 10 GPIO_ACTIVE_LOW>;
 	cts-gpios = <&gpio4 24 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -668,7 +667,6 @@
 	pinctrl-0 = <&pinctrl_uart3>, <&pinctrl_uart3_gpio>;
 	rts-gpios = <&gpio2 1 GPIO_ACTIVE_LOW>;
 	cts-gpios = <&gpio2 0 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 
 	bluetooth {
@@ -686,7 +684,6 @@
 	dtr-gpios = <&gpio4 3 GPIO_ACTIVE_LOW>;
 	dsr-gpios = <&gpio4 4 GPIO_ACTIVE_LOW>;
 	dcd-gpios = <&gpio4 6 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts
index 19f6d2943d26..8e861b920d09 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts
@@ -572,7 +572,6 @@
 	dtr-gpios = <&gpio1 0 GPIO_ACTIVE_LOW>;
 	dsr-gpios = <&gpio1 1 GPIO_ACTIVE_LOW>;
 	dcd-gpios = <&gpio3 24 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts b/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
index dd4302ac1de4..e7362d7615bd 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
@@ -631,7 +631,6 @@
 	pinctrl-0 = <&pinctrl_uart3>, <&pinctrl_uart3_gpio>;
 	rts-gpios = <&gpio2 1 GPIO_ACTIVE_LOW>;
 	cts-gpios = <&gpio2 0 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 
 	bluetooth {
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
index 06b4c93c5876..d68ef4f0726f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
@@ -611,7 +611,6 @@
 	pinctrl-0 = <&pinctrl_uart3>, <&pinctrl_uart3_gpio>;
 	cts-gpios = <&gpio3 21 GPIO_ACTIVE_LOW>;
 	rts-gpios = <&gpio3 22 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 
 	bluetooth {
-- 
2.39.0



