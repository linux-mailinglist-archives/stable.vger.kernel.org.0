Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B717259861
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732024AbgIAQZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:25:33 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8863 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731358AbgIAQZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 12:25:24 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4e75720001>; Tue, 01 Sep 2020 09:23:14 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 09:25:21 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 01 Sep 2020 09:25:21 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Sep
 2020 16:25:18 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 1 Sep 2020 16:25:18 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.173.243]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f4e75ed0000>; Tue, 01 Sep 2020 09:25:17 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v2 4.19 4/7] arm64: tegra: Add missing timeout clock to Tegra210 SDMMC
Date:   Tue, 1 Sep 2020 09:24:47 -0700
Message-ID: <1598977490-1826-5-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598977490-1826-1-git-send-email-skomatineni@nvidia.com>
References: <1598977490-1826-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598977394; bh=8EhT8HA9s+b3JAvccgWQBH1ITqNJkZPBpbsJDe8BYwU=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=MZLsAUmd/pKlupfNnOdrBylcTC3KYzQlfLDhg6/qBzupR0Si1vGql+thlJPcf8vXb
         LQ772UnGITqFztoPjrid0mFYqLOEB1ymLUdpCUOKlD4QelRedGQrBjyIj0d1pAOP4l
         eR39IPicMk2AMQ1jVjvYfyqKdWkJuN7sqe/rJM07ZIFSxP+MUGCWSrmm5TH9djFcPb
         tZ7bnierzuCuB+z37o+WXt0KYAZdikK85fiaSua5gfAeXQAdr20PQ2/HHMNUXd2saL
         bT9h4eaM6ccsMxhGMhOWX/Qc1/9jEbc/1vYOBEMyFIPRNlj7Yf4uZYPEzeZrT5+ncf
         HtBdPzyc2Ahwg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tegra210 uses separate SDMMC_LEGACY_TM clock for data timeout and this
clock was not enabled when Tegra210 support was added to the driver in
commit 742af7e7a0a1 ("arm64: tegra: Add Tegra210 support") which is not
recommended.

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

