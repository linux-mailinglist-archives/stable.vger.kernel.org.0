Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E3B2508F6
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 21:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgHXTQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 15:16:07 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1918 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgHXTQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 15:16:04 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4411b60002>; Mon, 24 Aug 2020 12:15:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 12:16:04 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 24 Aug 2020 12:16:04 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 19:16:03 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 19:16:02 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f4411f10003>; Mon, 24 Aug 2020 12:16:02 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v4 3/7] dt-bindings: mmc: tegra: Add tmclk for Tegra210 and later
Date:   Mon, 24 Aug 2020 12:15:53 -0700
Message-ID: <1598296557-32020-4-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598296557-32020-1-git-send-email-skomatineni@nvidia.com>
References: <1598296557-32020-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598296502; bh=OE2ZQv5nkBHqh7G1yQ3TVwATIhIH4KcXIaI9rgW5qsY=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=D16bILSXWV+Vw+pTBZVXK6e01fI70mu6fuf82XetjEKAoeFCsdHNm58pwaYbNHmn4
         mwZu15DIxofnBDEqdr1QvL82zIRBYNS5DRG8AXbVCQ0gKUX0uiekf3G08DwTRm/zy2
         lCrdo5aDE7xkja8SWOj5Fub/uBVjn70m1WowrvIVceo+IIxHNuYuXr33o80fTY+IIB
         CzDlQQuXVUgC36PPVT6JAUOxrMJedUCxKvRXV176hfGsZyBDcGJIV/XZHGLdNoNJIQ
         fZZgIRvwzE25jfpR1EAWMsLE7wUfaZ/45YQnQSDNMleNr00eD9xtoSRttZe6DLBpWo
         X8XmxxLssKw0w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tegra210 and later uses separate SDMMC_LEGACY_TM clock for data
timeout.

So, this patch adds "tmclk" to Tegra sdhci clock property in the
device tree binding.

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 .../bindings/mmc/nvidia,tegra20-sdhci.txt          | 23 +++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
index 2cf3aff..9603d05 100644
--- a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
+++ b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
@@ -17,6 +17,8 @@ Required properties:
   - "nvidia,tegra194-sdhci": for Tegra194
 - clocks : Must contain one entry, for the module clock.
   See ../clocks/clock-bindings.txt for details.
+  Must also contain "tmclk" entry for Tegra210, Tegra186, and Tegra194.
+  Tegra210 and later uses separate SDMMC_LEGACY_TM clock for data timeout.
 - resets : Must contain an entry for each entry in reset-names.
   See ../reset/reset.txt for details.
 - reset-names : Must include the following entries:
@@ -99,7 +101,7 @@ Optional properties for Tegra210, Tegra186 and Tegra194:
 
 Example:
 sdhci@700b0000 {
-	compatible = "nvidia,tegra210-sdhci", "nvidia,tegra124-sdhci";
+	compatible = "nvidia,tegra124-sdhci";
 	reg = <0x0 0x700b0000 0x0 0x200>;
 	interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
 	clocks = <&tegra_car TEGRA210_CLK_SDMMC1>;
@@ -115,3 +117,22 @@ sdhci@700b0000 {
 	nvidia,pad-autocal-pull-down-offset-1v8 = <0x7b>;
 	status = "disabled";
 };
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
+	pinctrl-0 = <&sdmmc1_3v3>;
+	pinctrl-1 = <&sdmmc1_1v8>;
+	nvidia,pad-autocal-pull-up-offset-3v3 = <0x00>;
+	nvidia,pad-autocal-pull-down-offset-3v3 = <0x7d>;
+	nvidia,pad-autocal-pull-up-offset-1v8 = <0x7b>;
+	nvidia,pad-autocal-pull-down-offset-1v8 = <0x7b>;
+	status = "disabled";
+};
-- 
2.7.4

