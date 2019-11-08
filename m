Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A02BF4A1A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388926AbfKHLkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:40:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388911AbfKHLkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 215CD222CB;
        Fri,  8 Nov 2019 11:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213239;
        bh=eCjSB8vjGUKo9aFTWo6mUAM0XxqRO2w9q9vDX6XN3Lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNTgN1Q63y5agaYOm4UiGrYVF0Tk0uzpVGyb+EmMvwbmYybvmAsekUD5yFZ+z4pfJ
         G5F4WTv1PQ8KvTXuGyva5CP6cjQ7PzoxH/6+S6/vP6/ALuoMUBsD5oYlRtHdwtinHB
         +6yNxPManNn3NAVH+7UKD7Sq2UF2dkKDBkp8tLfA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 109/205] ARM: dts: omap3-gta04: fix touchscreen tsc2007
Date:   Fri,  8 Nov 2019 06:36:16 -0500
Message-Id: <20191108113752.12502-109-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
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
index 79d708ce3a93f..de873e395c05d 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -283,6 +283,13 @@
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
@@ -423,10 +430,19 @@
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

