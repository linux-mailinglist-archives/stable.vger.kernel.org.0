Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0CD256305
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 00:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgH1W0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 18:26:12 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4826 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgH1WZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 18:25:57 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4983f90000>; Fri, 28 Aug 2020 15:23:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 28 Aug 2020 15:25:56 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 28 Aug 2020 15:25:56 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 28 Aug
 2020 22:25:51 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 28 Aug 2020 22:25:51 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f49846e0002>; Fri, 28 Aug 2020 15:25:50 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH 4.19 4/7] arm64: tegra: Add missing timeout clock to Tegra210 SDMMC
Date:   Fri, 28 Aug 2020 15:25:14 -0700
Message-ID: <1598653517-13658-5-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598653517-13658-1-git-send-email-skomatineni@nvidia.com>
References: <1598653517-13658-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598653433; bh=1OXJ+c8/lWDuHO0/vsrjng+eqTuoCWFXnUTYobDhqk8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=XVJY152qHjYvn/TPvRe7StPK1hkFenPA3TbaAFQKBkfin1obXrgdmTKlLI/ze5hn3
         n1B0R4casNqzsohvM+lAjhysLOzbvTDS/Jrgf3xs1Yvn/Ht3O/GzIohIz1yCM1hwyD
         UDFcmw8lZjnh+FWdeFJPo/zBQLA5+XkUkLKehmbgnJLcBKkPA9R+25hk5XJgPrBD2h
         yPR8rvPbiPobtJd3nKTzT4WEu71sJwOKc0hRTpsMkPNdRPdplbR4yzsCv9jXJgsdnL
         yZPWtxflwluHqqwQ7NMcJL3ISIqX2yPF/tlQNuWFErWYy1Scc47v0OAlTEAQnsuhhG
         n7zqA/NGuO49Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 742af7e7a0a1 ("arm64: tegra: Add Tegra210 support")

Tegra210 uses separate SDMMC_LEGACY_TM clock for data timeout and
this clock is not enabled currently which is not recommended.

Tegra SDMMC advertises 12Mhz as timeout clock frequency in host
capability register.

So, this clock should be kept enabled by SDMMC driver.

Fixes: 742af7e7a0a1 ("arm64: tegra: Add Tegra210 support")
Cc: stable <stable@vger.kernel.org> # 4.19
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra210.dtsi | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210.dtsi b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
index 6597c08..64a0cb5 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -1020,44 +1020,48 @@
 	};
 
 	sdhci@700b0000 {
-		compatible = "nvidia,tegra210-sdhci", "nvidia,tegra124-sdhci";
+		compatible = "nvidia,tegra210-sdhci";
 		reg = <0x0 0x700b0000 0x0 0x200>;
 		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car TEGRA210_CLK_SDMMC1>;
-		clock-names = "sdhci";
+		clocks = <&tegra_car TEGRA210_CLK_SDMMC1>,
+			 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
+		clock-names = "sdhci", "tmclk";
 		resets = <&tegra_car 14>;
 		reset-names = "sdhci";
 		status = "disabled";
 	};
 
 	sdhci@700b0200 {
-		compatible = "nvidia,tegra210-sdhci", "nvidia,tegra124-sdhci";
+		compatible = "nvidia,tegra210-sdhci";
 		reg = <0x0 0x700b0200 0x0 0x200>;
 		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car TEGRA210_CLK_SDMMC2>;
-		clock-names = "sdhci";
+		clocks = <&tegra_car TEGRA210_CLK_SDMMC2>,
+			 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
+		clock-names = "sdhci", "tmclk";
 		resets = <&tegra_car 9>;
 		reset-names = "sdhci";
 		status = "disabled";
 	};
 
 	sdhci@700b0400 {
-		compatible = "nvidia,tegra210-sdhci", "nvidia,tegra124-sdhci";
+		compatible = "nvidia,tegra210-sdhci";
 		reg = <0x0 0x700b0400 0x0 0x200>;
 		interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car TEGRA210_CLK_SDMMC3>;
-		clock-names = "sdhci";
+		clocks = <&tegra_car TEGRA210_CLK_SDMMC3>,
+			 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
+		clock-names = "sdhci", "tmclk";
 		resets = <&tegra_car 69>;
 		reset-names = "sdhci";
 		status = "disabled";
 	};
 
 	sdhci@700b0600 {
-		compatible = "nvidia,tegra210-sdhci", "nvidia,tegra124-sdhci";
+		compatible = "nvidia,tegra210-sdhci";
 		reg = <0x0 0x700b0600 0x0 0x200>;
 		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car TEGRA210_CLK_SDMMC4>;
-		clock-names = "sdhci";
+		clocks = <&tegra_car TEGRA210_CLK_SDMMC4>,
+			 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
+		clock-names = "sdhci", "tmclk";
 		resets = <&tegra_car 15>;
 		reset-names = "sdhci";
 		status = "disabled";
-- 
2.7.4

