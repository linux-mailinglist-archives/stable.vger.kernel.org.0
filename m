Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B782E65D5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389760AbgL1QFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:05:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389675AbgL1N1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:27:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A0BC208D5;
        Mon, 28 Dec 2020 13:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162024;
        bh=y2DRje8gmirsxZxje/X5CJI0Kv8FH0ddPqUkp1AkIPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHmkN49MEkTQYEnfUuvInGrUFzeLSdmoK8rlCMXN3RjExbDzftlX/rvaghdkewkaS
         AbOwHlv6Px5UI+siM7aaaIRVvYMeS/ZflelBzyKPa4/kr666uiiPWHn0Ic+kJeQqiu
         b9WZeLFWfjnzKDSsECNArMF01Y6giRrRVIcPwSH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/346] ARM: dts: at91: sama5d3_xplained: add pincontrol for USB Host
Date:   Mon, 28 Dec 2020 13:48:02 +0100
Message-Id: <20201228124927.668528769@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Birsan <cristian.birsan@microchip.com>

[ Upstream commit e1062fa7292f1e3744db0a487c4ac0109e09b03d ]

The pincontrol node is needed for USB Host since Linux v5.7-rc1. Without
it the driver probes but VBus is not powered because of wrong pincontrol
configuration.

Fixes: b7c2b61570798 ("ARM: at91: add Atmel's SAMA5D3 Xplained board")
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Link: https://lore.kernel.org/r/20201118120019.1257580-4-cristian.birsan@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d3_xplained.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index 02c1d2958d780..74440dad43354 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -243,6 +243,11 @@
 						atmel,pins =
 							<AT91_PIOE 9 AT91_PERIPH_GPIO AT91_PINCTRL_DEGLITCH>;	/* PE9, conflicts with A9 */
 					};
+					pinctrl_usb_default: usb_default {
+						atmel,pins =
+							<AT91_PIOE 3 AT91_PERIPH_GPIO AT91_PINCTRL_NONE
+							 AT91_PIOE 4 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
 				};
 			};
 		};
@@ -260,6 +265,8 @@
 					   &pioE 3 GPIO_ACTIVE_LOW
 					   &pioE 4 GPIO_ACTIVE_LOW
 					  >;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb_default>;
 			status = "okay";
 		};
 
-- 
2.27.0



