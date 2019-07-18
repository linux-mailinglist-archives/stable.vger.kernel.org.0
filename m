Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408FF6C53B
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389610AbfGRDEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:04:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389593AbfGRDED (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:04:03 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC2C621880;
        Thu, 18 Jul 2019 03:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419042;
        bh=368xgV5chnlIR6TMjaRLKtO91K1HD/zbeVNzTu8LWMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbSDAFGeD2CbzZ2W9maTwMb9/Tpo9shA05XcprhHPlQl6y9R+uLcrK7qyWTBgZ9zH
         /3hlNx3miaxRQULRURfe5zH1n5MgSBK/zS2VZkfjCrxRWDNZ0LbWYvSDzVXWDp6R05
         iYYdQLoEgRDz3J8t2onsQvMGWyDIY5zynTJsJ2b8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ran Wang <ran.wang_1@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 13/54] arm64: dts: ls1028a: Fix CPU idle fail.
Date:   Thu, 18 Jul 2019 12:01:08 +0900
Message-Id: <20190718030054.411412190@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



