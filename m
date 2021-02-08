Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A879313CB5
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbhBHSIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:08:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235432AbhBHSGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:06:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F59064EF4;
        Mon,  8 Feb 2021 18:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807204;
        bh=8olhe+kd+LG8lLR2OlrkeSqcVmhre88z3JtLm/Ojh7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvPpaSaZXwWAO3KH2W7tMs9Red09CZ8uUpR6B5zutQAiTdFynPoFrX50EuJw8I0Wn
         sxi5TBjPQzxoz+bC7L0wdLchrBJn5M1xB4K/08bxEBGnjPAx++euDr6qpGqY43eZN2
         RS9L3OaG69MqlSVux3wx3KWx2/tp8XJlW4Nkgr9oJrox5VmYMQhTWcML7C+R+9FV3E
         H/ue+ED1wdRoZLau+0S/MownwfZAV7m1NXAvpCAFDA7vvxiRcLEvKu3//t45Ic3whZ
         sP7KG3YhWTZRHcXWxYSDFBcr+zO3BwmekbU9+h7cP3aOPJX/f3/nhNiKh8qtb0Xo6S
         krrgUEHCwMyfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 3/4] ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL
Date:   Mon,  8 Feb 2021 12:59:59 -0500
Message-Id: <20210208180000.2092497-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208180000.2092497-1-sashal@kernel.org>
References: <20210208180000.2092497-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 5638159f6d93b99ec9743ac7f65563fca3cf413d ]

This reverts commit c17e9377aa81664d94b4f2102559fcf2a01ec8e7.

The lpc32xx clock driver is not able to actually change the PLL rate as
this would require reparenting ARM_CLK, DDRAM_CLK, PERIPH_CLK to SYSCLK,
then stop the PLL, update the register, restart the PLL and wait for the
PLL to lock and finally reparent ARM_CLK, DDRAM_CLK, PERIPH_CLK to HCLK
PLL.

Currently, the HCLK driver simply updates the registers but this has no
real effect and all the clock rate calculation end up being wrong. This is
especially annoying for the peripheral (e.g. UARTs, I2C, SPI).

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Tested-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20210203090320.GA3760268@piout.net'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lpc32xx.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/boot/dts/lpc32xx.dtsi b/arch/arm/boot/dts/lpc32xx.dtsi
index 2802c9565b6ca..976a75a4eb2c6 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
@@ -323,9 +323,6 @@ clk: clock-controller@0 {
 
 					clocks = <&xtal_32k>, <&xtal>;
 					clock-names = "xtal_32k", "xtal";
-
-					assigned-clocks = <&clk LPC32XX_CLK_HCLK_PLL>;
-					assigned-clock-rates = <208000000>;
 				};
 			};
 
-- 
2.27.0

