Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D4826B59D
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgIOXs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgIOOdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 162D923BEB;
        Tue, 15 Sep 2020 14:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179892;
        bh=LI/sscUIW8xR4KpzI5c/auJJcSJXS1F1ajHVrXqEM+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OV+/ltZ3fwvnA2NjhideerlJx6jgwLVC5YGHgMhYX6O+0QTHXByqd2AxIGpi47jQm
         chB5ba6ziZbiMKcRTbDHsxgrrrEngisTHzY1oldvm2/tGpqL/C7Vq/O5mqVy8cX4Kz
         NY67Ad/Abta4uxiG2Tg70XVWeyjVfMK36/Cf3TOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Shah <dave@ds0.me>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 008/177] ARM: dts: omap5: Fix DSI base address and clocks
Date:   Tue, 15 Sep 2020 16:11:19 +0200
Message-Id: <20200915140654.039362173@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Shah <dave@ds0.me>

[ Upstream commit 6542e2b613c2b1952e83973dc434831332ce8e27 ]

DSI was not probing due to base address off by 0x1000, and sys_clk
missing.

With this patch, the Pyra display works if HDMI is disabled in the
device tree.

Fixes: 5a507162f096 ("ARM: dts: Configure interconnect target module for omap5 dsi1")
Signed-off-by: David Shah <dave@ds0.me>
Tested-by: H. Nikolaus Schaller <hns@goldelico.com>
[tony@atomide.com: standardized subject line, added fixes tag]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap5.dtsi | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index fb889c5b00c9d..de55ac5e60f39 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -463,11 +463,11 @@
 					};
 				};
 
-				target-module@5000 {
+				target-module@4000 {
 					compatible = "ti,sysc-omap2", "ti,sysc";
-					reg = <0x5000 0x4>,
-					      <0x5010 0x4>,
-					      <0x5014 0x4>;
+					reg = <0x4000 0x4>,
+					      <0x4010 0x4>,
+					      <0x4014 0x4>;
 					reg-names = "rev", "sysc", "syss";
 					ti,sysc-sidle = <SYSC_IDLE_FORCE>,
 							<SYSC_IDLE_NO>,
@@ -479,7 +479,7 @@
 					ti,syss-mask = <1>;
 					#address-cells = <1>;
 					#size-cells = <1>;
-					ranges = <0 0x5000 0x1000>;
+					ranges = <0 0x4000 0x1000>;
 
 					dsi1: encoder@0 {
 						compatible = "ti,omap5-dsi";
@@ -489,8 +489,9 @@
 						reg-names = "proto", "phy", "pll";
 						interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
 						status = "disabled";
-						clocks = <&dss_clkctrl OMAP5_DSS_CORE_CLKCTRL 8>;
-						clock-names = "fck";
+						clocks = <&dss_clkctrl OMAP5_DSS_CORE_CLKCTRL 8>,
+							 <&dss_clkctrl OMAP5_DSS_CORE_CLKCTRL 10>;
+						clock-names = "fck", "sys_clk";
 					};
 				};
 
@@ -520,8 +521,9 @@
 						reg-names = "proto", "phy", "pll";
 						interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
 						status = "disabled";
-						clocks = <&dss_clkctrl OMAP5_DSS_CORE_CLKCTRL 8>;
-						clock-names = "fck";
+						clocks = <&dss_clkctrl OMAP5_DSS_CORE_CLKCTRL 8>,
+							 <&dss_clkctrl OMAP5_DSS_CORE_CLKCTRL 10>;
+						clock-names = "fck", "sys_clk";
 					};
 				};
 
-- 
2.25.1



