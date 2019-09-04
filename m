Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08345A8D05
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbfIDQUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731658AbfIDP54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:57:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA2A92087E;
        Wed,  4 Sep 2019 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612675;
        bh=FyVssxbu35YOSuSBsVhZcdxlN4l730ukFePFxHMR+LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3dgi5dNGQuAXQQ2g8IvopjJHnujmdh67diaA13Pis1LKGfz0qkfpWIc5/MyHFETT
         DGZ6YVFLTpmTPQYn9Bo+5WBBOZCyn7FriVq6xaE0w0DnRe8Z1862mZ9xmsniMEC35B
         VjPnHc5ArQIxH/6ymyEoYhqDWu7vW8rtd/DMLLBg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Keerthy <j-keerthy@ti.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 08/94] ARM: dts: Fix incorrect dcan register mapping for am3, am4 and dra7
Date:   Wed,  4 Sep 2019 11:56:13 -0400
Message-Id: <20190904155739.2816-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

