Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A744E2E690E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgL1M45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:56:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728853AbgL1M44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BA9022A84;
        Mon, 28 Dec 2020 12:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160175;
        bh=HkFTnZAK+2ebbdjtoIxSwT6atkbSo3sZtof6Xx+Q9Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hrt5J7Wz78rY/XiNweeEj9xD21ckwcbEL7dy887XSySbBQNos/r1AzqXhHuQbthek
         qehdXvU/ksp1tuLU1G9/kwO5ZTx38FPnsG63xppxSyZCZryOddt91lUq70bWsVjYTL
         YMTpuorfpzacLH9oPzeLleQnF86AkDjxNw8UzBUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 055/132] ARM: dts: at91: sama5d4_xplained: add pincontrol for USB Host
Date:   Mon, 28 Dec 2020 13:48:59 +0100
Message-Id: <20201228124849.104864422@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Birsan <cristian.birsan@microchip.com>

[ Upstream commit be4dd2d448816a27c1446f8f37fce375daf64148 ]

The pincontrol node is needed for USB Host since Linux v5.7-rc1. Without
it the driver probes but VBus is not powered because of wrong pincontrol
configuration.

Fixes: 38153a017896f ("ARM: at91/dt: sama5d4: add dts for sama5d4 xplained board")
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Link: https://lore.kernel.org/r/20201118120019.1257580-3-cristian.birsan@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d4_xplained.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/at91-sama5d4_xplained.dts b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
index e27024cdf48bd..17adaa1a65c19 100644
--- a/arch/arm/boot/dts/at91-sama5d4_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
@@ -152,6 +152,11 @@
 						atmel,pins =
 							<AT91_PIOE 31 AT91_PERIPH_GPIO AT91_PINCTRL_DEGLITCH>;
 					};
+					pinctrl_usb_default: usb_default {
+						atmel,pins =
+							<AT91_PIOE 11 AT91_PERIPH_GPIO AT91_PINCTRL_NONE
+							 AT91_PIOE 14 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
 					pinctrl_key_gpio: key_gpio_0 {
 						atmel,pins =
 							<AT91_PIOE 8 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
@@ -177,6 +182,8 @@
 					   &pioE 11 GPIO_ACTIVE_HIGH
 					   &pioE 14 GPIO_ACTIVE_HIGH
 					  >;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb_default>;
 			status = "okay";
 		};
 
-- 
2.27.0



