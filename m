Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480A231BC84
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhBOPav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhBOP3s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:29:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37DC764E64;
        Mon, 15 Feb 2021 15:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402922;
        bh=x22AnEuiYNS/iYMtz8SWHqqNUIEUEDFE0qZjenqLcgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8IhR0Oa2ly3JLfHCNg6mhcX2g1NjnPlMqiEDx96yS74fYQCL8P/92qy/Op4zf9LC
         UzgHcYR941oWndgLnCWKSz418Ewa8vnD0GS6nNmZkPJL1CDqi2rXaZvMS0ep05rgTX
         exgV3JJyvwdiDsWhVqu+l2nzxKRC9vAWwFR6ZzE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/60] ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL
Date:   Mon, 15 Feb 2021 16:27:09 +0100
Message-Id: <20210215152716.041883017@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -329,9 +329,6 @@
 
 					clocks = <&xtal_32k>, <&xtal>;
 					clock-names = "xtal_32k", "xtal";
-
-					assigned-clocks = <&clk LPC32XX_CLK_HCLK_PLL>;
-					assigned-clock-rates = <208000000>;
 				};
 			};
 
-- 
2.27.0



