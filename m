Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6F0250909
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 21:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgHXTQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 15:16:23 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1924 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgHXTQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 15:16:06 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4411b80000>; Mon, 24 Aug 2020 12:15:04 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 12:16:06 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 24 Aug 2020 12:16:06 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 19:16:05 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 19:16:04 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f4411f40000>; Mon, 24 Aug 2020 12:16:04 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v4 6/7] arm64: tegra: Add missing timeout clock to Tegra194 SDMMC nodes
Date:   Mon, 24 Aug 2020 12:15:56 -0700
Message-ID: <1598296557-32020-7-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598296557-32020-1-git-send-email-skomatineni@nvidia.com>
References: <1598296557-32020-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598296504; bh=mAvMY8UFkvIoiC2Q/WfFkGUp3FgHP5BU81gQ8cOzMZI=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=rU3huQRKK+hnyKqQhpO9wyjrXuUSItEgHb9rpfwV5oc85jf23T00oUVKheL+CrB4N
         XTBWU021L7Ft06YP58h4LDBLoScVyGvjbo5irEdGEDxpn2iEP3B/ZLFcTcTv7sI1YN
         7iynhOGyxujaHfoiGreG20WY77q9DBLLamMDbiVIxXIfYpqdZmoT9CR4JWb1ydQn+C
         vVItDzDVIn5WVY1PSRpyeeETvYW4jcCpkz7u8yfYzPk+6214yaE+4LcXucfFNkNUdD
         qfq1UxZC+EJxLvWqsW9D80DPX4QJJm1NoZgMXxZJNXn74yLZLqTnTinimvo5rmClIU
         uNCDvKgmu+wQg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")

Tegra194 uses separate SDMMC_LEGACY_TM clock for data timeout and
this clock is not enabled currently which is not recommended.

Tegra194 SDMMC advertises 12Mhz as timeout clock frequency in host
capability register.

So, this clock should be kept enabled by SDMMC driver.

Fixes: 5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")
Cc: stable <stable@vger.kernel.org> # 5.4
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 48160f4..ca5cb6a 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -460,8 +460,9 @@
 			compatible = "nvidia,tegra194-sdhci";
 			reg = <0x03400000 0x10000>;
 			interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&bpmp TEGRA194_CLK_SDMMC1>;
-			clock-names = "sdhci";
+			clocks = <&bpmp TEGRA194_CLK_SDMMC1>,
+				 <&bpmp TEGRA194_CLK_SDMMC_LEGACY_TM>;
+			clock-names = "sdhci", "tmclk";
 			resets = <&bpmp TEGRA194_RESET_SDMMC1>;
 			reset-names = "sdhci";
 			interconnects = <&mc TEGRA194_MEMORY_CLIENT_SDMMCRA &emc>,
@@ -485,8 +486,9 @@
 			compatible = "nvidia,tegra194-sdhci";
 			reg = <0x03440000 0x10000>;
 			interrupts = <GIC_SPI 64 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&bpmp TEGRA194_CLK_SDMMC3>;
-			clock-names = "sdhci";
+			clocks = <&bpmp TEGRA194_CLK_SDMMC3>,
+				 <&bpmp TEGRA194_CLK_SDMMC_LEGACY_TM>;
+			clock-names = "sdhci", "tmclk";
 			resets = <&bpmp TEGRA194_RESET_SDMMC3>;
 			reset-names = "sdhci";
 			interconnects = <&mc TEGRA194_MEMORY_CLIENT_SDMMCR &emc>,
@@ -511,8 +513,9 @@
 			compatible = "nvidia,tegra194-sdhci";
 			reg = <0x03460000 0x10000>;
 			interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&bpmp TEGRA194_CLK_SDMMC4>;
-			clock-names = "sdhci";
+			clocks = <&bpmp TEGRA194_CLK_SDMMC4>,
+				 <&bpmp TEGRA194_CLK_SDMMC_LEGACY_TM>;
+			clock-names = "sdhci", "tmclk";
 			assigned-clocks = <&bpmp TEGRA194_CLK_SDMMC4>,
 					  <&bpmp TEGRA194_CLK_PLLC4>;
 			assigned-clock-parents =
-- 
2.7.4

