Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC7B313CA5
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbhBHSI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:08:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235152AbhBHSDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AEF664EE9;
        Mon,  8 Feb 2021 17:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807181;
        bh=genHdYrQUp3IrEwUmOaxsioICOc09CDe1p+qGObjApU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oR1roa7AGyvSlJhrhz/RLC3dDYOkfjo0WhXL9OAl2CajumyvMPFZec3bBSIoCaGnk
         ruqm6ADRPPGcSvbAP5Xb25S4TQ0vVCj9AV53TLbAFxH4kmfnQGI+rWQw32c+cYgKKS
         Wp3L0ySRD8jULhj1o7Q6R4PHZd5sxTxlDC+Otd/BkZkaUSTs7TK5L5dVFFtwMTvoON
         m0FoAqSEpNljAi/y+cdSV4VMIih3+B9ViU5FuarNSP9x4rFQRc4uSJMbbv7FRw4UfC
         +WuCCt+e2jvCZ1qbdVhGpy7x7SvAngc4RHWUco9QID3T7FNv1hdbk19NWwuYqZlR+J
         elmMLnajm6Alg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 11/14] ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL
Date:   Mon,  8 Feb 2021 12:59:23 -0500
Message-Id: <20210208175926.2092211-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175926.2092211-1-sashal@kernel.org>
References: <20210208175926.2092211-1-sashal@kernel.org>
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
index 9ad3df11db0d8..abef034987a27 100644
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

