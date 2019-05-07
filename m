Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4381D16761
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 18:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfEGQF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 12:05:59 -0400
Received: from 3.mo6.mail-out.ovh.net ([178.33.253.26]:48242 "EHLO
        3.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfEGQF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 12:05:58 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2019 12:05:58 EDT
Received: from player697.ha.ovh.net (unknown [10.108.57.23])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id DD58B1C0E07
        for <stable@vger.kernel.org>; Tue,  7 May 2019 17:27:42 +0200 (CEST)
Received: from armadeus.com (lfbn-1-7591-179.w90-126.abo.wanadoo.fr [90.126.248.179])
        (Authenticated sender: sebastien.szymanski@armadeus.com)
        by player697.ha.ovh.net (Postfix) with ESMTPSA id 261115875B80;
        Tue,  7 May 2019 15:27:23 +0000 (UTC)
From:   =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>, stable@vger.kernel.org
Subject: [PATCH RE-RESEND 2/2] ARM: dts: opos6uldev: use OF graph to describe the display
Date:   Tue,  7 May 2019 17:27:13 +0200
Message-Id: <20190507152713.27494-2-sebastien.szymanski@armadeus.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190507152713.27494-1-sebastien.szymanski@armadeus.com>
References: <20190507152713.27494-1-sebastien.szymanski@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11812378874205393943
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrkedtgdelgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To make use of the new eLCDIF DRM driver OF graph description is
required. Describe the display using OF graph nodes.

Cc: stable@vger.kernel.org # v4.19
Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
---
 arch/arm/boot/dts/imx6ul-opos6uldev.dts | 37 +++++++++++--------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/imx6ul-opos6uldev.dts b/arch/arm/boot/dts/imx6ul-opos6uldev.dts
index 0e59ee57fd55..8ecdb9ad2b2e 100644
--- a/arch/arm/boot/dts/imx6ul-opos6uldev.dts
+++ b/arch/arm/boot/dts/imx6ul-opos6uldev.dts
@@ -56,7 +56,7 @@
 		stdout-path = &uart1;
 	};
 
-	backlight {
+	backlight: backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pwm3 0 191000>;
 		brightness-levels = <0 4 8 16 32 64 128 255>;
@@ -97,6 +97,18 @@
 		gpios = <&gpio5 1 GPIO_ACTIVE_HIGH>;
 	};
 
+	panel: panel {
+		compatible = "armadeus,st0700-adapt";
+		power-supply = <&reg_3v3>;
+		backlight = <&backlight>;
+
+		port {
+			panel_in: endpoint {
+				remote-endpoint = <&lcdif_out>;
+			};
+		};
+	};
+
 	reg_5v: regulator-5v {
 		compatible = "regulator-fixed";
 		regulator-name = "5V";
@@ -182,28 +194,11 @@
 &lcdif {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_lcdif>;
-	display = <&display0>;
-	lcd-supply = <&reg_3v3>;
 	status = "okay";
 
-	display0: display0 {
-		bits-per-pixel = <32>;
-		bus-width = <18>;
-
-		display-timings {
-			timing0: timing0 {
-				clock-frequency = <33000033>;
-				hactive = <800>;
-				vactive = <480>;
-				hback-porch = <96>;
-				hfront-porch = <96>;
-				vback-porch = <20>;
-				vfront-porch = <21>;
-				hsync-len = <64>;
-				vsync-len = <4>;
-				de-active = <1>;
-				pixelclk-active = <0>;
-			};
+	port {
+		lcdif_out: endpoint {
+			remote-endpoint = <&panel_in>;
 		};
 	};
 };
-- 
2.19.2

