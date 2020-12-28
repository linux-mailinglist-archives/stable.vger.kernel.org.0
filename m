Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A8D2E671D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387449AbgL1QUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732398AbgL1NOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:14:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDC4B22B3A;
        Mon, 28 Dec 2020 13:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161206;
        bh=VMCbE7nrLhhGfe1E7kARDa8URoATMwrEDL3yoARcwTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PfJ9ZVjJYEl8b6RsZe3nZEtNsDsWc/Roh91/wCQiks+Td6GI3ckTwrWBJySqqsA/E
         8RJxiDHU+m89M2h+1gBMmdEXbrUQphNtJt76RUE4TtNjXTX1smgGi2bDTSMLcJ/xVy
         I4+KdwqJXd9MTJE70RGZSGChxbJGRuLesJMF36EU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 108/242] ARM: dts: at91: sama5d4_xplained: add pincontrol for USB Host
Date:   Mon, 28 Dec 2020 13:48:33 +0100
Message-Id: <20201228124910.010635078@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index 10f2fb9e0ea61..c271ca960caee 100644
--- a/arch/arm/boot/dts/at91-sama5d4_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
@@ -158,6 +158,11 @@
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
@@ -183,6 +188,8 @@
 					   &pioE 11 GPIO_ACTIVE_HIGH
 					   &pioE 14 GPIO_ACTIVE_HIGH
 					  >;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb_default>;
 			status = "okay";
 		};
 
-- 
2.27.0



