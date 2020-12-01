Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306782C9C67
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389832AbgLAJLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389827AbgLAJLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:11:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA69D2223F;
        Tue,  1 Dec 2020 09:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813863;
        bh=l/6/TSOPO7fWj6RFG6mgP7piWhupJSRqSCE3om6mm30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dy1wfd9g3VwCPcyiyiFHh417C2jPpoC0lWyJAEq3nH0moZ4Ef50F1RUP5ymx/AksB
         ipNa2yn5t88lH9a+A2qpJbT7kWPduxQElMqWMd+wQLlwdTFBJyayvQGs9BjzFQn47h
         q46rqPyylyDvS6jmyquaVgNgcZIBYeDZfohYwnTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 086/152] ARM: dts: dra76x: m_can: fix order of clocks
Date:   Tue,  1 Dec 2020 09:53:21 +0100
Message-Id: <20201201084723.141019483@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 05d5de6ba7dbe490dd413b5ca11d0875bd2bc006 ]

According to the bosch,m_can.yaml bindings the first clock shall be the "hclk",
while the second clock "cclk".

This patch fixes the order accordingly.

Fixes: 0adbe832f21a ("ARM: dts: dra76x: Add MCAN node")
Cc: Faiz Abbas <faiz_abbas@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra76x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dra76x.dtsi b/arch/arm/boot/dts/dra76x.dtsi
index b69c7d40f5d82..2f326151116b7 100644
--- a/arch/arm/boot/dts/dra76x.dtsi
+++ b/arch/arm/boot/dts/dra76x.dtsi
@@ -32,8 +32,8 @@
 				interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "int0", "int1";
-				clocks = <&mcan_clk>, <&l3_iclk_div>;
-				clock-names = "cclk", "hclk";
+				clocks = <&l3_iclk_div>, <&mcan_clk>;
+				clock-names = "hclk", "cclk";
 				bosch,mram-cfg = <0x0 0 0 32 0 0 1 1>;
 			};
 		};
-- 
2.27.0



