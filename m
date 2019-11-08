Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10677F47F9
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391430AbfKHLyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:54:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391352AbfKHLq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5093E222C2;
        Fri,  8 Nov 2019 11:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213589;
        bh=Gau1vM/kScUGBLToqhhxhKTc3RPJfU9dshLIcUAb4cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGq6xnb9FxQEWmMpOICP9U69Du+a8hs4otvmTIN5b8btAUaPKrKHE2OXx25CrkYRo
         UUuoHI5uGZqgZGnqHUwxBszfYI0UVKoM5p1LYk89+WO9f8tIpRZSvxcshFciMgMrWX
         HvcZa7txZJb6aKStmL+S+/WKO7buk/0yjri2b0PI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 31/64] ARM: dts: omap3-gta04: fix touchscreen tsc2007
Date:   Fri,  8 Nov 2019 06:45:12 -0500
Message-Id: <20191108114545.15351-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H. Nikolaus Schaller" <hns@goldelico.com>

[ Upstream commit 7384a24248eda140a234d356b6c840701ee9f055 ]

we fix penirq polarity, add penirq pinmux and touchscreen
properties.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index e86f42086a29b..6e809b0ff5c9f 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -274,6 +274,13 @@
 			OMAP3_CORE1_IOPAD(0x2134, PIN_INPUT_PULLUP | MUX_MODE4) /* gpio112 */
 		>;
 	};
+
+	penirq_pins: pinmux_penirq_pins {
+		pinctrl-single,pins = <
+			/* here we could enable to wakeup the cpu from suspend by a pen touch */
+			OMAP3_CORE1_IOPAD(0x2194, PIN_INPUT_PULLUP | MUX_MODE4) /* gpio160 */
+		>;
+	};
 };
 
 &omap3_pmx_core2 {
@@ -411,10 +418,19 @@
 	tsc2007@48 {
 		compatible = "ti,tsc2007";
 		reg = <0x48>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&penirq_pins>;
 		interrupt-parent = <&gpio6>;
 		interrupts = <0 IRQ_TYPE_EDGE_FALLING>; /* GPIO_160 */
-		gpios = <&gpio6 0 GPIO_ACTIVE_LOW>;
+		gpios = <&gpio6 0 GPIO_ACTIVE_LOW>;	/* GPIO_160 */
 		ti,x-plate-ohms = <600>;
+		touchscreen-size-x = <480>;
+		touchscreen-size-y = <640>;
+		touchscreen-max-pressure = <1000>;
+		touchscreen-fuzz-x = <3>;
+		touchscreen-fuzz-y = <8>;
+		touchscreen-fuzz-pressure = <10>;
+		touchscreen-inverted-y;
 	};
 
 	/* RFID EEPROM */
-- 
2.20.1

