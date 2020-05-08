Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A04B1CAADC
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgEHMh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgEHMh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D37E921473;
        Fri,  8 May 2020 12:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941447;
        bh=czb2rh6trtk0ws8zKHoLWdV/RHBUlRhmIPqcYVmHqec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFuaUTZAFOcF9VopuT4oSBc93Y27qe4Q/999NE1ZE0OOhQkO9lwJ1QYAXMdM8SNmY
         sk/5bgNQIulAtWHriQFz7cXMPeexTPRmPQii6ph+fLrQXCrSX0Q9itCMPrsKoi4OKK
         XiONQLBtmU+YUsJDuGwyJPECOECCmsa9vLfPDodI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>,
        Roger Shimizu <rogershimizu@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 4.4 036/312] ARM: dts: kirkwood: gpio pin fixes for linkstation ls-wxl/wsxl
Date:   Fri,  8 May 2020 14:30:27 +0200
Message-Id: <20200508123127.021507295@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Shimizu <rogershimizu@gmail.com>

commit 144e08abe80080c9c2cf0a06e40f1bc8150674eb upstream.

For kirkwood, gpio pins starts from 32 are in the 2nd bank, so it should be
converted to "gpio1 <pin minus 32>" in dts file.
e.g. gpio 40 should be "gpio1 8"

Besides, a few other pin fixes for ls-wxl/wsxl, to match with mpp pin
definition:
  - gpio-leds: "lswxl:blue:power" pin
  - gpio-leds: "lswxl:red:func" pin
  - gpio-leds: "lswxl:red:hdderr0" pin
  - gpio-leds: "lswxl:red:hdderr1" pin
  - gpio-fan:  low/high/alarm pin

The pin/bank issue was found when discussing Debian Bug #810894
  [https://bugs.debian.org/810894#47]

Fixes: e54e4b1b622e ("ARM: dts: add buffalo linkstation ls-wxl/wsxl")
Reported-by: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
Signed-off-by: Roger Shimizu <rogershimizu@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/kirkwood-lswxl.dts |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/arch/arm/boot/dts/kirkwood-lswxl.dts
+++ b/arch/arm/boot/dts/kirkwood-lswxl.dts
@@ -1,7 +1,8 @@
 /*
  * Device Tree file for Buffalo Linkstation LS-WXL/WSXL
  *
- * Copyright (C) 2015, rogershimizu@gmail.com
+ * Copyright (C) 2015, 2016
+ * Roger Shimizu <rogershimizu@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -156,21 +157,21 @@
 		button@1 {
 			label = "Function Button";
 			linux,code = <KEY_OPTION>;
-			gpios = <&gpio1 41 GPIO_ACTIVE_LOW>;
+			gpios = <&gpio1 9 GPIO_ACTIVE_LOW>;
 		};
 
 		button@2 {
 			label = "Power-on Switch";
 			linux,code = <KEY_RESERVED>;
 			linux,input-type = <5>;
-			gpios = <&gpio1 42 GPIO_ACTIVE_LOW>;
+			gpios = <&gpio1 10 GPIO_ACTIVE_LOW>;
 		};
 
 		button@3 {
 			label = "Power-auto Switch";
 			linux,code = <KEY_ESC>;
 			linux,input-type = <5>;
-			gpios = <&gpio1 43 GPIO_ACTIVE_LOW>;
+			gpios = <&gpio1 11 GPIO_ACTIVE_LOW>;
 		};
 	};
 
@@ -185,12 +186,12 @@
 
 		led@1 {
 			label = "lswxl:blue:func";
-			gpios = <&gpio1 36 GPIO_ACTIVE_LOW>;
+			gpios = <&gpio1 4 GPIO_ACTIVE_LOW>;
 		};
 
 		led@2 {
 			label = "lswxl:red:alarm";
-			gpios = <&gpio1 49 GPIO_ACTIVE_LOW>;
+			gpios = <&gpio1 17 GPIO_ACTIVE_LOW>;
 		};
 
 		led@3 {
@@ -200,23 +201,23 @@
 
 		led@4 {
 			label = "lswxl:blue:power";
-			gpios = <&gpio1 8 GPIO_ACTIVE_LOW>;
+			gpios = <&gpio1 7 GPIO_ACTIVE_LOW>;
 		};
 
 		led@5 {
 			label = "lswxl:red:func";
-			gpios = <&gpio1 5 GPIO_ACTIVE_LOW>;
+			gpios = <&gpio1 2 GPIO_ACTIVE_LOW>;
 			default-state = "keep";
 		};
 
 		led@6 {
 			label = "lswxl:red:hdderr0";
-			gpios = <&gpio1 2 GPIO_ACTIVE_LOW>;
+			gpios = <&gpio0 8 GPIO_ACTIVE_LOW>;
 		};
 
 		led@7 {
 			label = "lswxl:red:hdderr1";
-			gpios = <&gpio1 3 GPIO_ACTIVE_LOW>;
+			gpios = <&gpio1 14 GPIO_ACTIVE_LOW>;
 		};
 	};
 
@@ -225,15 +226,15 @@
 		pinctrl-0 = <&pmx_fan_low &pmx_fan_high &pmx_fan_lock>;
 		pinctrl-names = "default";
 
-		gpios = <&gpio0 47 GPIO_ACTIVE_LOW
-			 &gpio0 48 GPIO_ACTIVE_LOW>;
+		gpios = <&gpio1 16 GPIO_ACTIVE_LOW
+			 &gpio1 15 GPIO_ACTIVE_LOW>;
 
 		gpio-fan,speed-map = <0 3
 				1500 2
 				3250 1
 				5000 0>;
 
-		alarm-gpios = <&gpio1 49 GPIO_ACTIVE_HIGH>;
+		alarm-gpios = <&gpio1 8 GPIO_ACTIVE_HIGH>;
 	};
 
 	restart_poweroff {
@@ -256,7 +257,7 @@
 			enable-active-high;
 			regulator-always-on;
 			regulator-boot-on;
-			gpio = <&gpio0 37 GPIO_ACTIVE_HIGH>;
+			gpio = <&gpio1 5 GPIO_ACTIVE_HIGH>;
 		};
 		hdd_power0: regulator@2 {
 			compatible = "regulator-fixed";


