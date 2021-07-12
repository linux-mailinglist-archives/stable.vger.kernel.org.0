Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79853C47A1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbhGLGdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235382AbhGLGcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2649610CD;
        Mon, 12 Jul 2021 06:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071359;
        bh=4jVTRLATpxqQ7WBKq88sAf2fAMSL+T/Ox3CICqclvRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwrstYmeO5oD+h02/vCFytgntTwpFwWukWABJXmYUKRruwGgHqw0ZW8qm+GdtJsDW
         kp/BCavGH2jiHnl0hoU3X48GywkvOy97TgFzfjDjtsg0hx4/8+sB8f1dDN2eTbCbtf
         HO+SilqJi4wwLxcCAIkzF1Yw69tJPIDxkLyVmknQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 5.10 037/593] ARM: dts: ux500: Fix LED probing
Date:   Mon, 12 Jul 2021 08:03:17 +0200
Message-Id: <20210712060847.261682106@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 7749510c459c10c431d746a4749e7c9cf2899156 upstream.

The Ux500 HREF LEDs have not been probing properly for a
while as this was introduce:

     ret = of_property_read_u32(np, "color", &led_color);
     if (ret)
             return ret;

Since the device tree did not define the new invented color
attribute, probe was failing.

Define color attributes for the LEDs so they work again.

Link: https://lore.kernel.org/r/20210613123356.880933-1-linus.walleij@linaro.org
Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
Cc: stable@vger.kernel.org
Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/arch/arm/boot/dts/ste-href.dtsi b/arch/arm/boot/dts/ste-href.dtsi
index 83b179692dff..13d216192904 100644
--- a/arch/arm/boot/dts/ste-href.dtsi
+++ b/arch/arm/boot/dts/ste-href.dtsi
@@ -4,6 +4,7 @@
  */
 
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/leds/common.h>
 #include "ste-href-family-pinctrl.dtsi"
 
 / {
@@ -64,17 +65,20 @@ chan@0 {
 					reg = <0>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 					linux,default-trigger = "heartbeat";
 				};
 				chan@1 {
 					reg = <1>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 				chan@2 {
 					reg = <2>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 			};
 			lp5521@34 {
@@ -88,16 +92,19 @@ chan@0 {
 					reg = <0>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 				chan@1 {
 					reg = <1>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 				chan@2 {
 					reg = <2>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 			};
 			bh1780@29 {


