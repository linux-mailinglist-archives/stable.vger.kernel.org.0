Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAA740E7C7
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344723AbhIPRgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353447AbhIPRdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E59F63223;
        Thu, 16 Sep 2021 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810898;
        bh=V/R0gN+i0MHEYolSOZeJFTGWHbbe7nMpSoRfbptweFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TF+jiYAy0JG9qhVyIUXGPNNA3y6FsTa5HiICRuy50EN/d1inbJ7YPppKHI8jgsDC2
         odxpIc/dXXHToDfB3qbnnP5FHunZo4JTd/NtwHO0ixE0pvy6X7D44XhBkavdvzTgpI
         w7rPy1WiJqe8LVmBYCZ8hbkCpGD8jw/wYVHGUROc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 301/432] arm64: dts: imx8mm-venice-gw700x: fix mp5416 pmic config
Date:   Thu, 16 Sep 2021 18:00:50 +0200
Message-Id: <20210916155821.025868052@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 092cd75e527044050ea76bf774e7d730709b7e8b ]

Fix various MP5416 PMIC configurations:
 - Update regulator names per dt-bindings
 - ensure values fit among valid register values
 - add required regulator-max-microamp property
 - add regulator-always-on prop

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/freescale/imx8mm-venice-gw700x.dtsi   | 56 ++++++++++++-------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
index c769fadbd008..11dda79cc46b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
@@ -283,65 +283,83 @@ pmic@69 {
 		reg = <0x69>;
 
 		regulators {
+			/* vdd_0p95: DRAM/GPU/VPU */
 			buck1 {
-				regulator-name = "vdd_0p95";
-				regulator-min-microvolt = <805000>;
+				regulator-name = "buck1";
+				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <1000000>;
-				regulator-max-microamp = <2500000>;
+				regulator-min-microamp  = <3800000>;
+				regulator-max-microamp  = <6800000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* vdd_soc */
 			buck2 {
-				regulator-name = "vdd_soc";
-				regulator-min-microvolt = <805000>;
+				regulator-name = "buck2";
+				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <900000>;
-				regulator-max-microamp = <1000000>;
+				regulator-min-microamp  = <2200000>;
+				regulator-max-microamp  = <5200000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* vdd_arm */
 			buck3_reg: buck3 {
-				regulator-name = "vdd_arm";
-				regulator-min-microvolt = <805000>;
+				regulator-name = "buck3";
+				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <1000000>;
-				regulator-max-microamp = <2200000>;
-				regulator-boot-on;
+				regulator-min-microamp  = <3800000>;
+				regulator-max-microamp  = <6800000>;
+				regulator-always-on;
 			};
 
+			/* vdd_1p8 */
 			buck4 {
-				regulator-name = "vdd_1p8";
+				regulator-name = "buck4";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
-				regulator-max-microamp = <500000>;
+				regulator-min-microamp  = <2200000>;
+				regulator-max-microamp  = <5200000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* nvcc_snvs_1p8 */
 			ldo1 {
-				regulator-name = "nvcc_snvs_1p8";
+				regulator-name = "ldo1";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
-				regulator-max-microamp = <300000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* vdd_snvs_0p8 */
 			ldo2 {
-				regulator-name = "vdd_snvs_0p8";
+				regulator-name = "ldo2";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <800000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* vdd_0p9 */
 			ldo3 {
-				regulator-name = "vdd_0p95";
-				regulator-min-microvolt = <800000>;
-				regulator-max-microvolt = <800000>;
+				regulator-name = "ldo3";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <900000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* vdd_1p8 */
 			ldo4 {
-				regulator-name = "vdd_1p8";
+				regulator-name = "ldo4";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 		};
 	};
-- 
2.30.2



