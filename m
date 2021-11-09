Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092DC44B5E5
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343754AbhKIWXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:23:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343987AbhKIWWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFBBB61248;
        Tue,  9 Nov 2021 22:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496303;
        bh=4SocQtq8qZg7rNVIqVpPuI7ulAJS4JvkpVTR/mszbKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbXPYzgg/w1nMyHJwmUYMRpq3NXdhZnSHRnypNspFQBrbFY+dl1Nh31lJWdr2GwhI
         f75IWVM3Y/4TsQ79sfH5p2uLi6euJGlMLawlnRLgN8fjjPT8OfYQeFSMHJrtErO9Ib
         JAApikEFoE9mW6Kz4FQMQsfD2CpixlpCLvVGLVXnEgZUr19gBlvX1/mOAGHegI6mxZ
         hNIZktvx7brFj/2/d29H0rbv64H2xjuWbWBiPu0bz8YJMkylIbHBUNYbneLGQZ4e0C
         VoJpVUhiJqAQ1rkwgHZk/v3wnaZo8dPHwxkgwJU5gAi8/mHp/YB2kjMunZIDfej3K2
         uAnyMsAwf/g2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 56/82] ARM: dts: ls1021a: move thermal-zones node out of soc/
Date:   Tue,  9 Nov 2021 17:16:14 -0500
Message-Id: <20211109221641.1233217-56-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Yang <leoyang.li@nxp.com>

[ Upstream commit 1ee1500ef717eefb5d9bdaf97905cb81b4e69aa4 ]

This fixes dtbs-check error from simple-bus schema:
soc: thermal-zones: {'type': 'object'} is not allowed for {'cpu-thermal': ..... }
        From schema: /home/leo/.local/lib/python3.8/site-packages/dtschema/schemas/simple-bus.yaml

Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ls1021a.dtsi | 66 +++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/arm/boot/dts/ls1021a.dtsi b/arch/arm/boot/dts/ls1021a.dtsi
index 4fce81422943b..f3b8540750b61 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -329,39 +329,6 @@
 			#thermal-sensor-cells = <1>;
 		};
 
-		thermal-zones {
-			cpu_thermal: cpu-thermal {
-				polling-delay-passive = <1000>;
-				polling-delay = <5000>;
-
-				thermal-sensors = <&tmu 0>;
-
-				trips {
-					cpu_alert: cpu-alert {
-						temperature = <85000>;
-						hysteresis = <2000>;
-						type = "passive";
-					};
-					cpu_crit: cpu-crit {
-						temperature = <95000>;
-						hysteresis = <2000>;
-						type = "critical";
-					};
-				};
-
-				cooling-maps {
-					map0 {
-						trip = <&cpu_alert>;
-						cooling-device =
-							<&cpu0 THERMAL_NO_LIMIT
-							THERMAL_NO_LIMIT>,
-							<&cpu1 THERMAL_NO_LIMIT
-							THERMAL_NO_LIMIT>;
-					};
-				};
-			};
-		};
-
 		dspi0: spi@2100000 {
 			compatible = "fsl,ls1021a-v1.0-dspi";
 			#address-cells = <1>;
@@ -1016,4 +983,37 @@
 			big-endian;
 		};
 	};
+
+	thermal-zones {
+		cpu_thermal: cpu-thermal {
+			polling-delay-passive = <1000>;
+			polling-delay = <5000>;
+
+			thermal-sensors = <&tmu 0>;
+
+			trips {
+				cpu_alert: cpu-alert {
+					temperature = <85000>;
+					hysteresis = <2000>;
+					type = "passive";
+				};
+				cpu_crit: cpu-crit {
+					temperature = <95000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
+
+			cooling-maps {
+				map0 {
+					trip = <&cpu_alert>;
+					cooling-device =
+						<&cpu0 THERMAL_NO_LIMIT
+						THERMAL_NO_LIMIT>,
+						<&cpu1 THERMAL_NO_LIMIT
+						THERMAL_NO_LIMIT>;
+				};
+			};
+		};
+	};
 };
-- 
2.33.0

