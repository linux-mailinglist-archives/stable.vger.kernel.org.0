Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C86364C944
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 10:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbfFTISV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 04:18:21 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11525 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfFTISV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 04:18:21 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d0b414b0000>; Thu, 20 Jun 2019 01:18:19 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 20 Jun 2019 01:18:20 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 20 Jun 2019 01:18:20 -0700
Received: from HQMAIL104.nvidia.com (172.18.146.11) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 20 Jun
 2019 08:18:19 +0000
Received: from hqnvemgw01.nvidia.com (172.20.150.20) by HQMAIL104.nvidia.com
 (172.18.146.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 20 Jun 2019 08:18:19 +0000
Received: from moonraker.nvidia.com (Not Verified[10.21.132.148]) by hqnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5d0b414a0002>; Thu, 20 Jun 2019 01:18:19 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH 3/3] arm64: tegra: Fix Jetson Nano GPU regulator
Date:   Thu, 20 Jun 2019 09:17:02 +0100
Message-ID: <20190620081702.17209-4-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620081702.17209-1-jonathanh@nvidia.com>
References: <20190620081702.17209-1-jonathanh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1561018699; bh=4BwHSOEWA4xYe11LAIREqHwR6axdZ3eGywYYy70TgW8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=dO+pB5Vrs3cuDGLZqJ7Ruu7nqJsI3Dj87xL3W4JQ/bejWWxHemt12lK/Jnd41uihN
         T1cDI5B6OzTT63Zbl125ecsHEXI6k9vKJRaclNzkRJRNdxUZCqwldoOzqeR8MBhRNc
         FFDCRxvS3Uv0cKoXvSufbZRTgCjyQ9lUDSzPfg4y40odu7iCOw4dM0iadYnyuqUSp7
         JNPHqE2WK26kMscAsCgPWDWkFYvlVonNijQVAGKBf08TWF1psufYwfkslC2A0qQ6ps
         Dh0VjQw/iag/Hx7ZUeGaECr9IRaKudQZTj6JsZ9+RsH3Q4qEtdeRGQjoZVKUmqM5Av
         sE8OqSKZS1BwQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are a few issues with the GPU regulator defined for Jetson Nano
which are:

1. The GPU regulator is a PWM based regulator and not a fixed voltage
   regulator.
2. The output voltages for the GPU regulator are not correct.
3. The regulator enable ramp delay is too short for the regulator and
   needs to be increased. 2ms should be sufficient.
4. This is the same regulator used on Jetson TX1 and so make the ramp
   delay and settling time the same as Jetson TX1.

Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 .../boot/dts/nvidia/tegra210-p3450-0000.dts   | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts b/arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts
index 63df72eecf21..9d17ec707bce 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts
@@ -88,6 +88,10 @@
 		status = "okay";
 	};
 
+	pwm@7000a000 {
+		status = "okay";
+	};
+
 	i2c@7000c500 {
 		status = "okay";
 		clock-frequency = <100000>;
@@ -664,17 +668,16 @@
 		};
 
 		vdd_gpu: regulator@6 {
-			compatible = "regulator-fixed";
+			compatible = "pwm-regulator";
 			reg = <6>;
-
+			pwms = <&pwm 1 4880>;
 			regulator-name = "VDD_GPU";
-			regulator-min-microvolt = <5000000>;
-			regulator-max-microvolt = <5000000>;
-			regulator-enable-ramp-delay = <250>;
-
-			gpio = <&pmic 6 GPIO_ACTIVE_HIGH>;
-			enable-active-high;
-
+			regulator-min-microvolt = <710000>;
+			regulator-max-microvolt = <1320000>;
+			regulator-ramp-delay = <80>;
+			regulator-enable-ramp-delay = <2000>;
+			regulator-settling-time-us = <160>;
+			enable-gpios = <&pmic 6 GPIO_ACTIVE_HIGH>;
 			vin-supply = <&vdd_5v0_sys>;
 		};
 	};
-- 
2.17.1

