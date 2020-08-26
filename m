Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859CA2538CF
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 22:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgHZUGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 16:06:02 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8655 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgHZUFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 16:05:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f46c0510001>; Wed, 26 Aug 2020 13:04:33 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 26 Aug 2020 13:05:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 26 Aug 2020 13:05:36 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Aug
 2020 20:05:32 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 26 Aug 2020 20:05:32 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f46c08b0001>; Wed, 26 Aug 2020 13:05:32 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v5 1/7] sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra210
Date:   Wed, 26 Aug 2020 13:05:08 -0700
Message-ID: <1598472314-30235-2-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598472314-30235-1-git-send-email-skomatineni@nvidia.com>
References: <1598472314-30235-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598472273; bh=wT4t2/nhx1LSbE4eS4U3X4HmPpfUMZEMwHW/3RtHINo=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=ggsjKs3I1kq3YZJXVSIZAt84Qtd/J2z+kva3UV52uhUy+GSuSEZoC0VwLCG697jSO
         GFauS5p1/MPaEXiZ6N5j+gTaL4K7XMQaatQkw+yC4eYTCENwuwQzgr83mw0Q3uzcbU
         +s5x525+yZpypBGwITTNv6/Ql2zl1WAxNNANGKy+2tUQqiHUNyojGF49AM4ojqX29/
         dSHOcqXz4bFahTwZPZr+Fd6ZJDCVN+nDteOxNfTBmsivIj+QAaAugRnmFHFY0KUg5B
         a34p8/Bu66Yeh3lj8U7/yO1Iz2/ilIDmo9mUnkUCbXZIFhzS3HR1VNGX5ymHRPKVGB
         udf/MK2YgMv/A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b5a84ecf025a ("mmc: tegra: Add Tegra210 support")

SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK is set for Tegra210 from the
beginning of Tegra210 support in the driver.

Tegra210 SDMMC hardware by default uses timeout clock (TMCLK)
instead of SDCLK and this quirk should not be set.

So, this patch remove this quirk for Tegra210.

Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
Cc: stable <stable@vger.kernel.org> # 5.4
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 drivers/mmc/host/sdhci-tegra.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 0a3f9d0..2be3511 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -1418,7 +1418,6 @@ static const struct sdhci_ops tegra210_sdhci_ops = {
 
 static const struct sdhci_pltfm_data sdhci_tegra210_pdata = {
 	.quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
-		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
 		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
 		  SDHCI_QUIRK_NO_HISPD_BIT |
 		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
-- 
2.7.4

