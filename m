Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B0CB843F
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405386AbfISWJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405379AbfISWJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:09:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA1021928;
        Thu, 19 Sep 2019 22:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930955;
        bh=FyVssxbu35YOSuSBsVhZcdxlN4l730ukFePFxHMR+LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAquTO2P47U2XZo7JXrfxLmrg53juX9DHwMR5hto/DKd2OpY28N3qzydJX52fRMnA
         f7lLRdDnqe0NwmfjjJ+7HSkuclcGbxPVaS8/dUm366sRPuq/23CVLHgXVji96dqPhT
         N/b8grkLnCkGnzedeziIDtqK7yZELKGdYIKGNu9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 034/124] ARM: dts: Fix incorrect dcan register mapping for am3, am4 and dra7
Date:   Fri, 20 Sep 2019 00:02:02 +0200
Message-Id: <20190919214820.262275206@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 89bbc6f1eb90809b1538b3a9c54030c558180e3b ]

We are currently using a wrong register for dcan revision. Although
this is currently only used for detecting the dcan module, let's
fix it to avoid confusion.

Tested-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am33xx-l4.dtsi | 4 ++++
 arch/arm/boot/dts/am437x-l4.dtsi | 4 ++++
 arch/arm/boot/dts/dra7-l4.dtsi   | 4 ++--
 drivers/bus/ti-sysc.c            | 3 ++-
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx-l4.dtsi b/arch/arm/boot/dts/am33xx-l4.dtsi
index ced1a19d5f898..4bd22c1edf963 100644
--- a/arch/arm/boot/dts/am33xx-l4.dtsi
+++ b/arch/arm/boot/dts/am33xx-l4.dtsi
@@ -1758,6 +1758,8 @@
 
 		target-module@cc000 {			/* 0x481cc000, ap 60 46.0 */
 			compatible = "ti,sysc-omap4", "ti,sysc";
+			reg = <0xcc020 0x4>;
+			reg-names = "rev";
 			ti,hwmods = "d_can0";
 			/* Domains (P, C): per_pwrdm, l4ls_clkdm */
 			clocks = <&l4ls_clkctrl AM3_L4LS_D_CAN0_CLKCTRL 0>,
@@ -1780,6 +1782,8 @@
 
 		target-module@d0000 {			/* 0x481d0000, ap 62 42.0 */
 			compatible = "ti,sysc-omap4", "ti,sysc";
+			reg = <0xd0020 0x4>;
+			reg-names = "rev";
 			ti,hwmods = "d_can1";
 			/* Domains (P, C): per_pwrdm, l4ls_clkdm */
 			clocks = <&l4ls_clkctrl AM3_L4LS_D_CAN1_CLKCTRL 0>,
diff --git a/arch/arm/boot/dts/am437x-l4.dtsi b/arch/arm/boot/dts/am437x-l4.dtsi
index 989cb60b90295..04bee4ff9dcb8 100644
--- a/arch/arm/boot/dts/am437x-l4.dtsi
+++ b/arch/arm/boot/dts/am437x-l4.dtsi
@@ -1574,6 +1574,8 @@
 
 		target-module@cc000 {			/* 0x481cc000, ap 50 46.0 */
 			compatible = "ti,sysc-omap4", "ti,sysc";
+			reg = <0xcc020 0x4>;
+			reg-names = "rev";
 			ti,hwmods = "d_can0";
 			/* Domains (P, C): per_pwrdm, l4ls_clkdm */
 			clocks = <&l4ls_clkctrl AM4_L4LS_D_CAN0_CLKCTRL 0>;
@@ -1593,6 +1595,8 @@
 
 		target-module@d0000 {			/* 0x481d0000, ap 52 3a.0 */
 			compatible = "ti,sysc-omap4", "ti,sysc";
+			reg = <0xd0020 0x4>;
+			reg-names = "rev";
 			ti,hwmods = "d_can1";
 			/* Domains (P, C): per_pwrdm, l4ls_clkdm */
 			clocks = <&l4ls_clkctrl AM4_L4LS_D_CAN1_CLKCTRL 0>;
diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index 63628e166c0cd..21e5914fdd620 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -3025,7 +3025,7 @@
 
 		target-module@80000 {			/* 0x48480000, ap 31 16.0 */
 			compatible = "ti,sysc-omap4", "ti,sysc";
-			reg = <0x80000 0x4>;
+			reg = <0x80020 0x4>;
 			reg-names = "rev";
 			clocks = <&l4per2_clkctrl DRA7_L4PER2_DCAN2_CLKCTRL 0>;
 			clock-names = "fck";
@@ -4577,7 +4577,7 @@
 
 		target-module@c000 {			/* 0x4ae3c000, ap 30 04.0 */
 			compatible = "ti,sysc-omap4", "ti,sysc";
-			reg = <0xc000 0x4>;
+			reg = <0xc020 0x4>;
 			reg-names = "rev";
 			clocks = <&wkupaon_clkctrl DRA7_WKUPAON_DCAN1_CLKCTRL 0>;
 			clock-names = "fck";
diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 56a2399f341e8..58b38630171ff 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1127,7 +1127,8 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	SYSC_QUIRK("control", 0, 0, 0x10, -1, 0x40000900, 0xffffffff, 0),
 	SYSC_QUIRK("cpgmac", 0, 0x1200, 0x1208, 0x1204, 0x4edb1902,
 		   0xffff00f0, 0),
-	SYSC_QUIRK("dcan", 0, 0, -1, -1, 0xffffffff, 0xffffffff, 0),
+	SYSC_QUIRK("dcan", 0, 0x20, -1, -1, 0xa3170504, 0xffffffff, 0),
+	SYSC_QUIRK("dcan", 0, 0x20, -1, -1, 0x4edb1902, 0xffffffff, 0),
 	SYSC_QUIRK("dmic", 0, 0, 0x10, -1, 0x50010000, 0xffffffff, 0),
 	SYSC_QUIRK("dwc3", 0, 0, 0x10, -1, 0x500a0200, 0xffffffff, 0),
 	SYSC_QUIRK("epwmss", 0, 0, 0x4, -1, 0x47400001, 0xffffffff, 0),
-- 
2.20.1



