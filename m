Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391AF13EF0C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405252AbgAPRg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731622AbgAPRg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:36:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0BB4246AD;
        Thu, 16 Jan 2020 17:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196218;
        bh=KaJf4hSD/y/mradPUnWk1oZqxpE7DMsG6WMlEJ0ObRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqxYV1wEtHhPOSJx+tXewUq3db3NszoExjb674yYuHW8RQyWvw9dQEiU9uEcT04Id
         afL1q0dTRE6azBAuQOXOdKcFVgOV5N54SoRW7Xp013J/Ne0I7HXBeDRTo142cEqQ5u
         PzjLgUM6hqHgNoSP+2TO04nHUwxjBQ084X+E6Lls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Zapolskiy <vz@mleia.com>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 053/251] ARM: dts: lpc32xx: fix ARM PrimeCell LCD controller clocks property
Date:   Thu, 16 Jan 2020 12:33:22 -0500
Message-Id: <20200116173641.22137-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit 30fc01bae3cda747e7d9c352b1aa51ca113c8a9d ]

The originally added ARM PrimeCell PL111 clocks property misses
the required "clcdclk" clock, which is the same as a clock to enable
the LCD controller on NXP LPC3230 and NXP LPC3250 SoCs.

Fixes: 93898eb775e5 ("arm: dts: lpc32xx: add clock properties to device nodes")
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lpc32xx.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/lpc32xx.dtsi b/arch/arm/boot/dts/lpc32xx.dtsi
index 3adbbaff7971..2802c9565b6c 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
@@ -142,8 +142,8 @@
 			compatible = "arm,pl111", "arm,primecell";
 			reg = <0x31040000 0x1000>;
 			interrupts = <14 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk LPC32XX_CLK_LCD>;
-			clock-names = "apb_pclk";
+			clocks = <&clk LPC32XX_CLK_LCD>, <&clk LPC32XX_CLK_LCD>;
+			clock-names = "clcdclk", "apb_pclk";
 			status = "disabled";
 		};
 
-- 
2.20.1

