Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF2AF6661
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfKJCmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:42:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727974AbfKJCmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AE3D21850;
        Sun, 10 Nov 2019 02:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353763;
        bh=yz5PejhQbGuzk/AXf4ICBQpxa/55np+whAzr4vywspM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZGMreGONhEO86M7oWH4baXUn3P0SWhVrb44fmC2Eyk5fyE/hnly04xAnsDfxBhk2
         aIHTHpFQpHZBU8OjMaRXI4v3xlFEXVSSSJ2yj5RFQtJkznq5n7DSKkdRPaW+KSZRQ0
         72Mo2UQp/ikaMGsU3w9SrLfkQ7A4p0S0k9A4N0VY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Yannick=20Fertr=C3=A9?= <yannick.fertre@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 075/191] ARM: dts: stm32: enable display on stm32mp157c-ev1 board
Date:   Sat,  9 Nov 2019 21:38:17 -0500
Message-Id: <20191110024013.29782-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yannick Fertré <yannick.fertre@st.com>

[ Upstream commit 67330599f93672bd351123c729e2591a460fd24c ]

Enable panel raydium RM68200, DSI bridge & display controller.

Signed-off-by: Yannick Fertré <yannick.fertre@st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-ev1.dts | 73 ++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-ev1.dts b/arch/arm/boot/dts/stm32mp157c-ev1.dts
index 372bc2ea6b921..063ee8ac5dcbd 100644
--- a/arch/arm/boot/dts/stm32mp157c-ev1.dts
+++ b/arch/arm/boot/dts/stm32mp157c-ev1.dts
@@ -6,6 +6,7 @@
 /dts-v1/;
 
 #include "stm32mp157c-ed1.dts"
+#include <dt-bindings/gpio/gpio.h>
 
 / {
 	model = "STMicroelectronics STM32MP157C eval daughter on eval mother";
@@ -19,6 +20,58 @@
 		serial0 = &uart4;
 		ethernet0 = &ethernet0;
 	};
+
+	panel_backlight: panel-backlight {
+		compatible = "gpio-backlight";
+		gpios = <&gpiod 13 GPIO_ACTIVE_LOW>;
+		default-on;
+		status = "okay";
+	};
+};
+
+&cec {
+	pinctrl-names = "default";
+	pinctrl-0 = <&cec_pins_a>;
+	status = "okay";
+};
+
+&dsi {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	status = "okay";
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+			dsi_in: endpoint {
+				remote-endpoint = <&ltdc_ep0_out>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+			dsi_out: endpoint {
+				remote-endpoint = <&dsi_panel_in>;
+			};
+		};
+	};
+
+	panel-dsi@0 {
+		compatible = "raydium,rm68200";
+		reg = <0>;
+		reset-gpios = <&gpiof 15 GPIO_ACTIVE_LOW>;
+		backlight = <&panel_backlight>;
+		status = "okay";
+
+		port {
+			dsi_panel_in: endpoint {
+				remote-endpoint = <&dsi_out>;
+			};
+		};
+	};
 };
 
 &ethernet0 {
@@ -40,12 +93,6 @@
 	};
 };
 
-&cec {
-	pinctrl-names = "default";
-	pinctrl-0 = <&cec_pins_a>;
-	status = "okay";
-};
-
 &i2c2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c2_pins_a>;
@@ -62,6 +109,20 @@
 	status = "okay";
 };
 
+&ltdc {
+	status = "okay";
+
+	port {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ltdc_ep0_out: endpoint@0 {
+			reg = <0>;
+			remote-endpoint = <&dsi_in>;
+		};
+	};
+};
+
 &m_can1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&m_can1_pins_a>;
-- 
2.20.1

