Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2994C942
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 10:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730891AbfFTIST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 04:18:19 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3266 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfFTIST (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 04:18:19 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d0b414b0001>; Thu, 20 Jun 2019 01:18:19 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 20 Jun 2019 01:18:18 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 20 Jun 2019 01:18:18 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 20 Jun
 2019 08:18:18 +0000
Received: from hqnvemgw01.nvidia.com (172.20.150.20) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 20 Jun 2019 08:18:18 +0000
Received: from moonraker.nvidia.com (Not Verified[10.21.132.148]) by hqnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5d0b41480005>; Thu, 20 Jun 2019 01:18:17 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/3] arm64: tegra: Update Jetson TX1 GPU regulator timings
Date:   Thu, 20 Jun 2019 09:17:01 +0100
Message-ID: <20190620081702.17209-3-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620081702.17209-1-jonathanh@nvidia.com>
References: <20190620081702.17209-1-jonathanh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1561018699; bh=pWavaGbgye2Pi/FLNO2W87uDt3CkK2tN/NQb369yLbI=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=JZIyrluGqOYojjp+ukpvJS6N8MYunZyJVS8tBdjtdvQEY/9aapRJtiAHMQCG8sPl9
         Xxwh5zXENvpIoy+2gRsZhMlgxVNxInFwcqiQwdF/Mn35zlnlN3d62PpAyCT6hzuKKM
         /kv9LOb6Yrrt1Bmvox1azyZkO+zfH4JU6bqB8lxeA53q8veT3GynRSisTVxdcyk6EW
         BzPMsN5dWin4yXsO3YmdlYEyrDIyHuLRY3cPlIxDnKmqKztTQylOOD1d0p27ahvVRg
         3T+1P3V7/qCC0zRWvtLJoUlWxLd0wIqnd0J9ofevS+cCs7/YM9FBsPM/dQcEJWmqgq
         GoOulxpYJQ4Lg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The GPU regulator enable ramp delay for Jetson TX1 is set to 1ms which
not sufficient because the enable ramp delay has been measured to be
greater than 1ms. Furthermore, the downstream kernels released by NVIDIA
for Jetson TX1 are using a enable ramp delay 2ms and a settling delay of
160us. Update the GPU regulator enable ramp delay for Jetson TX1 to be
2ms and add a settling delay of 160us.

Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
index e8654061ce03..27723829d033 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
@@ -341,7 +341,8 @@
 			regulator-max-microvolt = <1320000>;
 			enable-gpios = <&pmic 6 GPIO_ACTIVE_HIGH>;
 			regulator-ramp-delay = <80>;
-			regulator-enable-ramp-delay = <1000>;
+			regulator-enable-ramp-delay = <2000>;
+			regulator-settling-time-us = <160>;
 		};
 	};
 };
-- 
2.17.1

