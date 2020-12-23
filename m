Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEDF2E1E32
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgLWPdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:33:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgLWPdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:33:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C13182158C;
        Wed, 23 Dec 2020 15:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737573;
        bh=OL6235zXMHiWm0kRimyZ4gUa+719scQaFHpgDjXL6T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xT3WKJZrO8Exg7ihRoLZ2/NPTgVtnIQh0Li5WJaOcx7kivXv+hVlysJPhqnGm59A/
         a0Gd4NZfSUMv6jT3UuKlzmp/EIB61t4zdrr+gDfTTS/DiHg2MaV07AdKUsbw24TQJM
         iOwK1qXXebxelcYJjic/6nhD8SJNZfurlyxo3+lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Gabriel Ribba Esteva <gabriel.ribbae@gmail.com>
Subject: [PATCH 5.10 13/40] ARM: dts: exynos: fix USB 3.0 VBUS control and over-current pins on Exynos5410
Date:   Wed, 23 Dec 2020 16:33:14 +0100
Message-Id: <20201223150516.201825225@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 3d992fd8f4e0f09c980726308d2f2725587b32d6 upstream.

The VBUS control (PWREN) and over-current pins of USB 3.0 DWC3
controllers are on Exynos5410 regular GPIOs.  This is different than for
example on Exynos5422 where these are special ETC pins with proper reset
values (pulls, functions).

Therefore these pins should be configured to enable proper USB 3.0
peripheral and host modes.  This also fixes over-current warning:

    [    6.024658] usb usb4-port1: over-current condition
    [    6.028271] usb usb3-port1: over-current condition

Fixes: cb0896562228 ("ARM: dts: exynos: Add USB to Exynos5410")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201015182044.480562-2-krzk@kernel.org
Tested-by: Gabriel Ribba Esteva <gabriel.ribbae@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos5410-pinctrl.dtsi |   28 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5410.dtsi         |    4 ++++
 2 files changed, 32 insertions(+)

--- a/arch/arm/boot/dts/exynos5410-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5410-pinctrl.dtsi
@@ -560,6 +560,34 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 	};
+
+	usb3_1_oc: usb3-1-oc {
+		samsung,pins = "gpk2-4", "gpk2-5";
+		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
+		samsung,pin-pud = <EXYNOS_PIN_PULL_UP>;
+		samsung,pin-drv = <EXYNOS5420_PIN_DRV_LV1>;
+	};
+
+	usb3_1_vbusctrl: usb3-1-vbusctrl {
+		samsung,pins = "gpk2-6", "gpk2-7";
+		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
+		samsung,pin-pud = <EXYNOS_PIN_PULL_DOWN>;
+		samsung,pin-drv = <EXYNOS5420_PIN_DRV_LV1>;
+	};
+
+	usb3_0_oc: usb3-0-oc {
+		samsung,pins = "gpk3-0", "gpk3-1";
+		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
+		samsung,pin-pud = <EXYNOS_PIN_PULL_UP>;
+		samsung,pin-drv = <EXYNOS5420_PIN_DRV_LV1>;
+	};
+
+	usb3_0_vbusctrl: usb3-0-vbusctrl {
+		samsung,pins = "gpk3-2", "gpk3-3";
+		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
+		samsung,pin-pud = <EXYNOS_PIN_PULL_DOWN>;
+		samsung,pin-drv = <EXYNOS5420_PIN_DRV_LV1>;
+	};
 };
 
 &pinctrl_2 {
--- a/arch/arm/boot/dts/exynos5410.dtsi
+++ b/arch/arm/boot/dts/exynos5410.dtsi
@@ -390,6 +390,8 @@
 &usbdrd3_0 {
 	clocks = <&clock CLK_USBD300>;
 	clock-names = "usbdrd30";
+	pinctrl-names = "default";
+	pinctrl-0 = <&usb3_0_oc>, <&usb3_0_vbusctrl>;
 };
 
 &usbdrd_phy0 {
@@ -401,6 +403,8 @@
 &usbdrd3_1 {
 	clocks = <&clock CLK_USBD301>;
 	clock-names = "usbdrd30";
+	pinctrl-names = "default";
+	pinctrl-0 = <&usb3_1_oc>, <&usb3_1_vbusctrl>;
 };
 
 &usbdrd_dwc3_1 {


