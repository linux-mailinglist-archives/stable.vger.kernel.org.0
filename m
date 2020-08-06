Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2461523D499
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 02:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgHFAcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 20:32:52 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2383 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgHFAcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 20:32:41 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2b4f770001>; Wed, 05 Aug 2020 17:31:51 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 17:32:41 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 05 Aug 2020 17:32:41 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 6 Aug
 2020 00:32:40 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 6 Aug 2020 00:32:40 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.172.190]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f2b4fa70000>; Wed, 05 Aug 2020 17:32:40 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v3 4/6] arm64: tegra: Add missing timeout clock to Tegra186 SDMMC nodes
Date:   Wed, 5 Aug 2020 17:32:27 -0700
Message-ID: <1596673949-1571-5-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596673949-1571-1-git-send-email-skomatineni@nvidia.com>
References: <1596673949-1571-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596673911; bh=+X9L35W65oet6Su95V+9f41+dbj8R6B/rbFJ25TM7zU=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=l04XGdQwW6x/n71zU2bBjmRIRKzof57nFCovoFdyxZnCFI1V2Db64bp/xa+P+QZ8t
         8iPv3zC4IU3UyomW/WD9ClDvukS5dHEJIJ7aJfA3XTy7uQdADoIb5VydREHA6SGoCy
         QEbDB+MI96nkMVa91LaZbz4FZXzwP+lYUPfr4O+W6TgAnnP3+z8RGm8eOkxJjGybjW
         xH35gwHYVRMklnn3OkFDL3p3qUwLIPbyLZux48fiHr88CZRPjX/qcpQorhz76AQ2TS
         RLT4Wh5aew//o/stWtpfOwFf13pT12s/fbjYHOLKYBuTdWV8ug57L6+xKYz3Y0QFiJ
         KY/A1qdY3dopQ==
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

