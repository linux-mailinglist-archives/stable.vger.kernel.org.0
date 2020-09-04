Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6159C25DB91
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 16:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbgIDO0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 10:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730460AbgIDNeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:34:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FBAE20E65;
        Fri,  4 Sep 2020 13:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226248;
        bh=OyJPEEMtX0OZO8ZGe/PWQVztakgqVmr0EUsWqA/IVP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0mX0EnUxL4GumD+/nMnqWtduGR4TTth3msZQoO5LsQ800Y84TZOvDfWJNJwk3KGe
         jT+4I8S2pU0rAsrxt6myVXi6Elz+A4Woym2U5HS1IZYAl9MobRA14Qxl2L3r7E9BFK
         OqZPmTGa3GeJWaaqXpc6XUVbQpDTkoAR/7WwB5Kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.8 11/17] arm64: tegra: Add missing timeout clock to Tegra194 SDMMC nodes
Date:   Fri,  4 Sep 2020 15:30:10 +0200
Message-Id: <20200904120258.543409905@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.983551609@linuxfoundation.org>
References: <20200904120257.983551609@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

commit c956c0cd4f6f4aac4f095621b1c4e1c5ee1df877 upstream.

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
Link: https://lore.kernel.org/r/1598548861-32373-7-git-send-email-skomatineni@nvidia.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -453,8 +453,9 @@
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
 			nvidia,pad-autocal-pull-up-offset-3v3-timeout =
@@ -475,8 +476,9 @@
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
 			nvidia,pad-autocal-pull-up-offset-1v8 = <0x00>;
@@ -498,8 +500,9 @@
 			compatible = "nvidia,tegra194-sdhci", "nvidia,tegra186-sdhci";
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


