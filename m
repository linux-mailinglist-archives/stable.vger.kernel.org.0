Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D8B2538C3
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 22:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgHZUFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 16:05:45 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8661 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgHZUFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 16:05:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f46c0510002>; Wed, 26 Aug 2020 13:04:34 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 26 Aug 2020 13:05:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 26 Aug 2020 13:05:36 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Aug
 2020 20:05:35 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 26 Aug 2020 20:05:34 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f46c08e0001>; Wed, 26 Aug 2020 13:05:34 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v5 4/7] arm64: tegra: Add missing timeout clock to Tegra210 SDMMC
Date:   Wed, 26 Aug 2020 13:05:11 -0700
Message-ID: <1598472314-30235-5-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598472314-30235-1-git-send-email-skomatineni@nvidia.com>
References: <1598472314-30235-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598472274; bh=4GhYufSucM1C4nPDlw6YKVKJdfsjgV4P7NbU6PXtfnc=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=k8Q3/P1B+wQOv5tcGCVSlr1DQ185dNcVXLv4OUpIYx+v9jEpaHurtqSf3nqQ+DgDS
         9HPQDcNrYv191nhqTrVMzyfKGG2n1kNTbXrvQxGh6K06imO6rVLlV/PSiwR0WMA3dI
         R0RgEIIkEvRgF/A3wf3ZCMPECy7A7Yfwhic9JqtVNrWNc/6BWuAgfda4Lb3VpM2h0v
         b+03SlKOvqp/+SkkQNCOOA/L11Ho509mhZck5wLQ3mPJ2KCOpTiaZl6FPw2rb9+stW
         qrv9sp0/2LJUvx/3fgPy16F5h8lb9xnlKy0aZ2MnC4AOObfJoIlMreMJRaK+Yw8nb9
         8tcbrHBIjkd7w==
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
Cc: stable <stable@vger.kernel.org> # 5.4
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra210.dtsi | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210.dtsi b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
index 829f786..8cca216 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -1194,8 +1194,9 @@
 		compatible = "nvidia,tegra210-sdhci";
 		reg = <0x0 0x700b0000 0x0 0x200>;
 		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car TEGRA210_CLK_SDMMC1>;
-		clock-names = "sdhci";
+		clocks = <&tegra_car TEGRA210_CLK_SDMMC1>,
+			 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
+		clock-names = "sdhci", "tmclk";
 		resets = <&tegra_car 14>;
 		reset-names = "sdhci";
 		pinctrl-names = "sdmmc-3v3", "sdmmc-1v8",
@@ -1222,8 +1223,9 @@
 		compatible = "nvidia,tegra210-sdhci";
 		reg = <0x0 0x700b0200 0x0 0x200>;
 		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car TEGRA210_CLK_SDMMC2>;
-		clock-names = "sdhci";
+		clocks = <&tegra_car TEGRA210_CLK_SDMMC2>,
+			 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
+		clock-names = "sdhci", "tmclk";
 		resets = <&tegra_car 9>;
 		reset-names = "sdhci";
 		pinctrl-names = "sdmmc-1v8-drv";
@@ -1239,8 +1241,9 @@
 		compatible = "nvidia,tegra210-sdhci";
 		reg = <0x0 0x700b0400 0x0 0x200>;
 		interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car TEGRA210_CLK_SDMMC3>;
-		clock-names = "sdhci";
+		clocks = <&tegra_car TEGRA210_CLK_SDMMC3>,
+			 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
+		clock-names = "sdhci", "tmclk";
 		resets = <&tegra_car 69>;
 		reset-names = "sdhci";
 		pinctrl-names = "sdmmc-3v3", "sdmmc-1v8",
@@ -1262,8 +1265,9 @@
 		compatible = "nvidia,tegra210-sdhci";
 		reg = <0x0 0x700b0600 0x0 0x200>;
 		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car TEGRA210_CLK_SDMMC4>;
-		clock-names = "sdhci";
+		clocks = <&tegra_car TEGRA210_CLK_SDMMC4>,
+			 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
+		clock-names = "sdhci", "tmclk";
 		resets = <&tegra_car 15>;
 		reset-names = "sdhci";
 		pinctrl-names = "sdmmc-3v3-drv", "sdmmc-1v8-drv";
-- 
2.7.4

