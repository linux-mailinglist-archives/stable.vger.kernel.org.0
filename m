Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D998D5DC68
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfGCCWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727547AbfGCCPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:15:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AD31218A0;
        Wed,  3 Jul 2019 02:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120123;
        bh=x+xiUEjIlDgPOtEAJJ3ptRrqKRICaQTLBuXdh2m9Fco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DA4SeyPvJHaBOLn9MmepAe7E7dKs2jNJRz4SSaAmKvlvrVrkL7yUqLkT2yP0nYkqe
         +M+iDzc8lWVmu5jEYY0X6oRTmSiHeGw6t/XSUC8dK2D5ARI7CXjTF4tO/I4McYPnYf
         b6qlnK9Df+sJgxRF0d3kH/CwlmbKjqr+cKcXOdjQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ran Wang <ran.wang_1@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 08/39] arm64: dts: ls1028a: Fix CPU idle fail.
Date:   Tue,  2 Jul 2019 22:14:43 -0400
Message-Id: <20190703021514.17727-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021514.17727-1-sashal@kernel.org>
References: <20190703021514.17727-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ran Wang <ran.wang_1@nxp.com>

[ Upstream commit 53f2ac9d3aa881ed419054076042898b77c27ee4 ]

PSCI spec define 1st parameter's bit 16 of function CPU_SUSPEND to
indicate CPU State Type: 0 for standby, 1 for power down. In this
case, we want to select standby for CPU idle feature. But current
setting wrongly select power down and cause CPU SUSPEND fail every
time. Need this fix.

Fixes: 8897f3255c9c ("arm64: dts: Add support for NXP LS1028A SoC")
Signed-off-by: Ran Wang <ran.wang_1@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 2896bbcfa3bb..228872549f01 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -28,7 +28,7 @@
 			enable-method = "psci";
 			clocks = <&clockgen 1 0>;
 			next-level-cache = <&l2>;
-			cpu-idle-states = <&CPU_PH20>;
+			cpu-idle-states = <&CPU_PW20>;
 		};
 
 		cpu1: cpu@1 {
@@ -38,7 +38,7 @@
 			enable-method = "psci";
 			clocks = <&clockgen 1 0>;
 			next-level-cache = <&l2>;
-			cpu-idle-states = <&CPU_PH20>;
+			cpu-idle-states = <&CPU_PW20>;
 		};
 
 		l2: l2-cache {
@@ -53,13 +53,13 @@
 		 */
 		entry-method = "arm,psci";
 
-		CPU_PH20: cpu-ph20 {
-			compatible = "arm,idle-state";
-			idle-state-name = "PH20";
-			arm,psci-suspend-param = <0x00010000>;
-			entry-latency-us = <1000>;
-			exit-latency-us = <1000>;
-			min-residency-us = <3000>;
+		CPU_PW20: cpu-pw20 {
+			  compatible = "arm,idle-state";
+			  idle-state-name = "PW20";
+			  arm,psci-suspend-param = <0x0>;
+			  entry-latency-us = <2000>;
+			  exit-latency-us = <2000>;
+			  min-residency-us = <6000>;
 		};
 	};
 
-- 
2.20.1

