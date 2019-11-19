Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676AC1014D8
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfKSFiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:38:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730134AbfKSFh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:37:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0330206EC;
        Tue, 19 Nov 2019 05:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141877;
        bh=yz5PejhQbGuzk/AXf4ICBQpxa/55np+whAzr4vywspM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ey95zcAjY44/GLDFRgNWBF6zUb3Spun+YOkMRKc2snoxFrzGwnSMMS2AdBKKGpjYa
         QOGgVvA0SPJ/qHLl5qlXTa0NpBTOR/46DK1X1MrmznWg9Im83XkbDRa9HvYulQSo2w
         b9Evqo1NHmrw7KTF8KekNLgyzPRG3ZFZICJe7mOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Yannick=20Fertr=C3=A9?= <yannick.fertre@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 309/422] ARM: dts: stm32: enable display on stm32mp157c-ev1 board
Date:   Tue, 19 Nov 2019 06:18:26 +0100
Message-Id: <20191119051419.021836317@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



