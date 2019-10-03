Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4EADCA8D3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391617AbfJCQdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392000AbfJCQdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:33:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C63AD2086A;
        Thu,  3 Oct 2019 16:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120411;
        bh=/J2pAeecO5+wy94vLp5m0dXczIyTOj8lr+GmEvWqm2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShLTMzxfIufZ812gTvFa34gCRRUOgtMdmGDrASzgu5NKlPgyh11qgcNzpzf47B7FZ
         raiNEFUtw1xF0PVbOWZST30HjZtBgba+FMXZtMRyb31C7Tn8EXqkZGhuFdKmmWGVgu
         FUK46h0uINjiJPuEYzKGN455kvlgWJaDYZTdqk/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.2 213/313] ARM: dts: logicpd-torpedo-baseboard: Fix missing video
Date:   Thu,  3 Oct 2019 17:53:11 +0200
Message-Id: <20191003154553.964985089@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

commit f9f5518a38684e031d913f40482721ff553f5ba2 upstream.

A previous commit removed the panel-dpi driver, which made the
Torpedo video stop working because it relied on the dpi driver
for setting video timings.  Now that the simple-panel driver is
available in omap2plus, this patch migrates the Torpedo dev kits
to use a similar panel and remove the manual timing requirements.

Fixes: 8bf4b1621178 ("drm/omap: Remove panel-dpi driver")

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi |   37 +++--------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

--- a/arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi
+++ b/arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi
@@ -108,7 +108,6 @@
 &dss {
 	status = "ok";
 	vdds_dsi-supply = <&vpll2>;
-	vdda_video-supply = <&video_reg>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&dss_dpi_pins1>;
 	port {
@@ -124,44 +123,20 @@
 		display0 = &lcd0;
 	};
 
-	video_reg: video_reg {
-		pinctrl-names = "default";
-		pinctrl-0 = <&panel_pwr_pins>;
-		compatible = "regulator-fixed";
-		regulator-name = "fixed-supply";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-		gpio = <&gpio5 27 GPIO_ACTIVE_HIGH>;	/* gpio155, lcd INI */
-	};
-
 	lcd0: display {
-		compatible = "panel-dpi";
+		/* This isn't the exact LCD, but the timings meet spec */
+		/* To make it work, set CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK=4 */
+		compatible = "newhaven,nhd-4.3-480272ef-atxl";
 		label = "15";
-		status = "okay";
-		/* default-on; */
 		pinctrl-names = "default";
-
+		pinctrl-0 = <&panel_pwr_pins>;
+		backlight = <&bl>;
+		enable-gpios = <&gpio5 27 GPIO_ACTIVE_HIGH>;
 		port {
 			lcd_in: endpoint {
 				remote-endpoint = <&dpi_out>;
 			};
 		};
-
-		panel-timing {
-			clock-frequency = <9000000>;
-			hactive = <480>;
-			vactive = <272>;
-			hfront-porch = <3>;
-			hback-porch = <2>;
-			hsync-len = <42>;
-			vback-porch = <3>;
-			vfront-porch = <4>;
-			vsync-len = <11>;
-			hsync-active = <0>;
-			vsync-active = <0>;
-			de-active = <1>;
-			pixelclk-active = <1>;
-		};
 	};
 
 	bl: backlight {


