Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5DD148024
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389090AbgAXLIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:08:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389598AbgAXLH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:07:59 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62EB32071A;
        Fri, 24 Jan 2020 11:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864079;
        bh=We6EuB01vHZaNthDNkLWEc3Hh6eHcDQE3m+IvHbdDiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5aY5U+EB54TdaUZaovaTeGtbxD1eMWxvKvzoU4ru5UAiOR4jU1ba66pVfPR7jQ5Y
         3v9mwQavROk9H0hQQbjrumxy7J9ro7Ux7NS5y6del1DM8SXmIZ+x4dE8ODFz+6PHrn
         6MbxgrrKStkOaeiEYahswkAK6N4gaigvb7kfyOkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Zapolskiy <vz@mleia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/639] ARM: dts: lpc32xx: fix ARM PrimeCell LCD controller clocks property
Date:   Fri, 24 Jan 2020 10:25:36 +0100
Message-Id: <20200124093107.968584719@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cfd422e7f774d..9ad3df11db0d8 100644
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



