Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740B123D4B1
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 02:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgHFAdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 20:33:31 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2388 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgHFAcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 20:32:42 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2b4f780000>; Wed, 05 Aug 2020 17:31:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 17:32:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 05 Aug 2020 17:32:42 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 6 Aug
 2020 00:32:39 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 6 Aug 2020 00:32:39 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.172.190]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f2b4fa60000>; Wed, 05 Aug 2020 17:32:38 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v3 2/6] sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra186
Date:   Wed, 5 Aug 2020 17:32:25 -0700
Message-ID: <1596673949-1571-3-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596673949-1571-1-git-send-email-skomatineni@nvidia.com>
References: <1596673949-1571-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596673912; bh=oz8A57gzhp0Azl3sB2boMW8c1eZVUyjxxtqlbUBC15k=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=o6N6qMAreBK2hWApldgN64WdOlmgO2/joGUYRHSdMNdc2bgnNHq6PjKmkETq2wNBe
         ofMmo7XYkq9QNibNUxK0xaHUkaQ8acBz+t7x/mG+BWmbDRAYtiVphXQ48AHPVEh6wH
         HCc1PfEM0b8ACEeyxGt/sqJidTpHlKx6hcjGGJxvNG3vT3okJogoM4pLVLmACh5aCo
         O6tnXGnerR1MAXbFQdL9gFDX8CLfJaeRHUa4SgSyVYahv8HPoj5k1d4z+7I0Dqfhn9
         Uqn6mP8NDVWFBylHdwz9cVUC8BdOnPiZ6+LKGlEyYBxFJRY3i8jTociMjYh6/HE6Iw
         BbS3lpOobLk0w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4346b7c7941d ("mmc: tegra: Add Tegra186 support")

SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK is set for Tegra186 from the
beginning of its support in driver.

Tegra186 SDMMC hardware by default uses timeout clock (TMCLK) instead
of SDCLK and this quirk should not be set.

So, this patch remove this quirk for Tegra186.

Fixes: 4346b7c7941d ("mmc: tegra: Add Tegra186 support")
Cc: stable <stable@vger.kernel.org> # 5.4
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 drivers/mmc/host/sdhci-tegra.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 2be3511..31ed321 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -1455,7 +1455,6 @@ static const struct sdhci_ops tegra186_sdhci_ops = {
 
 static const struct sdhci_pltfm_data sdhci_tegra186_pdata = {
 	.quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
-		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
 		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
 		  SDHCI_QUIRK_NO_HISPD_BIT |
 		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
-- 
2.7.4

