Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C27241DE34
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 17:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347446AbhI3P6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 11:58:49 -0400
Received: from mail.fris.de ([116.203.77.234]:36184 "EHLO mail.fris.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347341AbhI3P6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Sep 2021 11:58:48 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7DFD6BFC87;
        Thu, 30 Sep 2021 17:57:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1633017424; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding:in-reply-to:references;
        bh=o35XKi8sP7pTjx9dbzkIl3YkUdYw+egKO5cpgBi69rA=;
        b=EFB35ltBxViyg9XTKGhg/R/eUQJise6SGORQyf9D5g9qITWt9OKNtkozXNbymghIMK+etw
        38eGUoko7ryIAah/WHNRol2ZC+7bNNolEbnm9jyUHIyvo8AkxK4s2g2uqTsECdsaOmhc2T
        +wo1u3Nmcw13g4gK6OEdUmhyDd3ACyGdjZUDSk6DnSbjlyw+FK4N4bc29EwnHzIJrpdwdQ
        FTIjoNl6C3isWVbJGGNXe7XSDV96eTwOzh/y/srZo2h1BKIutcMay5yUuTypbzb1u8elOt
        ax3Lhyd/9zO0tMAuZWwIbwOVJkHYcmcG9zNid4SYIh2nlswWnnW3GsJCiBm94A==
From:   Frieder Schrempf <frieder@fris.de>
To:     devicetree@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: [PATCH 4/8] arm64: dts: imx8mm-kontron: Fix reg_rst_eth2 and reg_vdd_5v regulators
Date:   Thu, 30 Sep 2021 17:56:27 +0200
Message-Id: <20210930155633.2745201-5-frieder@fris.de>
In-Reply-To: <20210930155633.2745201-1-frieder@fris.de>
References: <20210930155633.2745201-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

The regulator reg_vdd_5v represents the fixed 5V supply on the board which
can't be switched off. Mark it as always-on.

The regulator reg_rst_eth2 should keep the reset signal of the USB ethernet
adapter deassertet anytime. Fix the polarity and mark it as always-on.

Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
index 62ba3bd08a0c..f2c8ccefd1bf 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -70,7 +70,9 @@ reg_rst_eth2: regulator-rst-eth2 {
 		regulator-name = "rst-usb-eth2";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_usb_eth2>;
-		gpio = <&gpio3 2 GPIO_ACTIVE_LOW>;
+		gpio = <&gpio3 2 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+		regulator-always-on;
 	};
 
 	reg_vdd_5v: regulator-5v {
@@ -78,6 +80,7 @@ reg_vdd_5v: regulator-5v {
 		regulator-name = "vdd-5v";
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
+		regulator-always-on;
 	};
 };
 
-- 
2.33.0

