Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4FC25DA2C
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 15:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgIDNmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 09:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730391AbgIDNlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:41:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9941208DB;
        Fri,  4 Sep 2020 13:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226213;
        bh=m9pIERxvWHUgsDqBqgVJI3JMc/1+doudOyGmLox0dOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqzyshBwE96PixGuiiQSTt6PLl3/wdfJ7DUhdOtGeULfbW/9mFHQKLpw+2zRmR+8K
         MlvydhjQzMg98kIOwDtYehzBIUvsREPqBnyWz+GInnLfp4BxJ9QXfbD8HT4z5ZPxxY
         CBp5KKamYJXg1hT4p3s7g8UHG3XSJYSDXQklGAzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 09/16] dt-bindings: mmc: tegra: Add tmclk for Tegra210 and later
Date:   Fri,  4 Sep 2020 15:30:02 +0200
Message-Id: <20200904120257.654794262@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.203708503@linuxfoundation.org>
References: <20200904120257.203708503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

commit f7f86e8ac0ad7cd6792a80137f5a550924966916 upstream.

commit b5a84ecf025a ("mmc: tegra: Add Tegra210 support")

Tegra210 and later uses separate SDMMC_LEGACY_TM clock for data
timeout.

So, this patch adds "tmclk" to Tegra sdhci clock property in the
device tree binding.

Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
Cc: stable <stable@vger.kernel.org> # 5.4
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Link: https://lore.kernel.org/r/1598548861-32373-4-git-send-email-skomatineni@nvidia.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt |   32 +++++++++-
 1 file changed, 29 insertions(+), 3 deletions(-)

--- a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
+++ b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
@@ -15,8 +15,15 @@ Required properties:
   - "nvidia,tegra210-sdhci": for Tegra210
   - "nvidia,tegra186-sdhci": for Tegra186
   - "nvidia,tegra194-sdhci": for Tegra194
-- clocks : Must contain one entry, for the module clock.
-  See ../clocks/clock-bindings.txt for details.
+- clocks: For Tegra210, Tegra186 and Tegra194 must contain two entries.
+	  One for the module clock and one for the timeout clock.
+	  For all other Tegra devices, must contain a single entry for
+	  the module clock. See ../clocks/clock-bindings.txt for details.
+- clock-names: For Tegra210, Tegra186 and Tegra194 must contain the
+	       strings 'sdhci' and 'tmclk' to represent the module and
+	       the timeout clocks, respectively.
+	       For all other Tegra devices must contain the string 'sdhci'
+	       to represent the module clock.
 - resets : Must contain an entry for each entry in reset-names.
   See ../reset/reset.txt for details.
 - reset-names : Must include the following entries:
@@ -99,7 +106,7 @@ Optional properties for Tegra210, Tegra1
 
 Example:
 sdhci@700b0000 {
-	compatible = "nvidia,tegra210-sdhci", "nvidia,tegra124-sdhci";
+	compatible = "nvidia,tegra124-sdhci";
 	reg = <0x0 0x700b0000 0x0 0x200>;
 	interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
 	clocks = <&tegra_car TEGRA210_CLK_SDMMC1>;
@@ -107,6 +114,25 @@ sdhci@700b0000 {
 	resets = <&tegra_car 14>;
 	reset-names = "sdhci";
 	pinctrl-names = "sdmmc-3v3", "sdmmc-1v8";
+	pinctrl-0 = <&sdmmc1_3v3>;
+	pinctrl-1 = <&sdmmc1_1v8>;
+	nvidia,pad-autocal-pull-up-offset-3v3 = <0x00>;
+	nvidia,pad-autocal-pull-down-offset-3v3 = <0x7d>;
+	nvidia,pad-autocal-pull-up-offset-1v8 = <0x7b>;
+	nvidia,pad-autocal-pull-down-offset-1v8 = <0x7b>;
+	status = "disabled";
+};
+
+sdhci@700b0000 {
+	compatible = "nvidia,tegra210-sdhci";
+	reg = <0x0 0x700b0000 0x0 0x200>;
+	interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&tegra_car TEGRA210_CLK_SDMMC1>,
+		 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
+	clock-names = "sdhci", "tmclk";
+	resets = <&tegra_car 14>;
+	reset-names = "sdhci";
+	pinctrl-names = "sdmmc-3v3", "sdmmc-1v8";
 	pinctrl-0 = <&sdmmc1_3v3>;
 	pinctrl-1 = <&sdmmc1_1v8>;
 	nvidia,pad-autocal-pull-up-offset-3v3 = <0x00>;


