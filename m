Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E52253C4B
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 05:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgH0Dud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 23:50:33 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4258 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgH0Dub (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 23:50:31 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f472d0d0003>; Wed, 26 Aug 2020 20:48:30 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 26 Aug 2020 20:50:31 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 26 Aug 2020 20:50:31 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Aug
 2020 03:50:30 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 27 Aug 2020 03:50:29 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f472d850001>; Wed, 26 Aug 2020 20:50:29 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v6 5/7] arm64: tegra: Add missing timeout clock to Tegra186 SDMMC nodes
Date:   Wed, 26 Aug 2020 20:49:59 -0700
Message-ID: <1598500201-5987-6-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598500201-5987-1-git-send-email-skomatineni@nvidia.com>
References: <1598500201-5987-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598500110; bh=uYGyWVuTrlRb0bsFIFzlygN7ungf01Az+VJ6uCd1/Pc=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=hO9cT3ophS3URjNq1uA9MW/O5vtNI/K8bcxT3W0hB289WKgm3+ZEIb/eqc3BGN2dY
         Ppelf6cTXhLz/cJn05wov448EyRj0uUII8fSLZSIFf/vRi4LQjiO+7ZszorrdnRfI7
         LK6EGzfT6yf3skKBhOjJeAqIMzsnx/5C/gUQP6uXLKSJSwI4exjYW5jsRL4S97l4Ko
         jDVBLE2wQ2fonYDIizunfsBhcIuJzFiKumPT4rA/IlL8lYEUAykqqQcoCQ6o/5dDCQ
         Q4R6CRxtD6XOhMTVuqbUG5vAK0nnqk1Q0p+Mu7riR/QjfmW5pMnjKukiYoXRkds6OM
         BJcOSeJ0eu+HQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 39cb62cb8973 ("arm64: tegra: Add Tegra186 support")

Tegra186 uses separate SDMMC_LEGACY_TM clock for data timeout and
this clock is not enabled currently which is not recommended.

Tegra186 SDMMC advertises 12Mhz as timeout clock frequency in host
capability register and uses it by default.

So, this clock should be kept enabled by the SDMMC driver.

Fixes: 39cb62cb8973 ("arm64: tegra: Add Tegra186 support")
Cc: stable <stable@vger.kernel.org> # 5.4
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra186.dtsi | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra186.dtsi b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
index 34d249d..8eb61dd 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -337,8 +337,9 @@
 		compatible = "nvidia,tegra186-sdhci";
 		reg = <0x0 0x03400000 0x0 0x10000>;
 		interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&bpmp TEGRA186_CLK_SDMMC1>;
-		clock-names = "sdhci";
+		clocks = <&bpmp TEGRA186_CLK_SDMMC1>,
+			 <&bpmp TEGRA186_CLK_SDMMC_LEGACY_TM>;
+		clock-names = "sdhci", "tmclk";
 		resets = <&bpmp TEGRA186_RESET_SDMMC1>;
 		reset-names = "sdhci";
 		interconnects = <&mc TEGRA186_MEMORY_CLIENT_SDMMCRA &emc>,
@@ -366,8 +367,9 @@
 		compatible = "nvidia,tegra186-sdhci";
 		reg = <0x0 0x03420000 0x0 0x10000>;
 		interrupts = <GIC_SPI 63 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&bpmp TEGRA186_CLK_SDMMC2>;
-		clock-names = "sdhci";
+		clocks = <&bpmp TEGRA186_CLK_SDMMC2>,
+			 <&bpmp TEGRA186_CLK_SDMMC_LEGACY_TM>;
+		clock-names = "sdhci", "tmclk";
 		resets = <&bpmp TEGRA186_RESET_SDMMC2>;
 		reset-names = "sdhci";
 		interconnects = <&mc TEGRA186_MEMORY_CLIENT_SDMMCRAA &emc>,
@@ -390,8 +392,9 @@
 		compatible = "nvidia,tegra186-sdhci";
 		reg = <0x0 0x03440000 0x0 0x10000>;
 		interrupts = <GIC_SPI 64 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&bpmp TEGRA186_CLK_SDMMC3>;
-		clock-names = "sdhci";
+		clocks = <&bpmp TEGRA186_CLK_SDMMC3>,
+			 <&bpmp TEGRA186_CLK_SDMMC_LEGACY_TM>;
+		clock-names = "sdhci", "tmclk";
 		resets = <&bpmp TEGRA186_RESET_SDMMC3>;
 		reset-names = "sdhci";
 		interconnects = <&mc TEGRA186_MEMORY_CLIENT_SDMMCR &emc>,
@@ -416,8 +419,9 @@
 		compatible = "nvidia,tegra186-sdhci";
 		reg = <0x0 0x03460000 0x0 0x10000>;
 		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&bpmp TEGRA186_CLK_SDMMC4>;
-		clock-names = "sdhci";
+		clocks = <&bpmp TEGRA186_CLK_SDMMC4>,
+			 <&bpmp TEGRA186_CLK_SDMMC_LEGACY_TM>;
+		clock-names = "sdhci", "tmclk";
 		assigned-clocks = <&bpmp TEGRA186_CLK_SDMMC4>,
 				  <&bpmp TEGRA186_CLK_PLLC4_VCO>;
 		assigned-clock-parents = <&bpmp TEGRA186_CLK_PLLC4_VCO>;
-- 
2.7.4

