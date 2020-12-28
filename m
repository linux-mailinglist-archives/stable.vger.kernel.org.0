Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DD12E3CDF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438589AbgL1OIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:08:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438583AbgL1OIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCB3A206D4;
        Mon, 28 Dec 2020 14:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164470;
        bh=xuZdtlpbaoSDyZUoxYoEnkI8NwfU9eypUec3pdGXAcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvlcJh6J2oW3fr3gSzDxrmtr8zM91GJVeJmh61nkgEIFJlaoKLU0FI9GHokxWzEW7
         pI7KTXrLuSjfy05LJfmfWjx9OjC2SXfvdxVkQVZ9IZbD8rnMFiqgruy13OW9qinSrB
         HJEaCrJHIf2GMHABSuOLxdpV3lDrtGnoLBICtwwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/717] ARM: dts: at91: sam9x60: add pincontrol for USB Host
Date:   Mon, 28 Dec 2020 13:43:10 +0100
Message-Id: <20201228125030.170421336@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Birsan <cristian.birsan@microchip.com>

[ Upstream commit 5ba6291086d2ae8006be9e0f19bf2001a85c9dc1 ]

The pincontrol node is needed for USB Host since Linux v5.7-rc1. Without
it the driver probes but VBus is not powered because of wrong pincontrol
configuration.

Fixes: 1e5f532c2737 ("ARM: dts: at91: sam9x60: add device tree for soc and board")
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Link: https://lore.kernel.org/r/20201118120019.1257580-2-cristian.birsan@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sam9x60ek.dts | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index eae28b82c7fd0..0e3b6147069f9 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -569,6 +569,13 @@
 			atmel,pins = <AT91_PIOB 16 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
 		};
 	};
+
+	usb1 {
+		pinctrl_usb_default: usb_default {
+			atmel,pins = <AT91_PIOD 15 AT91_PERIPH_GPIO AT91_PINCTRL_NONE
+				      AT91_PIOD 16 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+		};
+	};
 }; /* pinctrl */
 
 &pmc {
@@ -684,6 +691,8 @@
 	atmel,vbus-gpio = <0
 			   &pioD 15 GPIO_ACTIVE_HIGH
 			   &pioD 16 GPIO_ACTIVE_HIGH>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usb_default>;
 	status = "okay";
 };
 
-- 
2.27.0



