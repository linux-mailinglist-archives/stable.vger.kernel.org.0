Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1268C429007
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236510AbhJKOEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:04:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238622AbhJKOBf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:01:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E91A610A4;
        Mon, 11 Oct 2021 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960648;
        bh=a7soBnvaJvvym5T4g5L+xes0HRLJVFw//NvxaoIThtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnjo9aZCQEpSorhqXFEH4EYdyBcR2/OX49YF+9OSjrNJTufd2xx1f72WMZa1JJgDV
         KHpyiNLuOFJq+9l9tIPc20gQyB6wF/206GqoyZC+A2EOMsuwECTN3hJhMzlvj2g77R
         lXBV3H/qA/Qx7npb0+VZLBjUr0dM5Y4Qdk13SpPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Pavel Machek <pavel@ucw.cz>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.14 032/151] ARM: dts: imx6dl-yapp4: Fix lp5562 LED driver probe
Date:   Mon, 11 Oct 2021 15:45:04 +0200
Message-Id: <20211011134518.892004185@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Vokáč <michal.vokac@ysoft.com>

commit 9b663b34c94a78f39fa2c7a8271b1f828b546e16 upstream.

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
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
+++ b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
@@ -5,6 +5,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/input/input.h>
+#include <dt-bindings/leds/common.h>
 #include <dt-bindings/pwm/pwm.h>
 
 / {
@@ -277,6 +278,7 @@
 			led-cur = /bits/ 8 <0x20>;
 			max-cur = /bits/ 8 <0x60>;
 			reg = <0>;
+			color = <LED_COLOR_ID_RED>;
 		};
 
 		chan@1 {
@@ -284,6 +286,7 @@
 			led-cur = /bits/ 8 <0x20>;
 			max-cur = /bits/ 8 <0x60>;
 			reg = <1>;
+			color = <LED_COLOR_ID_GREEN>;
 		};
 
 		chan@2 {
@@ -291,6 +294,7 @@
 			led-cur = /bits/ 8 <0x20>;
 			max-cur = /bits/ 8 <0x60>;
 			reg = <2>;
+			color = <LED_COLOR_ID_BLUE>;
 		};
 
 		chan@3 {
@@ -298,6 +302,7 @@
 			led-cur = /bits/ 8 <0x0>;
 			max-cur = /bits/ 8 <0x0>;
 			reg = <3>;
+			color = <LED_COLOR_ID_WHITE>;
 		};
 	};
 


