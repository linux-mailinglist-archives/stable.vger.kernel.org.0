Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A5415EA0A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392182AbgBNQNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:13:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392178AbgBNQNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0597E246C6;
        Fri, 14 Feb 2020 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696812;
        bh=kI+CkZeBcSHJdIl5v43AfZbVLVXuOHyPO+KdcAjCUpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrZcmtKmGHsAX9RPEBAopjsyW9cvtlKViMgpoiQ005qOlSbfRMy5HGWSCAqravv8K
         iM+lcicaPjsUm0NvgQVa6frZuVamSVDq5LBUbZncAHcrH5q7zblZwHv5fo7bexu+bq
         tFDbKgyJ4VvnQj94pVPvGwuOIOquxeXEoElbKZRI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 082/252] arm: dts: allwinner: H3: Add PMU node
Date:   Fri, 14 Feb 2020 11:08:57 -0500
Message-Id: <20200214161147.15842-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 0388a110747bec0c9d9de995842bb2a03a26aae1 ]

Add the Performance Monitoring Unit (PMU) device tree node to the H3
.dtsi, which tells DT users which interrupts are triggered by PMU
overflow events on each core. The numbers come from the manual and have
been checked in U-Boot and with perf in Linux.

Tested with perf record and taskset on an OrangePi Zero.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-h3.dtsi | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index 9233ba30a857c..11172fbdc03aa 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -80,7 +80,7 @@
 			#cooling-cells = <2>;
 		};
 
-		cpu@1 {
+		cpu1: cpu@1 {
 			compatible = "arm,cortex-a7";
 			device_type = "cpu";
 			reg = <1>;
@@ -90,7 +90,7 @@
 			#cooling-cells = <2>;
 		};
 
-		cpu@2 {
+		cpu2: cpu@2 {
 			compatible = "arm,cortex-a7";
 			device_type = "cpu";
 			reg = <2>;
@@ -100,7 +100,7 @@
 			#cooling-cells = <2>;
 		};
 
-		cpu@3 {
+		cpu3: cpu@3 {
 			compatible = "arm,cortex-a7";
 			device_type = "cpu";
 			reg = <3>;
@@ -111,6 +111,15 @@
 		};
 	};
 
+	pmu {
+		compatible = "arm,cortex-a7-pmu";
+		interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 122 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 123 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-affinity = <&cpu0>, <&cpu1>, <&cpu2>, <&cpu3>;
+	};
+
 	timer {
 		compatible = "arm,armv7-timer";
 		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
-- 
2.20.1

