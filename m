Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B764D380C2A
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 16:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhENOqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 10:46:52 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:49105 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232759AbhENOqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 10:46:51 -0400
Received: from vokac-latitude.ysoft.local (unknown [10.0.28.99])
        by uho.ysoft.cz (Postfix) with ESMTP id 0FF8AA2C5C;
        Fri, 14 May 2021 16:45:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1621003538;
        bh=6WPvib1+u/MMJIgAB5EE+Z8wqS5Q6D/ao0Rp9ErE8YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSy1gTqN3ciGBYEgRG6f1yTI2yMrEx8pCZBaWsgMuzE7ZeBIWS7bYLboNd2vBD2Pt
         L1tZdFrFZ7me83LZA2b+6Z8JOaZlrl7YKuLaQE1ODuIwISBLwgOUQetz/yBCRD9WmQ
         +c/nwRhJucJ8c4gxomv31ieBI4ga5pkOHZ2W0j9Q=
From:   =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
To:     Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        stable@vger.kernel.org
Subject: [RFC 2/2] ARM: dts: imx6dl-yapp4: Fix lp5562 driver probe
Date:   Fri, 14 May 2021 16:44:37 +0200
Message-Id: <1621003477-11250-3-git-send-email-michal.vokac@ysoft.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621003477-11250-1-git-send-email-michal.vokac@ysoft.com>
References: <1621003477-11250-1-git-send-email-michal.vokac@ysoft.com>
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

Add the color property to fix this and remove the actually unused white
channel.

Fixes: b86d3d21cd4c ("ARM: dts: imx6dl-yapp4: Add reg property to the lp5562 channel node")
Cc: <stable@vger.kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: linux-leds@vger.kernel.org
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
---
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
index 7d2c72562c73..3107bf7fbce5 100644
--- a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
+++ b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
@@ -5,6 +5,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/input/input.h>
+#include <dt-bindings/leds/common.h>
 #include <dt-bindings/pwm/pwm.h>
 
 / {
@@ -271,6 +272,7 @@
 			led-cur = /bits/ 8 <0x20>;
 			max-cur = /bits/ 8 <0x60>;
 			reg = <0>;
+			color = <LED_COLOR_ID_RED>;
 		};
 
 		chan@1 {
@@ -278,6 +280,7 @@
 			led-cur = /bits/ 8 <0x20>;
 			max-cur = /bits/ 8 <0x60>;
 			reg = <1>;
+			color = <LED_COLOR_ID_GREEN>;
 		};
 
 		chan@2 {
@@ -285,13 +288,7 @@
 			led-cur = /bits/ 8 <0x20>;
 			max-cur = /bits/ 8 <0x60>;
 			reg = <2>;
-		};
-
-		chan@3 {
-			chan-name = "W";
-			led-cur = /bits/ 8 <0x0>;
-			max-cur = /bits/ 8 <0x0>;
-			reg = <3>;
+			color = <LED_COLOR_ID_BLUE>;
 		};
 	};
 
-- 
2.7.4

