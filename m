Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A80826B6C5
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgIPAKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbgIOO0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:26:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7A832244C;
        Tue, 15 Sep 2020 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179555;
        bh=x4U0PxElE1NikM11/3itTjZcEzcHNr2qNGiO5fYb0us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPskg+GJUp3eoqYaGTb3QEjsF77pWzatw6NYiMhbjBkK7mzJOWhECBueFiD2HFqpV
         o7hV7zdxkfNS0Zub2EOfGK9jCT0hkBs/I55Hl47M4HjCNZaKoWlDT94R4Ae70IPdkt
         EadVIbTMsgMkYsDHnOopI5k+xPoXRK8YD2KKYRVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/132] ARM: dts: logicpd-som-lv-baseboard: Fix missing video
Date:   Tue, 15 Sep 2020 16:11:45 +0200
Message-Id: <20200915140644.251012323@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit d1db7b80a6c8c5f81db0e80664d29b374750e2c6 ]

A previous commit removed the panel-dpi driver, which made the
SOM-LV video stop working because it relied on the DPI driver
for setting video timings.  Now that the simple-panel driver is
available in omap2plus, this patch migrates the SOM-LV dev kits
to use a similar panel and remove the manual timing requirements.
A similar patch was already done and applied to the Torpedo family.

Fixes: 8bf4b1621178 ("drm/omap: Remove panel-dpi driver")

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/logicpd-som-lv-baseboard.dtsi    | 27 ++++---------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi b/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
index c310c33ca6f3f..395e05f10d36c 100644
--- a/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
+++ b/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
@@ -104,35 +104,18 @@
 		regulator-max-microvolt = <3300000>;
 	};
 
-	lcd0: display@0 {
-		compatible = "panel-dpi";
-		label = "28";
-		status = "okay";
-		/* default-on; */
+	lcd0: display {
+		/* This isn't the exact LCD, but the timings meet spec */
+		compatible = "logicpd,type28";
 		pinctrl-names = "default";
 		pinctrl-0 = <&lcd_enable_pin>;
-		enable-gpios = <&gpio5 27 GPIO_ACTIVE_HIGH>;	/* gpio155, lcd INI */
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
-			vfront-porch = <2>;
-			vsync-len = <11>;
-			hsync-active = <1>;
-			vsync-active = <1>;
-			de-active = <1>;
-			pixelclk-active = <0>;
-		};
 	};
 
 	bl: backlight {
-- 
2.25.1



