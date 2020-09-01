Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725DD259859
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731009AbgIAQZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:25:34 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8869 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731920AbgIAQZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 12:25:24 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4e75720003>; Tue, 01 Sep 2020 09:23:14 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 09:25:21 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 01 Sep 2020 09:25:21 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Sep
 2020 16:25:20 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 1 Sep 2020 16:25:20 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.173.243]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f4e75ef0001>; Tue, 01 Sep 2020 09:25:19 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v2 4.19 6/7] arm64: tegra: Add missing timeout clock to Tegra194 SDMMC nodes
Date:   Tue, 1 Sep 2020 09:24:49 -0700
Message-ID: <1598977490-1826-7-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598977490-1826-1-git-send-email-skomatineni@nvidia.com>
References: <1598977490-1826-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598977394; bh=1uE5SDFRo/ET/OfBMf6H9PUAUO4i0NTqPx+aknVLNUk=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=lQ8LJymCEWcILs6/ixwioLV86rCHhMdGn0uhr+dsLVlrDUtbDs44Gt5gfbOEuzfty
         /4WjrxMQGbJnp8gtiDKBw6WI7t9SFbij0CHZ6EhqCxPE5g2NdlxKhcmotdQSFn2Vom
         kj5NzslgdNYRV25ljyIhAEHUCOGCHMg0FakQCg3WgVfCBE5wvAzYAZ502Jc1c0n2JE
         xy6Glr5niJoQuPVvKKmO1pixxsf3O2k38jOFlFT81LOCVoz9LHQkKwaE4ejsKoqk6v
         0YJ2mdJ72X+p+i+19L6lUKmbDRRWxdnUJRtoTf1jsdqT5LkOv5JEMDj2ht/GOtHimH
         Kuig+JnuXiiEQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tegra194 uses separate SDMMC_LEGACY_TM clock for data timeout and this
clock was not enabled when Tegra194 support was added to the driver in
commit 5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree") which
is not recommended.

Tegra194 SDMMC advertises 12Mhz as timeout clock frequency in host
capability register.

So, this clock should be kept enabled by SDMMC driver.

Fixes: 5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")
Cc: stable <stable@vger.kernel.org> # 4.19
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 9fc14bb..8a319c2 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -213,8 +213,9 @@
 			compatible = "nvidia,tegra194-sdhci", "nvidia,tegra186-sdhci";
 			reg = <0x03400000 0x10000>;
 			interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&bpmp TEGRA194_CLK_SDMMC1>;
-			clock-names = "sdhci";
+			clocks = <&bpmp TEGRA194_CLK_SDMMC1>,
+				 <&bpmp TEGRA194_CLK_SDMMC_LEGACY_TM>;
+			clock-names = "sdhci", "tmclk";
 			resets = <&bpmp TEGRA194_RESET_SDMMC1>;
 			reset-names = "sdhci";
 			status = "disabled";
@@ -224,8 +225,9 @@
 			compatible = "nvidia,tegra194-sdhci", "nvidia,tegra186-sdhci";
 			reg = <0x03440000 0x10000>;
 			interrupts = <GIC_SPI 64 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&bpmp TEGRA194_CLK_SDMMC3>;
-			clock-names = "sdhci";
+			clocks = <&bpmp TEGRA194_CLK_SDMMC3>,
+				 <&bpmp TEGRA194_CLK_SDMMC_LEGACY_TM>;
+			clock-names = "sdhci", "tmclk";
 			resets = <&bpmp TEGRA194_RESET_SDMMC3>;
 			reset-names = "sdhci";
 			status = "disabled";
@@ -235,8 +237,9 @@
 			compatible = "nvidia,tegra194-sdhci", "nvidia,tegra186-sdhci";
 			reg = <0x03460000 0x10000>;
 			interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&bpmp TEGRA194_CLK_SDMMC4>;
-			clock-names = "sdhci";
+			clocks = <&bpmp TEGRA194_CLK_SDMMC4>,
+				 <&bpmp TEGRA194_CLK_SDMMC_LEGACY_TM>;
+			clock-names = "sdhci", "tmclk";
 			resets = <&bpmp TEGRA194_RESET_SDMMC4>;
 			reset-names = "sdhci";
 			status = "disabled";
-- 
2.7.4

