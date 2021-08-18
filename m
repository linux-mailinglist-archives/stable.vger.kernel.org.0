Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB893EFD73
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 09:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238775AbhHRHMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 03:12:03 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:58283 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237805AbhHRHMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 03:12:02 -0400
Received: from vokac-Latitude-7410.ysoft.local (unknown [10.1.22.96])
        by uho.ysoft.cz (Postfix) with ESMTP id A51DAA01BF;
        Wed, 18 Aug 2021 09:02:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1629270155;
        bh=D3SoYq7cCf8X685kicAhxBhPpnT4tcM0Cnios45ggv8=;
        h=From:To:Cc:Subject:Date:From;
        b=D7nvxhBK4BVqR08HV+1wdjdazYuFbHJ1Z0xNzGRf0iWmt3yJCOUzQrgGGCJ/NKaGb
         JCo43iq0l7tp4z4w37qyEbuivD2ytuqa2KsBxBxLDyRto2ts4f6CJhe3/saOcTudNN
         /UTCQPD4ZETFImvdHD/dEkv4/4beEnAlbFQsPV2g=
From:   =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
To:     Shawn Guo <shawnguo@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        stable@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [PATCH 1/2] ARM: dts: imx6dl-yapp4: Fix lp5562 LED driver probe
Date:   Wed, 18 Aug 2021 09:02:08 +0200
Message-Id: <20210818070209.1540451-1-michal.vokac@ysoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the LED multicolor framework support was added in commit
92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
LEDs on this platform stopped working.

Author of the framework attempted to accommodate this DT to the
framework in commit b86d3d21cd4c ("ARM: dts: imx6dl-yapp4: Add reg property
to the lp5562 channel node") but that is not sufficient. A color property
is now required even if the multicolor framework is not used, otherwise
the driver probe fails:

  lp5562: probe of 1-0030 failed with error -22

Add the color property to fix this.

Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
Cc: <stable@vger.kernel.org>
Cc: linux-leds@vger.kernel.org
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
---
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
index 7d2c72562c73..8c796551352b 100644
--- a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
+++ b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
@@ -5,6 +5,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/input/input.h>
+#include <dt-bindings/leds/common.h>
 #include <dt-bindings/pwm/pwm.h>
 
 / {
@@ -271,6 +272,7 @@ chan@0 {
 			led-cur = /bits/ 8 <0x20>;
 			max-cur = /bits/ 8 <0x60>;
 			reg = <0>;
+			color = <LED_COLOR_ID_RED>;
 		};
 
 		chan@1 {
@@ -278,6 +280,7 @@ chan@1 {
 			led-cur = /bits/ 8 <0x20>;
 			max-cur = /bits/ 8 <0x60>;
 			reg = <1>;
+			color = <LED_COLOR_ID_GREEN>;
 		};
 
 		chan@2 {
@@ -285,6 +288,7 @@ chan@2 {
 			led-cur = /bits/ 8 <0x20>;
 			max-cur = /bits/ 8 <0x60>;
 			reg = <2>;
+			color = <LED_COLOR_ID_BLUE>;
 		};
 
 		chan@3 {
@@ -292,6 +296,7 @@ chan@3 {
 			led-cur = /bits/ 8 <0x0>;
 			max-cur = /bits/ 8 <0x0>;
 			reg = <3>;
+			color = <LED_COLOR_ID_WHITE>;
 		};
 	};
 
-- 
2.25.1

