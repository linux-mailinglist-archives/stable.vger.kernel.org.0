Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CAB45C1B9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344680AbhKXNVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:21:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349407AbhKXNTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:19:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F39661AF8;
        Wed, 24 Nov 2021 12:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757986;
        bh=Z32u477UJH7+XontE/nTr3QbELnlCVMPfLwiXNz1+DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICxT5nqJJwXjMDVeba0F1CZ3Ox+DQYxcau1IyXFWW4ZAaEc6NyK7JRig8Ry0SbLTT
         y/J+bYsa9eWliBFs3awNxsuDtHOPEZmzKyjedaIpQ+LljSfQ/RRgY9lj00A4m500Kh
         l5UYGA3leb6BaBLFp4yVoRNNk6U6aNjRYI8C10uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/100] ARM: dts: ls1021a: move thermal-zones node out of soc/
Date:   Wed, 24 Nov 2021 12:57:35 +0100
Message-Id: <20211124115655.481347086@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c62fcca7b4263..aeb8a40b6b601 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -311,39 +311,6 @@
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
@@ -984,4 +951,37 @@
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



