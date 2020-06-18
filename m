Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92E91FDB32
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgFRBKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbgFRBKl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 588E921924;
        Thu, 18 Jun 2020 01:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442640;
        bh=PAdD7kghUO96P8C/+xHGK6WZnHxci/xvKvwN8bHF4cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLc5w3+yDpQAL+KGPxE7ggQNKTgObHywR4xeebhOMC8hhaZirFwG0wadLuvVxaDYc
         M1Gza333BkZQuEmwXcR6rlTtqKAichzRaQ11yIbiJoTjlKA1bj92iINELPuYX5+g4O
         zuNq9icmvcQSpNjciUoz6XlpA/oQZ6AYSbOMQOdk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-realtek-soc@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 115/388] arm64: dts: realtek: rtd129x: Fix GIC CPU masks for RTD1293
Date:   Wed, 17 Jun 2020 21:03:32 -0400
Message-Id: <20200618010805.600873-115-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Färber <afaerber@suse.de>

[ Upstream commit 31888c8be1486daf2c34ba6c58129635e49d564a ]

Convert from GIC_CPU_MASK_RAW() to GIC_CPU_MASK_SIMPLE().

In case of RTD1293 adjust the arch timer and VGIC interrupts'
CPU masks to its smaller number of CPUs.

Fixes: cf976f660ee8 ("arm64: dts: realtek: Add RTD1293 and Synology DS418j")
Signed-off-by: Andreas Färber <afaerber@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/realtek/rtd1293.dtsi | 12 ++++++++----
 arch/arm64/boot/dts/realtek/rtd1295.dtsi |  8 ++++----
 arch/arm64/boot/dts/realtek/rtd1296.dtsi |  8 ++++----
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/realtek/rtd1293.dtsi b/arch/arm64/boot/dts/realtek/rtd1293.dtsi
index bd4e22723f7b..2d92b56ac94d 100644
--- a/arch/arm64/boot/dts/realtek/rtd1293.dtsi
+++ b/arch/arm64/boot/dts/realtek/rtd1293.dtsi
@@ -36,16 +36,20 @@ l2: l2-cache {
 	timer {
 		compatible = "arm,armv8-timer";
 		interrupts = <GIC_PPI 13
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>,
+			(GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 14
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>,
+			(GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>,
+			(GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>;
+			(GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>;
 	};
 };
 
 &arm_pmu {
 	interrupt-affinity = <&cpu0>, <&cpu1>;
 };
+
+&gic {
+	interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>;
+};
diff --git a/arch/arm64/boot/dts/realtek/rtd1295.dtsi b/arch/arm64/boot/dts/realtek/rtd1295.dtsi
index 93f0e1d97721..34f6cc6f16fe 100644
--- a/arch/arm64/boot/dts/realtek/rtd1295.dtsi
+++ b/arch/arm64/boot/dts/realtek/rtd1295.dtsi
@@ -61,13 +61,13 @@ tee@10100000 {
 	timer {
 		compatible = "arm,armv8-timer";
 		interrupts = <GIC_PPI 13
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>,
+			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 14
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>,
+			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>,
+			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>;
+			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/realtek/rtd1296.dtsi b/arch/arm64/boot/dts/realtek/rtd1296.dtsi
index 0f9e59cac086..fb864a139c97 100644
--- a/arch/arm64/boot/dts/realtek/rtd1296.dtsi
+++ b/arch/arm64/boot/dts/realtek/rtd1296.dtsi
@@ -50,13 +50,13 @@ l2: l2-cache {
 	timer {
 		compatible = "arm,armv8-timer";
 		interrupts = <GIC_PPI 13
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>,
+			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 14
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>,
+			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>,
+			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10
-			(GIC_CPU_MASK_RAW(0xf) | IRQ_TYPE_LEVEL_LOW)>;
+			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
 	};
 };
 
-- 
2.25.1

