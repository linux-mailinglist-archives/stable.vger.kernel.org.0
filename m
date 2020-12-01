Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456C22C9DC6
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390619AbgLAJ1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:27:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729333AbgLAJCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:02:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7182067D;
        Tue,  1 Dec 2020 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813328;
        bh=2CsRxRuNwFh3a65/dV+0ouIDSkW1QZKlBHw6aZbL+MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9etBgEU0gW40kuB2HvqLsE63PV8sYtRI8OmpehWOLLSiuYUHyrKKZdC7uqFL4Dms
         a6pdnbaXc/rZYwbed03lBGu0gzE+uTTrI/yS7Ct69KA30fk+7njMMaVgdUE0u8Wfn4
         dx29gBzsr93G5Pz493MNUGtD6evyACCoCGtHZbmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/57] ARM: dts: dra76x: m_can: fix order of clocks
Date:   Tue,  1 Dec 2020 09:53:35 +0100
Message-Id: <20201201084650.621209674@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
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
index 216e1d1a69c7d..473d6721b7887 100644
--- a/arch/arm/boot/dts/dra76x.dtsi
+++ b/arch/arm/boot/dts/dra76x.dtsi
@@ -35,8 +35,8 @@
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



