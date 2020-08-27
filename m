Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915A6254C1F
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 19:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgH0RV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 13:21:26 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12441 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbgH0RVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 13:21:25 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f47eb870000>; Thu, 27 Aug 2020 10:21:11 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Aug 2020 10:21:25 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Aug 2020 10:21:25 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Aug
 2020 17:21:24 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 27 Aug 2020 17:21:24 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f47eb940000>; Thu, 27 Aug 2020 10:21:24 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v7 2/7] sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra186
Date:   Thu, 27 Aug 2020 10:20:56 -0700
Message-ID: <1598548861-32373-3-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598548861-32373-1-git-send-email-skomatineni@nvidia.com>
References: <1598548861-32373-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598548871; bh=mXqaDHZAnjiA2FC3TMHhwQF8i9i1LflPE/o4KLabvD8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=M25K8WSOq2mO9Upcrlb21CYGug2SVFxWxAyIo7imxWincvTQ7AsDcrZ+FG3kweO3G
         1gkVc9JVyfe1jgTf6/zgQcEYXOyu48tjNqbaWo7M2B/JUtGAnM2zptwIwZipeh1waC
         aBJ7q/Le6EXzQDUww67ausdpkwR/FuJLGSIpPUfrkn+Gbqf2TLmK3vTGxd35KaVHid
         J0mE7p0oXIKvQ3BUtRYbU+VRoWHjmbrHATjNKkSzKlox2ohdV1mFDjaquwVIUam+kC
         IWHa6nbPQaWCQ5aFnfYG4cqX2q+Fmk/Qc1zADJokidChfYgiNTYEPMY77dZ+Mb254s
         VQsQpQ5+Lafiw==
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
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
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

