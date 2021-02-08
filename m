Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7097313C48
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbhBHSFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235165AbhBHSAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:00:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE61F64ECA;
        Mon,  8 Feb 2021 17:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807125;
        bh=CACrHjdgxxlqeca6xM+QPTTCAdtofJkj0XFyOoi53QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrHQq6FYJCqLx84GkHscUD+O0H7OCvRLbWEks/0A4eoe66ZdLxQkJkGR38G5rQZck
         v+x4ih7IOa2UC5AuhrDRj5aVkGs5h7rxNry/hrnDbMtE2M9YwaENYq9aLFhJRxDmgT
         IxsgKT9v4PkLJnrrPCv2umoh8Kvw4K+n9XI57CLtXm7oMmw3smHsTnVaGSKAtlXeWx
         f1Vb1EZsTdSJ1487xxsQHn0p/Pg3RGZQ7hqlX9jBPszoExxbkvKoyR/S3fCD+b1XCe
         fFJHZAbIANY3mvOkWLqj8ahTpyjUvaFFtakYMovWUhRLwxb+oe1hDu05vO92cvWscD
         VwQscF+NLuN+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 28/36] ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL
Date:   Mon,  8 Feb 2021 12:57:58 -0500
Message-Id: <20210208175806.2091668-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
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
index 7b7ec7b1217b8..824393e1bcfb7 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
@@ -329,9 +329,6 @@ clk: clock-controller@0 {
 
 					clocks = <&xtal_32k>, <&xtal>;
 					clock-names = "xtal_32k", "xtal";
-
-					assigned-clocks = <&clk LPC32XX_CLK_HCLK_PLL>;
-					assigned-clock-rates = <208000000>;
 				};
 			};
 
-- 
2.27.0

