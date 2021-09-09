Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AF2404F5A
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350987AbhIIMSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352899AbhIIMPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:15:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7B56611C7;
        Thu,  9 Sep 2021 11:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188170;
        bh=V/R0gN+i0MHEYolSOZeJFTGWHbbe7nMpSoRfbptweFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gx+XkR6xeFczvzLOb1p1XoI4FNJRxbFk27z71seQKdSvqzhKMDefx6bphpmqFKMOq
         RgEmtl/t1xtpDxaj/Lf+YJyUls4K9RuwOtBlvx3xVY8ntbykgvtPAvksYHPHrEGdWA
         yei6L1tCp6GlA7JEsi0jTM0T3m+Pq2DihwnmUuSFsnnFuIoeJGqzbE5dO+ShtoZce9
         JM0Gt+FvtrMNha9kAI8RCKqoayX43D5ZaBNXJmX7MZsMXCwewYjtJ61ATLjEw7FGOq
         o1qCwknLub7I7qGYIv0eJiM6v0+y/OaHjKWHko6K3ykehJOtcD3p5o3Uo39W9v5LP4
         GBb8AX0BgcT2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 135/219] arm64: dts: imx8mm-venice-gw700x: fix mp5416 pmic config
Date:   Thu,  9 Sep 2021 07:45:11 -0400
Message-Id: <20210909114635.143983-135-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

