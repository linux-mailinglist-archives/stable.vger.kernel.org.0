Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D95CA6FD
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392811AbfJCQtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392781AbfJCQtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:49:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3864C2070B;
        Thu,  3 Oct 2019 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121356;
        bh=Wb/Buv17l28cIMxrABBRC99pWTC6SdHgYan1rcQ+RPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5GkjxWFaRVZCT5xsNoJAXD68POS9mY4eYUF6nfva/eCHcRpBD4/vyEHjKBgjQsrJ
         paoBuP6kKiU6bwYeqrWR9vXKq1n7WT6JEM60SOuWt+b/Y+sExf891YYRT+G+9WgrXb
         TVEkUSMTYa7zROGmq2r8UnZDdb19V77g8moTabQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.3 248/344] ARM: dts: am3517-evm: Fix missing video
Date:   Thu,  3 Oct 2019 17:53:33 +0200
Message-Id: <20191003154604.927013033@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

commit 24cf23276a54dd2825d3e3965c1b1b453e2a113d upstream.

A previous commit removed the panel-dpi driver, which made the
video on the AM3517-evm stop working because it relied on the dpi
driver for setting video timings.  Now that the simple-panel driver
is available in omap2plus, this patch migrates the am3517-evm
to use a similar panel and remove the manual timing requirements.

Fixes: 8bf4b1621178 ("drm/omap: Remove panel-dpi driver")

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/am3517-evm.dts |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

--- a/arch/arm/boot/dts/am3517-evm.dts
+++ b/arch/arm/boot/dts/am3517-evm.dts
@@ -124,10 +124,11 @@
 	};
 
 	lcd0: display@0 {
-		compatible = "panel-dpi";
+		/* This isn't the exact LCD, but the timings meet spec */
+		/* To make it work, set CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK=4 */
+		compatible = "newhaven,nhd-4.3-480272ef-atxl";
 		label = "15";
-		status = "okay";
-		pinctrl-names = "default";
+		backlight = <&bl>;
 		enable-gpios = <&gpio6 16 GPIO_ACTIVE_HIGH>;	/* gpio176, lcd INI */
 		vcc-supply = <&vdd_io_reg>;
 
@@ -136,22 +137,6 @@
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


