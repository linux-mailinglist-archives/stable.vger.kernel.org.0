Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2299334169
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 16:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhCJPYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 10:24:32 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:45586 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhCJPYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 10:24:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615389863; x=1646925863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qhWXpo6sA8wYnJfCpmhhUeKxki99ScpogOsdtuDQEcE=;
  b=HSdtfbonRUJRgGu+fLKhUFjU0NRWwfOLYYgpWah6RotGpIqg/TqjdlOh
   DURAejO80bwVfFsEpx4yYf2FjI8VZ+TvuA9TGz2bJVX1h4Cb78+yg3aNL
   BCG7I7l2vigR811b42Q7cWN0Ds8ptLpYRVtZaXqejResGg3ytAsWmfmNj
   cqwA5QNvulXLsNyk8vw+6pSolzgU8aaxFSjYVOFidMwlav2WtwqrFpz1G
   UIP8bVec5jShWTC2q6k36KwiPAZgf9kggQJdo1TGsF4gGb129NonT/rbk
   PZ/tPs1mTP3JWBAVFFllLQUKOJQlM8wcUTdlV/Jsu8Xtu+qqJSjCf15gT
   Q==;
IronPort-SDR: z5a9mHrbjdtSN5C3UNt19sNUfkkeZj2wAtkzrtCzYBCTgD3wENdTyCQa2Tgp3iLqKFwovhNlaR
 FACx+uy8CBiVokvauiqyI7VgSPqOvCJ3bGBaQLa12cINq3y7zaNBJ1Wmq7eWW8QVqiqXiGVZIc
 Z7us53e1JSSkokTbBC6DXYlj6oqjb6kGXKeRDrLSfyEU8uFkmuuKpIyYUFeMG1e1m4MzrtHWNN
 r7FdBnMKidd84fhqE3XgwsGUn5h4u19PCp/HHnrLVlN5a8fgFEcCFXHv99X+uj7Cfsep8H865K
 lR8=
X-IronPort-AV: E=Sophos;i="5.81,237,1610434800"; 
   d="scan'208";a="106651791"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 08:24:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 08:24:23 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 10 Mar 2021 08:24:21 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
CC:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        <stable@vger.kernel.org>,
        "Sandeep Sheriker Mallikarjun" 
        <sandeepsheriker.mallikarjun@microchip.com>
Subject: [PATCH v2] ARM: dts: at91: sam9x60: fix mux-mask to match product's datasheet
Date:   Wed, 10 Mar 2021 16:20:06 +0100
Message-ID: <20210310152006.15018-1-nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210308184527.33036-1-nicolas.ferre@microchip.com>
References: <20210308184527.33036-1-nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Fix the whole mux-mask table according to datasheet for the sam9x60
product.  Too much functions for pins were disabled leading to
misunderstandings when enabling more peripherals or taking this table
as an example for another board.
Take advantage of this fix to move the mux-mask in the SoC file where it
belongs and use lower case letters for hex numbers like everywhere in
the file.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Fixes: 1e5f532c2737 ("ARM: dts: at91: sam9x60: add device tree for soc and board")
Cc: <stable@vger.kernel.org> # 5.6+
Cc: Sandeep Sheriker Mallikarjun <sandeepsheriker.mallikarjun@microchip.com>
---
v1 -> v2:
- move to SoC dtsi file: it applies to all boards using the sam9x60 SoC version
- use lower case for hex numbers instead of mixed nonsense

 arch/arm/boot/dts/at91-sam9x60ek.dts | 8 --------
 arch/arm/boot/dts/sam9x60.dtsi       | 9 +++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index 4c40ae571154..775ceb3acb6c 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -334,14 +334,6 @@ ethernet-phy@0 {
 };
 
 &pinctrl {
-	atmel,mux-mask = <
-			 /*	A	B	C	*/
-			 0xFFFFFEFF 0xC0E039FF 0xEF00019D	/* pioA */
-			 0x03FFFFFF 0x02FC7E68 0x00780000	/* pioB */
-			 0xffffffff 0xF83FFFFF 0xB800F3FC	/* pioC */
-			 0x003FFFFF 0x003F8000 0x00000000	/* pioD */
-			 >;
-
 	adc {
 		pinctrl_adc_default: adc_default {
 			atmel,pins = <AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE>;
diff --git a/arch/arm/boot/dts/sam9x60.dtsi b/arch/arm/boot/dts/sam9x60.dtsi
index 84066c1298df..ec45ced3cde6 100644
--- a/arch/arm/boot/dts/sam9x60.dtsi
+++ b/arch/arm/boot/dts/sam9x60.dtsi
@@ -606,6 +606,15 @@ pinctrl: pinctrl@fffff400 {
 				compatible = "microchip,sam9x60-pinctrl", "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "simple-bus";
 				ranges = <0xfffff400 0xfffff400 0x800>;
 
+				/* mux-mask corresponding to sam9x60 SoC in TFBGA228L package */
+				atmel,mux-mask = <
+						 /*	A	B	C	*/
+						 0xffffffff 0xffe03fff 0xef00019d	/* pioA */
+						 0x03ffffff 0x02fc7e7f 0x00780000	/* pioB */
+						 0xffffffff 0xffffffff 0xf83fffff	/* pioC */
+						 0x003fffff 0x003f8000 0x00000000	/* pioD */
+						 >;
+
 				pioA: gpio@fffff400 {
 					compatible = "microchip,sam9x60-gpio", "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
-- 
2.30.2

