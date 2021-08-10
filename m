Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA4C3E80E2
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbhHJRxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234366AbhHJRvV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:51:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3AFE61352;
        Tue, 10 Aug 2021 17:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617390;
        bh=0xzp1PXu05XRA9kCtipz+UIeV45TPO7SkPCFIe1QH9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJHeN+mlpv/zEw2h68mIiSgVlYpiWGKC3sD8W7zKCbzdQHfSPirzicLshprFu4sEC
         lOLf3Rh9+nL5bC8Ds6ZW8YJOqksx3B+fBPDbPi/PDHtNX0htvVK00a1uIjNPD9gPan
         PTbEQOn9cJMZ9Fy0iYcRb25Zbhp6VmPvjOjEpImU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 038/175] ARM: dts: stm32: Fix touchscreen IRQ line assignment on DHCOM
Date:   Tue, 10 Aug 2021 19:29:06 +0200
Message-Id: <20210810173002.209740494@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 15f68f027ebd961b99a1c420f96ff3838c5e4450 ]

While 7e5f3155dcbb4 ("ARM: dts: stm32: Fix LED5 on STM32MP1 DHCOM PDK2")
fixed the LED0 assignment on the PDK2 board, the same commit did not
update the touchscreen IRQ line assignment, which is the same GPIO line,
shared between the LED0 output and touchscreen IRQ input. To make this
more convoluted, the same EXTI input (not the same GPIO line) is shared
between Button B which is Active-Low IRQ, and touchscreen IRQ which is
Edge-Falling IRQ, which cannot be used at the same time. In case the LCD
board with touchscreen is in use, which is the case here, LED0 must be
disabled, Button B must be polled, so the touchscreen interrupt works as
it should.

Update the touchscreen IRQ line assignment, disable LED0 and use polled
GPIO button driver for Button B, since the DT here describes baseboard
with LCD board.

Fixes: 7e5f3155dcbb4 ("ARM: dts: stm32: Fix LED5 on STM32MP1 DHCOM PDK2")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Patrick Delaunay <patrick.delaunay@foss.st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi | 24 +++++++++++--------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index c5ea08fec535..6cf1c8b4c6e2 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -37,7 +37,7 @@
 		poll-interval = <20>;
 
 		/*
-		 * The EXTi IRQ line 3 is shared with touchscreen and ethernet,
+		 * The EXTi IRQ line 3 is shared with ethernet,
 		 * so mark this as polled GPIO key.
 		 */
 		button-0 {
@@ -46,6 +46,16 @@
 			gpios = <&gpiof 3 GPIO_ACTIVE_LOW>;
 		};
 
+		/*
+		 * The EXTi IRQ line 6 is shared with touchscreen,
+		 * so mark this as polled GPIO key.
+		 */
+		button-1 {
+			label = "TA2-GPIO-B";
+			linux,code = <KEY_B>;
+			gpios = <&gpiod 6 GPIO_ACTIVE_LOW>;
+		};
+
 		/*
 		 * The EXTi IRQ line 0 is shared with PMIC,
 		 * so mark this as polled GPIO key.
@@ -60,13 +70,6 @@
 	gpio-keys {
 		compatible = "gpio-keys";
 
-		button-1 {
-			label = "TA2-GPIO-B";
-			linux,code = <KEY_B>;
-			gpios = <&gpiod 6 GPIO_ACTIVE_LOW>;
-			wakeup-source;
-		};
-
 		button-3 {
 			label = "TA4-GPIO-D";
 			linux,code = <KEY_D>;
@@ -82,6 +85,7 @@
 			label = "green:led5";
 			gpios = <&gpioc 6 GPIO_ACTIVE_HIGH>;
 			default-state = "off";
+			status = "disabled";
 		};
 
 		led-1 {
@@ -185,8 +189,8 @@
 	touchscreen@38 {
 		compatible = "edt,edt-ft5406";
 		reg = <0x38>;
-		interrupt-parent = <&gpiog>;
-		interrupts = <2 IRQ_TYPE_EDGE_FALLING>; /* GPIO E */
+		interrupt-parent = <&gpioc>;
+		interrupts = <6 IRQ_TYPE_EDGE_FALLING>; /* GPIO E */
 	};
 };
 
-- 
2.30.2



