Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169ED34C9FD
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbhC2Ieh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234697AbhC2Id2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19705619D1;
        Mon, 29 Mar 2021 08:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006776;
        bh=2TW9CPbQ/+CJJBqvvlc7FFDOu/dSgrA0mwKG1D8j9BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0RA6P1f6Mk46tsXKGreIMA8YQS24RTYeEEAXikeyngChTVW7aCgKZv1RFFA1HNBY
         HHUnQs/Azvm+QEZguriv49zerhIhSlVf+bFLwa6sNGT7sDhagLT6WDvNT+xaXXZBwg
         MzLsvAJ5YTC3Dc13t9f35Nc2GdQIBy9sXE8IGIiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sandeep Sheriker Mallikarjun 
        <sandeepsheriker.mallikarjun@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.11 092/254] ARM: dts: at91: sam9x60: fix mux-mask to match products datasheet
Date:   Mon, 29 Mar 2021 09:56:48 +0200
Message-Id: <20210329075636.202249210@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

commit 2c69c8a1736eace8de491d480e6e577a27c2087c upstream.

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
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20210310152006.15018-1-nicolas.ferre@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/at91-sam9x60ek.dts |    8 --------
 arch/arm/boot/dts/sam9x60.dtsi       |    9 +++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -334,14 +334,6 @@
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
--- a/arch/arm/boot/dts/sam9x60.dtsi
+++ b/arch/arm/boot/dts/sam9x60.dtsi
@@ -606,6 +606,15 @@
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


